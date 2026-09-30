import Run2.RadialBinningSandwich
import Run2.RawProductLaw
import Run2.RawRadialEvents
import Run2.TriangularGaussian
import Run2.T5ScalarMass
import MgfProduct
import ConvolutionCert
import FinalTails

/-!
# ConvStruct — (b) splot strukturalny: faktoryzacja okna na splot 1535 bloków.

Cel tego pliku (L2 planu `PLAN_CONV_STRUCT.md`): sprowadzić `windowMassWin`
(na którym siedzą `engineGapLo/Hi` w `ConvolutionCert`) do jawnej postaci
iloczynowej na `blockLaw` — kształtu dla narzędzi MGF
(`MgfProduct.mgf_product`, `vector_product_sum_family`).

Uwaga konstrukcyjna (poprawka v1): `windowMassWin 0 b W` jest SFIBROWANE
w `z.1 0 = b`, więc postać splotowa zachowuje ten sam wskaźnik fibry
i tę samą asocjację `(∏·∏)/L` — dzięki czemu faktoryzacja jest punktowo
`rfl`. Niezależność od `b` i rozbiór Fubiniego na 1535 = osobne lematy
pod warstwę analityczną (tilt Craméra).
-/

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.ConvStruct

open Finset
open FT1536.Geometry
open FT1536.PublicSimulation
open FT1536.ConvolutionCert
open FT1536.MgfProduct
open FT1536.BlockTheta
open FT1536.FinalTails
open FT1536.Run2.RawProductLaw
open FT1536.Run2.RawRadialEvents
open FT1536.Run2.RadialWindowSplit
open FT1536.Run2.RadialBinningSandwich
open FT1536.Run2.RadialTriangleSplit
open FT1536.Run2.CenteringTriangle

/-- **Postać splotowa okna (sfibrowana)**: waga = iloczyn 1536 mas
    `blockLaw` ze skasowanym slotem 0 (iloraz — warunkowanie), okno `W`
    na energii reszty, wskaźnik fibry `z.1 0 = b` jak w `windowMassWin`. -/
noncomputable def restWindowMass (b : Block) (W : ℤ → Prop) : ℝ :=
  Finset.sum Finset.univ (fun z : BoxPair =>
    ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
      / blockLaw.mass (z.1 0))
      * indicator (z.1 0 = b ∧
          W ((∑ j, blockEnergy (z.1 j)) + (∑ j, blockEnergy (z.2 j))
            - blockEnergy (z.1 0))))

/-- Energia `before` = suma energii 1536 bloków (postać pod MGF). -/
theorem before_eq_energy_sum (z : BoxPair) :
    before z = (∑ j : Fin 768, blockEnergy (z.1 j))
        + (∑ j : Fin 768, blockEnergy (z.2 j)) := by
  simp only [before, Q, Q0, decode, decodeVec, blockEnergy, blockDecode]

/-- Energia reszty = suma 1536 bloków minus slot 0. -/
theorem restEnergy_eq (z : BoxPair) :
    restEnergy z 0 = (∑ j : Fin 768, blockEnergy (z.1 j))
        + (∑ j : Fin 768, blockEnergy (z.2 j)) - blockEnergy (z.1 0) := by
  rw [restEnergy, before_eq_energy_sum]

/-- Masa iloczynowa punktowo (REUSE `actual_mass_product`). -/
theorem mass_prod_pointwise (z : BoxPair) :
    rawLaw.mass z = (∏ j : Fin 768, blockLaw.mass (z.1 j))
        * (∏ j : Fin 768, blockLaw.mass (z.2 j)) := by
  rw [actual_mass_product]
  rfl

/-- **Faktoryzacja (L2)**: `windowMassWin 0 b W = restWindowMass b W` —
    punktowo `rfl` po `mass_prod_pointwise` i `restEnergy_eq`. -/
theorem windowMassWin_rest (b : Block) (W : ℤ → Prop) :
    windowMassWin 0 b W = restWindowMass b W := by
  classical
  simp only [windowMassWin, restWindowMass]
  apply Finset.sum_congr rfl
  intro z _
  rw [mass_prod_pointwise z, restEnergy_eq z]

/-- **Chernoff punktowy (elementwise)**: bez probabilistyki —
    dla `ℓ ≥ 0` i `T ≤ f i` zachodzi `1 ≤ exp(ℓ·(f i − T))`, więc
    wskaźnik okna półprostego zamienia się na moment wykładniczy.
    To jest postać pod `vector_product_sum_family` (mgf splotu). -/
theorem sum_indicator_exp_bound {ι : Type} [Fintype ι] (s : Finset ι)
    (w : ι → ℝ) (f : ι → ℝ) (T ℓ : ℝ)
    (hℓ : 0 ≤ ℓ) (hw : ∀ i ∈ s, 0 ≤ w i) :
    (∑ i ∈ s, w i * indicator (T ≤ f i))
      ≤ Real.exp (-ℓ * T) * ∑ i ∈ s, w i * Real.exp (ℓ * f i) := by
  classical
  have hpt : ∀ i ∈ s, w i * indicator (T ≤ f i)
      ≤ Real.exp (-ℓ * T) * (w i * Real.exp (ℓ * f i)) := by
    intro i hi
    unfold indicator
    by_cases h : T ≤ f i
    · simp only [h, ite_true, mul_one]
      have hx : 0 ≤ ℓ * (f i - T) := mul_nonneg hℓ (by linarith)
      have he : (1:ℝ) ≤ Real.exp (ℓ * (f i - T)) := Real.one_le_exp hx
      have hmain : (1:ℝ) * w i ≤ Real.exp (ℓ * (f i - T)) * w i :=
        mul_le_mul_of_nonneg_right he (hw i hi)
      calc w i = (1:ℝ) * w i := (one_mul _).symm
        _ ≤ Real.exp (ℓ * (f i - T)) * w i := hmain
        _ = Real.exp (-ℓ * T) * (w i * Real.exp (ℓ * f i)) := by
          have hsplit : ℓ * (f i - T) = ℓ * f i + (-ℓ * T) := by ring
          rw [hsplit, Real.exp_add]
          ring
    · simp only [h, ite_false, mul_zero]
      exact mul_nonneg (Real.exp_pos _).le (mul_nonneg (hw i hi) (Real.exp_pos _).le)
  calc (∑ i ∈ s, w i * indicator (T ≤ f i))
        ≤ ∑ i ∈ s, Real.exp (-ℓ * T) * (w i * Real.exp (ℓ * f i)) :=
          Finset.sum_le_sum hpt
    _ = Real.exp (-ℓ * T) * ∑ i ∈ s, w i * Real.exp (ℓ * f i) := by
          rw [Finset.mul_sum]

/-- **Moment splotu (krok 2 pod mgf)**: jednowektorowy moment wykładniczy
    energii rozkłada się na potęgę momentu jednoblokowego
    (`Real.exp_sum` + `vector_product_sum_family`). To jest dokładnie
    `mgf₁(ℓ)^768` — składnik `mgf_product` dla splotu 1535/1536. -/
