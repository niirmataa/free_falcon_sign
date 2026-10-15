import Source3.FftButterflyBuffer140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftButterflyLocal152
open C99WordBuffer140 (updated)

theorem outside {n : Nat} (v : Fin n → BitVec 64) (slots : Fin 4 → Fin n) (sr si : BitVec 64) (i : Fin n)
    (different : ∀ j, i≠slots j) : FftButterflyBuffer140.nextValues v slots sr si i=v i := by
  simp only [FftButterflyBuffer140.nextValues,C99FourWordBuffer140.values,updated,
    ite_eq_right (different 3),ite_eq_right (different 2),ite_eq_right (different 1),ite_eq_right (different 0)]

theorem locality {n : Nat} (v w : Fin n → BitVec 64) (slots : Fin 4 → Fin n) (sr si : BitVec 64) (i : Fin n)
    (agree : ∀ j, v (slots j)=w (slots j)) (same : v i=w i) :
    FftButterflyBuffer140.nextValues v slots sr si i=FftButterflyBuffer140.nextValues w slots sr si i := by
  have operands : FftButterflyBuffer140.operands v slots=FftButterflyBuffer140.operands w slots := by
    unfold FftButterflyBuffer140.operands
    rw [agree 0,agree 1,agree 2,agree 3]
  simp only [FftButterflyBuffer140.nextValues,operands,C99FourWordBuffer140.values,updated,same]

end FT1536.Source3.FftButterflyLocal152
