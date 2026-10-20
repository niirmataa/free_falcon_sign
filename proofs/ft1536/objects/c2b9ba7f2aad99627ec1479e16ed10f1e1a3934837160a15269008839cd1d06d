import Source3.KeygenIntermediateSource
import Source3.KeygenDepth0Call
import Source3.KeygenDeepestSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The M0 root search prefix. Every call is the complete fixed source body.
   The two dispatch tests are actual C evaluations; the inactive small-logn
   and binary arms remain pinned source and are excluded by the M0 profile.
   The post-decrement takes effect even on the final false test. -/
namespace FT1536.Source3.KeygenRootSearch
open C99ArrayReference (State Name bindValue restoreScope)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

def lines := KeygenLevelNtt.region
def tokens (start count : Nat) : Option (List B20.C.Token) :=
  KeygenZintCall.tokens ((lines start count).flatMap String.toList)
def lex (s : String) : Option (List B20.C.Token) := KeygenZintCall.tokens s.toList
theorem header : lines 7278 4 = ["static int\n",
    "solve_NTRU(falcon_keygen *fk, int16_t *F, int16_t *G,\n",
    "\tconst int16_t *f, const int16_t *g)\n","{\n"] := by decide
theorem declarations_source : tokens 7282 6 = lex
    "unsigned logn; size_t n, u; uint32_t *ft, *gt, *Ft, *Gt, *gm; uint32_t p, p0i, r; const small_prime *primes;" := by decide +kernel
theorem initialization_source : tokens 7288 2 = lex "logn = fk->logn; n = MKN(logn, fk->ternary);" := by decide
theorem deepest_source : tokens 7290 11 = lex "if (!solve_NTRU_deepest(fk, f, g)) { return 0; }" := by decide
theorem dispatch_source : tokens 7301 14 = lex
    "if (logn <= 2) { unsigned depth; depth = logn; while (depth -- > 0) { if (!solve_NTRU_intermediate(fk, f, g, depth)) { return 0; } } } else { unsigned depth; depth = logn; if (fk->ternary) {" := by decide +kernel
theorem loop_source : tokens 7315 5 = lex
    "while (depth -- > 1) { if (!solve_NTRU_intermediate(fk, f, g, depth)) { return 0; } }" := by decide
theorem depth0_source : tokens 7320 3 = lex "if (!solve_NTRU_ternary_depth0(fk, f, g)) { return 0; }" := by decide
theorem inactive_binary_source : tokens 7323 14 = lex
    "} else { while (depth -- > 2) { if (!solve_NTRU_intermediate(fk, f, g, depth)) { return 0; } } if (!solve_NTRU_binary_depth1(fk, f, g)) { return 0; } if (!solve_NTRU_binary_depth0(fk, f, g)) { return 0; } } }" := by decide +kernel
theorem partition : lines 7282 55 = lines 7282 6 ++ lines 7288 2 ++ lines 7290 11 ++
    lines 7301 14 ++ lines 7315 5 ++ lines 7320 3 ++ lines 7323 14 := by decide

def declared (s : State) : State :=
  let s := C99DeclarationStatements.effect .u32 ["logn".toList] s
  let s := C99DeclarationStatements.effect .u64 ["n".toList,"u".toList] s
  let s := {s with arrays := fun name => if (["ft","gt","Ft","Gt","gm"].map String.toList).contains name then none else s.arrays name}
  let s := C99DeclarationStatements.effect .u32 ["p".toList,"p0i".toList,"r".toList] s
  {s with arrays := fun name => if name="primes".toList then none else s.arrays name}
def logged (s : State) (word : BitVec 32) : State := bindValue (declared s) "logn".toList .uint32 (.uint32 word)
def view (s : State) (word : BitVec 32) : State := bindValue s "ter".toList .uint32 (.uint32 word)
def sizeExpr : CLogic.Expr := C99ArrayParser.mkn (.var "logn".toList) (.var "ter".toList)
def ready (s : State) : State := bindValue (logged s 10) "n".toList .uint64 (.uint64 1536)
inductive Start (ctx : Context) (before : State) : State → Prop where
  | run (logn ternary : BitVec 32) (n : Value)
      (lognRead : KeygenSearchContext.ReadLogn ctx (declared before) logn)
      (ternaryRead : KeygenSearchContext.ReadTernary ctx (logged before logn) ternary)
      (size : C99ArrayReference.scalar (view (logged before logn) ternary) sizeExpr n) :
      Start ctx before (bindValue (logged before logn) "n".toList .uint64 n)