theorem rest_moment_factor (ℓ : ℝ) :
    (∑ v : BoxVec, (∏ j, blockLaw.mass (v j))
        * Real.exp (ℓ * ∑ j, blockEnergy (v j)))
      = (∑ b : Block, blockLaw.mass b * Real.exp (ℓ * blockEnergy b))^768 := by
  classical
  have hexp : ∀ v : BoxVec, Real.exp (ℓ * ∑ j, blockEnergy (v j))
      = ∏ j, Real.exp (ℓ * blockEnergy (v j)) := by
    intro v
    push_cast
    rw [Finset.mul_sum, Real.exp_sum]
  have hpoint : ∀ v : BoxVec,
      (∏ j, blockLaw.mass (v j)) * Real.exp (ℓ * ∑ j, blockEnergy (v j))
        = ∏ j, (blockLaw.mass (v j) * Real.exp (ℓ * blockEnergy (v j))) := by
    intro v
    rw [hexp v]
    exact (Finset.prod_mul_distrib).symm
  calc (∑ v : BoxVec, (∏ j, blockLaw.mass (v j))
        * Real.exp (ℓ * ∑ j, blockEnergy (v j)))
      = ∑ v : BoxVec, ∏ j, (blockLaw.mass (v j)
          * Real.exp (ℓ * blockEnergy (v j))) :=
          Finset.sum_congr rfl (fun v _ => hpoint v)
    _ = (∏ i : Fin 768, ∑ b : Block,
          blockLaw.mass b * Real.exp (ℓ * blockEnergy b)) :=
          vector_product_sum_family (fun (_ : Fin 768) (b : Block) =>
            blockLaw.mass b * Real.exp (ℓ * blockEnergy b))
    _ = (∑ b : Block, blockLaw.mass b * Real.exp (ℓ * blockEnergy b))^768 := by
          simp only [Finset.prod_const, Finset.card_univ, Fintype.card_fin]

/-! ## Rozbiory głowica/ogon rodziny (`Fin.prod/sum_univ_succ`) -/

theorem prod_succ_split {D M : Type*} [Fintype D] [CommMonoid M] {k : ℕ}
    (t : D → M) (v : Fin (k+1) → D) :
    (∏ j : Fin (k+1), t (v j)) = t (v 0) * ∏ i : Fin k, t (v i.succ) :=
  Fin.prod_univ_succ (fun j => t (v j))

theorem sum_succ_split {D M : Type*} [Fintype D] [AddCommMonoid M] {k : ℕ}
    (t : D → M) (v : Fin (k+1) → D) :
    (∑ j : Fin (k+1), t (v j)) = t (v 0) + ∑ i : Fin k, t (v i.succ) :=
  Fin.sum_univ_succ (fun j => t (v j))

/-- Rozbiór rodziny przez głowicę `v 0` (wzorzec bijekcji z `MgfProduct.sum_prod_fn`). -/
theorem sum_head_tail {D : Type*} [Fintype D] (h g : D → ℝ) :
    ∀ n : ℕ, (∑ v : Fin (n+1) → D, h (v 0) * ∏ i : Fin n, g (v i.succ))
      = (∑ d : D, h d) * (∑ d : D, g d)^n := by
  intro n
  classical
  have hbij : (∑ v : Fin (n+1) → D, h (v 0) * ∏ i : Fin n, g (v i.succ))
      = Finset.sum Finset.univ
          (fun p : D × (Fin n → D) => h p.1 * ∏ i : Fin n, g (p.2 i)) := by
    refine Finset.sum_bij (fun v _ => (v 0, fun i => v i.succ)) ?_ ?_ ?_ ?_
    · intro a ha; exact Finset.mem_univ _
    · intro a₁ _ a₂ _ heq
      have h0 : a₁ 0 = a₂ 0 := congrArg Prod.fst heq
      have ht : Fin.tail a₁ = Fin.tail a₂ := congrArg Prod.snd heq
      calc a₁ = Fin.cons (a₁ 0) (Fin.tail a₁) := (Fin.cons_self_tail a₁).symm
        _ = Fin.cons (a₂ 0) (Fin.tail a₂) := by rw [h0, ht]
        _ = a₂ := Fin.cons_self_tail a₂
    · intro b hb
      exact ⟨Fin.cons b.1 b.2, Finset.mem_univ _, by simp⟩
    · intro a ha; rfl
  rw [hbij, ← Finset.univ_product_univ, Finset.sum_product]
  have hswap : ∀ x : D, (∑ w : Fin n → D, h x * ∏ i : Fin n, g (w i))
      = h x * (∑ w : Fin n → D, ∏ i : Fin n, g (w i)) :=
    fun x => (Finset.mul_sum _ _ _).symm
  rw [Finset.sum_congr rfl (fun x _ => hswap x), ← Finset.sum_mul,
    sum_prod_fn g n, mul_comm]

/-- **Moment warunkowany (fibra `z.1 0 = b`)** = `mgf₁(ℓ)^1535`. -/
theorem fiber_moment_eq (ℓ : ℝ) (b : Block) :
    (∑ z : BoxPair,
      ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
        / blockLaw.mass (z.1 0))
        * indicator (z.1 0 = b)
        * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j)) + (∑ j, blockEnergy (z.2 j))
            - blockEnergy (z.1 0))))
      = (∑ x : Block, blockLaw.mass x * Real.exp (ℓ * blockEnergy x))^1535 := by
  classical
  set g : Block → ℝ := fun x => blockLaw.mass x * Real.exp (ℓ * blockEnergy x)
    with hg
  have hpoint : ∀ z : BoxPair,
      ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
        / blockLaw.mass (z.1 0))
        * indicator (z.1 0 = b)
        * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j)) + (∑ j, blockEnergy (z.2 j))
            - blockEnergy (z.1 0)))
      = indicator (z.1 0 = b)
          * (∏ i : Fin 767, g (z.1 i.succ)) * (∏ j, g (z.2 j)) := by
    intro z
    have hL1 := prod_succ_split blockLaw.mass (z.1)
    have hE1 := sum_succ_split blockEnergy (z.1)
    have hE : (((∑ j, blockEnergy (z.1 j)) : ℤ) : ℝ)
          + (((∑ j, blockEnergy (z.2 j)) : ℤ) : ℝ)
          - (((blockEnergy (z.1 0)) : ℤ) : ℝ)
        = (((∑ i : Fin 767, blockEnergy (z.1 i.succ)) : ℤ) : ℝ)
          + (((∑ j, blockEnergy (z.2 j)) : ℤ) : ℝ) := by
      rw [hE1]
      push_cast
      ring
    have hne : blockLaw.mass (z.1 0) ≠ 0 := by
      exact ne_of_gt (by
        simpa only [blockLaw, Law.weighted, blockWeight, blockNormalizer] using
          div_pos (Real.exp_pos _) blockNormalizer_pos)
    have hL2 : ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j)))
          / blockLaw.mass (z.1 0)
        = (∏ i : Fin 767, blockLaw.mass (z.1 i.succ))
            * (∏ j, blockLaw.mass (z.2 j)) := by
      conv_lhs => rw [hL1]
      field_simp [hne]
    have hexpz : Real.exp (ℓ * ((((∑ i : Fin 767, blockEnergy (z.1 i.succ)) : ℤ) : ℝ)
          + (((∑ j, blockEnergy (z.2 j)) : ℤ) : ℝ)))
        = (∏ i : Fin 767, Real.exp (ℓ * blockEnergy (z.1 i.succ)))
          * ∏ j, Real.exp (ℓ * blockEnergy (z.2 j)) := by
      push_cast
      rw [mul_add, Real.exp_add, Finset.mul_sum, Real.exp_sum,
        Finset.mul_sum, Real.exp_sum]
    have hs1 : (∏ i : Fin 767, g (z.1 i.succ))
        = (∏ i : Fin 767, blockLaw.mass (z.1 i.succ))
          * ∏ i : Fin 767, Real.exp (ℓ * blockEnergy (z.1 i.succ)) := by
      simp only [hg]
      exact Finset.prod_mul_distrib
    have hs2 : (∏ j, g (z.2 j))
        = (∏ j, blockLaw.mass (z.2 j))
          * ∏ j, Real.exp (ℓ * blockEnergy (z.2 j)) := by
      simp only [hg]
      exact Finset.prod_mul_distrib
    rw [hE, hexpz, hL2, hs1, hs2]
    ring
  rw [Finset.sum_congr rfl (fun z _ => hpoint z), Fintype.sum_prod_type]
  simp_rw [← Finset.mul_sum]
  rw [← Finset.sum_mul]
  have hdirac : (∑ x : Block, indicator (x = b)) = 1 := by
    have hsingle : ∀ x ∈ (Finset.univ : Finset Block), x ≠ b →
        indicator (x = b) = 0 := by
      intro x _ hx
      simp [indicator, hx]
    have hb : indicator (b = b) = (1:ℝ) := by simp [indicator]
    rw [Finset.sum_eq_single b hsingle]
    · exact hb
    · intro hcontr
      exact absurd (Finset.mem_univ b) hcontr
  rw [sum_head_tail (fun x : Block => indicator (x = b)) g 767,
    sum_prod_fn g 768, hdirac, one_mul, ← pow_add]

