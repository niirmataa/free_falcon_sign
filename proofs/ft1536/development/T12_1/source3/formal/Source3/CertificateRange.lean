import Source3.CertificateReverse

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateRange
open B20.C C99Typing C99ValueBridge

def types : Types := fun n => if n="bits".toList ∨ n=LeafRange.lowerName ∨ n=LeafRange.upperName then some .u64
  else if n="valid".toList ∨ n="bad".toList then some .u32 else none
def initial (w : BitVec 64) (bad : BitVec 32) : B20.C.Scalar.State := ⟨types,(LeafRange.initial w bad).values⟩
def flags (w : BitVec 64) (bad : BitVec 32) : BitVec 32 := bad ||| (Run2.KeygenLeafGate.rangeValid w ^^^ 1)
def finalState (w : BitVec 64) (bad : BitVec 32) : B20.C.Scalar.State :=
  ⟨types,update (update (initial w bad).values "valid".toList (.u32 (Run2.KeygenLeafGate.rangeValid w))) "bad".toList (.u32 (flags w bad))⟩
def initialEnv (w : BitVec 64) (bad : BitVec 32) : C99ScalarReference.Env := fun n =>
  if n="bits".toList then some (.uint64,some (.uint64 w))
  else if n="bad".toList then some (.uint32,some (.uint32 bad))
  else if n="valid".toList then some (.uint32,none)
  else if n=LeafRange.lowerName then some (.uint64,some (.uint64 Run2.KeygenLeafGate.lowerBits))
  else if n=LeafRange.upperName then some (.uint64,some (.uint64 Run2.KeygenLeafGate.upperBits)) else none

theorem initial_good (w : BitVec 64) (bad : BitVec 32) : WellTyped (initial w bad) := by
  intro n v hv
  by_cases hb : n="bits".toList <;> by_cases hd : n="bad".toList <;>
    by_cases hvv : n="valid".toList <;> by_cases hlo : n=LeafRange.lowerName <;> by_cases hhi : n=LeafRange.upperName <;>
      simp_all [initial,types,LeafRange.initial,LeafRange.macros,LeafRange.lowerName,LeafRange.upperName,Val.ty]
  all_goals rw [← hv]
theorem environment_bound (w : BitVec 64) (bad : BitVec 32) : environment (initial w bad)=initialEnv w bad := by
  funext n
  by_cases hb : n="bits".toList <;> by_cases hd : n="bad".toList <;>
    by_cases hvv : n="valid".toList <;> by_cases hlo : n=LeafRange.lowerName <;> by_cases hhi : n=LeafRange.upperName <;>
      simp_all [environment,initial,types,initialEnv,LeafRange.initial,LeafRange.macros,
        LeafRange.lowerName,LeafRange.upperName,C99ValueBridge.type,C99ValueBridge.value]
theorem checked : C99StateBridge.checkBody C99HeaderProof.noSignature types LeafRange.tail=some types := by rfl

theorem model_tail (w : BitVec 64) (bad : BitVec 32) :
    UnsignedState.exec (fun _ _ => none) (initial w bad) LeafRange.tail=some (finalState w bad) := by
  simp [UnsignedState.exec,LeafRange.tail,initial,finalState,types,LeafRange.initial,LeafRange.macros,
    LeafRange.lowerName,LeafRange.upperName,CLogic.step,CLogic.eval,B20.C.Scalar.assign,update,
    B20.C.bin,B20.C.shift,commonTy,Val.ty,B20.C.cast,literalValue,bitsOp,flags,Run2.KeygenLeafGate.rangeValid]
  funext n
  by_cases hv : n=['v','a','l','i','d'] <;> by_cases hb : n=['b','a','d'] <;> simp [update,hv,hb]

def ScalarExec (w : BitVec 64) (bad final : BitVec 32) : Prop := ∃ env,
  C99ScalarReference.Exec C99Frontend.noCalls (initialEnv w bad) (C99Frontend.scalars LeafRange.tail) (.normal env) ∧
  env "bad".toList=some (.uint32,some (.uint32 final))

