import Source3.KeygenNttMiddleRounds
import Source3.KeygenNttCells

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- B1.04 only: t*m=n at the intermediate-loop HEADERS. During the
   t=ht / m<<=1 seam the old m times the new t is 768, not 1536.
   All values below refine the already source-derived MInv counters. -/
namespace FT1536.Source3.KeygenNttGeometry
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenNttLoopSupport (USlot PSlot)
open KeygenNttMiddleRounds (MInv MTrace)

def m (i : Nat) : Nat := 2^(i+1)
def t (i : Nat) : Nat := 768/2^i
def ht (i : Nat) : Nat := t i/2
def lowIndex (i j k : Nat) : Nat := j*t i+k
def highIndex (i j k : Nat) : Nat := j*t i+ht i+k
def twiddleIndex (i j : Nat) : Nat := m i+j

theorem header_product (i : Nat) (hi : i≤8) : t i*m i=1536 := by
  interval_cases i <;> decide

theorem header_positive (i : Nat) (hi : i≤8) : 0<t i ∧ 0<m i := by
  interval_cases i <;> decide

theorem active_halving (i : Nat) (hi : i≤7) : t i=2*ht i ∧ 0<ht i := by
  interval_cases i <;> decide

theorem seam_product (i : Nat) (hi : i≤7) : ht i*m i=768 := by
  interval_cases i <;> decide

theorem next_header (i : Nat) : t (i+1)=ht i ∧ m (i+1)=2*m i := by
  constructor
  · exact (KeygenNttMiddleRounds.halve_eq i).symm
  · simp only [m,pow_succ]
    omega

theorem active_twiddle (i j : Nat) (hi : i≤7) (hj : j<m i) :
    2≤twiddleIndex i j ∧ twiddleIndex i j<512 := by
  have hm : 2≤m i ∧ m i≤256 := by interval_cases i <;> decide
  unfold twiddleIndex
  omega

theorem butterfly_indices (i j k : Nat) (hi : i≤7) (hj : j<m i) (hk : k<ht i) :
    lowIndex i j k<highIndex i j k ∧ highIndex i j k<1536 := by
  obtain ⟨halves,pos⟩ := active_halving i hi
  have bound : (j+1)*t i≤m i*t i := Nat.mul_le_mul_right _ (by omega)
  have product : m i*t i=1536 := by rw [Nat.mul_comm,header_product i (by omega)]
  rw [product] at bound
  rw [Nat.add_mul,Nat.one_mul] at bound
  simp only [lowIndex,highIndex]
  constructor <;> omega

theorem block_covers (i q : Nat) (hi : i≤7) (hq : q<1536) :
    ∃ j<m i, ∃ k<ht i, q=lowIndex i j k ∨ q=highIndex i j k := by
  obtain ⟨halves,hpos⟩ := active_halving i hi
  have tp := (header_positive i (by omega)).1
  have product := header_product i (by omega)
  have jm : q/t i<m i := (Nat.div_lt_iff_lt_mul tp).mpr (by nlinarith)
  have rem : q%t i<t i := Nat.mod_lt q tp
  have split := Nat.mod_add_div q (t i)
  refine ⟨q/t i,jm,?_⟩
  by_cases small : q%t i<ht i
  · refine ⟨q%t i,small,Or.inl ?_⟩
    unfold lowIndex
    nlinarith
  · refine ⟨q%t i-ht i,by omega,Or.inr ?_⟩
    unfold highIndex
    nlinarith [Nat.sub_add_cancel (by omega : ht i≤q%t i)]

theorem same_block_disjoint (p : ArrayPointer) (width : p.elementBytes=4)
    (i j k : Nat) (hi : i≤7) (hj : j<m i) (hk : k<ht i) :
    KeygenNttCells.Separate (KeygenSmallOutput.element p (lowIndex i j k))
      (KeygenSmallOutput.element p (highIndex i j k)) :=
  KeygenNttCells.elements_separate p width _ _ (Nat.ne_of_lt (butterfly_indices i j k hi hj hk).1)

theorem source_header_product (i : Nat) (hi : i≤8) (s : State) (inv : MInv i s) :
    USlot s "t" (t i) ∧ USlot s "m" (m i) ∧ t i*m i=1536 :=
  ⟨inv.tSlot,inv.mSlot,header_product i hi⟩

theorem stop_index (i : Nat) (hi : i≤8) (stop : ¬3<t i) : i=8 := by
  interval_cases i <;> first | rfl | exact (stop (by decide)).elim

theorem trace_exit (p : ArrayPointer) (stride i : Nat) (before after : State)
    (trace : MTrace p stride i before after) (hi : i≤8) : MInv 8 after := by
  induction trace with
  | done i s stop inv =>
      have he := stop_index i hi stop
      subst i
      exact inv
  | next i before mid next fin guard inv iteration run update rest ih =>
      exact ih (by have := KeygenNttMiddleRounds.round_index_bound i guard; omega)

theorem intermediate_exit (p : ArrayPointer) (before : State) (out : Result)
    (hn : USlot before "hn" 768)
    (tc : ∃ old, before.locals "t".toList=some (.uint64,old))
    (mc : ∃ old, before.locals "m".toList=some (.uint64,old))
    (full : KeygenNttForwardExec.fullAt before) (stride : USlot before "stride" 1)
    (ap : PSlot before "a" p)
    (source : C99ModularReference.Exec KeygenNttForwardPrograms.intermediatePass before out) :
    out.flow=.normal ∧ USlot out.state "m" 512 ∧ USlot out.state "t" 3 := by
  obtain ⟨flow,s0,_,trace⟩ := KeygenNttMiddleRounds.intermediate_result p 1 before out
    (by decide) (by decide) hn tc mc full stride ap source
  have exit := trace_exit p 1 0 s0 out.state trace (by decide)
  exact ⟨flow,exit.mSlot,exit.tSlot⟩

end FT1536.Source3.KeygenNttGeometry