theorem start_m0 (ctx : Context) (before after : State) (profile : KeygenSearchContext.M0 before.heap ctx)
    (source : Start ctx before after) : after=ready before := by
  cases source with
  | run logn ternary n lognRead ternaryRead size =>
    have hl := KeygenSearchContext.logn_m0 ctx (declared before) logn profile lognRead
    subst logn
    have ht := KeygenSearchContext.ternary_m0 ctx (logged before 10) ternary profile ternaryRead
    subst ternary
    have hn := KeygenSmallBounds.mkn_value (view (logged before 10) 1) n ⟨rfl,rfl⟩ size
    simp only [bindValue,hn,ready]
    rfl

inductive Kind where | deepest | intermediate | depth0
  deriving DecidableEq, Repr
def Call (ctx : Context) : Kind → State → State → Value → Prop
  | .deepest => KeygenDeepestSource.Call ctx
  | .intermediate => KeygenIntermediateSource.Call ctx
  | .depth0 => KeygenDepth0Call.Call ctx
def Protected := KeygenIntermediateSource.Protected
theorem call_slots (ctx : Context) (kind : Kind) (before after : State) (v : Value)
    (source : Call ctx kind before after v) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  cases kind with
  | deepest => exact KeygenDeepestSource.slots ctx before after v source
  | intermediate => exact KeygenIntermediateSource.slots ctx before after v source
  | depth0 => exact KeygenDepth0Call.slots ctx before after v source
theorem call_bytes (ctx : Context) (kind : Kind) (before after : State) (v : Value)
    (source : Call ctx kind before after v) (block : Nat) (separate : Protected ctx before block) :
    ∀ offset, after.heap.bytes block offset=before.heap.bytes block offset := by
  cases kind with
  | deepest => exact KeygenDeepestSource.call_frame ctx before after v source block separate
  | intermediate => exact KeygenIntermediateSource.call_frame ctx before after v source block separate
  | depth0 => exact KeygenDepth0Call.frame ctx before after v source block separate
inductive Gate (ctx : Context) (kind : Kind) (before : State) : Result → Prop where
  | accept (after : State) (v : Value) (source : Call ctx kind before after v) (nonzero : v.integer≠0) :
      Gate ctx kind before ⟨after,.normal⟩
  | reject (after : State) (v : Value) (source : Call ctx kind before after v) (zero : v.integer=0) :
      Gate ctx kind before ⟨after,.returned (some (.int32 0))⟩
theorem gate_frame (ctx : Context) (kind : Kind) (before : State) (out : Result)
    (source : Gate ctx kind before out) (block : Nat) (separate : Protected ctx before block) :
    out.state.locals=before.locals ∧ out.state.arrays=before.arrays ∧ out.state.tables=before.tables ∧
    ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | accept after v source nonzero | reject after v source zero =>
    obtain ⟨hl,ha,ht⟩ := call_slots ctx kind before after v source
    exact ⟨hl,ha,ht,call_bytes ctx kind before after v source block separate⟩

inductive Post (before : State) : State → Value → Prop where
  | run (old next test : Value)
      (read : C99ArrayReference.scalar before (.var "depth".toList) old)
      (declared : ∃ previous, before.locals "depth".toList=some (.uint32,previous))
      (decrement : C99IntegerReference.ArithmeticExec .minus old (.int32 1) next)
      (compare : C99IntegerReference.CompareExec .gt old (.int32 1) test) :
      Post before (bindValue before "depth".toList .uint32 next) test
theorem post_frame (before after : State) (v : Value) (source : Post before after v) :
    after.heap=before.heap ∧ after.arrays=before.arrays ∧ after.tables=before.tables ∧
    ∀ name, name≠"depth".toList → after.locals name=before.locals name := by
  cases source
  exact ⟨rfl,rfl,rfl,fun name h => by simp only [bindValue,C99ScalarReference.set,h,ite_false]⟩
