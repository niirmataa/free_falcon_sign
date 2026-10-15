import Source3.GsInvNormCallee154
import Source3.SelectedNormGate153

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsBinding154
open C99ArrayReference (State bindValue bindPointer Bind)
open C99CompactState115 (reference)

noncomputable def before := SelectedRawNorm151.after
def destination : C99MemoryReference.ArrayPointer := {SelectedFftBuffer141.base with index := 3072}
def arguments : List C99ArrayReference.Arg :=
  [.pointer "rt3".toList (.literal .u64 0),.pointer "rt1".toList (.literal .u64 0),
    .pointer "rt2".toList (.literal .u64 0),.scalar (.var "logn".toList),.scalar (.literal .i32 1)]
noncomputable def empty : State := ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩
noncomputable def full := bindValue empty "full".toList .uint32 (.int32 1)
noncomputable def dimensions := bindValue full "logn".toList .uint32 (.uint32 10)
noncomputable def withB := bindPointer dimensions "b".toList SelectedFftGInput148.base
noncomputable def withA := bindPointer withB "a".toList SelectedFftBuffer141.base
noncomputable def bound := bindPointer withA "d".toList destination

theorem arrays : before.arrays=(reference SelectedFftFStart138.before).arrays :=
  SelectedRawNorm151.loop_frame.arrays.trans SelectedFftGComplete150.arrays

theorem logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)) := by
  have old : SelectedNormEntry151.before.locals "logn".toList=some (.uint32,some (.uint32 10)) := by
    change SelectedFftGComplete150.after.locals "logn".toList=_
    rw [SelectedFftGComplete150.locals]
    decide +kernel
  exact (FftLocalCells140.outside SelectedRawNorm151.loopAfter "norm".toList "logn".toList SelectedRawNorm151.finalWord (by decide)).trans
    ((SelectedRawNorm151.loop_frame.locals _ (by decide)).trans ((SelectedNormEntry151.frame.locals _ (by decide)).trans old))

theorem a_binding : before.arrays "rt1".toList=some SelectedFftBuffer141.base := by rw [arrays]; decide +kernel
theorem b_binding : before.arrays "rt2".toList=some SelectedFftGInput148.base := by rw [arrays]; decide +kernel
theorem d_binding : before.arrays "rt3".toList=some destination := by rw [arrays]; decide +kernel

theorem a_pointer : C99ArrayReference.Pointer before "rt1".toList (.literal .u64 0) SelectedFftBuffer141.base :=
  C99PointerNat141.source before _ _ SelectedFftBuffer141.base 0 (by decide) (by decide) a_binding (.literal .uint64 0)
theorem b_pointer : C99ArrayReference.Pointer before "rt2".toList (.literal .u64 0) SelectedFftGInput148.base :=
  C99PointerNat141.source before _ _ SelectedFftGInput148.base 0 (by decide) (by decide) b_binding (.literal .uint64 0)
theorem d_pointer : C99ArrayReference.Pointer before "rt3".toList (.literal .u64 0) destination :=
  C99PointerNat141.source before _ _ destination 0 (by decide) (by decide) d_binding (.literal .uint64 0)

theorem binding : Bind before GsInvNormShape154.function.params arguments bound :=
  .pointer "d".toList "rt3".toList (.literal .u64 0) destination _ _ withA d_pointer
    (.pointer "a".toList "rt1".toList (.literal .u64 0) SelectedFftBuffer141.base _ _ withB a_pointer
      (.pointer "b".toList "rt2".toList (.literal .u64 0) SelectedFftGInput148.base _ _ dimensions b_pointer
        (.scalar .uint32 "logn".toList (.var "logn".toList) _ _ full (.uint32 10)
          (.variable "logn".toList .uint32 (.uint32 10) logn)
          (.scalar .uint32 "full".toList (.literal .i32 1) [] [] empty (.int32 1) (.literal .int32 1) .nil))))

end FT1536.Source3.SelectedGsBinding154
