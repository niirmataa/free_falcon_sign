import Source3.KeygenNttBinaryValues
import Source3.KeygenNttPolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The block polynomial invariant for the remaining passes. Radix-2
   remainders are tied to the actual cells of the executed v-loop. -/
namespace FT1536.Source3.KeygenNttSubpolynomial
open Polynomial Finset
open KeygenNttWordAlgebra (R)
open KeygenSmallOutput (element)

noncomputable def polynomial (a : Nat → R) (base n : Nat) : Polynomial R :=
  ∑ i ∈ range n, C (a (base+i))*X^i
noncomputable def modulus (d : Nat) (root : R) : Polynomial R := X^d-C root
noncomputable def lowPolynomial (a : Nat → R) (base d : Nat) (root : R) : Polynomial R :=
  polynomial (KeygenNttBinaryValues.low a base d root) 0 d
noncomputable def highPolynomial (a : Nat → R) (base d : Nat) (root : R) : Polynomial R :=
  polynomial (KeygenNttBinaryValues.high a base d root) 0 d

theorem coefficient (a : Nat → R) (base n j : Nat) (hj : j<n) :
    (polynomial a base n).coeff j=a (base+j) := by
  rw [polynomial,finsetSum_coeff]
  have term (i : Nat) : (C (a (base+i))*X^i).coeff j=if i=j then a (base+i) else 0 := by
    by_cases he : i=j
    · subst i
      simp
    · simp [coeff_C_mul,coeff_X_pow,he,Ne.symm he]
  simp_rw [term]
  simp [hj]

theorem degree_bound (a : Nat → R) (base n : Nat) : (polynomial a base n).degree<n := by
  apply (degree_lt_iff_coeff_zero _ n).2
  intro j hj
  rw [polynomial,finsetSum_coeff]
  apply sum_eq_zero
  intro i hi
  have bound := mem_range.mp hi
  have ne : j≠i := by omega
  simp [coeff_C_mul,coeff_X_pow,ne]

theorem split_halves (a : Nat → R) (base d : Nat) :
    polynomial a base (2*d)=polynomial a base d+X^d*polynomial a (base+d) d := by
  unfold polynomial
  rw [two_mul,sum_range_add,mul_sum]
  congr 1
  apply sum_congr rfl
  intro i _
  rw [pow_add]
  simp only [Nat.add_assoc]
  ring

theorem low_decomposition (a : Nat → R) (base d : Nat) (root : R) :
    polynomial a base (2*d)=lowPolynomial a base d root+
      modulus d root*polynomial a (base+d) d := by
  rw [split_halves]
  unfold lowPolynomial polynomial modulus
  rw [mul_sum,mul_sum,← sum_add_distrib,← sum_add_distrib]
  apply sum_congr rfl
  intro i _
  simp only [Nat.zero_add,KeygenNttBinaryValues.low,map_add,map_mul]
  ring

theorem negate_low (a : Nat → R) (base d : Nat) (root : R) :
    lowPolynomial a base d (-root)=highPolynomial a base d root := by
  unfold lowPolynomial highPolynomial
  congr 1
  funext i
  unfold KeygenNttBinaryValues.low KeygenNttBinaryValues.high
  ring

theorem modulus_degree (d : Nat) (root : R) (positive : 0<d) : (modulus d root).degree=d := by
  exact degree_X_pow_sub_C positive root

theorem low_remainder (a : Nat → R) (base d : Nat) (root : R) (positive : 0<d) :
    polynomial a base (2*d) %ₘ modulus d root=lowPolynomial a base d root := by
  have monic : (modulus d root).Monic := monic_X_pow_sub_C root (by omega)
  rw [low_decomposition a base d root,add_modByMonic,self_mul_modByMonic monic,add_zero]
  apply (modByMonic_eq_self_iff monic).2
  rw [modulus_degree d root positive]
  exact degree_bound _ _ _

theorem high_remainder (a : Nat → R) (base d : Nat) (root : R) (positive : 0<d) :
    polynomial a base (2*d) %ₘ modulus d (-root)=highPolynomial a base d root := by
  rw [low_remainder a base d (-root) positive,negate_low]

theorem eval_low (a : Nat → R) (base d : Nat) (root z : R) (power : z^d=root) :
    (polynomial a base (2*d)).eval z=(lowPolynomial a base d root).eval z := by
  rw [low_decomposition a base d root,eval_add,eval_mul]
  simp only [modulus,eval_sub,eval_pow,eval_X,eval_C,power,sub_self,zero_mul,add_zero]

