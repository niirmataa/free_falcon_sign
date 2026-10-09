import Source3.KeygenPublicRadixFold

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- q18433 block polynomials for the SAME radix-loop cells. The sum/split
   argument parallels KeygenNttSubpolynomial, but is checked here in the
   public field with the public uint16 execution theorem. -/
namespace FT1536.Source3.KeygenPublicSplitPolynomial
open Polynomial Finset
open KeygenPublicAlgebra (R radix)
open KeygenPublicRadixFold (low high image)

noncomputable def polynomial (a : Nat → R) (base n : Nat) : Polynomial R :=
  ∑ i ∈ range n, C (a (base+i))*X^i
noncomputable def lowPolynomial (a : Nat → R) (base d : Nat) (root : R) : Polynomial R :=
  polynomial (low a base d root) 0 d
noncomputable def highPolynomial (a : Nat → R) (base d : Nat) (root : R) : Polynomial R :=
  polynomial (high a base d root) 0 d
noncomputable def modulus (d : Nat) (root : R) : Polynomial R := X^d-C root

theorem coefficient (a : Nat → R) (base n j : Nat) (hj : j<n) :
    (polynomial a base n).coeff j=a (base+j) := by
  rw [polynomial,finsetSum_coeff]
  have term (i : Nat) : (C (a (base+i))*X^i).coeff j=if i=j then a (base+i) else 0 := by
    by_cases he : i=j
    · subst i; simp
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
    polynomial a base (2*d)=lowPolynomial a base d root+modulus d root*polynomial a (base+d) d := by
  rw [split_halves]
  unfold lowPolynomial polynomial modulus
  rw [mul_sum,mul_sum,← sum_add_distrib,← sum_add_distrib]
  apply sum_congr rfl
  intro i _
  simp only [Nat.zero_add,low,map_add,map_mul]
  ring

theorem negate_low (a : Nat → R) (base d : Nat) (root : R) :
    lowPolynomial a base d (-root)=highPolynomial a base d root := by
  unfold lowPolynomial highPolynomial
  congr 1
  funext i
  unfold low high
  ring

theorem low_remainder (a : Nat → R) (base d : Nat) (root : R) (positive : 0<d) :
    polynomial a base (2*d) %ₘ modulus d root=lowPolynomial a base d root := by
  have monic : (modulus d root).Monic := monic_X_pow_sub_C root (by omega)
  rw [low_decomposition a base d root,add_modByMonic,self_mul_modByMonic monic,add_zero]
  apply (modByMonic_eq_self_iff monic).2
  rw [show (modulus d root).degree=d from degree_X_pow_sub_C positive root]
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

def RemainderImage (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (a : Nat → R) (base d : Nat) (root : R) : Prop := ∀ i<d,
  KeygenPublicInputCells.Cell heap p (base+i) ((polynomial a base (2*d) %ₘ modulus d root).coeff i) ∧
  KeygenPublicInputCells.Cell heap p (base+d+i) ((polynomial a base (2*d) %ₘ modulus d (-root)).coeff i)

theorem source_remainders (a : Nat → R) (p : C99MemoryReference.ArrayPointer) (base d : Nat) (root : R)
    (s : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (positive : 0<d) (extent : base+2*d≤1536) (width : p.elementBytes=2)
    (pointer : s.arrays "a".toList=some p) (ht : KeygenNttLoopSupport.USlot s "ht" d)
    (limit : KeygenNttLoopSupport.USlot s "v2" (base+d)) (counter : KeygenNttLoopSupport.USlot s "v" base)
    (twiddle : KeygenPublicValueExpr.Local s "s" (radix*root)) (input : KeygenPublicInputCells.Cells s.heap p 1536 a)
    (source : KeygenPublicExec.Exec KeygenPublicSource.program [] KeygenPublicRadixFold.loop s out) :
    out.flow=.normal ∧ RemainderImage out.state.heap p a base d root := by
  obtain ⟨flow,final⟩ := KeygenPublicRadixFold.source_loop a p base d root s out
    positive extent width pointer ht limit counter twiddle input source
  refine ⟨flow,?_⟩
  intro i hi
  rw [low_remainder a base d root positive,high_remainder a base d root positive]
  simp only [lowPolynomial,highPolynomial,coefficient _ _ _ _ hi,Nat.zero_add]
  have lo := final.cells (base+i) (by omega)
  have high := final.cells (base+d+i) (by omega)
  rw [KeygenPublicRadixFold.image_low a base d d i root hi] at lo
  rw [KeygenPublicRadixFold.image_high a base d d i root (by omega) hi] at high
  exact ⟨lo,high⟩

end FT1536.Source3.KeygenPublicSplitPolynomial
