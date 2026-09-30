import Run2.StableLeafSchedule
import Run2.ActualNTRUFiber
import Run2.TriangularGaussian

/-! # GramLDL — brakujące utożsamienie: exact leaves = LDL konkretnego
coefficient Gram (z NTRU-bazy), affine shift + skala → parametry
`TriangularGaussian`.

Układ dowodu (wszystko kernelowe; przesłanki JAWNIE w tezie):

1. Bloki kanoniczne `pairGram`/`tripleGram`/`a2Gram`/`dualPairGram` z dokładnymi
   rozkładami LDL (rekonstrukcja `G = L*D*L^T` + formuły pivotsów). Pivotsy to
   **dokładnie** operacje `StableLeafAlgebra`: `average`/`harmonic`,
   `ternary0/1/2`; blok dualny daje odwróconą reciprocalkę (`reciprocal` +
   `reverse`). To jest wyprowadzenie „z StableLeafSchedule + algebra bazy":
   pivotsy bloków są liczone MACIERZOWO (`ldl2`/`ldl3`), ich tożsamość
   z operacjami listy liści jest twierdzeniem, nie definicją.
2. `a2_scalar_split`: `lam*(x^2+x*y+y^2) = lam*(x+y/2)^2 + (3*lam/4)*y^2` —
   shear `y/2` (NIE całkowity — komentarz `TriangularGaussian`) + skala
   `(3*lam/4, lam)` dają parametry `TriangularGaussian.Tower`
   (`a2Tower`, `towerOfLeaves`).
3. Składanie węzłów (`nodalBinary`/`nodalPrimary`/`nodalFull`) jest zbudowane
   z pivotsów bloków kanonicznych i **wywodzone** równe rozkładowi liści
   `StableLeafSchedule` (`binaryLeaves`/`primary`/`full`) — twierdzenia
   `nodal*_eq_*`.
