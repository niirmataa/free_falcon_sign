import Source3.KeygenDecodeStaticReady
import Source3.KeygenDecodeStaticBitRead

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The unread bytes are actual initialized physical loads. Whole-codec
   use must derive them from the same actual encoder, rather than supply
   a desired decoder value or successful-execution premise. -/
namespace FT1536.Source3.KeygenDecodeStaticWire
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenCodecStaticBitBuffer

def Reads (heap : Memory) (src : ArrayPointer) (v : Nat) (bytes : List (BitVec 8)) : Prop :=
  ∀ i : Fin bytes.length, ∃ atByte, PointerAdd src (v+i.val) atByte ∧ LoadByte heap atByte (bytes.get i)

structure Wire (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) : Prop where
  ready : Ready args src dst v p db s
  reads : Reads s.heap src v bytes
  extent : v+bytes.length≤args.len.toNat

def remaining (p : Nat) (db : BitVec 32) (bytes : List (BitVec 8)) : List Bool :=
  buffer p db++bytesBits bytes

theorem bytes_length (bytes : List (BitVec 8)) : (bytesBits bytes).length=8*bytes.length := by
  induction bytes with
  | nil => rfl
  | cons byte rest ih =>
    simp only [bytesBits,List.flatMap_cons,List.length_append,KeygenCodecStaticBits.digits_length,List.length_cons]
    change 8+(bytesBits rest).length=_
    rw [ih]
    omega

theorem head (heap : Memory) (src : ArrayPointer) (v : Nat) (byte : BitVec 8) (rest : List (BitVec 8))
    (reads : Reads heap src v (byte::rest)) : ∃ atByte, PointerAdd src v atByte ∧ LoadByte heap atByte byte := by
  obtain ⟨atByte,advance,load⟩ := reads ⟨0,by simp only [List.length_cons]; omega⟩
  refine ⟨atByte,by simpa only [Nat.add_zero] using advance,?_⟩
  exact load

theorem tail (heap : Memory) (src : ArrayPointer) (v : Nat) (byte : BitVec 8) (rest : List (BitVec 8))
    (reads : Reads heap src v (byte::rest)) : Reads heap src (v+1) rest := by
  intro i
  obtain ⟨atByte,advance,load⟩ := reads ⟨i.val+1,by simpa only [List.length_cons] using Nat.succ_lt_succ i.isLt⟩
  refine ⟨atByte,?_,?_⟩
  · simpa only [show v+(i.val+1)=v+1+i.val by omega] using advance
  · simpa only [List.get_cons_succ] using load

theorem store_preserved (args : Args) (src dst atWord : ArrayPointer) (v p : Nat)
    (db : BitVec 32) (bytes : List (BitVec 8)) (s t : State) (word : BitVec 16)
    (wire : Wire args src dst v p db bytes s) (separated : src.block≠atWord.block)
    (store : Store16 s.heap atWord word t.heap) (ready : Ready args src dst v p db t) :
    Wire args src dst v p db bytes t := by
  refine ⟨ready,?_,wire.extent⟩
  intro i
  obtain ⟨atByte,advance,load⟩ := wire.reads i
  refine ⟨atByte,advance,?_⟩
  have sameBlock : atByte.block=src.block := by cases advance; rfl
  exact KeygenDecodeWrite16.byte_preserved _ _ _ _ _ _ store
    (by rw [sameBlock]; exact separated) load

theorem refill_remaining (p : Nat) (db : BitVec 32) (byte : BitVec 8) (rest : List (BitVec 8))
    (width : p+8≤32) :
    remaining (p+8) ((db <<< 8)+byte.setWidth 32) rest=remaining p db (byte::rest) := by
  unfold remaining
  rw [KeygenDecodeStaticBitRead.refill_bits p db byte width]
  simp only [bytesBits,List.flatMap_cons,List.append_assoc]

end FT1536.Source3.KeygenDecodeStaticWire
