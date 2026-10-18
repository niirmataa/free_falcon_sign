import Source3.PublicInverseTriplePrefix172

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedInversePrefix172
open C99ArrayReference (State)
open KeygenPublicExec (Exec allocated)
open SelectedPublicBinding157 (h)
open SelectedQuotient171 (after)
open PublicForwardEntry159 (entryT)
open PublicInverseBody172 (igmPointer generateEntry aliasesBound bodyState)

theorem second_fresh : KeygenRngSource.Fresh (allocated after.heap 33 2048) 34 :=
  SelectedForwardInputs168.allocated_fresh_other _ 33 2048 34 (by decide) SelectedQuotient171.i_fresh

theorem exists_generator : ∃ generated,
    Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate)
      (generateEntry (entryT after h) 33 34) ⟨generated,.normal⟩ ∧
    PublicInverseDomains172.TailEntry (aliasesBound (entryT after h) 33 34 generated) h (igmPointer 34) :=
  PublicInverseDomains172.generated after h 33 34 SelectedQuotient171.output_fixed.data
    SelectedQuotient171.g_fresh second_fresh

noncomputable def generated : State := Classical.choose exists_generator
noncomputable def ready : State := aliasesBound (entryT after h) 33 34 generated

theorem generator_source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate)
    (generateEntry (entryT after h) 33 34) ⟨generated,.normal⟩ := (Classical.choose_spec exists_generator).1

theorem ready_domain : PublicInverseDomains172.TailEntry ready h (igmPointer 34) :=
  (Classical.choose_spec exists_generator).2

theorem exists_triples : ∃ last, Exec KeygenPublicSource.program [] PublicInverseTripleStart172.segment ready ⟨last,.normal⟩ ∧
    PublicInverseTriplePrefix172.After last h (igmPointer 34) :=
  PublicInverseTriplePrefix172.source ready h (igmPointer 34) ready_domain

noncomputable def last : State := Classical.choose exists_triples

theorem triples_source : Exec KeygenPublicSource.program [] PublicInverseTripleStart172.segment ready ⟨last,.normal⟩ :=
  (Classical.choose_spec exists_triples).1

theorem output_domain : PublicInverseTriplePrefix172.After last h (igmPointer 34) :=
  (Classical.choose_spec exists_triples).2

theorem continue_inverse (finalState : State)
    (remaining : Exec KeygenPublicSource.program [] KeygenPublicInverseProgram.remaining last ⟨finalState,.normal⟩) :
    Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT) (entryT after h)
      ⟨bodyState (entryT after h) 33 34 finalState,.normal⟩ :=
  PublicInverseBody172.source after h 33 34 (by decide) (by decide)
    SelectedQuotient171.g_fresh second_fresh generated finalState generator_source
    (PublicInverseTripleStart172.continue_tail ready last ⟨finalState,.normal⟩ triples_source remaining)

end FT1536.Source3.SelectedInversePrefix172
