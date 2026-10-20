import GramLDL
import SourceLeafBridge
import Run2.T5ScalarMass

/-! # PerKeyTransport — złożenie per-key: liście+LDL → affine shift/skala →
`TriangularGaussian`/`T5ScalarMass` dla każdego `h` z `Adm`.

`Adm` jest abstrakcyjnym parametrem modelu (dopuszczone klucze — decyzja
właściciela). Dla każdego `h : Adm`:

1. **liście + LDL**: lista liści klucza = `toLeaves (ldlPivots 3072
   (coefficientGram …))` (`GramLDL.gram_ldl_leaves`, przesłanki-algebry-bazy
   jawne w `BasisLeafAlgebra`),
2. **affine shift + skala**: wieża `Tower 3072` z `pivotScale`-skalowanych
   pivotsów `(3*lam/4, lam)` (`GramLDL.towerOfLeaves` w wariancie skalowanym),
   shear `y/2` + translacja włókna (`Relation.centerRq c`),
3. **transport masy T5**: `T5ScalarMass.uniform_shifted_mass_3072` — sandwich
   `(1±massBudget)*scale` dla `total` = **wkład per-key do FinalDelta**
   (`CENTERING_CLOSURE/FinalTails`); warunki `CoefficientRange` z brzegów liści
   (`SourceLeafBridge`: `> 991` ⇒ `≤ 18433^2/991`).

Most do włókna: `perKey_fiber_reindex` = ich `gaussian_fiber_in_basis`
per-key (sumy po `{z // A h z = c}` → współrzędne `u`), gdzie działa
`GramLDL.gaussian_tower_atom` (tożsamość atomu pary A2). -/

namespace FT1536.PerKeyTransport

open FT1536.GramLDL FT1536.SourceLeafBridge
open FT1536.Run2.StableLeafSchedule FT1536.Run2.StableLeafAlgebra
open FT1536.Run2.TriangularGaussian FT1536.Run2.ShiftedGaussian
open FT1536.Run2.T5ScalarMass FT1536.Run2.ActualNTRUFiber
open FT1536.Run2.CoefficientQuotient
open FT1536.Geometry FT1536.Relation

/-! ## A. Skala pivots → współczynniki wieży (`a = pivot/(2π·768²)`). -/

/-- Skalowanie pivots → `a` wieży Gaussa: `a = pivot/(2*pi*768^2)`
    (ta sama normalizacja co `T5ScalarMass.maxCoefficient`). -/
noncomputable def pivotScale : ℝ := 1/(2*Real.pi*768^2)

theorem pivotScale_pos : 0 < pivotScale := by
  unfold pivotScale
  positivity

/-- `maxCoefficient` to dokładnie `q²/991` przeskalowane `pivotScale`
    (`q = 18433`): `a ≤ maxCoefficient ↔ pivot ≤ q²/991`. -/
theorem maxCoefficient_eq :
    maxCoefficient = ((18433^2 : ℝ)/991) * pivotScale := by
  have hd : ((991:ℝ)*2*Real.pi*768^2) ≠ 0 := by positivity
  have hd2 : ((2:ℝ)*Real.pi*768^2) ≠ 0 := by positivity
  simp only [maxCoefficient, pivotScale]
  field_simp [hd, hd2]

theorem three_quarter_le (x : ℝ) (hx : 0 ≤ x) : 3*x/4 ≤ x := by
  rw [div_le_iff₀ (by norm_num : (0:ℝ) < 4)]
  linarith

/-! ## B. Wieża per-key ze skalowanymi pivotsami. -/

/-- Wieża `Tower (2 * ls.length)` ze skalowanymi pivotsami liści:
    `a = (3*lam/4, lam) * pivotScale`, shear `x + y/2`, affine shift `sh`. -/
noncomputable def towerOfScaledLeaves : (ls : List ℝ) → (sh : ℕ → ℝ × ℝ) → Tower (2 * ls.length)
  | [], _ => .nil
  | l :: ls, sh =>
    .snoc (.snoc (towerOfScaledLeaves ls (fun n => sh (n + 1)))
      (3 * (l * pivotScale) / 4) (fun _ => (sh 0).1)) (l * pivotScale)
      (fun z => (z.2 : ℝ) / 2 + (sh 0).2)

theorem towerOfScaledLeaves_scale (ls : List ℝ) (sh : ℕ → ℝ × ℝ) :
    scale (towerOfScaledLeaves ls sh)
      = (ls.map (fun l => continuousMass (3 * (l * pivotScale) / 4) *
        continuousMass (l * pivotScale))).prod := by
  induction ls generalizing sh with
  | nil => simp [towerOfScaledLeaves, scale]
  | cons l ls ih =>
    simp only [towerOfScaledLeaves, scale, List.map_cons, List.prod_cons]
    rw [ih (fun n => sh (n + 1))]
    ring

theorem scale_cast {n m : ℕ} (h : n = m) (T : Tower n) :
    scale (cast (congrArg Tower h) T) = scale T := by
  cases h
  rfl

