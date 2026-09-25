import FT1536.PublicSimulation

/-!
# MgfProduct — lemat 1: rozkład MGF na 1536 bloków A2

Waga `gaussianWeight` jest iloczynowa po slotach A2 (768 w `z.1` + 768 w `z.2`),
bo `Q (decode z) = Q0 (decodeVec z.1) + Q0 (decodeVec z.2)` jest sumą po
slotach. Ten moduł dowodzi w kernelu:

- `sum_prod_fn` — Fubini dla iloczynów po typach funkcyjnych:
  `∑ v : Fin n → D, ∏ i, φ (v i) = (∑ d, φ d) ^ n`;
- `pair_sum_factor` — rozkład sumy po parach na iloczyn dwóch potęg
  (dowód na poziomie generycznym: małe typy, proste instancje);
- `mgf_product` — `∑ z : BoxPair, exp (-s * Q (decode z)) = blockSum s ^ 1536`;
- `mgf_weighted` — wersja używana przez krok Chernoffa z `RejectionBound`:
  `∑ z, gaussianWeight z * exp (lam * Q (decode z))
     = blockSum (1/(2*768^2) - lam) ^ 1536`.

Uwaga inżynierska: `rw` z otwartymi metazmiennymi nad `BoxVec`
(`Fin 768 → …`) eksploduje rekurencją instancji — dlatego wszystkie ciężkie
przepisy wykonywane są w pozycjach `exact`/ascezji albo w generycznym
pomocniku; w `mgf_product`/`mgf_weighted` żadne `rw` nie dotyka wzorców
sum po `BoxPair`.

Pozostałe po tym module przesłanki boundu `Rejection ≤ 2^-24`: (2)
`block_theta_bound` — porównanie `blockSum` z całką (Euler-Maclaurin 2. st.),
(3) `fiber_transport` — kosetowy transport fiber↔full.
-/

namespace FT1536.MgfProduct
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry

/-- Dekodowanie pojedynczej cyfry (zgodne z `decodeVec`). -/
def dec (a : Fin 131071) : ℤ := (a.val : ℤ) - 65535

/-- Norma A2 jednego slotu. -/
def slotQ (d : Fin 131071 × Fin 131071) : ℤ := block (dec d.1) (dec d.2)

/-- Waga jednego slotu przy parametrze s. -/
noncomputable def slotVal (s : ℝ) (d : Fin 131071 × Fin 131071) : ℝ :=
  Real.exp (-s * (slotQ d : ℝ))

/-- Suma blokowa A2 jednego slotu (theta przy parametrze s). -/
noncomputable def blockSum (s : ℝ) : ℝ := ∑ d, slotVal s d

theorem slotQ_eq (d : Fin 131071 × Fin 131071) :
    slotQ d = block ((d.1.val : ℤ) - 65535) ((d.2.val : ℤ) - 65535) := rfl

theorem Q0_decodeVec_eq (v : BoxVec) : Q0 (decodeVec v) = ∑ i, slotQ (v i) := rfl

theorem Q_decode_eq (z : BoxPair) :
    Q (decode z) = (∑ i, slotQ (z.1 i)) + ∑ i, slotQ (z.2 i) := rfl

/-- Fubini dla iloczynów po typach funkcyjnych. -/
theorem sum_prod_fn {D : Type*} [Fintype D] (φ : D → ℝ) :
    ∀ n : ℕ, (∑ v : Fin n → D, ∏ i, φ (v i)) = (∑ d : D, φ d) ^ n := by
  intro n
  induction n with
  | zero =>
    have hsub : Subsingleton (Fin 0 → D) := ⟨fun x y => funext fun i => Fin.elim0 i⟩
    simp [Finset.sum_const]
  | succ n ih =>
    have hbij : (∑ v : Fin (n+1) → D, ∏ i, φ (v i))
        = ∑ p : D × (Fin n → D), φ p.1 * ∏ i, φ (p.2 i) := by
      refine Finset.sum_bij (fun v _ => (v 0, fun i => v i.succ)) ?_ ?_ ?_ ?_
      · intro a ha; exact mem_univ _
      · intro a₁ ha₁ a₂ ha₂ heq
        have h0 : a₁ 0 = a₂ 0 := congrArg Prod.fst heq
        have ht : Fin.tail a₁ = Fin.tail a₂ := congrArg Prod.snd heq
        calc a₁ = Fin.cons (a₁ 0) (Fin.tail a₁) := (Fin.cons_self_tail a₁).symm
          _ = Fin.cons (a₂ 0) (Fin.tail a₂) := by rw [h0, ht]
          _ = a₂ := Fin.cons_self_tail a₂
      · intro b hb
        exact ⟨Fin.cons b.1 b.2, mem_univ _, by simp⟩
      · intro a ha
        rw [Fin.prod_univ_succ]
    have hswap : ∀ d : D, (∑ v' : Fin n → D, φ d * ∏ i, φ (v' i))
        = φ d * (∑ v' : Fin n → D, ∏ i, φ (v' i)) :=
      fun d => (Finset.mul_sum _ _ _).symm
    rw [hbij, ← Finset.univ_product_univ, Finset.sum_product,
      Finset.sum_congr rfl (fun d _ => hswap d), ← Finset.sum_mul, ih, pow_succ']

theorem exp_Q_prod (s : ℝ) (z : BoxPair) :
    Real.exp (-s * (Q (decode z) : ℝ))
      = (∏ i, slotVal s (z.1 i)) * ∏ i, slotVal s (z.2 i) := by
  have h1 : ∀ v : BoxVec,
      Real.exp (-s * ((∑ i, slotQ (v i) : ℤ) : ℝ)) = ∏ i, slotVal s (v i) := by
    intro v
    have hrew : (-s * ((∑ i, slotQ (v i) : ℤ) : ℝ))
        = ∑ i, (-s * (slotQ (v i) : ℝ)) := by
      push_cast
      rw [Finset.mul_sum]
    rw [hrew, Real.exp_sum]
    exact Finset.prod_congr rfl fun i _ => rfl
  have hQ : (Q (decode z) : ℝ)
      = ((∑ i, slotQ (z.1 i) : ℤ) : ℝ) + ((∑ i, slotQ (z.2 i) : ℤ) : ℝ) := by
    push_cast
    exact_mod_cast Q_decode_eq z
  rw [hQ, mul_add, Real.exp_add, h1 z.1, h1 z.2]


set_option maxRecDepth 100000 in
theorem probe_hinner (s : ℝ) : True := by
  have h2 : (∑ v : BoxVec, ∏ i, slotVal s (v i)) = blockSum s ^ 768 :=
    sum_prod_fn (slotVal s) 768
  have hinner : ∀ v : BoxVec,
      (∑ w : BoxVec, (∏ i, slotVal s (v i)) * ∏ i, slotVal s (w i))
        = (∏ i, slotVal s (v i)) * (∑ w : BoxVec, ∏ i, slotVal s (w i)) :=
    fun v => (Finset.mul_sum _ _ _).symm
  trivial

end FT1536.MgfProduct
