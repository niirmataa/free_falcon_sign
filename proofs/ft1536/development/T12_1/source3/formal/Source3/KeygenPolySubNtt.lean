import Source3.KeygenMakeFgSource
import Source3.KeygenZintScaled
import Source3.KeygenZintTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete NTT-assisted scaled subtraction. The signed k read is explicit;
   binary/ternary transforms, CRT and the final scaled subtraction execute
   fixed source bodies. This module supplies operational coverage and a byte
   frame, without assuming a multiplication or reduction postcondition. -/
namespace FT1536.Source3.KeygenPolySubNtt
open C99ArrayReference (State Name Param Arg restoreScope)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open B20.C (Token)

def widths : KeygenWordExpr.Types :=
  ["F","f","k","tmp","gm","igm","fk","t1","x","y"].map (fun n => (n.toList,4)) ++
  [("primes".toList,12),("PRIMES2".toList,12),("PRIMES3".toList,12)]
def writable : List Name :=
  ["F","f","tmp","gm","igm","fk","t1","x","y","primes","PRIMES2","PRIMES3"].map String.toList
def params : List Param := [.pointer "F".toList,.scalar .uint64 "Flen".toList,
  .scalar .uint64 "Fstride".toList,.pointer "f".toList,.scalar .uint64 "flen".toList,
  .scalar .uint64 "fstride".toList,.pointer "k".toList,.scalar .uint32 "sc".toList,
  .scalar .uint32 "logn".toList,.scalar .uint32 "full".toList,.scalar .int32 "ternary".toList,
  .pointer "tmp".toList]
inductive Stmt where
  | base (code : KeygenMakeFgSource.Stmt)
  | divide (code : KeygenZintTop.Stmt)
  | subtract (args : List Arg)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  deriving DecidableEq, Repr
def modular (code : C99ModularReference.Stmt) : Stmt := .base (KeygenMakeFgSource.modular code)
def skip : Stmt := modular (.base .skip)
def chain : List Stmt → Stmt
  | [] => skip
  | a::rest => .seq a (chain rest)

