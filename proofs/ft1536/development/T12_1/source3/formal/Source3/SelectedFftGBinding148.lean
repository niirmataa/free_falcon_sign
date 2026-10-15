import Source3.SelectedFftGInput148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGBinding148
open C99ArrayReference (State bindValue bindPointer Bind)
open C99CompactState115 (reference)

noncomputable def before := SelectedFftFComplete148.after
noncomputable def empty : State := ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩
noncomputable def full := bindValue empty "full".toList .uint32 (.int32 1)
noncomputable def dimensions := bindValue full "logn".toList .uint32 (.uint32 10)
noncomputable def bound := bindPointer dimensions "a".toList SelectedFftGInput148.base

theorem parameters : GeneratedFft138Syntax.function.params=
    [.pointer "a".toList,.scalar .uint32 "logn".toList,.scalar .uint32 "full".toList] := by rfl

theorem logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)) := by
  change SelectedFftFComplete148.after.locals "logn".toList=_
  rw [SelectedFftFComplete148.locals]
  decide +kernel

theorem pointer : C99ArrayReference.Pointer before "rt2".toList (.literal .u64 0) SelectedFftGInput148.base :=
  C99PointerNat141.source before "rt2".toList (.literal .u64 0) SelectedFftGInput148.base 0
    (by decide) (by decide) SelectedFftGInput148.binding (.literal .uint64 0)

/-- Actual second-call parameter binding from the first call's returned state. -/
theorem binding : Bind before GeneratedFft138Syntax.function.params (FftShape138.args "rt2") bound := by
  rw [parameters]
  exact .pointer "a".toList "rt2".toList (.literal .u64 0) SelectedFftGInput148.base _ _ dimensions pointer
    (.scalar .uint32 "logn".toList (.var "logn".toList) _ _ full (.uint32 10)
      (.variable "logn".toList .uint32 (.uint32 10) logn)
      (.scalar .uint32 "full".toList (.literal .i32 1) [] [] empty (.int32 1) (.literal .int32 1) .nil))

theorem image : C99WordBuffer140.Represents bound.heap SelectedFftGInput148.base SelectedFftGInput148.values := SelectedFftGInput148.represented

theorem array_binding : bound.arrays "a".toList=some SelectedFftGInput148.base := by
  change (if "a".toList="a".toList then some SelectedFftGInput148.base else dimensions.arrays "a".toList)=_
  rw [ite_eq_left (show "a".toList="a".toList from rfl)]

theorem pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment bound.heap := SelectedFftFFrame148.pinned

end FT1536.Source3.SelectedFftGBinding148