theorem scalar_exact (w : BitVec 64) (bad final : BitVec 32) (h : ScalarExec w bad final) : final=flags w bad := by
  obtain ⟨env,he,hread⟩:=h
  rw [← environment_bound] at he
  obtain ⟨out,hm,hout,_,_⟩:=C99NormalBodyBridge.normal_complete C99HeaderProof.noSignature _ _
    C99HeaderProof.no_calls_ok LeafRange.tail (initial w bad) types env (initial_good w bad) checked he
  have heq : out=finalState w bad := Option.some.inj (hm.symm.trans (model_tail w bad))
  rw [← hout,heq] at hread
  simpa [environment,finalState,types,update,C99ValueBridge.type,C99ValueBridge.value,
    LeafRange.lowerName,LeafRange.upperName] using hread.symm

theorem scalar_exists (w : BitVec 64) (bad : BitVec 32) : ScalarExec w bad (flags w bad) := by
  obtain ⟨hr,_,_⟩:=C99BodySound.normal_sound C99HeaderProof.noSignature _ _ C99HeaderSound.no_calls_sound
    LeafRange.tail (initial w bad) (finalState w bad) types (initial_good w bad) checked (model_tail w bad)
  rw [environment_bound] at hr
  exact ⟨_,hr,by simp [environment,finalState,types,update,C99ValueBridge.type,C99ValueBridge.value,
    LeafRange.lowerName,LeafRange.upperName]⟩

def Exec (l : CertificateMemory.Layout) (s : CertificateEffects.RState) (bits : BitVec 64) (out : CertificateEffects.RState) : Prop :=
  ∃ old new, C99MemoryReference.Load32 s.heap (CertificateMemory.badPtr l) old ∧ ScalarExec bits old new ∧
    C99MemoryReference.Store32 s.heap (CertificateMemory.badPtr l) new out.heap ∧
    out.trace=CertificateEffects.Event.upper bits::CertificateEffects.Event.lower bits::s.trace

def run (l : CertificateMemory.Layout) (s : CertificateEffects.State) (bits : BitVec 64) : Option CertificateEffects.State := do
  let old ← StableBinaryByteView.flagRead s.heap l.bad
  let (_,new) ← LeafRange.runTail (fun _ _ => none) LeafRange.tail bits old
  let heap ← StableBinaryByteView.flagWrite s.heap l.bad new
  pure ⟨heap,CertificateEffects.Event.upper bits::CertificateEffects.Event.lower bits::s.trace⟩

theorem run_formula (l : CertificateMemory.Layout) (s : CertificateEffects.State) (bits : BitVec 64) :
    run l s bits=(StableBinaryByteView.flagRead s.heap l.bad).bind
      (fun old => (StableBinaryByteView.flagWrite s.heap l.bad (flags bits old)).map
        (fun heap => ⟨heap,CertificateEffects.Event.upper bits::CertificateEffects.Event.lower bits::s.trace⟩)) := by
  unfold run
  simp only [LeafRange.execute_tail]
  cases StableBinaryByteView.flagRead s.heap l.bad with
  | none => rfl
  | some old =>
      change (StableBinaryByteView.flagWrite s.heap l.bad (flags bits old)).bind
        (fun heap => some (⟨heap,CertificateEffects.Event.upper bits::CertificateEffects.Event.lower bits::s.trace⟩ : CertificateEffects.State))=
        (StableBinaryByteView.flagWrite s.heap l.bad (flags bits old)).map _
      cases StableBinaryByteView.flagWrite s.heap l.bad (flags bits old) <;> rfl

end FT1536.Source3.CertificateRange

#print axioms FT1536.Source3.CertificateRange.scalar_exact
#print axioms FT1536.Source3.CertificateRange.scalar_exists
