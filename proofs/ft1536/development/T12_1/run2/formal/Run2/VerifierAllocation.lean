import Run2.BitAllocation
import Run2.VerifierInputs

namespace FT1536.Run2.VerifierAllocation
open BitArithmetic FileArithmetic FileVerifier FieldProgram

def load (ws : List (List Bool)) (n : ℕ) : ℕ := match ws,n with
  | [],_ => 32
  | w::_,0 => 2*w.length+32
  | _::ws,n+1 => load ws n+32

theorem load_bound (ws : List (List Bool)) (n : ℕ) : load ws n≤32*(FieldProgram.load ws n).steps := by
  induction ws generalizing n with
  | nil => rfl
  | cons w ws ih =>
    cases n with
    | zero => simp only [load,FieldProgram.load]; omega
    | succ n => have hh:=ih n; simp only [load,FieldProgram.load]; omega

def loadSigned (ws : List SignedWord) (n : ℕ) : ℕ := match ws,n with
  | [],_ => 32
  | w::_,0 => 2*w.magnitude.length+33
  | _::ws,n+1 => loadSigned ws n+32

theorem loadSigned_bound (ws : List SignedWord) (n : ℕ) :
    loadSigned ws n≤32*(FileArithmetic.loadSigned ws n).steps := by
  induction ws generalizing n with
  | nil => rfl
  | cons w ws ih =>
    cases n with
    | zero => simp only [loadSigned,FileArithmetic.loadSigned]; omega
    | succ n => have hh:=ih n; simp only [loadSigned,FileArithmetic.loadSigned]; omega

def expression (ws : List (List Bool)) : Expr → ℕ
  | .zero => 32
  | .one => 33
  | .negOne => 47
  | .input n => load ws n
  | .add a b => expression ws a+expression ws b+
      BitAllocation.fadd (execute ws a).bits (execute ws b).bits+32
  | .mul a b => expression ws a+expression ws b+
      BitAllocation.fmul (execute ws a).bits (execute ws b).bits+32

theorem expression_bound (ws : List (List Bool)) (p : Expr) :
    expression ws p≤32*(execute ws p).steps := by
  induction p with
  | zero => rfl
  | one => change (33 : ℕ)≤32*3; decide
  | negOne => change (47 : ℕ)≤32*31; decide
  | input n => exact load_bound ws n
  | add a b ha hb =>
    have hh:=BitAllocation.fadd_bound (execute ws a).bits (execute ws b).bits
    simp only [expression,execute]
    omega
  | mul a b ha hb =>
    have hh:=BitAllocation.fmul_bound (execute ws a).bits (execute ws b).bits
    simp only [expression,execute]
    omega

/- Unary input addresses and explicit literal/instruction blocks. All
coefficient programs are stored, rather than generated at no charged cost. -/
def expressionCode : Expr → ℕ
  | .zero | .one | .negOne => 32
  | .input n => n+32
  | .add a b | .mul a b => expressionCode a+expressionCode b+32

theorem expressionCode_bound (p : Expr) : expressionCode p≤32*weight p := by
  induction p <;> simp only [expressionCode,weight] at * <;> omega

def polynomialCode : ℕ := ∑ r : Fin 1536,expressionCode (PolynomialMachine.coefficientProgram r)

theorem polynomialCode_bound : polynomialCode≤2^50 := by
  unfold polynomialCode
  calc
    _ ≤ ∑ _r : Fin 1536,32*(((6150+1)*1536+2)*1536+1) := by
      apply Finset.sum_le_sum
      intro r _
      exact (expressionCode_bound _).trans (Nat.mul_le_mul_left 32 (PolynomialMachine.coefficient_weight r))
    _ ≤ _ := by
      simp only [Finset.sum_const,Finset.card_univ,Fintype.card_fin,smul_eq_mul]
      norm_num

def reduceFile (ss : List SignedWord) : ℕ := ∑ r : Fin 1536,
  (loadSigned ss r.val+BitAllocation.reduceSigned (FileArithmetic.loadSigned ss r.val).word+32+
    2*(fieldReduceSigned (FileArithmetic.loadSigned ss r.val).word).bits.length+32)

