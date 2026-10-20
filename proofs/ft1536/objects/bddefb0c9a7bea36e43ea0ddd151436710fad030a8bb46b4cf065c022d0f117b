import Run2.RawRadialEvents
import Mathlib.Algebra.BigOperators.GroupWithZero.Finset

attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.Run2.RawIndependence
open Finset PublicSimulation Geometry RawProductLaw RawRadialEvents

/- A canonical indicator presentation avoids making probability identities
   depend on which Decidable instance happens to be inferred for a predicate. -/
noncomputable def prob {Ω : Type*} [Fintype Ω] (p : Law Ω) (P : Ω → Prop) : ℝ :=
  mean p (fun x => indicator (P x))

theorem prob_eq_event {Ω : Type*} [Fintype Ω] (p : Law Ω) (P : Ω → Prop) [DecidablePred P] :
    prob p P=p.event P := mean_indicator p P

theorem prob_congr {Ω : Type*} [Fintype Ω] (p : Law Ω) (P Q : Ω → Prop)
    (h : ∀ x,P x↔Q x) : prob p P=prob p Q := by
  unfold prob mean
  apply sum_congr rfl
  intro x _
  dsimp only
  rw [propext (h x)]

theorem prob_true {Ω : Type*} [Fintype Ω] (p : Law Ω) : prob p (fun _ => True)=1 := by
  simp only [prob,mean,indicator,ite_true,mul_one,p.total]

theorem indicator_and (P Q : Prop) : indicator (P ∧ Q)=indicator P*indicator Q := by
  classical
  by_cases hp : P <;> by_cases hq : Q <;> simp [indicator,hp,hq]

theorem indicator_forall {I : Type*} [Fintype I] (P : I → Prop) :
    indicator (∀ i,P i)=∏ i,indicator (P i) := by
  classical
  unfold indicator
  rw [Fintype.prod_ite_zero]
  simp only [prod_const_one]
  by_cases h : ∀ i,P i <;> simp [h]

theorem vector_cylinder (P : Fin 768 → Block → Prop) :
    prob vectorLaw (fun v => ∀ i,P i (v i))=∏ i : Fin 768,prob blockLaw (P i) := by
  simp only [prob,mean,vectorLaw,indicator_forall,←prod_mul_distrib]
  exact vector_product_sum_family (fun i b => blockLaw.mass b*indicator (P i b))

theorem raw_two_cylinders (P Q : BoxVec → Prop) :
    prob rawLaw (fun z => P z.1 ∧ Q z.2)=prob vectorLaw P*prob vectorLaw Q := by
  rw [rawLaw_eq_productLaw]
  simp only [prob,mean,productLaw,indicator_and]
  rw [Fintype.sum_prod_type]
  have he (v w : BoxVec) :
      vectorLaw.mass v*vectorLaw.mass w*(indicator (P v)*indicator (Q w))=
        (vectorLaw.mass v*indicator (P v))*(vectorLaw.mass w*indicator (Q w)) := by ring
  simp_rw [he,←mul_sum]
  rw [←sum_mul]

theorem raw_first_cylinder (P : BoxVec → Prop) :
    prob rawLaw (fun z => P z.1)=prob vectorLaw P := by
  have hh := raw_two_cylinders P (fun _ => True)
  simpa only [and_true,prob_true,mul_one] using hh

theorem raw_second_cylinder (P : BoxVec → Prop) :
    prob rawLaw (fun z => P z.2)=prob vectorLaw P := by
  have hh := raw_two_cylinders (fun _ => True) P
  simpa only [true_and,prob_true,one_mul] using hh

theorem one_coordinate (i : Fin 768) (P : Block → Prop) :
    prob vectorLaw (fun v => P (v i))=prob blockLaw P := by
  classical
  let C : Fin 768 → Block → Prop := fun k b => k=i → P b
  have hc : prob vectorLaw (fun v => P (v i))=prob vectorLaw (fun v => ∀ k,C k (v k)) := by
    apply prob_congr
    intro v
    simp [C]
  rw [hc,vector_cylinder]
  have he (k : Fin 768) : prob blockLaw (C k)=if k=i then prob blockLaw P else 1 := by
    by_cases hk : k=i
    · simp only [C,hk,true_implies,ite_true]
    · simp only [C,hk,false_implies,ite_false,prob_true]
  simp_rw [he]
  simp

