import B20.Fpr.Domain
import B20.Fpr.RintExec
import B20.Word.LERefinement

namespace V02

/-- Reviewer countertest: the conditional sub premise cannot be produced by
    the present shift-only dispatcher, for any of its BitVec arguments. -/
theorem no_add_dispatch (x y w : BitVec 64) :
    ¬ B20.Fpr.AddCallObligation x y w := by
  intro h
  have hval := h.eval
  have hn : B20.C.Scalar.shiftCalls "fpr_add".toList
      [.u64 x, .u64 y] = none := rfl
  rw [hn] at hval
  cases hval

/-- This exception has a legal rint input but is explicitly outside floor. -/
theorem negative_zero_in_rint :
    B20.Fpr.rintDomain (0x8000000000000000 : BitVec 64) := by
  unfold B20.Fpr.rintDomain
  decide

theorem negative_zero_outside_floor :
    ¬ B20.Fpr.floorDomain (0x8000000000000000 : BitVec 64) := by
  simp [B20.Fpr.floorDomain]

theorem pack_large_e_rejected :
    ¬ B20.Fpr.packDomain 0#32 2147483647#32 := by
  unfold B20.Fpr.packDomain
  decide

#check @B20.Word.load_store_le_refines
#check @B20.Fpr.rint_execution
#check @B20.Fpr.floor_execution
#check @B20.Fpr.sub_refines_via_add_obligation
#print axioms B20.Word.load_store_le_refines
#print axioms B20.Fpr.rint_execution
#print axioms B20.Fpr.floor_execution
#print axioms B20.Fpr.sub_refines_via_add_obligation
#print axioms V02.no_add_dispatch
#print axioms V02.negative_zero_in_rint

end V02
