import Run2.FileArithmetic

namespace FT1536.Run2.FileVerifier
open FT1536.Relation BitArithmetic FileArithmetic PolynomialReference

def pairs (xs : List SignedWord) : List (SignedWord × SignedWord) := List.ofFn fun i : Fin 768 =>
  ((loadSigned xs i.val).word,(loadSigned xs (i.val+768)).word)

theorem represents_first (xs : List SignedWord) (s : Geometry.Vec) (h : SignedRepresents xs s)
    (i : Fin 768) : signedValue (loadSigned xs i.val).word=(s i).1 := by
  simpa only [exponent,intCoefficient,Bool.false_eq_true,ite_false,Nat.add_zero] using h (i,false)

theorem represents_second (xs : List SignedWord) (s : Geometry.Vec) (h : SignedRepresents xs s)
    (i : Fin 768) : signedValue (loadSigned xs (i.val+768)).word=(s i).2 := by
  simpa only [exponent,intCoefficient,ite_true] using h (i,true)

theorem pairs_norm (xs : List SignedWord) (s : Geometry.Vec) (h : SignedRepresents xs s) :
    ((pairs xs).map fun p => Geometry.block (signedValue p.1) (signedValue p.2)).sum=Geometry.Q0 s := by
  simp only [pairs,List.map_ofFn,List.sum_ofFn,Function.comp_def,Geometry.Q0]
  apply Finset.sum_congr rfl
  intro i _
  rw [represents_first xs s h,represents_second xs s h]

def low : SignedWord := encodeSigned (-32768) 16
def high : SignedWord := encodeSigned 32768 16
def threshold : SignedWord := encodeSigned Geometry.B 32

theorem low_value : signedValue low= -32768 := encodeSigned_correct _ _ (by norm_num)
theorem high_value : signedValue high=32768 := encodeSigned_correct _ _ (by norm_num)
theorem threshold_value : signedValue threshold=Geometry.B := encodeSigned_correct _ _ (by norm_num [Geometry.B])

def signed16Code (x : SignedWord) : Bool × ℕ :=
  let l:=signedLess x low; let u:=signedLess x high
  (!l.1 && u.1,l.2+u.2+2)

theorem signed16Code_correct (x : SignedWord) :
    (signed16Code x).1=true ↔ -32768≤signedValue x ∧ signedValue x≤32767 := by
  simp only [signed16Code,signedLess_correct,low_value,high_value,Bool.and_eq_true,
    Bool.not_eq_true',decide_eq_false_iff_not,decide_eq_true_eq]
  omega

def checkPairs : List (SignedWord × SignedWord) → Bool × ℕ
  | [] => (true,1)
  | (x,y)::xs =>
      let a:=signed16Code x; let b:=signed16Code y; let r:=checkPairs xs
      (a.1 && b.1 && r.1,a.2+b.2+r.2+3)

theorem checkPairs_correct (xs : List (SignedWord × SignedWord)) :
    (checkPairs xs).1=true ↔ ∀ x∈xs,
      (-32768≤signedValue x.1 ∧ signedValue x.1≤32767) ∧
      (-32768≤signedValue x.2 ∧ signedValue x.2≤32767) := by
  induction xs with
  | nil => simp [checkPairs]
  | cons p xs ih =>
    obtain ⟨x,y⟩:=p
    simp only [checkPairs,Bool.and_eq_true,signed16Code_correct,ih,List.forall_mem_cons]

theorem check_represented (xs : List SignedWord) (s : Geometry.Vec) (h : SignedRepresents xs s) :
    (checkPairs (pairs xs)).1=true ↔ Relation.signed16 s := by
  rw [checkPairs_correct]
  constructor
  · intro hc i
    have hi:=hc ((loadSigned xs i.val).word,(loadSigned xs (i.val+768)).word)
      (List.mem_ofFn.mpr ⟨i,rfl⟩)
    rw [represents_first xs s h,represents_second xs s h] at hi
    exact ⟨hi.1.1,hi.1.2,hi.2.1,hi.2.2⟩
  · intro hc p hp
    obtain ⟨i,rfl⟩:=List.mem_ofFn.mp hp
    rw [represents_first xs s h,represents_second xs s h]
    exact ⟨⟨(hc i).1,(hc i).2.1⟩,(hc i).2.2⟩

def polynomialInput (hs : List (List Bool)) (ss : List SignedWord) : List (List Bool) :=
  hs++resultBits (reducedFile ss)

def product (hs : List (List Bool)) (ss : List SignedWord) : List (List Bool) :=
  resultBits (PolynomialMachine.multiplyFile (polynomialInput hs ss))

def residual (hs cs : List (List Bool)) (ss : List SignedWord) : List SignedWord :=
  resultWords (centeredFile cs (product hs ss))

theorem product_represents (hs : List (List Bool)) (ss : List SignedWord) (h : Rq) (s : Geometry.Vec)
    (hlen : hs.length=1536) (hh : FieldRepresents hs h) (hss : SignedRepresents ss s) :
    FieldRepresents (product hs ss) (mulRq h (reduceVec s)) := by
  intro i
  apply product_coordinate
  exact append_represents hs (resultBits (reducedFile ss)) h (reduceVec s) hlen hh
    (reduceFile_correct ss s hss)

theorem residual_represents (hs cs : List (List Bool)) (ss : List SignedWord)
    (h c : Rq) (s : Geometry.Vec) (hlen : hs.length=1536)
    (hh : FieldRepresents hs h) (hc : FieldRepresents cs c) (hss : SignedRepresents ss s) :
    SignedRepresents (residual hs cs ss) (Relation.extract h c s).1 :=
  centeredFile_correct cs (product hs ss) c (mulRq h (reduceVec s)) hc
    (product_represents hs ss h s hlen hh hss)

def decision (hs cs : List (List Bool)) (ss : List SignedWord) : Bool :=
  let z:=residual hs cs ss
  let n:=NormMachine.normCode (pairs z++pairs ss)
  let check:=checkPairs (pairs ss)
  check.1 && (signedLess n.word threshold).1

/- Complete semantic refinement of the file/bit program to the actual
Verify predicate. There is no assumed equivalence or ideal arithmetic call
inside the executable decision code. -/
theorem decision_correct (hs cs : List (List Bool)) (ss : List SignedWord)
    (h c : Rq) (s : Geometry.Vec) (hlen : hs.length=1536)
    (hh : FieldRepresents hs h) (hc : FieldRepresents cs c) (hss : SignedRepresents ss s) :
    decision hs cs ss=true ↔ Verify h c s := by
  have hz:=residual_represents hs cs ss h c s hlen hh hc hss
  simp only [decision,Bool.and_eq_true,check_represented ss s hss,signedLess_correct,
    decide_eq_true_eq,threshold_value,NormMachine.normCode_correct,List.map_append,List.sum_append]
  rw [pairs_norm _ _ hz,pairs_norm ss s hss]
  rfl

end FT1536.Run2.FileVerifier