/-! ## Bound Chernoffa (złożenie gotowych kawałków) -/

/-- Ogólny bound Chernoffa z implikacją `P i → Q i ∧ T ≤ f i`:
    wskaźnik `P` zamienia się na moment wykładniczy z dodatkowym
    wskaźnikiem `Q` po prawej (tu: fibra `z.1 0 = b` przepływa wprost
    do `fiber_moment_eq`). -/
theorem sum_imp_exp_bound {ι : Type} [Fintype ι] (s : Finset ι)
    (w : ι → ℝ) (f : ι → ℝ) (P Q : ι → Prop) (T ℓ : ℝ)
    (hℓ : 0 ≤ ℓ) (hw : ∀ i ∈ s, 0 ≤ w i)
    (himp : ∀ i ∈ s, P i → Q i ∧ T ≤ f i) :
    (∑ i ∈ s, w i * indicator (P i))
      ≤ Real.exp (-ℓ * T)
          * ∑ i ∈ s, ((w i * indicator (Q i)) * Real.exp (ℓ * f i)) := by
  classical
  have hpt : ∀ i ∈ s, w i * indicator (P i)
      ≤ Real.exp (-ℓ * T) * ((w i * indicator (Q i)) * Real.exp (ℓ * f i)) := by
    intro i hi
    rcases em (P i) with hp | hp
    · obtain ⟨hq, hT⟩ := himp i hi hp
      rw [show indicator (P i) = (1:ℝ) from by simp [indicator, hp],
        show indicator (Q i) = (1:ℝ) from by simp [indicator, hq]]
      simp only [mul_one]
      have hx : 0 ≤ ℓ * f i - ℓ * T := by nlinarith
      have he : (1:ℝ) ≤ Real.exp (ℓ * f i - ℓ * T) := Real.one_le_exp hx
      have hmain : (1:ℝ) * w i ≤ Real.exp (ℓ * f i - ℓ * T) * w i :=
        mul_le_mul_of_nonneg_right he (hw i hi)
      calc w i = (1:ℝ) * w i := (one_mul _).symm
        _ ≤ Real.exp (ℓ * f i - ℓ * T) * w i := hmain
        _ = Real.exp (-ℓ * T) * (w i * Real.exp (ℓ * f i)) := by
          have hs : ℓ * f i - ℓ * T = -ℓ * T + ℓ * f i := by ring
          rw [hs, Real.exp_add]
          ring
    · rw [show indicator (P i) = (0:ℝ) from by simp [indicator, hp], mul_zero]
      exact mul_nonneg (Real.exp_pos _).le
        (mul_nonneg (mul_nonneg (hw i hi) (indicator_nonnegative _))
          (Real.exp_pos _).le)
  calc (∑ i ∈ s, w i * indicator (P i))
        ≤ ∑ i ∈ s, Real.exp (-ℓ * T)
            * ((w i * indicator (Q i)) * Real.exp (ℓ * f i)) :=
          Finset.sum_le_sum hpt
    _ = Real.exp (-ℓ * T)
          * ∑ i ∈ s, ((w i * indicator (Q i)) * Real.exp (ℓ * f i)) := by
          rw [← Finset.mul_sum]

/-- **Bound Chernoffa dla okna półprostego**:
    `windowMassWin 0 b (T ≤ ·) ≤ e^{−ℓ·T} · mgf₁(ℓ)^1535` dla `ℓ ≥ 0`. -/
theorem windowMassWin_half_le (b : Block) (T : ℤ) (ℓ : ℝ) (hℓ : 0 ≤ ℓ) :
    windowMassWin 0 b (fun E => T ≤ E)
      ≤ Real.exp (-ℓ * ((T:ℤ):ℝ))
          * (∑ x : Block, blockLaw.mass x * Real.exp (ℓ * blockEnergy x))^1535 := by
  classical
  simp only [windowMassWin_rest, restWindowMass]
  have hnonneg : ∀ z : BoxPair, (0:ℝ) ≤ ((∏ j, blockLaw.mass (z.1 j))
      * (∏ j, blockLaw.mass (z.2 j)) / blockLaw.mass (z.1 0)) := by
    intro z
    apply div_nonneg
    · exact mul_nonneg (Finset.prod_nonneg fun _ _ => blockLaw.nonneg _)
        (Finset.prod_nonneg fun _ _ => blockLaw.nonneg _)
    · exact blockLaw.nonneg _
  refine le_trans (sum_imp_exp_bound Finset.univ
      (fun z : BoxPair => ((∏ j, blockLaw.mass (z.1 j))
        * (∏ j, blockLaw.mass (z.2 j)) / blockLaw.mass (z.1 0)))
      (fun z : BoxPair => (((∑ j, blockEnergy (z.1 j)) : ℤ) : ℝ)
        + (((∑ j, blockEnergy (z.2 j)) : ℤ) : ℝ)
        - (((blockEnergy (z.1 0)) : ℤ) : ℝ))
      (fun z : BoxPair => z.1 0 = b ∧ ((T:ℤ) ≤ (∑ j, blockEnergy (z.1 j))
        + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))
      (fun z : BoxPair => z.1 0 = b)
      ((T:ℤ):ℝ) ℓ hℓ (fun z _ => hnonneg z) (fun z _ h => ⟨h.1, by exact_mod_cast h.2⟩)) ?_
  rw [fiber_moment_eq ℓ b]

/-- **Pojedynczy mgf = stosunek sum blokowych** przy przesuniętym
    parametrze `c0 − ℓ` (łącznik `rest_moment_factor` → machina θ). -/
theorem mgf1_eq (ℓ : ℝ) :
    (∑ x : Block, blockLaw.mass x * Real.exp (ℓ * blockEnergy x))
      = blockSum (c0 - ℓ) / blockSum c0 := by
  classical
  have hpoint : ∀ x : Block,
      blockLaw.mass x * Real.exp (ℓ * blockEnergy x)
        = slotVal (c0 - ℓ) x / blockNormalizer := by
    intro x
    have h1 : blockLaw.mass x = blockWeight x / blockNormalizer := rfl
    have h2 : blockWeight x * Real.exp (ℓ * blockEnergy x) = slotVal (c0 - ℓ) x := by
      unfold blockWeight slotVal
      rw [slotQ_eq_blockEnergy x, ← Real.exp_add]
      congr 1
      rw [c0_val]
      field_simp
      ring
    rw [h1, div_mul_eq_mul_div, h2]
  rw [Finset.sum_congr rfl (fun x _ => hpoint x), ← Finset.sum_div,
    ← blockSum_c0_eq]
  rfl

/-- **Ważony moment oknowy** (kanapka Craméra — uwaga właściciela
    2026-09-30: waga `e^{−λS}` zmienna w oknie): `∑ w_z·1[fib ∧ W]·e^{ℓ·S_z}`;
    dla `W ≡ True` zbiega się z `fiber_moment_eq` (`= mgf₁(ℓ)^1535`). -/
noncomputable def weightedWindowMass (b : Block) (W : ℤ → Prop) (ℓ : ℝ) : ℝ :=
  Finset.sum Finset.univ (fun z : BoxPair =>
    (((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
      / blockLaw.mass (z.1 0)))
      * indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
          + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))
      * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j)) + (∑ j, blockEnergy (z.2 j))
          - blockEnergy (z.1 0))))

