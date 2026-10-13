import Source3.KeygenPublicEncodeReady077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeAppend077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

def rhs : Expr := .binary .bor (.binary .shl (.variable "acc".toList) (.number .i32 15))
  (.unary .dereference (.postInc (.variable "x".toList)))
def after (s : State) (next : ArrayPointer) (acc : BitVec 32) (input : BitVec 16) : State :=
  withLocals s (localSet {s.locals with x := some next} "acc".toList .uint32
    (some (.uint32 (KeygenPublicBits077.appended acc input))))

theorem unsigned_convert (input : BitVec 16) : C99IntegerReference.convert .uint32
    (C99IntegerReference.Value.int32 (BitVec.ofNat 32 input.toNat)).integer=.uint32 (input.setWidth 32) := by
  rw [C99IntegerReference.Value.integer,KeygenCodecNoneCursor.signed_nat32 input.toNat (by have bound:=input.isLt; omega)]
  change C99IntegerReference.Value.uint32 (BitVec.ofInt 32 (input.toNat : Int))=_
  rw [BitVec.ofInt_natCast,BitVec.ofNat_toNat]

theorem or_input (acc : BitVec 32) (input : BitVec 16) :
    C99IntegerReference.BitwiseExec .or (.uint32 acc) (.int32 (BitVec.ofNat 32 input.toNat))
      (.uint32 (acc ||| input.setWidth 32)) := by
  have source := C99IntegerReference.BitwiseExec.step .or (.uint32 acc) (.int32 (BitVec.ofNat 32 input.toNat)) .uint32 rfl
    (.uint32 acc) (.uint32 (input.setWidth 32)) (KeygenDecodeWordOps.self32 _).symm (unsigned_convert input).symm
  have same : C99IntegerReference.convert .uint32 (C99IntegerReference.bitResult .or
      (C99IntegerReference.Value.uint32 acc).bits (C99IntegerReference.Value.uint32 (input.setWidth 32)).bits)=.uint32 (acc ||| input.setWidth 32) := by
    change C99IntegerReference.Value.uint32 (BitVec.ofNat 32 (acc ||| input.setWidth 32).toNat)=_
    rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem calculation (args : Args) (s : State) (ptr next : ArrayPointer) (acc : BitVec 32) (input : BitVec 16)
    (held : s.locals.x=some ptr) (advance : PointerAdd ptr 1 next) (load : Load16 s.heap ptr input)
    (cell : Cell "acc" .uint32 (.uint32 acc) s.locals) :
    Computes args s.heap s.buf rhs s.locals (.uint32 (KeygenPublicBits077.appended acc input)) {s.locals with x := some next} := by
  have shifted : KeygenPublicEncodePure077.Computes s.locals
      (.binary .shl (.variable "acc".toList) (.number .i32 15)) (.uint32 (acc <<< 15)) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) cell)
      (.number _ _ _ (by decide +kernel)) (.shl _ _ _ (KeygenDecodeWordOps.left32 acc 15 (by decide +kernel)))
  exact .binary _ _ _ _ _ _ _ _ _ (.pure _ _ _ shifted) (.read _ _ _ _ held advance load) (.bor _ _ _ (or_input _ _))

theorem source_append (args : Args) (s : State) (ptr next : ArrayPointer) (acc : BitVec 32) (input : BitVec 16)
    (held : s.locals.x=some ptr) (advance : PointerAdd ptr 1 next) (load : Load16 s.heap ptr input)
    (cell : Cell "acc" .uint32 (.uint32 acc) s.locals) :
    Checked args KeygenPublicEncodeBinding077.node009 s (after s next acc input) .normal := by
  have source := assign args s "acc".toList .uint32 (some (.uint32 acc)) rhs _ {s.locals with x := some next}
    (by decide +kernel) (by decide +kernel) cell (calculation args s ptr next acc input held advance load cell)
  simpa only [KeygenDecodeWordOps.self32,KeygenPublicEncodeBinding077.node009,rhs,KeygenPublicBits077.appended,after] using source

end FT1536.Source3.KeygenPublicEncodeAppend077
