import InputLayout020
import IndexReference020D
import Residue020D

namespace FT1536.S05.KeyWords020D
open WordRAM020 Interleaved020D IndexReference020D Residue020D
open FT1536.Relation FT1536.Run2.PolynomialReference

def keySlot (j : Fin 1536) : Fin romSize :=
  ⟨92162+exponentN j.val,by have := exponent_bound j.val j.isLt;unfold romSize;omega⟩

theorem first_word (h : Rq) (j : Fin 768) :
    InputLayout020.image h ⟨92162+j.val,by have := j.isLt;unfold romSize;omega⟩=fw (h j).1 :=
  BitVec.eq_of_toInt_eq ((InputLayout020.key_first_exact h j).trans (decode_fw (h j).1).symm)

theorem second_word (h : Rq) (j : Fin 768) :
    InputLayout020.image h ⟨92930+j.val,by have := j.isLt;unfold romSize;omega⟩=fw (h j).2 :=
  BitVec.eq_of_toInt_eq ((InputLayout020.key_second_exact h j).trans (decode_fw (h j).2).symm)

theorem key_word (h : Rq) (j : Fin 1536) :
    InputLayout020.image h (keySlot j)=fw (coefficient h (term j)) := by
  rw [coefficient_eq]
  rcases parity j.val with he|he
  · have hi : keySlot j=(⟨92162+(pairIndex j).val,by have := (pairIndex j).isLt;unfold romSize;omega⟩:Fin romSize) := by
      apply Fin.ext
      change 92162+(j.val/2+(j.val%2)*768)=92162+j.val/2
      rw [he];omega
    rw [hi,ite_eq_left he]
    exact first_word h (pairIndex j)
  · have hi : keySlot j=(⟨92930+(pairIndex j).val,by have := (pairIndex j).isLt;unfold romSize;omega⟩:Fin romSize) := by
      apply Fin.ext
      change 92162+(j.val/2+(j.val%2)*768)=92930+j.val/2
      rw [he];omega
    rw [hi,ite_eq_right (show j.val%2≠0 by omega)]
    exact second_word h (pairIndex j)

end FT1536.S05.KeyWords020D
