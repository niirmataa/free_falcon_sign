import Source3.KeygenZintScaled
import Source3.KeygenZintTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The full quadratic subtraction body, including both ring branches.
   This grammar has no early-return/break constructs, so its finite natural
   semantics ends normally. The fixed scaled leaf retains its own return
   control. Pointer provenance is tracked by object, allowing C's backward
   pointer arguments without assuming a nonnegative unsigned j-off value. -/
namespace FT1536.Source3.KeygenPolySubScaled
open C99ArrayReference (State Name Param Pointer bindValue bindPointer restoreScope)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open KeygenWordExpr (Expr)
open KeygenZintScaled (Arg Blocks TableBlocks)
open B20.C (Token)

inductive Stmt where
  | skip
  | declare (ty : Ty) (name : Name)
  | declarePtr (name : Name)
  | assign (name : Name) (value : Expr)
  | pointer (dst src : Name) (index : CLogic.Expr)
  | divide31 (dst src : Name) (remainder : Bool)
  | addScaled (args : List Arg)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : Expr) (yes no : Stmt)
  | loop (condition : Expr) (body increment : Stmt)
  deriving DecidableEq, Repr
def chain : List Stmt → Stmt
  | [] => .skip
  | a::rest => .seq a (chain rest)
def clearPointer (before : State) (name : Name) : State :=
  {before with arrays := fun n => if n=name then none else before.arrays n}
inductive Exec : Stmt → State → State → Prop where
  | skip (before : State) : Exec .skip before before
  | declare (ty : Ty) (name : Name) (before : State) :
      Exec (.declare ty name) before {before with locals := C99ScalarReference.set before.locals name (ty,none)}
  | declarePtr (name : Name) (before : State) : Exec (.declarePtr name) before (clearPointer before name)
  | assign (name : Name) (e : Expr) (before : State) (ty : Ty) (old : Option Value) (v : Value)
      (declared : before.locals name=some (ty,old)) (value : KeygenWordExpr.Eval before e v) :
      Exec (.assign name e) before (bindValue before name ty v)
  | pointer (dst src : Name) (index : CLogic.Expr) (before : State) (p : ArrayPointer)
      (source : Pointer before src index p) : Exec (.pointer dst src index) before (bindPointer before dst p)
  | divide31 (dst src : Name) (remainder : Bool) (before : State) (old : Option Value) (word : BitVec 32)
      (declared : before.locals dst=some (.uint32,old))
      (read : before.locals src=some (.uint32,some (.uint32 word))) :
      Exec (.divide31 dst src remainder) before
        (bindValue before dst .uint32 (KeygenZintTop.divided31 word remainder))
  | addScaled (args : List Arg) (before after : State)
      (source : KeygenZintScaled.Call .add before args after) : Exec (.addScaled args) before after
  | seq (a b : Stmt) (before middle after : State)
      (first : Exec a before middle) (second : Exec b middle after) : Exec (.seq a b) before after
  | scope (locals pointers : List Name) (body : Stmt) (before after : State)
      (source : Exec body before after) : Exec (.scope locals pointers body) before (restoreScope before after locals pointers)
  | branchTrue (condition : Expr) (yes no : Stmt) (before after : State) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (nonzero : v.integer≠0)
      (source : Exec yes before after) : Exec (.branch condition yes no) before after
  | branchFalse (condition : Expr) (yes no : Stmt) (before after : State) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (zero : v.integer=0)
      (source : Exec no before after) : Exec (.branch condition yes no) before after
  | loopFalse (condition : Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (zero : v.integer=0) : Exec (.loop condition body increment) before before
  | loopTrue (condition : Expr) (body increment : Stmt) (before middle next after : State) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before middle) (update : Exec increment middle next)
      (rest : Exec (.loop condition body increment) next after) : Exec (.loop condition body increment) before after

