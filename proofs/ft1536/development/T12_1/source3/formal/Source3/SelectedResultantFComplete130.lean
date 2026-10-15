import Source3.PackingFComplete130
import Source3.KeygenResultantCall093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedResultantFComplete130
open C99CompactState115 (State reference)
open SelectedPackingF130 (before args block bound ready zeroed)

def packed := PackingFComplete130.after

theorem profile : C99ArrayReference.scalar (reference packed) (.var "logn".toList) (.uint32 10) :=
  KeygenResultantRun130.profile_sound packed 10 (by decide +kernel)

def reductionResult := KeygenWordEndpoints130.normal 256 (GeneratedResultantSyntax130.reduction 10) packed
theorem reduction_defined : reductionResult.isSome=true := by decide +kernel
def reduced : State := reductionResult.get reduction_defined

theorem reduction_computed : KeygenWordEndpoints130.normal 256 (KeygenResultantSource.switchCode 10) packed=some reduced := by
  rw [GeneratedResultantSyntax130.reduction_eq]
  exact SelectedInput124.option_get reductionResult reduction_defined

theorem reduction_source : KeygenWordExec.Exec (KeygenResultantSource.switchCode 10)
    (reference packed) ⟨reference reduced,.normal⟩ :=
  KeygenWordEndpoints130.normal_sound 256 _ packed reduced reduction_computed

def tailResult := KeygenWordEndpoints130.returned 32 GeneratedResultantSyntax130.ending reduced
theorem returned_one : tailResult.map Prod.snd=some (.i32 1) := by decide +kernel

theorem tail_defined : tailResult.isSome=true := by
  have checked := returned_one
  cases found : tailResult with
  | none => simp [found] at checked
  | some output => rfl

def output : State×B20.C.Val := tailResult.get tail_defined

theorem tail_computed : KeygenWordEndpoints130.returned 32 GeneratedResultantSyntax130.ending reduced=some output :=
  SelectedInput124.option_get tailResult tail_defined

theorem value_one : output.2=.i32 1 := by
  have checked := returned_one
  change (KeygenWordEndpoints130.returned 32 GeneratedResultantSyntax130.ending reduced).map Prod.snd=some (.i32 1) at checked
  rw [tail_computed] at checked
  exact Option.some.inj checked

theorem tail_source : KeygenWordExec.Exec KeygenResultantSource.tailCode (reference reduced)
    ⟨reference output.1,.returned (some (.int32 1))⟩ := by
  have source := KeygenWordEndpoints130.returned_sound 32 GeneratedResultantSyntax130.ending reduced output.1 output.2 tail_computed
  rw [value_one,← GeneratedResultantSyntax130.ending_eq] at source
  exact source

def after : State := {before with heap := C99FiniteAllocation115.restore before.heap output.1.heap block}

theorem source_raw : KeygenResultantSource.Call (reference before) args (reference after) (.uint32 1) := by
  unfold after
  rw [C99CompactState115.reference_heap before (C99FiniteAllocation115.restore before.heap output.1.heap block),
    C99FiniteAllocation115.restore_source]
  refine KeygenResultantSource.Call.run (reference bound) (reference ready) (reference packed) (reference reduced)
    ⟨reference output.1,.returned (some (.int32 1))⟩ block 10 (.uint32 1)
    SelectedPackingF130.binding SelectedPackingF130.fresh SelectedPackingF130.setup_source
    (KeygenResultantInit130.zero_legal ready block SelectedPackingF130.zero_guard) ?_ profile reduction_source tail_source ?_
  · have source := PackingFComplete130.source
    change KeygenWordExec.Exec KeygenResultantSource.packing
      (reference (KeygenResultantInit130.zeroed ready block)) _ at source
    rw [KeygenResultantInit130.zero_source ready block SelectedPackingF130.zero_guard] at source
    exact source
  · exact .value .uint32 (.int32 1)

theorem unchanged : reference after=reference before := KeygenResultantCall093.call_state _ _ args _ source_raw

theorem source : KeygenResultantSource.Call (reference before) args (reference before) (.uint32 1) := by
  have checked := source_raw
  rw [unchanged] at checked
  exact checked

end FT1536.Source3.SelectedResultantFComplete130
