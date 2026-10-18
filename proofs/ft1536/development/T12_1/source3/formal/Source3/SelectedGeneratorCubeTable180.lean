import Source3.SelectedGeneratorCube180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorCubeTable180
open SelectedTopLayout177 (gm igm)
open SelectedTopInit178 (p0i)
open SelectedGeneratorCubeSetup180 (before logged)
open SelectedGeneratorCubeLoop180 (after)
open KeygenSmallOutput (element)

theorem row_result : KeygenMkgm3Loops.Filled after.heap gm 256 ∧
    KeygenNttLoopSupport.USlot after "u" 512 ∧ KeygenNttButterflyCalls.U32Slot after "k" 8 :=
  KeygenMkgm3Assembly.full_rows logged ⟨after,.normal⟩ p0i gm igm
    SelectedGeneratorCubeSetup180.params
    ⟨SelectedGeneratorCubeSetup180.pointers.forward,SelectedGeneratorCubeSetup180.pointers.inverse⟩
    (ModularAtoms178.slot before "k" 9) SelectedGeneratorCubeSetup180.full_cell
    ⟨some (.uint64 512),SelectedGeneratorRowTable179.u_cell⟩
    SelectedGeneratorRowTable179.forward_filled (by decide) (by decide) SelectedGeneratorRowTable179.separate
    (KeygenNinv31.source_exists KeygenNinv31.prime) SelectedGeneratorCube180.source

theorem forward_filled : KeygenMkgm3Loops.Filled after.heap gm 256 := row_result.1
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 512 := row_result.2.1
theorem k_cell : KeygenNttButterflyCalls.U32Slot after "k" 8 := row_result.2.2

theorem g_initialized (i : Nat) (lo : 256 ≤ i) (hi : i < 1024) : Word32Initialized180.At after.heap (element gm i) := by
  by_cases small : i<512
  · exact (SelectedGeneratorCubeLoop180.initialized i lo small).1
  · exact SelectedGeneratorCubeLoop180.fixed.gUpper i (by omega) hi

theorem i_initialized (i : Nat) (lo : 256 ≤ i) (hi : i < 1024) : Word32Initialized180.At after.heap (element igm i) := by
  by_cases small : i<512
  · exact (SelectedGeneratorCubeLoop180.initialized i lo small).2
  · exact SelectedGeneratorCubeLoop180.fixed.iUpper i (by omega) hi

theorem g_read (i : Nat) (lo : 256 ≤ i) (hi : i < 1024) :
    ∃ word, C99MemoryReference.Load32 after.heap (element gm i) word :=
  Word32Initialized180.load after.heap (element gm i) (SelectedGeneratorCubeLoop180.fixed.gAllocated i hi)
    SelectedGeneratorCubeLoop180.fixed.gWidth (g_initialized i lo hi)

theorem i_read (i : Nat) (lo : 256 ≤ i) (hi : i < 1024) :
    ∃ word, C99MemoryReference.Load32 after.heap (element igm i) word :=
  Word32Initialized180.load after.heap (element igm i) (SelectedGeneratorCubeLoop180.fixed.iAllocated i hi)
    SelectedGeneratorCubeLoop180.fixed.iWidth (i_initialized i lo hi)

end FT1536.Source3.SelectedGeneratorCubeTable180
