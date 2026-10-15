import Source3.ConversionGPrefix136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSmallGComplete136
open C99CompactState115 (State reference)

def internal : State := GeneratedConversion136G23.after

theorem guard_value : C99ScalarCompute130.evaluate internal.locals SmallintsProgram.condition=some (.i32 0) := by decide +kernel

theorem loop_source : C99ProcedureReference.Exec KeygenSearchFft.program KeygenSmallShape136.loop
    (reference SelectedSmallGStart136.initial) ⟨reference internal,.normal⟩ :=
  C99ProcedureSegments136.finish KeygenSearchFft.program SmallintsProgram.condition KeygenSmallShape136.iteration
    SmallintsProgram.increment 1536 _ _ _ ConversionGPrefix136.through24
    (.loopFalse _ _ _ _ (.int32 0)
      (C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls internal.locals SmallintsProgram.condition (.i32 0) guard_value)
      (by decide +kernel))

theorem body : C99ProcedureReference.Exec KeygenSearchFft.program KeygenSearchLeaves.smallBody
    (reference SelectedSmallGStart136.bound) ⟨reference internal,.normal⟩ := by
  rw [KeygenSmallShape136.body_shape]
  exact .seqNormal _ _ _ _ _ SelectedSmallGStart136.declaration
    (.seqNormal _ _ _ _ _ SelectedSmallGStart136.size
      (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ SelectedSmallGStart136.initialization loop_source)
        (.base _ _ _ (.skip _))))

def after : State := {SelectedSmallGStart136.before with heap := internal.heap}

theorem source : KeygenSearchLeaves.SmallCall (reference SelectedSmallGStart136.before)
    SelectedSmallGStart136.args (reference after) :=
  .run (reference SelectedSmallGStart136.bound) ⟨reference internal,.normal⟩
    SelectedSmallGStart136.binding body .voidEnd

theorem locals_restored : after.locals=SelectedSmallGStart136.before.locals := rfl
theorem arrays_restored : after.arrays=SelectedSmallGStart136.before.arrays := rfl
theorem tables_restored : after.tables=SelectedSmallGStart136.before.tables := rfl

end FT1536.Source3.SelectedSmallGComplete136
