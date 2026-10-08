import Source3.KeygenLevelCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete binary generator/forward/inverse source bodies. This stratum
   retains pointer scopes, the literal empty statement in the inverse body,
   right-to-left chained assignment, and the unsigned 16-bit REV10 load.
   The frame is operational; no transform or primality theorem is assumed. -/
namespace FT1536.Source3.KeygenBinaryNtt
open C99ArrayReference (State Name Param restoreScope)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open B20.C (Token)

inductive Stmt where
  | base (code : C99ModularReference.Stmt)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  deriving DecidableEq, Repr
def skip : Stmt := .base (.base .skip)
def chain : List Stmt → Stmt
  | [] => skip
  | a::rest => .seq a (chain rest)
inductive Exec : Stmt → State → Result → Prop where
  | base (code : C99ModularReference.Stmt) (before : State) (out : Result)
      (source : C99ModularReference.Exec code before out) : Exec (.base code) before out
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (first : Exec a before ⟨middle,.normal⟩) (second : Exec b middle out) : Exec (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result)
      (first : Exec a before out) (exit : out.flow≠.normal) : Exec (.seq a b) before out
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (out : Result)
      (source : Exec body before out) : Exec (.scope locals pointers body) before
        ⟨restoreScope before out.state locals pointers,out.flow⟩
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (source : Exec yes before out) : Exec (.branch condition yes no) before out
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0)
      (source : Exec no before out) : Exec (.branch condition yes no) before out
  | loopFalse (condition : CLogic.Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0) :
      Exec (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State)
      (out : Result) (v : Value) (guard : C99ArrayReference.scalar before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨middle,.normal⟩)
      (update : Exec increment middle ⟨next,.normal⟩) (rest : Exec (.loop condition body increment) next out) :
      Exec (.loop condition body increment) before out
  | loopReturn (condition : CLogic.Expr) (body increment : Stmt) (before after : State)
      (v : Value) (ret : Option Value) (guard : C99ArrayReference.scalar before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨after,.returned ret⟩) :
      Exec (.loop condition body increment) before ⟨after,.returned ret⟩
