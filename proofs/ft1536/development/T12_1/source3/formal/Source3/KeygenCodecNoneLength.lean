import Source3.KeygenCodecExecution

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- First scalar step of B1.08: the length expression at the exact bound
   NONE else assignment evaluates to3072 at the derived logn10. This is
   not yet the complete return/loop/capacity theorem. No encoded length
   or successful codec result is assumed. -/
namespace FT1536.Source3.KeygenCodecNoneLength
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

theorem number_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (ty : Ty) (n : Nat) (value : C99IntegerReference.Value) (before after : Locals) (result : Value)
    (computed : castInteger ty (.int64 (BitVec.ofNat 64 n))=some value)
    (evaluated : Eval args heap buf (.number ty n) before result after) :
    result=.integer value ∧ after=before := by
  cases evaluated with
  | number ty n v l converted =>
    have same : v=value := Option.some.inj (converted.symm.trans computed)
    subst v
    exact ⟨rfl,rfl⟩

theorem size_three_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (before after : Locals) (result : Value)
    (evaluated : Eval args heap buf (.cast .size (.number .i32 3)) before result after) :
    result=.integer (.uint64 3) ∧ after=before := by
  cases evaluated with
  | cast ty e before after v z inner converted =>
    obtain ⟨same,locals⟩ := number_eval args heap buf .i32 3 (.int32 3) before after (.integer v) (by decide +kernel) inner
    have integer : v=.int32 3 := Value.integer.inj same
    subst v
    have value : z=.uint64 3 := Option.some.inj (converted.symm.trans (by decide +kernel))
    subst z
    exact ⟨rfl,locals⟩

theorem logn_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (before after : Locals) (result : Value)
    (cell : before.scalars "logn".toList=some (.uint32,some (.uint32 10)))
    (evaluated : Eval args heap buf (.variable "logn".toList) before result after) :
    result=.integer (.uint32 10) ∧ after=before := by
  cases evaluated; simp_all

def rhs : Expr := .binary .shl (.cast .size (.number .i32 3)) (.variable "logn".toList)
theorem assignment_source : KeygenCodecNoneBinding.node006=.write (.variable "len".toList) .set rhs := rfl

theorem rhs_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (before after : Locals) (result : Value)
    (cell : before.scalars "logn".toList=some (.uint32,some (.uint32 10)))
    (evaluated : Eval args heap buf rhs before result after) :
    result=.integer (.uint64 3072) ∧ after=before := by
  cases evaluated with
  | binary op a b before m after x y z first second operation =>
    obtain ⟨hx,hm⟩ := size_three_eval args heap buf before m x first
    subst x
    subst m
    obtain ⟨hy,ht⟩ := logn_eval args heap buf before after y cell second
    subst y
    cases operation with
    | shl x y z shifted =>
      have canonical : C99IntegerReference.ShiftExec .left (.uint64 3) (.uint32 10) (.uint64 3072) :=
        .unsignedLeft (.uint64 3) (.uint32 10) 10 (by decide +kernel) rfl (by decide +kernel)
      have equal := C99IntegerReference.shift_deterministic .left (.uint64 3) (.uint32 10) z (.uint64 3072) shifted canonical
      subst z
      exact ⟨rfl,ht⟩

end FT1536.Source3.KeygenCodecNoneLength
