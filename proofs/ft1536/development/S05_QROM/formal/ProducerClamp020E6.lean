import ProducerWordLaws020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerClamp020E6
open WordRAM020

theorem word_toInt (w : Word) : word w.toInt=w := BitVec.ofInt_toInt

theorem clamp (w : Word) : (if WordRAM020.op .lt w 0=0 then w else 0)=word w.toInt.toNat := by
  have hz : (0 : Word).toInt=0 := rfl
  change (if word (if w.toInt<(0 : Word).toInt then 1 else 0)=0 then w else 0)=_
  rw [hz]
  by_cases h : w.toInt<0
  · rw [ite_eq_left h]
    have hto : w.toInt.toNat=0 := Int.toNat_of_nonpos (le_of_lt h)
    rw [hto]
    rfl
  · rw [ite_eq_right h]
    have hto : (w.toInt.toNat : Int)=w.toInt := Int.toNat_of_nonneg (by omega)
    rw [hto,word_toInt]
    rfl

end FT1536.S05.ProducerClamp020E6
