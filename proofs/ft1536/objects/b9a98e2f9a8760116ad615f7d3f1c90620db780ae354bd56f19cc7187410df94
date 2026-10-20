import Run2.PolynomialReference
import Run2.FieldProgram
import Run2.WordEncoding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Run2.PolynomialMachine
open FT1536.Relation PolynomialReference FieldProgram

def indices : List TermIndex :=
  (List.ofFn (fun i : Fin 768 => (i,false)))++(List.ofFn (fun i : Fin 768 => (i,true)))

theorem indices_length : indices.length=1536 := by
  simp only [indices,List.length_append,List.length_ofFn]

theorem sum_indices (f : TermIndex → PolynomialReference.F) :
    (indices.map f).sum=∑ i : TermIndex,f i := by
  have hi : termFinite=instFintypeProd (Fin 768) Bool := Subsingleton.elim _ _
  rw [hi]
  simp only [indices,List.map_append,List.map_ofFn,List.sum_append,List.sum_ofFn]
  simp [Fintype.sum_prod_type,Finset.sum_add_distrib,add_comm]

def factor (k : Fin 3072) (r : Fin 1536) : Expr :=
  if k.val<1536 then (if k.val=r.val then .one else .zero)
  else if k.val<2304 then
    .add (if k.val-768=r.val then .one else .zero)
      (if k.val-1536=r.val then .negOne else .zero)
  else if k.val-2304=r.val then .negOne else .zero

theorem factor_correct (ws : List (List Bool)) (k : Fin 3072) (r : Fin 1536) :
    meaning ws (factor k r)=coefficientOfTerms (remainderTerms k) r := by
  unfold factor remainderTerms
  split
  · split <;> simp_all [coefficientOfTerms,meaning,Fin.ext_iff]
  · split
    · simp only [meaning]
      split <;> split <;> simp_all [coefficientOfTerms,meaning,Fin.ext_iff]
    · split <;> simp_all [coefficientOfTerms,meaning,Fin.ext_iff]

theorem factor_weight (k : Fin 3072) (r : Fin 1536) : weight (factor k r)≤3 := by
  unfold factor
  split
  · split <;> decide
  · split
    · split <;> split <;> decide
    · split <;> decide

def term (i j : TermIndex) (r : Fin 1536) : Expr :=
  .mul (.mul (.input (exponent i)) (.input (1536+exponent j))) (factor (productExponent i j) r)

def coefficientProgram (r : Fin 1536) : Expr :=
  FieldProgram.sum (indices.map fun i => FieldProgram.sum (indices.map fun j => term i j r))

def Represents (ws : List (List Bool)) (a b : Rq) : Prop :=
  (∀ i, (BitArithmetic.value (ws[exponent i]?.getD []) : PolynomialReference.F)=coefficient a i) ∧
  (∀ j, (BitArithmetic.value (ws[1536+exponent j]?.getD []) : PolynomialReference.F)=coefficient b j)

theorem term_correct (ws : List (List Bool)) (a b : Rq) (h : Represents ws a b)
    (i j : TermIndex) (r : Fin 1536) :
    meaning ws (term i j r)=coefficient a i*coefficient b j*
      coefficientOfTerms (remainderTerms (productExponent i j)) r := by
  simp only [term,meaning,h.1,h.2,factor_correct]

theorem coefficient_correct (ws : List (List Bool)) (a b : Rq) (h : Represents ws a b)
    (r : Fin 1536) :
    (BitArithmetic.value (execute ws (coefficientProgram r)).bits : PolynomialReference.F)=
      multiplyCoefficient a b r := by
  rw [execute_correct]
  simp only [coefficientProgram,meaning_sum,List.map_map,Function.comp_def]
  simp_rw [term_correct ws a b h,sum_indices]
  rfl

theorem term_weight (i j : TermIndex) (r : Fin 1536) : weight (term i j r)≤6150 := by
  have hi:=exponent_lt i
  have hj:=exponent_lt j
  have hf:=factor_weight (productExponent i j) r
  simp only [term,weight]
  omega

theorem coefficient_weight (r : Fin 1536) :
    weight (coefficientProgram r)≤((6150+1)*1536+1+1)*1536+1 := by
  unfold coefficientProgram
  have hi (i : TermIndex) : weight (FieldProgram.sum (indices.map fun j => term i j r))≤(6150+1)*1536+1 := by
    have hh:=weight_sum_bound (indices.map fun j => term i j r) 6150 (by
      intro p hp
      obtain ⟨j,_,rfl⟩:=List.mem_map.mp hp
      exact term_weight i j r)
    simpa only [List.length_map,indices_length] using hh
  have hh:=weight_sum_bound (indices.map fun i => FieldProgram.sum (indices.map fun j => term i j r))
    ((6150+1)*1536+1) (by
      intro p hp
      obtain ⟨i,_,rfl⟩:=List.mem_map.mp hp
      exact hi i)
  simpa only [List.length_map,indices_length] using hh