/-- Punktowa kanapka wag okna (waga `e^{ℓ·S}` zmienna!): dla `ℓ ≥ 0`
    i `T1 ≤ S ≤ T2`: `e^{−ℓ·T2}·e^{ℓ·S} ≤ 1 ≤ e^{−ℓ·T1}·e^{ℓ·S}`.
    Wersja wprost na ℝ (zero kastów w środku). -/
theorem sandwich_pointwise (T1 T2 S : ℝ) (ℓ : ℝ) (hℓ : 0 ≤ ℓ)
    (hT1 : T1 ≤ S) (hT2 : S ≤ T2) :
    Real.exp (-ℓ * T2) * Real.exp (ℓ * S) ≤ (1:ℝ)
      ∧ (1:ℝ) ≤ Real.exp (-ℓ * T1) * Real.exp (ℓ * S) := by
  constructor
  · have hx : ℓ * (S - T2) ≤ 0 := by nlinarith
    have he : Real.exp (ℓ * (S - T2)) ≤ (1:ℝ) := by
      rw [← Real.exp_zero]
      exact Real.exp_le_exp.mpr hx
    have hcalc : Real.exp (-ℓ * T2) * Real.exp (ℓ * S)
        = Real.exp (ℓ * (S - T2)) := by
      have hs : -ℓ * T2 + ℓ * S = ℓ * (S - T2) := by ring
      rw [← Real.exp_add, hs]
    rw [hcalc]
    exact he
  · have hx : 0 ≤ ℓ * (S - T1) := by nlinarith
    have he : (1:ℝ) ≤ Real.exp (ℓ * (S - T1)) := Real.one_le_exp hx
    have hcalc : Real.exp (-ℓ * T1) * Real.exp (ℓ * S)
        = Real.exp (ℓ * (S - T1)) := by
      have hs : -ℓ * T1 + ℓ * S = ℓ * (S - T1) := by ring
      rw [← Real.exp_add, hs]
    rw [hcalc]
    exact he

/-- **Dwustronna kanapka okna** (dokładna postać przekrzywienia — waga
    `e^{ℓ·S}` zmienna, bez skrótu `e^{−Λ*}`): dla `ℓ ≥ 0` i okna w `[T1,T2]`:
    `e^{−ℓ·T2}·weightedWindowMass ≤ windowMassWin ≤ e^{−ℓ·T1}·weightedWindowMass`. -/
theorem windowSandwich (b : Block) (W : ℤ → Prop) (T1 T2 : ℤ) (ℓ : ℝ)
    (hℓ : 0 ≤ ℓ)
    (hW : ∀ e : ℤ, W e → ((T1:ℤ):ℝ) ≤ ((e:ℤ):ℝ) ∧ ((e:ℤ):ℝ) ≤ ((T2:ℤ):ℝ)) :
    Real.exp (-ℓ * ((T2:ℤ):ℝ)) * weightedWindowMass b W ℓ
        ≤ windowMassWin 0 b W
      ∧ windowMassWin 0 b W
        ≤ Real.exp (-ℓ * ((T1:ℤ):ℝ)) * weightedWindowMass b W ℓ := by
  classical
  simp only [windowMassWin_rest, restWindowMass, weightedWindowMass]
  have hnonneg : ∀ z : BoxPair, (0:ℝ) ≤ ((∏ j, blockLaw.mass (z.1 j))
      * (∏ j, blockLaw.mass (z.2 j)) / blockLaw.mass (z.1 0)) := by
    intro z
    apply div_nonneg
    · exact mul_nonneg (Finset.prod_nonneg fun _ _ => blockLaw.nonneg _)
        (Finset.prod_nonneg fun _ _ => blockLaw.nonneg _)
    · exact blockLaw.nonneg _
  have hptL : ∀ z : BoxPair,
      Real.exp (-ℓ * ((T2:ℤ):ℝ))
          * (((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
            / blockLaw.mass (z.1 0))
            * indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
                + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))
            * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j))
                + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))))
      ≤ ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
          / blockLaw.mass (z.1 0))
          * indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
              + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) := by
    intro z
    have hA := hnonneg z
    rcases em (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
        + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) with hp | hp
    · rcases hp with ⟨hp1, hp2⟩
      subst hp1
      have hsp := sandwich_pointwise ((T1:ℤ):ℝ) ((T2:ℤ):ℝ)
        (((((∑ j, blockEnergy (z.1 j)) : ℤ) : ℝ)
          + ((((∑ j, blockEnergy (z.2 j)) : ℤ) : ℝ))
          - ((((blockEnergy (z.1 0)) : ℤ) : ℝ))))
        ℓ hℓ (by exact_mod_cast (hW _ hp2).1) (by exact_mod_cast (hW _ hp2).2)
      rw [show indicator (z.1 0 = z.1 0 ∧ W ((∑ j, blockEnergy (z.1 j))
          + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) = (1:ℝ) from by
        simp [indicator, hp2]]
      simp only [mul_one]
      calc Real.exp (-ℓ * ((T2:ℤ):ℝ))
            * (((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
              / blockLaw.mass (z.1 0)) * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j))
                + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))))
          = ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
              / blockLaw.mass (z.1 0))
              * (Real.exp (-ℓ * ((T2:ℤ):ℝ)) * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j))
                + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))) := by ring
        _ ≤ ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
              / blockLaw.mass (z.1 0)) * (1:ℝ) :=
            mul_le_mul_of_nonneg_left hsp.1 hA
        _ = ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
              / blockLaw.mass (z.1 0)) := by ring
    · rw [show indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
        + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) = (0:ℝ) from by
        simp [indicator, hp]]
      simp [mul_zero, zero_mul]
  have hptU : ∀ z : BoxPair,
      ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
        / blockLaw.mass (z.1 0))
        * indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
            + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))
      ≤ Real.exp (-ℓ * ((T1:ℤ):ℝ))
          * (((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
            / blockLaw.mass (z.1 0))
            * indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
                + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))
            * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j))
                + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))) := by
    intro z
    have hA := hnonneg z
    rcases em (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
        + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) with hp | hp
    · rcases hp with ⟨hp1, hp2⟩
      subst hp1
      have hsp := sandwich_pointwise ((T1:ℤ):ℝ) ((T2:ℤ):ℝ)
        (((((∑ j, blockEnergy (z.1 j)) : ℤ) : ℝ)
          + ((((∑ j, blockEnergy (z.2 j)) : ℤ) : ℝ))
          - ((((blockEnergy (z.1 0)) : ℤ) : ℝ))))
        ℓ hℓ (by exact_mod_cast (hW _ hp2).1) (by exact_mod_cast (hW _ hp2).2)
      rw [show indicator (z.1 0 = z.1 0 ∧ W ((∑ j, blockEnergy (z.1 j))
          + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) = (1:ℝ) from by
        simp [indicator, hp2]]
      simp only [mul_one]
      calc ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
            / blockLaw.mass (z.1 0))
          = ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
              / blockLaw.mass (z.1 0)) * (1:ℝ) := by ring
        _ ≤ ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
              / blockLaw.mass (z.1 0))
              * (Real.exp (-ℓ * ((T1:ℤ):ℝ)) * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j))
                + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))) :=
            mul_le_mul_of_nonneg_left hsp.2 hA
        _ = Real.exp (-ℓ * ((T1:ℤ):ℝ))
              * (((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
                / blockLaw.mass (z.1 0)) * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j))
                  + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))) := by ring
    · rw [show indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
        + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) = (0:ℝ) from by
        simp [indicator, hp]]
      simp [mul_zero, zero_mul]
  constructor
  · rw [Finset.mul_sum]
    exact Finset.sum_le_sum (fun z _ => hptL z)
  · rw [Finset.mul_sum]
    exact Finset.sum_le_sum (fun z _ => hptU z)

/-- Spójność: ważony moment okna pełnego (`W ≡ True`) = `mgf₁(ℓ)^1535`
    (`fiber_moment_eq`) — scala `windowSandwich` z `mgf1_eq`. -/
