import FT1536.Basic

namespace FT1536.Run2.StableLeafAlgebra

noncomputable def average (a b : ℝ) : ℝ := (a+b)/2
noncomputable def harmonic (a b : ℝ) : ℝ := 2*a*b/(a+b)

theorem average_pos {a b : ℝ} (ha : 0<a) (hb : 0<b) : 0<average a b := by
  unfold average
  positivity

theorem harmonic_pos {a b : ℝ} (ha : 0<a) (hb : 0<b) : 0<harmonic a b := by
  unfold harmonic
  positivity

theorem average_reciprocal {q a b : ℝ} (ha : 0<a) (hb : 0<b) :
    average (q/a) (q/b)=q/harmonic a b := by
  unfold average harmonic
  field_simp
  ring

theorem harmonic_reciprocal {q a b : ℝ} (hq : 0<q) (ha : 0<a) (hb : 0<b) :
    harmonic (q/a) (q/b)=q/average a b := by
  unfold harmonic average
  have hab : a+b≠0 := ne_of_gt (add_pos ha hb)
  have hqab : q/a+q/b≠0 := ne_of_gt (add_pos (div_pos hq ha) (div_pos hq hb))
  field_simp
  ring

def pairMap (f : ℝ → ℝ → ℝ) : List ℝ → List ℝ
  | a::b::xs => f a b::pairMap f xs
  | _ => []

def Positive (xs : List ℝ) : Prop := ∀ x∈xs, 0<x
noncomputable def reciprocal (q : ℝ) (xs : List ℝ) : List ℝ := xs.map (fun x => q/x)

theorem pairMap_length (f : ℝ → ℝ → ℝ) : ∀ xs : List ℝ,
    (pairMap f xs).length=xs.length/2
  | [] => rfl
  | [_] => by simp [pairMap]
  | a::b::xs => by
    simp only [pairMap, List.length_cons, pairMap_length f xs]
    omega

theorem pairMap_positive (f : ℝ → ℝ → ℝ) (hf : ∀ a b, 0<a → 0<b → 0<f a b) :
    ∀ xs : List ℝ, Positive xs → Positive (pairMap f xs)
  | [], _ => by simp [pairMap, Positive]
  | [_], _ => by simp [pairMap, Positive]
  | a::b::xs, hp => by
    intro z hz
    have ht : Positive xs := fun x hx => hp x (by simp [hx])
    simp only [pairMap, List.mem_cons] at hz
    rcases hz with rfl | hz
    · exact hf a b (hp a (by simp)) (hp b (by simp))
    · exact pairMap_positive f hf xs ht z hz

theorem reciprocal_positive {q : ℝ} (hq : 0<q) {xs : List ℝ} (hp : Positive xs) :
    Positive (reciprocal q xs) := by
  intro z hz
  obtain ⟨x,hx,rfl⟩ := List.mem_map.mp hz
  exact div_pos hq (hp x hx)

theorem pairMap_reciprocal {q : ℝ} (hq : 0<q) : ∀ xs : List ℝ, Positive xs →
    pairMap average (reciprocal q xs)=reciprocal q (pairMap harmonic xs) ∧
    pairMap harmonic (reciprocal q xs)=reciprocal q (pairMap average xs)
  | [], _ => by simp [pairMap, reciprocal]
  | [_], _ => by simp [pairMap, reciprocal]
  | a::b::xs, hp => by
    have ha := hp a (by simp)
    have hb := hp b (by simp)
    have ht : Positive xs := fun x hx => hp x (by simp [hx])
    have ih := pairMap_reciprocal hq xs ht
    simp only [reciprocal, List.map_cons, pairMap] at ih ⊢
    constructor
    · rw [average_reciprocal ha hb, ih.1]
    · rw [harmonic_reciprocal hq ha hb, ih.2]

/- Source order: pair adjacent values, put averages in the first half and
   harmonic means in the second half, then recurse on the two halves. -/
noncomputable def binaryLeaves : ℕ → List ℝ → List ℝ
  | 0, xs => xs
  | n+1, xs => binaryLeaves n (pairMap average xs) ++ binaryLeaves n (pairMap harmonic xs)

