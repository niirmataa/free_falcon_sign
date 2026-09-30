import Run2.RawRadialEvents

set_option maxHeartbeats 4000000

-- Local instance hygiene (LEKCJA: bez democji składnia mean ⟨law⟩ (λ…)
-- rozwija dane elems instancji Fintype — pętla elaboratora).
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

/- ============================================================================
   Strukturalny rozbiór radialSum na regiony trójkątne.

   Silnik arb_radial liczy `4*768 * (masa trójkąta kanonicznego)`; to jest
   warstwa strukturalna uzasadniająca ten rozkład:
   - radialHit z i => blok (z.1 i) leży w jednym z CZTERECH trójkątów
     CenteringTriangle.exact_increase_region;
   - cztery regiony są parami rozłączne (omega na linear bounds);
   - masa mean/indicator rozkłada się na sumę czterech rozłącznych regionów.

   Kolejne etapy (osobne joby): symetria czterech regionów (x4 przez
   neg/swap bloku), symetria współrzędnych (x768 przez swap pary), oraz
   wiązanie binning/CDF-okien silnika z masą zdarzeń.
   ============================================================================ -/

namespace FT1536.Run2.RadialTriangleSplit

open Finset PublicSimulation Geometry RawProductLaw RawRadialEvents CenteringTriangle

/-! ## Cztery regiony wzrostu na poziomie bloku -/

def region1 (b : Block) : Prop := triangle (blockDecode b).1 (blockDecode b).2
def region2 (b : Block) : Prop := triangle (-(blockDecode b).1) (-(blockDecode b).2)
def region3 (b : Block) : Prop := triangle (blockDecode b).2 (blockDecode b).1
def region4 (b : Block) : Prop := triangle (-(blockDecode b).2) (-(blockDecode b).1)

def triangleRegion (b : Block) : Prop :=
  region1 b ∨ region2 b ∨ region3 b ∨ region4 b

/-! ## Rozłączność czterech trójkątów (omega po unfold triangle) -/

theorem triangle_disj_12 (x y : ℤ) : ¬(triangle x y ∧ triangle (-x) (-y)) := by
  intro h
  simp only [triangle] at h
  omega

theorem triangle_disj_13 (x y : ℤ) : ¬(triangle x y ∧ triangle y x) := by
  intro h
  simp only [triangle] at h
  omega

theorem triangle_disj_14 (x y : ℤ) : ¬(triangle x y ∧ triangle (-y) (-x)) := by
  intro h
  simp only [triangle] at h
  omega

theorem triangle_disj_23 (x y : ℤ) : ¬(triangle (-x) (-y) ∧ triangle y x) := by
  intro h
  simp only [triangle] at h
  omega

theorem triangle_disj_24 (x y : ℤ) : ¬(triangle (-x) (-y) ∧ triangle (-y) (-x)) := by
  intro h
  simp only [triangle] at h
  omega

theorem triangle_disj_34 (x y : ℤ) : ¬(triangle y x ∧ triangle (-y) (-x)) := by
  intro h
  simp only [triangle] at h
  omega

theorem region_disj_12 (b : Block) : ¬(region1 b ∧ region2 b) :=
  triangle_disj_12 (blockDecode b).1 (blockDecode b).2

theorem region_disj_13 (b : Block) : ¬(region1 b ∧ region3 b) :=
  triangle_disj_13 (blockDecode b).1 (blockDecode b).2

theorem region_disj_14 (b : Block) : ¬(region1 b ∧ region4 b) :=
  triangle_disj_14 (blockDecode b).1 (blockDecode b).2

theorem region_disj_23 (b : Block) : ¬(region2 b ∧ region3 b) :=
  triangle_disj_23 (blockDecode b).1 (blockDecode b).2

theorem region_disj_24 (b : Block) : ¬(region2 b ∧ region4 b) :=
  triangle_disj_24 (blockDecode b).1 (blockDecode b).2

theorem region_disj_34 (b : Block) : ¬(region3 b ∧ region4 b) :=
  triangle_disj_34 (blockDecode b).1 (blockDecode b).2

/-! ## Zdarzenie radialHit implikuje region (exact_increase_region) -/

theorem radialHit_increase (z : BoxPair) (i : Fin 768)
    (h : radialHit z i) : blockEnergy (z.1 i) < centeredEnergy (z.1 i) := by
  simp only [radialHit, oneChange] at h
  omega

