import Source3.KeygenZintTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Operational polynomial extraction/conversion. The nested store call
   executes zint_get_top and the pinned FPEMU fpr_scaled body, then writes
   the resulting eight bytes. No real-number conversion contract is used. -/
namespace FT1536.Source3.KeygenZintPoly
open C99ArrayReference (State Name Param Arg Pointer restoreScope)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenWordExpr (Expr)
open B20.C (Token)

inductive Kind where
  | maxBitlength | bigToFp
  deriving DecidableEq, Repr
def params : Kind → List Param
  | .maxBitlength => [.pointer "f".toList,.scalar .uint64 "flen".toList,
    .scalar .uint64 "fstride".toList,.scalar .uint32 "logn".toList,.scalar .uint32 "ter".toList]
  | .bigToFp => [.pointer "d".toList,.pointer "f".toList,.scalar .uint64 "flen".toList,
    .scalar .uint64 "fstride".toList,.scalar .uint32 "logn".toList,.scalar .uint32 "ter".toList,
    .scalar .uint32 "maxbl".toList,.scalar .uint32 "scale".toList]
def result : Kind → Option C99IntegerReference.Ty
  | .maxBitlength => some .uint32
  | .bigToFp => none
/- f is a read-only walk pointer, but belongs to the footprint name set:
   the generic provenance checker follows its for-clause advancement. -/
def writable : Kind → List Name
  | .maxBitlength => ["f".toList]
  | .bigToFp => ["d".toList,"f".toList]
def widths : Kind → KeygenWordExpr.Types
  | .maxBitlength => [("f".toList,4)]
  | .bigToFp => [("d".toList,8),("f".toList,4)]

inductive Stmt where
  | base (code : KeygenZintTop.Stmt)
  | scaledStore (array : Name) (index : CLogic.Expr) (args : List Arg) (exponent : Expr)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : Expr) (yes no : Stmt)
  | loop (condition : Expr) (body increment : Stmt)
  deriving DecidableEq, Repr
def core (code : KeygenZintCall.Stmt) : Stmt := .base (.core code)
def skip : Stmt := core KeygenZintCall.skip
def chain : List Stmt → Stmt
  | [] => skip
  | a::rest => .seq a (chain rest)

