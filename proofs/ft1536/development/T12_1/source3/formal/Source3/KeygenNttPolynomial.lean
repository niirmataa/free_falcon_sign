import Source3.KeygenNttFirstValues
import Run2.CoefficientQuotient

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 32768

/- B1.04 polynomial invariants use the existing coefficient model. The
   first pass forms the two degree-<768 remainders at the actual gm[1]
   root and its complement; no transform-output evaluation is assumed. -/
namespace FT1536.Source3.KeygenNttPolynomial
open Polynomial Finset
open KeygenNttWordAlgebra (R value)
open KeygenSmallOutput (element)
open KeygenNttCells (Cell Cells)
open FT1536.Run2
open KeygenNttFirstValues (firstRoot)

instance modulusNontrivial : Nontrivial R := ZMod.nontrivial_iff.mpr (by decide)

abbrev Coeff := CoefficientQuotient.Coeff R
def castVec (v : Geometry.Vec) : Coeff := fun i => ((v i).1,(v i).2)
def coefficient (v : Coeff) (i : Nat) : R :=
  if h : i<768 then (v ⟨i,h⟩).1 else if h : i<1536 then (v ⟨i-768,by omega⟩).2 else 0

theorem coefficient_low (v : Coeff) (i : Fin 768) : coefficient v i.val=(v i).1 := by
  simp only [coefficient,dite_eq_left i.isLt]

theorem coefficient_high (v : Coeff) (i : Fin 768) : coefficient v (768+i.val)=(v i).2 := by
  have hlo : ¬768+i.val<768 := by omega
  have hhi : 768+i.val<1536 := by have := i.isLt; omega
  simp only [coefficient,dite_eq_right hlo,dite_eq_left hhi]
  congr 2
  apply Fin.ext
  simp

