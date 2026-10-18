import Source3.SelectedGeneratorRow179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorRowTable179
open C99ModularReference (chainOf)
open SelectedTopLayout177 (gm igm)
open KeygenFullData127 (rev)
open SelectedTopInit178 (p0i)
open SelectedGeneratorRow179 (before after)

theorem ready : KeygenMkgm3Prelude.Ready p0i before :=
  KeygenMkgm3Prelude.initial_result SelectedGeneratorEntry178.entry ⟨before,.normal⟩ p0i
    ⟨rfl,rfl⟩ rfl rfl rfl (KeygenNinv31.source_exists KeygenNinv31.prime)
    SelectedGeneratorInverse178.prefix_source

theorem pointers : KeygenMkgm3Upward.Pointers before gm igm :=
  KeygenMkgm3Upward.pointers_after _ SelectedGeneratorEntry178.entry ⟨before,.normal⟩ gm igm (by decide)
    ⟨rfl,rfl⟩ SelectedGeneratorInverse178.prefix_source

theorem rev_table : KeygenMkgm3RevMemory.Rev before rev :=
  KeygenMkgm3RevMemory.transported _ SelectedGeneratorEntry178.entry ⟨before,.normal⟩ rev (by decide)
    (KeygenMkgm3RevMemory.from_source _ rev SelectedGeneratorEntry178.rev_binding SelectedGeneratorEntry178.rev_source)
    SelectedGeneratorInverse178.prefix_source

theorem separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096 := by
  unfold KeygenMkgm3Layout.DisjointBytes
  decide

theorem row_result : KeygenMkgm3Loops.Filled after.heap gm 512 ∧
    KeygenNttLoopSupport.USlot after "u" 512 ∧ KeygenNttButterflyCalls.U32Slot after "k" 1 :=
  KeygenMkgm3RowInit.selected_row before ⟨after,.normal⟩ p0i gm igm rev ready pointers rev_table
    (by decide) (by decide) separate (KeygenNinv31.source_exists KeygenNinv31.prime) SelectedGeneratorRow179.source

theorem forward_filled : KeygenMkgm3Loops.Filled after.heap gm 512 := row_result.1
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 512 := row_result.2.1
theorem k_cell : KeygenNttButterflyCalls.U32Slot after "k" 1 := row_result.2.2

end FT1536.Source3.SelectedGeneratorRowTable179