theorem coefficient_bit_steps (ws : List (List Bool)) (r : Fin 1536)
    (h : ∀ w∈ws,w.length≤16) :
    (execute ws (coefficientProgram r)).steps≤
      (2^20+4)*(((6150+1)*1536+2)*1536+1) := by
  exact (execute_steps ws _ h).trans (Nat.mul_le_mul_left _ (coefficient_weight r))

def flat (a : Rq) (r : Fin 1536) : PolynomialReference.F :=
  if h : r.val<768 then (a ⟨r.val,h⟩).1 else (a ⟨r.val-768,by omega⟩).2

theorem flat_exponent (a : Rq) (i : TermIndex) :
    flat a ⟨exponent i,exponent_lt i⟩=coefficient a i := by
  obtain ⟨i,b⟩:=i
  have hi:=i.isLt
  cases b <;> simp [flat,exponent,coefficient,hi]

def inputFile (a b : Rq) : List (List Bool) := List.ofFn fun i : Fin 3072 =>
  if h : i.val<1536 then BitArithmetic.encodeNat (flat a ⟨i.val,h⟩).val 16
  else BitArithmetic.encodeNat (flat b ⟨i.val-1536,by omega⟩).val 16

theorem inputFile_length (a b : Rq) : (inputFile a b).length=3072 := List.length_ofFn

theorem inputFile_word_length (a b : Rq) : ∀ w∈inputFile a b,w.length≤16 := by
  intro w hw
  obtain ⟨i,rfl⟩:=List.mem_ofFn.mp hw
  split <;> simp only [BitArithmetic.encodeNat_length,Nat.le_refl]

theorem inputFile_represents (a b : Rq) : Represents (inputFile a b) a b := by
  constructor
  · intro i
    have hi:=exponent_lt i
    have hv : (flat a ⟨exponent i,hi⟩).val<2^16 :=
      (ZMod.val_lt _).trans (by decide)
    simp only [inputFile,List.getElem?_ofFn]
    simp only [show exponent i<3072 by omega,dite_true,hi,Option.getD_some]
    rw [BitArithmetic.encodeNat_value _ _ hv,ZMod.natCast_zmod_val,flat_exponent]
  · intro i
    have hi:=exponent_lt i
    have hv : (flat b ⟨exponent i,hi⟩).val<2^16 :=
      (ZMod.val_lt _).trans (by decide)
    simp only [inputFile,List.getElem?_ofFn]
    simp only [show 1536+exponent i<3072 by omega,dite_true,
      show ¬1536+exponent i<1536 by omega,dite_false,Nat.add_sub_cancel_left,Option.getD_some]
    rw [BitArithmetic.encodeNat_value _ _ hv,ZMod.natCast_zmod_val,flat_exponent]

/- All 1536 outputs are actually computed, rather than accessed as an
unbounded mathematical function. The sum is the sequential file producer's
cost, including two bit operations per output bit and a control step. -/
def multiplyFile (ws : List (List Bool)) : List BitArithmetic.Result :=
  List.ofFn fun r : Fin 1536 => execute ws (coefficientProgram r)

def multiplyFileSteps (ws : List (List Bool)) : ℕ :=
  ((multiplyFile ws).map (fun r => r.steps+2*r.bits.length+1)).sum

def decodeFile (rs : List BitArithmetic.Result) : Rq := fun i =>
  ((BitArithmetic.value ((rs[i.val]?.getD ⟨[],0⟩).bits) : PolynomialReference.F),
   (BitArithmetic.value ((rs[i.val+768]?.getD ⟨[],0⟩).bits) : PolynomialReference.F))

theorem multiplyFile_correct (a b : Rq) :
    decodeFile (multiplyFile (inputFile a b))=mulRq a b := by
  rw [←multiply_correct]
  funext i
  have hi:=i.isLt
  simp only [decodeFile,multiplyFile,List.getElem?_ofFn]
  simp only [show i.val<1536 by omega,show i.val+768<1536 by omega,dite_true,Option.getD_some]
  rw [coefficient_correct _ a b (inputFile_represents a b),
    coefficient_correct _ a b (inputFile_represents a b)]
  rfl

theorem multiplyFile_bit_steps_general (ws : List (List Bool))
    (h : ∀ w∈ws,w.length≤16) :
    multiplyFileSteps ws≤
      1536*((2^20+4)*(((6150+1)*1536+2)*1536+1)+33) := by
  simp only [multiplyFileSteps,multiplyFile,List.map_ofFn,List.sum_ofFn]
  calc
    _ ≤ ∑ _r : Fin 1536, ((2^20+4)*(((6150+1)*1536+2)*1536+1)+33) := by
      apply Finset.sum_le_sum
      intro r _
      have hs:=coefficient_bit_steps ws r h
      have hl:=execute_length ws (coefficientProgram r) h
      dsimp only [Function.comp_def]
      omega
    _ = _ := by simp only [Finset.sum_const,Finset.card_univ,Fintype.card_fin,smul_eq_mul]

theorem multiplyFile_bit_steps (a b : Rq) :
    multiplyFileSteps (inputFile a b)≤
      1536*((2^20+4)*(((6150+1)*1536+2)*1536+1)+33) :=
  multiplyFile_bit_steps_general _ (inputFile_word_length a b)

end FT1536.Run2.PolynomialMachine
