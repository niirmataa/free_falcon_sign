import Source3.SelectedPublicInputs158
import Source3.PublicConvertLoop158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicConvert158
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open Word16Memory158 (Represents)
open SelectedPublicBinding157 (f g h)
open SelectedPublicStart157 (t)
open SelectedSamplerWords158 (fValues gValues)

noncomputable def before := SelectedPublicStart157.ready
noncomputable def initial := FftLocalCells140.put before "u".toList 0
def tValues := PublicConvertInvariant158.image fValues
def hValues := PublicConvertInvariant158.image gValues

theorem fixed : PublicConvertInvariant158.Fixed before f g t h 1536 fValues gValues :=
  ⟨by decide,by decide,by decide,by decide,by decide,rfl,rfl,
    SelectedPublicStart157.f_cell,SelectedPublicStart157.g_cell,SelectedPublicStart157.t_cell,SelectedPublicStart157.h_cell,
    SelectedPublicStart157.n_cell,SelectedPublicStart157.q_cell,
    SelectedPublicInputs158.t_allocated,SelectedPublicInputs158.h_allocated,
    SelectedPublicInputs158.t_writable,SelectedPublicInputs158.h_writable,
    SelectedPublicInputs158.f_image,SelectedPublicInputs158.g_image,
    by decide,by decide,by decide,by decide,by decide⟩

theorem initialization : KeygenPublicExec.Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
    KeygenPublicInputProgram.initial before ⟨initial,.normal⟩ := PublicNat158.initial before none rfl

theorem exists_loop : ∃ after, KeygenPublicExec.Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
    KeygenPublicInputProgram.loop initial ⟨after,.normal⟩ ∧
    PublicConvertInvariant158.Fixed after f g t h 1536 fValues gValues ∧ Cell after "u".toList 1536 ∧
    Represents after.heap t tValues ∧ Represents after.heap h hValues ∧ PublicConvertFrame158.Frame t h 1536 initial after :=
  PublicConvertLoop158.source initial f g t h 1536 fValues gValues
    (PublicConvertLoop158.counter_fixed before f g t h 1536 fValues gValues fixed 0) (FftLocalCells140.cell_at before "u".toList 0)

noncomputable def after : State := Classical.choose exists_loop
theorem loop_source : KeygenPublicExec.Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
    KeygenPublicInputProgram.loop initial ⟨after,.normal⟩ := (Classical.choose_spec exists_loop).1
theorem output_fixed : PublicConvertInvariant158.Fixed after f g t h 1536 fValues gValues := (Classical.choose_spec exists_loop).2.1
theorem t_image : Represents after.heap t tValues := (Classical.choose_spec exists_loop).2.2.2.1
theorem h_image : Represents after.heap h hValues := (Classical.choose_spec exists_loop).2.2.2.2.1
theorem frame : PublicConvertFrame158.Frame t h 1536 before after :=
  PublicConvertFrame158.trans t h 1536 before initial after (PublicConvertFrame158.counter t h 1536 before 0)
    (Classical.choose_spec exists_loop).2.2.2.2.2

/-- Full actual original conversion, including zero initialization and both stores at every index. -/
theorem source : KeygenPublicExec.Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
    KeygenPublicInputProgram.conversion before ⟨after,.normal⟩ := .seqNormal _ _ _ initial _ initialization loop_source

def remaining := KeygenPublicInputProgram.append
  (KeygenPublicExec.chain [KeygenPublicInputProgram.hForward,KeygenPublicInputProgram.tForward]) KeygenPublicInputProgram.suffix

theorem continue_body (out : C99ProcedureReference.Result)
    (tail : KeygenPublicExec.Exec KeygenPublicSource.program KeygenPublicInputProgram.signed remaining after out) :
    KeygenPublicExec.Exec KeygenPublicSource.program KeygenPublicInputProgram.signed SelectedPublicStart157.remaining before out :=
  .seqNormal _ _ _ after _ source tail

end FT1536.Source3.SelectedPublicConvert158
