import Source3.KeygenCodecNoneWord
import Source3.KeygenCodecNonePair
import Source3.KeygenCodecStaticMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Ordered bytes of the real NONE coefficient body. The read witness and
   writes come from one derivation, with no encoded-output premise. -/
namespace FT1536.Source3.KeygenCodecNonePairBytes
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecNoneCursor KeygenCodecScalarCalculation
open KeygenCodecByteHistory

theorem byte_value (word : BitVec 8) :
    BitVec.ofInt 8 (C99IntegerReference.Value.int32 (BitVec.ofNat 32 word.toNat)).integer=word := by
  have small : word.toNat<2^31 := by have bound:=word.isLt; omega
  rw [C99IntegerReference.Value.integer,signed_nat32 word.toNat small,BitVec.ofInt_natCast,
    BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem store_trace (args : Args) (s t : State) (flow : Flow) (n d : Nat)
    (rhs : Expr) (dst : ArrayPointer) (byte : BitVec 8) (bound : n+d<2^64) (small : d<2^31)
    (cursor : Cursor n s.locals) (buffer : s.buf=some (some dst))
    (calculation : Computes s.locals rhs (.int32 (BitVec.ofNat 32 byte.toNat)))
    (source : Exec args (.write (.index (.variable "buf".toList) (index d)) .set rhs) s t flow) :
    Trace s.heap t.heap [(byteOff dst (n+d),byte)] := by
  cases source with
  | store args s index rhs middle last ptr offset word after held indexValue nonnegative rhsValue write =>
    have pointer := Option.some.inj (Option.some.inj (held.symm.trans buffer))
    subst ptr
    obtain ⟨same,lastIndex⟩ := index_eval args s middle (.integer offset) n d bound small cursor indexValue
    have integer : offset=.uint64 (BitVec.ofNat 64 (n+d)) := Value.integer.inj same
    subst offset
    subst middle
    obtain ⟨same,lastValue⟩ := computes_eval args s.heap s.buf s.locals rhs _ calculation last (.integer word) rhsValue
    have integer : word=.int32 (BitVec.ofNat 32 byte.toNat) := Value.integer.inj same
    subst word
    have actualOffset : (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 (n+d))).integer.toNat=n+d := by
      rw [unsigned_nat64 (n+d) bound]; rfl
    rw [actualOffset,byte_value] at write
    exact .step _ _ _ _ _ _ write (.nil _)

/-- One source-bound coefficient body reads exactly one physical int16,
    advances its real pointer and emits its high then low byte. -/
theorem pair_bytes (args : Args) (s t : State) (flow : Flow) (n : Nat) (dst : ArrayPointer)
    (bound : n+1<2^64) (cursor : Cursor n s.locals) (buffer : s.buf=some (some dst))
    (source : Exec args KeygenCodecNoneBinding.node031 s t flow) :
    ∃ ptr next : ArrayPointer, ∃ input : BitVec 16,
      s.locals.x=some ptr ∧ PointerAdd ptr 1 next ∧ Load16 s.heap ptr input ∧
      t.locals.x=some next ∧
      Trace s.heap t.heap [(byteOff dst n,KeygenDecodeNoneScalar.high input),
        (byteOff dst (n+1),KeygenDecodeNoneScalar.low input)] := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨declared,decl,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node022 KeygenCodecNoneBinding.node029 s t flow inside (by rfl)
    obtain ⟨loaded,load,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node023 KeygenCodecNoneBinding.node028 declared t flow rest (by rfl)
    obtain ⟨high,writeHigh,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node024 KeygenCodecNoneBinding.node027 loaded t flow rest (by rfl)
    obtain ⟨low,writeLow,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node025 KeygenCodecNoneBinding.node026 high t flow rest (by rfl)
    cases rest
    have declHeap := KeygenCodecStateFrame.heap_frame args _ s declared .normal decl (by decide +kernel)
    have loadHeap := KeygenCodecStateFrame.heap_frame args _ declared loaded .normal load (by decide +kernel)
    have declaredW : declared.locals.scalars "w".toList=some (.uint32,none) := by
      cases decl with
      | declare args s objects locals declarations =>
        have same : locals=localSet s.locals "w".toList .uint32 none := by
          simpa [KeygenCodecNoneBinding.node022,declareLocals,scalarTy] using declarations.symm
        subst locals
        simp [declared,localSet,C99ScalarReference.set]
    obtain ⟨ptr,next,input,inputPtr,advance,word,lastPtr,wLoaded⟩ :=
      KeygenCodecNoneWord.input_read args declared loaded .normal declaredW load
    have pointerBefore := (KeygenCodecPointerFrame.exec_frame args _ s declared .normal decl (by decide +kernel)).symm.trans inputPtr
    have cursorLoaded : Cursor n loaded.locals :=
      (KeygenCodecCellFrame.exec_frame "u".toList args _ declared loaded .normal load (by decide +kernel)).trans
        ((KeygenCodecCellFrame.exec_frame "u".toList args _ s declared .normal decl (by decide +kernel)).trans cursor)
    have bufferLoaded := (KeygenCodecStateFrame.buf_frame args _ declared loaded .normal load (by decide +kernel)).trans
      ((KeygenCodecStateFrame.buf_frame args _ s declared .normal decl (by decide +kernel)).trans buffer)
    have first := store_trace args loaded high .normal n 0 _ dst (KeygenDecodeNoneScalar.high input)
      (by omega) (by decide +kernel) cursorLoaded bufferLoaded (KeygenCodecNoneWord.high_calculation _ input wLoaded) writeHigh
    have wHigh : KeygenCodecNoneWord.W input high.locals :=
      (KeygenCodecCellFrame.exec_frame "w".toList args _ loaded high .normal writeHigh (by decide +kernel)).trans wLoaded
    have cursorHigh : Cursor n high.locals :=
      (KeygenCodecCellFrame.exec_frame "u".toList args _ loaded high .normal writeHigh (by decide +kernel)).trans cursorLoaded
    have bufferHigh := (KeygenCodecStateFrame.buf_frame args _ loaded high .normal writeHigh (by decide +kernel)).trans bufferLoaded
    have second := store_trace args high t .normal n 1 _ dst (KeygenDecodeNoneScalar.low input)
      bound (by decide +kernel) cursorHigh bufferHigh (KeygenCodecNoneWord.low_calculation _ input wHigh) writeLow
    have pointerAfter := (KeygenCodecPointerFrame.exec_frame args _ high t .normal writeLow (by decide +kernel)).trans
      ((KeygenCodecPointerFrame.exec_frame args _ loaded high .normal writeHigh (by decide +kernel)).trans lastPtr)
    refine ⟨ptr,next,input,pointerBefore,advance,?_,pointerAfter,?_⟩
    · simpa only [declHeap] using word
    · have trace := append _ _ _ _ _ first second
      simpa only [scopeExit,loadHeap,declHeap,Nat.add_zero,List.cons_append,List.nil_append] using trace

end FT1536.Source3.KeygenCodecNonePairBytes
