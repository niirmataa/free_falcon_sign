import Source3.KeygenCodecStaticStores

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The exact guarded-write event shared by all three STATIC sites.
   Its byte is calculated from the actual RHS. Rejection emits no byte. -/
namespace FT1536.Source3.KeygenCodecStaticWriteStep
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation KeygenCodecStaticByte

def Cursor (u : BitVec 64) (s : State) : Prop :=
  s.locals.scalars "u".toList=some (.uint64,some (.uint64 u))
def Capacity (args : Args) (s : State) : Prop :=
  s.locals.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity))

def Written (args : Args) (s t : State) (u : BitVec 64) (word : BitVec 32) : Prop :=
  u.toNat<args.capacity.toNat ∧ t.locals=s.locals ∧ t.buf=s.buf ∧
  ∃ dst : ArrayPointer, s.buf=some (some dst) ∧
    StoreByte s.heap (byteOff dst u.toNat) (byte word) t.heap

def Rejected (args : Args) (s t : State) (u : BitVec 64) (flow : Flow) : Prop :=
  flow=.returned 0 ∧ args.capacity.toNat≤u.toNat ∧ t=s

def Outcome (args : Args) (s t : State) (u : BitVec 64) (word : BitVec 32) (flow : Flow) : Prop :=
  (flow=.normal ∧ Written args s t u word) ∨ Rejected args s t u flow

theorem guard_true_bound (args : Args) (s : State) (l : Locals) (value : Value) (u : BitVec 64)
    (cursor : Cursor u s) (capacity : Capacity args s)
    (source : Eval args s.heap s.buf KeygenCodecGuardedWrite.test s.locals value l)
    (yes : truth value=true) : args.capacity.toNat≤u.toNat := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨rfl,rfl⟩ := KeygenCodecGuardedWrite.u_eval args s.heap s.buf s.locals middle x u cursor first
    obtain ⟨rfl,_⟩ := KeygenCodecGuardedWrite.capacity_eval args s.heap s.buf s.locals l y capacity second
    cases operation with
    | ge x y z compared =>
      cases compared with
      | step ty ht a b ha hb =>
        subst ty
        subst a
        subst b
        by_contra no
        simp [truth,C99IntegerReference.usual,C99IntegerReference.promote,
          C99IntegerReference.convert,C99IntegerReference.Value.type,
          C99IntegerReference.Value.integer,C99IntegerReference.compare,no] at yes

theorem guard_outcome (args : Args) (s t : State) (flow : Flow) (u : BitVec 64)
    (cursor : Cursor u s) (capacity : Capacity args s)
    (source : Exec args (.branch KeygenCodecGuardedWrite.test KeygenCodecGuardedWrite.reject .skip) s t flow) :
    (flow=.normal ∧ t=s ∧ u.toNat<args.capacity.toNat) ∨ Rejected args s t u flow := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    have bound := guard_true_bound args s locals value u cursor capacity evaluated yes
    have same := KeygenCodecGuardedWrite.guard_locals args s.heap s.buf s.locals locals value u cursor capacity evaluated
    subst locals
    obtain ⟨same,returned⟩ := KeygenCodecGuardedWrite.reject_state args _ t flow selected
    exact Or.inr ⟨returned,bound,same⟩
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    obtain ⟨bound,same⟩ := KeygenCodecGuardedWrite.guard_false_bound args s.heap s.buf s.locals locals value u cursor capacity evaluated no
    subst locals
    cases selected
    exact Or.inl ⟨rfl,rfl,bound⟩

theorem calculated_store (args : Args) (s t : State) (flow : Flow) (rhs : Expr)
    (u : BitVec 64) (word : BitVec 32) (cursor : Cursor u s)
    (calculation : Computes s.locals rhs (promoted word))
    (source : Exec args (.write (.index (.variable "buf".toList) (.variable "u".toList)) .set rhs) s t flow) :
    flow=.normal ∧ t.locals=s.locals ∧ t.buf=s.buf ∧
    ∃ dst : ArrayPointer, s.buf=some (some dst) ∧
      StoreByte s.heap (byteOff dst u.toNat) (byte word) t.heap := by
  cases source with
  | store args s index rhs middle last dst offset value after buffer indexValue nonnegative rhsValue write =>
    obtain ⟨same,lastIndex⟩ := KeygenCodecGuardedWrite.u_eval args s.heap s.buf s.locals middle (.integer offset) u cursor indexValue
    cases same
    subst middle
    obtain ⟨same,lastRhs⟩ := computes_eval args s.heap s.buf s.locals rhs _ calculation last (.integer value) rhsValue
    cases same
    subst last
    rw [byte_again] at write
    exact ⟨rfl,rfl,rfl,dst,buffer,by simpa only [C99IntegerReference.Value.integer,Int.toNat_natCast] using write⟩

theorem guarded_outcome (args : Args) (s t : State) (flow : Flow) (rhs : Expr)
    (u : BitVec 64) (word : BitVec 32) (cursor : Cursor u s) (capacity : Capacity args s)
    (calculation : Computes s.locals rhs (promoted word))
    (source : Exec args (KeygenCodecGuardedWrite.guarded rhs) s t flow) : Outcome args s t u word flow := by
  cases source with
  | seq args a b s middle t flow first second =>
    rcases guard_outcome args s middle .normal u cursor capacity first with ⟨_,same,bound⟩ | rejected
    · subst middle
      cases second with
      | seq args a b s middle t flow first second =>
        obtain ⟨normal,locals,buf,store⟩ := calculated_store args s middle .normal rhs u word cursor calculation first
        cases second
        exact Or.inl ⟨rfl,bound,locals,buf,store⟩
      | seqReturn args a b s t value first => cases first
    · cases rejected.1
  | seqReturn args a b s t value first =>
    rcases guard_outcome args s t (.returned value) u cursor capacity first with ⟨normal,_,_⟩ | rejected
    · cases normal
    · exact Or.inr rejected

theorem written_trace (args : Args) (s t : State) (u : BitVec 64) (word : BitVec 32)
    (written : Written args s t u word) :
    ∃ dst : ArrayPointer, s.buf=some (some dst) ∧
      KeygenCodecByteHistory.Trace s.heap t.heap [(byteOff dst u.toNat,byte word)] := by
  obtain ⟨_,_,_,dst,buffer,store⟩ := written
  exact ⟨dst,buffer,.step _ _ _ _ _ _ store (.nil _)⟩

end FT1536.Source3.KeygenCodecStaticWriteStep
