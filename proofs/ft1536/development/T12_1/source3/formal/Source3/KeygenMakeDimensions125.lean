import Source3.KeygenMakeFresh125

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakeDimensions125
open C99CompactState115 (State reference bindValue)
open KeygenSearchContext (Context)

def counted (s : State) : State := bindValue s "local_attempts".toList .u64 (.i32 0)

theorem reference_counted (s : State) : reference (counted s)=KeygenMakePrologue.counted (reference s) := by
  unfold counted
  rw [C99CompactState115.reference_bindValue]
  rfl

theorem count_source (s : State) (blocks : Fin 6 → Nat) :
    C99ProcedureReference.Exec (fun _ => none) KeygenMakePrologue.countCode
      (reference (KeygenMakeDeclare125.declared s blocks))
      ⟨reference (counted (KeygenMakeDeclare125.declared s blocks)),.normal⟩ := by
  rw [reference_counted,KeygenMakeDeclare125.reference_declared]
  exact .base _ _ _ (.assign _ "local_attempts".toList (.scalar (.literal .i32 0)) .uint64 none (.int32 0)
    (KeygenMakePrologue.count_declared (reference s) blocks) (.scalar _ _ (.literal .int32 0)))

def logged (s : State) (word : BitVec 32) : State := bindValue s "logn".toList .u32 (.u32 word)
def ternary (s : State) (logn ter : BitVec 32) : State := bindValue (logged s logn) "ter".toList .u32 (.u32 ter)

theorem reference_logged (s : State) (word : BitVec 32) :
    reference (logged s word)=KeygenMakePrologue.logged (reference s) word := by
  unfold logged
  rw [C99CompactState115.reference_bindValue]
  rfl

theorem reference_ternary (s : State) (logn ter : BitVec 32) :
    reference (ternary s logn ter)=KeygenMakePrologue.ternary (reference s) logn ter := by
  unfold ternary
  rw [C99CompactState115.reference_bindValue,reference_logged]
  rfl

def run (ctx : Context) (before : State) : Option State := do
  if KeygenRngOps124.ReadGuard ctx before then
    let logn ← C99FiniteRead114.read32 before.heap (KeygenSearchContext.field ctx 0 4)
    let ter ← C99FiniteRead114.read32 (logged before logn).heap (KeygenSearchContext.field ctx 4 4)
    let size ← KeygenRngOps124.evaluate (ternary before logn ter) KeygenCallerInit.sizeExpr
    pure (bindValue (ternary before logn ter) "n".toList .u64 size)
  else none

theorem run_sound (ctx : Context) (before after : State) (computed : run ctx before=some after) :
    KeygenMakePrologue.Dimensions ctx (reference before) (reference after) := by
  unfold run at computed
  split at computed
  next checked =>
    obtain ⟨logn,first,rest⟩ := Option.bind_eq_some_iff.mp computed
    obtain ⟨ter,second,rest⟩ := Option.bind_eq_some_iff.mp rest
    obtain ⟨size,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_bindValue,reference_ternary]
    refine .run logn ter (C99ValueBridge.value size)
      (.read logn checked.1 checked.2 (C99FiniteRead114.read32_sound before.heap _ logn first)) ?_ ?_
    · have loaded := C99FiniteRead114.read32_sound (logged before logn).heap _ ter second
      exact .read ter checked.1 checked.2 loaded
    · have source := KeygenRngOps124.evaluate_sound (ternary before logn ter) KeygenCallerInit.sizeExpr size evaluated
      rw [reference_ternary] at source
      exact source
  next rejected => cases computed

end FT1536.Source3.KeygenMakeDimensions125