theorem total_cast {n m : ℕ} (h : n = m) (T : Tower n) :
    total (cast (congrArg Tower h) T) = total T := by
  cases h
  rfl

theorem coefficientRange_cast {n m : ℕ} (h : n = m) (T : Tower n) :
    CoefficientRange (cast (congrArg Tower h) T) ↔ CoefficientRange T := by
  cases h
  exact Iff.rfl

/-- `CoefficientRange` wieży ze skalowanymi pivotsami WYŁĄCZNIE z brzegów liści
    (`991 ≤ leaf ≤ 18433^2/991` — oba z `SourceLeafBridge`). -/
theorem coefficientRange_scaled :
    ∀ (ls : List ℝ) (sh : ℕ → ℝ × ℝ),
      (∀ l ∈ ls, (991 : ℝ) ≤ l) → (∀ l ∈ ls, l ≤ (18433^2 : ℝ)/991) →
      CoefficientRange (towerOfScaledLeaves ls sh)
  | [], _, _, _ => trivial
  | l :: ls, sh, hlo, hhi => by
    have hmem : l ∈ l :: ls := by simp
    have hpos : 0 < l := by linarith [hlo l hmem]
    have hp : 0 < pivotScale := pivotScale_pos
    have hax : 0 < l * pivotScale := mul_pos hpos hp
    have hlo' : ∀ x ∈ ls, (991 : ℝ) ≤ x := fun x hx => hlo x (by simp [hx])
    have hhi' : ∀ x ∈ ls, x ≤ (18433^2 : ℝ)/991 := fun x hx => hhi x (by simp [hx])
    have ih := coefficientRange_scaled ls (fun n => sh (n + 1)) hlo' hhi'
    have ha1 : l * pivotScale ≤ maxCoefficient := by
      rw [maxCoefficient_eq]
      exact mul_le_mul_of_nonneg_right (hhi l hmem) hp.le
    have ha0 : 3 * (l * pivotScale) / 4 ≤ maxCoefficient :=
      (three_quarter_le _ hax.le).trans ha1
    have h0p : 0 < 3 * (l * pivotScale) / 4 :=
      div_pos (mul_pos (by norm_num) hax) (by norm_num)
    simp only [towerOfScaledLeaves, CoefficientRange]
    exact ⟨⟨ih, h0p, ha0⟩, hax, ha1⟩

/-! ## C. Model per-key (`Adm` — abstrakcyjny parametr: dopuszczone klucze). -/

/-- Model per-key: klucz `h : Adm` niesie dane algebry bazy `(f,g,−f,−F)`
    z równaniami NTRU (`Run2.NTRUBasis.Key` — jawne równania!), roots grafu
    liści, przesunięcia affine wieży, dane bramki i kontrakt Warstwy 2. -/
structure PerKeyModel (Adm : Type) where
  pub : Adm → Rq
  f : Adm → Vec
  g : Adm → Vec
  bigF : Adm → Vec
  bigG : Adm → Vec
  fInv : Adm → Rq
  c : Adm → Rq
  rootsOf : Adm → List ℝ
  shiftOf : Adm → ℕ → ℝ × ℝ
  ntru : ∀ h, multiply (f h) (bigG h) - multiply (g h) (bigF h)
    = constantCoeffs (18433 : ℤ)
  public_eq : ∀ h, mulRq (pub h) (reduceVec (f h)) = reduceVec (g h)
  inverse_eq : ∀ h, mulRq (fInv h) (reduceVec (f h))
    = constantCoeffs (1 : ZMod 18433)
  alg : ∀ h, BasisLeafAlgebra (f h) (g h) (bigF h) (bigG h) (rootsOf h)
  gate : ∀ h, LeafGateData (rootsOf h)

/-- Indeks-pomost: `2 * leaves.length = 3072` dla liści o długości 1536. -/
theorem two_mul_len (leaves : List ℝ) (hlen : leaves.length = 1536) :
    2 * leaves.length = 3072 :=
  Eq.trans (congrArg (fun n : ℕ => 2 * n) hlen)
    (by norm_num : (2:ℕ) * 1536 = 3072)

theorem perKey_leaves_len {Adm : Type} (M : PerKeyModel Adm) (h : Adm) :
    (full (18433^2) 8 (M.rootsOf h)).length = 1536 :=
  ft1536_full_length (M.rootsOf h) ((M.alg h).roots_len)

/-! ## D. Złożenie — twierdzenia per-key (każde `h : Adm`, kernelowo). -/

/-- **Liście + LDL** per-key: lista liści = pivotsy LDL konkretnego
    coefficient Gram klucza (`GramLDL.gram_ldl_leaves`). -/
theorem perKey_ldl_leaves {Adm : Type} (M : PerKeyModel Adm) (h : Adm) :
    toLeaves (ldlPivots 3072 (coefficientGram (M.f h) (M.g h) (M.bigF h) (M.bigG h)))
      = full (18433^2) 8 (M.rootsOf h) :=
  gram_ldl_leaves (M.f h) (M.g h) (M.bigF h) (M.bigG h) (M.rootsOf h) (M.alg h)

