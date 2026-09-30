import Run2.RawProductLaw
import Run2.CenteringTriangle

attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.Run2.RawRadialEvents
open Finset PublicSimulation Geometry RawProductLaw LegalKeyErrorTransfer

def before (z : BoxPair) : ℤ := Q (decode z)
def after (z : BoxPair) : ℤ := Q (centerVec (decode z).1,(decode z).2)
def centeredEnergy (b : Block) : ℤ :=
  Geometry.block (center (blockDecode b).1) (center (blockDecode b).2)
def changed (b : Block) : Prop := centeredEnergy b≠blockEnergy b
def normBad (z : BoxPair) : Prop := before z<B ∧ B≤after z
def emitBad (z : BoxPair) : Prop := ¬PublicSimulation.signed16 z.2
def oneChange (z : BoxPair) (i : Fin 768) : ℤ :=
  before z-blockEnergy (z.1 i)+centeredEnergy (z.1 i)
def radialHit (z : BoxPair) (i : Fin 768) : Prop := before z<B ∧ B≤oneChange z i

noncomputable def indicator (P : Prop) : ℝ := by
  classical
  exact if P then 1 else 0
noncomputable def surrogate (z : BoxPair) : ℝ := ∑ i : Fin 768,indicator (radialHit z i)
noncomputable def orderedPairs (z : BoxPair) : ℝ :=
  ∑ i : Fin 768, ∑ j : Fin 768, indicator (i≠j ∧ changed (z.1 i) ∧ changed (z.1 j))

theorem indicator_nonnegative (P : Prop) : 0 ≤ indicator P := by
  classical
  unfold indicator
  split_ifs <;> norm_num

theorem indicator_le_one (P : Prop) : indicator P≤1 := by
  classical
  unfold indicator
  split_ifs <;> norm_num

theorem rawEvent_iff (z : BoxPair) : rawEvent z ↔ normBad z ∧ ¬emitBad z := by
  constructor
  · rintro ⟨hq,hs,hbad⟩
    exact ⟨⟨hq,not_lt.mp hbad⟩,not_not.mpr hs⟩
  · rintro ⟨⟨hq,hbad⟩,hs⟩
    exact ⟨hq,not_not.mp hs,not_lt.mpr hbad⟩

theorem raw_norm_indicators (z : BoxPair) :
    indicator (rawEvent z) ≤ indicator (normBad z) ∧
      indicator (normBad z) ≤ indicator (rawEvent z)+indicator (emitBad z) := by
  classical
  rw [show rawEvent z = (normBad z ∧ ¬emitBad z) from propext (rawEvent_iff z)]
  by_cases hn : normBad z <;> by_cases he : emitBad z <;> simp [indicator,hn,he]

theorem total_change (z : BoxPair) :
    after z=before z+∑ i : Fin 768,(centeredEnergy (z.1 i)-blockEnergy (z.1 i)) := by
  unfold after before Q Q0 centeredEnergy blockEnergy
  simp only [decode, centerVec, decodeVec, blockDecode]
  rw [sum_sub_distrib]
  ring

theorem one_changed_coordinate (z : BoxPair) (i : Fin 768)
    (h : ∀ j, j≠i → ¬changed (z.1 j)) : after z=oneChange z i := by
  have he : (∑ j : Fin 768,(centeredEnergy (z.1 j)-blockEnergy (z.1 j))) =
      centeredEnergy (z.1 i)-blockEnergy (z.1 i) := by
    apply sum_eq_single i
    · intro j _ hji
      have hj : centeredEnergy (z.1 j)=blockEnergy (z.1 j) := not_ne_iff.mp (h j hji)
      rw [hj,sub_self]
    · simp
  rw [total_change, he]
  unfold oneChange
  ring

theorem radialHit_changed (z : BoxPair) (i : Fin 768) (h : radialHit z i) : changed (z.1 i) := by
  intro he
  unfold radialHit oneChange at h
  rw [he] at h
  omega

