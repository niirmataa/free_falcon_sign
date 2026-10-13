import Source3.KeygenDecodeStaticPaddingBits
import Source3.KeygenDecodeStaticOuterCounter

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual final padding guard and return v. Zero residue is derived
   from the source stream before this local source block is invoked. -/
namespace FT1536.Source3.KeygenDecodeStaticPaddingReturn
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeCalculation KeygenDecodeWordOps

def maskExpr : Expr := .binary .sub (.binary .shl (.number .u32 1) (.variable "db_len".toList)) (.number .u32 1)

theorem mask_calculation (args : Args) (s : State) (p : Nat) (small : p<8)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals) :
    Computes args s.heap s.buf s.locals maskExpr (.uint32 (KeygenDecodeStaticPaddingBits.mask p)) :=
  .binary _ _ _ _ _ _
    (.binary _ _ _ _ _ _ (.number .u32 1 (.uint32 1) (by decide +kernel))
      (.scalar _ _ _ (by unfold Ordinary; decide +kernel) pending)
      (.shl _ _ _ (KeygenDecodeStaticWordOps.left_uint32 1 p (by omega))))
    (.number .u32 1 (.uint32 1) (by decide +kernel)) (.sub _ _ _ (sub32 _ _))

theorem neq_zero : C99IntegerReference.CompareExec .ne (.uint32 0) (.int32 0) (.int32 0) := by
  have primitive := C99IntegerReference.CompareExec.step .ne (.uint32 0) (.int32 0) .uint32 rfl
    (.uint32 0) (.uint32 0) rfl rfl
  convert primitive using 1; decide +kernel

theorem guard_calculation (args : Args) (s : State) (p : Nat) (db : BitVec 32) (small : p<8)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals)
    (acc : Cell "db" .uint32 (.uint32 db) s.locals) (zero : KeygenCodecStaticSuffix.low db p=0) :
    Computes args s.heap s.buf s.locals KeygenDecodeStaticBinding.guard090 (.int32 0) := by
  have masked : Computes args s.heap s.buf s.locals (.binary .band (.variable "db".toList) maskExpr)
      (.uint32 (db &&& KeygenDecodeStaticPaddingBits.mask p)) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) acc)
      (mask_calculation args s p small pending) (.band _ _ _ (and32 _ _))
  rw [KeygenDecodeStaticPaddingBits.masked_zero p db small zero] at masked
  exact .binary _ _ _ _ _ _ masked (.number .i32 0 (.int32 0) (by decide +kernel)) (.ne _ _ _ neq_zero)

theorem source_guard (args : Args) (s : State) (p : Nat) (db : BitVec 32) (small : p<8)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals)
    (acc : Cell "db" .uint32 (.uint32 db) s.locals) (zero : KeygenCodecStaticSuffix.low db p=0) :
    Checked args KeygenDecodeStaticBinding.node090 s s .normal := by
  have same : withLocals s s.locals=s := by cases s; rfl
  exact branch_false args KeygenDecodeStaticBinding.guard090 KeygenDecodeStaticBinding.node089 .skip s s .normal
    (.int32 0) s.locals (.pure _ _ _ (guard_calculation args s p db small pending acc zero))
    (by decide +kernel) (by rw [same]; exact skip args s)

theorem source_return (args : Args) (s : State) (v : Nat)
    (cursor : KeygenDecodeStaticRead.cursor v s.locals) :
    Checked args KeygenDecodeStaticBinding.node091 s s (.returned (BitVec.ofNat 64 v)) := by
  have calculation : Computes args s.heap s.buf s.locals (.variable "v".toList) (.uint64 (BitVec.ofNat 64 v)) :=
    .scalar _ _ _ (by unfold Ordinary; decide +kernel) cursor
  have source := ret args s (.variable "v".toList) (.uint64 (BitVec.ofNat 64 v)) s.locals (.pure _ _ _ calculation)
  have same : withLocals s s.locals=s := by cases s; rfl
  simpa only [KeygenDecodeStaticBinding.node091,same,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq] using source

theorem complete (args : Args) (s : State) (v p : Nat) (db : BitVec 32) (small : p<8)
    (cursor : KeygenDecodeStaticRead.cursor v s.locals)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals)
    (acc : Cell "db" .uint32 (.uint32 db) s.locals) (zero : KeygenCodecStaticSuffix.low db p=0) :
    Checked args KeygenDecodeStaticBinding.node095 s s (.returned (BitVec.ofNat 64 v)) := by
  have guard := source_guard args s p db small pending acc zero
  have returned := source_return args s v cursor
  have tailRun : Checked args KeygenDecodeStaticBinding.node093 s s (.returned (BitVec.ofNat 64 v)) :=
    seq_return args _ _ s s _ returned
  have inside : Checked args KeygenDecodeStaticBinding.node094 s s (.returned (BitVec.ofNat 64 v)) :=
    seq args _ _ s s s _ guard tailRun
  have source := scope args KeygenDecodeStaticBinding.node094 s s _ (by intro impossible; cases impossible) inside
  rw [empty_scope _ _ _ rfl] at source
  exact source

end FT1536.Source3.KeygenDecodeStaticPaddingReturn
