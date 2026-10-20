import Run2.PolynomialMachine
import Run2.ScalarMachine
import Run2.NormMachine

namespace FT1536.Run2.FileArithmetic
open FT1536.Relation BitArithmetic PolynomialReference

def zeroSigned : SignedWord := ⟨false,[]⟩

def loadSigned : List SignedWord → ℕ → SignedResult
  | [],_ => ⟨zeroSigned,1⟩
  | w::_,0 => ⟨w,2*w.magnitude.length+3⟩
  | _::ws,n+1 => let r:=loadSigned ws n; ⟨r.word,4+r.steps⟩

theorem loadSigned_correct (xs : List SignedWord) (n : ℕ) :
    (loadSigned xs n).word=xs[n]?.getD zeroSigned := by
  induction xs generalizing n with
  | nil => simp [loadSigned]
  | cons x xs ih => cases n <;> simp [loadSigned,ih]

theorem loadSigned_length (xs : List SignedWord) (n K : ℕ)
    (h : ∀ x∈xs,x.magnitude.length≤K) : (loadSigned xs n).word.magnitude.length≤K := by
  induction xs generalizing n with
  | nil => simp [loadSigned,zeroSigned]
  | cons x xs ih =>
    cases n with
    | zero => exact h x (List.mem_cons_self ..)
    | succ n => exact ih n (fun y hy => h y (List.mem_cons_of_mem _ hy))

theorem loadSigned_steps (xs : List SignedWord) (n K : ℕ)
    (h : ∀ x∈xs,x.magnitude.length≤K) : (loadSigned xs n).steps≤4*n+2*K+3 := by
  induction xs generalizing n with
  | nil => simp [loadSigned]
  | cons x xs ih =>
    cases n with
    | zero => have hh:=h x (List.mem_cons_self ..); simp only [loadSigned]; omega
    | succ n =>
      have hh:=ih n (fun y hy => h y (List.mem_cons_of_mem _ hy))
      simp only [loadSigned]; omega

theorem getD_ofFn {α : Type} {n : ℕ} (f : Fin n → α) (i : Fin n) (d : α) :
    ((List.ofFn f)[i.val]?.getD d)=f i := by
  simp only [List.getElem?_ofFn,i.isLt,dite_true,Option.getD_some]

def intCoefficient (s : Geometry.Vec) (i : TermIndex) : ℤ :=
  if i.2 then (s i.1).2 else (s i.1).1

def SignedRepresents (xs : List SignedWord) (s : Geometry.Vec) : Prop :=
  ∀ i,signedValue (loadSigned xs (exponent i)).word=intCoefficient s i

def FieldRepresents (xs : List (List Bool)) (a : Rq) : Prop :=
  ∀ i,(value (FieldProgram.load xs (exponent i)).bits : F)=coefficient a i

def reducedFile (xs : List SignedWord) : List Result := List.ofFn fun r : Fin 1536 =>
  let x:=loadSigned xs r.val
  let y:=fieldReduceSigned x.word
  ⟨y.bits,x.steps+y.steps+2⟩

def resultBits (xs : List Result) : List (List Bool) := xs.map Result.bits

theorem reducedFile_length (xs : List SignedWord) : (reducedFile xs).length=1536 := List.length_ofFn

theorem reducedFile_word_length (xs : List SignedWord) :
    ∀ w∈resultBits (reducedFile xs),w.length≤16 := by
  intro w hw
  obtain ⟨r,hr,rfl⟩:=List.mem_map.mp hw
  obtain ⟨i,rfl⟩:=List.mem_ofFn.mp hr
  exact (fieldReduceSigned_length _).trans (by decide)

theorem reduceFile_correct (xs : List SignedWord) (s : Geometry.Vec) (h : SignedRepresents xs s) :
    FieldRepresents (resultBits (reducedFile xs)) (reduceVec s) := by
  intro i
  rw [FieldProgram.load_correct]
  simp only [resultBits,reducedFile,List.map_ofFn]
  rw [getD_ofFn _ ⟨exponent i,exponent_lt i⟩]
  change (value (fieldReduceSigned _).bits : F)=_
  rw [fieldReduceSigned_correct,h i]
  obtain ⟨i,b⟩:=i
  cases b <;> rfl