theorem no_double_change (z : BoxPair)
    (h : ¬∃ i j : Fin 768, i≠j ∧ changed (z.1 i) ∧ changed (z.1 j)) :
    surrogate z=indicator (normBad z) := by
  classical
  by_cases hc : ∃ i : Fin 768, changed (z.1 i)
  · obtain ⟨i,hi⟩ := hc
    have hj : ∀ j, j≠i → ¬changed (z.1 j) := by
      intro j hji hcj
      exact h ⟨i,j,Ne.symm hji,hi,hcj⟩
    have he := one_changed_coordinate z i hj
    have hh : normBad z ↔ radialHit z i := by simp only [normBad,radialHit,he]
    unfold surrogate
    rw [sum_eq_single i]
    · exact congrArg indicator (propext hh.symm)
    · intro j _ hji
      have hn : ¬radialHit z j := fun hh => hj j hji (radialHit_changed z j hh)
      simp [indicator,hn]
    · simp
  · have hn : ∀ i : Fin 768, ¬changed (z.1 i) := by simpa using hc
    have he := one_changed_coordinate z 0 (fun j _ => hn j)
    have h0 : centeredEnergy (z.1 0)=blockEnergy (z.1 0) := not_ne_iff.mp (hn 0)
    have ha : after z=before z := by rw [he,oneChange,h0]; omega
    have hb : ¬normBad z := by simp only [normBad,ha]; omega
    have hh : ∀ i, ¬radialHit z i := fun i hi => hn i (radialHit_changed z i hi)
    simp [surrogate,indicator,hh,hb]