/-- **Skala** per-key: `scale` wieży = iloczyn skal par liścia
    (`GramLDL`-skala + `ShiftedGaussian.continuousMass`) — forma na
    `towerOfScaledLeaves` (postać skalowanych pivotsów `(3*lam/4, lam)`). -/
theorem perKey_scale {Adm : Type} (M : PerKeyModel Adm) (h : Adm) :
    scale (towerOfScaledLeaves (full (18433^2) 8 (M.rootsOf h)) (M.shiftOf h))
      = ((full (18433^2) 8 (M.rootsOf h)).map (fun l =>
        continuousMass (3 * (l * pivotScale) / 4) * continuousMass (l * pivotScale))).prod :=
  towerOfScaledLeaves_scale _ _

/-- **Most włókna** per-key: ich `gaussian_fiber_in_basis` — masa gaussowska
    po włóknie `A (pub h) z = c h` = suma po współrzędnych `u` bazy
    `(g,G;−f,−F)` z translacją `(centerRq (c h), 0)`. Tu wchodzi
    `GramLDL.gaussian_tower_atom` (tożsamość atomu pary A2). -/
theorem perKey_fiber_reindex {Adm : Type} (M : PerKeyModel Adm) (h : Adm) (a : ℝ) :
    (∑' z : {z : Vec×Vec // A (M.pub h) z = M.c h},
      Real.exp (-a*(Geometry.Q z.val : ℝ)))
      = ∑' u : Vec×Vec,
        Real.exp (-a*(Geometry.Q ((centerRq (M.c h), 0) +
          coefficientBasis (M.f h) (M.g h) (M.bigF h) (M.bigG h) u) : ℝ)) :=
  gaussian_fiber_in_basis (M.f h) (M.g h) (M.bigF h) (M.bigG h) (M.pub h) (M.fInv h) (M.c h)
    (M.ntru h) (M.public_eq h) (M.inverse_eq h) a

/-- Ogólna teza transportu masy dla dowolnej listy liści o długości 1536
    (`uniform_shifted_mass_3072` po transporcie indeksu) — forma zmiennych
    (tanich dla unifikacji), na której instancjonuje się twierdzenie per-key. -/
theorem mass_bounds_of_leaves (leaves : List ℝ) (hlen : leaves.length = 1536)
    (sh : ℕ → ℝ × ℝ)
    (hlo : ∀ l ∈ leaves, (991 : ℝ) ≤ l) (hhi : ∀ l ∈ leaves, l ≤ (18433^2 : ℝ)/991) :
    (1 - massBudget) * scale (towerOfScaledLeaves leaves sh)
        ≤ total (towerOfScaledLeaves leaves sh) ∧
      total (towerOfScaledLeaves leaves sh)
        ≤ (1 + massBudget) * scale (towerOfScaledLeaves leaves sh) := by
  have h2 := two_mul_len leaves hlen
  have hs : scale (cast (congrArg Tower h2) (towerOfScaledLeaves leaves sh))
      = scale (towerOfScaledLeaves leaves sh) :=
    scale_cast h2 (towerOfScaledLeaves leaves sh)
  have ht : total (cast (congrArg Tower h2) (towerOfScaledLeaves leaves sh))
      = total (towerOfScaledLeaves leaves sh) :=
    total_cast h2 (towerOfScaledLeaves leaves sh)
  have key := uniform_shifted_mass_3072
    (cast (congrArg Tower h2) (towerOfScaledLeaves leaves sh))
    ((coefficientRange_cast h2 (towerOfScaledLeaves leaves sh)).2
      (coefficientRange_scaled leaves sh hlo hhi))
  rw [hs, ht] at key
  exact key

/-- **TEZA PER-KEY (wyjście dla FinalDelta)**: dla każdego `h : Adm` masa
    trójkątnego Gaussa klucza w sandwichu `(1±massBudget)*scale` — dokładny
    transport `T5ScalarMass.uniform_shifted_mass_3072` (`massBudget = 2^−34`). -/
theorem perKey_mass_bounds {Adm : Type} (M : PerKeyModel Adm) (h : Adm) :
    (1 - massBudget)
        * scale (towerOfScaledLeaves (full (18433^2) 8 (M.rootsOf h)) (M.shiftOf h))
        ≤ total (towerOfScaledLeaves (full (18433^2) 8 (M.rootsOf h)) (M.shiftOf h)) ∧
      total (towerOfScaledLeaves (full (18433^2) 8 (M.rootsOf h)) (M.shiftOf h))
        ≤ (1 + massBudget)
            * scale (towerOfScaledLeaves (full (18433^2) 8 (M.rootsOf h)) (M.shiftOf h)) :=
  mass_bounds_of_leaves (full (18433^2) 8 (M.rootsOf h)) (perKey_leaves_len M h)
    (M.shiftOf h)
    (fun x hx => (schedule_leaf_bounds (M.rootsOf h) (M.gate h)).1 x hx)
    (fun x hx => (schedule_leaf_bounds (M.rootsOf h) (M.gate h)).2 x hx)

end FT1536.PerKeyTransport