theorem weightedWindowMass_true (b : Block) (ℓ : ℝ) :
    weightedWindowMass b (fun _ => True) ℓ
      = (∑ x : Block, blockLaw.mass x * Real.exp (ℓ * blockEnergy x))^1535 := by
  classical
  simp only [weightedWindowMass]
  have hz : ∀ z : BoxPair,
      (((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
        / blockLaw.mass (z.1 0)))
        * indicator (z.1 0 = b ∧ True)
        * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j)) + (∑ j, blockEnergy (z.2 j))
            - blockEnergy (z.1 0)))
      = (((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
        / blockLaw.mass (z.1 0)))
        * indicator (z.1 0 = b)
        * Real.exp (ℓ * ((∑ j, blockEnergy (z.1 j)) + (∑ j, blockEnergy (z.2 j))
            - blockEnergy (z.1 0))) := by
    intro z
    rw [and_true]
  rw [Finset.sum_congr rfl (fun z _ => hz z)]
  exact fiber_moment_eq ℓ b

/-- Rozbiór wskaźnika koniunkcji: `1[p ∧ q] + 1[p ∧ ¬q] = 1[p]`. -/
theorem indicator_and_split (p q : Prop) :
    indicator (p ∧ q) + indicator (p ∧ ¬ q) = (indicator p : ℝ) := by
  unfold indicator
  by_cases hp : p
  · by_cases hq : q <;> simp [hp, hq]
  · simp [hp]

/-- **Rozbiór momentu**: pełny ważony moment = okno + dopełnienie
    (elementarny krok do `P_λ(I) = 1 − P_λ(I^c)`). -/
theorem weightedWindowMass_split (b : Block) (W : ℤ → Prop) (ℓ : ℝ) :
    weightedWindowMass b (fun _ => True) ℓ
      = weightedWindowMass b W ℓ + weightedWindowMass b (fun e => ¬ W e) ℓ := by
  classical
  simp only [weightedWindowMass]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro z _
  have hind : (indicator (z.1 0 = b ∧ True) : ℝ)
      = indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
          + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)))
        + indicator (z.1 0 = b ∧ ¬ W ((∑ j, blockEnergy (z.1 j))
            + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) := by
    rw [and_true, indicator_and_split]
  rw [hind]
  ring

/-- Lustro Chernoffa — dolna półprosta (`f i ≤ T`): dla `ℓ ≥ 0`
    `∑ w·1[P] ≤ e^{ℓ·T}·∑ (w·1[Q])·e^{−ℓ·f}` przy `P i → Q i ∧ f i ≤ T`. -/
theorem sum_imp_exp_bound_neg {ι : Type} [Fintype ι] (s : Finset ι)
    (w : ι → ℝ) (f : ι → ℝ) (P Q : ι → Prop) (T ℓ : ℝ)
    (hℓ : 0 ≤ ℓ) (hw : ∀ i ∈ s, 0 ≤ w i)
    (himp : ∀ i ∈ s, P i → Q i ∧ f i ≤ T) :
    (∑ i ∈ s, w i * indicator (P i))
      ≤ Real.exp (ℓ * T)
          * ∑ i ∈ s, ((w i * indicator (Q i)) * Real.exp (-ℓ * f i)) := by
  classical
  have hpt : ∀ i ∈ s, w i * indicator (P i)
      ≤ Real.exp (ℓ * T) * ((w i * indicator (Q i)) * Real.exp (-ℓ * f i)) := by
    intro i hi
    rcases em (P i) with hp | hp
    · obtain ⟨hq, hT⟩ := himp i hi hp
      rw [show indicator (P i) = (1:ℝ) from by simp [indicator, hp],
        show indicator (Q i) = (1:ℝ) from by simp [indicator, hq]]
      simp only [mul_one]
      have hx : 0 ≤ ℓ * (T - f i) := by nlinarith
      have he : (1:ℝ) ≤ Real.exp (ℓ * (T - f i)) := Real.one_le_exp hx
      have hmain : (1:ℝ) * w i ≤ Real.exp (ℓ * (T - f i)) * w i :=
        mul_le_mul_of_nonneg_right he (hw i hi)
      calc w i = (1:ℝ) * w i := (one_mul _).symm
        _ ≤ Real.exp (ℓ * (T - f i)) * w i := hmain
        _ = Real.exp (ℓ * T) * (w i * Real.exp (-ℓ * f i)) := by
          have hs : ℓ * (T - f i) = ℓ * T + -ℓ * f i := by ring
          rw [hs, Real.exp_add]
          ring
    · rw [show indicator (P i) = (0:ℝ) from by simp [indicator, hp], mul_zero]
      exact mul_nonneg (Real.exp_pos _).le
        (mul_nonneg (mul_nonneg (hw i hi) (indicator_nonnegative _))
          (Real.exp_pos _).le)
  calc (∑ i ∈ s, w i * indicator (P i))
        ≤ ∑ i ∈ s, Real.exp (ℓ * T)
            * ((w i * indicator (Q i)) * Real.exp (-ℓ * f i)) :=
          Finset.sum_le_sum hpt
    _ = Real.exp (ℓ * T)
          * ∑ i ∈ s, ((w i * indicator (Q i)) * Real.exp (-ℓ * f i)) := by
          rw [← Finset.mul_sum]

/-- **Dopełnienie kwadratu dla zwrotu sektorowego**: forma blokowa
    `Q(x,y) = x²+xy+y²` i zwrot `−κ·(2x+y)` — wektor zwrotu jest
    gradientem `Q` w kierunku `(1,0)`, więc przesunięcie środka to
    dokładnie `u = κ/s`:
    `−s·Q(x,y) − κ(2x+y) = −s·Q(x+κ/s, y) + κ²/s`. -/
theorem hex_twist_shift (s κ x y : ℝ) (hs : s ≠ 0) :
    -s * (x*x + x*y + y*y) - κ * (2*x + y)
      = -s * ((x + κ/s)*(x + κ/s) + (x + κ/s)*y + y*y) + κ*κ/s := by
  field_simp [hs]
  ring

/-- Wieża A2 z realnym przesunięciem `(u + y/2)` w kanale `x`
    (LDL-shear niecałkowity — `TriangularGaussian.Tower` to dopuszcza;
    rozkład `Q(x,y) = (x+y/2)² + 3y²/4` = `a2_scalar_split`). -/
noncomputable def a2Tower (s u : ℝ) : FT1536.Run2.TriangularGaussian.Tower 2 :=
  .snoc (.snoc (.nil : FT1536.Run2.TriangularGaussian.Tower 0)
    (3 * s / (4 * Real.pi)) (fun _ => 0)) (s / Real.pi)
    (fun p => u + ((p.2 : ℤ) : ℝ) / 2)

/-- Tożsamość atomu punktowo: `atom (a2Tower s u) (((), y), x) = e^{−s·Q(x+u, y)}`. -/
theorem a2Tower_atom (s u : ℝ) (x y : ℤ) :
    FT1536.Run2.TriangularGaussian.atom (a2Tower s u) ((((), y), x))
      = Real.exp (-s * (((x : ℝ) + u) * ((x : ℝ) + u)
          + ((x : ℝ) + u) * (y : ℝ) + (y : ℝ) * (y : ℝ))) := by
  simp only [a2Tower, FT1536.Run2.TriangularGaussian.atom]
  rw [one_mul]
  have hs : ∀ A B : ℝ, Real.exp A * Real.exp B = Real.exp (A + B) :=
    fun A B => (Real.exp_add A B).symm
  rw [hs]
  congr 1
  by_cases h : s = 0
  · simp [h]
  · have hp : Real.pi ≠ 0 := Real.pi_ne_zero
    field_simp [h, hp]
    ring

/-- Przekrzywiony potencjał `Q(x+u, y)` w zapisie punktu wieży. -/
noncomputable def a2Q (s u : ℝ) (z : FT1536.Run2.TriangularGaussian.Points 2) : ℝ :=
  let X : ℝ := ((z.2 : ℤ) : ℝ) + u
  let Y : ℝ := ((z.1.2 : ℤ) : ℝ)
  Real.exp (-s * (X * X + X * Y + Y * Y))

/-- Identyfikacja `total` wieży A2 z sumą nieoznaczoną `a2Q` (atom wieży przepisany punktowo). -/
theorem a2Tower_total (s u : ℝ) :
    FT1536.Run2.TriangularGaussian.total (a2Tower s u)
      = ∑' z : FT1536.Run2.TriangularGaussian.Points 2, a2Q s u z := by
  unfold FT1536.Run2.TriangularGaussian.total
  apply tsum_congr
  intro z
  rcases z with ⟨⟨⟨⟩, y⟩, x⟩
  exact a2Tower_atom s u x y

/-- Kanapka masy wieży A2 (z generycznego `triangular_mass_bounds` przy `n=2`,
    błąd rzędu `2⁻⁴⁶` — ogromny zapas wobec wymaganych `10⁻¹⁰`). -/
theorem a2Tower_mass_bounds (s u : ℝ)
    (hs : 0 < s) (hmax : s / Real.pi ≤ FT1536.Run2.T5ScalarMass.maxCoefficient) :
    (1 - 2*FT1536.Run2.T5ScalarMass.rowRatio/(1-FT1536.Run2.T5ScalarMass.rowRatio))^2
        * FT1536.Run2.TriangularGaussian.scale (a2Tower s u)
      ≤ FT1536.Run2.TriangularGaussian.total (a2Tower s u)
    ∧ FT1536.Run2.TriangularGaussian.total (a2Tower s u)
      ≤ (1 + 2*FT1536.Run2.T5ScalarMass.rowRatio/(1-FT1536.Run2.T5ScalarMass.rowRatio))^2
        * FT1536.Run2.TriangularGaussian.scale (a2Tower s u) := by
  have hr : 0 < FT1536.Run2.T5ScalarMass.rowRatio :=
    (FT1536.Run2.T5ScalarMass.dimension_margins).1
  have hrl : FT1536.Run2.T5ScalarMass.rowRatio < 1 :=
    (FT1536.Run2.T5ScalarMass.dimension_margins).2.1
  have hhe : 2*FT1536.Run2.T5ScalarMass.rowRatio
      /(1-FT1536.Run2.T5ScalarMass.rowRatio) ≤ 1 :=
    le_trans (FT1536.Run2.T5ScalarMass.dimension_margins).2.2.2.1
      (FT1536.Run2.T5ScalarMass.dimension_margins).2.2.2.2.1
  have hcr : FT1536.Run2.T5ScalarMass.CoefficientRange (a2Tower s u) := by
    have h3 : (0:ℝ) < 3*s/(4*Real.pi) := by positivity
    have h4 : (3*s/(4*Real.pi) : ℝ) ≤ s/Real.pi := by
      have hp : 0 < Real.pi := Real.pi_pos
      rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 4*Real.pi) hp]
      nlinarith
    refine ⟨⟨trivial, h3, h4.trans hmax⟩, by positivity, hmax⟩
  exact FT1536.Run2.TriangularGaussian.triangular_mass_bounds
    (a2Tower s u) FT1536.Run2.T5ScalarMass.rowRatio hr hrl hhe
    (FT1536.Run2.T5ScalarMass.local_exponents (a2Tower s u) hcr)