theorem two_coordinates (i j : Fin 768) (hij : i≠j) (P Q : Block → Prop) :
    prob vectorLaw (fun v => P (v i) ∧ Q (v j))=prob blockLaw P*prob blockLaw Q := by
  classical
  let C : Fin 768 → Block → Prop := fun k b => (k=i → P b) ∧ (k=j → Q b)
  have hc : prob vectorLaw (fun v => P (v i) ∧ Q (v j))=
      prob vectorLaw (fun v => ∀ k,C k (v k)) := by
    apply prob_congr
    intro v
    constructor
    · rintro ⟨hp,hq⟩ k
      exact ⟨fun hk => by simpa only [hk] using hp,fun hk => by simpa only [hk] using hq⟩
    · intro h
      exact ⟨(h i).1 rfl,(h j).2 rfl⟩
  rw [hc,vector_cylinder]
  have he (k : Fin 768) : prob blockLaw (C k)=
      (if k=i then prob blockLaw P else 1)*(if k=j then prob blockLaw Q else 1) := by
    by_cases hki : k=i <;> by_cases hkj : k=j
    · exact (hij (hki.symm.trans hkj)).elim
    · simp only [C,hki,true_implies,show ¬i=j from hij,false_implies,and_true,
        ite_true,ite_false,mul_one]
    · simp only [C,hkj,true_implies,show ¬j=i from Ne.symm hij,false_implies,true_and,
        ite_true,ite_false,one_mul]
    · simp only [C,hki,hkj,false_implies,true_and,ite_false,prob_true,mul_one]
  simp_rw [he]
  rw [prod_mul_distrib]
  simp

noncomputable def changeProbability : ℝ := prob blockLaw changed

theorem pairPenalty_exact : pairPenalty=768*767*changeProbability^2 := by
  classical
  unfold pairPenalty
  simp_rw [←prob_eq_event]
  have he (i j : Fin 768) :
      prob rawLaw (fun z => i≠j ∧ changed (z.1 i) ∧ changed (z.1 j))=
        if i=j then 0 else changeProbability^2 := by
    by_cases hij : i=j
    · simp [hij,prob,mean,indicator]
    · have hp : prob rawLaw (fun z => i≠j ∧ changed (z.1 i) ∧ changed (z.1 j))=
          prob rawLaw (fun z => changed (z.1 i) ∧ changed (z.1 j)) := by
        apply prob_congr
        intro z
        simp only [hij,ne_eq,not_false_eq_true,true_and]
      rw [hp,raw_first_cylinder (fun v => changed (v i) ∧ changed (v j)),
        two_coordinates i j hij,ite_eq_right hij]
      simp only [changeProbability,pow_two]
  simp_rw [he]
  have hrow (i : Fin 768) : (∑ j : Fin 768,if i=j then (0 : ℝ) else changeProbability^2)=
      767*changeProbability^2 := by
    have ht (j : Fin 768) : (if i=j then (0 : ℝ) else changeProbability^2)=
        changeProbability^2-(if i=j then changeProbability^2 else 0) := by
      by_cases hij : i=j <;> simp [hij]
    simp_rw [ht]
    rw [sum_sub_distrib]
    simp
    ring
  simp_rw [hrow]
  simp
  ring

theorem prob_exists_le_sum {Ω I : Type*} [Fintype Ω] [Fintype I] (p : Law Ω)
    (P : I → Ω → Prop) : prob p (fun x => ∃ i,P i x)≤∑ i,prob p (P i) := by
  classical
  have hp (x : Ω) : indicator (∃ i,P i x) ≤ ∑ i,indicator (P i x) := by
    by_cases h : ∃ i,P i x
    · obtain ⟨i,hi⟩ := h
      have hex : ∃ j,P j x := ⟨i,hi⟩
      have hh := single_le_sum (fun j _ => indicator_nonnegative (P j x)) (mem_univ i)
      simpa only [indicator,ite_eq_left hi,ite_eq_left hex] using hh
    · rw [indicator,ite_eq_right h]
      exact sum_nonneg fun i _ => indicator_nonnegative (P i x)
  unfold prob
  rw [←mean_sum]
  exact sum_le_sum fun x _ => mul_le_mul_of_nonneg_left (hp x) (p.nonneg x)

end FT1536.Run2.RawIndependence
