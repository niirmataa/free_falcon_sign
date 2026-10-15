import Source3.ConversionFPrefix136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSmallFComplete136
open C99CompactState115 (State reference)

def internal : State := GeneratedConversion136F23.after

theorem guard_value : C99ScalarCompute130.evaluate internal.locals SmallintsProgram.condition=some (.i32 0) := by decide +kernel

theorem loop_source : C99ProcedureReference.Exec KeygenSearchFft.program KeygenSmallShape136.loop
    (reference SelectedSmallFStart136.initial) ⟨reference internal,.normal⟩ :=
  C99ProcedureSegments136.finish KeygenSearchFft.program SmallintsProgram.condition KeygenSmallShape136.iteration
    SmallintsProgram.increment 1536 _ _ _ ConversionFPrefix136.through24
    (.loopFalse _ _ _ _ (.int32 0)
      (C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls internal.locals SmallintsProgram.condition (.i32 0) guard_value)
      (by decide +kernel))

theorem body : C99ProcedureReference.Exec KeygenSearchFft.program KeygenSearchLeaves.smallBody
    (reference SelectedSmallFStart136.bound) ⟨reference internal,.normal⟩ := by
  rw [KeygenSmallShape136.body_shape]
  exact .seqNormal _ _ _ _ _ SelectedSmallFStart136.declaration
    (.seqNormal _ _ _ _ _ SelectedSmallFStart136.size
      (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ SelectedSmallFStart136.initialization loop_source)
        (.base _ _ _ (.skip _))))

def after : State := {SelectedSmallFStart136.before with heap := internal.heap}

theorem source : KeygenSearchLeaves.SmallCall (reference SelectedSmallFStart136.before)
    SelectedSmallFStart136.args (reference after) :=
  .run (reference SelectedSmallFStart136.bound) ⟨reference internal,.normal⟩
    SelectedSmallFStart136.binding body .voidEnd

theorem locals_restored : after.locals=SelectedSmallFStart136.before.locals := rfl
theorem arrays_restored : after.arrays=SelectedSmallFStart136.before.arrays := rfl
theorem tables_restored : after.tables=SelectedSmallFStart136.before.tables := rfl

end FT1536.Source3.SelectedSmallFComplete136
