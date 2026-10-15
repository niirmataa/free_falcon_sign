import Source3.FftCertifiedTwiddle153
import Source3.SelectedFftImages152

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLiteralPass153

def middle (n hn t m : Nat) (length : 2*hn≤n) (input : Fin n → BitVec 64) (i : Fin n) : BitVec 64 :=
  let k := FftOuterLocal152.owner hn t i
  if k<m/2 then
    let v := FftGroupValues152.owner hn (t/2) (k*t) i
    if k*t≤v ∧ v<k*t+t/2 then
      FftLoopStep141.advance n hn (t/2) v length (FftCertifiedTwiddle153.pair .square (m+k)).1
        (FftCertifiedTwiddle153.pair .square (m+k)).2 input i else input i
  else input i

theorem middle_source (n hn t m : Nat) (length : 2*hn≤n) (input : Fin n → BitVec 64) :
    middle n hn t m length input=FftOuterValues152.image n hn t m length input := by
  funext i
  simp only [middle,FftOuterValues152.image,FftGroupValues152.image,FftCertifiedTwiddle153.square]

def tripleData (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64)
    (c : FftTripleBody147.Constants) : FftTripleWords147.Inputs :=
  ⟨input (FftTripleLoadShape147.slot n hn u inside length 0),input (FftTripleLoadShape147.slot n hn u inside length 1),
   input (FftTripleLoadShape147.slot n hn u inside length 2),input (FftTripleLoadShape147.slot n hn u inside length 3),
   input (FftTripleLoadShape147.slot n hn u inside length 4),input (FftTripleLoadShape147.slot n hn u inside length 5),
   (FftCertifiedTwiddle153.pair .cubic q).1,(FftCertifiedTwiddle153.pair .cubic q).2,c.w2r,c.w2i,c.w4r,c.w4i⟩

theorem data_source (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64) (c : FftTripleBody147.Constants) :
    tripleData n hn u q inside length input c=FftTripleLocal147.data n hn u q inside length input c.w2r c.w2i c.w4r c.w4i := by
  unfold tripleData FftTripleLocal147.data
  rw [FftCertifiedTwiddle153.cubic]

def tripleStep (c : FftTripleBody147.Constants) (k : Nat) (input : Fin 1536 → BitVec 64) : Fin 1536 → BitVec 64 :=
  if range : k<256 then FftTripleWrites147.values 1536 768 (3*k) (by omega) (by decide)
    (tripleData 1536 768 (3*k) (512+k) (by omega) (by decide) input c) input else input

theorem step_source (c : FftTripleBody147.Constants) (k : Nat) (input : Fin 1536 → BitVec 64) :
    tripleStep c k input=FftTriplingStep148.advance c k input := by
  unfold tripleStep FftTriplingStep148.advance
  split_ifs
  · rw [data_source]
    rfl
  · rfl

def tripling (c : FftTripleBody147.Constants) (input : Fin 1536 → BitVec 64) (i : Fin 1536) : BitVec 64 :=
  tripleStep c (FftTriplingValues152.owner i) input i

theorem tripling_source (c : FftTripleBody147.Constants) (input : Fin 1536 → BitVec 64) :
    tripling c input=FftTriplingValues152.image c input := by
  funext i
  exact congrFun (step_source c (FftTriplingValues152.owner i) input) i

end FT1536.Source3.FftLiteralPass153
