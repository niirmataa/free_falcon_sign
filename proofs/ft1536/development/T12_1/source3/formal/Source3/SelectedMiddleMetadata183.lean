import Source3.SelectedMiddleFrame183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMiddleMetadata183
open KeygenModpR2Exec (Slot)
open SelectedNttMiddle183 (before after source)

theorem logn_cell : Slot after "logn" 10 :=
  KeygenNttControl.keep_u32 source (by decide) "logn" 10 (by decide) SelectedFirstMetadata182.logn_cell

theorem full_cell : Slot after "full" 1 :=
  KeygenNttControl.keep_u32 source (by decide) "full" 1 (by decide) SelectedFirstMetadata182.full_cell

theorem u_cell : KeygenNttLoopSupport.USlot after "u" 768 :=
  KeygenNttControl.keep_u64 source (by decide) "u" 768 (by decide) SelectedNttFirst182.counter

theorem r_declared : after.locals "r".toList=some (.uint64,none) := by
  have first : before.locals "r".toList=some (.uint64,none) :=
    ((KeygenNttControl.frame _ _ _ (by decide) SelectedNttFirst182.first_pass).2.1 "r".toList (by decide)).trans rfl
  exact ((KeygenNttControl.frame _ _ _ (by decide) source).2.1 "r".toList (by decide)).trans first

def prefixCode := KeygenNttForwardPrograms.glue SelectedFirstMetadata182.prefixCode KeygenNttForwardPrograms.intermediatePass

theorem prefix_source : C99ModularReference.Exec prefixCode SelectedForwardEntry182.entry ⟨after,.normal⟩ :=
  NttGlue182.source SelectedFirstMetadata182.prefixCode SelectedForwardEntry182.entry before
    SelectedFirstMetadata182.prefix_source KeygenNttForwardPrograms.intermediatePass ⟨after,.normal⟩ source

end FT1536.Source3.SelectedMiddleMetadata183
