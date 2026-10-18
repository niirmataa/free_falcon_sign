import Source3.SelectedInverse174

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicSuccess174
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed)

noncomputable def result : Result := ⟨SelectedInverse174.after,.returned (some (.int32 1))⟩

theorem returned : Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.success
    SelectedInverse174.after result :=
  .ret _ _ (.int32 1) (.scalar _ _ (.literal .int32 1))

theorem remaining : Exec KeygenPublicSource.program signed SelectedQuotient171.remaining SelectedQuotient171.after result :=
  .seqNormal _ _ _ SelectedInverse174.after result SelectedInverse174.source
    (.seqExit _ _ SelectedInverse174.after result returned (by decide))

theorem body_source : Exec KeygenPublicSource.program signed SelectedPublicStart157.remaining
    SelectedPublicStart157.ready result := SelectedQuotient171.continue_public result remaining

noncomputable def after : State := {SelectedPublicBinding157.before with heap:=
  (KeygenPublicExec.localExit SelectedPublicStart157.declared SelectedInverse174.after
    "t".toList SelectedPublicMemory157.temporary).heap}

theorem source : KeygenPublicSource.Call SelectedPublicBinding157.before after (.int32 1) :=
  SelectedPublicStart157.continue_call result (.int32 1) body_source
    (C99ProcedureReference.ReturnValue.value .int32 (.int32 1))

theorem gate : KeygenAttemptMaterial.PublicGate SelectedAttemptPrefix156.publicInput ⟨after,.normal⟩ :=
  .accept after (.int32 1) source (by decide)

theorem continue_search (out : Result)
    (root : KeygenCallerSuccess.RootGate KeygenFullData127.env.ctx after out) :
    KeygenMakeSearchPrefix134.Sampled KeygenFullData127.env.ctx SelectedAttemptPrefix156.saved out :=
  SelectedAttemptPrefix156.continue_search after out gate root

end FT1536.Source3.SelectedPublicSuccess174