theorem reduceFile_bound (ss : List SignedWord) : reduceFile ss≤32*fieldFileSteps (reducedFile ss) := by
  simp only [reduceFile,fieldFileSteps,reducedFile,List.map_ofFn,List.sum_ofFn,Function.comp_def,Finset.mul_sum]
  apply Finset.sum_le_sum
  intro r _
  have hl:=loadSigned_bound ss r.val
  have hr:=BitAllocation.reduceSigned_bound (FileArithmetic.loadSigned ss r.val).word
  omega

def multiplyFile (ws : List (List Bool)) : ℕ := ∑ r : Fin 1536,
  (expression ws (PolynomialMachine.coefficientProgram r)+
    2*(execute ws (PolynomialMachine.coefficientProgram r)).bits.length+32)

theorem multiplyFile_bound (ws : List (List Bool)) :
    multiplyFile ws≤32*PolynomialMachine.multiplyFileSteps ws := by
  simp only [multiplyFile,PolynomialMachine.multiplyFileSteps,PolynomialMachine.multiplyFile,
    List.map_ofFn,List.sum_ofFn,Function.comp_def,Finset.mul_sum]
  apply Finset.sum_le_sum
  intro r _
  have hh:=expression_bound ws (PolynomialMachine.coefficientProgram r)
  omega

def centerDifference (cs ps : List (List Bool)) (n : ℕ) : ℕ :=
  load cs n+load ps n+
    BitAllocation.fsub (FieldProgram.load cs n).bits (FieldProgram.load ps n).bits+
    BitAllocation.center (fieldSubtract (FieldProgram.load cs n).bits (FieldProgram.load ps n).bits).bits+32

theorem centerDifference_bound (cs ps : List (List Bool)) (n : ℕ) :
    centerDifference cs ps n≤32*(FileArithmetic.centerDifference cs ps n).steps := by
  have hl:=load_bound cs n
  have hr:=load_bound ps n
  have hs:=BitAllocation.fsub_bound (FieldProgram.load cs n).bits (FieldProgram.load ps n).bits
  have hc:=BitAllocation.center_bound (fieldSubtract (FieldProgram.load cs n).bits (FieldProgram.load ps n).bits).bits
  simp only [centerDifference,FileArithmetic.centerDifference]
  omega

def centeredFile (cs ps : List (List Bool)) : ℕ := ∑ r : Fin 1536,
  (centerDifference cs ps r.val+2*(FileArithmetic.centerDifference cs ps r.val).word.magnitude.length+33)

theorem centeredFile_bound (cs ps : List (List Bool)) :
    centeredFile cs ps≤32*signedFileSteps (FileArithmetic.centeredFile cs ps) := by
  simp only [centeredFile,signedFileSteps,FileArithmetic.centeredFile,List.map_ofFn,List.sum_ofFn,
    Function.comp_def,Finset.mul_sum]
  apply Finset.sum_le_sum
  intro r _
  have hh:=centerDifference_bound cs ps r.val
  omega

def pair (ss : List SignedWord) : ℕ := ∑ r : Fin 768,
  (loadSigned ss r.val+loadSigned ss (r.val+768)+66)

theorem pair_bound (ss : List SignedWord) : pair ss≤32*pairSteps ss := by
  simp only [pair,pairSteps,Finset.mul_sum]
  apply Finset.sum_le_sum
  intro r _
  have hl:=loadSigned_bound ss r.val
  have hr:=loadSigned_bound ss (r.val+768)
  omega

def block (x y : SignedWord) : ℕ :=
  BitAllocation.smul x x+BitAllocation.smul x y+BitAllocation.smul y y+
    BitAllocation.sadd (signedMultiply x x).word (signedMultiply x y).word+
    BitAllocation.sadd (signedAdd (signedMultiply x x).word (signedMultiply x y).word).word
      (signedMultiply y y).word+32

theorem block_bound (x y : SignedWord) : block x y≤32*(NormMachine.blockCode x y).steps := by
  have hxx:=BitAllocation.smul_bound x x
  have hxy:=BitAllocation.smul_bound x y
  have hyy:=BitAllocation.smul_bound y y
  have ha:=BitAllocation.sadd_bound (signedMultiply x x).word (signedMultiply x y).word
  have hb:=BitAllocation.sadd_bound
    (signedAdd (signedMultiply x x).word (signedMultiply x y).word).word (signedMultiply y y).word
  simp only [block,NormMachine.blockCode]
  omega

