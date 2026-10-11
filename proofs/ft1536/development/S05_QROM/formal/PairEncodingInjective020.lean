import PairEncoding020
import Mathlib.Data.List.OfFn

namespace FT1536.S05.PairEncodingInjective020
open PairEncoding020 FT1536.Relation FT1536.PublicSimulation FT1536.Run2.BitArithmetic

/-- Uniform block lengths make flattening lossless at a fixed block count. -/
theorem flatten_injective (xs ys : List (List Bool)) (n : Nat)
    (hx : ∀ x ∈ xs, x.length=n) (hy : ∀ y ∈ ys, y.length=n)
    (hl : xs.length=ys.length) (he : xs.flatten=ys.flatten) : xs=ys := by
  induction xs generalizing ys with
  | nil =>
    have h : ys=[] := List.eq_nil_of_length_eq_zero (by simpa using hl.symm)
    exact h.symm
  | cons x xs ih =>
    cases ys with
    | nil => simp at hl
    | cons y ys =>
      have hb := List.append_inj he (by rw [hx x (by simp),hy y (by simp)])
      have ht := ih ys (fun a ha => hx a (by simp [ha]))
        (fun a ha => hy a (by simp [ha])) (by simpa using hl) hb.2
      exact congrArg₂ List.cons hb.1 ht

theorem keyCell_injective (c d : Rq) (i : Fin 768) (he : keyCell c i=keyCell d i) : c i=d i := by
  have h := List.append_inj he (by simp only [encodeNat_length])
  apply Prod.ext
  · apply ZMod.val_injective
    have hv := congrArg value h.1
    simpa only [field_word_exact] using hv
  · apply ZMod.val_injective
    have hv := congrArg value h.2
    simpa only [field_word_exact] using hv

theorem replyCell_injective (z w : BoxVec) (i : Fin 768) (he : replyCell z i=replyCell w i) : z i=w i := by
  have h := List.append_inj he (by simp only [encodeNat_length])
  apply Prod.ext
  · apply Fin.ext
    have hv := congrArg value h.1
    simpa only [box_word_exact] using hv
  · apply Fin.ext
    have hv := congrArg value h.2
    simpa only [box_word_exact] using hv

theorem keyBits_injective : Function.Injective keyBits := by
  intro c d he
  have hc (x : List Bool) (h : x ∈ List.ofFn (keyCell c)) : x.length=32 := by
    rcases List.mem_ofFn.mp h with ⟨i,rfl⟩
    exact keyCell_length c i
  have hd (x : List Bool) (h : x ∈ List.ofFn (keyCell d)) : x.length=32 := by
    rcases List.mem_ofFn.mp h with ⟨i,rfl⟩
    exact keyCell_length d i
  have hl := flatten_injective _ _ 32 hc hd (by simp only [List.length_ofFn]) he
  have hf := List.ofFn_injective hl
  funext i
  exact keyCell_injective c d i (congrFun hf i)

theorem replyBits_injective : Function.Injective replyBits := by
  intro z w he
  have hz (x : List Bool) (h : x ∈ List.ofFn (replyCell z)) : x.length=34 := by
    rcases List.mem_ofFn.mp h with ⟨i,rfl⟩
    exact replyCell_length z i
  have hw (x : List Bool) (h : x ∈ List.ofFn (replyCell w)) : x.length=34 := by
    rcases List.mem_ofFn.mp h with ⟨i,rfl⟩
    exact replyCell_length w i
  have hl := flatten_injective _ _ 34 hz hw (by simp only [List.length_ofFn]) he
  have hf := List.ofFn_injective hl
  funext i
  exact replyCell_injective z w i (congrFun hf i)

theorem full_pair_injective : Function.Injective PairEncoding020.encode := by
  rintro ⟨c,x⟩ ⟨d,y⟩ he
  have h := List.append_inj he (by rw [keyBits_length,keyBits_length])
  have hc : c=d := keyBits_injective h.1
  subst d
  cases x with
  | none =>
    cases y with
    | none => rfl
    | some z => exact False.elim (no_failure_erasure c c z he)
  | some z =>
    cases y with
    | none => exact False.elim (no_failure_erasure c c z he.symm)
    | some w =>
      have hr : replyBits z=replyBits w := List.cons.inj h.2 |>.2
      have hz := replyBits_injective hr
      subst w
      rfl

end FT1536.S05.PairEncodingInjective020
