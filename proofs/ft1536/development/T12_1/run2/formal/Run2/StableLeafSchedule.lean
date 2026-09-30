import Run2.StableLeafAlgebra

namespace FT1536.Run2.StableLeafSchedule
open StableLeafAlgebra

def tripleMap (f : ℝ → ℝ → ℝ → ℝ) : List ℝ → List ℝ
  | a::b::c::xs => f a b c::tripleMap f xs
  | _ => []

theorem tripleMap_length (f : ℝ → ℝ → ℝ → ℝ) : ∀ xs : List ℝ,
    (tripleMap f xs).length=xs.length/3
  | [] => rfl
  | [_] => by simp [tripleMap]
  | [_,_] => by simp [tripleMap]
  | a::b::c::xs => by
    simp only [tripleMap, List.length_cons, tripleMap_length f xs]
    omega

theorem tripleMap_positive (f : ℝ → ℝ → ℝ → ℝ)
    (hf : ∀ a b c, 0<a → 0<b → 0<c → 0<f a b c) :
    ∀ xs : List ℝ, Positive xs → Positive (tripleMap f xs)
  | [], _ => by simp [tripleMap, Positive]
  | [_], _ => by simp [tripleMap, Positive]
  | [_,_], _ => by simp [tripleMap, Positive]
  | a::b::c::xs, hp => by
    intro z hz
    have ht : Positive xs := fun x hx => hp x (by simp [hx])
    simp only [tripleMap, List.mem_cons] at hz
    rcases hz with rfl | hz
    · exact hf a b c (hp a (by simp)) (hp b (by simp)) (hp c (by simp))
    · exact tripleMap_positive f hf xs ht z hz

theorem tripleMap_reciprocal {q : ℝ} (hq : 0<q) : ∀ xs : List ℝ, Positive xs →
    tripleMap ternary0 (reciprocal q xs)=reciprocal q (tripleMap ternary2 xs) ∧
    tripleMap ternary1 (reciprocal q xs)=reciprocal q (tripleMap ternary1 xs) ∧
    tripleMap ternary2 (reciprocal q xs)=reciprocal q (tripleMap ternary0 xs)
  | [], _ => by simp [tripleMap, reciprocal]
  | [_], _ => by simp [tripleMap, reciprocal]
  | [_,_], _ => by simp [tripleMap, reciprocal]
  | a::b::c::xs, hp => by
    have ht : Positive xs := fun x hx => hp x (by simp [hx])
    have hr := ternary_reciprocal hq (hp a (by simp)) (hp b (by simp)) (hp c (by simp))
    have ih := tripleMap_reciprocal hq xs ht
    simp only [reciprocal, List.map_cons, tripleMap] at ih ⊢
    constructor
    · rw [hr.1, ih.1]
    constructor
    · rw [hr.2.1, ih.2.1]
    · rw [hr.2.2, ih.2.2]

/- The three contiguous source branches, each followed by n binary levels. -/
noncomputable def primary (n : ℕ) (roots : List ℝ) : List ℝ :=
  binaryLeaves n (tripleMap ternary0 roots) ++
    binaryLeaves n (tripleMap ternary1 roots) ++
    binaryLeaves n (tripleMap ternary2 roots)

theorem primary_positive (n : ℕ) (roots : List ℝ) (hp : Positive roots) :
    Positive (primary n roots) := by
  have h0 := tripleMap_positive ternary0 (fun _ _ _ ha hb hc => (ternary_positive ha hb hc).1) roots hp
  have h1 := tripleMap_positive ternary1 (fun _ _ _ ha hb hc => (ternary_positive ha hb hc).2.1) roots hp
  have h2 := tripleMap_positive ternary2 (fun _ _ _ ha hb hc => (ternary_positive ha hb hc).2.2) roots hp
  intro z hz
  simp only [primary, List.mem_append] at hz
  rcases hz with (hz | hz) | hz
  · exact binary_positive n _ h0 z hz
  · exact binary_positive n _ h1 z hz
  · exact binary_positive n _ h2 z hz

theorem primary_length (n : ℕ) (roots : List ℝ) (hlen : roots.length=3*2^n) :
    (primary n roots).length=3*2^n := by
  have h (f : ℝ → ℝ → ℝ → ℝ) : (tripleMap f roots).length=2^n := by
    rw [tripleMap_length, hlen]
    omega
  simp only [primary, List.length_append, binary_length n _ (h _)]
  omega