theorem binary_positive (n : ℕ) (xs : List ℝ) (hp : Positive xs) :
    Positive (binaryLeaves n xs) := by
  induction n generalizing xs with
  | zero => exact hp
  | succ n ih =>
    intro z hz
    rcases List.mem_append.mp hz with hl | hr
    · exact ih _ (pairMap_positive average (fun _ _ => average_pos) xs hp) z hl
    · exact ih _ (pairMap_positive harmonic (fun _ _ => harmonic_pos) xs hp) z hr

theorem binary_length (n : ℕ) (xs : List ℝ) (hlen : xs.length=2^n) :
    (binaryLeaves n xs).length=2^n := by
  induction n generalizing xs with
  | zero => exact hlen
  | succ n ih =>
    have ha : (pairMap average xs).length=2^n := by
      rw [pairMap_length, hlen, Nat.pow_succ]
      omega
    have hh : (pairMap harmonic xs).length=2^n := by
      rw [pairMap_length, hlen, Nat.pow_succ]
      omega
    simp only [binaryLeaves, List.length_append, ih _ ha, ih _ hh, Nat.pow_succ]
    omega

theorem binary_reciprocal (n : ℕ) (q : ℝ) (hq : 0<q) (xs : List ℝ)
    (hp : Positive xs) (hlen : xs.length=2^n) :
    binaryLeaves n (reciprocal q xs)=reciprocal q (binaryLeaves n xs).reverse := by
  induction n generalizing xs with
  | zero =>
    have hl : xs.length=1 := by simpa using hlen
    obtain ⟨x,rfl⟩ := List.length_eq_one_iff.mp hl
    simp [binaryLeaves, reciprocal]
  | succ n ih =>
    have ha : (pairMap average xs).length=2^n := by
      rw [pairMap_length, hlen, Nat.pow_succ]
      omega
    have hh : (pairMap harmonic xs).length=2^n := by
      rw [pairMap_length, hlen, Nat.pow_succ]
      omega
    have hpa := pairMap_positive average (fun _ _ => average_pos) xs hp
    have hph := pairMap_positive harmonic (fun _ _ => harmonic_pos) xs hp
    rw [binaryLeaves, (pairMap_reciprocal hq xs hp).1, (pairMap_reciprocal hq xs hp).2,
      ih _ hph hh, ih _ hpa ha]
    simp only [binaryLeaves, List.reverse_append, reciprocal, List.map_append]

noncomputable def ternary0 (a b c : ℝ) : ℝ := (a+b+c)/3
noncomputable def ternary1 (a b c : ℝ) : ℝ := (a*b+a*c+b*c)/(a+b+c)
noncomputable def ternary2 (a b c : ℝ) : ℝ := 3*a*b*c/(a*b+a*c+b*c)

theorem ternary_positive {a b c : ℝ} (ha : 0<a) (hb : 0<b) (hc : 0<c) :
    0<ternary0 a b c ∧ 0<ternary1 a b c ∧ 0<ternary2 a b c := by
  unfold ternary0 ternary1 ternary2
  constructor
  · positivity
  constructor <;> positivity

theorem ternary_reciprocal {q a b c : ℝ} (hq : 0<q) (ha : 0<a) (hb : 0<b) (hc : 0<c) :
    ternary0 (q/a) (q/b) (q/c)=q/ternary2 a b c ∧
    ternary1 (q/a) (q/b) (q/c)=q/ternary1 a b c ∧
    ternary2 (q/a) (q/b) (q/c)=q/ternary0 a b c := by
  have he1 : a+b+c≠0 := ne_of_gt (by positivity)
  have he2 : a*b+a*c+b*c≠0 := ne_of_gt (by positivity)
  have hi1 : q/a+q/b+q/c≠0 := ne_of_gt (by positivity)
  have hi2 : q/a*(q/b)+q/a*(q/c)+q/b*(q/c)≠0 := ne_of_gt (by positivity)
  unfold ternary0 ternary1 ternary2
  constructor
  · field_simp
    ring
  constructor <;> field_simp <;> ring

end FT1536.Run2.StableLeafAlgebra