theorem double_change_dominates (z : BoxPair)
    (h : ∃ i j : Fin 768, i≠j ∧ changed (z.1 i) ∧ changed (z.1 j)) :
    surrogate z≤orderedPairs z ∧ (1 : ℝ)≤orderedPairs z := by
  classical
  obtain ⟨i,j,hij,hi,hj⟩ := h
  have other (k : Fin 768) : ∃ l, k≠l ∧ changed (z.1 l) := by
    by_cases hk : k=i
    · exact ⟨j,by simpa only [hk] using hij,hj⟩
    · exact ⟨i,hk,hi⟩
  constructor
  · unfold surrogate orderedPairs
    apply sum_le_sum
    intro k _
    by_cases hk : radialHit z k
    · obtain ⟨l,hkl,hl⟩ := other k
      have he : k≠l ∧ changed (z.1 k) ∧ changed (z.1 l) :=
        ⟨hkl,radialHit_changed z k hk,hl⟩
      have hh := single_le_sum
        (fun l' _ => indicator_nonnegative (k≠l' ∧ changed (z.1 k) ∧ changed (z.1 l')))
        (mem_univ l)
      simpa only [indicator,ite_eq_left hk,ite_eq_left he] using hh
    · simp only [indicator,ite_eq_right hk]
      exact sum_nonneg fun _ _ => indicator_nonnegative _
  · have hrow := single_le_sum
      (fun l _ => indicator_nonnegative (i≠l ∧ changed (z.1 i) ∧ changed (z.1 l))) (mem_univ j)
    have hall : (∑ l : Fin 768,indicator (i≠l ∧ changed (z.1 i) ∧ changed (z.1 l)))≤orderedPairs z :=
      single_le_sum
        (fun k _ => sum_nonneg (s:=univ) fun l _ =>
          indicator_nonnegative (k≠l ∧ changed (z.1 k) ∧ changed (z.1 l)))
        (mem_univ i)
    have he : i≠j ∧ changed (z.1 i) ∧ changed (z.1 j) := ⟨hij,hi,hj⟩
    have hh : (1 : ℝ)≤∑ l : Fin 768,indicator (i≠l ∧ changed (z.1 i) ∧ changed (z.1 l)) := by
      simpa only [indicator,ite_eq_left he] using hrow
    exact hh.trans hall

theorem pointwise_sandwich (z : BoxPair) :
    surrogate z-orderedPairs z-indicator (emitBad z) ≤ indicator (rawEvent z) ∧
      indicator (rawEvent z)≤surrogate z+orderedPairs z := by
  have hs : 0≤surrogate z := sum_nonneg fun _ _ => indicator_nonnegative _
  have hp : 0≤orderedPairs z := sum_nonneg fun _ _ => sum_nonneg fun _ _ => indicator_nonnegative _
  have he := indicator_nonnegative (emitBad z)
  have hr := indicator_nonnegative (rawEvent z)
  by_cases hm : ∃ i j : Fin 768, i≠j ∧ changed (z.1 i) ∧ changed (z.1 j)
  · obtain ⟨h0,h1⟩ := double_change_dominates z hm
    have hu := indicator_le_one (rawEvent z)
    constructor <;> linarith
  · rw [no_double_change z hm]
    obtain ⟨h0,h1⟩ := raw_norm_indicators z
    constructor <;> linarith

noncomputable def mean {Ω : Type*} [Fintype Ω] (p : Law Ω) (f : Ω → ℝ) : ℝ :=
  ∑ x,p.mass x*f x

theorem mean_indicator {Ω : Type*} [Fintype Ω] (p : Law Ω) (E : Ω → Prop) [DecidablePred E] :
    mean p (fun x => indicator (E x))=p.event E := by
  unfold mean Law.event
  apply sum_congr rfl
  intro x _
  by_cases h : E x <;> simp [indicator,h]

theorem mean_add {Ω : Type*} [Fintype Ω] (p : Law Ω) (f g : Ω → ℝ) :
    mean p (fun x => f x+g x)=mean p f+mean p g := by
  simp only [mean,mul_add,sum_add_distrib]

theorem mean_sub {Ω : Type*} [Fintype Ω] (p : Law Ω) (f g : Ω → ℝ) :
    mean p (fun x => f x-g x)=mean p f-mean p g := by
  simp only [mean,mul_sub,sum_sub_distrib]

theorem mean_sum {Ω I : Type*} [Fintype Ω] [Fintype I] (p : Law Ω) (f : I → Ω → ℝ) :
    mean p (fun x => ∑ i,f i x)=∑ i,mean p (f i) := by
  simp only [mean,mul_sum]
  rw [sum_comm]

noncomputable def radialSum : ℝ := by
  classical
  exact ∑ i : Fin 768,rawLaw.event (fun z => radialHit z i)
noncomputable def pairPenalty : ℝ := by
  classical
  exact ∑ i : Fin 768,∑ j : Fin 768,
    rawLaw.event (fun z => i≠j ∧ changed (z.1 i) ∧ changed (z.1 j))
noncomputable def emitPenalty : ℝ := by
  classical
  exact rawLaw.event emitBad

theorem radial_sandwich :
    radialSum-pairPenalty-emitPenalty≤rawBad ∧ rawBad≤radialSum+pairPenalty := by
  classical
  have hlo := sum_le_sum (s:=univ) (fun z _ =>
    mul_le_mul_of_nonneg_left (pointwise_sandwich z).1 (rawLaw.nonneg z))
  have hhi := sum_le_sum (s:=univ) (fun z _ =>
    mul_le_mul_of_nonneg_left (pointwise_sandwich z).2 (rawLaw.nonneg z))
  change mean rawLaw (fun z => surrogate z-orderedPairs z-indicator (emitBad z)) ≤
    mean rawLaw (fun z => indicator (rawEvent z)) at hlo
  change mean rawLaw (fun z => indicator (rawEvent z)) ≤
    mean rawLaw (fun z => surrogate z+orderedPairs z) at hhi
  have hs : mean rawLaw surrogate=radialSum := by
    change mean rawLaw (fun z => ∑ i : Fin 768,indicator (radialHit z i))=radialSum
    rw [mean_sum]
    simp only [mean_indicator,radialSum]
  have hp : mean rawLaw orderedPairs=pairPenalty := by
    change mean rawLaw (fun z => ∑ i : Fin 768,∑ j : Fin 768,
      indicator (i≠j ∧ changed (z.1 i) ∧ changed (z.1 j)))=pairPenalty
    rw [mean_sum]
    simp_rw [mean_sum,mean_indicator]
    rfl
  have hr : mean rawLaw (fun z => indicator (rawEvent z))=rawBad := by
    rw [mean_indicator,rawBad_is_event]
  have he : mean rawLaw (fun z => indicator (emitBad z))=emitPenalty := mean_indicator _ _
  simpa only [mean_sub,mean_add,hs,hp,hr,he] using And.intro hlo hhi

end FT1536.Run2.RawRadialEvents