def sumResults : List (SignedResult × ℕ) → ℕ
  | [] => 32
  | (x,a)::xs => a+sumResults xs+
      BitAllocation.sadd x.word (NormMachine.sumResults (xs.map Prod.fst)).word+32

theorem sumResults_bound (xs : List (SignedResult × ℕ))
    (h : ∀ x∈xs,x.2≤32*x.1.steps) :
    sumResults xs≤32*(NormMachine.sumResults (xs.map Prod.fst)).steps := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    have hx:=h x (List.mem_cons_self ..)
    have ht:=ih (fun y hy => h y (List.mem_cons_of_mem _ hy))
    have ha:=BitAllocation.sadd_bound x.1.word (NormMachine.sumResults (xs.map Prod.fst)).word
    obtain ⟨r,a⟩:=x
    dsimp only at hx ha
    simp only [sumResults,List.map_cons,NormMachine.sumResults]
    omega

def norm (xs : List (SignedWord × SignedWord)) : ℕ :=
  sumResults (xs.map fun p => (NormMachine.blockCode p.1 p.2,block p.1 p.2))

theorem norm_bound (xs : List (SignedWord × SignedWord)) : norm xs≤32*(NormMachine.normCode xs).steps := by
  have hh:=sumResults_bound (xs.map fun p => (NormMachine.blockCode p.1 p.2,block p.1 p.2)) (by
    intro x hx
    obtain ⟨p,_,rfl⟩:=List.mem_map.mp hx
    exact block_bound p.1 p.2)
  simpa only [norm,NormMachine.normCode,List.map_map,Function.comp_def] using hh

def signed16 (x : SignedWord) : ℕ := BitAllocation.sless x low+BitAllocation.sless x high+32

theorem signed16_bound (x : SignedWord) : signed16 x≤32*(signed16Code x).2 := by
  have hl:=BitAllocation.sless_bound x low
  have hu:=BitAllocation.sless_bound x high
  simp only [signed16,signed16Code]
  omega

def checkPairs : List (SignedWord × SignedWord) → ℕ
  | [] => 32
  | (x,y)::xs => signed16 x+signed16 y+checkPairs xs+32

theorem checkPairs_bound (xs : List (SignedWord × SignedWord)) :
    checkPairs xs≤32*(FileVerifier.checkPairs xs).2 := by
  induction xs with
  | nil => rfl
  | cons p xs ih =>
    obtain ⟨x,y⟩:=p
    have hx:=signed16_bound x
    have hy:=signed16_bound y
    simp only [checkPairs,FileVerifier.checkPairs]
    omega

def decision (hs cs : List (List Bool)) (ss : List SignedWord) : ℕ :=
  let ps:=product hs ss
  let zs:=residual hs cs ss
  let ns:=pairs zs++pairs ss
  reduceFile ss+multiplyFile (polynomialInput hs ss)+centeredFile cs ps+pair zs+2*pair ss+
    norm ns+checkPairs (pairs ss)+BitAllocation.sless (NormMachine.normCode ns).word threshold+
    64*(hs.length+cs.length+ss.length+3072)+2^12

theorem decision_bound (hs cs : List (List Bool)) (ss : List SignedWord) :
    decision hs cs ss≤32*decisionSteps hs cs ss := by
  have hr:=reduceFile_bound ss
  have hm:=multiplyFile_bound (polynomialInput hs ss)
  have hc:=centeredFile_bound cs (product hs ss)
  have hp:=pair_bound (residual hs cs ss)
  have hs':=pair_bound ss
  have hn:=norm_bound (pairs (residual hs cs ss)++pairs ss)
  have hk:=checkPairs_bound (pairs ss)
  have hl:=BitAllocation.sless_bound (NormMachine.normCode (pairs (residual hs cs ss)++pairs ss)).word threshold
  simp only [decision,decisionSteps]
  omega

theorem concrete_decision_bound (h c : FT1536.Relation.Rq) (s : PublicSimulation.BoxVec) :
    decision (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)≤2^71 := by
  have hh:=(decision_bound (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)).trans
    (Nat.mul_le_mul_left 32 (concrete_bit_verifier_steps h c s))
  exact hh

end FT1536.Run2.VerifierAllocation

#print FT1536.Run2.VerifierAllocation.concrete_decision_bound
#print axioms FT1536.Run2.VerifierAllocation.concrete_decision_bound
#print axioms FT1536.Run2.VerifierAllocation.polynomialCode_bound
