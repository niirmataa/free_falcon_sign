import Source3.KeygenIntermediateParser

namespace FT1536.Source3.KeygenSourceLines
theorem slice (source expected : List String) (start : Nat)
    (entries : ∀ i : Fin expected.length, source[start+i.val]?=expected[i.val]?) :
    (source.drop start).take expected.length=expected := by
  apply List.ext_getElem?
  intro i
  by_cases h : i<expected.length
  · simpa only [List.getElem?_take,List.getElem?_drop,h,reduceIte] using entries ⟨i,h⟩
  · simp only [List.getElem?_take,h,reduceIte]
    exact (List.getElem?_eq_none (Nat.le_of_not_gt h)).symm
theorem consSlice (source : List String) (start : Nat) (head : String) (tail : List String)
    (first : source[start]?=some head)
    (rest : (source.drop (start+1)).take tail.length=tail) :
    (source.drop start).take (head::tail).length=head::tail := by
  have hf : (source.drop start)[0]?=some head := by
    simpa only [List.getElem?_drop,Nat.add_zero] using first
  have hd : source.drop (start+1)=(source.drop start).drop 1 := by rw [List.drop_drop]
  cases hs : source.drop start with
  | nil => simp only [hs,List.getElem?_nil] at hf; cases hf
  | cons x xs =>
    have hx : x=head := Option.some.inj (by simpa only [hs,List.getElem?_cons_zero] using hf)
    subst x
    rw [hs] at hd
    change source.drop (start+1)=xs at hd
    rw [hd] at rest
    simpa only [hs,List.length_cons,List.take_succ_cons] using congrArg (head::·) rest
end FT1536.Source3.KeygenSourceLines
