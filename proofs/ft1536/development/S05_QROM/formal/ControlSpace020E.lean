import ControlStack020E

namespace FT1536.S05.ControlSpace020E
open WordRAM020 ControlStack020E

/-- Stored syntax volume of the pending jobs; loop bodies are never unrolled
    into cap copies. Both old and new job lists may be charged at a transition. -/
def footprint : Jobs → Nat
  | [] => 0
  | c::cs => nodes c+footprint cs

def space : Code → Nat
  | .atom a => atomNodes a
  | .seq a b => max (1+nodes a+nodes b) (max (space a+nodes b) (space b))
  | .branch e a b => max (1+exprNodes e+nodes a+nodes b) (max (space a) (space b))
  | .loop _ g b => space b+(1+exprNodes g+nodes b)

/-- Future peak of the head, while the continuation remains stored. -/
def reserve : Jobs → Nat
  | [] => 0
  | c::cs => max (space c+footprint cs) (reserve cs)

theorem nodes_le_space (c : Code) : nodes c≤space c := by
  cases c <;> simp only [nodes,space]
  · exact le_rfl
  · exact le_max_left _ _
  · exact le_max_left _ _
  · omega

theorem footprint_le (cs : Jobs) : footprint cs≤reserve cs := by
  cases cs with
  | nil => exact le_rfl
  | cons c cs => exact (Nat.add_le_add_right (nodes_le_space c) _).trans (le_max_left _ _)

theorem next_reserve (i : Input) (c : Code) (cs : Jobs) (s : State) :
    reserve (next i c cs s).1≤reserve (c::cs) := by
  cases c with
  | atom a => exact le_max_right _ _
  | seq a b => simp only [next,reserve,footprint,space];omega
  | branch e a b =>
    simp only [next,reserve,space]
    split <;> simp only [reserve] <;> omega
  | loop n g b =>
    cases n with
    | zero => exact le_max_right _ _
    | succ n =>
      simp only [next,reserve,space]
      split <;> simp only [reserve,footprint,nodes,space] <;> omega

/-- A single transition's live old and new control syntax fits this bound.
    This is syntax volume, before the separate finite-cell encoding. -/
theorem transition_footprint (i : Input) (c : Code) (cs : Jobs) (s : State) :
    footprint (c::cs)+footprint (next i c cs s).1≤2*reserve (c::cs) := by
  have a := footprint_le (c::cs)
  have b := (footprint_le (next i c cs s).1).trans (next_reserve i c cs s)
  omega

/-- Number of control transitions is bounded by the old same-program cost.
    It is not equated to total time of expression compilation/copying. -/
theorem work_le_bound (c : Code) : work c≤bound c := by
  induction c with
  | atom a => cases a <;> simp only [work,bound,atomCost] <;> omega
  | seq a b ha hb => simp only [work,bound];omega
  | branch e a b ha hb => simp only [work,bound];omega
  | loop n g b hb => simp only [work,bound];nlinarith

end FT1536.S05.ControlSpace020E
