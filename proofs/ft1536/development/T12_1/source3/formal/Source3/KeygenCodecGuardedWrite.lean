import Source3.KeygenCodecExecution
import Source3.KeygenCodecNoneLength

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- B1.08 local capacity seam: an evaluated failing u>=max_out_len test
   followed by its actual byte store yields an exact capacity-window frame
   for that store. The guard and store are execution legs, not a supplied
   inequality, encoded length, result or heap frame. The complete three guarded blocks are derived below, including return0.
   Extracting/folding them over a full STATIC body remains a separate step. -/
namespace FT1536.Source3.KeygenCodecGuardedWrite
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

structure Window (dst : ArrayPointer) (capacity : Nat) (before after : Memory) : Prop where
  sizes : after.size=before.size
  writable : after.writable=before.writable
  bytes : ∀ block offset, block≠dst.block ∨ offset<dst.offset ∨ dst.offset+capacity≤offset →
    after.bytes block offset=before.bytes block offset

theorem byteOff_offset (p : ArrayPointer) (u : Nat) : (byteOff p u).offset=p.offset+u := by
  simp only [byteOff,ArrayPointer.offset]
  omega

theorem store_window (dst : ArrayPointer) (capacity offset : Nat) (before after : Memory) (value : BitVec 8)
    (inside : offset<capacity) (store : StoreByte before (byteOff dst offset) value after) :
    Window dst capacity before after := by
  refine ⟨store.2.2.2.1,store.2.2.2.2.1,?_⟩
  intro block index outside
  apply store.2.2.2.2.2.2 block index
  rcases outside with foreign | before | after
  · exact Or.inl foreign
  · right; rw [byteOff_offset]; omega
  · right; rw [byteOff_offset]; omega

theorem u_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (before after : Locals) (result : Value) (u : BitVec 64)
    (cell : before.scalars "u".toList=some (.uint64,some (.uint64 u)))
    (evaluated : Eval args heap buf (.variable "u".toList) before result after) :
    result=.integer (.uint64 u) ∧ after=before := by
  cases evaluated; simp_all

theorem capacity_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (before after : Locals) (result : Value)
    (cell : before.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity)))
    (evaluated : Eval args heap buf (.variable "max_out_len".toList) before result after) :
    result=.integer (.uint64 args.capacity) ∧ after=before := by
  cases evaluated; simp_all

def test : Expr := .binary .ge (.variable "u".toList) (.variable "max_out_len".toList)
def reject : Stmt := .scope (.seq (.ret (.number .i32 0)) .skip)
def guarded (rhs : Expr) : Stmt :=
  .seq (.branch test reject .skip) (.seq (.write (.index (.variable "buf".toList) (.variable "u".toList)) .set rhs) .skip)

theorem first_site_source : KeygenCodecStaticBinding.node051=guarded
    (.cast .byte (.binary .shr (.variable "acc".toList) (.variable "acc_len".toList))) := rfl
theorem unary_site_source : KeygenCodecStaticBinding.node071=guarded
    (.cast .byte (.variable "acc".toList)) := rfl
theorem padding_site_source : KeygenCodecStaticBinding.node111=guarded
    (.cast .byte (.binary .shl (.variable "acc".toList) (.binary .sub (.number .i32 8) (.variable "acc_len".toList)))) := rfl

/-- The strict write bound is DERIVED from the actual typed guard. The
    equality of locals accounts for expression effects rather than
    assuming that a test has no side effects in general. -/
theorem guard_false_bound (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (before after : Locals) (result : Value) (u : BitVec 64)
    (uCell : before.scalars "u".toList=some (.uint64,some (.uint64 u)))
    (capacityCell : before.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity)))
    (evaluated : Eval args heap buf test before result after) (falseTest : truth result=false) :
    u.toNat<args.capacity.toNat ∧ after=before := by
  cases evaluated with
  | binary op a b before middle after x y z first second operation =>
    obtain ⟨hx,hm⟩ := u_eval args heap buf before middle x u uCell first
    subst x
    subst middle
    obtain ⟨hy,ht⟩ := capacity_eval args heap buf before after y capacityCell second
    subst y
    cases operation with
    | ge x y z compared =>
      cases compared
      simp_all [truth,C99IntegerReference.usual,C99IntegerReference.promote,
        C99IntegerReference.convert,C99IntegerReference.Value.type,C99IntegerReference.Value.integer,C99IntegerReference.compare]
      by_cases comparison : args.capacity.toNat≤u.toNat
      · simp [comparison] at falseTest
      · omega

