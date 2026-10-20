import Source3.KeygenPublicReversePolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual reverse tree reconstructs block evaluations in ORIGINAL
   physical point order. After all eight stages the factor is768, not1. -/
namespace FT1536.Source3.KeygenPublicReverseReconstruction
open KeygenPublicAlgebra (R)
open KeygenPublicSplitPolynomial (polynomial)
open KeygenPublicRootTree (nodeRoot twiddle)
open KeygenPublicRoots (point)

def blockSize (k : Nat) : Nat := 3*2^k
def block (k : Nat) (i : Fin 1536) : Nat := i.val/blockSize k
def stageImage (a : Nat → R) (k : Nat) : Nat → R :=
  KeygenPublicReverseStages.image (KeygenPublicInverseFold.value a) k

theorem dimensions (k : Nat) (hk : k<8) :
    KeygenPublicRadixStages.count (7-k)=KeygenPublicReverseStages.count k ∧
    KeygenPublicReverseStages.size k/2=blockSize k ∧
    blockSize (k+1)=2*blockSize k ∧ 8-k=(7-k)+1 ∧ 8-(k+1)=7-k ∧ 7-k<8 := by
  have cert : ∀ k : Fin 8,
      KeygenPublicRadixStages.count (7-k.val)=KeygenPublicReverseStages.count k.val ∧
      KeygenPublicReverseStages.size k.val/2=blockSize k.val ∧
      blockSize (k.val+1)=2*blockSize k.val ∧ 8-k.val=(7-k.val)+1 ∧ 8-(k.val+1)=7-k.val ∧ 7-k.val<8 := by decide
  exact cert ⟨k,hk⟩
theorem block_bounds (k : Nat) (hk : k<8) (i : Fin 1536) :
    block (k+1) i<KeygenPublicRadixStages.count (7-k) ∧
    (block k i=2*block (k+1) i ∨ block k i=2*block (k+1) i+1) := by
  have hi := i.isLt
  interval_cases k <;> norm_num [block,blockSize,KeygenPublicRadixStages.count] <;> omega
theorem tree_twiddle (k j : Nat) (hk : k<8) :
    twiddle (7-k) j=KeygenPublicRadixRow.root (KeygenPublicReverseStages.count k) j := by
  rw [twiddle,(dimensions k hk).1]

theorem point_power (k : Nat) (hk : k≤8) (i : Fin 1536) :
    point i^blockSize k=nodeRoot (8-k) (block k i) := by
  induction k with
  | zero =>
      have hi := i.isLt
      have index : (⟨3*(i.val/3)+i.val%3,by omega⟩ : Fin 1536)=i := by apply Fin.ext; dsimp; omega
      have law := KeygenPublicRootTree.leaf_power (i.val/3) (i.val%3) (by omega) (by omega)
      rw [index] at law
      exact law
  | succ k ih =>
      have active : k<8 := by omega
      obtain ⟨_,_,twice,childDepth,parentDepth,depthBound⟩ := dimensions k active
      obtain ⟨parentBound,shape⟩ := block_bounds k active i
      obtain ⟨low,high⟩ := KeygenPublicRootTree.children (7-k) (block (k+1) i) depthBound parentBound
      have old := ih (by omega)
      rw [childDepth] at old
      rw [twice,parentDepth,Nat.mul_comm 2 (blockSize k),pow_mul]
      rcases shape with equal | equal
      · rw [equal,low] at old
        rw [old,KeygenPublicRootTree.parent_square _ _ depthBound]
      · rw [equal,high] at old
        rw [old,KeygenPublicRootTree.parent_square _ _ depthBound]
        ring

def Invariant (a : Nat → R) (k : Nat) : Prop := ∀ i : Fin 1536,
  (polynomial (stageImage a k) (block k i*blockSize k) (blockSize k)).eval (point i)=
    (3*2^k : R)*a i.val

theorem first_invariant (a : Nat → R) : Invariant a 0 := by
  intro i
  change (polynomial (KeygenPublicInverseFold.value a) ((i.val/3)*3) 3).eval (point i)=3*a i.val
  rw [Nat.mul_comm (i.val/3) 3]
  exact KeygenPublicInverseTriplePolynomial.all_physical a i

theorem next_invariant (a : Nat → R) (k : Nat) (hk : k<8) (input : Invariant a k) : Invariant a (k+1) := by
  intro i
  obtain ⟨counts,half,twice,childDepth,_,depthBound⟩ := dimensions k hk
  obtain ⟨parentBound,shape⟩ := block_bounds k hk i
  obtain ⟨low,high⟩ := KeygenPublicRootTree.children (7-k) (block (k+1) i) depthBound parentBound
  have rootPower := point_power k (by omega) i
  rw [childDepth] at rootPower
  have rowBound : block (k+1) i<KeygenPublicReverseStages.count k := by rw [← counts]; exact parentBound
  have result := input i
  have imageNext : stageImage a (k+1)=KeygenPublicReverseRows.image (stageImage a k)
      (KeygenPublicReverseStages.count k) (blockSize k) (KeygenPublicReverseStages.count k) := by
    unfold stageImage
    rw [KeygenPublicReverseStages.image,half]
  change (polynomial (stageImage a (k+1)) (block (k+1) i*blockSize (k+1)) (blockSize (k+1))).eval (point i)=_
  rw [imageNext,twice]
  rcases shape with equal | equal
  · rw [equal,low,tree_twiddle k _ hk] at rootPower
    rw [KeygenPublicReversePolynomial.eval_low _ _ _ _ rowBound (point i) rootPower]
    rw [equal] at result
    have base : (2*block (k+1) i)*blockSize k=block (k+1) i*(2*blockSize k) := by ring
    rw [base] at result
    rw [result,pow_succ]
    ring
  · rw [equal,high,tree_twiddle k _ hk] at rootPower
    rw [KeygenPublicReversePolynomial.eval_high _ _ _ _ rowBound (point i) rootPower]
    rw [equal] at result
    have base : (2*block (k+1) i+1)*blockSize k=block (k+1) i*(2*blockSize k)+blockSize k := by ring
    rw [base] at result
    rw [result,pow_succ]
    ring

theorem stages_invariant (a : Nat → R) (k : Nat) (hk : k≤8) : Invariant a k := by
  induction k with
  | zero => exact first_invariant a
  | succ k ih => exact next_invariant a k (by omega) (ih (by omega))

theorem original_block (a : Nat → R) (i : Fin 1536) :
    (polynomial (KeygenPublicReverseEntry.reverseImage a) ((i.val/768)*768) 768).eval (point i)=768*a i.val :=
  stages_invariant a 8 (by decide) i

end FT1536.Source3.KeygenPublicReverseReconstruction
