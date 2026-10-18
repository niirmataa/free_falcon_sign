import Source3.SelectedGeneratorInverse178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorInverseFacts178
open SelectedGeneratorInverseCall178 (ig before after)
open SelectedGeneratorSquare178 (g1)

#eval IO.FS.writeFile "../GENERATOR_FACTS178_PROGRESS.txt" "before heap"

theorem heap : after.heap=SelectedGeneratorEntry178.entry.heap :=
  KeygenMkgm3Atoms.pure_heap (C99ModularReference.chainOf SelectedGeneratorInverse178.steps)
    SelectedGeneratorEntry178.entry ⟨after,.normal⟩ (by decide) SelectedGeneratorInverse178.prefix_source

#eval IO.FS.writeFile "../GENERATOR_FACTS178_PROGRESS.txt" "before ig_cell"

theorem ig_cell : KeygenModpR2Exec.Slot after "ig" ig := ModularAtoms178.slot before "ig" ig
#eval IO.FS.writeFile "../GENERATOR_FACTS178_PROGRESS.txt" "before g_cell"

theorem g_cell : after.locals "g".toList=some (.uint32,some (.uint32 g1)) :=
  (ModularAtoms178.outside before "ig" "g" ig (by decide)).trans SelectedGeneratorSquare178.g_cell
#eval IO.FS.writeFile "../GENERATOR_FACTS178_PROGRESS.txt" "before k_cell"

theorem k_cell : after.locals "k".toList=some (.uint32,some (.uint32 12)) :=
  (ModularAtoms178.outside before "ig" "k" ig (by decide)).trans SelectedGeneratorSquare178.k_cell


#eval IO.FS.writeFile "../GENERATOR_FACTS178_PROGRESS.txt" "complete"

end FT1536.Source3.SelectedGeneratorInverseFacts178