theorem residue_value (w : BitVec 32) (z : Int)
    (residue : (w.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=z%(KeygenNinv31.prime.toNat : Int)) :
    value w=(z : R) := by
  have hc := (ZMod.intCast_eq_intCast_iff' (w.toNat : Int) z 2147355649).mpr residue
  simpa only [value,Int.cast_natCast] using hc

theorem converted_cells (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (v : Geometry.Vec) (input : KeygenResidueVectors.Represents heap p v) :
    Cells heap p 1536 (coefficient (castVec v)) := by
  intro j hj
  by_cases hlo : j<768
  · obtain ⟨w,read,range,residue⟩ := (input ⟨j,hlo⟩).1
    rw [coefficient_low (castVec v) ⟨j,hlo⟩]
    exact ⟨w,read,range,residue_value w _ residue⟩
  · let i : Fin 768 := ⟨j-768,by omega⟩
    have he : 768+i.val=j := by dsimp [i]; omega
    obtain ⟨w,read,range,residue⟩ := (input i).2
    have hp : i.val+768=j := by omega
    rw [hp] at read
    rw [← he,coefficient_high]
    rw [he]
    exact ⟨w,read,range,residue_value w _ residue⟩

noncomputable def halfPolynomial (a : Fin 768 → R) : Polynomial R :=
  ∑ i, C (a i)*X^i.val
noncomputable def lowPolynomial (v : Coeff) (root : R) : Polynomial R :=
  halfPolynomial (fun i => (v i).1+(v i).2*root)
noncomputable def highPolynomial (v : Coeff) (root : R) : Polynomial R :=
  halfPolynomial (fun i => (v i).1+(v i).2-(v i).2*root)
noncomputable def halfModulus (root : R) : Polynomial R := X^768-C root

theorem half_coefficient (a : Fin 768 → R) (i : Fin 768) :
    (halfPolynomial a).coeff i.val=a i := by
  rw [halfPolynomial,finsetSum_coeff]
  have term (j : Fin 768) : (C (a j)*X^j.val).coeff i.val=if j=i then a j else 0 := by
    by_cases he : j=i
    · subst j
      simp
    · have hv : i.val≠j.val := fun h => he (Fin.ext h.symm)
      simp [coeff_C_mul,coeff_X_pow,he,hv]
  simp_rw [term]
  simp

theorem half_degree (a : Fin 768 → R) : (halfPolynomial a).degree<768 := by
  apply (degree_lt_iff_coeff_zero _ 768).2
  intro n hn
  rw [halfPolynomial,finsetSum_coeff]
  apply sum_eq_zero
  intro i _
  have hi : n≠i.val := by have := i.isLt; omega
  simp [coeff_C_mul,coeff_X_pow,hi]

theorem first_decomposition (v : Coeff) (root : R) :
    CoefficientQuotient.polynomial v=lowPolynomial v root+
      halfModulus root*halfPolynomial (fun i => (v i).2) := by
  unfold CoefficientQuotient.polynomial lowPolynomial halfPolynomial halfModulus
  rw [mul_sum,← sum_add_distrib]
  apply sum_congr rfl
  intro i _
  rw [pow_add,map_add,map_mul]
  ring

theorem complement_polynomial (v : Coeff) (root : R) :
    lowPolynomial v (1-root)=highPolynomial v root := by
  unfold lowPolynomial highPolynomial
  congr 1
  funext i
  ring

theorem first_remainder (v : Coeff) (root : R) :
    CoefficientQuotient.polynomial v %ₘ halfModulus root=lowPolynomial v root := by
  have hm : (halfModulus root).Monic := monic_X_pow_sub_C root (by decide : (768 : Nat)≠0)
  rw [first_decomposition v root,add_modByMonic,self_mul_modByMonic hm,add_zero]
  apply (modByMonic_eq_self_iff hm).2
  have hd : (halfModulus root).degree=768 := by
    unfold halfModulus
    compute_degree <;> norm_num
  rw [hd]
  exact half_degree _

theorem eval_low (v : Coeff) (root z : R) (hz : z^768=root) :
    (CoefficientQuotient.polynomial v).eval z=(lowPolynomial v root).eval z := by
  rw [first_decomposition v root,eval_add,eval_mul]
  simp only [halfModulus,eval_sub,eval_pow,eval_X,eval_C,hz,sub_self,zero_mul,add_zero]

theorem eval_high (v : Coeff) (root z : R) (hz : z^768=1-root) :
    (CoefficientQuotient.polynomial v).eval z=(highPolynomial v root).eval z := by
  rw [← complement_polynomial]
  exact eval_low v (1-root) z hz

theorem first_root_power : firstRoot=KeygenMkgm3Rows.generator^1536 := by
  rw [KeygenNttFirstValues.firstRoot,
    show KeygenMkgm3Indices.tableExponent 1=768 from rfl,KeygenMkgm3Rows.root,← pow_mul]

theorem first_root_relation : firstRoot^2-firstRoot+1=0 := by
  rw [first_root_power,KeygenMkgm3Rows.generator_pow]
  decide

theorem complement_relation : (1-firstRoot)^2-(1-firstRoot)+1=0 := by
  calc
    (1-firstRoot)^2-(1-firstRoot)+1 = firstRoot^2-firstRoot+1 := by ring
    _ = 0 := first_root_relation

theorem first_factorization : CoefficientQuotient.phi R=
    halfModulus firstRoot*halfModulus (1-firstRoot) := by
  have prod : firstRoot*(1-firstRoot)=1 := by
    have h := first_root_relation
    linear_combination -h
  have hC := congrArg (C : R → Polynomial R) prod
  simp only [map_mul,map_sub,map_one] at hC
  unfold CoefficientQuotient.phi halfModulus
  rw [map_sub,map_one,show (1536 : Nat)=768*2 from rfl,pow_mul]
  linear_combination -hC

/- The same source first pass now has both memory-range and polynomial
   conclusions about the Vec supplied by the checked conversion. -/
def FirstImage (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (v : Geometry.Vec) : Prop := ∀ i : Fin 768,
  Cell heap (element p i.val) ((castVec v i).1+(castVec v i).2*firstRoot) ∧
  Cell heap (element p (768+i.val)) ((castVec v i).1+(castVec v i).2-(castVec v i).2*firstRoot)

def RemainderImage (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (v : Geometry.Vec) : Prop := ∀ i : Fin 768,
  Cell heap (element p i.val)
    ((CoefficientQuotient.polynomial (castVec v) %ₘ halfModulus firstRoot).coeff i.val) ∧
  Cell heap (element p (768+i.val))
    ((CoefficientQuotient.polynomial (castVec v) %ₘ halfModulus (1-firstRoot)).coeff i.val)

theorem image_remainders (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (v : Geometry.Vec) (image : FirstImage heap p v) : RemainderImage heap p v := by
  intro i
  rw [first_remainder,first_remainder,complement_polynomial]
  simpa only [lowPolynomial,highPolynomial,half_coefficient] using image i

theorem image_of_cells (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (v : Geometry.Vec) (cells : Cells heap p 1536
      (KeygenNttFirstValues.values (coefficient (castVec v)) firstRoot)) : FirstImage heap p v := by
  intro i
  have hl := cells i.val (by have := i.isLt; omega)
  have hh := cells (768+i.val) (by have := i.isLt; omega)
  have hn : ¬768+i.val<768 := by omega
  simp only [KeygenNttFirstValues.values,i.isLt,ite_true,KeygenNttFirstValues.low,
    coefficient_low,coefficient_high] at hl
  simp only [KeygenNttFirstValues.values,hn,ite_false,Nat.add_sub_cancel_left,
    KeygenNttFirstValues.high,coefficient_low,coefficient_high] at hh
  exact ⟨hl,hh⟩

theorem source_first_pass (before : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (p gm : C99MemoryReference.ArrayPointer) (v : Geometry.Vec) (p0i : BitVec 32)
    (width : p.elementBytes=4)
    (word : KeygenNttButterflyCalls.U32Declared before "w")
    (prime : KeygenNttButterflyCalls.U32Slot before "p" KeygenNinv31.prime)
    (inverse : KeygenNttButterflyCalls.U32Slot before "p0i" p0i)
    (stride : KeygenNttLoopSupport.USlot before "stride" 1)
    (hn : KeygenNttLoopSupport.USlot before "hn" 768)
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (ap : KeygenNttLoopSupport.PSlot before "a" p) (gp : KeygenNttLoopSupport.PSlot before "gm" gm)
    (input : KeygenResidueVectors.Represents before.heap p v)
    (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : C99ModularReference.Exec KeygenNttForwardPrograms.firstPass before out) :
    out.flow=.normal ∧ FirstImage out.state.heap p v ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨flow,cells,frame⟩ := KeygenNttFirstValues.pass_values before out p gm (coefficient (castVec v))
    p0i width word prime inverse stride hn uc ap gp (converted_cells before.heap p v input)
    table initialization source
  exact ⟨flow,image_of_cells out.state.heap p v cells,frame⟩

end FT1536.Source3.KeygenNttPolynomial