theorem append_represents (as bs : List (List Bool)) (a b : Rq)
    (hlen : as.length=1536) (ha : FieldRepresents as a) (hb : FieldRepresents bs b) :
    PolynomialMachine.Represents (as++bs) a b := by
  constructor
  · intro i
    have hi:=exponent_lt i
    rw [List.getElem?_append_left (by omega)]
    simpa only [FieldProgram.load_correct] using ha i
  · intro i
    rw [List.getElem?_append_right (by omega),hlen,Nat.add_sub_cancel_left]
    simpa only [FieldProgram.load_correct] using hb i

theorem product_coordinate (ws : List (List Bool)) (a b : Rq)
    (h : PolynomialMachine.Represents ws a b) (i : TermIndex) :
    (value (FieldProgram.load (resultBits (PolynomialMachine.multiplyFile ws)) (exponent i)).bits : F)=
      coefficient (mulRq a b) i := by
  rw [FieldProgram.load_correct]
  simp only [resultBits,PolynomialMachine.multiplyFile,List.map_ofFn]
  rw [getD_ofFn _ ⟨exponent i,exponent_lt i⟩]
  dsimp only [Function.comp_def]
  rw [PolynomialMachine.coefficient_correct ws a b h]
  rw [←PolynomialReference.multiply_correct]
  obtain ⟨i,b⟩:=i
  cases b <;> rfl

def centerDifference (cs ps : List (List Bool)) (n : ℕ) : SignedResult :=
  let c:=FieldProgram.load cs n; let p:=FieldProgram.load ps n
  let d:=fieldSubtract c.bits p.bits
  let z:=centerCode d.bits
  ⟨z.word,c.steps+p.steps+d.steps+z.steps+4⟩

def centeredFile (cs ps : List (List Bool)) : List SignedResult :=
  List.ofFn fun r : Fin 1536 => centerDifference cs ps r.val

def resultWords (xs : List SignedResult) : List SignedWord := xs.map SignedResult.word

theorem centerDifference_correct (cs ps : List (List Bool)) (c p : Rq)
    (hc : FieldRepresents cs c) (hp : FieldRepresents ps p) (i : TermIndex) :
    signedValue (centerDifference cs ps (exponent i)).word=intCoefficient (centerRq (c-p)) i := by
  have hv:=fieldSubtract_correct (FieldProgram.load cs (exponent i)).bits
    (FieldProgram.load ps (exponent i)).bits
  rw [hc i,hp i] at hv
  have hcan:=fieldSubtract_canonical (FieldProgram.load cs (exponent i)).bits
    (FieldProgram.load ps (exponent i)).bits
  have he := congrArg ZMod.val hv
  simp only [ZMod.val_natCast,Nat.mod_eq_of_lt hcan] at he
  simp only [centerDifference,centerCode_correct _ hcan,he]
  obtain ⟨i,b⟩:=i
  cases b <;> rfl

theorem centeredFile_correct (cs ps : List (List Bool)) (c p : Rq)
    (hc : FieldRepresents cs c) (hp : FieldRepresents ps p) :
    SignedRepresents (resultWords (centeredFile cs ps)) (centerRq (c-p)) := by
  intro i
  rw [loadSigned_correct]
  simp only [resultWords,centeredFile,List.map_ofFn]
  rw [getD_ofFn _ ⟨exponent i,exponent_lt i⟩]
  exact centerDifference_correct cs ps c p hc hp i

theorem centeredFile_word_length (cs ps : List (List Bool)) :
    ∀ x∈resultWords (centeredFile cs ps),x.magnitude.length≤16 := by
  intro x hx
  obtain ⟨r,hr,rfl⟩:=List.mem_map.mp hx
  obtain ⟨i,rfl⟩:=List.mem_ofFn.mp hr
  exact centerCode_length _ ((fieldSubtract_length _ _).trans (by decide))

