import Source3.KeygenInputBytes124
import Source3.KeygenSamplerContext121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRngOps124
open C99MemoryReference
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open KeygenSearchContext (Context)
open KeygenReadyFast (Flag field)
open KeygenSamplerContext121 (Guard guard_sound)
open KeygenRngReference (Exec)

def evaluate (state : State) (expr : CLogic.Expr) : Option B20.C.Val :=
  C99CompactScalar115.evaluate noCalls state.locals expr

theorem evaluate_sound (state : State) (expr : CLogic.Expr) (value : B20.C.Val)
    (computed : evaluate state expr=some value) :
    C99ArrayReference.scalar (reference state) expr (C99ValueBridge.value value) :=
  C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls
    (C99CompactPointer115.noCalls_sound _) state.locals expr value computed

def init (ctx : Context) (fuel : Nat) (before : State) (expr : CLogic.Expr) : Option State := do
  if Guard ctx before then
    let value ← evaluate before expr
    ShakeSeedInvoke118.init (KeygenSamplerContext.rng ctx) fuel before value
  else none

theorem init_sound (ctx : Context) (fuel : Nat) (before after : State) (expr : CLogic.Expr)
    (computed : init ctx fuel before expr=some after) :
    Exec ctx (.init expr) (reference before) [] ⟨reference after,.normal⟩ := by
  unfold init at computed
  split at computed
  next checked =>
    obtain ⟨value,evaluated,body⟩ := Option.bind_eq_some_iff.mp computed
    exact .init _ _ expr (C99ValueBridge.value value) (guard_sound ctx before checked)
      (evaluate_sound before expr value evaluated)
      (ShakeSeedInvoke118.init_sound _ fuel before after value body)
  next rejected => cases computed

def inject (ctx : Context) (fuel : Nat) (before : State) (name : C99ArrayReference.Name)
    (expr : CLogic.Expr) : Option State := do
  if Guard ctx before then
    let pointer ← C99CompactPointer115.pointer noCalls before name (KeygenRngProgram.num 0)
    let value ← evaluate before expr
    ShakeSeedInvoke118.inject (KeygenSamplerContext.rng ctx) fuel before pointer value
  else none

theorem inject_sound (ctx : Context) (fuel : Nat) (before after : State) (name : C99ArrayReference.Name)
    (expr : CLogic.Expr) (computed : inject ctx fuel before name expr=some after) :
    Exec ctx (.inject name expr) (reference before) [] ⟨reference after,.normal⟩ := by
  unfold inject at computed
  split at computed
  next checked =>
    obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
    obtain ⟨value,evaluated,body⟩ := Option.bind_eq_some_iff.mp rest
    exact .inject _ _ name expr pointer (C99ValueBridge.value value) (guard_sound ctx before checked)
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before name _ pointer address)
      (evaluate_sound before expr value evaluated)
      (ShakeSeedInvoke118.inject_sound _ fuel before after pointer value body)
  next rejected => cases computed

def flip (ctx : Context) (fuel : Nat) (before : State) : Option State :=
  if Guard ctx before then ShakeSeedInvoke118.flip (KeygenSamplerContext.rng ctx) fuel before else none

theorem flip_sound (ctx : Context) (fuel : Nat) (before after : State)
    (computed : flip ctx fuel before=some after) :
    Exec ctx .flip (reference before) [] ⟨reference after,.normal⟩ := by
  unfold flip at computed
  split at computed
  next checked => exact .flip _ _ (guard_sound ctx before checked) (ShakeSeedInvoke118.flip_sound _ fuel before after computed)
  next rejected => cases computed

def WriteGuard (ctx : Context) (before : State) (flag : Flag) : Prop :=
  C99NameMap115.lookup before.arrays "fk".toList=some ctx.object ∧
  Allocated (C99FiniteMemory114.memory before.heap) (field ctx flag) ∧
  (C99FiniteMemory114.memory before.heap).writable (field ctx flag).block=true

instance writeGuardDecidable (ctx : Context) (before : State) (flag : Flag) : Decidable (WriteGuard ctx before flag) := by
  unfold WriteGuard
  infer_instance

def store (ctx : Context) (before : State) (flag : Flag) (expr : CLogic.Expr) : Option State := do
  let value ← evaluate before expr
  if WriteGuard ctx before flag then
    pure {before with heap := C99FiniteWrite114.write32 before.heap (field ctx flag) (BitVec.ofInt 32 value.integer)}
  else none

theorem store_sound (ctx : Context) (before after : State) (flag : Flag) (expr : CLogic.Expr)
    (computed : store ctx before flag expr=some after) :
    Exec ctx (.storeFlag flag expr) (reference before) [] ⟨reference after,.normal⟩ := by
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
  split at rest
  next checked =>
    have same := Option.some.inj rest
    subst after
    rw [C99CompactState115.reference_heap]
    refine .storeFlag _ flag expr (C99ValueBridge.value value) _ checked.1
      (evaluate_sound before expr value evaluated) ?_
    simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using
      C99FiniteWrite114.write32_sound before.heap (field ctx flag) (BitVec.ofInt 32 value.integer)
        checked.2.1 rfl checked.2.2
  next rejected => cases rest

def ReadGuard (ctx : Context) (before : State) : Prop :=
  C99NameMap115.lookup before.arrays "fk".toList=some ctx.object ∧
  KeygenSearchContext.ObjectLegal (C99FiniteMemory114.memory before.heap) ctx

instance readGuardDecidable (ctx : Context) (before : State) : Decidable (ReadGuard ctx before) := by
  unfold ReadGuard KeygenSearchContext.ObjectLegal
  infer_instance

def flagExpression (negated : Bool) : CLogic.Expr :=
  if negated then .lnot (.var "$member".toList) else .var "$member".toList

def test (ctx : Context) (before : State) (flag : Flag) (negated : Bool) : Option B20.C.Val := do
  if ReadGuard ctx before then
    let word ← C99FiniteRead114.read32 before.heap (field ctx flag)
    C99CompactScalar115.evaluate noCalls (C99NameMap115.put before.locals "$member".toList (.i32 (some word)))
      (flagExpression negated)
  else none

theorem test_sound (ctx : Context) (before : State) (flag : Flag) (negated : Bool) (value : B20.C.Val)
    (computed : test ctx before flag negated=some value) :
    KeygenRngReference.FlagTest ctx (reference before) flag negated (C99ValueBridge.value value) := by
  unfold test at computed
  split at computed
  next checked =>
    obtain ⟨word,read,evaluated⟩ := Option.bind_eq_some_iff.mp computed
    refine .load word (C99ValueBridge.value value)
      (.load word checked.1 checked.2 (C99FiniteRead114.read32_sound before.heap _ word read)) ?_
    have source := C99CompactScalar115.evaluate_sound (fun _ _ _ => False) noCalls
      (C99CompactPointer115.noCalls_sound _) (C99NameMap115.put before.locals "$member".toList (.i32 (some word)))
      (flagExpression negated) value evaluated
    rw [C99CompactCells115.environment_put] at source
    cases negated <;> exact source
  next rejected => cases computed

end FT1536.Source3.KeygenRngOps124
