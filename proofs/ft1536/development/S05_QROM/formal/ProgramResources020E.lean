import ControlMeter020E
import ProgramCost020
import ExprCompileBudget020E

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 512
namespace FT1536.S05.ProgramResources020E
open WordRAM020 ControlStack020E ControlSpace020E SyntaxLegal020E

/-- These are kernel evaluations of the unchanged closed syntax. -/
theorem cap_value : maxCap PairProgram020.program=1536 := by decide +kernel

theorem space_bound : space PairProgram020.program≤28941 := by decide +kernel

theorem legal : JobsLegal [PairProgram020.program] := by
  simp only [JobsLegal,List.mem_singleton,forall_eq,cap_value]
  norm_num

theorem reachable (i : Input) (s0 s : State) (cs : Jobs)
    (h : ControlMeter020E.Reach i [PairProgram020.program] s0 cs s) :
    footprint cs≤28941 ∧ JobsLegal cs := by
  have b := ControlMeter020E.reachable_resources i _ cs s0 s h legal
  have hs : reserve [PairProgram020.program]=space PairProgram020.program := by
    simp only [reserve,footprint,Nat.add_zero,max_eq_left (Nat.zero_le _)]
  rw [hs] at b
  exact ⟨(footprint_le cs).trans (b.1.trans space_bound),b.2⟩

theorem measured_bounds (i : Input) (s : State) :
    let r := ControlMeter020E.measured i (work PairProgram020.program) [PairProgram020.program] s
    r.answer=some (run i PairProgram020.program s).1 ∧
      r.transitions≤1106642201817 ∧ r.peakSyntax≤57882 := by
  have b := ControlMeter020E.correct_with_peak i PairProgram020.program s
  have hw := work_le_bound PairProgram020.program
  rw [ProgramCost020.program_bound_value] at hw
  exact ⟨b.1,b.2.1.trans hw,by have hs := space_bound;omega⟩

theorem syntax_length : (SyntaxTape020E.program PairProgram020.program).length=877 :=
  (SyntaxTape020E.program_length _).trans ProgramCost020.program_nodes

/-- Lossless fixed-cell encoding exists for every reachable job; this theorem
    does not assert a physical heap allocator or its complete cost. -/
theorem reachable_codec (i : Input) (s0 s : State) (cs : Jobs)
    (h : ControlMeter020E.Reach i [PairProgram020.program] s0 cs s)
    (c : Code) (hc : c∈cs) :
    ((SyntaxTape020E.program c).map SyntaxCells020E.encode).map SyntaxCells020E.decode=
      (SyntaxTape020E.program c).map some :=
  decode_map _ (code_legal c ((reachable i s0 s cs h).2 c hc))

end FT1536.S05.ProgramResources020E
