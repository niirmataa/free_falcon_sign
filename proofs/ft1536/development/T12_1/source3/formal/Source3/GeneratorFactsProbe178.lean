import Source3.SelectedGeneratorInverse178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorFactsProbe178
open SelectedGeneratorInverseCall178 (ig before after)
open SelectedGeneratorSquare178 (g1)

#eval IO.FS.writeFile "../FACT178_PROGRESS.txt" "before heap"

theorem heap : after.heap=SelectedGeneratorEntry178.entry.heap := rfl
#eval IO.FS.writeFile "../FACT178_PROGRESS.txt" "before ig_cell"

theorem ig_cell : KeygenModpR2Exec.Slot after "ig" ig := ModularAtoms178.slot before "ig" ig
#eval IO.FS.writeFile "../FACT178_PROGRESS.txt" "before g_cell"

theorem g_cell : after.locals "g".toList=some (.uint32,some (.uint32 g1)) := SelectedGeneratorSquare178.g_cell
#eval IO.FS.writeFile "../FACT178_PROGRESS.txt" "before k_cell"

theorem k_cell : after.locals "k".toList=some (.uint32,some (.uint32 12)) := SelectedGeneratorSquare178.k_cell


#eval IO.FS.writeFile "../FACT178_PROGRESS.txt" "complete"

end FT1536.Source3.GeneratorFactsProbe178
