import Source3.CertificateScan

namespace FT1536.Source3.CertificateReturn
open B20.C CertificateMemory CertificateEffects StableBinaryByteView

def expression : CLogic.Expr := .cmp .eq (.var "bad".toList) (.literal .i32 0)
def locals (bad : BitVec 32) : B20.C.Scalar.State :=
  ⟨fun n => if n="bad".toList then some .u32 else none,
   fun n => if n="bad".toList then some (.u32 bad) else none⟩
def env (bad : BitVec 32) : C99ScalarReference.Env :=
  fun n => if n="bad".toList then some (.uint32,some (.uint32 bad)) else none
def run (l : Layout) (s : State) : Option Bool := (flagRead s.heap l.bad).map (fun bad => decide (bad=0))
def Exec (l : Layout) (s : RState) (result : Bool) : Prop := ∃ bad,
  C99MemoryReference.Load32 s.heap (badPtr l) bad ∧
  C99ScalarReference.Exec C99Frontend.noCalls (env bad) (C99Frontend.scalar LeafCertificateSuffix.returnProgram)
    (.returned (C99ScalarReference.boolean result))

theorem locals_good (bad : BitVec 32) : C99Typing.WellTyped (locals bad) := by
  intro n v hv
  by_cases hn : n="bad".toList <;> simp_all [locals,Val.ty]
  rw [← hv]
theorem env_bound (bad : BitVec 32) : C99Typing.environment (locals bad)=env bad := by
  funext n
  by_cases hn : n="bad".toList <;>
    simp_all [C99Typing.environment,locals,env,C99ValueBridge.type,C99ValueBridge.value]
theorem model_expression (bad : BitVec 32) : ExpressionFuel.unbounded (fun _ _ => none) (locals bad).values expression=
    some (CLogic.boolean (decide (bad=0))) := by
  have h:=LeafCertificateSuffix.return_bit bad
  change CLogic.eval (fun _ _ => none) (locals bad).values 32 expression=some (CLogic.boolean (decide (bad=0))) at h
  rw [ExpressionFuel.fuel_adequate _ _ _ _ (by decide : ExpressionFuel.depth expression≤32)] at h
  exact h

theorem complete (l : Layout) (s : RState) (result : Bool) (h : Exec l s result) : run l (encode s)=some result := by
  obtain ⟨bad,hr,he⟩:=h
  obtain ⟨v,hv,hret⟩:=C99ControlInversion.return_inv _ _ _ _ he
  have hrval : C99ScalarReference.boolean result=v := C99ScalarReference.Result.returned.inj hret
  rw [← hrval,← env_bound] at hv
  have hm:=(C99ExpressionBridge.expression_complete C99HeaderProof.noSignature _ _ C99HeaderProof.no_calls_ok
    (locals bad) (locals_good bad) expression .i32 (C99ScalarReference.boolean result) (by rfl) hv).1
  have hm0:=model_expression bad
  have hb:=congrArg CLogic.truth (Option.some.inj (hm.symm.trans hm0))
  change CLogic.truth (CLogic.boolean result)=CLogic.truth (CLogic.boolean (decide (bad=0))) at hb
  rw [CLogic.truth_boolean,CLogic.truth_boolean] at hb
  have hread : flagRead (encode s).heap l.bad=some bad := C99MemoryAccess.load32_to_model _ _ _ rfl hr
  simp [run,hread,hb]

theorem exists_execution (l : Layout) (hl : WellFormed l) (s : State) (legal : Legal l s.heap) :
    ∃ result, Exec l (decode s) result ∧ run l s=some result := by
  obtain ⟨bad,hr⟩:=Option.isSome_iff_exists.mp legal.badReadable
  have hload : C99MemoryReference.Load32 (decode s).heap (badPtr l) bad := by
    apply (C99MemoryAccess.load32_iff _ _ _ rfl (bad_allocated l s.heap hl legal) rfl).mpr
    exact hr
  have he:=C99ExpressionSound.expression_sound _ _ C99HeaderSound.no_calls_sound (locals bad)
    (locals_good bad) expression (CLogic.boolean (decide (bad=0))) (model_expression bad)
  rw [env_bound] at he
  have hret : C99ScalarReference.Exec C99Frontend.noCalls (env bad) (C99Frontend.scalar LeafCertificateSuffix.returnProgram)
      (.returned (C99ScalarReference.boolean (decide (bad=0)))) := C99ScalarReference.Exec.ret _ _ _ he
  exact ⟨decide (bad=0),⟨bad,hload,hret⟩,by simp [run,hr]⟩

theorem true_iff (l : Layout) (s : State) : run l s=some true ↔ flagRead s.heap l.bad=some 0 := by
  simp [run,Option.map_eq_some_iff]

end FT1536.Source3.CertificateReturn

#print axioms FT1536.Source3.CertificateReturn.complete
#print axioms FT1536.Source3.CertificateReturn.exists_execution
