import Source3.KeygenDecodeStaticPaddingReturn

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticOuterSuffix
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire

theorem advanced_wire (args : Args) (src dst : ArrayPointer) (u v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (bound : u<1536)
    (wire : Wire args src dst v p db bytes s)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals) :
    Wire args src dst v p db bytes (KeygenDecodeStaticOuterCounter.next s u) := by
  have evaluated : Checked args (.evaluate KeygenDecodeStaticBinding.guard096) s
      (KeygenDecodeStaticOuterCounter.next s u) .normal :=
    KeygenDecodeStaticCertified.evaluate args s _ _ _
      (KeygenDecodeStaticOuterCounter.calculation args s u bound cursor wire.ready.context.count)
  exact KeygenDecodeStaticReaderFrame.wire_frame args src dst v p db bytes s _ _ .normal evaluated.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel)
    (by decide +kernel) wire

theorem nonfinal (args : Args) (s : State) (u : Nat) (bound : u+1<1536)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (count : Cell "n" .uint64 (.uint64 1536) s.locals) :
    Checked args KeygenDecodeStaticBinding.node098 s (KeygenDecodeStaticOuterCounter.next s u) .normal :=
  seq args KeygenDecodeStaticBinding.node096 KeygenDecodeStaticBinding.node097 s _ _ .normal
    (KeygenDecodeStaticOuterCounter.source_nonfinal args s u bound cursor count) (skip args _)

theorem final (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (small : p<8)
    (wire : Wire args src dst v p db bytes s)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 1535)) s.locals)
    (zero : KeygenCodecStaticSuffix.low db p=0) :
    Checked args KeygenDecodeStaticBinding.node098 s (KeygenDecodeStaticOuterCounter.next s 1535)
      (.returned (BitVec.ofNat 64 v)) := by
  let next := KeygenDecodeStaticOuterCounter.next s 1535
  have wireNext := advanced_wire args src dst 1535 v p db bytes s (by decide +kernel) wire cursor
  have returned := KeygenDecodeStaticPaddingReturn.complete args next v p db small
    wireNext.ready.cursor wireNext.ready.pending wireNext.ready.accumulator zero
  have branch : Checked args KeygenDecodeStaticBinding.node096 s next (.returned (BitVec.ofNat 64 v)) :=
    branch_true args KeygenDecodeStaticBinding.guard096 KeygenDecodeStaticBinding.node095 .skip s next _ _ next.locals
      (KeygenDecodeStaticOuterCounter.calculation args s 1535 (by decide +kernel) cursor wire.ready.context.count)
      (by decide +kernel) returned
  exact seq_return args _ _ s next _ branch

end FT1536.Source3.KeygenDecodeStaticOuterSuffix
