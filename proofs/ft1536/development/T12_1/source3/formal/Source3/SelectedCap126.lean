import Source3.KeygenCapCompute126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedCap126
open C99CompactState115 (State reference)

def result := KeygenCapCompute126.run SelectedPrefix125.ready
theorem defined : result.isSome=true := by decide +kernel
def first : State := result.get defined
theorem computed : KeygenCapCompute126.run SelectedPrefix125.ready=some first :=
  SelectedInput124.option_get result defined

theorem source (program : C99ProcedureReference.Program) : C99ProcedureReference.Exec program KeygenAttemptCap.code
    (reference SelectedPrefix125.ready) ⟨reference first,.normal⟩ :=
  KeygenCapCompute126.run_sound program SelectedPrefix125.ready first computed

theorem exact_state : reference first=KeygenCapWords.advanced (reference SelectedPrefix125.ready) 0 := by
  have actual := KeygenCapExecution.source_result (fun _ => none) (reference SelectedPrefix125.ready) 0
    ⟨reference first,.normal⟩ (by decide) SelectedPrefixFacts125.entry_facts.1 (source (fun _ => none))
  have ordinary : ¬KeygenAttemptCap.limit<0+1 := by decide
  rw [KeygenCapExecution.result,ite_eq_right ordinary] at actual
  exact congrArg C99ProcedureReference.Result.state actual

theorem count : KeygenCapWords.Count (reference first) 1 := by
  rw [exact_state]
  exact KeygenCapWords.advanced_count (reference SelectedPrefix125.ready) 0

end FT1536.Source3.SelectedCap126
