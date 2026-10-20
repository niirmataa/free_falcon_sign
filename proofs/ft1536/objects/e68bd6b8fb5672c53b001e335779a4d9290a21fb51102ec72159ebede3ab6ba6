import Source3.KeygenZintCore

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete scaled bigint leaves and typed call arguments. The backward
   pointer argument preserves C's (F+j)-off order and its intermediate
   one-past bound; it is not grouped into unsigned scalar j-off arithmetic. -/
namespace FT1536.Source3.KeygenZintScaled
open C99ArrayReference (State Name Param bindValue bindPointer Pointer)
open C99MemoryReference
open C99IntegerReference (Value)
open KeygenZintCall (Stmt)
open B20.C (Token)

inductive Kind where | add | sub
  deriving DecidableEq, Repr
def params : Kind → List Param
  | .add => [.pointer "x".toList,.scalar .uint64 "xlen".toList,
    .pointer "y".toList,.scalar .uint64 "ylen".toList,.scalar .int32 "k".toList,
    .scalar .uint32 "sch".toList,.scalar .uint32 "scl".toList]
  | .sub => [.pointer "x".toList,.scalar .uint64 "xlen".toList,
    .pointer "y".toList,.scalar .uint64 "ylen".toList,
    .scalar .uint32 "sch".toList,.scalar .uint32 "scl".toList]
def writable : List Name := ["x".toList]
def widths : KeygenWordExpr.Types := [("x".toList,4),("y".toList,4)]
def parsed : Kind → Nat → Option Stmt
  | .add,0 => KeygenZintCall.region widths [] 4338 4
  | .add,1 => KeygenZintCall.region widths [] 4342 7
  | .add,2 => KeygenZintCall.region widths [] 4349 32
  | .sub,0 => KeygenZintCall.region widths [] 4398 4
  | .sub,1 => KeygenZintCall.region widths [] 4402 7
  | .sub,2 => KeygenZintCall.region widths [] 4409 16
  | _,_ => none
def part (kind : Kind) (index : Nat) : Stmt := (parsed kind index).getD KeygenZintCall.skip
def code (kind : Kind) : Stmt := KeygenZintCall.chain [part kind 0,part kind 1,part kind 2]
def lines := KeygenLevelNtt.region
theorem add_header : lines 4333 5=["static void\n",
    "zint_add_scaled_mul_small(uint32_t *restrict x, size_t xlen,\n",
    "\tconst uint32_t *restrict y, size_t ylen, int32_t k,\n",
    "\tuint32_t sch, uint32_t scl)\n","{\n"] := by decide
theorem add_close : Pinned.keygenLines[4380]?=some "}\n" := by decide
theorem sub_header : lines 4394 4=["static void\n",
    "zint_sub_scaled(uint32_t *restrict x, size_t xlen,\n",
    "\tconst uint32_t *restrict y, size_t ylen, uint32_t sch, uint32_t scl)\n","{\n"] := by decide
theorem sub_close : Pinned.keygenLines[4424]?=some "}\n" := by decide
theorem add_partition : lines 4338 43=lines 4338 4 ++ lines 4342 7 ++ lines 4349 32 := by decide
theorem sub_partition : lines 4398 27=lines 4398 4 ++ lines 4402 7 ++ lines 4409 16 := by decide
def audit (kind : Kind) (index : Nat) : Option Bool := (parsed kind index).map (KeygenZintCall.only writable)
theorem add_audit0 : audit .add 0=some true := by decide
theorem add_audit1 : audit .add 1=some true := by decide
theorem add_audit2 : audit .add 2=some true := by decide
theorem sub_audit0 : audit .sub 0=some true := by decide
theorem sub_audit1 : audit .sub 1=some true := by decide
theorem sub_audit2 : audit .sub 2=some true := by decide
theorem add_bitcast : (parsed .add 2).map KeygenZintCall.bitcastCount=some 1 := by decide
theorem parsed_part (kind : Kind) (index : Nat) (h : audit kind index=some true) :
    parsed kind index=some (part kind index) := by
  cases hp : parsed kind index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (kind : Kind) (index : Nat) (h : audit kind index=some true) :
    KeygenZintCall.only writable (part kind index)=true := by
  have parsed := parsed_part kind index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h
