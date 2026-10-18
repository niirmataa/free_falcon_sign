import Source3.SelectedGeneratorCubeTable180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorCubeFrame180
open C99ModularReference (Exec chainOf)
open SelectedGeneratorCubeSetup180 (before logged)
open SelectedGeneratorCubeLoop180 (after)
open SelectedTopLayout177 (fs gs)

def code := chainOf [KeygenMkgm3Program.kFromLogn,KeygenMkgm3Program.ifFull]

theorem source : Exec code before ⟨after,.normal⟩ :=
  .seqNormal _ _ before logged ⟨after,.normal⟩ SelectedGeneratorCubeSetup180.source
    (.seqNormal _ _ logged after ⟨after,.normal⟩ SelectedGeneratorCube180.source (.base .skip after after (.skip after)))

theorem outside (block offset : Nat) (separate : block≠31 ∨ offset<19064) :
    C99ArrayFrame.Outside before ["gm".toList,"igm".toList] block offset := by
  intro name member pointer binding
  have arrays := (KeygenMkgm3Control.frame _ _ _ (by decide) SelectedGeneratorRow179.source).2.1
  have old : SelectedGeneratorRow179.before.arrays name=some pointer := by
    rw [←arrays]
    exact binding
  exact SelectedGeneratorRowFrame179.outside block offset separate name member pointer old

theorem bytes (block offset : Nat) (separate : block≠31 ∨ offset<19064) :
    after.heap.bytes block offset=before.heap.bytes block offset :=
  (KeygenLevelModularFrame.body_frame code before ⟨after,.normal⟩ source ["gm".toList,"igm".toList]
    (by decide) block offset (outside block offset separate)).2.2

theorem stable : KeygenMemoryStability.Stable before.heap after.heap := KeygenMemoryStability.modular code before ⟨after,.normal⟩ source

theorem f_image : Word32Memory176.Represents after.heap fs SelectedMakeFgConvert176.fImage := by
  intro i
  apply Gate00Memory.load32_transport before.heap after.heap _ _ (SelectedGeneratorRowFrame179.f_image i) stable.size
  intro byte
  apply bytes
  right
  have hi:=i.isLt
  have hb:=byte.isLt
  change 0+4*(1694+i.val)+byte.val<19064
  omega

theorem g_image : Word32Memory176.Represents after.heap gs SelectedMakeFgConvert176.gImage := by
  intro i
  apply Gate00Memory.load32_transport before.heap after.heap _ _ (SelectedGeneratorRowFrame179.g_image i) stable.size
  intro byte
  apply bytes
  right
  have hi:=i.isLt
  have hb:=byte.isLt
  change 0+4*(3230+i.val)+byte.val<19064
  omega

end FT1536.Source3.SelectedGeneratorCubeFrame180
