import Source3.KeygenDecodeStaticReady

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticInputGate
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenDecodeStaticCertified KeygenDecodeStaticReady

/-- A single-read availability check, not a whole-codec length premise. -/
theorem comparison (v : Nat) (len : BitVec 64) (available : v<len.toNat) :
    C99IntegerReference.CompareExec .ge (.uint64 (BitVec.ofNat 64 v)) (.uint64 len) (.int32 0) := by
  have convert64 (word : BitVec 64) : C99IntegerReference.convert .uint64
      (C99IntegerReference.Value.uint64 word).integer=.uint64 word := by
    simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,
      BitVec.ofNat_toNat,BitVec.setWidth_eq]
  have source := C99IntegerReference.CompareExec.step .ge (.uint64 (BitVec.ofNat 64 v)) (.uint64 len)
    .uint64 rfl (.uint64 (BitVec.ofNat 64 v)) (.uint64 len) (convert64 _).symm (convert64 _).symm
  have vi := KeygenCodecNoneCursor.unsigned_nat64 v (by have bound:=len.isLt; omega)
  have li : (C99IntegerReference.Value.uint64 len).integer=(len.toNat : Int) := rfl
  have no : ¬(len.toNat : Int)≤v := by omega
  simpa only [C99IntegerReference.compare,vi,li,no,decide_false,Bool.false_eq_true,ite_false,
    show (0#32 : BitVec 32)=(0 : BitVec 32) by decide +kernel] using source

theorem calculation (args : Args) (s : State) (v : Nat) (available : v<args.len.toNat)
    (cursor : KeygenDecodeStaticRead.cursor v s.locals)
    (length : Cell "len" .uint64 (.uint64 args.len) s.locals) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenDecodeStaticBinding.guard030 (.int32 0) :=
  .binary _ _ _ _ _ _
    (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) cursor)
    (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) length)
    (.ge _ _ _ (comparison v args.len available))

theorem source_prefix (args : Args) (s : State) (v : Nat) (available : v<args.len.toNat)
    (cursor : KeygenDecodeStaticRead.cursor v s.locals)
    (length : Cell "len" .uint64 (.uint64 args.len) s.locals) :
    Checked args KeygenDecodeStaticBinding.node030 s s .normal := by
  have source := branch_false args KeygenDecodeStaticBinding.guard030 KeygenDecodeStaticBinding.node029 .skip s s .normal (.int32 0) s.locals
    (.pure _ _ _ (calculation args s v available cursor length)) (by decide +kernel)
    (by simpa only [show withLocals s s.locals=s by cases s; rfl] using skip args s)
  exact source

theorem unary (args : Args) (s : State) (v : Nat) (available : v<args.len.toNat)
    (cursor : KeygenDecodeStaticRead.cursor v s.locals)
    (length : Cell "len" .uint64 (.uint64 args.len) s.locals) :
    Checked args KeygenDecodeStaticBinding.node047 s s .normal := by
  have source := branch_false args KeygenDecodeStaticBinding.guard047 KeygenDecodeStaticBinding.node046 .skip s s .normal (.int32 0) s.locals
    (.pure _ _ _ (calculation args s v available cursor length)) (by decide +kernel)
    (by simpa only [show withLocals s s.locals=s by cases s; rfl] using skip args s)
  exact source

end FT1536.Source3.KeygenDecodeStaticInputGate