theorem product_word_length (ws : List (List Bool)) (h : ∀ w∈ws,w.length≤16) :
    ∀ w∈resultBits (PolynomialMachine.multiplyFile ws),w.length≤16 := by
  intro w hw
  obtain ⟨r,hr,rfl⟩:=List.mem_map.mp hw
  obtain ⟨i,rfl⟩:=List.mem_ofFn.mp hr
  exact FieldProgram.execute_length ws _ h

def fieldFileSteps (xs : List Result) : ℕ := (xs.map fun r => r.steps+2*r.bits.length+1).sum
def signedFileSteps (xs : List SignedResult) : ℕ :=
  (xs.map fun r => r.steps+2*r.word.magnitude.length+3).sum

theorem reduceFile_steps (xs : List SignedWord) (h : ∀ x∈xs,x.magnitude.length≤16) :
    fieldFileSteps (reducedFile xs)≤2^33 := by
  simp only [fieldFileSteps,reducedFile,List.map_ofFn,List.sum_ofFn,Function.comp_def]
  calc
    _ ≤ ∑ _i : Fin 1536, (4*1536+35+2^22+2+33 : ℕ) := by
      apply Finset.sum_le_sum
      intro i _
      have hn:=i.isLt
      have hl:=loadSigned_length xs i.val 16 h
      have hs:=loadSigned_steps xs i.val 16 h
      have hr:=fieldReduceSigned_steps (loadSigned xs i.val).word hl
      have hb:=fieldReduceSigned_length (loadSigned xs i.val).word
      omega
    _ ≤ _ := by
      simp only [Finset.sum_const,Finset.card_univ,Fintype.card_fin,smul_eq_mul]
      norm_num

theorem centerDifference_steps (cs ps : List (List Bool)) (n : ℕ) (hn : n<1536)
    (hc : ∀ w∈cs,w.length≤16) (hp : ∀ w∈ps,w.length≤16) :
    (centerDifference cs ps n).steps≤2*(4*1536+33)+2^22+516+4 := by
  have cl:=FieldProgram.load_length cs n 16 hc
  have pl:=FieldProgram.load_length ps n 16 hp
  have ct:=FieldProgram.load_steps cs n 16 hc
  have pt:=FieldProgram.load_steps ps n 16 hp
  have dt:=fieldSubtract_steps (FieldProgram.load cs n).bits (FieldProgram.load ps n).bits cl pl
  have dl:=fieldSubtract_length (FieldProgram.load cs n).bits (FieldProgram.load ps n).bits
  have zt:=centerCode_steps (fieldSubtract (FieldProgram.load cs n).bits (FieldProgram.load ps n).bits).bits
    (by omega)
  dsimp only [centerDifference]
  omega

theorem centeredFile_steps (cs ps : List (List Bool))
    (hc : ∀ w∈cs,w.length≤16) (hp : ∀ w∈ps,w.length≤16) :
    signedFileSteps (centeredFile cs ps)≤2^33 := by
  simp only [signedFileSteps,centeredFile,List.map_ofFn,List.sum_ofFn,Function.comp_def]
  calc
    _ ≤ ∑ _i : Fin 1536, (2*(4*1536+33)+2^22+516+4+35 : ℕ) := by
      apply Finset.sum_le_sum
      intro i _
      have ht:=centerDifference_steps cs ps i.val i.isLt hc hp
      have hl:=centerCode_length
        (fieldSubtract (FieldProgram.load cs i.val).bits (FieldProgram.load ps i.val).bits).bits
        ((fieldSubtract_length _ _).trans (by decide))
      change (centerDifference cs ps i.val).word.magnitude.length≤16 at hl
      omega
    _ ≤ _ := by
      simp only [Finset.sum_const,Finset.card_univ,Fintype.card_fin,smul_eq_mul]
      norm_num

end FT1536.Run2.FileArithmetic
