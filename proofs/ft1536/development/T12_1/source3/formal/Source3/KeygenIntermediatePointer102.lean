import Source3.KeygenPolyNtt101

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediatePointer102
open C99ArrayReference (State)
open C99MemoryReference
open KeygenSearchContext (Context)
open KeygenIntermediateMemory

theorem rounding_checked : C99ModularArity096.checkedCode rounding = true := by decide

theorem align (before : State) (base data a b : ArrayPointer)
    (first : Align32 before base data a) (second : Align32 before base data b) : a = b := by
  have rounded := C99ModularArity096.execution_unique rounding
  cases first
  cases second
  have naturalUnique : ∀ x y : BitVec 64, (x.toNat : Int) = (y.toNat : Int) → x = y := by
    intro x y equal
    apply BitVec.eq_of_toNat_eq
    omega
  grind only [KeygenSearchPointer100.cast, rounding_checked,
    C99ScalarCallsDeterminism089.array_scalar, C99HeapDeterminism089.pointer_add]

theorem pointer (ctx : Context) (before : State) (e : Expr) (a b : ArrayPointer)
    (first : Eval ctx before e a) (second : Eval ctx before e b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [KeygenSearchPointer100.tmp, KeygenSearchPointer100.cast,
    KeygenSearchPointer100.align, align, C99ScalarCallsDeterminism089.array_scalar,
    C99HeapDeterminism089.pointer_add]

theorem compare (p q : ArrayPointer) (a b : Bool)
    (first : CompareLt p q a) (second : CompareLt p q b) : a = b :=
  first.2.2.2.2.2.2.trans second.2.2.2.2.2.2.symm

end FT1536.Source3.KeygenIntermediatePointer102
