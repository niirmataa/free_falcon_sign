import CachedSampler018
import Mathlib.Algebra.BigOperators.Group.List.Basic

set_option maxRecDepth 8192
namespace FT1536.S05.Scatter018
open FT1536.Run2.PolynomialReference FT1536.Relation
abbrev Coeffs := Vector F 1536

def addAt (v : Coeffs) (t : Fin 1536 × F) : Coeffs :=
  v.set t.1.val (v[t.1.val]+t.2)

def scatter (v : Coeffs) (xs : List (Fin 1536 × F)) : Coeffs := xs.foldl addAt v

theorem get_addAt (v : Coeffs) (t : Fin 1536 × F) (r : Fin 1536) :
    (addAt v t)[r.val]=v[r.val]+if t.1=r then t.2 else 0 := by
  by_cases h : t.1=r
  · subst h
    simp [addAt]
  · have hn : t.1.val≠r.val := fun e => h (Fin.ext e)
    simp [addAt,hn,h]

theorem get_scatter (v : Coeffs) (xs : List (Fin 1536 × F)) (r : Fin 1536) :
    (scatter v xs)[r.val]=v[r.val]+coefficientOfTerms xs r := by
  induction xs generalizing v with
  | nil => simp [scatter,coefficientOfTerms]
  | cons t xs ih =>
    change (scatter (addAt v t) xs)[r.val]=_
    rw [ih,get_addAt]
    simp only [coefficientOfTerms,List.map_cons,List.sum_cons]
    exact add_assoc _ _ _

theorem sum_flatMap {A I : Type} [AddMonoid A] (s : List I) (f : I → List A) :
    (s.flatMap f).sum=(s.map (fun i => (f i).sum)).sum := by
  induction s with
  | nil => rfl
  | cons i s ih => simp [ih]

def indices : List TermIndex := (List.finRange 768).flatMap (fun i => [(i,false),(i,true)])

theorem sum_indices {A : Type} [AddCommMonoid A] (f : TermIndex → A) :
    (indices.map f).sum=∑ i : TermIndex,f i := by
  have hi : termFinite=instFintypeProd (Fin 768) Bool := Subsingleton.elim _ _
  rw [hi]
  simp [indices,List.map_flatMap,sum_flatMap,Fintype.sum_prod_type,add_comm,←Fin.sum_univ_def,Finset.sum_add_distrib]

theorem coefficient_scale (xs : List (Fin 1536 × F)) (a : F) (r : Fin 1536) :
    coefficientOfTerms (xs.map (fun t => (t.1,a*t.2))) r=a*coefficientOfTerms xs r := by
  induction xs with
  | nil => simp [coefficientOfTerms]
  | cons t xs ih =>
    simp only [List.map_cons,coefficientOfTerms,List.sum_cons,List.map_map,Function.comp_def] at *
    rw [ih,mul_add]
    by_cases h : t.1=r <;> simp [h]

theorem get_fold {I : Type} (xs : List I) (step : Coeffs → I → Coeffs)
    (f : I → F) (r : Fin 1536)
    (hs : ∀ v i,(step v i)[r.val]=v[r.val]+f i) (v : Coeffs) :
    (xs.foldl step v)[r.val]=v[r.val]+(xs.map f).sum := by
  induction xs generalizing v with
  | nil => simp
  | cons i xs ih =>
    simp only [List.foldl_cons,List.map_cons,List.sum_cons]
    rw [ih,hs,add_assoc]

def step (a b : Rq) (v : Coeffs) (i j : TermIndex) : Coeffs :=
  let c := coefficient a i*coefficient b j
  scatter v ((remainderTerms (productExponent i j)).map (fun t => (t.1,c*t.2)))

theorem get_step (a b : Rq) (v : Coeffs) (i j : TermIndex) (r : Fin 1536) :
    (step a b v i j)[r.val]=v[r.val]+coefficient a i*coefficient b j*
      coefficientOfTerms (remainderTerms (productExponent i j)) r := by
  unfold step
  rw [get_scatter,coefficient_scale]

def multiply (a b : Rq) : Coeffs :=
  indices.foldl (fun v i => indices.foldl (fun w j => step a b w i j) v) (Vector.replicate 1536 0)

theorem get_multiply (a b : Rq) (r : Fin 1536) :
    (multiply a b)[r.val]=multiplyCoefficient a b r := by
  have hi (v : Coeffs) (i : TermIndex) :
      (indices.foldl (fun w j => step a b w i j) v)[r.val]=v[r.val]+
        ∑ j : TermIndex,coefficient a i*coefficient b j*
          coefficientOfTerms (remainderTerms (productExponent i j)) r := by
    rw [get_fold _ _ _ r (fun w j => get_step a b w i j r),sum_indices]
  unfold multiply
  rw [get_fold _ _ _ r hi,sum_indices]
  simp [multiplyCoefficient]

def view (v : Coeffs) : Rq := fun i => (v[i.val],v[i.val+768])

theorem multiply_eq (a b : Rq) : view (multiply a b)=FT1536.Run2.PolynomialReference.multiply a b := by
  funext i
  apply Prod.ext
  · exact get_multiply a b ⟨i.val,by have := i.isLt; omega⟩
  · exact get_multiply a b ⟨i.val+768,by have := i.isLt; omega⟩

def pairVisits : ℕ := (indices.map (fun _ => indices.length)).sum
def updateVisits : ℕ := (indices.map (fun i =>
  (indices.map (fun j => (remainderTerms (productExponent i j)).length)).sum)).sum

theorem indices_length : indices.length=1536 := by
  have h := sum_indices (fun _ => (1 : ℕ))
  simpa [term_count] using h

theorem pair_visits : pairVisits=2359296 := by
  simp [pairVisits,indices_length]

theorem update_visits_bound : updateVisits≤4718592 := by
  unfold updateVisits
  simp_rw [sum_indices]
  exact reduced_term_visits

#print axioms indices_length
#print axioms pair_visits
#print axioms update_visits_bound
#print axioms coefficient_scale
#print axioms get_fold
#print axioms get_step
#print axioms get_multiply
#print axioms multiply_eq
#print axioms get_addAt
#print axioms get_scatter
#print axioms sum_indices
end FT1536.S05.Scatter018
