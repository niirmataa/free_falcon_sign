import PairProgram020

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000
namespace FT1536.S05.ProgramCost020
open WordRAM020 PairProgram020

theorem program_bound_value : bound program = 1106642201817 := by decide +kernel

theorem program_nodes : nodes program = 877 := by decide +kernel

theorem program_depth : depth program = 32 := by decide +kernel

theorem finite_data_bits : dataBits = 24712937985 := by decide +kernel

/-- Core execution only; input materialization, concrete control storage and
    transfer to a caller still need a driver and its refinement. -/
theorem core_cost (i : Input) (s : State) :
    (run i program s).2 ≤ 1106642201817 := by
  rw [←program_bound_value]
  exact operational_bound i s

theorem core_cost_initial (i : Input) :
    (run i program initial).2 ≤ 1106642201817 := core_cost i initial

end FT1536.S05.ProgramCost020
