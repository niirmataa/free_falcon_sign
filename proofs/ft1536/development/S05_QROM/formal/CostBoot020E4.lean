import CostParse020E4
import PublicImage020E4

namespace FT1536.S05.CostBoot020E4
open CostRun020E4

def boot := CostParse020E4.load 877 PublicImage020E4.cells
def price := CostParse020E4.loadPrice 877 877

theorem value : boot.value=ArrayArena020E4.parse (ArenaProgram020E1.image PairProgram020.program) (ArrayArena020E4.empty 877) :=
  (CostParse020E4.load_value 877 PublicImage020E4.cells).trans
    (congrArg (fun cs => ArrayArena020E4.parse cs (ArrayArena020E4.empty 877)) PublicImage020E4.binding)

theorem bound : Bounded boot price price := by
  have h := CostParse020E4.load_bound 877 PublicImage020E4.cells
  rw [PublicImage020E4.length] at h
  exact h

end FT1536.S05.CostBoot020E4
