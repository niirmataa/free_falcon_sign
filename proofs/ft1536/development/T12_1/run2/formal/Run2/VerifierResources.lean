import Run2.FileVerifier

namespace FT1536.Run2.FileVerifier
open BitArithmetic FileArithmetic

theorem pairs_length (xs : List SignedWord) : (pairs xs).length=768 := List.length_ofFn

theorem pairs_word_length (xs : List SignedWord) (h : ∀ x∈xs,x.magnitude.length≤16) :
    ∀ p∈pairs xs,p.1.magnitude.length≤16 ∧ p.2.magnitude.length≤16 := by
  intro p hp
  obtain ⟨i,rfl⟩:=List.mem_ofFn.mp hp
  exact ⟨loadSigned_length xs i.val 16 h,loadSigned_length xs (i.val+768) 16 h⟩

theorem signed16Code_steps (x : SignedWord) (h : x.magnitude.length≤16) :
    (signed16Code x).2≤1586 := by
  have hl:=signedLess_steps x low
  have hu:=signedLess_steps x high
  have ll : low.magnitude.length=16 := encodeSigned_length _ _
  have lu : high.magnitude.length=16 := encodeSigned_length _ _
  rw [ll] at hl
  rw [lu] at hu
  dsimp only [signed16Code]
  omega

theorem checkPairs_steps (xs : List (SignedWord × SignedWord))
    (h : ∀ p∈xs,p.1.magnitude.length≤16 ∧ p.2.magnitude.length≤16) :
    (checkPairs xs).2≤3175*xs.length+1 := by
  induction xs with
  | nil => rfl
  | cons p xs ih =>
    obtain ⟨x,y⟩:=p
    have hx:=signed16Code_steps x (h (x,y) (List.mem_cons_self ..)).1
    have hy:=signed16Code_steps y (h (x,y) (List.mem_cons_self ..)).2
    have ht:=ih (fun q hq => h q (List.mem_cons_of_mem _ hq))
    simp only [checkPairs,List.length_cons]
    omega

/- Pair gathering uses the explicit sequential signed-file reader twice
per coefficient pair. Both copies of `pairs ss` in decision are charged. -/
def pairSteps (xs : List SignedWord) : ℕ :=
  ∑ i : Fin 768, ((loadSigned xs i.val).steps+(loadSigned xs (i.val+768)).steps+66)

theorem pairSteps_bound (xs : List SignedWord) (h : ∀ x∈xs,x.magnitude.length≤16) :
    pairSteps xs≤2^24 := by
  unfold pairSteps
  calc
    _ ≤ ∑ _i : Fin 768,(2*(4*1536+35)+66 : ℕ) := by
      apply Finset.sum_le_sum
      intro i _
      have hi:=i.isLt
      have hl:=loadSigned_steps xs i.val 16 h
      have hr:=loadSigned_steps xs (i.val+768) 16 h
      omega
    _ ≤ _ := by
      simp only [Finset.sum_const,Finset.card_univ,Fintype.card_fin,smul_eq_mul]
      norm_num

set_option maxRecDepth 32768 in
theorem norm_length (xs ys : List SignedWord)
    (hx : ∀ x∈xs,x.magnitude.length≤16) (hy : ∀ y∈ys,y.magnitude.length≤16) :
    (NormMachine.normCode (pairs xs++pairs ys)).word.magnitude.length≤1586 := by
  have hl : (pairs xs++pairs ys).length=1536 := by
    simp only [List.length_append,pairs_length]
  have hp : ∀ p∈pairs xs++pairs ys,p.1.magnitude.length≤16 ∧ p.2.magnitude.length≤16 := by
    intro p hm
    rcases List.mem_append.mp hm with hm|hm
    · exact pairs_word_length xs hx p hm
    · exact pairs_word_length ys hy p hm
  have hn:=NormMachine.sumResults_length
    ((pairs xs++pairs ys).map fun x => NormMachine.blockCode x.1 x.2) 50 (by
      intro z hz
      obtain ⟨p,hp',rfl⟩:=List.mem_map.mp hz
      exact NormMachine.blockCode_length _ _ (hp p hp').1 (hp p hp').2)
  simpa only [NormMachine.normCode,List.length_map,hl,Nat.reduceAdd] using hn

/- Primitive bit counts for the executable file pipeline. The last term
pays for finite-file copies, concatenation, tags and loop control.
Full reducer state memory and its external ports are accounted elsewhere. -/
def decisionSteps (hs cs : List (List Bool)) (ss : List SignedWord) : ℕ :=
  let ws:=polynomialInput hs ss
  let ps:=product hs ss
  let zs:=residual hs cs ss
  let n:=NormMachine.normCode (pairs zs++pairs ss)
  fieldFileSteps (reducedFile ss)+PolynomialMachine.multiplyFileSteps ws+
    signedFileSteps (centeredFile cs ps)+pairSteps zs+2*pairSteps ss+
    n.steps+(checkPairs (pairs ss)).2+(signedLess n.word threshold).2+
    64*(hs.length+cs.length+ss.length+3072)+2^12

theorem decision_bit_steps (hs cs : List (List Bool)) (ss : List SignedWord)
    (hh : ∀ x∈hs,x.length≤16) (hc : ∀ x∈cs,x.length≤16)
    (hss : ∀ x∈ss,x.magnitude.length≤16)
    (hhl : hs.length≤1536) (hcl : cs.length≤1536) (hsl : ss.length≤1536) :
    decisionSteps hs cs ss≤2^66 := by
  have hw : ∀ w∈polynomialInput hs ss,w.length≤16 := by
    intro w hm
    rcases List.mem_append.mp hm with hm|hm
    · exact hh w hm
    · exact reducedFile_word_length ss w hm
  have hp:=product_word_length (polynomialInput hs ss) hw
  have hz:=centeredFile_word_length cs (product hs ss)
  have hnorm : ∀ p∈pairs (residual hs cs ss)++pairs ss,
      p.1.magnitude.length≤16 ∧ p.2.magnitude.length≤16 := by
    intro p hm
    rcases List.mem_append.mp hm with hm|hm
    · exact pairs_word_length _ hz p hm
    · exact pairs_word_length ss hss p hm
  have hr:=reduceFile_steps ss hss
  have hm:=PolynomialMachine.multiplyFile_bit_steps_general (polynomialInput hs ss) hw
  have hcc:=centeredFile_steps cs (product hs ss) hc hp
  have hpz:=pairSteps_bound (residual hs cs ss) hz
  have hps:=pairSteps_bound ss hss
  have hnn:=NormMachine.normCode_steps (pairs (residual hs cs ss)++pairs ss)
    (by simp only [List.length_append,pairs_length,Nat.le_refl]) hnorm
  have hchk:=checkPairs_steps (pairs ss) (pairs_word_length ss hss)
  rw [pairs_length] at hchk
  have hnlen:=norm_length (residual hs cs ss) ss hz hss
  have ht:=signedLess_steps (NormMachine.normCode (pairs (residual hs cs ss)++pairs ss)).word threshold
  have htl : threshold.magnitude.length=32 := encodeSigned_length _ _
  rw [htl] at ht
  dsimp only [decisionSteps]
  omega

end FT1536.Run2.FileVerifier