inductive Loop (ctx : Context) : State → Result → Prop where
  | done (before next : State) (v : Value) (test : Post before next v) (zero : v.integer=0) :
      Loop ctx before ⟨next,.normal⟩
  | step (before next middle : State) (out : Result) (v : Value)
      (test : Post before next v) (nonzero : v.integer≠0)
      (body : Gate ctx .intermediate next ⟨middle,.normal⟩) (rest : Loop ctx middle out) : Loop ctx before out
  | reject (before next after : State) (v : Value) (test : Post before next v) (nonzero : v.integer≠0)
      (body : Gate ctx .intermediate next ⟨after,.returned (some (.int32 0))⟩) :
      Loop ctx before ⟨after,.returned (some (.int32 0))⟩
theorem loop_frame (ctx : Context) (before : State) (out : Result) (source : Loop ctx before out)
    (block : Nat) (separate : Protected ctx before block) :
    out.state.arrays=before.arrays ∧ out.state.tables=before.tables ∧
    (∀ name, name≠"depth".toList → out.state.locals name=before.locals name) ∧
    ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | done before next v test zero =>
    obtain ⟨hh,ha,ht,hl⟩ := post_frame before next v test
    exact ⟨ha,ht,hl,fun offset => congrArg (fun h : Memory => h.bytes block offset) hh⟩
  | step before next middle out v test nonzero body rest ih =>
    obtain ⟨hh,ha,ht,hl⟩ := post_frame before next v test
    have hn : Protected ctx next block := ⟨separate.1,by simpa only [ht] using separate.2⟩
    obtain ⟨gl,ga,gt,gf⟩ := gate_frame ctx .intermediate next ⟨middle,.normal⟩ body block hn
    change middle.tables=next.tables at gt
    obtain ⟨ra,rt,rl,rf⟩ := ih ⟨hn.1,by simpa only [gt] using hn.2⟩
    exact ⟨ra.trans (ga.trans ha),rt.trans (gt.trans ht),fun n h => (rl n h).trans ((congrFun gl n).trans (hl n h)),
      fun offset => (rf offset).trans ((gf offset).trans (congrArg (fun h : Memory => h.bytes block offset) hh))⟩
  | reject before next after v test nonzero body =>
    obtain ⟨hh,ha,ht,hl⟩ := post_frame before next v test
    obtain ⟨gl,ga,gt,gf⟩ := gate_frame ctx .intermediate next ⟨after,.returned (some (.int32 0))⟩ body block
      ⟨separate.1,by simpa only [ht] using separate.2⟩
    exact ⟨ga.trans ha,gt.trans ht,fun n h => (congrFun gl n).trans (hl n h),
      fun offset => (gf offset).trans (congrArg (fun h : Memory => h.bytes block offset) hh)⟩

def depthEntry (before : State) (v : Value) : State :=
  bindValue (C99DeclarationStatements.effect .u32 ["depth".toList] before) "depth".toList .uint32 v
def smallTest : CLogic.Expr := .cmp .le (.var "logn".toList) (.literal .i32 2)
inductive DepthBody (ctx : Context) (before : State) : Result → Prop where
  | reject (after : State) (source : Loop ctx before ⟨after,.returned (some (.int32 0))⟩) :
      DepthBody ctx before ⟨after,.returned (some (.int32 0))⟩
  | last (middle : State) (out : Result) (source : Loop ctx before ⟨middle,.normal⟩)
      (depth0 : Gate ctx .depth0 middle out) : DepthBody ctx before out
theorem depth_body_frame (ctx : Context) (before : State) (out : Result) (source : DepthBody ctx before out)
    (block : Nat) (separate : Protected ctx before block) :
    out.state.arrays=before.arrays ∧ out.state.tables=before.tables ∧
    (∀ name, name≠"depth".toList → out.state.locals name=before.locals name) ∧
    ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | reject after source => exact loop_frame ctx before _ source block separate
  | last middle out source depth0 =>
    obtain ⟨ha,ht,hl,hf⟩ := loop_frame ctx before _ source block separate
    change middle.tables=before.tables at ht
    obtain ⟨gl,ga,gt,gf⟩ := gate_frame ctx .depth0 middle out depth0 block
      ⟨separate.1,by simpa only [ht] using separate.2⟩
    exact ⟨ga.trans ha,gt.trans ht,fun n h => (congrFun gl n).trans (hl n h),
      fun offset => (gf offset).trans (hf offset)⟩