theorem write_after_guard (args : Args) (s t : State) (locals : Locals) (value : Value)
    (u : BitVec 64) (dst : ArrayPointer) (rhs : Expr)
    (uCell : s.locals.scalars "u".toList=some (.uint64,some (.uint64 u)))
    (capacityCell : s.locals.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity)))
    (buffer : s.buf=some (some dst))
    (guard : Eval args s.heap s.buf test s.locals value locals) (falseTest : truth value=false)
    (source : Exec args (.write (.index (.variable "buf".toList) (.variable "u".toList)) .set rhs)
      (withLocals s locals) t .normal) : Window dst args.capacity.toNat s.heap t.heap := by
  obtain ⟨inside,sameLocals⟩ := guard_false_bound args s.heap s.buf s.locals locals value u uCell capacityCell guard falseTest
  subst locals
  cases source with
  | store args start index rhs m last ptr offset word after held indexValue nonnegative rhsValue write =>
    have pointer : ptr=dst := by simpa using held.symm.trans buffer
    subst ptr
    obtain ⟨same,_⟩ := u_eval args s.heap s.buf s.locals m (.integer offset) u uCell indexValue
    have integer : offset=.uint64 u := Value.integer.inj same
    subst offset
    exact store_window dst args.capacity.toNat u.toNat s.heap after (BitVec.ofInt 8 word.integer) inside write

theorem guard_locals (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (before after : Locals) (result : Value) (u : BitVec 64)
    (uCell : before.scalars "u".toList=some (.uint64,some (.uint64 u)))
    (capacityCell : before.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity)))
    (evaluated : Eval args heap buf test before result after) : after=before := by
  cases evaluated with
  | binary op a b before middle after x y z first second operation =>
    obtain ⟨_,hm⟩ := u_eval args heap buf before middle x u uCell first
    subst middle
    exact (capacity_eval args heap buf before after y capacityCell second).2

theorem reject_state (args : Args) (s t : State) (flow : Flow) (source : Exec args reject s t flow) :
    t=s ∧ flow=.returned 0 := by
  cases source with
  | scope args a s middle flow noBufShadow inside =>
    cases inside with
    | seq args a b s m middle flow first second => cases first
    | seqReturn args a b s middle ret first =>
      cases first with
      | ret args s e value locals evaluated =>
        obtain ⟨equal,sameLocals⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 0
          (.int32 0) s.locals locals (.integer value) (by decide +kernel) evaluated
        have integer : value=.int32 0 := Value.integer.inj equal
        subst value
        subst locals
        exact ⟨by cases s; rfl,rfl⟩

/-- The actual guard statement either exits without a write or reaches
    the following statement with a derived strict capacity inequality. -/
theorem guard_step (args : Args) (s t : State) (flow : Flow) (u : BitVec 64)
    (uCell : s.locals.scalars "u".toList=some (.uint64,some (.uint64 u)))
    (capacityCell : s.locals.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity)))
    (source : Exec args (.branch test reject .skip) s t flow) :
    t=s ∧ (flow=.normal → u.toNat<args.capacity.toNat) := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    have sameLocals := guard_locals args s.heap s.buf s.locals locals value u uCell capacityCell evaluated
    subst locals
    obtain ⟨same,returned⟩ := reject_state args _ t flow selected
    refine ⟨same,?_⟩
    intro normal
    rw [normal] at returned
    cases returned
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    obtain ⟨inside,sameLocals⟩ := guard_false_bound args s.heap s.buf s.locals locals value u uCell capacityCell evaluated no
    subst locals
    cases selected
    exact ⟨rfl,fun _ => inside⟩

/-- A full execution of any of the three fixed guarded write blocks has
    this exact window frame, including its return0 edge. The bound and
    frame are conclusions of the source guard/store execution. -/
theorem guarded_window (args : Args) (s t : State) (flow : Flow) (u : BitVec 64)
    (dst : ArrayPointer) (rhs : Expr)
    (uCell : s.locals.scalars "u".toList=some (.uint64,some (.uint64 u)))
    (capacityCell : s.locals.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity)))
    (buffer : s.buf=some (some dst)) (source : Exec args (guarded rhs) s t flow) :
    Window dst args.capacity.toNat s.heap t.heap := by
  cases source with
  | seq args a b s middle t flow first second =>
    obtain ⟨same,inside⟩ := guard_step args s middle .normal u uCell capacityCell first
    subst middle
    cases second with
    | seq args a b s middle t flow first second =>
      cases first with
      | store args s index rhs m last ptr offset word after held indexValue nonnegative rhsValue write =>
        have pointer : ptr=dst := by simpa using held.symm.trans buffer
        subst ptr
        obtain ⟨same,_⟩ := u_eval args s.heap s.buf s.locals m (.integer offset) u uCell indexValue
        have integer : offset=.uint64 u := Value.integer.inj same
        subst offset
        cases second
        exact store_window dst args.capacity.toNat u.toNat s.heap after (BitVec.ofInt 8 word.integer) (inside rfl) write
    | seqReturn args a b s t value first => cases first
  | seqReturn args a b s t value first =>
    obtain ⟨same,_⟩ := guard_step args s t (.returned value) u uCell capacityCell first
    subst t
    exact ⟨rfl,rfl,fun _ _ _ => rfl⟩

end FT1536.Source3.KeygenCodecGuardedWrite