theorem radialHit_region (z : BoxPair) (i : Fin 768)
    (h : radialHit z i) : triangleRegion (z.1 i) := by
  have hinc := radialHit_increase z i h
  have hgr : Geometry.block (blockDecode (z.1 i)).1 (blockDecode (z.1 i)).2 <
      Geometry.block (center (blockDecode (z.1 i)).1) (center (blockDecode (z.1 i)).2) := by
    simpa only [blockEnergy, centeredEnergy] using hinc
  exact (exact_increase_region (blockDecode (z.1 i)).1 (blockDecode (z.1 i)).2).mp hgr

theorem radialHit_or4 (z : BoxPair) (i : Fin 768) :
    radialHit z i ↔
      (radialHit z i ∧ region1 (z.1 i)) ∨ (radialHit z i ∧ region2 (z.1 i))
        ∨ (radialHit z i ∧ region3 (z.1 i)) ∨ (radialHit z i ∧ region4 (z.1 i)) := by
  constructor
  · intro h
    rcases radialHit_region z i h with h1 | h2 | h3 | h4
    · exact Or.inl ⟨h, h1⟩
    · exact Or.inr (Or.inl ⟨h, h2⟩)
    · exact Or.inr (Or.inr (Or.inl ⟨h, h3⟩))
    · exact Or.inr (Or.inr (Or.inr ⟨h, h4⟩))
  · rintro (⟨h, _⟩ | ⟨h, _⟩ | ⟨h, _⟩ | ⟨h, _⟩) <;> exact h

/-! ## Addytywność mean/indicator dla rozłącznych alternatyw -/

theorem mean_congr {Ω : Type*} [Fintype Ω] (p : Law Ω) (f g : Ω → ℝ)
    (h : ∀ x, f x = g x) : mean p f = mean p g :=
  Finset.sum_congr rfl (fun x _ => congrArg (fun t => p.mass x * t) (h x))

theorem mean_or4_disjoint {Ω : Type*} [Fintype Ω] (p : Law Ω)
    (A B C D : Ω → Prop)
    (hAB : ∀ x, ¬(A x ∧ B x)) (hAC : ∀ x, ¬(A x ∧ C x)) (hAD : ∀ x, ¬(A x ∧ D x))
    (hBC : ∀ x, ¬(B x ∧ C x)) (hBD : ∀ x, ¬(B x ∧ D x)) (hCD : ∀ x, ¬(C x ∧ D x)) :
    mean p (fun x => indicator (A x ∨ B x ∨ C x ∨ D x)) =
      mean p (fun x => indicator (A x)) + mean p (fun x => indicator (B x))
        + mean p (fun x => indicator (C x)) + mean p (fun x => indicator (D x)) := by
  classical
  simp only [mean]
  have hpoint : ∀ x,
      p.mass x * indicator (A x ∨ B x ∨ C x ∨ D x) =
        p.mass x * indicator (A x) + p.mass x * indicator (B x)
          + p.mass x * indicator (C x) + p.mass x * indicator (D x) := by
    intro x
    by_cases ha : A x
    · have hb : ¬B x := fun hb => hAB x ⟨ha, hb⟩
      have hc : ¬C x := fun hc => hAC x ⟨ha, hc⟩
      have hd : ¬D x := fun hd => hAD x ⟨ha, hd⟩
      simp [indicator, ha, hb, hc, hd]
    · by_cases hb : B x
      · have hc : ¬C x := fun hc => hBC x ⟨hb, hc⟩
        have hd : ¬D x := fun hd => hBD x ⟨hb, hd⟩
        simp [indicator, ha, hb, hc, hd]
      · by_cases hc : C x
        · have hd : ¬D x := fun hd => hCD x ⟨hc, hd⟩
          simp [indicator, ha, hb, hc, hd]
        · by_cases hd : D x
          · simp [indicator, ha, hb, hc, hd]
          · simp [indicator, ha, hb, hc, hd]
  simp_rw [hpoint]
  rw [Finset.sum_add_distrib, Finset.sum_add_distrib, Finset.sum_add_distrib]

/-! ## Rozbiór zdarzenia radialHit na cztery regiony -/

