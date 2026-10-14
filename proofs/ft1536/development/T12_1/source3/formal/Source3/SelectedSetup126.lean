import Source3.KeygenAttemptSetup126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSetup126
open C99CompactState115 (State reference)
open KeygenCallerData123 (env)

def result := KeygenAttemptSetup126.run env.ctx SelectedCap126.first
theorem defined : result.isSome=true := by decide +kernel
def ready : State := result.get defined
theorem computed : KeygenAttemptSetup126.run env.ctx SelectedCap126.first=some ready :=
  SelectedInput124.option_get result defined

theorem setup : KeygenCallerInit.Setup env.ctx (reference SelectedCap126.first) (reference ready) :=
  KeygenAttemptSetup126.run_sound env.ctx SelectedCap126.first ready computed

theorem capped : KeygenMakeSampling.CappedSetup env.ctx (reference SelectedPrefix125.ready) ⟨reference ready,.normal⟩ :=
  .run (reference SelectedCap126.first) (reference ready) (SelectedCap126.source KeygenSearchFft.program) setup

theorem exact_state : reference ready=KeygenMakeSampling.prepared env.ctx
    (KeygenCapWords.advanced (reference SelectedPrefix125.ready) 0) := by
  have classified := KeygenMakeSampling.cap_before_setup env.ctx (reference SelectedPrefix125.ready) 0
    ⟨reference ready,.normal⟩ (by decide) SelectedPrefixFacts125.entry_facts.1 SelectedPrefixFacts125.dimension capped
  rcases classified with stopped | running
  · have impossible : (0:Nat)≠KeygenAttemptCap.limit := by decide
    exact (impossible stopped.1).elim
  · exact congrArg C99ProcedureReference.Result.state running.2.1

theorem count : KeygenCapWords.Count (reference ready) 1 := by
  rw [exact_state]
  exact KeygenMakeSampling.prepared_count env.ctx _ 1 (KeygenCapWords.advanced_count _ 0)

theorem entry : KeygenAttemptMaterial.Entry env.ctx (reference ready)
    (KeygenMakeEntry.input env.blocks 0) (KeygenMakeEntry.input env.blocks 1) := by
  rw [exact_state]
  exact KeygenMakeSampling.entry_from_prepared env.ctx (reference SelectedPrefix125.ready) 0
    (KeygenMakeEntry.input env.blocks) (KeygenMakeEntry.publicPointer env.blocks)
    SelectedInput124.domain.primes SelectedInput124.domain.rev
    SelectedPrefixFacts125.entry_facts.2.1 SelectedPrefixFacts125.dimension

end FT1536.Source3.SelectedSetup126