theorem eval_high (a : Nat → R) (base d : Nat) (root z : R) (power : z^d= -root) :
    (polynomial a base (2*d)).eval z=(highPolynomial a base d root).eval z := by
  rw [← negate_low]
  exact eval_low a base d (-root) z power

theorem values_low (a : Nat → R) (base d : Nat) (root : R) (i : Nat) (hi : i<d) :
    KeygenNttBinaryValues.values a base d root (base+i)=KeygenNttBinaryValues.low a base d root i := by
  have h0 : ¬base+i<base := by omega
  have h1 : base+i<base+d := by omega
  simp only [KeygenNttBinaryValues.values,h0,ite_false,h1,ite_true,Nat.add_sub_cancel_left]

theorem values_high (a : Nat → R) (base d : Nat) (root : R) (i : Nat) (hi : i<d) :
    KeygenNttBinaryValues.values a base d root (base+d+i)=KeygenNttBinaryValues.high a base d root i := by
  have h0 : ¬base+d+i<base := by omega
  have h1 : ¬base+d+i<base+d := by omega
  have h2 : base+d+i<base+2*d := by omega
  simp only [KeygenNttBinaryValues.values,h0,ite_false,h1,h2,ite_true,Nat.add_sub_cancel_left]

def RemainderImage (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (a : Nat → R) (base d : Nat) (root : R) : Prop := ∀ i<d,
  KeygenNttCells.Cell heap (element p (base+i)) ((polynomial a base (2*d) %ₘ modulus d root).coeff i) ∧
  KeygenNttCells.Cell heap (element p (base+d+i)) ((polynomial a base (2*d) %ₘ modulus d (-root)).coeff i)

theorem image_remainders (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (a : Nat → R) (base d : Nat) (root : R) (positive : 0<d) (extent : base+2*d≤1536)
    (cells : KeygenNttCells.Cells heap p 1536 (KeygenNttBinaryValues.values a base d root)) :
    RemainderImage heap p a base d root := by
  intro i hi
  rw [low_remainder a base d root positive,high_remainder a base d root positive]
  simp only [lowPolynomial,highPolynomial,coefficient _ _ _ _ hi,Nat.zero_add]
  have hl := cells (base+i) (by omega)
  have hh := cells (base+d+i) (by omega)
  rw [values_low a base d root i hi] at hl
  rw [values_high a base d root i hi] at hh
  exact ⟨hl,hh⟩

theorem source_remainders (before : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (p : C99MemoryReference.ArrayPointer) (a : Nat → R) (base d : Nat) (root : R) (tw p0i : BitVec 32)
    (width : p.elementBytes=4) (positive : 0<d) (extent : base+2*d≤1536)
    (args : KeygenNttBinaryValues.Args tw p0i before)
    (vc : ∃ old, before.locals "v".toList=some (.uint64,old))
    (ht : KeygenNttLoopSupport.USlot before "ht" d)
    (lo : KeygenNttLoopSupport.PSlot before "r1" (element p base))
    (hi : KeygenNttLoopSupport.PSlot before "r2" (element p (base+d)))
    (input : KeygenNttCells.Cells before.heap p 1536 a)
    (twiddle : KeygenNttButterflyAlgebra.Canonical tw ∧ KeygenNttWordAlgebra.value tw=KeygenNttWordAlgebra.radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : C99ModularReference.Exec KeygenNttForwardPrograms.vLoop before out) :
    out.flow=.normal ∧ RemainderImage out.state.heap p a base d root ∧
      KeygenNttCells.Cells out.state.heap p 1536 (KeygenNttBinaryValues.values a base d root) ∧
      KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨flow,cells,frame⟩ := KeygenNttBinaryValues.loop_values before out p a base d root tw p0i width extent
    args vc ht lo hi input twiddle initialization source
  exact ⟨flow,image_remainders _ p a base d root positive extent cells,cells,frame⟩

theorem triple_polynomial (a : Nat → R) (base : Nat) (z : R) :
    (polynomial a base 3).eval z=KeygenNttCells.quadratic (a base) (a (base+1)) (a (base+2)) z := by
  simp [polynomial,sum_range_succ,KeygenNttCells.quadratic]

end FT1536.Source3.KeygenNttSubpolynomial
