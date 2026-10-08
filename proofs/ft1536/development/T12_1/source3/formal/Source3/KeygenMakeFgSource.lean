import Source3.KeygenBinaryNtt
import Source3.KeygenZintCore
import Source3.KeygenMakeFgTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Fixed make_fg/make_fg_step source closure. The mixed declarations,
   pointer conditional, size_t table loads, int16 input loads, both NTT
   families and actual CRT calls all remain executable syntax. Static
   object initialization and root-context bindings belong to the caller. -/
namespace FT1536.Source3.KeygenMakeFgSource
open C99ArrayReference (State Name Param Arg restoreScope)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open B20.C (Token)

inductive Kind where | step | make
  deriving DecidableEq, Repr
def params : Kind → List Param
  | .step => [.pointer "data".toList,.scalar .uint32 "logn".toList,.scalar .uint32 "depth".toList,
    .scalar .uint32 "ter".toList,.scalar .int32 "in_ntt".toList,.scalar .int32 "out_ntt".toList]
  | .make => [.pointer "data".toList,.pointer "f".toList,.pointer "g".toList,
    .scalar .uint32 "logn".toList,.scalar .uint32 "ter".toList,.scalar .uint32 "depth".toList,
    .scalar .int32 "out_ntt".toList]
def widths : KeygenWordExpr.Types :=
  (["data","fd","gd","fs","gs","gm","igm","t1","x","ft","gt"].map (fun n => (n.toList,4))) ++
  [("f".toList,2),("g".toList,2),("primes".toList,12),
   ("PRIMES2".toList,12),("PRIMES3".toList,12),
   ("MAX_BL_SMALL2".toList,8),("MAX_BL_SMALL3".toList,8)]
def writable : List Name :=
  ["data","fd","gd","fs","gs","gm","igm","t1","x","ft","gt","primes","PRIMES2","PRIMES3"].map String.toList
inductive Stmt where
  | level (code : KeygenLevelExec.Stmt)
  | zint (code : KeygenZintCall.Stmt)
  | word (code : KeygenWordExec.Stmt)
  | binary (kind : KeygenBinaryNtt.Kind) (args : List KeygenLevelCalls.Arg)
  | top (args : List Arg)
  | step (args : List Arg)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  deriving DecidableEq, Repr
def modular (code : C99ModularReference.Stmt) : Stmt := .level (.modular code)
def skip : Stmt := modular (.base .skip)
def chain : List Stmt → Stmt
  | [] => skip
  | a::rest => .seq a (chain rest)
def binaryOf : Name → Option (KeygenBinaryNtt.Kind×Bool)
  | ['m','o','d','p','_','m','k','g','m','2'] => some (.generate,false)
  | ['m','o','d','p','_','N','T','T','2'] => some (.forward,true)
  | ['m','o','d','p','_','i','N','T','T','2'] => some (.inverse,true)
  | ['m','o','d','p','_','N','T','T','2','_','e','x','t'] => some (.forward,false)
  | ['m','o','d','p','_','i','N','T','T','2','_','e','x','t'] => some (.inverse,false)
  | _ => none
def binaryParams (kind : KeygenBinaryNtt.Kind) (wrapper : Bool) : List Param :=
  let ps := KeygenBinaryNtt.params kind
  if wrapper then ps.take 1++ps.drop 2 else ps
