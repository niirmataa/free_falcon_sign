import Source3.KeygenDecodeStaticOuterScope
import Source3.KeygenDecodeNoneMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete real STATIC iteration, including its outer u++ test and
   lexical exit. Physical writes come from the actual coefficient body. -/
namespace FT1536.Source3.KeygenDecodeStaticIteration
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire
open KeygenDecodeNoneMemory (WritableArray element)

def pieces : List Stmt := [KeygenDecodeStaticBinding.node023,KeygenDecodeStaticBinding.node024,
  KeygenDecodeStaticBinding.node025,KeygenDecodeStaticBinding.node038,KeygenDecodeStaticBinding.node039,
  KeygenDecodeStaticBinding.node040,KeygenDecodeStaticBinding.node041,KeygenDecodeStaticBinding.node070,
  KeygenDecodeStaticBinding.node075,KeygenDecodeStaticBinding.node076,KeygenDecodeStaticBinding.node085]

theorem source_partition : KeygenDecodeStaticBinding.node109=
    KeygenDecodeStaticSequence.chain pieces KeygenDecodeStaticBinding.node098 := rfl

theorem nonfinal (args : Args) (src dst : ArrayPointer) (u v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (input : BitVec 16) (tail : List Bool)
    (bound : u+1<1536) (small : p<8) (wire : Wire args src dst v p db bytes s)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (bits : remaining p db bytes=KeygenCodecStaticBitStream.coefficient input++tail)
    (legal : WritableArray s.heap dst 1536) (separated : src.block≠dst.block) :
    ∃ v' p' db' bytes' t, Checked args KeygenDecodeStaticBinding.node110 s t .normal ∧
      Wire args src dst v' p' db' bytes' t ∧ p'<8 ∧
      Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 (u+1))) t.locals ∧
      Store16 s.heap (element dst u) input t.heap ∧ remaining p' db' bytes'=tail ∧
      v'+bytes'.length=v+bytes.length := by
  obtain ⟨v',p',db',bytes',middle,core,middleWire,lastSmall,middleCursor,store,lastBits,byteCount⟩ :=
    KeygenDecodeStaticCoefficient.complete args src dst (element dst u) u v p db bytes s input tail small wire cursor bits
      (KeygenDecodeNoneMemory.advance _ _ _ _ legal (by omega)) (legal.2.2 u (by omega)) legal.1 legal.2.1 separated
  let advanced := KeygenDecodeStaticOuterCounter.next middle u
  let t := scopeExit KeygenDecodeStaticBinding.node109 s advanced
  have suffix : Checked args KeygenDecodeStaticBinding.node098 middle advanced .normal :=
    KeygenDecodeStaticOuterSuffix.nonfinal args middle u bound middleCursor middleWire.ready.context.count
  have body : Checked args KeygenDecodeStaticBinding.node109 s advanced .normal :=
    KeygenDecodeStaticSequence.append_checked pieces args s middle advanced _ .normal core suffix
  have full : Checked args KeygenDecodeStaticBinding.node110 s t .normal :=
    scope args KeygenDecodeStaticBinding.node109 s advanced .normal (by intro impossible; cases impossible) body
  have advancedWire := KeygenDecodeStaticOuterSuffix.advanced_wire args src dst u v' p' db' bytes' middle (by omega) middleWire middleCursor
  have finalWire : Wire args src dst v' p' db' bytes' t :=
    KeygenDecodeStaticOuterScope.wire args src dst v' p' db' bytes' s advanced advancedWire
  have advancedCursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 (u+1))) advanced.locals := by
    simp only [Cell,advanced,KeygenDecodeStaticOuterCounter.next,withLocals,localSet,C99ScalarReference.set,ite_true]
  exact ⟨v',p',db',bytes',t,full,finalWire,lastSmall,
    KeygenDecodeStaticOuterScope.cursor s advanced (u+1) advancedCursor,store,lastBits,byteCount⟩

theorem final (args : Args) (src dst : ArrayPointer) (v p padding : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (input : BitVec 16) (small : p<8) (paddingSmall : padding<8)
    (wire : Wire args src dst v p db bytes s)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 1535)) s.locals)
    (bits : remaining p db bytes=KeygenCodecStaticBitStream.coefficient input++List.replicate padding false)
    (legal : WritableArray s.heap dst 1536) (separated : src.block≠dst.block) :
    ∃ t, Checked args KeygenDecodeStaticBinding.node110 s t (.returned (BitVec.ofNat 64 (v+bytes.length))) ∧
      Store16 s.heap (element dst 1535) input t.heap := by
  obtain ⟨v',p',db',bytes',middle,core,middleWire,lastSmall,middleCursor,store,lastBits,byteCount⟩ :=
    KeygenDecodeStaticCoefficient.complete args src dst (element dst 1535) 1535 v p db bytes s input _ small wire cursor bits
      (KeygenDecodeNoneMemory.advance _ _ _ _ legal (by decide +kernel)) (legal.2.2 1535 (by decide +kernel)) legal.1 legal.2.1 separated
  obtain ⟨empty,_,zero⟩ := KeygenDecodeStaticPaddingBits.exhausted p' padding db' bytes' paddingSmall lastBits
  have consumed : v'=v+bytes.length := by rw [empty,List.length_nil,Nat.add_zero] at byteCount; exact byteCount
  let advanced := KeygenDecodeStaticOuterCounter.next middle 1535
  let t := scopeExit KeygenDecodeStaticBinding.node109 s advanced
  have suffix : Checked args KeygenDecodeStaticBinding.node098 middle advanced (.returned (BitVec.ofNat 64 v')) :=
    KeygenDecodeStaticOuterSuffix.final args src dst v' p' db' bytes' middle lastSmall middleWire middleCursor zero
  have body : Checked args KeygenDecodeStaticBinding.node109 s advanced (.returned (BitVec.ofNat 64 v')) :=
    KeygenDecodeStaticSequence.append_checked pieces args s middle advanced _ _ core suffix
  have full : Checked args KeygenDecodeStaticBinding.node110 s t (.returned (BitVec.ofNat 64 v')) :=
    scope args KeygenDecodeStaticBinding.node109 s advanced _ (by intro impossible; cases impossible) body
  rw [consumed] at full
  exact ⟨t,full,store⟩

end FT1536.Source3.KeygenDecodeStaticIteration
