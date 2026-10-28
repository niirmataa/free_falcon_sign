import Source3.BezoutMlen217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Compose original upper u/v zeroing and mlen branch. -/
namespace FT1536.Source3.BezoutUpperSequence217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99MemoryReference (ArrayPointer Load32)
open KeygenZintCall (Exec Stmt)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)

def code : Stmt := .seq BezoutUpperZero217.first (.seq BezoutUpperZero217.second BezoutMlen217.select)
def after (s : State) (nx ny : Nat) := BezoutMlen217.after (BezoutUpperZero217.after s nx ny) nx ny

theorem shape : KeygenZintCall.bezoutPart 5=.seq BezoutUpperZero217.first (.seq BezoutUpperZero217.second (.seq BezoutMlen217.select BezoutMlen217.tail)) := by
  rw [BezoutUpperZero217.shape,BezoutMlen217.shape]

theorem source (s : State) (nx ny : Nat) (h : BezoutUpperZero217.Input s nx ny)
    (ac : Cell s "alen".toList nx) (bc : Cell s "blen".toList ny)
    (declared : s.locals "mlen".toList=some (.uint64,none)) :
    Exec code s ⟨after s nx ny,.normal⟩ ∧ Cell (after s nx ny) "mlen".toList (max nx ny) ∧
    Load32 (after s nx ny).heap Gp 1 := by
  obtain ⟨first,second,one⟩:=BezoutUpperZero217.source s nx ny h
  have ac' : Cell (BezoutUpperZero217.after s nx ny) "alen".toList nx := ac
  have bc' : Cell (BezoutUpperZero217.after s nx ny) "blen".toList ny := bc
  have decl' : (BezoutUpperZero217.after s nx ny).locals "mlen".toList=some (.uint64,none) := declared
  obtain ⟨select,mlen⟩:=BezoutMlen217.source _ nx ny h.nxBound h.nyBound ac' bc' decl'
  exact ⟨.seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second select),mlen,one⟩

theorem keep_data (s : State) (nx ny n : Nat) (root : ArrayPointer) (W : Nat → BitVec 32)
    (data : Data s root n W)
    (apartU : ∀ i<n, (elem root i).block≠Gp.block ∨ (elem root i).offset+4≤(element Gp ny).offset ∨
      (element Gp ny).offset+4*(335-ny)≤(elem root i).offset)
    (apartV : ∀ i<n, (elem root i).block≠Fp.block ∨ (elem root i).offset+4≤(element Fp nx).offset ∨
      (element Fp nx).offset+4*(335-nx)≤(elem root i).offset) : Data (after s nx ny) root n W := by
  intro i bound
  exact BezoutMemzero217.outside (BezoutUpperZero217.middle s ny).heap (element Fp nx) (elem root i) (4*(335-nx)) (W i) (apartV i bound)
    (BezoutMemzero217.outside s.heap (element Gp ny) (elem root i) (4*(335-ny)) (W i) (apartU i bound) (data i bound))

end FT1536.Source3.BezoutUpperSequence217
