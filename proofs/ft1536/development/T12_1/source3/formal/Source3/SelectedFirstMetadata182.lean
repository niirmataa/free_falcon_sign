import Source3.SelectedFirstFrame182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFirstMetadata182
open KeygenModpR2Exec (Slot)
open SelectedNttFirst182 (after first_pass)

theorem logn_cell : Slot after "logn" 10 :=
  KeygenNttControl.keep_u32 first_pass (by decide) "logn" 10 (by decide) SelectedFirstInput182.input.logn

theorem full_cell : Slot after "full" 1 :=
  KeygenNttControl.keep_u32 first_pass (by decide) "full" 1 (by decide) SelectedFirstInput182.input.full

theorem m_declared : after.locals "m".toList=some (.uint64,none) :=
  ((KeygenNttControl.frame _ _ _ (by decide) first_pass).2.1 "m".toList (by decide)).trans rfl

theorem t_declared : after.locals "t".toList=some (.uint64,none) :=
  ((KeygenNttControl.frame _ _ _ (by decide) first_pass).2.1 "t".toList (by decide)).trans rfl

def prefixCode := KeygenNttForwardPrograms.glue KeygenNttForwardPrograms.prologue KeygenNttForwardPrograms.firstPass

theorem prefix_source : C99ModularReference.Exec prefixCode SelectedForwardEntry182.entry ⟨after,.normal⟩ :=
  NttGlue182.source KeygenNttForwardPrograms.prologue SelectedForwardEntry182.entry
    (KeygenNttForwardExec.ready SelectedForwardEntry182.entry) SelectedNttFirst182.prologue
    KeygenNttForwardPrograms.firstPass ⟨after,.normal⟩ first_pass

end FT1536.Source3.SelectedFirstMetadata182