/-- Wykładnicza postać zwrotu: `e^{−s·Q(x,y) − κ(2x+y)} = e^{κ²/s}·e^{−s·Q(x+κ/s, y)}`. -/
theorem hex_twist_shift_exp (s κ x y : ℝ) (hs : s ≠ 0) :
    Real.exp (-s * (x*x + x*y + y*y) - κ * (2*x + y))
      = Real.exp (κ*κ/s) * Real.exp (-s * ((x + κ/s)*(x + κ/s)
          + (x + κ/s)*y + y*y)) := by
  rw [hex_twist_shift s κ x y hs, Real.exp_add]
  ring

/-- Box-to-lattice bridge: the box sum over `Fin 131071^2` (coordinates via
    `blockDecode`) does not exceed the unordered sum over `ℤ × ℤ` for
    nonnegative summable functions (the image of the box under `blockDecode`
    is `Icc (-65535) 65535 × Icc (-65535) 65535`, a subset of `ℤ × ℤ`). -/
theorem box_sum_le_tsum {f : ℤ × ℤ → ℝ}
    (hf : ∀ p, 0 ≤ f p) (hsum : Summable f) :
    (∑ b : Block, f (blockDecode b)) ≤ ∑' p : ℤ × ℤ, f p := by
  classical
  rw [Fintype.sum_prod_type]
  have h0 : (∑ a : Fin 131071, ∑ t : Fin 131071, f (blockDecode (a, t)))
      = (∑ a : Fin 131071, ∑ t : Fin 131071,
          f (((a.val : ℤ) - 65535, ((t.val : ℤ) - 65535)))) :=
    Finset.sum_congr rfl (fun a _ => Finset.sum_congr rfl (fun t _ => rfl))
  rw [h0]
  rw [sum_fin131071_eq (g := fun x : ℤ => ∑ t : Fin 131071,
    f ((x, ((t.val : ℤ) - 65535))))]
  have h2 : (∑ x ∈ Finset.Icc (-65535:ℤ) 65535,
      ∑ t : Fin 131071, f ((x, ((t.val : ℤ) - 65535))))
      = (∑ x ∈ Finset.Icc (-65535:ℤ) 65535,
          ∑ y ∈ Finset.Icc (-65535:ℤ) 65535, f ((x, y))) :=
    Finset.sum_congr rfl (fun x _ => sum_fin131071_eq (g := fun y : ℤ => f ((x, y))))
  rw [h2, ← Finset.sum_product]
  exact hsum.sum_le_tsum _ (fun p _ => hf p)

/-- Monotonicity of the weighted window moment with respect to the window predicate:
    `W ⊆ W'` implies `weightedWindowMass b W ℓ ≤ weightedWindowMass b W' ℓ`. -/
