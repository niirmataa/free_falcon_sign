import Source3.KeygenCheckExpression

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCheckExpressionSound
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ModularReference (Eval)
open KeygenFinalCheck (Arrays)
open KeygenCheckExpression (Inputs)

theorem pointer_exists (s : State) (name : String) (root : ArrayPointer) (i : Nat) (word : BitVec 32)
    (hi : i≤1536) (counter : C99CountedWords.Counter s i) (binding : s.arrays name.toList=some root)
    (read : Load32 s.heap (KeygenSmallOutput.element root i) word) :
    C99ArrayReference.Pointer s name.toList (.var "u".toList) (KeygenSmallOutput.element root i) := by
  have bound : root.index+i≤root.count := by
    cases read with
    | load bytes allocated width initialized => exact Nat.le_of_lt allocated.2.2.1
  have nonnegative : (0 : Int)≤(Value.uint64 (BitVec.ofNat 64 i)).integer := by
    change (0 : Int)≤((BitVec.ofNat 64 i).toNat : Int)
    omega
  apply C99ArrayReference.Pointer.add name.toList (.var "u".toList) root _
    (.uint64 (BitVec.ofNat 64 i)) binding (C99ScalarReference.Eval.variable _ _ _ counter) nonnegative
  have hn : (Value.uint64 (BitVec.ofNat 64 i)).integer.toNat=i := by
    have hn : (BitVec.ofNat 64 i).toNat=i := Nat.mod_eq_of_lt (by omega)
    change ((BitVec.ofNat 64 i).toNat : Int).toNat=i
    rw [hn]
    rfl
  rw [hn]
  exact PointerAdd.within root i bound

theorem product_exists (s : State) (leftName rightName : String) (leftPtr rightPtr : ArrayPointer)
    (p0i : BitVec 32) (i : Nat) (a b : BitVec 32) (hi : i≤1536)
    (counter : C99CountedWords.Counter s i)
    (leftBinding : s.arrays leftName.toList=some leftPtr) (rightBinding : s.arrays rightName.toList=some rightPtr)
    (prime : s.locals "p".toList=some (.uint32,some (.uint32 KeygenNinv31.prime)))
    (inverse : s.locals "p0i".toList=some (.uint32,some (.uint32 p0i)))
    (readA : Load32 s.heap (KeygenSmallOutput.element leftPtr i) a)
    (readB : Load32 s.heap (KeygenSmallOutput.element rightPtr i) b) :
    Eval s (KeygenCheckProgram.product leftName rightName)
      (.uint32 (KeygenModpWord.montgomery a b KeygenNinv31.prime p0i)) := by
  refine .call4 _ _ _ _ _ _ _ _ _ _
    (.load32 leftName.toList _ _ a (pointer_exists s leftName leftPtr i a hi counter leftBinding readA) readA)
    (.load32 rightName.toList _ _ b (pointer_exists s rightName rightPtr i b hi counter rightBinding readB) readB)
    (.scalar _ _ (C99ScalarReference.Eval.variable _ _ _ prime))
    (.scalar _ _ (C99ScalarReference.Eval.variable _ _ _ inverse)) ?_
  exact .montgomery _ _ (KeygenModpWord.source_exists a b KeygenNinv31.prime p0i)

theorem expression_exists (arrays : Arrays) (s : State) (p0i target : BitVec 32) (i : Nat)
    (a b bigF bigG : BitVec 32) (hi : i≤1536) (counter : C99CountedWords.Counter s i)
    (inputs : Inputs arrays p0i target s)
    (readF : Load32 s.heap (KeygenSmallOutput.element arrays.f i) a)
    (readG : Load32 s.heap (KeygenSmallOutput.element arrays.g i) b)
    (readBigF : Load32 s.heap (KeygenSmallOutput.element arrays.bigF i) bigF)
    (readBigG : Load32 s.heap (KeygenSmallOutput.element arrays.bigG i) bigG) :
    ∃ out, Eval s KeygenCheckProgram.expression (.uint32 out) := by
  let left := KeygenModpWord.montgomery a bigG KeygenNinv31.prime p0i
  let right := KeygenModpWord.montgomery b bigF KeygenNinv31.prime p0i
  refine ⟨KeygenModpAddSub.result .sub left right KeygenNinv31.prime,
    .call3 _ _ _ _ (.uint32 left) (.uint32 right) (.uint32 KeygenNinv31.prime) _ ?_ ?_ ?_ ?_⟩
  · exact product_exists s "ft" "Gt" arrays.f arrays.bigG p0i i a bigG hi counter inputs.f inputs.bigG inputs.prime inputs.inverse readF readBigG
  · exact product_exists s "gt" "Ft" arrays.g arrays.bigF p0i i b bigF hi counter inputs.g inputs.bigF inputs.prime inputs.inverse readG readBigF
  · exact .scalar _ _ (C99ScalarReference.Eval.variable _ _ _ inputs.prime)
  · exact .sub _ _ (KeygenModpAddSub.source_exists .sub left right KeygenNinv31.prime)

end FT1536.Source3.KeygenCheckExpressionSound