def only (names : List Name) : Stmt → Bool
  | .skip | .declare _ _ | .declarePtr _ | .assign _ _ | .divide31 _ _ _ => true
  | .pointer _ src _ => names.contains src
  | .addScaled args => KeygenZintScaled.allowed names (KeygenZintScaled.params .add) args
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ _ body => only names body
theorem frame (code : Stmt) (before after : State) (source : Exec code before after)
    (names : List Name) (checked : only names code=true) (block offset : Nat)
    (separated : Blocks before names block) (tables : TableBlocks before block) :
    Blocks after names block ∧ after.tables=before.tables ∧
      after.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | skip | declare | assign | divide31 | loopFalse => exact ⟨separated,rfl,rfl⟩
  | declarePtr name before =>
    refine ⟨?_,rfl,rfl⟩
    intro n hn p hp
    by_cases he : n=name
    · simp [clearPointer,he] at hp
    · exact separated n hn p (by simpa [clearPointer,he] using hp)
  | pointer dst src index before p source =>
    have ho := KeygenZintScaled.pointer_block before names src index p source block
      (List.contains_iff_mem.mp checked) separated
    refine ⟨?_,rfl,rfl⟩
    intro n hn q hq
    by_cases he : n=dst
    · have hpq : p=q := Option.some.inj (by simpa [bindPointer,he] using hq)
      subst q
      exact ho
    · exact separated n hn q (by simpa [bindPointer,he] using hq)
  | addScaled args before after source =>
    exact KeygenZintScaled.call_frame .add before after args names source block offset checked separated tables
  | seq a b before middle after first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha separated tables
    have tm : TableBlocks middle block := by simpa only [TableBlocks,ta] using tables
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa tm
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | scope locals pointers body before after source ih =>
    obtain ⟨ho,ht,hf⟩ := ih checked separated tables
    refine ⟨?_,ht,hf⟩
    intro n hn p hp
    dsimp [restoreScope] at hp
    split at hp
    · exact separated n hn p hp
    · exact ho n hn p hp
  | branchTrue condition yes no before after v guard nonzero source ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 separated tables
  | branchFalse condition yes no before after v guard zero source ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).2 separated tables
  | loopTrue condition body increment before middle next after v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha separated tables
    have tm : TableBlocks middle block := by simpa only [TableBlocks,ta] using tables
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa tm
    have tn : TableBlocks next block := by simpa only [TableBlocks,tb,ta] using tables
    obtain ⟨oc,tc,fc⟩ := ih3 checked ob tn
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩

def widths : KeygenWordExpr.Types := [("F".toList,4),("f".toList,4),("k".toList,4)]
def parameters : List Param := [.pointer "F".toList,.scalar .uint64 "Flen".toList,
  .scalar .uint64 "Fstride".toList,.pointer "f".toList,.scalar .uint64 "flen".toList,
  .scalar .uint64 "fstride".toList,.pointer "k".toList,.scalar .uint32 "sc".toList,
  .scalar .uint32 "logn".toList,.scalar .uint32 "full".toList,.scalar .uint32 "ternary".toList]
def writable : List Name := ["F","f","x","y"].map String.toList
def lower : KeygenWordExec.Stmt → Option Stmt
  | .assign dst e => some (.assign dst e)
  | .modular (.base (.scalar (.declare ty names))) =>
    some (chain (names.map (fun name => .declare (C99ValueBridge.type ty) name)))
  | .modular (.base (.scalar (.update name op e))) =>
    some (.assign name (.bin op (.scalar (.var name)) (.scalar e)))
  | _ => none
def clause (ptrs : List Name) (rest : List Token) : Option (Stmt×List Token) :=
  match KeygenZintCall.pointerClause ptrs rest with
  | some (.word (.modular (.base (.bindPtr dst src index))),rest) => some (.pointer dst src index,rest)
  | _ => do
    let (code,rest) ← KeygenWordParser.clause (KeygenZintCall.env widths ptrs) rest
    pure (← lower code,rest)
def clauses (ptrs : List Name) (ending : Token) : Nat → List Token → Option (Stmt×List Token)
  | 0,_ => none
  | fuel+1,rest =>
    if rest.head?=some ending then some (.skip,rest.drop 1) else do
      let (head,rest) ← clause ptrs rest
      match rest with
      | [',']::rest => do
        let (tail,rest) ← clauses ptrs ending fuel rest
        pure (.seq head tail,rest)
      | last::rest => if last=ending then some (head,rest) else none
      | _ => none
def pointerDeclaration (ptrs : List Name) : List Token → Option (Stmt×List Name×List Token)
  | ['c','o','n','s','t']::['u','i','n','t','3','2','_','t']::['*']::rest
  | ['u','i','n','t','3','2','_','t']::['*']::rest => do
    let (names,rest) ← C99ProcedureParser.pointerNames 32 (['*']::rest)
    pure (chain (names.map Stmt.declarePtr),names++ptrs,rest)
  | _ => none
def simple (ptrs : List Name) (ts : List Token) : Option (Stmt×List Name×List Token) := do
  match ts with
  | ['z','i','n','t','_','a','d','d','_','s','c','a','l','e','d','_','m','u','l','_','s','m','a','l','l']::['(']::rest =>
    let (args,rest) ← KeygenZintScaled.arguments (KeygenZintScaled.params .add) rest
    match rest with
    | [';']::rest => pure (.addScaled args,ptrs,rest)
    | _ => none
  | dst::['=']::['-']::['k']::['[']::rest =>
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::[';']::rest =>
      pure (.assign dst (.neg (.cast .int32 (.load32 "k".toList index))),ptrs,rest)
    | _ => none
  | dst::['=']::src::op::['3','1']::[';']::rest =>
    if op=['/'] then pure (.divide31 dst src false,ptrs,rest) else
    if op=['%'] then pure (.divide31 dst src true,ptrs,rest) else do
      let (code,rest) ← KeygenWordParser.simple (KeygenZintCall.env widths ptrs) ts
      pure (← lower code,ptrs,rest)
  | _ =>
    match pointerDeclaration ptrs ts with
    | some code => some code
    | none => match KeygenZintCall.pointerStmt ptrs ts with
      | some (.word (.modular (.base (.bindPtr dst src index))),rest) => pure (.pointer dst src index,ptrs,rest)
      | _ => do
        let (code,rest) ← KeygenWordParser.simple (KeygenZintCall.env widths ptrs) ts
        pure (← lower code,ptrs,rest)