def special (ptrs : List Name) : List Token → Option (Stmt×List Name×List Token)
  | ['c','o','n','s','t']::['u','i','n','t','3','2','_','t']::['*']::rest => do
    let (code,next,rest) ← KeygenZintCall.pointerDeclare ptrs ("uint32_t".toList::['*']::rest)
    pure (.base (.zint code),next,rest)
  | ['*']::dst::['=']::callee::['(']::rest => do
    let kind ← KeygenZintCall.calleeOf callee
    let (args,rest) ← C99ProcedureParser.arguments (KeygenZintCall.params kind) rest
    match rest with
    | [';']::rest => pure (.base (.zint (.call kind args (.store dst C99ProcedureParser.zero))),ptrs,rest)
    | _ => none
  | ['z','i','n','t','_','s','u','b','_','s','c','a','l','e','d']::['(']::rest => do
    let (args,rest) ← C99ProcedureParser.arguments (KeygenZintScaled.params .sub) rest
    match rest with
    | [';']::rest => pure (.subtract args,ptrs,rest)
    | _ => none
  | dst::['=']::src::op::['3','1']::[';']::rest =>
    if op=['/'] then some (.divide (.divide31 dst src false),ptrs,rest) else
    if op=['%'] then some (.divide (.divide31 dst src true),ptrs,rest) else none
  | dst::['[']::rest => do
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::['=']::['m','o','d','p','_','s','e','t']::['(']::['k']::['[']::rest => do
      let (ki,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [']']::[',']::rest => do
        let (p,rest) ← KeygenWordExpr.expression widths rest
        match rest with
        | [')']::[';']::rest => pure (.base (.word (.store dst index
            (.call2 "modp_set".toList (.cast .int32 (.load32 "k".toList ki)) p))),ptrs,rest)
        | _ => none
      | _ => none
    | _ => none
  | _ => none
def simple (ptrs : List Name) (ts : List Token) : Option (Stmt×List Name×List Token) :=
  match special ptrs ts with
  | some out => some out
  | none => do
    let (code,ptrs,rest) ← KeygenMakeFgSource.simple ptrs ts
    pure (.base code,ptrs,rest)
def declarations : Stmt → List Name×List Name
  | .base code => KeygenMakeFgSource.declarations code
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
      let (initial,rest) ← C99ModularParser.clauses ptrs [';'] 16 rest
      let (condition,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [';']::rest => do
        let (update,rest) ← C99ModularParser.clauses ptrs [')'] 16 rest
        let (inner,_,rest) ← statement ptrs fuel rest
        pure (.seq (modular initial) (.loop condition inner (modular update)),ptrs,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [')']::rest => do
        let (yes,_,rest) ← statement ptrs fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,_,rest) ← statement ptrs fuel rest
          pure (.branch condition yes no,ptrs,rest)
        | _ => pure (.branch condition yes skip,ptrs,rest)
      | _ => none
    | _+1,rest => simple ptrs rest
  def body (ptrs : List Name) : Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (skip,ptrs,rest)
    | fuel+1,rest => do
      let (first,next,rest) ← statement ptrs fuel rest
      let (tail,final,rest) ← body next fuel rest
      pure (.seq first tail,final,rest)
end
def region (start count : Nat) : Option Stmt := do
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← KeygenZintTop.tokens text
  let (code,_,rest) ← body (widths.map Prod.fst) 256 lexed
  if rest.isEmpty then pure code else none
def parsed : Nat → Option Stmt
  | 0 => region 4601 6
  | 1 => region 4607 8
  | 2 => region 4615 46
  | 3 => region 4661 14
  | _ => none
def part (index : Nat) : Stmt := (parsed index).getD skip
def code : Stmt := chain [part 0,part 1,part 2,part 3]
def only (names : List Name) : Stmt → Bool
  | .base code => KeygenMakeFgSource.only names code
  | .divide code => KeygenZintTop.only names code
  | .subtract args => C99PointerFootprint.arguments names KeygenZintScaled.writable (KeygenZintScaled.params .sub) args
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ _ body => only names body
def counts : Stmt → Nat×Nat×Nat×Nat×Nat
  | .base code =>
    let c := KeygenMakeFgSource.counts code
    (c.1,c.2.1,c.2.2.1,0,0)
  | .subtract _ => (0,0,0,1,0)
  | .divide (.divide31 _ _ _) => (0,0,0,0,1)
  | .seq a b | .branch _ a b | .loop _ a b =>
    let x := counts a
    let y := counts b
    (x.1+y.1,x.2.1+y.2.1,x.2.2.1+y.2.2.1,x.2.2.2.1+y.2.2.2.1,x.2.2.2.2+y.2.2.2.2)
  | .scope _ _ body => counts body
  | _ => (0,0,0,0,0)
def signedLoads : Stmt → Nat
  | .base (.word (.store _ _ (.call2 _ (.cast .int32 (.load32 _ _)) _))) => 1
  | .seq a b | .branch _ a b | .loop _ a b => signedLoads a+signedLoads b
  | .scope _ _ body => signedLoads body
  | _ => 0
def lines := KeygenLevelNtt.region
theorem header : lines 4595 6=["static void\n",
    "poly_sub_scaled_ntt(uint32_t *restrict F, size_t Flen, size_t Fstride,\n",
    "\tconst uint32_t *restrict f, size_t flen, size_t fstride,\n",
    "\tconst int32_t *restrict k, uint32_t sc,\n",
    "\tunsigned logn, unsigned full, int ternary, uint32_t *restrict tmp)\n","{\n"] := by decide
theorem close : Pinned.keygenLines[4674]?=some "}\n" := by decide
theorem partition : lines 4601 74=lines 4601 6 ++ lines 4607 8 ++ lines 4615 46 ++ lines 4661 14 := by decide
def audit (index : Nat) : Option Bool := (parsed index).map (only writable)
theorem audit0 : audit 0=some true := by decide
theorem audit1 : audit 1=some true := by decide
theorem audit2 : audit 2=some true := by decide
theorem audit3 : audit 3=some true := by decide
theorem calls2 : (parsed 2).map counts=some (4,4,1,0,0) := by decide
theorem calls3 : (parsed 3).map counts=some (0,0,1,1,2) := by decide
theorem signed_k : (parsed 2).map signedLoads=some 1 := by decide
theorem parsed_part (index : Nat) (h : audit index=some true) : parsed index=some (part index) := by
  cases hp : parsed index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (index : Nat) (h : audit index=some true) : only writable (part index)=true := by
  have parsed := parsed_part index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
theorem only_skip (names : List Name) : only names skip=true := rfl
theorem code_checked : only writable code=true := by
  show only writable (.seq (part 0) (.seq (part 1) (.seq (part 2) (.seq (part 3) skip))))=true
  rw [only_seq,only_seq,only_seq,only_seq,only_skip,
    part_checked 0 audit0,part_checked 1 audit1,part_checked 2 audit2,part_checked 3 audit3]
  decide

inductive Exec : Stmt → State → Result → Prop where
  | base (code : KeygenMakeFgSource.Stmt) (before : State) (out : Result)
      (source : KeygenMakeFgSource.Exec code before out) : Exec (.base code) before out
  | divide (code : KeygenZintTop.Stmt) (before : State) (out : Result)
      (source : KeygenZintTop.Exec code before out) : Exec (.divide code) before out
  | subtract (args : List Arg) (before entry : State) (out : Result)
      (binding : C99ArrayReference.Bind before (KeygenZintScaled.params .sub) args entry)
      (source : KeygenZintCall.Exec (KeygenZintScaled.code .sub) entry out)
      (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Exec (.subtract args) before ⟨{before with heap := out.state.heap},.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (first : Exec a before ⟨middle,.normal⟩) (second : Exec b middle out) : Exec (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result)
      (first : Exec a before out) (exit : out.flow≠.normal) : Exec (.seq a b) before out
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (out : Result)
      (source : Exec body before out) : Exec (.scope locals pointers body) before ⟨restoreScope before out.state locals pointers,out.flow⟩
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (source : Exec yes before out) : Exec (.branch condition yes no) before out
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0)
      (source : Exec no before out) : Exec (.branch condition yes no) before out
  | loopFalse (condition : CLogic.Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0) : Exec (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨middle,.normal⟩) (update : Exec increment middle ⟨next,.normal⟩)
      (rest : Exec (.loop condition body increment) next out) : Exec (.loop condition body increment) before out
  | loopReturn (condition : CLogic.Expr) (body increment : Stmt) (before after : State) (v : Value) (ret : Option Value)
      (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨after,.returned ret⟩) : Exec (.loop condition body increment) before ⟨after,.returned ret⟩
theorem frame (body : Stmt) (before : State) (out : Result) (source : Exec body before out)
    (names : List Name) (checked : only names body=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | base code before out source => exact KeygenMakeFgSource.frame code before out source names checked block offset outside tables
  | divide code before out source => exact KeygenZintTop.frame code before out source names checked block offset outside tables
  | subtract args before entry out binding source returned =>
    obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before (KeygenZintScaled.params .sub) args entry binding
      names KeygenZintScaled.writable checked block offset outside tables
    have keep := (KeygenZintCall.body_frame KeygenZintCore.code_checked (KeygenZintScaled.code .sub) entry out source
      KeygenZintScaled.writable (KeygenZintScaled.code_checked .sub) block offset ho
      (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)).2.2
    rw [C99ArrayReference.bind_heap before (KeygenZintScaled.params .sub) args entry binding] at keep
    exact ⟨outside,rfl,keep⟩
  | seqNormal a b before middle out first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa (by simpa only [C99PointerFootprint.TablesOutside,ta] using tables)
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out first exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | scope locals pointers body before out source ih =>
    obtain ⟨ho,ht,hf⟩ := ih checked outside tables
    exact ⟨C99PointerFootprint.restore_outside before out.state locals pointers names block offset outside ho,ht,hf⟩
  | branchTrue condition yes no before out v guard nonzero source ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | branchFalse condition yes no before out v guard zero source ih => exact ih (Bool.and_eq_true_iff.mp checked).2 outside tables
  | loopFalse => exact ⟨outside,rfl,rfl⟩
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa (by simpa only [C99PointerFootprint.TablesOutside,ta] using tables)
    change next.tables=middle.tables at tb
    obtain ⟨oc,tc,fc⟩ := ih3 checked ob (by simpa only [C99PointerFootprint.TablesOutside,tb,ta] using tables)
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables

def Call (before : State) (args : List Arg) (after : State) : Prop :=
  ∃ entry out, C99ArrayReference.Bind before params args entry ∧ Exec code entry out ∧
    C99ProcedureReference.ReturnValue none out.flow none ∧ after={before with heap := out.state.heap}
theorem call_frame (before after : State) (args : List Arg) (source : Call before args after)
    (names : List Name) (block offset : Nat)
    (allowed : C99PointerFootprint.arguments names writable params args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  obtain ⟨entry,out,binding,execution,returned,rfl⟩ := source
  obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before params args entry binding names writable allowed block offset outside tables
  have keep := (frame code entry out execution writable code_checked block offset ho
    (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)).2.2
  rw [C99ArrayReference.bind_heap before params args entry binding] at keep
  exact keep

end FT1536.Source3.KeygenPolySubNtt
