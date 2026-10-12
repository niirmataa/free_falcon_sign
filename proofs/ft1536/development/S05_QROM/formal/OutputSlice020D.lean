import WordRAM020

namespace FT1536.S05.OutputSlice020D
open WordRAM020

/-- Functional specification of replacing one bounded contiguous output slice. -/
def write (out : Fin outputSize → Bool) (b : Nat) (xs : List Bool) : Fin outputSize → Bool := fun j =>
  if h : b≤j.val ∧ j.val<b+xs.length then
    have hk : j.val-b<xs.length := by omega
    xs[j.val-b]
  else out j

theorem write_nil (out : Fin outputSize → Bool) (b : Nat) : write out b []=out := by
  funext j
  simp only [write,List.length_nil,Nat.add_zero]
  rw [dite_eq_right (by omega)]

theorem write_at (out : Fin outputSize → Bool) (b : Nat) (xs : List Bool) (k : Nat)
    (hk : k<xs.length) (hb : b+xs.length≤outputSize) :
    write out b xs ⟨b+k,by omega⟩=xs[k] := by
  simp only [write]
  rw [dite_eq_left (show b≤b+k ∧ b+k<b+xs.length by omega)]
  simp only [Nat.add_sub_cancel_left]

theorem write_other (out : Fin outputSize → Bool) (b : Nat) (xs : List Bool) (j : Fin outputSize)
    (hj : j.val<b ∨ b+xs.length≤j.val) : write out b xs j=out j := by
  rw [write,dite_eq_right (by omega)]

theorem write_cons (out : Fin outputSize → Bool) (b : Nat) (bit : Bool) (xs : List Bool)
    (hb : b+1+xs.length≤outputSize) :
    write (Function.update out ⟨b,by omega⟩ bit) (b+1) xs=write out b (bit::xs) := by
  have baseOk : b<outputSize := by omega
  funext j
  by_cases he : j.val=b
  · have hf : j=(⟨b,baseOk⟩:Fin outputSize) := Fin.ext he
    subst j
    simp [write,Function.update]
  · by_cases hs : b+1≤j.val ∧ j.val<b+1+xs.length
    · have hs' : b≤j.val ∧ j.val<b+(bit::xs).length := by simp only [List.length_cons];omega
      rw [write,dite_eq_left hs,write,dite_eq_left hs']
      have hi : j.val-b=(j.val-(b+1))+1 := by omega
      simp only [hi,List.getElem_cons_succ]
    · have hs' : ¬(b≤j.val ∧ j.val<b+(bit::xs).length) := by simp only [List.length_cons];omega
      rw [write,dite_eq_right hs,write,dite_eq_right hs']
      simp [Function.update,show j≠(⟨b,baseOk⟩:Fin outputSize) from fun h => he (congrArg Fin.val h)]

end FT1536.S05.OutputSlice020D
