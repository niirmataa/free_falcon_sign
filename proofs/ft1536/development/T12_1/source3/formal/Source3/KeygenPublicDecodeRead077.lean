import Source3.KeygenPublicDecodeReady077
import Source3.KeygenPublicDecodeBits077
import Source3.KeygenDecodeStaticInputGate

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeRead077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenPublicDecodeCertified077 KeygenPublicDecodeReady077

def next (u : Nat) (l : Locals) : Locals := localSet l "u".toList .uint64 (some (.uint64 (BitVec.ofNat 64 (u+1))))
def readRhs : Expr := .index (.variable "buf".toList) (.postInc (.variable "u".toList))
def appendRhs : Expr := .binary .bor (.binary .shl (.variable "acc".toList) (.number .i32 8)) readRhs
def after (s : State) (u : Nat) (acc : BitVec 32) (byte : BitVec 8) : State :=
  withLocals s (localSet (next u s.locals) "acc".toList .uint32 (some (.uint32 (KeygenPublicDecodeBits077.appended acc byte))))

theorem or_byte (acc : BitVec 32) (byte : BitVec 8) :
    C99IntegerReference.BitwiseExec .or (.uint32 acc) (.int32 (BitVec.ofNat 32 byte.toNat))
      (.uint32 (acc ||| byte.setWidth 32)) := by
  have cast := Option.some.inj (KeygenDecodeWordOps.byte_cast32 byte)
  have source := C99IntegerReference.BitwiseExec.step .or (.uint32 acc) (.int32 (BitVec.ofNat 32 byte.toNat)) .uint32 rfl
    (.uint32 acc) (.uint32 (byte.setWidth 32)) (KeygenDecodeWordOps.self32 _).symm cast.symm
  have same : C99IntegerReference.convert .uint32 (C99IntegerReference.bitResult .or
      (C99IntegerReference.Value.uint32 acc).bits (C99IntegerReference.Value.uint32 (byte.setWidth 32)).bits)=
      .uint32 (acc ||| byte.setWidth 32) := by
    change C99IntegerReference.Value.uint32 (BitVec.ofNat 32 (acc ||| byte.setWidth 32).toNat)=_
    rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem read_calculation (args : Args) (s : State) (u : Nat) (bound : u+1<2^64)
    (src atByte : ArrayPointer) (byte : BitVec 8)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (buffer : s.buf=some (some src)) (advance : PointerAdd src u atByte) (load : LoadByte s.heap atByte byte) :
    Computes args s.heap s.buf readRhs s.locals (.int32 (BitVec.ofNat 32 byte.toNat)) (next u s.locals) := by
  have update : ScalarUpdate "u".toList 1 s.locals (.uint64 (BitVec.ofNat 64 u))
      (.uint64 (BitVec.ofNat 64 (u+1))) (next u s.locals) :=
    .scalar (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) .uint64 cursor _
      (KeygenDecodeNoneRead.plus64 u 1 bound (by decide +kernel)) (KeygenDecodeStaticOuterCounter.self64 _).symm rfl
  apply Computes.byteIndex _ _ _ src atByte (.uint64 (BitVec.ofNat 64 u)) byte buffer (.postInc _ _ _ _ _ update)
  · rw [KeygenCodecNoneCursor.unsigned_nat64 u (by omega)]; omega
  · rw [KeygenCodecNoneCursor.unsigned_nat64 u (by omega)]
    exact advance
  · exact load

theorem append_calculation (args : Args) (s : State) (u : Nat) (bound : u+1<2^64)
    (src atByte : ArrayPointer) (byte : BitVec 8) (acc : BitVec 32)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (word : Cell "acc" .uint32 (.uint32 acc) s.locals)
    (buffer : s.buf=some (some src)) (advance : PointerAdd src u atByte) (load : LoadByte s.heap atByte byte) :
    Computes args s.heap s.buf appendRhs s.locals (.uint32 (KeygenPublicDecodeBits077.appended acc byte)) (next u s.locals) := by
  have shifted : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals
      (.binary .shl (.variable "acc".toList) (.number .i32 8)) (.uint32 (acc <<< 8)) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) word)
      (.number _ _ _ (by decide +kernel)) (.shl _ _ _ (KeygenDecodeWordOps.left32 acc 8 (by decide +kernel)))
  exact .binary _ _ _ _ _ _ _ _ _ (.pure _ _ _ shifted)
    (read_calculation args s u bound src atByte byte cursor buffer advance load) (.bor _ _ _ (or_byte _ _))

theorem source_append (args : Args) (s : State) (u : Nat) (bound : u+1<2^64)
    (src atByte : ArrayPointer) (byte : BitVec 8) (acc : BitVec 32)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (word : Cell "acc" .uint32 (.uint32 acc) s.locals)
    (buffer : s.buf=some (some src)) (advance : PointerAdd src u atByte) (load : LoadByte s.heap atByte byte) :
    Checked args KeygenPublicDecodeBinding077.node014 s (after s u acc byte) .normal := by
  have source := assign args s "acc".toList .uint32 (some (.uint32 acc)) appendRhs _ (next u s.locals)
    (by decide +kernel) (by decide +kernel) word (append_calculation args s u bound src atByte byte acc cursor word buffer advance load)
  simpa only [KeygenDecodeWordOps.self32,KeygenPublicDecodeBinding077.node014,appendRhs,readRhs,after] using source

end FT1536.Source3.KeygenPublicDecodeRead077