def extra (ctx : List Name) : List Token → Option (Stmt×List Name×List Token)
  | ['m','a','k','e','_','f','g','_','t','e','r','n','a','r','y','_','t','o','p']::['(']::rest => do
    let (args,rest) ← C99ProcedureParser.arguments KeygenMakeFgTop.params rest
    match rest with | [';']::rest => pure (.top args,ctx,rest) | _ => none
  | ['m','a','k','e','_','f','g','_','s','t','e','p']::['(']::rest => do
    let (args,rest) ← C99ProcedureParser.arguments (params .step) rest
    match rest with | [';']::rest => pure (.step args,ctx,rest) | _ => none
  | name::['(']::rest => do
    let (kind,wrapper) ← binaryOf name
    let (args,rest) ← KeygenLevelParser.arguments (binaryParams kind wrapper) rest
    match rest with
    | [';']::rest => pure (.binary kind (KeygenLevelParser.expandArgs args wrapper),ctx,rest)
    | _ => none
  | dst::['=']::src::['[']::rest =>
    if src="MAX_BL_SMALL2".toList || src="MAX_BL_SMALL3".toList then do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [']']::[';']::rest => pure (modular (.base (.assign dst (.load src index))),ctx,rest)
      | _ => none
    else none
  | ['p','r','i','m','e','s']::['=']::rest => do
    let (condition,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | ['?']::yes::[':']::no::[';']::rest =>
      pure (.branch condition
        (modular (.base (.bindPtr "primes".toList yes C99ProcedureParser.zero)))
        (modular (.base (.bindPtr "primes".toList no C99ProcedureParser.zero))),ctx,rest)
    | _ => none
  | ty::['*']::rest => do
    let t ← B20.C.Scalar.typeToken ty
    let beforeEnd := (['*']::rest).takeWhile (· != [';'])
    let beyond := (['*']::rest).drop beforeEnd.length
    match beyond with
    | [';']::tail => do
      let parts ← KeygenLevelNtt.declarators t 32 (beforeEnd++[[';']])
      let code := C99ModularParser.chain parts
      let pointers := (KeygenBinaryNtt.baseDeclarations code).2
      pure (modular code,pointers++ctx,tail)
    | _ => none
  | ['c','o','n','s','t']::['s','m','a','l','l','_','p','r','i','m','e']::['*']::rest => do
    let (code,ctx,rest) ← KeygenZintCall.pointerDeclare ctx
      ("const".toList::"small_prime".toList::['*']::rest)
    pure (.zint code,ctx,rest)
  | _ => none
def simple (ctx : List Name) (ts : List Token) : Option (Stmt×List Name×List Token) :=
  match extra ctx ts with
  | some code => some code
  | none =>
    match KeygenZintCall.fresh widths ctx ts with
    | some (.call kind args dst,next,rest) => some (.zint (.call kind args dst),next,rest)
    | _ =>
      match KeygenWordParser.simple widths ts with
      | some (.store name index (.call2 ['m','o','d','p','_','s','e','t'] a b),rest) =>
        some (.word (.store name index (.call2 "modp_set".toList a b)),ctx,rest)
      | _ => do
        let (code,ctx,rest) ← KeygenLevelParser.simple ctx ts
        pure (.level code,ctx,rest)
def declarations : Stmt → List Name×List Name
  | .level code => KeygenLevelParser.declarations code
  | .zint code => KeygenZintCall.declarations code
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])
mutual
  def statement (ctx : List Name) : Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (code,_,rest) ← body ctx fuel rest
      let names := declarations code
      pure (.scope names.1 names.2 code,ctx,rest)
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← C99ModularParser.clauses ctx [';'] 16 rest
      let (condition,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [';']::rest => do
        let (update,rest) ← C99ModularParser.clauses ctx [')'] 16 rest
        let (inner,_,rest) ← statement ctx fuel rest
        pure (.seq (modular initial) (.loop condition inner (modular update)),ctx,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [')']::rest => do
        let (yes,_,rest) ← statement ctx fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,_,rest) ← statement ctx fuel rest
          pure (.branch condition yes no,ctx,rest)
        | _ => pure (.branch condition yes skip,ctx,rest)
      | _ => none
    | _+1,rest => simple ctx rest
  def body (ctx : List Name) : Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (skip,ctx,rest)
    | fuel+1,rest => do
      let (first,next,rest) ← statement ctx fuel rest
      let (tail,final,rest) ← body next fuel rest
      pure (.seq first tail,final,rest)
end
def region (start count : Nat) : Option Stmt := do
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← KeygenZintCall.tokens text
  let lexed ← KeygenSearchParser.sizes widths lexed
  let (code,_,rest) ← body (widths.map Prod.fst) 512 lexed
  if rest.isEmpty then pure code else none
def parsed : Kind → Nat → Option Stmt
  | .step,0 => region 5380 5
  | .step,1 => region 5385 28
  | .step,2 => region 5413 84
  | .step,3 => region 5497 11
  | .step,4 => region 5508 61
  | .make,0 => region 5685 5
  | .make,1 => region 5690 10
  | .make,2 => region 5700 20
  | .make,3 => region 5720 12
  | _,_ => none
def part (kind : Kind) (index : Nat) : Stmt := (parsed kind index).getD skip
def code : Kind → Stmt
  | .step => chain [part .step 0,part .step 1,part .step 2,part .step 3,part .step 4]
  | .make => chain [part .make 0,part .make 1,part .make 2,part .make 3]
def only (names : List Name) : Stmt → Bool
  | .level body => KeygenLevelExec.only names body
  | .zint body => KeygenZintCall.only names body
  | .word body => KeygenWordExec.only names body
  | .binary kind args => KeygenLevelCalls.arguments names (KeygenBinaryNtt.writable kind) (KeygenBinaryNtt.params kind) args
  | .top args => C99PointerFootprint.arguments names KeygenMakeFgTop.writable KeygenMakeFgTop.params args
  | .step args => C99PointerFootprint.arguments names writable (params .step) args
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ _ body => only names body
def counts : Stmt → Nat×Nat×Nat×Nat×Nat
  | .binary _ _ => (1,0,0,0,0)
  | .level (.call _ _) => (0,1,0,0,0)
  | .zint (.call _ _ _) => (0,0,1,0,0)
  | .top _ => (0,0,0,1,0)
  | .step _ => (0,0,0,0,1)
  | .seq a b | .branch _ a b | .loop _ a b =>
    let x := counts a
    let y := counts b
    (x.1+y.1,x.2.1+y.2.1,x.2.2.1+y.2.2.1,x.2.2.2.1+y.2.2.2.1,x.2.2.2.2+y.2.2.2.2)
  | .scope _ _ body => counts body
  | _ => (0,0,0,0,0)
def lines := KeygenLevelNtt.region
theorem step_header : lines 5376 4=["static void\n",
    "make_fg_step(uint32_t *data, unsigned logn, unsigned depth, unsigned ter,\n",
    "\tint in_ntt, int out_ntt)\n","{\n"] := by decide
theorem step_close : Pinned.keygenLines[5568]?=some "}\n" := by decide
theorem make_header : lines 5681 4=["static void\n",
    "make_fg(uint32_t *data, const int16_t *f, const int16_t *g,\n",
    "\tunsigned logn, unsigned ter, unsigned depth, int out_ntt)\n","{\n"] := by decide
theorem make_close : Pinned.keygenLines[5731]?=some "}\n" := by decide
theorem step_partition : lines 5380 189=lines 5380 5 ++ lines 5385 28 ++ lines 5413 84 ++
    lines 5497 11 ++ lines 5508 61 := by decide
theorem make_partition : lines 5685 47=lines 5685 5 ++ lines 5690 10 ++ lines 5700 20 ++ lines 5720 12 := by decide
def audit (kind : Kind) (index : Nat) : Option Bool := (parsed kind index).map (only writable)
theorem step_audit0 : audit .step 0=some true := by decide
theorem step_audit1 : audit .step 1=some true := by decide
theorem step_audit2 : audit .step 2=some true := by decide
theorem step_audit3 : audit .step 3=some true := by decide
theorem step_audit4 : audit .step 4=some true := by decide
theorem make_audit0 : audit .make 0=some true := by decide
theorem make_audit1 : audit .make 1=some true := by decide
theorem make_audit2 : audit .make 2=some true := by decide
theorem make_audit3 : audit .make 3=some true := by decide
theorem step_calls2 : (parsed .step 2).map counts=some (7,7,0,0,0) := by decide
theorem step_calls3 : (parsed .step 3).map counts=some (0,0,2,0,0) := by decide
theorem step_calls4 : (parsed .step 4).map counts=some (5,5,2,0,0) := by decide
theorem make_calls2 : (parsed .make 2).map counts=some (3,3,0,0,0) := by decide
theorem make_calls3 : (parsed .make 3).map counts=some (0,0,0,1,2) := by decide
theorem parsed_part (kind : Kind) (index : Nat) (h : audit kind index=some true) : parsed kind index=some (part kind index) := by
  cases hp : parsed kind index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (kind : Kind) (index : Nat) (h : audit kind index=some true) : only writable (part kind index)=true := by
  have parsed := parsed_part kind index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
theorem only_skip (names : List Name) : only names skip=true := rfl
theorem code_checked : ∀ kind, only writable (code kind)=true := by
  intro kind
  cases kind with
  | step =>
    show only writable (.seq (part .step 0) (.seq (part .step 1) (.seq (part .step 2)
      (.seq (part .step 3) (.seq (part .step 4) skip)))))=true
    rw [only_seq,only_seq,only_seq,only_seq,only_seq,only_skip,
      part_checked .step 0 step_audit0,part_checked .step 1 step_audit1,part_checked .step 2 step_audit2,
      part_checked .step 3 step_audit3,part_checked .step 4 step_audit4]
    decide
  | make =>
    show only writable (.seq (part .make 0) (.seq (part .make 1) (.seq (part .make 2)
      (.seq (part .make 3) skip))))=true
    rw [only_seq,only_seq,only_seq,only_seq,only_skip,
      part_checked .make 0 make_audit0,part_checked .make 1 make_audit1,
      part_checked .make 2 make_audit2,part_checked .make 3 make_audit3]
    decide

inductive Exec : Stmt → State → Result → Prop where
  | level (code : KeygenLevelExec.Stmt) (before : State) (out : Result)
      (source : KeygenLevelExec.Exec code before out) : Exec (.level code) before out
  | zint (code : KeygenZintCall.Stmt) (before : State) (out : Result)
      (source : KeygenZintCall.Exec code before out) : Exec (.zint code) before out
  | word (code : KeygenWordExec.Stmt) (before : State) (out : Result)
      (source : KeygenWordExec.Exec code before out) : Exec (.word code) before out
  | binary (kind : KeygenBinaryNtt.Kind) (args : List KeygenLevelCalls.Arg) (before after : State)
      (source : KeygenBinaryNtt.Call kind before args after) : Exec (.binary kind args) before ⟨after,.normal⟩
  | top (args : List Arg) (before after : State) (source : KeygenMakeFgTop.Call before args after) :
      Exec (.top args) before ⟨after,.normal⟩
  | step (args : List Arg) (before entry : State) (out : Result)
      (binding : C99ArrayReference.Bind before (params .step) args entry)
      (source : Exec (code .step) entry out) (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Exec (.step args) before ⟨{before with heap := out.state.heap},.normal⟩
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
  induction source generalizing names with
  | level code before out source => exact KeygenLevelExec.body_frame code before out source names checked block offset outside tables
  | zint code before out source => exact KeygenZintCall.body_frame KeygenZintCore.code_checked code before out source names checked block offset outside tables
  | word code before out source => exact KeygenWordExec.body_frame code before out source names checked block offset outside
  | binary kind args before after source =>
    have keep := KeygenBinaryNtt.call_frame kind before after args source names block offset checked outside tables
    cases source
    exact ⟨outside,rfl,keep⟩
  | top args before after source =>
    have keep := KeygenMakeFgTop.call_frame before after args source names block offset checked outside tables
    cases source
    exact ⟨outside,rfl,keep⟩
  | step args before entry out binding source returned ih =>
    obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before (params .step) args entry binding names writable checked block offset outside tables
    obtain ⟨_,_,keep⟩ := ih writable (code_checked .step) ho
      (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)
    rw [C99ArrayReference.bind_heap before (params .step) args entry binding] at keep
    exact ⟨outside,rfl,keep⟩
  | seqNormal a b before middle out first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 names ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 names hb oa (by simpa only [C99PointerFootprint.TablesOutside,ta] using tables)
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out first exit ih => exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | scope locals pointers body before out source ih =>
    obtain ⟨ho,ht,hf⟩ := ih names checked outside tables
    exact ⟨C99PointerFootprint.restore_outside before out.state locals pointers names block offset outside ho,ht,hf⟩
  | branchTrue condition yes no before out v guard nonzero source ih => exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | branchFalse condition yes no before out v guard zero source ih => exact ih names (Bool.and_eq_true_iff.mp checked).2 outside tables
  | loopFalse => exact ⟨outside,rfl,rfl⟩
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 names ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 names hb oa (by simpa only [C99PointerFootprint.TablesOutside,ta] using tables)
    change next.tables=middle.tables at tb
    obtain ⟨oc,tc,fc⟩ := ih3 names checked ob (by simpa only [C99PointerFootprint.TablesOutside,tb,ta] using tables)
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables

def Call (kind : Kind) (before : State) (args : List Arg) (after : State) : Prop :=
  ∃ entry out, C99ArrayReference.Bind before (params kind) args entry ∧ Exec (code kind) entry out ∧
    C99ProcedureReference.ReturnValue none out.flow none ∧ after={before with heap := out.state.heap}
theorem call_frame (kind : Kind) (before after : State) (args : List Arg) (source : Call kind before args after)
    (names : List Name) (block offset : Nat)
    (allowed : C99PointerFootprint.arguments names writable (params kind) args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  obtain ⟨entry,out,binding,execution,returned,rfl⟩ := source
  obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before (params kind) args entry binding names writable allowed block offset outside tables
  have keep := (frame (code kind) entry out execution writable (code_checked kind) block offset ho
    (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)).2.2
  rw [C99ArrayReference.bind_heap before (params kind) args entry binding] at keep
  exact keep

end FT1536.Source3.KeygenMakeFgSource