theorem radialHit_mean_4sum (i : Fin 768) :
    mean rawLaw (fun z => indicator (radialHit z i)) =
      mean rawLaw (fun z => indicator (radialHit z i ∧ region1 (z.1 i)))
        + mean rawLaw (fun z => indicator (radialHit z i ∧ region2 (z.1 i)))
        + mean rawLaw (fun z => indicator (radialHit z i ∧ region3 (z.1 i)))
        + mean rawLaw (fun z => indicator (radialHit z i ∧ region4 (z.1 i))) := by
  classical
  have hdisj12 : ∀ z : BoxPair,
      ¬((radialHit z i ∧ region1 (z.1 i)) ∧ (radialHit z i ∧ region2 (z.1 i))) :=
    fun z h => region_disj_12 (z.1 i) ⟨h.1.2, h.2.2⟩
  have hdisj13 : ∀ z : BoxPair,
      ¬((radialHit z i ∧ region1 (z.1 i)) ∧ (radialHit z i ∧ region3 (z.1 i))) :=
    fun z h => region_disj_13 (z.1 i) ⟨h.1.2, h.2.2⟩
  have hdisj14 : ∀ z : BoxPair,
      ¬((radialHit z i ∧ region1 (z.1 i)) ∧ (radialHit z i ∧ region4 (z.1 i))) :=
    fun z h => region_disj_14 (z.1 i) ⟨h.1.2, h.2.2⟩
  have hdisj23 : ∀ z : BoxPair,
      ¬((radialHit z i ∧ region2 (z.1 i)) ∧ (radialHit z i ∧ region3 (z.1 i))) :=
    fun z h => region_disj_23 (z.1 i) ⟨h.1.2, h.2.2⟩
  have hdisj24 : ∀ z : BoxPair,
      ¬((radialHit z i ∧ region2 (z.1 i)) ∧ (radialHit z i ∧ region4 (z.1 i))) :=
    fun z h => region_disj_24 (z.1 i) ⟨h.1.2, h.2.2⟩
  have hdisj34 : ∀ z : BoxPair,
      ¬((radialHit z i ∧ region3 (z.1 i)) ∧ (radialHit z i ∧ region4 (z.1 i))) :=
    fun z h => region_disj_34 (z.1 i) ⟨h.1.2, h.2.2⟩
  have h4 := mean_or4_disjoint rawLaw
    (fun z => radialHit z i ∧ region1 (z.1 i))
    (fun z => radialHit z i ∧ region2 (z.1 i))
    (fun z => radialHit z i ∧ region3 (z.1 i))
    (fun z => radialHit z i ∧ region4 (z.1 i))
    hdisj12 hdisj13 hdisj14 hdisj23 hdisj24 hdisj34
  have hcongr := mean_congr rawLaw
    (fun z => indicator (radialHit z i))
    (fun z => indicator
      ((fun z => radialHit z i ∧ region1 (z.1 i)) z
        ∨ (fun z => radialHit z i ∧ region2 (z.1 i)) z
        ∨ (fun z => radialHit z i ∧ region3 (z.1 i)) z
        ∨ (fun z => radialHit z i ∧ region4 (z.1 i)) z))
    (fun z => congrArg indicator (propext (radialHit_or4 z i)))
  exact hcongr.trans h4

/-! ## RadialSum: suma po 768 współrzędnych rozbita na cztery regiony -/

theorem radialSum_4sum :
    radialSum = ∑ i : Fin 768,
      (mean rawLaw (fun z => indicator (radialHit z i ∧ region1 (z.1 i)))
        + mean rawLaw (fun z => indicator (radialHit z i ∧ region2 (z.1 i)))
        + mean rawLaw (fun z => indicator (radialHit z i ∧ region3 (z.1 i)))
        + mean rawLaw (fun z => indicator (radialHit z i ∧ region4 (z.1 i)))) := by
  classical
  have hm (i : Fin 768) :
      mean rawLaw (fun z => indicator (radialHit z i)) = rawLaw.event (fun z => radialHit z i) :=
    mean_indicator _ _
  show (∑ i : Fin 768, rawLaw.event (fun z => radialHit z i)) = _
  simp_rw [← hm, radialHit_mean_4sum]

#print axioms radialHit_region
#print axioms mean_or4_disjoint
#print axioms radialHit_mean_4sum
#print axioms radialSum_4sum

end FT1536.Run2.RadialTriangleSplit