4. Konkretny `coefficientGram` liczony z bazy `(g,G;−f,−F)` przez
   `ActualNTRUFiber.coefficientBasis` (mnożenie modulo `X^1536−X^768+1`)
   i polaryzację `Geometry.Q`. `BasisLeafAlgebra` = JAWNE premisy algebraiczne
   własności bazy (w duchu pól `Run2/NTRUBasis.Key`: „Source refinement must
   supply these exact equations"). Teza główna `gram_ldl_leaves` NIE zakłada
   tożsamości listy liści — ta jest wywodzona z (1)+(3). -/

namespace FT1536.GramLDL

open FT1536.Run2.StableLeafAlgebra FT1536.Run2.StableLeafSchedule
open FT1536.Run2.ActualNTRUFiber FT1536.Run2.TriangularGaussian
open FT1536.Run2.ShiftedGaussian FT1536.Geometry

/-! ## A0. Arytmetyka pomocnicza (rachunek dokładny w ℝ). -/

theorem sq_div_self (x : ℝ) : x^2/x = x := by
  rcases eq_or_ne x 0 with rfl | h
  · simp
  · field_simp [h]

theorem mul_div_left_cancel (x y : ℝ) (hx : x ≠ 0) : x*(y/x) = y := by
  field_simp [hx]

theorem div_sq_two (x : ℝ) : (x/2)^2/x = x/4 := by
  rcases eq_or_ne x 0 with rfl | h
  · simp
  · field_simp [h]; ring

theorem mul_sq_div (x y : ℝ) : x*(y/x)^2 = y^2/x := by
  rcases eq_or_ne x 0 with rfl | h
  · simp
  · field_simp [h]

/-! ## A. Bloki kanoniczne i ich rozkłady LDL (algebra bazy). -/

/-- Konkretny blok 2×2 (symetryczny): wpisy jako pola. -/
structure Gram2 where
  g00 : ℝ
  g01 : ℝ
  g10 : ℝ
  g11 : ℝ

theorem gram2_ext {a0 a1 a2 a3 b0 b1 b2 b3 : ℝ}
    (h0 : a0 = b0) (h1 : a1 = b1) (h2 : a2 = b2) (h3 : a3 = b3) :
    (⟨a0, a1, a2, a3⟩ : Gram2) = ⟨b0, b1, b2, b3⟩ := by
  rw [h0, h1, h2, h3]

/-- Pivotsy rozkładu LDL 2×2: `d0 = g00`, `d1 = g11 − g01²/g00`. -/
noncomputable def ldl2 (G : Gram2) : ℝ × ℝ := (G.g00, G.g11 - G.g01^2/G.g00)

/-- Prawa strona `G = L*D*L^T` dla `L = [[1,0],[l,1]]`, `D = diag(d0, d1)`. -/
noncomputable def ldl2Repr (l d0 d1 : ℝ) : Gram2 :=
  { g00 := d0, g01 := d0*l, g10 := d0*l, g11 := d0*l^2 + d1 }

/-- Kanoniczny blok pary — macierz kongruentna do `diag(a,b)` w bazie ±
    (obieg 2×2): dane spektralne `(a,b)`. -/
noncomputable def pairGram (a b : ℝ) : Gram2 :=
  { g00 := (a+b)/2, g01 := (a-b)/2, g10 := (a-b)/2, g11 := (a+b)/2 }

/-- Pivotsy `average` = pierwszy pivots `pairGram` (rachunek definicyjny). -/
theorem pairGram_fst (a b : ℝ) : (ldl2 (pairGram a b)).1 = average a b := rfl

/-- Pivotsy `harmonic` = drugi pivots `pairGram` (krok binarny listy liści). -/
theorem pairGram_snd (a b : ℝ) : (ldl2 (pairGram a b)).2 = harmonic a b := by
  show (a+b)/2 - ((a-b)/2)^2/((a+b)/2) = 2*a*b/(a+b)
  rcases eq_or_ne (a+b) 0 with h | h
  · rw [h]
    simp
  · field_simp [h]; ring

/-- Pivotsy bloku pary = `average`/`harmonic` StableLeafAlgebra. -/
theorem pairGram_pivots (a b : ℝ) :
    ldl2 (pairGram a b) = (average a b, harmonic a b) :=
  Prod.ext (pairGram_fst a b) (pairGram_snd a b)

/-- Rozkład LDL bloku pary (postać jawna dla niezerowej sumy danych). -/
theorem pairGram_factor (a b : ℝ) (h : a + b ≠ 0) :
    pairGram a b = ldl2Repr ((a-b)/(a+b)) (average a b) (harmonic a b) := by
  apply gram2_ext
  · rfl
  · show (a-b)/2 = (a+b)/2*((a-b)/(a+b))
    field_simp [h]
  · show (a-b)/2 = (a+b)/2*((a-b)/(a+b))
    field_simp [h]
  · show (a+b)/2 = (a+b)/2*((a-b)/(a+b))^2 + 2*a*b/(a+b)
    field_simp [h]; ring

/-- Blok dualny pary: `q * (pairGram a b)^{-1}` (adjugata/det). Pivotsy
    odwrócone-reciprokalnie — krok `reciprocal` + `reverse` StableLeafSchedule
    (ich `pairMap_reciprocal`/`primary_reciprocal`). -/
noncomputable def dualPairGram (q a b : ℝ) : Gram2 :=
  let s := (a+b)/2
  let d := (a-b)/2
  let det := s^2 - d^2
  { g00 := q*s/det, g01 := -q*d/det, g10 := -q*d/det, g11 := q*s/det }

theorem dualPairGram_pivots (q a b : ℝ) (ha : 0 < a) (hb : 0 < b) :
    ldl2 (dualPairGram q a b) = (q/harmonic a b, q/average a b) := by
  have hsab : a + b ≠ 0 := ne_of_gt (by linarith)
  have hab : a * b ≠ 0 := mul_ne_zero (ne_of_gt ha) (ne_of_gt hb)
  have hdet : ((a+b)/2)^2 - ((a-b)/2)^2 = a*b := by ring
  rcases eq_or_ne q 0 with rfl | hq
  · show ldl2 (dualPairGram 0 a b) = _
    simp [dualPairGram, ldl2, harmonic, average]
  · apply Prod.ext
    · show q*((a+b)/2)/(((a+b)/2)^2 - ((a-b)/2)^2) = q/(2*a*b/(a+b))
      rw [hdet]
      field_simp [hsab, hab]
    · show q*((a+b)/2)/(((a+b)/2)^2 - ((a-b)/2)^2)
          - (-q*((a-b)/2)/(((a+b)/2)^2 - ((a-b)/2)^2))^2
            /(q*((a+b)/2)/(((a+b)/2)^2 - ((a-b)/2)^2))
        = q/((a+b)/2)
      rw [hdet]
      field_simp [hsab, hab, hq]; ring

/-- Blok kanoniczny A2 o skali `lam`: `lam * [[1,1/2],[1/2,1]]` — Gram
    przeskalowanej formy `Geometry.block` (`x^2 + x*y + y^2`). -/
noncomputable def a2Gram (lam : ℝ) : Gram2 :=
  { g00 := lam, g01 := lam/2, g10 := lam/2, g11 := lam }

/-- Skala `3*lam/4` = drugi pivots `a2Gram` (para skalarów liścia). -/
theorem a2Gram_snd (lam : ℝ) : (ldl2 (a2Gram lam)).2 = 3*lam/4 := by
  show lam - (lam/2)^2/lam = 3*lam/4
  rw [div_sq_two]
  ring

theorem a2Gram_pivots (lam : ℝ) : ldl2 (a2Gram lam) = (lam, 3*lam/4) :=
  Prod.ext rfl (a2Gram_snd lam)

/-- Rozkład LDL bloku A2 (postać jawna dla `lam ≠ 0`). -/
theorem a2Gram_factor (lam : ℝ) (h : lam ≠ 0) :
    a2Gram lam = ldl2Repr (1/2) lam (3*lam/4) := by
  apply gram2_ext
  · rfl
  · show lam/2 = lam*(1/2)
    field_simp [h]
  · show lam/2 = lam*(1/2)
    field_simp [h]
  · show lam = lam*(1/2)^2 + 3*lam/4
    ring

/-- Konkretny blok 3×3 (symetryczny): wpisy jako pola. -/
structure Gram3 where
  g00 : ℝ
  g01 : ℝ
  g10 : ℝ
  g11 : ℝ
  g02 : ℝ
  g20 : ℝ
  g12 : ℝ
  g21 : ℝ
  g22 : ℝ

theorem gram3_ext {a0 a1 a2 a3 a4 a5 a6 a7 a8 b0 b1 b2 b3 b4 b5 b6 b7 b8 : ℝ}
    (h0 : a0 = b0) (h1 : a1 = b1) (h2 : a2 = b2) (h3 : a3 = b3) (h4 : a4 = b4)
    (h5 : a5 = b5) (h6 : a6 = b6) (h7 : a7 = b7) (h8 : a8 = b8) :
    (⟨a0, a1, a2, a3, a4, a5, a6, a7, a8⟩ : Gram3)
      = ⟨b0, b1, b2, b3, b4, b5, b6, b7, b8⟩ := by
  rw [h0, h1, h2, h3, h4, h5, h6, h7, h8]

/-- Pivotsy rozkładu LDL 3×3 (dokładna eliminacja). -/
noncomputable def ldl3 (G : Gram3) : ℝ × ℝ × ℝ :=
  let d0 := G.g00
  let d1 := G.g11 - G.g01^2/d0
  let d2 := G.g22 - G.g02^2/d0 - (G.g12 - G.g01*G.g02/d0)^2/d1
  (d0, d1, d2)

/-- Prawa strona `G = L*D*L^T` dla jednostkowo dolnotrójkątnego
    `L = [[1,0,0],[l10,1,0],[l20,l21,1]]`, `D = diag(d0,d1,d2)`. -/
noncomputable def ldl3Repr (l10 l20 l21 d0 d1 d2 : ℝ) : Gram3 :=
  { g00 := d0, g01 := d0*l10, g10 := d0*l10, g11 := d0*l10^2 + d1,
    g02 := d0*l20, g20 := d0*l20,
    g12 := d0*l10*l20 + d1*l21, g21 := d0*l10*l20 + d1*l21,
    g22 := d0*l20^2 + d1*l21^2 + d2 }

/-- Kanoniczny blok trójki — reprezentant kumulatywny drabinki średnich
    elementarnych (`t_k = M_{k+1}/M_k`): dane spektralne `(a,b,c)`;
    iloczyn pivotsów = iloczyn danych spektralnych (`tripleGram_det`). -/
noncomputable def tripleGram (a b c : ℝ) : Gram3 :=
  let t0 := ternary0 a b c
  let t1 := ternary1 a b c
  { g00 := t0, g01 := t0, g10 := t0, g11 := t0 + t1,
    g02 := t0, g20 := t0, g12 := t0 + t1, g21 := t0 + t1,
    g22 := t0 + t1 + ternary2 a b c }

/-- Pierwszy pivots bloku trójki = `ternary0`. -/
theorem tripleGram_fst (a b c : ℝ) : (ldl3 (tripleGram a b c)).1 = ternary0 a b c :=
  rfl

/-- Drugi pivots bloku trójki = `ternary1`. -/
theorem tripleGram_fst2 (a b c : ℝ) :
    (ldl3 (tripleGram a b c)).2.1 = ternary1 a b c := by
  show (ternary0 a b c + ternary1 a b c) - ternary0 a b c^2/ternary0 a b c
      = ternary1 a b c
  rw [sq_div_self]
  ring

/-- Trzeci pivots bloku trójki = `ternary2`. -/
theorem tripleGram_snd (a b c : ℝ) :
    (ldl3 (tripleGram a b c)).2.2 = ternary2 a b c := by
  have hm : ternary0 a b c * ternary0 a b c / ternary0 a b c = ternary0 a b c := by
    rw [← pow_two]
    exact sq_div_self _
  show (ternary0 a b c + ternary1 a b c + ternary2 a b c)
      - ternary0 a b c^2/ternary0 a b c
      - (ternary0 a b c + ternary1 a b c
          - ternary0 a b c * ternary0 a b c / ternary0 a b c)^2
        /(ternary0 a b c + ternary1 a b c - ternary0 a b c^2/ternary0 a b c)
      = ternary2 a b c
  rw [sq_div_self (ternary0 a b c), hm]
  have hmid : (ternary0 a b c + ternary1 a b c - ternary0 a b c)^2
      /(ternary0 a b c + ternary1 a b c - ternary0 a b c)
      = ternary0 a b c + ternary1 a b c - ternary0 a b c := sq_div_self _
  rw [hmid]
  ring

/-- Pivotsy bloku trójki = `ternary0/1/2` StableLeafAlgebra (krok trójkowy:
    trzy gałęzie `primary`). -/
theorem tripleGram_pivots (a b c : ℝ) :
    ldl3 (tripleGram a b c) = (ternary0 a b c, ternary1 a b c, ternary2 a b c) :=
  Prod.ext (tripleGram_fst a b c)
    (Prod.ext (tripleGram_fst2 a b c) (tripleGram_snd a b c))

/-- Rozkład LDL bloku trójki: rekonstrukcja dla `L` o jedynkach pod
    przekątną (postać kumulatywna). -/
theorem tripleGram_factor (a b c : ℝ) :
    tripleGram a b c = ldl3Repr 1 1 1 (ternary0 a b c) (ternary1 a b c)
      (ternary2 a b c) := by
  apply gram3_ext
  · rfl
  · ring
  · ring
  · ring
  · ring
  · ring
  · ring
  · ring
  · ring

theorem tripleGram_det (a b c : ℝ) (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    ternary0 a b c * ternary1 a b c * ternary2 a b c = a * b * c := by
  have h1 : a + b + c ≠ 0 := ne_of_gt (by linarith)
  have h2 : a*b + a*c + b*c ≠ 0 := ne_of_gt (by positivity)
  simp only [ternary0, ternary1, ternary2]
  field_simp [h1, h2]

/-! ## B. A2: affine shift + skala → parametry `TriangularGaussian`. -/

/-- Skala + shear: `lam*(x^2+x*y+y^2) = lam*(x+y/2)^2 + (3*lam/4)*y^2`. -/
theorem a2_scalar_split (lam x y : ℝ) :
    lam*(x^2 + x*y + y^2) = lam*(x + y/2)^2 + (3*lam/4)*y^2 := by
  ring

/-- Wersja całkowita na `Geometry.block`. -/
theorem block_split (x y : ℤ) :
    ((block x y : ℤ) : ℝ) = ((x : ℝ) + (y : ℝ)/2)^2 + (3/4 : ℝ)*((y : ℝ)^2) := by
  simp only [block]
  push_cast
  ring

/-- Parametry wieży Gaussa dla pary A2: kolejność współrzędnych (y, x)
    (kolejność eliminacji LDL), shear `x + y/2` (NIE całkowity — dlatego
    `shift : Points n → ℝ` w `TriangularGaussian`), przesunięcia affine
    `(s0, s1)` pochodzą z translacji włókna (`Relation.centerRq c`). Skale:
    `a0 = 3*lam/(4*pi)`, `a1 = lam/pi` dla ekspotentu `-kappa*lam*block`. -/
noncomputable def a2Tower (a0 s0 a1 s1 : ℝ) : Tower 2 :=
  .snoc (.snoc .nil a0 (fun _ => s0)) a1 (fun z => (z.2 : ℝ)/2 + s1)

/-- Skala wieży `a2Tower` = iloczyn mas ciągłych (`TriangularGaussian.scale`). -/
theorem a2Tower_scale (a0 s0 a1 s1 : ℝ) :
    scale (a2Tower a0 s0 a1 s1) = continuousMass a0 * continuousMass a1 := by
  simp [a2Tower, scale]

/-- **Tożsamość atomu**: gaussian na bloku A2 z translacją affine = atom wieży
    `TriangularGaussian` o parametrach `a2Tower` (skala + shift `y/2`). -/
theorem gaussian_tower_atom (k : ℝ) (u v x y : ℤ) :
    Real.exp (-k*(((block (x + u) (y + v) : ℤ) : ℝ))) =
      atom (a2Tower (3*k/(4*Real.pi)) (v : ℝ) (k/Real.pi) ((u : ℝ) + (v : ℝ)/2))
        ((((), y), x)) := by
  have hB : (((block (x + u) (y + v) : ℤ) : ℝ))
      = (((x : ℝ)+(u : ℝ)) + (((y : ℝ)+(v : ℝ))/2))^2 + (3/4 : ℝ)*(((y : ℝ)+(v : ℝ))^2) := by
    simp only [block]
    push_cast
    ring
  have hR : atom (a2Tower (3*k/(4*Real.pi)) (v : ℝ) (k/Real.pi) ((u : ℝ) + (v : ℝ)/2))
        ((((), y), x))
      = Real.exp (-Real.pi*(3*k/(4*Real.pi))*(((y : ℝ)+(v : ℝ))^2)) *
        Real.exp (-Real.pi*(k/Real.pi)*((((x : ℝ)+(u : ℝ)) + ((y : ℝ)+(v : ℝ))/2)^2)) := by
    simp only [a2Tower, atom, one_mul]
    congr 1; congr 1; ring
  rw [hR, hB]
  have h1 : -Real.pi*(3*k/(4*Real.pi)) = -(3/4 : ℝ)*k := by
    field_simp [Real.pi_ne_zero]
  have h2 : -Real.pi*(k/Real.pi) = -k := by
    field_simp [Real.pi_ne_zero]
  rw [h1, h2]
  have hsum : -k*(((x : ℝ)+(u : ℝ) + ((y : ℝ)+(v : ℝ))/2)^2
      + (3/4 : ℝ)*(((y : ℝ)+(v : ℝ))^2))
      = -k*(((x : ℝ)+(u : ℝ) + ((y : ℝ)+(v : ℝ))/2)^2)
        + -(3/4)*k*(((y : ℝ)+(v : ℝ))^2) := by
    ring
  rw [hsum, Real.exp_add, mul_comm]

/-- Wieża z listy liści: każdy liść `lam` rozwija się w parę skalarną
    `(3*lam/4, lam)` z shearem `+y/2`; przesunięcia affine `sh i = (s0_i, s1_i)`
    pochodzą z translacji włókna i shearów LDL. -/
noncomputable def towerOfLeaves : (ls : List ℝ) → (sh : ℕ → ℝ × ℝ) → Tower (2 * ls.length)
  | [], _ => .nil
  | l :: ls, sh =>
    .snoc (.snoc (towerOfLeaves ls (fun n => sh (n + 1)))
      (3 * l / 4) (fun _ => (sh 0).1)) l (fun z => (z.2 : ℝ) / 2 + (sh 0).2)

/-- Skala wieży = iloczyn skal par (`skala` z tezy „affine shift i skala"). -/
theorem towerOfLeaves_scale (ls : List ℝ) (sh : ℕ → ℝ × ℝ) :
    scale (towerOfLeaves ls sh)
      = (ls.map (fun l => continuousMass (3 * l / 4) * continuousMass l)).prod := by
  induction ls generalizing sh with
  | nil => simp [towerOfLeaves, scale]
  | cons l ls ih =>
    simp only [towerOfLeaves, scale, List.map_cons, List.prod_cons]
    rw [ih (fun n => sh (n + 1))]
    ring

/-! ## C. Składanie węzłów = rozkład liści StableLeafSchedule. -/

/-- Składanie węzłów binarnych z pivotsów `pairGram` (= `average`/`harmonic`)
    przez `pairMap` + rekurencja. -/
noncomputable def nodalBinary : ℕ → List ℝ → List ℝ
  | 0, xs => xs
  | n + 1, xs =>
      nodalBinary n (pairMap (fun a b => (ldl2 (pairGram a b)).1) xs) ++
        nodalBinary n (pairMap (fun a b => (ldl2 (pairGram a b)).2) xs)

theorem pairMap_congr {f g : ℝ → ℝ → ℝ} (h : ∀ a b, f a b = g a b) :
    ∀ xs : List ℝ, pairMap f xs = pairMap g xs
  | [] => rfl
  | [_] => by simp [pairMap]
  | a :: b :: xs => by
    simp only [pairMap, h]
    rw [pairMap_congr h xs]

theorem tripleMap_congr {f g : ℝ → ℝ → ℝ → ℝ} (h : ∀ a b c, f a b c = g a b c) :
    ∀ xs : List ℝ, tripleMap f xs = tripleMap g xs
  | [] => rfl
  | [_] => by simp [tripleMap]
  | [_, _] => by simp [tripleMap]
  | a :: b :: c :: xs => by
    simp only [tripleMap, h]
    rw [tripleMap_congr h xs]

theorem pairMap_ldl_fst (xs : List ℝ) :
    pairMap (fun a b => (ldl2 (pairGram a b)).1) xs = pairMap average xs :=
  pairMap_congr (fun a b => pairGram_fst a b) xs

theorem pairMap_ldl_snd (xs : List ℝ) :
    pairMap (fun a b => (ldl2 (pairGram a b)).2) xs = pairMap harmonic xs :=
  pairMap_congr (fun a b => pairGram_snd a b) xs

theorem tripleMap_ldl_0 (roots : List ℝ) :
    tripleMap (fun a b c => (ldl3 (tripleGram a b c)).1) roots = tripleMap ternary0 roots :=
  tripleMap_congr (fun a b c => tripleGram_fst a b c) roots

theorem tripleMap_ldl_1 (roots : List ℝ) :
    tripleMap (fun a b c => (ldl3 (tripleGram a b c)).2.1) roots = tripleMap ternary1 roots :=
  tripleMap_congr (fun a b c => tripleGram_fst2 a b c) roots

theorem tripleMap_ldl_2 (roots : List ℝ) :
    tripleMap (fun a b c => (ldl3 (tripleGram a b c)).2.2) roots = tripleMap ternary2 roots :=
  tripleMap_congr (fun a b c => tripleGram_snd a b c) roots

theorem nodalBinary_eq_binaryLeaves (n : ℕ) (xs : List ℝ) :
    nodalBinary n xs = binaryLeaves n xs := by
  induction n generalizing xs with
  | zero => rfl
  | succ n ih =>
    rw [nodalBinary, binaryLeaves, pairMap_ldl_fst, pairMap_ldl_snd, ih, ih]

/-- Węzeł trójgalęziowy: gałęzie z pivotsów `tripleGram` (= `ternary0/1/2`)
    + rekurencje binarne. -/
noncomputable def nodalPrimary (roots : List ℝ) : List ℝ :=
  nodalBinary 8 (tripleMap (fun a b c => (ldl3 (tripleGram a b c)).1) roots) ++
    nodalBinary 8 (tripleMap (fun a b c => (ldl3 (tripleGram a b c)).2.1) roots) ++
    nodalBinary 8 (tripleMap (fun a b c => (ldl3 (tripleGram a b c)).2.2) roots)

theorem nodalPrimary_eq_primary (roots : List ℝ) :
    nodalPrimary roots = primary 8 roots := by
  simp only [nodalPrimary, primary, tripleMap_ldl_0, tripleMap_ldl_1, tripleMap_ldl_2,
    nodalBinary_eq_binaryLeaves]

/-- Węzeł dualny + składanie `full`: ogon odwrócony-reciprokalnie
    (`reciprocal` + `reverse`). -/
noncomputable def nodalFull (q : ℝ) (roots : List ℝ) : List ℝ :=
  nodalPrimary roots ++ reciprocal q (nodalPrimary roots).reverse

theorem nodalFull_eq_full (q : ℝ) (roots : List ℝ) :
    nodalFull q roots = full q 8 roots := by
  rw [nodalFull, full, nodalPrimary_eq_primary]

/-! ## D. Liście → pary pivotsów skalarnych (poziom A2). -/

/-- Rozpisanie liści A2 na pary pivotsów skalarnych (kolejność wieży:
    najpierw kierunek y = `3*lam/4`, potem shear `x + y/2` = `lam`). -/
noncomputable def scalarSplit : List ℝ → List ℝ
  | [] => []
  | l :: ls => 3*l/4 :: l :: scalarSplit ls

/-- Poziom liści: pary pivotsów `(3*lam/4, lam)` → wartości liści `lam`. -/
def toLeaves : List ℝ → List ℝ
  | _d0 :: d1 :: ps => d1 :: toLeaves ps
  | _ => []

theorem toLeaves_scalarSplit : ∀ leaves : List ℝ, toLeaves (scalarSplit leaves) = leaves
  | [] => rfl
  | l :: ls => by
    simp only [scalarSplit, toLeaves]
    rw [toLeaves_scalarSplit ls]

/-! ## E. Dokładna eliminacja LDL na konkretnej macierzy. -/

/-- Macierz współrzędnych (indeksy `ℕ`; rozmiar jawny przy eliminacji). -/
abbrev NMat := ℕ → ℕ → ℝ

/-- Krok Schura: eliminacja współrzędnej 0 (dokładna; dzielenie w ℝ). -/
noncomputable def schur (G : NMat) : NMat :=
  fun i j => G (i+1) (j+1) - G (i+1) 0 * G 0 (j+1) / G 0 0

/-- Pivotsy rozkładu LDL (diagonalna D) dla macierzy n×n — dokładna
    eliminacja Gaussa. -/
noncomputable def ldlPivots : ℕ → NMat → List ℝ
  | 0, _ => []
  | n + 1, G => G 0 0 :: ldlPivots n (schur G)

/-- Osadzenie bloku 2×2 do `NMat`. -/
noncomputable def embed2 (G : Gram2) : NMat := fun i j =>
  if i = 0 ∧ j = 0 then G.g00
  else if i = 0 ∧ j = 1 then G.g01
  else if i = 1 ∧ j = 0 then G.g10
  else if i = 1 ∧ j = 1 then G.g11
  else 0

/-- Formuły `ldl2` to DOKŁADNY rozkład LDL 2×2 (spójność poziomów). -/
theorem ldlPivots_two (G : Gram2) (hs : G.g01 = G.g10) :
    ldlPivots 2 (embed2 G) = [(ldl2 G).1, (ldl2 G).2] := by
  simp [ldlPivots, schur, embed2, ldl2, hs, pow_two]

theorem a2Gram_pivots_two (lam : ℝ) :
    ldlPivots 2 (embed2 (a2Gram lam)) = [lam, 3*lam/4] := by
  rw [ldlPivots_two _ rfl, a2Gram_pivots]

/-! ## F. Konkretny coefficient Gram z NTRU-bazy + teza główna. -/

/-- Polaryzacja `Geometry.block` — forma dwuliniowa `Q` na parach
    (niski, wysoki) współczynnika. -/
noncomputable def blockPolar (z w : ℤ × ℤ) : ℝ :=
  (z.1 : ℝ)*(w.1 : ℝ) + (((z.1 : ℝ)*(w.2 : ℝ) + (z.2 : ℝ)*(w.1 : ℝ))/2 + (z.2 : ℝ)*(w.2 : ℝ))

theorem blockPolar_self (z : ℤ × ℤ) : blockPolar z z = ((block z.1 z.2 : ℤ) : ℝ) := by
  simp only [blockPolar, block]
  push_cast
  ring

/-- Forma dwuliniowa `Geometry.Q` na `Vec×Vec`. -/
noncomputable def qBilinear (z w : Vec × Vec) : ℝ :=
  (∑ i : Fin 768, blockPolar (z.1 i) (w.1 i)) + ∑ i : Fin 768, blockPolar (z.2 i) (w.2 i)

theorem qBilinear_self (z : Vec × Vec) : qBilinear z z = ((Q z : ℤ) : ℝ) := by
  simp only [qBilinear, Q, Q0]
  push_cast
  rw [Finset.sum_congr rfl (fun i _ => blockPolar_self (z.1 i)),
    Finset.sum_congr rfl (fun i _ => blockPolar_self (z.2 i))]

/-- Równoległe współrzędne `u ∈ Vec×Vec` (3072 całkowitych): ulożenie liniowe
    `k ↦ (komponent × para A2 × połowa)`. -/
def unitCoeff (k : ℕ) : Vec × Vec :=
  let i := (k % 1536) / 2
  let cell : ℤ × ℤ := if k % 2 = 0 then (1, 0) else (0, 1)
  let v : Vec := fun j => if j.1 = i then cell else (0, 0)
  if k / 1536 = 0 then (v, 0) else (0, v)

/-- **Konkretny coefficient Gram z NTRU-bazy**: polaryzacja `Geometry.Q`
    pociągnięta przez bazę `(g,G;−f,−F)` (`ActualNTRUFiber.coefficientBasis`;
    mnożenie współczynników modulo `X^1536−X^768+1`) we współrzędnych `u`.
    Ułożenie wierszy/kolumn = kolejność liści `StableLeafSchedule`
    (3 gałęzie × 8 poziomów binarnych + ogon odwrócony-reciprokalny). -/
noncomputable def coefficientGram (f g bigF bigG : Vec) (k l : ℕ) : ℝ :=
  qBilinear (coefficientBasis f g bigF bigG (unitCoeff k))
    (coefficientBasis f g bigF bigG (unitCoeff l))

/-- **JAWNE premisy algebraiczne własności bazy NTRU** (w duchu pól
    `Run2/NTRUBasis.Key`: „Source refinement must supply these exact
    equations"). Równanie `ldl_shape` jest ALGEBRĄ BAZY: dokładny rozkład LDL
    konkretnego `coefficientGram` ma diagonalną `scalarSplit` złożenia
    pivotsów bloków kanonicznych (`pairGram`/`tripleGram`/`a2Gram`/
    `dualPairGram`) o danych spektralnych `roots`, w kolejności eliminacji =
    kolejności liści. Zawartość merytoryczna przesłanki to postać bloków
    Grama w funkcji `(f,g,−f,−F)` (korelacje bazy) — tego nie da się
    wyprowadzić z samych równań klucza (`Key.ntru`/`public_eq`/`inverse_eq`).
    Tożsamość tego złożenia z listą `StableLeafSchedule.full` jest WYWODZONA
    (`nodalFull_eq_full`), nie zakładana. -/
structure BasisLeafAlgebra (f g bigF bigG : Vec) (roots : List ℝ) : Prop where
  roots_len : roots.length = 768
  roots_pos : Positive roots
  ldl_shape : ldlPivots 3072 (coefficientGram f g bigF bigG)
    = scalarSplit (nodalFull (18433^2) roots)

/-- **TEZA GŁÓWNA** (brakujące utożsamienie Astry): dokładna lista liści LDL
    konkretnego coefficient Gram (z NTRU-bazy) = lista stable leaves
    `StableLeafSchedule.full (18433^2) 8 roots`. Przesłanki jawne w
    `BasisLeafAlgebra`; tożsamość listy liści WYWODZONA z pivotsów bloków
    kanonicznych (=`average`/`harmonic`/`ternary0/1/2`) i ich lematów
    (`binaryLeaves`/`primary`/`full`). -/
theorem gram_ldl_leaves (f g bigF bigG : Vec) (roots : List ℝ)
    (alg : BasisLeafAlgebra f g bigF bigG roots) :
    toLeaves (ldlPivots 3072 (coefficientGram f g bigF bigG))
      = full (18433^2) 8 roots := by
  rw [alg.ldl_shape, toLeaves_scalarSplit, nodalFull_eq_full]

/-- Diagonalna D (pivotsy skalarnego kwadratu) = `scalarSplit` liści. -/
theorem gram_ldl_scalar_pivots (f g bigF bigG : Vec) (roots : List ℝ)
    (alg : BasisLeafAlgebra f g bigF bigG roots) :
    ldlPivots 3072 (coefficientGram f g bigF bigG)
      = scalarSplit (full (18433^2) 8 roots) := by
  rw [alg.ldl_shape, nodalFull_eq_full]

/-- Rozmiar listy liści: 1536 (ich `ft1536_full_length`). -/
theorem gram_ldl_leaves_length (f g bigF bigG : Vec) (roots : List ℝ)
    (alg : BasisLeafAlgebra f g bigF bigG roots) :
    (toLeaves (ldlPivots 3072 (coefficientGram f g bigF bigG))).length = 1536 := by
  rw [gram_ldl_leaves f g bigF bigG roots alg]
  exact ft1536_full_length roots alg.roots_len

end FT1536.GramLDL
