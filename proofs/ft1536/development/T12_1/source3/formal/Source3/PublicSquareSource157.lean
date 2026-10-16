import Source3.PublicArgumentSource157
import Source3.KeygenPublicSquare

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicSquareSource157
open C99IntegerReference (Value)
open KeygenPublicScalar (Body)
open KeygenPublicSquare (Slot)

def entry (x q qi : BitVec 32) := C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params .square)
  [.uint32 x,.uint32 q,.uint32 qi]

theorem cells (x q qi : BitVec 32) : Slot (entry x q qi) "x" x ∧ Slot (entry x q qi) "q" q ∧ Slot (entry x q qi) "q0i" qi := by
  simp [Slot,entry,KeygenPublicScalar.params,C99ModularReference.bindParams,C99ArrayReference.bindValue,
    C99ScalarReference.set,KeygenPublicScalar.empty,KeygenPublicSquare.converted_word]

theorem body (x q qi : BitVec 32) : Body KeygenPublicScalar.Leaf .square [.uint32 x,.uint32 q,.uint32 qi]
    (.uint32 (KeygenPublicLeafWords.montgomery x x q qi)) := by
  let s := entry x q qi
  let w := KeygenPublicLeafWords.montgomery x x q qi
  have leaf : KeygenPublicScalar.Leaf "mq_montymul".toList [.uint32 x,.uint32 x,.uint32 q,.uint32 qi] (.uint32 w) :=
    .run .mul _ _ (by unfold KeygenPublicScalar.IsLeaf; decide) (PublicLeafSource157.body .mul (by decide) [.u32 x,.u32 x,.u32 q,.u32 qi] w rfl
      (KeygenPublicLeafWords.bound_mul x x q qi) (KeygenPublicLeafWords.mul_model x x q qi))
  refine ⟨rfl,⟨s,.returned (some (.uint32 w))⟩,?_,?_⟩
  · rw [KeygenPublicSquare.source_code]
    apply C99ModularReference.GenExec.seqExit
    · exact .ret _ s (.uint32 w) (.call4 _ _ _ _ _ (.uint32 x) (.uint32 x) (.uint32 q) (.uint32 qi) (.uint32 w)
        (.scalar _ _ (.variable "x".toList .uint32 (.uint32 x) (cells x q qi).1))
        (.scalar _ _ (.variable "x".toList .uint32 (.uint32 x) (cells x q qi).1))
        (.scalar _ _ (.variable "q".toList .uint32 (.uint32 q) (cells x q qi).2.1))
        (.scalar _ _ (.variable "q0i".toList .uint32 (.uint32 qi) (cells x q qi).2.2)) leaf)
    · intro impossible; cases impossible
  · simpa only [KeygenPublicSquare.converted_word] using (C99ProcedureReference.ReturnValue.value .uint32 (.uint32 w))

theorem source (x q qi : B20.C.Val) : KeygenPublicScalar.Call "mq_montysqr".toList
    [C99ValueBridge.value x,C99ValueBridge.value q,C99ValueBridge.value qi]
    (.uint32 (KeygenPublicLeafWords.montgomery (PublicArgumentSource157.word x) (PublicArgumentSource157.word x)
      (PublicArgumentSource157.word q) (PublicArgumentSource157.word qi))) :=
  .square _ _ _ (.square _ _ (KeygenPublicArguments.body_conversion _ .square _ _ _
    (PublicArgumentSource157.cons_unsigned _ x _ _ _ (PublicArgumentSource157.cons_unsigned _ q _ _ _
      (PublicArgumentSource157.cons_unsigned _ qi _ _ _ .nil)))
    (body (PublicArgumentSource157.word x) (PublicArgumentSource157.word q) (PublicArgumentSource157.word qi))))

end FT1536.Source3.PublicSquareSource157
