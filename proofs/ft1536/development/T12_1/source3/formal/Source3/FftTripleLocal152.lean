import Source3.FftTripleBody147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleLocal152
open FftTripleIndices146 (realSlot imagSlot)
open C99WordBuffer140 (updated)

theorem writes_outside (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n)
    (x : FftTripleWords147.Inputs) (input : Fin n → BitVec 64) (i : Fin n)
    (real : ∀ j, i≠realSlot n hn u inside length j) (imag : ∀ j, i≠imagSlot n hn u inside length j) :
    FftTripleWrites147.values n hn u inside length x input i=input i := by
  simp only [FftTripleWrites147.values,FftTripleStore146.values,C99TwoWordBuffer146.values,updated,
    ite_eq_right (imag 2),ite_eq_right (real 2),ite_eq_right (imag 1),ite_eq_right (real 1),ite_eq_right (imag 0),ite_eq_right (real 0)]

theorem writes_locality (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n)
    (x : FftTripleWords147.Inputs) (input other : Fin n → BitVec 64) (i : Fin n) (same : input i=other i) :
    FftTripleWrites147.values n hn u inside length x input i=FftTripleWrites147.values n hn u inside length x other i := by
  simp only [FftTripleWrites147.values,FftTripleStore146.values,C99TwoWordBuffer146.values,updated,same]

theorem data_same (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input other : Fin n → BitVec 64)
    (c : FftTripleBody147.Constants) (agree : ∀ j, input (FftTripleLoadShape147.slot n hn u inside length j)=other (FftTripleLoadShape147.slot n hn u inside length j)) :
    FftTripleLocal147.data n hn u q inside length input c.w2r c.w2i c.w4r c.w4i=
      FftTripleLocal147.data n hn u q inside length other c.w2r c.w2i c.w4r c.w4i := by
  unfold FftTripleLocal147.data
  rw [agree 0,agree 1,agree 2,agree 3,agree 4,agree 5]

theorem locality (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input other : Fin n → BitVec 64)
    (c : FftTripleBody147.Constants) (i : Fin n) (same : input i=other i)
    (agree : ∀ j, input (FftTripleLoadShape147.slot n hn u inside length j)=other (FftTripleLoadShape147.slot n hn u inside length j)) :
    FftTripleBody147.values n hn u q inside length input c i=FftTripleBody147.values n hn u q inside length other c i := by
  unfold FftTripleBody147.values
  rw [data_same n hn u q inside length input other c agree]
  exact writes_locality n hn u inside length _ input other i same

end FT1536.Source3.FftTripleLocal152