inductive Dispatch (ctx : Context) (before : State) : Result → Prop where
  | run (test logn : Value) (ternary : BitVec 32) (out : Result)
      (small : C99ArrayReference.scalar before smallTest test) (large : test.integer=0)
      (read : C99ArrayReference.scalar before (.var "logn".toList) logn)
      (member : KeygenSearchContext.ReadTernary ctx (depthEntry before logn) ternary)
      (isTernary : ternary.toNat≠0) (source : DepthBody ctx (depthEntry before logn) out) :
      Dispatch ctx before ⟨restoreScope before out.state ["depth".toList] [],out.flow⟩
theorem dispatch_frame (ctx : Context) (before : State) (out : Result) (source : Dispatch ctx before out)
    (block : Nat) (separate : Protected ctx before block) :
    out.state.locals=before.locals ∧ out.state.arrays=before.arrays ∧ out.state.tables=before.tables ∧
    ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run test logn ternary out small large read member isTernary source =>
    obtain ⟨ha,ht,hl,hf⟩ := depth_body_frame ctx (depthEntry before logn) out source block separate
    refine ⟨?_,ha,ht,hf⟩
    funext name
    by_cases he : name="depth".toList
    · subst name; rfl
    · have absent : ["depth".toList].contains name=false := by
        cases hv : ["depth".toList].contains name with
        | false => rfl
        | true => exact (he (List.mem_singleton.mp (List.contains_iff_mem.mp hv))).elim
      change C99ScalarReference.restore before.locals out.state.locals ["depth".toList] name=before.locals name
      simp only [C99ScalarReference.restore,absent,Bool.false_eq_true,ite_false]
      simpa only [depthEntry,bindValue,C99ScalarReference.set,C99DeclarationStatements.effect,
        C99DeclarationCells.declareCells,he,ite_false] using hl name he

inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | deepestRejected (ready after : State) (start : Start ctx before ready)
      (deepest : Gate ctx .deepest ready ⟨after,.returned (some (.int32 0))⟩) :
      Exec ctx before ⟨after,.returned (some (.int32 0))⟩
  | searched (ready deep : State) (out : Result) (start : Start ctx before ready)
      (deepest : Gate ctx .deepest ready ⟨deep,.normal⟩)
      (dispatch : Dispatch ctx deep out) : Exec ctx before out

theorem frame (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (profile : KeygenSearchContext.M0 before.heap ctx) (block : Nat) (separate : Protected ctx before block) :
    out.state.locals=(ready before).locals ∧ out.state.arrays=(ready before).arrays ∧
    out.state.tables=before.tables ∧ ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | deepestRejected entry after start deepest =>
    have he := start_m0 ctx before entry profile start
    subst entry
    exact gate_frame ctx .deepest (ready before) _ deepest block separate
  | searched entry deep out start deepest dispatch =>
    have he := start_m0 ctx before entry profile start
    subst entry
    obtain ⟨dl,da,dt,df⟩ := gate_frame ctx .deepest (ready before) _ deepest block separate
    change deep.tables=before.tables at dt
    obtain ⟨il,ia,it,ifrm⟩ := dispatch_frame ctx deep _ dispatch block ⟨separate.1,by simpa only [dt] using separate.2⟩
    exact ⟨il.trans dl,ia.trans da,it.trans dt,fun offset => (ifrm offset).trans (df offset)⟩
theorem material (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (profile : KeygenSearchContext.M0 before.heap ctx) (input : ArrayPointer) (separate : Protected ctx before input.block)
    (vector : Geometry.Vec) (represented : KeygenMaterial.Represents before.heap input vector) :
    KeygenMaterial.Represents out.state.heap input vector := by
  have keep := (frame ctx before out source profile input.block separate).2.2.2
  intro i
  exact ⟨fun byte => (keep _).trans ((represented i).1 byte),fun byte => (keep _).trans ((represented i).2 byte)⟩
theorem output_caller (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (profile : KeygenSearchContext.M0 before.heap ctx) (F G : ArrayPointer)
    (first : before.arrays "F".toList=some F) (second : before.arrays "G".toList=some G)
    (block : Nat) (separate : Protected ctx before block) : KeygenOutputGateBounds.Caller out.state F G := by
  obtain ⟨hl,ha,_,_⟩ := frame ctx before out source profile block separate
  exact ⟨(congrFun hl _).trans rfl,(congrFun hl _).trans rfl,
    (congrFun ha _).trans first,(congrFun ha _).trans second⟩

end FT1536.Source3.KeygenRootSearch
