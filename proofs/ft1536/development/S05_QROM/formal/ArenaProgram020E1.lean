import ArenaParse020E1
import ArenaDecode020E1
import ProgramResources020E

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ArenaProgram020E1
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaInvariant020E1 ArenaParse020E1

def image (c : Code) : List SyntaxCells020E.Cell := (program c).map SyntaxCells020E.encode
def build (cap : Nat) (c : Code) : Option (Arena cap) := runCells (image c) (empty cap)

theorem build_invariant (cap : Nat) (c : Code) (hc : SyntaxLegal020E.maxCap c<2^511)
    (room : nodes c≤cap) :
    ∃ s : Arena cap,∃ mu : Meaning,build cap c=some s ∧ Inv s mu [.code c] ∧ s.used.val=nodes c := by
  let mu0 : Meaning := fun _ => .expr (.lit 0)
  have ht := SyntaxLegal020E.code_legal c hc
  obtain ⟨s,mu,hr,hi,hused⟩ := parse_refines (program c) (empty cap) mu0 [] [.code c]
    ht (empty_inv cap mu0) (by simpa only [empty_used,Nat.zero_add,program_length] using room)
    (program_roundtrip c [])
  refine ⟨s,mu,?_,hi,?_⟩
  · rw [build,image,encoded_run _ _ ht]
    exact hr
  · simpa only [empty_used,Nat.zero_add,program_length] using hused

/-- Every legal code image reconstructs the exact code by bank-only decoding.
    The existential Meaning occurs only in the proof of this concrete result. -/
theorem build_correct (cap : Nat) (c : Code) (hc : SyntaxLegal020E.maxCap c<2^511)
    (room : nodes c≤cap) :
    ∃ s : Arena cap,build cap c=some s ∧ ArenaDecode020E1.root s=some (.code c) ∧
      s.used.val=nodes c ∧ s.sp.val=1 := by
  obtain ⟨s,mu,hr,hi,hused⟩ := build_invariant cap c hc room
  exact ⟨s,hr,ArenaDecode020E1.root_correct s mu (.code c) hi,hused,
    (logical_length s mu [.code c] hi).symm⟩

def actual : Option (Arena 877) := build 877 PairProgram020.program

theorem actual_exists : ∃ s : Arena 877,actual=some s ∧
    ArenaDecode020E1.root s=some (.code PairProgram020.program) ∧ s.used.val=877 ∧ s.sp.val=1 := by
  have hc : SyntaxLegal020E.maxCap PairProgram020.program<2^511 := by
    rw [ProgramResources020E.cap_value]
    norm_num
  have h := build_correct 877 PairProgram020.program hc (by rw [ProgramCost020.program_nodes])
  simpa only [actual,ProgramCost020.program_nodes] using h

theorem actual_roundtrip : actual.bind ArenaDecode020E1.root=some (.code PairProgram020.program) := by
  obtain ⟨s,hs,hr,_,_⟩ := actual_exists
  rw [hs,Option.bind_some,hr]

theorem actual_counts (s : Arena 877) (hs : actual=some s) : s.used.val=877 ∧ s.sp.val=1 := by
  obtain ⟨q,hq,_,hu,hp⟩ := actual_exists
  have he : q=s := Option.some.inj (hq.symm.trans hs)
  subst q
  exact ⟨hu,hp⟩

end FT1536.S05.ArenaProgram020E1