def declarations : Stmt → List Name×List Name
  | .declare _ name => ([name],[])
  | .declarePtr name => ([],[name])
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])
mutual
  def statement (ptrs : List Name) : Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (code,_,rest) ← body ptrs fuel rest
      let names := declarations code
      pure (.scope names.1 names.2 code,ptrs,rest)
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← clauses ptrs [';'] 16 rest
      let (condition,rest) ← KeygenWordExpr.expression (KeygenZintCall.env widths ptrs) rest
      match rest with
      | [';']::rest => do
        let (update,rest) ← clauses ptrs [')'] 16 rest
        let (inner,_,rest) ← statement ptrs fuel rest
        pure (.seq initial (.loop condition inner update),ptrs,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← KeygenWordExpr.expression (KeygenZintCall.env widths ptrs) rest
      match rest with
      | [')']::rest => do
        let (yes,_,rest) ← statement ptrs fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,_,rest) ← statement ptrs fuel rest
          pure (.branch condition yes no,ptrs,rest)
        | _ => pure (.branch condition yes .skip,ptrs,rest)
      | _ => none
    | _+1,rest => simple ptrs rest
  def body (ptrs : List Name) : Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (.skip,ptrs,rest)
    | fuel+1,rest => do
      let (first,next,rest) ← statement ptrs fuel rest
      let (tail,final,rest) ← body next fuel rest
      pure (.seq first tail,final,rest)
end
def region (start count : Nat) : Option Stmt := do
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← KeygenZintTop.tokens text
  let (code,_,rest) ← body (widths.map Prod.fst) 512 lexed
  if rest.isEmpty then pure code else none
def parsed : Nat → Option Stmt
  | 0 => region 4525 3
  | 1 => region 4528 4
  | 2 => region 4532 56
  | _ => none
def part (index : Nat) : Stmt := (parsed index).getD .skip
def code : Stmt := chain [part 0,part 1,part 2]
def counts : Stmt → Nat×Nat×Nat
  | .addScaled args => (1,(args.filter (fun arg => match arg with | .backward _ _ _ => true | _ => false)).length,0)
  | .assign _ (.neg (.cast .int32 (.load32 _ _))) => (0,0,1)
  | .seq a b | .branch _ a b | .loop _ a b =>
    let x := counts a
    let y := counts b
    (x.1+y.1,x.2.1+y.2.1,x.2.2+y.2.2)
  | .scope _ _ code => counts code
  | _ => (0,0,0)
def lines := KeygenLevelNtt.region
theorem header : lines 4519 6 = ["static void\n",
    "poly_sub_scaled(uint32_t *restrict F, size_t Flen, size_t Fstride,\n",
    "\tconst uint32_t *restrict f, size_t flen, size_t fstride,\n",
    "\tconst int32_t *restrict k, uint32_t sc,\n",
    "\tunsigned logn, unsigned full, unsigned ternary)\n","{\n"] := by decide
theorem close : Pinned.keygenLines[4587]?=some "}\n" := by decide
theorem partition : lines 4525 63=lines 4525 3 ++ lines 4528 4 ++ lines 4532 56 := by decide
def audit (index : Nat) : Option Bool := (parsed index).map (only writable)
theorem audit0 : audit 0=some true := by decide
theorem audit1 : audit 1=some true := by decide
theorem audit2 : audit 2=some true := by decide
theorem call_pointer_signed_counts : (parsed 2).map counts=some (5,3,2) := by decide
theorem parsed_part (index : Nat) (h : audit index=some true) : parsed index=some (part index) := by
  cases hp : parsed index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (index : Nat) (h : audit index=some true) : only writable (part index)=true := by
  have parsed := parsed_part index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
theorem code_checked : only writable code=true := by
  show only writable (.seq (part 0) (.seq (part 1) (.seq (part 2) .skip)))=true
  rw [only_seq,only_seq,only_seq,part_checked 0 audit0,part_checked 1 audit1,part_checked 2 audit2]
  rfl
def Call (before : State) (args : List C99ArrayReference.Arg) (after : State) : Prop :=
  ∃ entry out, C99ArrayReference.Bind before parameters args entry ∧ Exec code entry out ∧
    after={before with heap := out.heap}

end FT1536.Source3.KeygenPolySubScaled
