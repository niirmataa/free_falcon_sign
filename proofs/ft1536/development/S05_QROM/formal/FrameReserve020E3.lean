import NodeExecute020E2
import ControlSpace020E
import ProgramResources020E

namespace FT1536.S05.FrameReserve020E3
open WordRAM020 NodeFrames020E2 ControlStack020E ControlSpace020E

theorem nodes_positive (c : Code) : 0<nodes c := by
  cases c with
  | atom a => cases a <;> simp only [nodes,atomNodes] <;> omega
  | seq a b => simp only [nodes];omega
  | branch e a b => simp only [nodes];omega
  | loop n g b => simp only [nodes];omega

theorem length_le_footprint (cs : Jobs) : cs.length≤footprint cs := by
  induction cs with
  | nil => exact le_rfl
  | cons c cs ih => have hp := nodes_positive c;simp only [List.length_cons,footprint];omega

theorem length_le_reserve (cs : Jobs) : cs.length≤reserve cs :=
  (length_le_footprint cs).trans (footprint_le cs)

theorem next_length_bound (i : Input) (c : Code) (cs : Jobs) (s : State) :
    (next i c cs s).1.length≤reserve (c::cs) :=
  (length_le_reserve _).trans (next_reserve i c cs s)

theorem actual_reserve : reserve [PairProgram020.program]≤28941 := by
  simp only [reserve,footprint,Nat.add_zero,max_eq_left (Nat.zero_le _)]
  exact ProgramResources020E.space_bound

end FT1536.S05.FrameReserve020E3
