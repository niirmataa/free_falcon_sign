import Source3.StepFirstImage196

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FirstStepReturn196
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open SelectedStepLayout187 (fd gd)

/-- The caller return frame writes only the heap. -/
noncomputable def returned (callee : State) : State := {FirstStepEntry187.caller with heap:=callee.heap}
def advance (s : State) : State := ModularAtoms178.set s "d" 2

theorem increment_source (s : State) (dCell : Slot s "d" 1) :
    Exec FirstStepEntry187.increment s ⟨advance s,.normal⟩ := by
  have sum : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (.arithmetic .plus (.variable "d".toList) (.literal .int32 1)) (.uint32 2) :=
    .arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
      (.step .plus (.uint32 1) (.int32 1) .uint32 rfl (.uint32 1) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "d".toList .add (FirstStepEntry187.num 1))) s (advance s) :=
    .scalar s _ _ (.assign s.locals "d".toList _ .uint32 (some (.uint32 1)) (.uint32 2) dCell sum)
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem d_two (s : State) : Slot (advance s) "d" 2 := ModularAtoms178.slot s "d" 2

theorem next_guard (s : State) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar (advance s) FirstStepEntry187.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (d_two s))
    (.variable _ _ _ ((ModularAtoms178.outside s "d" "depth" 2 (by decide)).trans depth))
    (.step .lt (.uint32 2) (.uint32 10) .uint32 rfl (.uint32 2) (.uint32 10) rfl rfl)

/-- Full first step, enclosing d-loop body, increment, and both 512-word arrays. -/
theorem source : ∃ (callee : State) (gvs : Fin 512 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (.step FirstStepEntry187.arguments) FirstStepEntry187.caller ⟨returned callee,.normal⟩ ∧
    Exec FirstStepEntry187.body FirstStepEntry187.caller ⟨returned callee,.normal⟩ ∧
    Exec FirstStepEntry187.increment (returned callee) ⟨advance (returned callee),.normal⟩ ∧
    C99ArrayReference.scalar (advance (returned callee)) FirstStepEntry187.condition (.int32 1) ∧
    Slot (advance (returned callee)) "d" 2 ∧
    StepNttImage195.Image (advance (returned callee)) fd (StepFirstImage196.fdWords gvs) ∧
    StepNttImage195.Image (advance (returned callee)) gd (StepFirstImage196.gdWords gvs) ∧
    (advance (returned callee)).arrays=FirstStepEntry187.caller.arrays ∧
    (∀ name : String, name.toList≠"d".toList →
      (advance (returned callee)).locals name.toList=FirstStepEntry187.caller.locals name.toList) := by
  obtain ⟨callee,gvs,run,fdImage,gdImage⟩ := StepFirstImage196.source
  have call : Exec (.step FirstStepEntry187.arguments) FirstStepEntry187.caller ⟨returned callee,.normal⟩ :=
    FirstStepEntry187.source_step _ run .voidEnd
  have body : Exec FirstStepEntry187.body FirstStepEntry187.caller ⟨returned callee,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ FirstStepEntry187.caller (returned callee) _ call
      (SelectedStepAddPrime195.skip_run _))
  have dCell : Slot (returned callee) "d" 1 := by rfl
  have depth : Slot (returned callee) "depth" 10 := SelectedTopContinuation186.depth_cell
  exact ⟨callee,gvs,run,call,body,increment_source _ dCell,next_guard _ depth,d_two _,
    fdImage,gdImage,rfl,fun name different => ModularAtoms178.outside _ "d" name 2 different⟩

/-- The remaining d-loop at d=2 can be consumed without replaying the first step. -/
theorem continue_loop {callee : State}
    (body : Exec FirstStepEntry187.body FirstStepEntry187.caller ⟨returned callee,.normal⟩)
    (increment : Exec FirstStepEntry187.increment (returned callee) ⟨advance (returned callee),.normal⟩)
    (out : C99ProcedureReference.Result)
    (rest : Exec FirstStepEntry187.loop (advance (returned callee)) out) :
    Exec FirstStepEntry187.loop FirstStepEntry187.caller out :=
  .loopNormal _ _ _ FirstStepEntry187.caller (returned callee) (advance (returned callee)) out
    (.int32 1) FirstStepEntry187.guard (by decide) body increment rest

end FT1536.Source3.FirstStepReturn196