theorem weightedWindowMass_mono {W W' : ℤ → Prop} (b : Block) (ℓ : ℝ)
    (h : ∀ e : ℤ, W e → W' e) :
    weightedWindowMass b W ℓ ≤ weightedWindowMass b W' ℓ := by
  classical
  simp only [weightedWindowMass]
  apply Finset.sum_le_sum
  intro z _
  have hA : (0:ℝ) ≤ ((∏ j, blockLaw.mass (z.1 j)) * (∏ j, blockLaw.mass (z.2 j))
      / blockLaw.mass (z.1 0)) := by
    apply div_nonneg
    · exact mul_nonneg (Finset.prod_nonneg fun _ _ => blockLaw.nonneg _)
        (Finset.prod_nonneg fun _ _ => blockLaw.nonneg _)
    · exact blockLaw.nonneg _
  rcases em (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
      + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) with hp | hp
  · rcases hp with ⟨hp1, hp2⟩
    subst hp1
    have hp2' : W' ((∑ j, blockEnergy (z.1 j))
        + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0)) := h _ hp2
    rw [show indicator (z.1 0 = z.1 0 ∧ W ((∑ j, blockEnergy (z.1 j))
        + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) = (1:ℝ) from by
      simp [indicator, hp2]]
    rw [show indicator (z.1 0 = z.1 0 ∧ W' ((∑ j, blockEnergy (z.1 j))
        + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) = (1:ℝ) from by
      simp [indicator, hp2']]
  · rw [show indicator (z.1 0 = b ∧ W ((∑ j, blockEnergy (z.1 j))
      + (∑ j, blockEnergy (z.2 j)) - blockEnergy (z.1 0))) = (0:ℝ) from by
      simp [indicator, hp], mul_zero, zero_mul]
    exact mul_nonneg (mul_nonneg hA (indicator_nonnegative _)) (Real.exp_pos _).le

/-- The weighted window moment never exceeds the full moment `mgf₁(ℓ)^1535`. -/
theorem weightedWindowMass_le_full (b : Block) (W : ℤ → Prop) (ℓ : ℝ) :
    weightedWindowMass b W ℓ
      ≤ (∑ x : Block, blockLaw.mass x * Real.exp (ℓ * blockEnergy x))^1535 :=
  (weightedWindowMass_mono b ℓ (fun _ _ => trivial)).trans
    (le_of_eq (weightedWindowMass_true b ℓ))

/-- Per-block upper bound of the hi-window gap by the tilted full moment
    (Cramér upper side of `windowSandwich` + `weightedWindowMass_le_full`). -/
theorem engineGapHi_le (b : Block) (ℓ : ℝ) (hℓ : 0 ≤ ℓ) :
    engineGapHi b
      ≤ Real.exp (-ℓ * (((hiT1 (blockEnergy b) (centeredEnergy b)) : ℤ) : ℝ))
          * (∑ x : Block, blockLaw.mass x * Real.exp (ℓ * blockEnergy x))^1535 := by
  rw [← windowMassWin_hiWin b]
  have hW : ∀ e : ℤ, hiWin (blockEnergy b) (centeredEnergy b) e
      → (((hiT1 (blockEnergy b) (centeredEnergy b)) : ℤ) : ℝ) ≤ ((e:ℤ):ℝ)
        ∧ ((e:ℤ):ℝ) ≤ (((hiT2 (blockEnergy b) (centeredEnergy b)) : ℤ) : ℝ) := by
    intro e he
    rw [hiWin_eq_Icc] at he
    exact ⟨by exact_mod_cast he.1, by exact_mod_cast he.2⟩
  have hs := (windowSandwich b (hiWin (blockEnergy b) (centeredEnergy b))
    (hiT1 (blockEnergy b) (centeredEnergy b)) (hiT2 (blockEnergy b) (centeredEnergy b))
    ℓ hℓ hW).2
  have hf := weightedWindowMass_le_full b (hiWin (blockEnergy b) (centeredEnergy b)) ℓ
  exact le_trans hs (mul_le_mul_of_nonneg_left hf (Real.exp_pos _).le)

/-- Threshold monotonicity: `hiT1` rounds up, hence
    `B − Qc − 1535*15 ≤ hiT1 Q Qc` (from `binLo_spec`; the upper-side step for certHi). -/
theorem hiT1_ge (Q Qc : ℤ) :
    (B - Qc - 1535*15 : ℤ) ≤ hiT1 Q Qc := by
  have h := (binLo_spec (B - Qc - 1535*15 : ℤ)).1
  simpa [hiT1] using h

/-- Exponential form of the threshold step (upper side for certHi):
    `e^{−ℓ·hiT1} ≤ e^{−ℓ(B−Qc−1535·15)}` for `ℓ ≥ 0`. -/
theorem exp_neg_hiT1_le (Q Qc : ℤ) (ℓ : ℝ) (hℓ : 0 ≤ ℓ) :
    Real.exp (-ℓ * ((hiT1 Q Qc : ℤ) : ℝ))
      ≤ Real.exp (-ℓ * (((B - Qc - 1535*15) : ℤ) : ℝ)) := by
  have h := hiT1_ge Q Qc
  have hc : (((B - Qc - 1535*15) : ℤ) : ℝ) ≤ ((hiT1 Q Qc : ℤ) : ℝ) := by
    exact_mod_cast h
  have hm : -ℓ * ((hiT1 Q Qc : ℤ) : ℝ) ≤ -ℓ * (((B - Qc - 1535*15) : ℤ) : ℝ) :=
    mul_le_mul_of_nonpos_left hc (neg_nonpos.mpr hℓ)
  exact Real.exp_le_exp.mpr hm

/-- Sector identity (kernel twin of the L0 pre-check): for `region1` blocks
    the centered energy satisfies `Qc − Q = 18433·δ` with
    `δ = 18433 − 2a − c` (`a`, `c` = decoded coordinates), since
    `center a = a − 18433` on the sector range. -/
theorem centeredEnergy_region1 (b : Block) (hreg : region1 b) :
    centeredEnergy b
      = blockEnergy b
          + 18433 * (18433 - 2*(blockDecode b).1 - (blockDecode b).2) := by
  have htri : 9217 ≤ (blockDecode b).1 ∧ (blockDecode b).1 ≤ 13824
      ∧ -9216 ≤ (blockDecode b).2
      ∧ (blockDecode b).2 ≤ 18432 - 2*(blockDecode b).1 := by
    simpa [region1, triangle] using hreg
  have hca : center (blockDecode b).1 = (blockDecode b).1 - 18433 := by
    unfold center
    omega
  have hcb : center (blockDecode b).2 = (blockDecode b).2 := by
    unfold center
    omega
  simp only [centeredEnergy, blockEnergy, hca, hcb, Geometry.block]
  ring

/-- Sector twist with the delta constant (the assembly form):
    `e^{−s·Q(a,b) + ℓ·18433² − κ(2a+b)} = e^{ℓ·18433² + κ²/s}·e^{−s·Q(a+κ/s, b)}`
    for `s ≠ 0` (with `s = c0 − ℓ`, `κ = ℓ·18433` at use site). -/
theorem hex_twist_shift_exp_delta (s κ ℓ a b : ℝ) (hs : s ≠ 0) :
    Real.exp (-s * (a*a + a*b + b*b) + ℓ*18433^2 - κ * (2*a + b))
      = Real.exp (ℓ*18433^2 + κ*κ/s) * Real.exp (-s * ((a + κ/s)*(a + κ/s)
          + (a + κ/s)*b + b*b)) := by
  rw [show (-s * (a*a + a*b + b*b) + ℓ*18433^2 - κ * (2*a + b))
      = ℓ*18433^2 + (-s * (a*a + a*b + b*b) - κ * (2*a + b)) by ring,
    Real.exp_add, hex_twist_shift_exp s κ a b hs, Real.exp_add]
  ring

/-- Twisted block potential at the shifted coordinate: `Q(a + u, c)` where
    `a`, `c` are the decoded coordinates and `u = κ/s` (the real LDL shift
    of `hex_twist_shift`). -/
noncomputable def shiftedBlockQ (b : Block) (s κ : ℝ) : ℝ :=
  let a : ℝ := (((blockDecode b).1 : ℤ) : ℝ)
  let c : ℝ := (((blockDecode b).2 : ℤ) : ℝ)
  let u : ℝ := κ / s
  (a + u) * (a + u) + (a + u) * c + c * c

/-- Unfolding identity of the shifted potential (no hypotheses). -/
theorem shiftedBlockQ_eq (b : Block) (s κ : ℝ) :
    shiftedBlockQ b s κ
      = (((((blockDecode b).1 : ℤ) : ℝ) + κ/s) * ((((blockDecode b).1 : ℤ) : ℝ) + κ/s)
        + (((((blockDecode b).1 : ℤ) : ℝ) + κ/s) * (((blockDecode b).2 : ℤ) : ℝ))
        + (((blockDecode b).2 : ℤ) : ℝ) * (((blockDecode b).2 : ℤ) : ℝ)) := by
  rfl

/-- Exponent bridge: `blockWeight b = exp(−c0·Q_b)` (the two exponent forms
    of the block weight differ only by `c0_val`). -/
theorem blockWeight_eq_exp (b : Block) :
    blockWeight b = Real.exp (-((c0:ℝ) * ((blockEnergy b : ℤ) : ℝ))) := by
  unfold blockWeight
  rw [c0_val]
  field_simp

/-- Exponent identity of the twisted weight (pure algebra on real
    coordinates): with `s = c0' − ℓ`, `κ = ℓ·18433`,
    `−c0'·Q + ℓ·(Q + 18433·(18433 − 2a − c)) = ℓ·18433² + κ²/s − s·Q(a+κ/s, c)`
    where `Q(a,c) = a*a + a*c + c*c`. -/
theorem twist_exponent_identity (a c s κ c0' ℓ : ℝ)
    (hs : s = c0' - ℓ) (hk : κ = ℓ*18433) (hss : s ≠ 0) :
    -c0' * (a*a + a*c + c*c)
        + ℓ * ((a*a + a*c + c*c) + 18433*(18433 - 2*a - c))
      = ℓ*18433^2 + κ*κ/s
          - s * ((a + κ/s)*(a + κ/s) + (a + κ/s)*c + c*c) := by
  have hss' : (c0':ℝ) - ℓ ≠ 0 := by rw [← hs]; exact hss
  rw [hs, hk]
  field_simp [hss']
  ring

/-- Real expansion of the block energy in the decoded coordinates
    (`Geometry.block x y = x*x + x*y + y*y` cast to `ℝ`). -/
theorem blockEnergy_as_real (b : Block) :
    ((blockEnergy b : ℤ) : ℝ)
      = (((blockDecode b).1 : ℤ) : ℝ) * (((blockDecode b).1 : ℤ) : ℝ)
        + (((blockDecode b).1 : ℤ) : ℝ) * (((blockDecode b).2 : ℤ) : ℝ)
        + (((blockDecode b).2 : ℤ) : ℝ) * (((blockDecode b).2 : ℤ) : ℝ) := by
  simp only [blockEnergy, Geometry.block]
  push_cast
  ring

/-- Twisted exponent form of the block weight (the exponent-level assembly):
    `exp(−c0·Q)·exp(ℓ·Qc) = exp(ℓ·18433² + κ²/s)·exp(−s·Q(a+κ/s, c))` for
    `region1` blocks and `s = c0 − ℓ ≠ 0`, with `κ = ℓ·18433`. -/
theorem twisted_weight_exp_eq (b : Block) (ℓ : ℝ) (hreg : region1 b)
    (hs : (c0:ℝ) - ℓ ≠ 0) :
    Real.exp (-((c0:ℝ) * ((blockEnergy b : ℤ) : ℝ)))
        * Real.exp (ℓ * ((centeredEnergy b : ℤ) : ℝ))
      = Real.exp (ℓ*18433^2 + (ℓ*18433)*(ℓ*18433)/((c0:ℝ) - ℓ))
          * Real.exp (-((c0:ℝ) - ℓ) * shiftedBlockQ b ((c0:ℝ) - ℓ) (ℓ*18433)) := by
  have ha := blockEnergy_as_real b
  have hqc : ((centeredEnergy b : ℤ) : ℝ)
      = ((blockEnergy b : ℤ) : ℝ)
          + 18433 * (18433 - 2 * (((blockDecode b).1 : ℤ) : ℝ)
            - (((blockDecode b).2 : ℤ) : ℝ)) := by
    exact_mod_cast centeredEnergy_region1 b hreg
  have halg := twist_exponent_identity (((blockDecode b).1 : ℤ) : ℝ)
    (((blockDecode b).2 : ℤ) : ℝ) ((c0:ℝ) - ℓ) (ℓ*18433) (c0:ℝ) ℓ rfl rfl hs
  have hshift := shiftedBlockQ_eq b ((c0:ℝ) - ℓ) (ℓ*18433)
  have hE : -((c0:ℝ) * ((((blockDecode b).1 : ℤ) : ℝ)
        * (((blockDecode b).1 : ℤ) : ℝ)
        + (((blockDecode b).1 : ℤ) : ℝ) * (((blockDecode b).2 : ℤ) : ℝ)
        + (((blockDecode b).2 : ℤ) : ℝ) * (((blockDecode b).2 : ℤ) : ℝ)))
      + ℓ * (((((blockDecode b).1 : ℤ) : ℝ) * (((blockDecode b).1 : ℤ) : ℝ)
        + (((blockDecode b).1 : ℤ) : ℝ) * (((blockDecode b).2 : ℤ) : ℝ)
        + (((blockDecode b).2 : ℤ) : ℝ) * (((blockDecode b).2 : ℤ) : ℝ))
        + 18433 * (18433 - 2 * (((blockDecode b).1 : ℤ) : ℝ)
          - (((blockDecode b).2 : ℤ) : ℝ)))
      = ℓ*18433^2 + (ℓ*18433)*(ℓ*18433)/((c0:ℝ) - ℓ)
          + (-((c0:ℝ) - ℓ) * shiftedBlockQ b ((c0:ℝ) - ℓ) (ℓ*18433)) := by
    rw [← neg_mul, halg, hshift]
    ring
  rw [← Real.exp_add, hqc, ha, hE, Real.exp_add]

/-- Block-level twisted weight (assembly): the centered-energy tilt of the
    block mass equals the shifted-potential exponential `exp(−s·Q_shift)` up
    to the two twist constants and the normalizer. -/
theorem twisted_block_weight_eq (b : Block) (ℓ : ℝ) (hreg : region1 b)
    (hs : (c0:ℝ) - ℓ ≠ 0) :
    blockLaw.mass b * Real.exp (ℓ * ((centeredEnergy b : ℤ) : ℝ))
      = Real.exp (ℓ*18433^2 + (ℓ*18433)*(ℓ*18433)/((c0:ℝ) - ℓ))
          * Real.exp (-((c0:ℝ) - ℓ) * shiftedBlockQ b ((c0:ℝ) - ℓ) (ℓ*18433))
          / blockNormalizer := by
  have hmass : blockLaw.mass b = blockWeight b / blockNormalizer := rfl
  rw [hmass, blockWeight_eq_exp b, div_mul_eq_mul_div,
    twisted_weight_exp_eq b ℓ hreg hs]

/-- The `region1`-tilted mass (twisted sector sum): the centered-energy tilt
    of the block law restricted to the triangle. -/
noncomputable def region1TwistMass (ℓ : ℝ) : ℝ :=
  ∑ b : Block, blockLaw.mass b * indicator (region1 b)
      * Real.exp (ℓ * ((centeredEnergy b : ℤ) : ℝ))

/-- Twisted form of the sector sum (pointwise assembly of
    `twisted_block_weight_eq` over `region1`): the tilted sector mass is the
    twist constant over `blockNormalizer` times the `region1`-restricted sum
    of shifted-potential exponentials `exp(−s·shiftedBlockQ)`. -/
theorem region1TwistMass_eq_shifted (ℓ : ℝ) (hs : (c0:ℝ) - ℓ ≠ 0) :
    region1TwistMass ℓ
      = (Real.exp (ℓ*18433^2 + (ℓ*18433)*(ℓ*18433)/((c0:ℝ) - ℓ))
          / blockNormalizer)
          * ∑ b : Block, indicator (region1 b)
              * Real.exp (-((c0:ℝ) - ℓ) * shiftedBlockQ b ((c0:ℝ) - ℓ) (ℓ*18433)) := by
  have hcongr : ∀ b : Block,
      blockLaw.mass b * indicator (region1 b)
          * Real.exp (ℓ * ((centeredEnergy b : ℤ) : ℝ))
        = (Real.exp (ℓ*18433^2 + (ℓ*18433)*(ℓ*18433)/((c0:ℝ) - ℓ))
            / blockNormalizer)
            * (indicator (region1 b)
                * Real.exp (-((c0:ℝ) - ℓ) * shiftedBlockQ b ((c0:ℝ) - ℓ) (ℓ*18433))) := by
    intro b
    by_cases hreg : region1 b
    · simp [indicator, hreg]
      rw [twisted_block_weight_eq b ℓ hreg hs]
      ring
    · simp [indicator, hreg]
  unfold region1TwistMass
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl (fun b _ => hcongr b)

end FT1536.ConvStruct