inductive Exec : Stmt → State → Result → Prop where
  | base (code : KeygenZintTop.Stmt) (before : State) (out : Result)
      (source : KeygenZintTop.Exec code before out) : Exec (.base code) before out
  | scaledStore (array : Name) (index : CLogic.Expr) (args : List Arg) (exponent : Expr)
      (before middle : State) (after : Memory) (p : ArrayPointer) (z e v : Value)
      (top : KeygenZintTop.Call before args middle z)
      (scale : KeygenWordExpr.Eval middle exponent e)
      (convert : FprPrefixCalls.calls "fpr_scaled".toList [z,e] v)
      (address : Pointer middle array index p)
      (write : Store64 middle.heap p (BitVec.ofInt 64 v.integer) after) :
      Exec (.scaledStore array index args exponent) before ⟨{middle with heap := after},.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (first : Exec a before ⟨middle,.normal⟩) (second : Exec b middle out) :
      Exec (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result)
      (first : Exec a before out) (exit : out.flow≠.normal) : Exec (.seq a b) before out
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (out : Result)
      (source : Exec body before out) :
      Exec (.scope locals pointers body) before ⟨restoreScope before out.state locals pointers,out.flow⟩
  | branchTrue (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (nonzero : v.integer≠0)
      (source : Exec yes before out) : Exec (.branch condition yes no) before out
  | branchFalse (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (zero : v.integer=0)
      (source : Exec no before out) : Exec (.branch condition yes no) before out
  | loopFalse (condition : Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (zero : v.integer=0) :
      Exec (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : Expr) (body increment : Stmt) (before middle next : State)
      (out : Result) (v : Value) (guard : KeygenWordExpr.Eval before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨middle,.normal⟩)
      (update : Exec increment middle ⟨next,.normal⟩)
      (rest : Exec (.loop condition body increment) next out) :
      Exec (.loop condition body increment) before out
  | loopReturn (condition : Expr) (body increment : Stmt) (before after : State)
      (v : Value) (ret : Option Value) (guard : KeygenWordExpr.Eval before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨after,.returned ret⟩) :
      Exec (.loop condition body increment) before ⟨after,.returned ret⟩

def declarations : Stmt → List Name×List Name
  | .base (.core code) => KeygenZintCall.declarations code
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])
def scaled (types : KeygenWordExpr.Types) (ptrs : List Name) :
    List Token → Option (Stmt×List Name×List Token)
  | array::['[']::rest => do
    if KeygenSearchParser.width types array≠some 8 then none else do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [']']::['=']::['f','p','r','_','s','c','a','l','e','d']::['(']::
          ['z','i','n','t','_','g','e','t','_','t','o','p']::['(']::rest => do
        let (args,rest) ← C99ProcedureParser.arguments KeygenZintTop.params rest
        match rest with
        | [',']::rest => do
          let (exponent,rest) ← KeygenWordExpr.expression (KeygenZintCall.env types ptrs) rest
          match rest with
          | [')']::[';']::rest => pure (.scaledStore array index args exponent,ptrs,rest)
          | _ => none
        | _ => none
      | _ => none
  | _ => none
mutual
  def statement (types : KeygenWordExpr.Types) (ptrs : List Name) :
      Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (code,_,rest) ← body types ptrs fuel rest
      let names := declarations code
      pure (.scope names.1 names.2 code,ptrs,rest)
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← KeygenZintCall.clauses types ptrs [';'] 16 rest
      let (condition,rest) ← KeygenWordExpr.expression (KeygenZintCall.env types ptrs) rest
      match rest with
      | [';']::rest => do
        let (update,rest) ← KeygenZintCall.clauses types ptrs [')'] 16 rest
        let (inner,_,rest) ← statement types ptrs fuel rest
        pure (.seq (core initial) (.loop condition inner (core update)),ptrs,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← KeygenWordExpr.expression (KeygenZintCall.env types ptrs) rest
      match rest with
      | [')']::rest => do
        let (yes,_,rest) ← statement types ptrs fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,_,rest) ← statement types ptrs fuel rest
          pure (.branch condition yes no,ptrs,rest)
        | _ => pure (.branch condition yes skip,ptrs,rest)
      | _ => none
    | _+1,rest =>
      match scaled types ptrs rest with
      | some code => some code
      | none => do
        let (code,ptrs,rest) ← KeygenZintTop.statement types ptrs rest
        pure (.base code,ptrs,rest)
  def body (types : KeygenWordExpr.Types) (ptrs : List Name) :
      Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (skip,ptrs,rest)
    | fuel+1,rest => do
      let (first,next,rest) ← statement types ptrs fuel rest
      let (tail,final,rest) ← body types next fuel rest
      pure (.seq first tail,final,rest)
end
def region (kind : Kind) (start count : Nat) : Option Stmt := do
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← KeygenZintTop.tokens text
  let (code,_,rest) ← body (widths kind) ((widths kind).map Prod.fst) 512 lexed
  if rest.isEmpty then pure code else none
def only (names : List Name) : Stmt → Bool
  | .base code => KeygenZintTop.only names code
  | .scaledStore array _ _ _ => names.contains array
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ _ code => only names code
def scaledCount : Stmt → Nat
  | .scaledStore _ _ _ _ => 1
  | .seq a b | .branch _ a b | .loop _ a b => scaledCount a+scaledCount b
  | .scope _ _ code => scaledCount code
  | .base _ => 0
def baseCallCount : KeygenZintTop.Stmt → Nat
  | .core code => (KeygenZintCall.callShape code).1+(KeygenZintCall.callShape code).2.1
  | .seq a b => baseCallCount a+baseCallCount b
  | _ => 0
def callCount : Stmt → Nat
  | .scaledStore _ _ _ _ => 2
  | .seq a b | .branch _ a b | .loop _ a b => callCount a+callCount b
  | .scope _ _ code => callCount code
  | .base code => baseCallCount code

theorem frame (code : Stmt) (before : State) (out : Result) (source : Exec code before out)
    (names : List Name) (checked : only names code=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | base code before out source =>
    exact KeygenZintTop.frame code before out source names checked block offset outside tables
  | scaledStore array index args exponent before middle after p z e v top scale convert address write =>
    have keep := KeygenZintTop.call_frame before middle args z top block offset tables
    obtain ⟨entry,inner,binding,execution,returned,rfl⟩ := top
    have stored := write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame _ names array index p 8 address
        (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)
    exact ⟨outside,rfl,stored.trans keep⟩
  | seqNormal a b before middle out first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    have tm : C99PointerFootprint.TablesOutside middle block offset := by
      simpa only [C99PointerFootprint.TablesOutside,ta] using tables
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa tm
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out first exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | scope locals pointers body before out source ih =>
    obtain ⟨ho,ht,hf⟩ := ih checked outside tables
    exact ⟨C99PointerFootprint.restore_outside before out.state locals pointers names block offset
      outside ho,ht,hf⟩
  | branchTrue condition yes no before out v guard nonzero source ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | branchFalse condition yes no before out v guard zero source ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).2 outside tables
  | loopFalse => exact ⟨outside,rfl,rfl⟩
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    have tm : C99PointerFootprint.TablesOutside middle block offset := by
      simpa only [C99PointerFootprint.TablesOutside,ta] using tables
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa tm
    change next.tables=middle.tables at tb
    have tn : C99PointerFootprint.TablesOutside next block offset := by
      simpa only [C99PointerFootprint.TablesOutside,tb,ta] using tables
    obtain ⟨oc,tc,fc⟩ := ih3 checked ob tn
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables

def parsed : Kind → Nat → Option Stmt
  | .maxBitlength,0 => region .maxBitlength 4449 3
  | .maxBitlength,1 => region .maxBitlength 4452 2
  | .maxBitlength,2 => region .maxBitlength 4454 8
  | .maxBitlength,3 => region .maxBitlength 4462 1
  | .bigToFp,0 => region .bigToFp 4475 3
  | .bigToFp,1 => region .bigToFp 4478 2
  | .bigToFp,2 => region .bigToFp 4480 4
  | _,_ => none
def part (kind : Kind) (index : Nat) : Stmt := (parsed kind index).getD skip
def code : Kind → Stmt
  | .maxBitlength => chain [part .maxBitlength 0,part .maxBitlength 1,part .maxBitlength 2,part .maxBitlength 3]
  | .bigToFp => chain [part .bigToFp 0,part .bigToFp 1,part .bigToFp 2]
def lines := KeygenLevelNtt.region
theorem max_header : lines 4445 4 = ["static uint32_t\n",
    "poly_max_bitlength(const uint32_t *f, size_t flen, size_t fstride,\n",
    "\tunsigned logn, unsigned ter)\n","{\n"] := by decide
theorem max_close : Pinned.keygenLines[4462]?=some "}\n" := by decide
theorem max_partition : lines 4449 14=lines 4449 3 ++ lines 4452 2 ++ lines 4454 8 ++ lines 4462 1 := by decide
theorem fp_header : lines 4471 4 = ["static void\n",
    "poly_big_to_fp(fpr *d, const uint32_t *f, size_t flen, size_t fstride,\n",
    "\tunsigned logn, unsigned ter, uint32_t maxbl, uint32_t scale)\n","{\n"] := by decide
theorem fp_close : Pinned.keygenLines[4483]?=some "}\n" := by decide
theorem fp_partition : lines 4475 9=lines 4475 3 ++ lines 4478 2 ++ lines 4480 4 := by decide
def audit (kind : Kind) (index : Nat) : Option Bool := (parsed kind index).map (only (writable kind))
theorem max_audit0 : audit .maxBitlength 0=some true := by decide
theorem max_audit1 : audit .maxBitlength 1=some true := by decide
theorem max_audit2 : audit .maxBitlength 2=some true := by decide
theorem max_audit3 : audit .maxBitlength 3=some true := by decide
theorem fp_audit0 : audit .bigToFp 0=some true := by decide
theorem fp_audit1 : audit .bigToFp 1=some true := by decide
theorem fp_audit2 : audit .bigToFp 2=some true := by decide
theorem fp_call_store : (parsed .bigToFp 2).map scaledCount=some 1 := by decide
theorem max_signed_call : (parsed .maxBitlength 2).map callCount=some 1 := by decide
theorem fp_nested_calls : (parsed .bigToFp 2).map callCount=some 2 := by decide
theorem parsed_part (kind : Kind) (index : Nat) (h : audit kind index=some true) :
    parsed kind index=some (part kind index) := by
  cases hp : parsed kind index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (kind : Kind) (index : Nat) (h : audit kind index=some true) :
    only (writable kind) (part kind index)=true := by
  have parsed := parsed_part kind index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
theorem only_skip (names : List Name) : only names skip=true := rfl
theorem code_checked : ∀ kind, only (writable kind) (code kind)=true := by
  intro kind
  cases kind with
  | maxBitlength =>
    show only (writable .maxBitlength) (.seq (part .maxBitlength 0) (.seq (part .maxBitlength 1)
      (.seq (part .maxBitlength 2) (.seq (part .maxBitlength 3) skip))))=true
    rw [only_seq,only_seq,only_seq,only_seq,only_skip,
      part_checked .maxBitlength 0 max_audit0,part_checked .maxBitlength 1 max_audit1,
      part_checked .maxBitlength 2 max_audit2,part_checked .maxBitlength 3 max_audit3]
    decide
  | bigToFp =>
    show only (writable .bigToFp) (.seq (part .bigToFp 0)
      (.seq (part .bigToFp 1) (.seq (part .bigToFp 2) skip)))=true
    rw [only_seq,only_seq,only_seq,only_skip,
      part_checked .bigToFp 0 fp_audit0,part_checked .bigToFp 1 fp_audit1,part_checked .bigToFp 2 fp_audit2]
    decide

def Call (kind : Kind) (before : State) (args : List Arg) (after : State) (v : Option Value) : Prop :=
  ∃ entry out, C99ArrayReference.Bind before (params kind) args entry ∧ Exec (code kind) entry out ∧
    C99ProcedureReference.ReturnValue (result kind) out.flow v ∧ after={before with heap := out.state.heap}
theorem call_frame (kind : Kind) (before after : State) (args : List Arg) (v : Option Value)
    (source : Call kind before args after v) (names : List Name) (block offset : Nat)
    (allowed : C99PointerFootprint.arguments names (writable kind) (params kind) args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  obtain ⟨entry,out,binding,execution,returned,rfl⟩ := source
  obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before (params kind) args entry binding
    names (writable kind) allowed block offset outside tables
  have tm : C99PointerFootprint.TablesOutside entry block offset := by
    simpa only [C99PointerFootprint.TablesOutside,ht] using tables
  have keep := (frame (code kind) entry out execution (writable kind) (code_checked kind)
    block offset ho tm).2.2
  rw [C99ArrayReference.bind_heap before (params kind) args entry binding] at keep
  exact keep

end FT1536.Source3.KeygenZintPoly
