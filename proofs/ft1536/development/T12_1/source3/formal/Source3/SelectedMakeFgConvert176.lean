import Source3.SelectedMakeFgDomains176
import Source3.MakeFgConversionLoop176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMakeFgConvert176
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open SelectedMakeFgSetup176 (ft gt)
open SelectedSamplerWords158 (fValues gValues)
open SelectedRootEntry175 (inputs)

noncomputable def before := SelectedMakeFgSetup176.after
noncomputable def initial := FftLocalCells140.put before "u".toList 0
def fImage := MakeFgConversionInvariant176.image fValues
def gImage := MakeFgConversionInvariant176.image gValues

theorem initialization : Exec MakeFgConversionShape176.initial before ⟨initial,.normal⟩ :=
  MakeFgNat176.initial before none rfl

theorem exists_loop : ∃ after, Exec MakeFgConversionShape176.loop initial ⟨after,.normal⟩ ∧
    MakeFgConversionInvariant176.Fixed after (inputs 0) (inputs 1) ft gt 1536 fValues gValues ∧
    Cell after "u".toList 1536 ∧ Word32Memory176.Represents after.heap ft fImage ∧
    Word32Memory176.Represents after.heap gt gImage ∧ MakeFgConversionFrame176.Frame ft gt 1536 initial after :=
  MakeFgConversionLoop176.source initial (inputs 0) (inputs 1) ft gt 1536 fValues gValues
    (MakeFgConversionLoop176.counter_fixed before (inputs 0) (inputs 1) ft gt 1536 fValues gValues
      SelectedMakeFgDomains176.fixed 0) (FftLocalCells140.cell_at before "u".toList 0)

noncomputable def after : State := Classical.choose exists_loop

theorem source : Exec MakeFgConversionShape176.conversion before ⟨after,.normal⟩ :=
  .seqNormal _ _ before initial ⟨after,.normal⟩ initialization (Classical.choose_spec exists_loop).1
theorem output_fixed : MakeFgConversionInvariant176.Fixed after (inputs 0) (inputs 1) ft gt 1536 fValues gValues :=
  (Classical.choose_spec exists_loop).2.1
theorem f_image : Word32Memory176.Represents after.heap ft fImage := (Classical.choose_spec exists_loop).2.2.2.1
theorem g_image : Word32Memory176.Represents after.heap gt gImage := (Classical.choose_spec exists_loop).2.2.2.2.1
theorem frame : MakeFgConversionFrame176.Frame ft gt 1536 before after :=
  MakeFgConversionFrame176.trans ft gt 1536 before initial after (MakeFgConversionFrame176.counter ft gt 1536 before 0)
    (Classical.choose_spec exists_loop).2.2.2.2.2
theorem part_source : Exec (KeygenMakeFgSource.part .make 1) SelectedMakeFgSetup176.before ⟨after,.normal⟩ :=
  SelectedMakeFgSetup176.continue_part after source

def remaining := KeygenMakeFgSource.chain [KeygenMakeFgSource.part .make 2,KeygenMakeFgSource.part .make 3]

theorem continue_make (out : C99ProcedureReference.Result) (rest : Exec remaining after out) :
    Exec (KeygenMakeFgSource.code .make) SelectedMakeFgEntry175.entry out :=
  .seqNormal _ _ SelectedMakeFgEntry175.entry SelectedMakeFgSetup176.before out
    (MakeFgDeclarations176.source SelectedMakeFgEntry175.entry)
    (.seqNormal _ _ SelectedMakeFgSetup176.before after out part_source rest)

end FT1536.Source3.SelectedMakeFgConvert176
