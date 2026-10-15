import Source3.KeygenNormInvariant151

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenNormStep151
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (element)
open C99LoopScalar141 (Cell)
open KeygenNormInvariant151 (Fixed Norm names)
open FftLocalCells140 (put)

def advance {n : Nat} (f g : Fin n → BitVec 64) (u : Nat) (acc : BitVec 64) : BitVec 64 :=
  if range : u<n then KeygenNormBody151.step acc (f ⟨u,range⟩) (g ⟨u,range⟩) else acc

theorem source (ctx : KeygenSearchContext.Context) (s : State) (p q : ArrayPointer) (n u : Nat)
    (f g : Fin n → BitVec 64) (acc : BitVec 64) (fixed : Fixed s p q n f g)
    (counter : Cell s "u".toList u) (norm : Norm s acc) (range : u<n) :
    ∃ middle after, KeygenSearchExec.Exec ctx KeygenNormShape151.body s ⟨middle,.normal⟩ ∧
      KeygenSearchExec.Exec ctx KeygenNormShape151.increment middle ⟨after,.normal⟩ ∧
      Fixed after p q n f g ∧ Cell after "u".toList (u+1) ∧ Norm after (advance f g u acc) ∧
      C99ScopeFrame147.Frame names s after ∧ after.heap=s.heap := by
  let i : Fin n := ⟨u,range⟩
  have bound := fixed.wordBound
  have pc := fixed.pCapacity
  have qc := fixed.qCapacity
  have index := C99LoopScalar141.read s "u".toList u counter
  have pAddress : C99ArrayReference.Pointer s "rt1".toList (.var "u".toList) (element p i) :=
    C99PointerNat141.source s _ _ p u (by omega) (by omega) fixed.pBinding index
  have qAddress : C99ArrayReference.Pointer s "rt2".toList (.var "u".toList) (element q i) :=
    C99PointerNat141.source s _ _ q u (by omega) (by omega) fixed.qBinding index
  let one := put s "norm".toList (KeygenNormBody151.addSquare acc (f i))
  let middle := put one "norm".toList (KeygenNormBody151.step acc (f i) (g i))
  let after := put middle "u".toList (C99NatWord141.word (u+1))
  have middleFrame : C99ScopeFrame147.Frame names s middle :=
    C99ScopeFrame147.trans names s one middle (C99ScopeFrame147.put names s "norm".toList _ (by decide))
      (C99ScopeFrame147.put names one "norm".toList _ (by decide))
  have middleCounter : Cell middle "u".toList u :=
    (FftLocalCells140.outside one "norm".toList "u".toList _ (by decide)).trans
      ((FftLocalCells140.outside s "norm".toList "u".toList _ (by decide)).trans counter)
  have frame : C99ScopeFrame147.Frame names s after := C99ScopeFrame147.trans names s middle after middleFrame
    (C99ScopeFrame147.put names middle "u".toList _ (by decide))
  refine ⟨middle,after,KeygenNormBody151.source ctx s _ _ acc (f i) (g i) norm pAddress qAddress (fixed.fImage i) (fixed.gImage i),?_,
    KeygenNormInvariant151.transfer s after p q n f g fixed frame rfl,FftLocalCells140.cell_at middle "u".toList _,?_,frame,rfl⟩
  · exact .procedure _ _ _ (C99LoopScalar141.increment _ middle "u".toList u (by omega) middleCounter)
  · rw [advance,dite_eq_left range]
    exact (FftLocalCells140.outside middle "u".toList "norm".toList _ (by decide)).trans
      (FftLocalCells140.cell_at one "norm".toList _)

end FT1536.Source3.KeygenNormStep151
