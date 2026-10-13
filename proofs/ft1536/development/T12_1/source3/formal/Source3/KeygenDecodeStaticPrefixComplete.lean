import Source3.KeygenDecodeStaticPrefixAssign

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete source coefficient prefix: three real declarations,
   whole refill loop and sign/db_len/low assignments. No old sign/lo/ne
   values or decoded result are entry assumptions. -/
namespace FT1536.Source3.KeygenDecodeStaticPrefixComplete
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire
open KeygenCodecStaticBitBuffer KeygenCodecStaticBits KeygenCodecStaticBitInverse

def plug (tail : Stmt) : Stmt := .seq KeygenDecodeStaticBinding.node023
  (.seq KeygenDecodeStaticBinding.node024 (.seq KeygenDecodeStaticBinding.node025
    (.seq KeygenDecodeStaticBinding.node038 (.seq KeygenDecodeStaticBinding.node039
      (.seq KeygenDecodeStaticBinding.node040 (.seq KeygenDecodeStaticBinding.node041 tail))))))
def code : Stmt := plug .skip
def fresh (s : State) (name : String) : State :=
  ⟨s.heap,localSet s.locals name.toList .uint32 none,s.buf⟩

theorem source_partition : KeygenDecodeStaticBinding.node109=plug KeygenDecodeStaticBinding.node102 := rfl

theorem complete (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (input : BitVec 16) (tail : List Bool) (small : p<8)
    (wire : Wire args src dst v p db bytes s)
    (bits : remaining p db bytes=KeygenCodecStaticBitStream.coefficient input++tail) :
    ∃ v' r db' bytes' t,
      Checked args code s t .normal ∧ Wire args src dst v' r db' bytes' t ∧ r<8 ∧
      Cell "sign" .uint32 (.uint32 (BitVec.ofNat 32 (sign input).toNat)) t.locals ∧
      Cell "lo" .uint32 (.uint32 (BitVec.ofNat 32 (magnitude input%256))) t.locals ∧
      t.locals.scalars "ne".toList=some (.uint32,none) ∧
      remaining r db' bytes'=List.replicate (magnitude input/256) false++[true]++tail ∧ t.heap=s.heap := by
  let s1 := fresh s "sign"
  let s2 := fresh s1 "lo"
  let s3 := fresh s2 "ne"
  have d0 : Checked args KeygenDecodeStaticBinding.node023 s s1 .normal :=
    KeygenDecodeStaticCertified.declare args s [⟨"sign".toList,.u32,none⟩]
      (localSet s.locals "sign".toList .uint32 none) rfl
  have d1 : Checked args KeygenDecodeStaticBinding.node024 s1 s2 .normal :=
    KeygenDecodeStaticCertified.declare args s1 [⟨"lo".toList,.u32,none⟩]
      (localSet s1.locals "lo".toList .uint32 none) rfl
  have d2 : Checked args KeygenDecodeStaticBinding.node025 s2 s3 .normal :=
    KeygenDecodeStaticCertified.declare args s2 [⟨"ne".toList,.u32,none⟩]
      (localSet s2.locals "ne".toList .uint32 none) rfl
  have w1 := KeygenDecodeStaticReaderFrame.wire_frame args src dst v p db bytes s s1 _ .normal d0.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel) (by decide +kernel) wire
  have w2 := KeygenDecodeStaticReaderFrame.wire_frame args src dst v p db bytes s1 s2 _ .normal d1.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel) (by decide +kernel) w1
  have w3 := KeygenDecodeStaticReaderFrame.wire_frame args src dst v p db bytes s2 s3 _ .normal d2.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel) (by decide +kernel) w2
  have needed : 9≤(remaining p db bytes).length := by
    rw [bits,List.length_append,KeygenCodecStaticBitStream.coefficient_length]
    have cost:=KeygenCodecStaticLength.cost_bounds input
    omega
  obtain ⟨k,p',db',bytes',loaded,refill,loadedWire,pending,lower,upper,sameBits,heap⟩ :=
    KeygenDecodeStaticPrefixLoop.loop args src dst v p db bytes s3 (by omega) w3 needed
  have loadedBits : remaining p' db' bytes'=KeygenCodecStaticBitStream.coefficient input++tail := sameBits.trans bits
  obtain ⟨rest,shape,size,lastBits⟩ := KeygenDecodeStaticPrefixBits.coefficient p' db' bytes' input tail lower loadedBits
  have sign3 : s3.locals.scalars "sign".toList=some (.uint32,none) := by
    simp only [s3,s2,s1,fresh,localSet,C99ScalarReference.set]
    rfl
  have lo3 : s3.locals.scalars "lo".toList=some (.uint32,none) := by
    simp only [s3,s2,fresh,localSet,C99ScalarReference.set]
    rfl
  have ne3 : s3.locals.scalars "ne".toList=some (.uint32,none) := by
    simp only [s3,fresh,localSet,C99ScalarReference.set,ite_true]
  have signLoaded := (KeygenDecodeStaticCellFrame.exec_frame "sign".toList args _ s3 loaded .normal refill.run (by decide +kernel)).trans sign3
  have loLoaded := (KeygenDecodeStaticCellFrame.exec_frame "lo".toList args _ s3 loaded .normal refill.run (by decide +kernel)).trans lo3
  have neLoaded := (KeygenDecodeStaticCellFrame.exec_frame "ne".toList args _ s3 loaded .normal refill.run (by decide +kernel)).trans ne3
  obtain ⟨selected,finalReady,finalSign,finalLow,finalHeap⟩ :=
    KeygenDecodeStaticPrefixAssign.assignments args loaded src dst (v+k) p' (magnitude input) db' (sign input) rest
      lower upper loadedWire.ready signLoaded loLoaded shape size
  let t := KeygenDecodeStaticPrefixAssign.after loaded p' (magnitude input) (sign input)
  have finalWire : Wire args src dst (v+k) (p'-9) db' bytes' t := by
    refine ⟨finalReady,?_,loadedWire.extent⟩
    rw [finalHeap]
    exact loadedWire.reads
  have finalNe := (KeygenDecodeStaticCellFrame.exec_frame "ne".toList args _ loaded t .normal selected.run (by decide +kernel)).trans neLoaded
  have headLength : (sign input::digits 8 (magnitude input)).length=9 := by
    rw [List.length_cons,digits_length]
  have fullShape : buffer ((sign input::digits 8 (magnitude input)).length+rest.length) db'=
      (sign input::digits 8 (magnitude input))++rest := by
    rw [headLength,size,show 9+(p'-9)=p' by omega]
    simpa only [List.cons_append] using shape
  have suffixBits := KeygenDecodeStaticBitSlice.tail_bits _ _ _ fullShape
  rw [size] at suffixBits
  have finalBits : remaining (p'-9) db' bytes'=List.replicate (magnitude input/256) false++[true]++tail := by
    unfold remaining
    rw [suffixBits]
    exact lastBits
  have full : Checked args code s t .normal :=
    seq args _ _ s s1 t .normal d0 (seq args _ _ s1 s2 t .normal d1
      (seq args _ _ s2 s3 t .normal d2 (seq args _ _ s3 loaded t .normal refill selected)))
  exact ⟨v+k,p'-9,db',bytes',t,full,finalWire,by omega,finalSign,finalLow,finalNe,finalBits,finalHeap.trans heap⟩

end FT1536.Source3.KeygenDecodeStaticPrefixComplete