theorem code_checked (kind : Kind) : KeygenZintCall.only writable (code kind)=true := by
  show KeygenZintCall.only writable (.seq (part kind 0) (.seq (part kind 1)
    (.seq (part kind 2) KeygenZintCall.skip)))=true
  rw [KeygenZintCore.only_seq,KeygenZintCore.only_seq,KeygenZintCore.only_seq,KeygenZintCore.only_skip]
  cases kind with
  | add => rw [part_checked .add 0 add_audit0,part_checked .add 1 add_audit1,part_checked .add 2 add_audit2]; decide
  | sub => rw [part_checked .sub 0 sub_audit0,part_checked .sub 1 sub_audit1,part_checked .sub 2 sub_audit2]; decide

inductive Arg where
  | ordinary (value : C99ArrayReference.Arg)
  | backward (name : Name) (forward back : CLogic.Expr)
  deriving DecidableEq, Repr
/- Erasure is used only by the source-name footprint checker. Execution
   always retains both pointer operations and their object bounds. -/
def footprint : Arg → C99ArrayReference.Arg
  | .ordinary arg => arg
  | .backward name forward _ => .pointer name forward
def allowed (names : List Name) (ps : List Param) (args : List Arg) : Bool :=
  C99PointerFootprint.arguments names writable ps (args.map footprint)
def Blocks (s : State) (names : List Name) (block : Nat) : Prop :=
  ∀ name∈names, ∀ p, s.arrays name=some p → block≠p.block
def TableBlocks (s : State) (block : Nat) : Prop :=
  ∀ name p, s.tables name=some p → block≠p.block
theorem pointer_block (s : State) (names : List Name) (name : Name) (index : CLogic.Expr)
    (p : ArrayPointer) (source : Pointer s name index p) (block : Nat)
    (member : name∈names) (separated : Blocks s names block) : block≠p.block := by
  cases source with
  | add root _ value binding evaluated nonnegative within =>
    cases within
    exact separated name member root binding

inductive Bind (caller : State) : List Param → List Arg → State → Prop where
  | nil : Bind caller [] [] ⟨caller.heap,caller.globals,caller.tables,caller.globals,caller.tables⟩
  | scalar (ty : C99IntegerReference.Ty) (name : Name) (e : CLogic.Expr)
      (ps : List Param) (args : List Arg) (out : State) (v : Value)
      (value : C99ArrayReference.scalar caller e v) (rest : Bind caller ps args out) :
      Bind caller (.scalar ty name::ps) (.ordinary (.scalar e)::args) (bindValue out name ty v)
  | pointer (name src : Name) (index : CLogic.Expr) (p : ArrayPointer)
      (ps : List Param) (args : List Arg) (out : State)
      (value : Pointer caller src index p) (rest : Bind caller ps args out) :
      Bind caller (.pointer name::ps) (.ordinary (.pointer src index)::args) (bindPointer out name p)
  | backward (name src : Name) (forward back : CLogic.Expr) (p : ArrayPointer) (v : Value)
      (ps : List Param) (args : List Arg) (out : State)
      (advance : Pointer caller src forward p) (distance : C99ArrayReference.scalar caller back v)
      (nonnegative : 0≤v.integer) (within : v.integer.toNat≤p.index)
      (rest : Bind caller ps args out) :
      Bind caller (.pointer name::ps) (.backward src forward back::args)
        (bindPointer out name {p with index := p.index-v.integer.toNat})
theorem bind_heap (before : State) (ps : List Param) (args : List Arg) (entry : State)
    (source : Bind before ps args entry) : entry.heap=before.heap := by
  induction source with
  | nil => rfl
  | scalar _ _ _ _ _ _ _ _ _ ih => exact ih
  | pointer _ _ _ _ _ _ _ _ _ ih => exact ih
  | backward _ _ _ _ _ _ _ _ _ _ _ _ _ _ ih => exact ih