theorem primary_reciprocal (n : ℕ) (q : ℝ) (hq : 0<q) (roots : List ℝ)
    (hp : Positive roots) (hlen : roots.length=3*2^n) :
    primary n (reciprocal q roots)=reciprocal q (primary n roots).reverse := by
  have hlen' (f : ℝ → ℝ → ℝ → ℝ) : (tripleMap f roots).length=2^n := by
    rw [tripleMap_length, hlen]
    omega
  have h0 := tripleMap_positive ternary0 (fun _ _ _ ha hb hc => (ternary_positive ha hb hc).1) roots hp
  have h1 := tripleMap_positive ternary1 (fun _ _ _ ha hb hc => (ternary_positive ha hb hc).2.1) roots hp
  have h2 := tripleMap_positive ternary2 (fun _ _ _ ha hb hc => (ternary_positive ha hb hc).2.2) roots hp
  have hr := tripleMap_reciprocal hq roots hp
  rw [primary, hr.1, hr.2.1, hr.2.2,
    binary_reciprocal n q hq _ h2 (hlen' _), binary_reciprocal n q hq _ h1 (hlen' _),
    binary_reciprocal n q hq _ h0 (hlen' _)]
  simp only [primary, List.reverse_append, reciprocal, List.map_append, List.append_assoc]

noncomputable def full (q : ℝ) (n : ℕ) (roots : List ℝ) : List ℝ :=
  primary n roots ++ reciprocal q (primary n roots).reverse

theorem full_length (q : ℝ) (n : ℕ) (roots : List ℝ) (hlen : roots.length=3*2^n) :
    (full q n roots).length=2*(3*2^n) := by
  simp only [full, List.length_append, reciprocal, List.length_map, List.length_reverse,
    primary_length n roots hlen]
  omega

theorem full_positive (q : ℝ) (hq : 0<q) (n : ℕ) (roots : List ℝ) (hp : Positive roots) :
    Positive (full q n roots) := by
  have hl := primary_positive n roots hp
  have hr : Positive (primary n roots).reverse := fun x hx => hl x (List.mem_reverse.mp hx)
  intro x hx
  rcases List.mem_append.mp hx with hx | hx
  · exact hl x hx
  · exact reciprocal_positive hq hr x hx

theorem reciprocal_twice (q : ℝ) (hq : q≠0) (xs : List ℝ) :
    reciprocal q (reciprocal q xs)=xs := by
  simp only [reciprocal, List.map_map, Function.comp_def]
  have he : (fun x : ℝ => q/(q/x))=id := by
    funext x
    change q/(q/x)=x
    by_cases hx : x=0
    · simp [hx]
    · field_simp
  rw [he, List.map_id]

theorem full_reciprocal (q : ℝ) (hq : q≠0) (n : ℕ) (roots : List ℝ) :
    reciprocal q (full q n roots)=(full q n roots).reverse := by
  rw [full]
  rw [show reciprocal q (primary n roots ++ reciprocal q (primary n roots).reverse)=
      reciprocal q (primary n roots) ++ reciprocal q (reciprocal q (primary n roots).reverse) by
    exact List.map_append ..]
  rw [reciprocal_twice q hq]
  simp only [List.reverse_append, reciprocal, List.map_reverse, List.reverse_reverse]

theorem full_lower_gives_upper (q : ℝ) (hq : 0<q) (n : ℕ) (roots : List ℝ)
    (lower : ∀ x∈full q n roots, (991 : ℝ)≤x) :
    ∀ x∈full q n roots, x≤q/991 := by
  intro x hx
  have hpos : 0<x := by linarith [lower x hx]
  have hm : q/x∈reciprocal q (full q n roots) := List.mem_map.mpr ⟨x,hx,rfl⟩
  rw [full_reciprocal q (ne_of_gt hq)] at hm
  have hr := lower (q/x) (List.mem_reverse.mp hm)
  have hh := (le_div_iff₀ hpos).mp hr
  apply (le_div_iff₀ (by norm_num : (0 : ℝ)<991)).2
  simpa only [mul_comm] using hh

theorem ft1536_primary_length (roots : List ℝ) (hlen : roots.length=768) :
    (primary 8 roots).length=768 := by
  exact primary_length 8 roots (by simpa using hlen)

theorem ft1536_full_length (roots : List ℝ) (hlen : roots.length=768) :
    (full (18433^2) 8 roots).length=1536 := by
  exact full_length (18433^2) 8 roots (by simpa using hlen)

end FT1536.Run2.StableLeafSchedule
