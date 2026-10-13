import Source3.KeygenDecodeStaticInputGate
import Source3.KeygenDecodeStaticCounterOps

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The COMPLETE actual prefix-refill loop body, including its availability
   check, physical read, v++ and db_len +=8. No successful decoder premise. -/
namespace FT1536.Source3.KeygenDecodeStaticRefill
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenDecodeStaticCertified KeygenDecodeStaticReady

def afterRead (s : State) (v : Nat) (db : BitVec 32) (byte : BitVec 8) : State :=
  withLocals s (localSet (KeygenDecodeStaticRead.next v s.locals) "db".toList .uint32
    (some (.uint32 ((db <<< 8)+byte.setWidth 32))))
def afterRefill (s : State) (v p : Nat) (db : BitVec 32) (byte : BitVec 8) : State :=
  withLocals (afterRead s v db byte) (localSet (afterRead s v db byte).locals "db_len".toList .uint32
    (some (.uint32 (BitVec.ofNat 32 (p+8)))))

theorem body (args : Args) (s : State) (src dst atByte : ArrayPointer) (v p : Nat)
    (db : BitVec 32) (byte : BitVec 8) (available : v<args.len.toNat)
    (ready : Ready args src dst v p db s)
    (advance : PointerAdd src v atByte) (load : LoadByte s.heap atByte byte) :
    Checked args KeygenDecodeStaticBinding.node037 s (afterRefill s v p db byte) .normal ∧
      Ready args src dst (v+1) (p+8) ((db <<< 8)+byte.setWidth 32) (afterRefill s v p db byte) ∧
      (afterRefill s v p db byte).heap=s.heap := by
  have bound : v+1<2^64 := by
    have extent:=args.len.isLt
    omega
  let s1 := afterRead s v db byte
  let s2 := afterRefill s v p db byte
  have gate := KeygenDecodeStaticInputGate.source_prefix args s v available ready.cursor ready.context.length
  have read : Checked args KeygenDecodeStaticBinding.node031 s s1 .normal :=
    KeygenDecodeStaticRead.source_append args s v bound src atByte byte db ready.cursor ready.accumulator ready.context.buffer advance load
  have pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s1.locals :=
    (KeygenDecodeStaticCellFrame.exec_frame "db_len".toList args _ s s1 .normal read.run (by decide +kernel)).trans ready.pending
  have count : Checked args KeygenDecodeStaticBinding.node032 s1 s2 .normal := by
    have source := compound args s1 "db_len".toList .uint32 (.uint32 (BitVec.ofNat 32 p))
      .add .add (.number .i32 8) (.int32 8) (.uint32 (BitVec.ofNat 32 (p+8))) s1.locals
      (by decide +kernel) (by decide +kernel) pending rfl
      (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
      (.add _ _ _ (KeygenDecodeStaticCounterOps.plus_nat32 p 8 (by decide +kernel)))
    simpa only [KeygenDecodeWordOps.self32,KeygenDecodeStaticBinding.node032,afterRefill,s2,s1] using source
  have inside : Checked args KeygenDecodeStaticBinding.node036 s s2 .normal :=
    seq args _ _ s s s2 .normal gate
      (seq args _ _ s s1 s2 .normal read
        (seq args _ _ s1 s2 s2 .normal count (skip args s2)))
  have full : Checked args KeygenDecodeStaticBinding.node037 s s2 .normal := by
    have source := scope args KeygenDecodeStaticBinding.node036 s s2 .normal (by intro impossible; cases impossible) inside
    rw [empty_scope _ _ _ rfl] at source
    exact source
  have context := context_frame args src dst s s2 _ .normal full.run (by unfold Checks; decide +kernel) ready.context
  refine ⟨full,⟨context,?_,?_,?_⟩,rfl⟩
  · simp only [KeygenDecodeStaticRead.cursor,afterRefill,afterRead,withLocals,
      KeygenDecodeStaticRead.next,localSet,C99ScalarReference.set]
    rfl
  · simp only [Cell,afterRefill,withLocals,localSet,C99ScalarReference.set,ite_true]
  · simp only [Cell,afterRefill,afterRead,withLocals,localSet,C99ScalarReference.set]
    rfl

end FT1536.Source3.KeygenDecodeStaticRefill