theorem bind_blocks (before : State) (ps : List Param) (args : List Arg) (entry : State)
    (source : Bind before ps args entry) (names : List Name) (block : Nat)
    (checked : allowed names ps args=true) (separated : Blocks before names block)
    (tables : TableBlocks before block) : Blocks entry writable block ∧ entry.tables=before.tables := by
  induction source with
  | nil => exact ⟨fun n _ p hp => tables n p hp,rfl⟩
  | scalar ty name e ps args out v value rest ih => exact ih checked
  | pointer name src index p ps args out value rest ih =>
    obtain ⟨hc,hr⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨ho,ht⟩ := ih hr
    refine ⟨?_,ht⟩
    intro n hn q hq
    by_cases he : n=name
    · subst n
      have hm : writable.contains name=true := List.contains_iff_mem.mpr hn
      have hs : src∈names := List.contains_iff_mem.mp (by rw [hm] at hc; exact hc)
      have hpq : p=q := Option.some.inj (by simpa [bindPointer] using hq)
      subst q
      exact pointer_block before names src index p value block hs separated
    · exact ho n hn q (by simpa [bindPointer,he] using hq)
  | backward name src forward back p v ps args out advance distance nonnegative within rest ih =>
    obtain ⟨hc,hr⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨ho,ht⟩ := ih hr
    refine ⟨?_,ht⟩
    intro n hn q hq
    by_cases he : n=name
    · subst n
      have hm : writable.contains name=true := List.contains_iff_mem.mpr hn
      have hs : src∈names := List.contains_iff_mem.mp (by rw [hm] at hc; exact hc)
      have hpq : {p with index := p.index-v.integer.toNat}=q :=
        Option.some.inj (by simpa [bindPointer] using hq)
      subst q
      exact pointer_block before names src forward p advance block hs separated
    · exact ho n hn q (by simpa [bindPointer,he] using hq)

def Call (kind : Kind) (before : State) (args : List Arg) (after : State) : Prop :=
  ∃ entry out, Bind before (params kind) args entry ∧ KeygenZintCall.Exec (code kind) entry out ∧
    C99ProcedureReference.ReturnValue none out.flow none ∧ after={before with heap := out.state.heap}
theorem call_frame (kind : Kind) (before after : State) (args : List Arg) (names : List Name)
    (source : Call kind before args after) (block offset : Nat)
    (checked : allowed names (params kind) args=true) (separated : Blocks before names block)
    (tables : TableBlocks before block) :
    Blocks after names block ∧ after.tables=before.tables ∧
      after.heap.bytes block offset=before.heap.bytes block offset := by
  obtain ⟨entry,out,binding,execution,returned,rfl⟩ := source
  obtain ⟨ho,ht⟩ := bind_blocks before (params kind) args entry binding names block checked separated tables
  have outside : C99ArrayFrame.Outside entry writable block offset :=
    fun n hn p hp => Or.inl (ho n hn p hp)
  have tm : C99PointerFootprint.TablesOutside entry block offset := by
    intro n p hp
    rw [ht] at hp
    exact Or.inl (tables n p hp)
  have keep := (KeygenZintCall.body_frame KeygenZintCore.code_checked (code kind) entry out execution
    writable (code_checked kind) block offset outside tm).2.2
  rw [bind_heap before (params kind) args entry binding] at keep
  exact ⟨separated,rfl,keep⟩

def argument : Param → List Token → Option (Arg×List Token)
  | .pointer _,name::['+']::forward::['-']::back::rest =>
    if forward.all B20.C.wordChar && back.all B20.C.wordChar &&
        !B20.C.digit forward.head! && !B20.C.digit back.head! then
      some (.backward name (.var forward) (.var back),rest)
    else none
  | param,rest => do
    let (arg,rest) ← C99ProcedureParser.argument param rest
    pure (.ordinary arg,rest)
def arguments : List Param → List Token → Option (List Arg×List Token)
  | [],[')']::rest => some ([],rest)
  | [p],rest => do
    let (arg,rest) ← argument p rest
    match rest with
    | [')']::rest => pure ([arg],rest)
    | _ => none
  | p::q::ps,rest => do
    let (arg,rest) ← argument p rest
    match rest with
    | [',']::rest => do
      let (args,rest) ← arguments (q::ps) rest
      pure (arg::args,rest)
    | _ => none
  | _,_ => none

end FT1536.Source3.KeygenZintScaled
