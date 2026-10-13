import Source3.KeygenDecodeStaticUnaryScope

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- COMPLETE real unary bit-loop body, including fresh bit declaration,
   conditional physical refill, db_len--, bit extraction and actual break. -/
namespace FT1536.Source3.KeygenDecodeStaticUnaryBody
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire

def freshBit (s : State) : State := ⟨s.heap,localSet s.locals "bit".toList .uint32 none,s.buf⟩

theorem body (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (bit : Bool) (tail : List Bool) (small : p<8)
    (wire : Wire args src dst v p db bytes s) (bits : remaining p db bytes=bit::tail) :
    ∃ v' p' db' bytes' t,
      Checked args KeygenDecodeStaticBinding.node069 s t (KeygenDecodeStaticUnaryDecision.flow bit) ∧
      Wire args src dst v' p' db' bytes' t ∧ p'<8 ∧ remaining p' db' bytes'=tail ∧ v'+bytes'.length=v+bytes.length ∧ t.heap=s.heap := by
  let s1 := freshBit s
  have declare : Checked args KeygenDecodeStaticBinding.node042 s s1 .normal :=
    KeygenDecodeStaticCertified.declare args s [⟨"bit".toList,.u32,none⟩]
      (localSet s.locals "bit".toList .uint32 none) rfl
  have wire1 := KeygenDecodeStaticReaderFrame.wire_frame args src dst v p db bytes s s1 _ .normal declare.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel) (by decide +kernel) wire
  have needed : 1≤(remaining p db bytes).length := by rw [bits,List.length_cons]; omega
  obtain ⟨v1,p1,db1,bytes1,filled,fill,wire2,positive,upper,sameBits,fillCount,fillHeap⟩ :=
    KeygenDecodeStaticUnaryRefill.conditional args src dst v p db bytes s1 (by omega) wire1 needed
  have bit1 : s1.locals.scalars "bit".toList=some (.uint32,none) := by
    simp only [s1,freshBit,localSet,C99ScalarReference.set,ite_true]
  have bit2 := (KeygenDecodeStaticCellFrame.exec_frame "bit".toList args _ s1 filled .normal fill.run (by decide +kernel)).trans bit1
  obtain ⟨select,wire3,lastBits,selectHeap⟩ := KeygenDecodeStaticUnarySelect.select args src dst v1 p1 db1 bytes1 filled bit tail
    positive upper wire2 bit2 (sameBits.trans bits)
  let raw := KeygenDecodeStaticUnarySelect.setBit (KeygenDecodeStaticScalarTests.afterPop filled p1) bit
  let t := scopeExit KeygenDecodeStaticBinding.node068 s raw
  have inside : Checked args KeygenDecodeStaticBinding.node068 s raw (KeygenDecodeStaticUnaryDecision.flow bit) :=
    seq args _ _ s s1 raw _ declare (seq args _ _ s1 filled raw _ fill select)
  have full : Checked args KeygenDecodeStaticBinding.node069 s t (KeygenDecodeStaticUnaryDecision.flow bit) :=
    scope args KeygenDecodeStaticBinding.node068 s raw _ (by intro impossible; cases impossible) inside
  have finalWire : Wire args src dst v1 (p1-1) db1 bytes1 t :=
    KeygenDecodeStaticUnaryScope.wire args src dst v1 (p1-1) db1 bytes1 s raw wire3
  exact ⟨v1,p1-1,db1,bytes1,t,full,finalWire,by omega,lastBits,fillCount,selectHeap.trans fillHeap⟩

end FT1536.Source3.KeygenDecodeStaticUnaryBody
