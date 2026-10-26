import Source3.SecondStepOneBody204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepExit204
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open SecondStepFirstBody203 (bodyState scope_locals)
open SecondStepOuter204 (counter)

theorem increment (before out : State) (u : Cell out "u".toList 1) :
    Exec StepPrimeShape188.increment (bodyState before out) ⟨counter before out 2,.normal⟩ := by
  have cell : Cell (bodyState before out) "u".toList 1 := (scope_locals before out "u".toList (by decide)).trans u
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (MakeFgTailShape190.num 1))) (bodyState before out) (counter before out 2) := by
    cases C99LoopScalar141.increment (fun _ => none) (bodyState before out) "u".toList 1 (by decide) cell with
    | base _ _ _ source => exact source
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem u_two (before out : State) : Cell (counter before out 2) "u".toList 2 := FftLocalCells140.cell_at _ _ _

theorem guard (before out : State) (slen : Cell out "slen".toList 2) :
    C99ArrayReference.scalar (counter before out 2) StepPrimeShape188.condition (.int32 0) := by
  have kept : Cell (counter before out 2) "slen".toList 2 :=
    (SecondStepOuter204.counter_local before out 2 "slen".toList (by decide) (by decide)).trans slen
  exact .compare .lt _ _ _ _ _ (.variable _ _ _ (u_two before out)) (.variable _ _ _ kept)
    (.step .lt (.uint64 2) (.uint64 2) .uint64 rfl (.uint64 2) (.uint64 2) rfl rfl)

theorem loop_end (before out : State) (slen : Cell out "slen".toList 2) :
    Exec StepPrimeShape188.loop (counter before out 2) ⟨counter before out 2,.normal⟩ :=
  .loopFalse _ _ _ _ (.int32 0) (guard before out slen) rfl

end FT1536.Source3.SecondStepExit204
