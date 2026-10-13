import Source3.KeygenDecodeStaticCoefficientStore
import Source3.KeygenDecodeStaticPrefixConservation
import Source3.KeygenDecodeStaticSequence

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Compose every actual coefficient operation through its physical store.
   Outer u++/termination/padding remain the next source suffix. -/
namespace FT1536.Source3.KeygenDecodeStaticCoefficient
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire
open KeygenCodecStaticBitInverse

def plug (tail : Stmt) : Stmt := KeygenDecodeStaticPrefixComplete.plug
  (.seq KeygenDecodeStaticBinding.node070 (.seq KeygenDecodeStaticBinding.node075
    (.seq KeygenDecodeStaticBinding.node076 (.seq KeygenDecodeStaticBinding.node085 tail))))
def code : Stmt := plug .skip

theorem source_partition : KeygenDecodeStaticBinding.node109=plug KeygenDecodeStaticBinding.node098 := rfl

theorem complete (args : Args) (src dst atWord : ArrayPointer) (u v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (input : BitVec 16) (tail : List Bool) (small : p<8)
    (wire : Wire args src dst v p db bytes s)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (bits : remaining p db bytes=KeygenCodecStaticBitStream.coefficient input++tail)
    (advance : PointerAdd dst u atWord) (allocated : Allocated s.heap atWord)
    (width : atWord.elementBytes=2) (writable : s.heap.writable atWord.block=true)
    (separated : src.block≠dst.block) :
    ∃ v' p' db' bytes' t,
      Checked args code s t .normal ∧ Wire args src dst v' p' db' bytes' t ∧ p'<8 ∧
      Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) t.locals ∧
      Store16 s.heap atWord input t.heap ∧ remaining p' db' bytes'=tail ∧
      v'+bytes'.length=v+bytes.length := by
  obtain ⟨v1,p1,db1,bytes1,prefixed,prefixRun,prefixWire,prefixSmall,signValue,lowValue,neDeclared,unaryBits,prefixCount,prefixHeap⟩ :=
    KeygenDecodeStaticPrefixConservation.complete_with_count args src dst v p db bytes s input tail small wire bits
  have quotient : magnitude input/256≤128 := by have bound:=magnitude_bound input; omega
  obtain ⟨v2,p2,db2,bytes2,unaryDone,unary,unaryWire,unarySmall,neValue,tailBits,unaryCount,unaryHeap⟩ :=
    KeygenDecodeStaticUnaryLoop.loop args src dst v1 p1 (magnitude input/256) db1 bytes1 prefixed tail
      prefixSmall quotient prefixWire neDeclared (by simpa only [List.singleton_append,List.append_assoc] using unaryBits)
  have signUnary := (KeygenDecodeStaticCellFrame.exec_frame "sign".toList args _ prefixed unaryDone .normal unary.run (by decide +kernel)).trans signValue
  have lowUnary := (KeygenDecodeStaticCellFrame.exec_frame "lo".toList args _ prefixed unaryDone .normal unary.run (by decide +kernel)).trans lowValue
  have guard := KeygenDecodeStaticMagnitude.source_guard args unaryDone (magnitude input/256) quotient neValue
  have join := KeygenDecodeStaticMagnitude.source_join args unaryDone (magnitude input) (magnitude_bound input)
    lowUnary neValue unaryWire.ready.context.j
  let joined := KeygenDecodeStaticMagnitude.after unaryDone (magnitude input)
  have joinedWire : Wire args src dst v2 p2 db2 bytes2 joined :=
    KeygenDecodeStaticReaderFrame.wire_frame args src dst v2 p2 db2 bytes2 unaryDone joined _ .normal join.run
      (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel)
      (by decide +kernel) unaryWire
  have joinedSign := (KeygenDecodeStaticCellFrame.exec_frame "sign".toList args _ unaryDone joined .normal join.run (by decide +kernel)).trans signUnary
  have joinedLow : Cell "lo" .uint32 (.uint32 (BitVec.ofNat 32 (magnitude input))) joined.locals := by
    simp only [Cell,joined,KeygenDecodeStaticMagnitude.after,withLocals,localSet,C99ScalarReference.set,ite_true]
  have cursorPrefix := (KeygenDecodeStaticCellFrame.exec_frame "u".toList args _ s prefixed .normal prefixRun.run (by decide +kernel)).trans cursor
  have cursorUnary := (KeygenDecodeStaticCellFrame.exec_frame "u".toList args _ prefixed unaryDone .normal unary.run (by decide +kernel)).trans cursorPrefix
  have cursorJoined := (KeygenDecodeStaticCellFrame.exec_frame "u".toList args _ unaryDone joined .normal join.run (by decide +kernel)).trans cursorUnary
  have heapJoined : joined.heap=s.heap := unaryHeap.trans prefixHeap
  have legal : Allocated joined.heap atWord := by rw [heapJoined]; exact allocated
  have permission : joined.heap.writable atWord.block=true := by rw [heapJoined]; exact writable
  obtain ⟨store,write⟩ := KeygenDecodeStaticCoefficientStore.source_store args joined u dst atWord input
    cursorJoined joinedSign joinedLow joinedWire.ready.context.destination advance legal width permission
  let t := KeygenDecodeStaticCoefficientStore.after joined atWord input
  have finalReady := KeygenDecodeStaticReaderFrame.ready_frame args src dst v2 p2 db2 joined t _ .normal store.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel) joinedWire.ready
  have away : src.block≠atWord.block := by
    have sameBlock : atWord.block=dst.block := by cases advance; rfl
    rw [sameBlock]
    exact separated
  have finalWire := store_preserved args src dst atWord v2 p2 db2 bytes2 joined t input joinedWire away write finalReady
  have finalCursor := (KeygenDecodeStaticCellFrame.exec_frame "u".toList args _ joined t .normal store.run (by decide +kernel)).trans cursorJoined
  have suffix : Checked args (.seq KeygenDecodeStaticBinding.node070 (.seq KeygenDecodeStaticBinding.node075
      (.seq KeygenDecodeStaticBinding.node076 (.seq KeygenDecodeStaticBinding.node085 .skip)))) prefixed t .normal :=
    seq args _ _ prefixed unaryDone t .normal unary (seq args _ _ unaryDone unaryDone t .normal guard
      (seq args _ _ unaryDone joined t .normal join (seq args _ _ joined t t .normal store (skip args t))))
  have full : Checked args code s t .normal :=
    KeygenDecodeStaticSequence.append_checked
      [KeygenDecodeStaticBinding.node023,KeygenDecodeStaticBinding.node024,KeygenDecodeStaticBinding.node025,
       KeygenDecodeStaticBinding.node038,KeygenDecodeStaticBinding.node039,KeygenDecodeStaticBinding.node040,
       KeygenDecodeStaticBinding.node041] args s prefixed t _ .normal prefixRun suffix
  exact ⟨v2,p2,db2,bytes2,t,full,finalWire,unarySmall,finalCursor,
    by simpa only [heapJoined] using write,tailBits,unaryCount.trans prefixCount⟩

end FT1536.Source3.KeygenDecodeStaticCoefficient