def only (names : List Name) : Stmt → Bool
  | .base code => KeygenLevelModularFrame.only names code
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ _ code => only names code
theorem frame (code : Stmt) (before : State) (out : Result) (source : Exec code before out)
    (names : List Name) (checked : only names code=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | base code before out source => exact KeygenLevelModularFrame.body_frame code before out source names checked block offset outside
  | seqNormal a b before middle out first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out first exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | scope locals pointers body before out source ih =>
    obtain ⟨ho,ht,hf⟩ := ih checked outside
    exact ⟨C99PointerFootprint.restore_outside before out.state locals pointers names block offset outside ho,ht,hf⟩
  | branchTrue condition yes no before out v guard nonzero source ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | branchFalse condition yes no before out v guard zero source ih => exact ih (Bool.and_eq_true_iff.mp checked).2 outside
  | loopFalse => exact ⟨outside,rfl,rfl⟩
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa
    obtain ⟨oc,tc,fc⟩ := ih3 checked ob
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside

def simple (ctx : List Name) : List Token → Option (Stmt×List Name×List Token)
  | [';']::rest => some (skip,ctx,rest)
  | dst::['=']::['R','E','V','1','0']::['[']::rest => do
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::[';']::rest => pure (.base (.base (.assign dst (.load16 false "REV10".toList index))),ctx,rest)
    | _ => none
  | dst::['=']::src::['=']::rest => do
    let (e,rest) ← C99ModularParser.expr 32 rest
    match rest with
    | [';']::rest => pure (.seq (.base (.assign src e))
      (.base (.assign dst (.scalar (.var src)))),ctx,rest)
    | _ => none
  | rest => do
    let (code,ctx,rest) ← C99ModularParser.simple ctx rest
    pure (.base code,ctx,rest)
def baseDeclarations : C99ModularReference.Stmt → List Name×List Name
  | .base (.scalar (.declare _ names)) => (names,[])
  | .base (.declarePtr name) => ([],[name])
  | .seq a b => ((baseDeclarations a).1++(baseDeclarations b).1,
    (baseDeclarations a).2++(baseDeclarations b).2)
  | _ => ([],[])
def declarations : Stmt → List Name×List Name
  | .base code => baseDeclarations code
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
        pure (.seq (.base initial) (.loop condition inner (.base update)),ctx,rest)
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
inductive Kind where | generate | forward | inverse
  deriving DecidableEq, Repr
def params : Kind → List Param
  | .generate => [.pointer "gm".toList,.pointer "igm".toList,.scalar .uint32 "logn".toList,
    .scalar .uint32 "g".toList,.scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList]
  | .forward => [.pointer "a".toList,.scalar .uint64 "stride".toList,.pointer "gm".toList,
    .scalar .uint32 "logn".toList,.scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList]
  | .inverse => [.pointer "a".toList,.scalar .uint64 "stride".toList,.pointer "igm".toList,
    .scalar .uint32 "logn".toList,.scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList]
def writable : Kind → List Name
  | .generate => ["gm".toList,"igm".toList]
  | .forward => ["a".toList,"r1".toList,"r2".toList]
  | .inverse => ["a".toList,"r".toList,"r1".toList,"r2".toList]
def region (kind : Kind) (start count : Nat) : Option Stmt := do
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← C99ProcedureParser.tokens text
  let (code,_,rest) ← body (writable kind) 512 lexed
  if rest.isEmpty then pure code else none
def parsed : Kind → Nat → Option Stmt
  | .generate,0 => region .generate 2779 4
  | .generate,1 => region .generate 2783 12
  | .generate,2 => region .generate 2795 3
  | .generate,3 => region .generate 2798 9
  | .forward,0 => region .forward 2817 2
  | .forward,1 => region .forward 2819 5
  | .forward,2 => region .forward 2824 23
  | .inverse,0 => region .inverse 2856 4
  | .inverse,1 => region .inverse 2860 5
  | .inverse,2 => region .inverse 2865 25
  | .inverse,3 => region .inverse 2890 11
  | _,_ => none
def part (kind : Kind) (index : Nat) : Stmt := (parsed kind index).getD skip
def code : Kind → Stmt
  | .generate => chain [part .generate 0,part .generate 1,part .generate 2,part .generate 3]
  | .forward => chain [part .forward 0,part .forward 1,part .forward 2]
  | .inverse => chain [part .inverse 0,part .inverse 1,part .inverse 2,part .inverse 3]
def lines := KeygenLevelNtt.region
theorem generator_header : lines 2775 4=["static void\n",
    "modp_mkgm2(uint32_t *restrict gm, uint32_t *restrict igm, unsigned logn,\n",
    "\tuint32_t g, uint32_t p, uint32_t p0i)\n","{\n"] := by decide
theorem generator_close : Pinned.keygenLines[2806]?=some "}\n" := by decide
theorem forward_header : lines 2813 4=["static void\n",
    "modp_NTT2_ext(uint32_t *a, size_t stride, const uint32_t *gm, unsigned logn,\n",
    "\tuint32_t p, uint32_t p0i)\n","{\n"] := by decide
theorem forward_close : Pinned.keygenLines[2846]?=some "}\n" := by decide
theorem inverse_header : lines 2852 4=["static void\n",
    "modp_iNTT2_ext(uint32_t *a, size_t stride, const uint32_t *igm, unsigned logn,\n",
    "\tuint32_t p, uint32_t p0i)\n","{\n"] := by decide
theorem inverse_close : Pinned.keygenLines[2900]?=some "}\n" := by decide
theorem wrappers : lines 2907 2=[
    "#define modp_NTT2(a, gm, logn, p, p0i)   modp_NTT2_ext(a, 1, gm, logn, p, p0i)\n",
    "#define modp_iNTT2(a, igm, logn, p, p0i) modp_iNTT2_ext(a, 1, igm, logn, p, p0i)\n"] := by decide
theorem rev_type : Pinned.keygenLines[2672]?=some "static const uint16_t REV10[] = {\n" := by decide
theorem generator_partition : lines 2779 28=lines 2779 4 ++ lines 2783 12 ++ lines 2795 3 ++ lines 2798 9 := by decide
theorem forward_partition : lines 2817 30=lines 2817 2 ++ lines 2819 5 ++ lines 2824 23 := by decide
theorem inverse_partition : lines 2856 45=lines 2856 4 ++ lines 2860 5 ++ lines 2865 25 ++ lines 2890 11 := by decide
def audit (kind : Kind) (index : Nat) : Option Bool := (parsed kind index).map (only (writable kind))
theorem generate_audit0 : audit .generate 0=some true := by decide
theorem generate_audit1 : audit .generate 1=some true := by decide
theorem generate_audit2 : audit .generate 2=some true := by decide
theorem generate_audit3 : audit .generate 3=some true := by decide
theorem forward_audit0 : audit .forward 0=some true := by decide
theorem forward_audit1 : audit .forward 1=some true := by decide
theorem forward_audit2 : audit .forward 2=some true := by decide
theorem inverse_audit0 : audit .inverse 0=some true := by decide
theorem inverse_audit1 : audit .inverse 1=some true := by decide
theorem inverse_audit2 : audit .inverse 2=some true := by decide
theorem inverse_audit3 : audit .inverse 3=some true := by decide
theorem parsed_part (kind : Kind) (index : Nat) (h : audit kind index=some true) : parsed kind index=some (part kind index) := by
  cases hp : parsed kind index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (kind : Kind) (index : Nat) (h : audit kind index=some true) : only (writable kind) (part kind index)=true := by
  have parsed := parsed_part kind index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
theorem only_skip (names : List Name) : only names skip=true := rfl
theorem code_checked : ∀ kind, only (writable kind) (code kind)=true := by
  intro kind
  cases kind with
  | generate =>
    show only (writable .generate) (.seq (part .generate 0) (.seq (part .generate 1)
      (.seq (part .generate 2) (.seq (part .generate 3) skip))))=true
    rw [only_seq,only_seq,only_seq,only_seq,only_skip,
      part_checked .generate 0 generate_audit0,part_checked .generate 1 generate_audit1,
      part_checked .generate 2 generate_audit2,part_checked .generate 3 generate_audit3]
    decide
  | forward =>
    show only (writable .forward) (.seq (part .forward 0) (.seq (part .forward 1) (.seq (part .forward 2) skip)))=true
    rw [only_seq,only_seq,only_seq,only_skip,
      part_checked .forward 0 forward_audit0,part_checked .forward 1 forward_audit1,part_checked .forward 2 forward_audit2]
    decide
  | inverse =>
    show only (writable .inverse) (.seq (part .inverse 0) (.seq (part .inverse 1)
      (.seq (part .inverse 2) (.seq (part .inverse 3) skip))))=true
    rw [only_seq,only_seq,only_seq,only_seq,only_skip,
      part_checked .inverse 0 inverse_audit0,part_checked .inverse 1 inverse_audit1,
      part_checked .inverse 2 inverse_audit2,part_checked .inverse 3 inverse_audit3]
    decide
inductive Call (kind : Kind) (before : State) (args : List KeygenLevelCalls.Arg) : State → Prop where
  | run (entry : State) (out : Result) (binding : KeygenLevelCalls.Bind before (params kind) args entry)
      (source : Exec (code kind) entry out) (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Call kind before args {before with heap := out.state.heap}
theorem call_frame (kind : Kind) (before after : State) (args : List KeygenLevelCalls.Arg)
    (source : Call kind before args after) (names : List Name) (block offset : Nat)
    (allowed : KeygenLevelCalls.arguments names (writable kind) (params kind) args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out binding execution returned =>
    obtain ⟨ho,_⟩ := KeygenLevelCalls.bind_outside before entry (params kind) args binding
      names (writable kind) allowed block offset outside tables
    have keep := (frame (code kind) entry out execution (writable kind) (code_checked kind) block offset ho).2.2
    rw [KeygenLevelCalls.bind_heap before entry (params kind) args binding] at keep
    exact keep

end FT1536.Source3.KeygenBinaryNtt
