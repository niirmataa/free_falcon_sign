import Source3.KeygenIntermediateCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Natural semantics of intermediate's control/word/pointer language.
   Break, continue, return and loop updates have separate actual outcomes.
   The footprint invariant is object separation, allowing the fixed
   quadratic subtraction's backward pointer operations. -/
namespace FT1536.Source3.KeygenIntermediateExec
open C99ArrayReference (State Name bindValue bindPointer restoreScope)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenIntermediateCalls (Expr Eval Kind Arg Call TableBlocks)
open KeygenIntermediateMemory (Blocks)

inductive Stmt where
  | skip
  | scalar (code : CLogic.Stmt)
  | declarePtr (name : Name)
  | pointer (name : Name) (value : KeygenIntermediateMemory.Expr)
  | assign (name : Name) (value : Expr)
  | store (name : Name) (index : CLogic.Expr) (value : Expr)
  | move (dst src : KeygenIntermediateMemory.Expr) (count : CLogic.Expr)
  | call (kind : Kind) (args : List Arg) (dst : KeygenZintCall.CDest)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : Expr) (yes no : Stmt)
  | loop (condition : Expr) (body increment : Stmt)
  | ret (value : Expr)
  | breakLoop | continueLoop
  deriving DecidableEq, Repr
def chain : List Stmt → Stmt
  | [] => .skip
  | a::rest => .seq a (chain rest)
def clearPointer (before : State) (name : Name) : State :=
  {before with arrays := fun n => if n=name then none else before.arrays n}
inductive Exec (ctx : Context) : Stmt → State → Result → Prop where
  | skip (s : State) : Exec ctx .skip s ⟨s,.normal⟩
  | scalar (code : CLogic.Stmt) (before : State) (env : C99ScalarReference.Env)
      (source : C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalar code) (.normal env)) :
      Exec ctx (.scalar code) before ⟨{before with locals := env},.normal⟩
  | declarePtr (name : Name) (before : State) : Exec ctx (.declarePtr name) before ⟨clearPointer before name,.normal⟩
  | pointer (name : Name) (e : KeygenIntermediateMemory.Expr) (before : State) (p : ArrayPointer)
      (source : KeygenIntermediateMemory.Eval ctx before e p) : Exec ctx (.pointer name e) before ⟨bindPointer before name p,.normal⟩
  | assign (name : Name) (e : Expr) (before : State) (ty : Ty) (old : Option Value) (v : Value)
      (declared : before.locals name=some (ty,old)) (source : Eval ctx before e v) :
      Exec ctx (.assign name e) before ⟨bindValue before name ty v,.normal⟩
  | store (name : Name) (index : CLogic.Expr) (e : Expr) (before : State) (after : Memory) (p : ArrayPointer) (v : Value)
      (address : C99ArrayReference.Pointer before name index p) (value : Eval ctx before e v)
      (write : Store32 before.heap p (BitVec.ofInt 32 v.integer) after) :
      Exec ctx (.store name index e) before ⟨{before with heap := after},.normal⟩
  | move (dst src : KeygenIntermediateMemory.Expr) (count : CLogic.Expr) (before : State) (after : Memory)
      (p q : ArrayPointer) (word : BitVec 64) (destination : KeygenIntermediateMemory.Eval ctx before dst p)
      (source : KeygenIntermediateMemory.Eval ctx before src q)
      (length : C99ArrayReference.scalar before count (.uint64 word))
      (copy : KeygenSearchMemory.Memmove before.heap p q word.toNat after) :
      Exec ctx (.move dst src count) before ⟨{before with heap := after},.normal⟩
  | call (kind : Kind) (args : List Arg) (dst : KeygenZintCall.CDest) (before middle after : State) (v : Option Value)
      (source : Call ctx kind before args middle v) (receive : KeygenZintCall.ReceiveC dst middle v after) :
      Exec ctx (.call kind args dst) before ⟨after,.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (first : Exec ctx a before ⟨middle,.normal⟩) (second : Exec ctx b middle out) : Exec ctx (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result)
      (first : Exec ctx a before out) (exit : out.flow≠.normal) : Exec ctx (.seq a b) before out
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (out : Result)
      (source : Exec ctx body before out) : Exec ctx (.scope locals pointers body) before ⟨restoreScope before out.state locals pointers,out.flow⟩
  | branchTrue (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : Eval ctx before condition v) (nonzero : v.integer≠0)
      (source : Exec ctx yes before out) : Exec ctx (.branch condition yes no) before out
  | branchFalse (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : Eval ctx before condition v) (zero : v.integer=0)
      (source : Exec ctx no before out) : Exec ctx (.branch condition yes no) before out
  | loopFalse (condition : Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : Eval ctx before condition v) (zero : v.integer=0) : Exec ctx (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : Expr) (body increment : Stmt) (before middle next : State) (out : Result) (v : Value)
      (guard : Eval ctx before condition v) (nonzero : v.integer≠0)
      (iteration : Exec ctx body before ⟨middle,.normal⟩) (update : Exec ctx increment middle ⟨next,.normal⟩)
      (rest : Exec ctx (.loop condition body increment) next out) : Exec ctx (.loop condition body increment) before out
  | loopContinue (condition : Expr) (body increment : Stmt) (before middle next : State) (out : Result) (v : Value)
      (guard : Eval ctx before condition v) (nonzero : v.integer≠0)
      (iteration : Exec ctx body before ⟨middle,.continueLoop⟩) (update : Exec ctx increment middle ⟨next,.normal⟩)
      (rest : Exec ctx (.loop condition body increment) next out) : Exec ctx (.loop condition body increment) before out
  | loopReturn (condition : Expr) (body increment : Stmt) (before after : State) (v : Value) (ret : Option Value)
      (guard : Eval ctx before condition v) (nonzero : v.integer≠0)
      (iteration : Exec ctx body before ⟨after,.returned ret⟩) : Exec ctx (.loop condition body increment) before ⟨after,.returned ret⟩
  | loopBreak (condition : Expr) (body increment : Stmt) (before after : State) (v : Value)
      (guard : Eval ctx before condition v) (nonzero : v.integer≠0)
      (iteration : Exec ctx body before ⟨after,.breakLoop⟩) : Exec ctx (.loop condition body increment) before ⟨after,.normal⟩
  | ret (e : Expr) (before : State) (v : Value) (source : Eval ctx before e v) : Exec ctx (.ret e) before ⟨before,.returned (some v)⟩
  | breakLoop (before : State) : Exec ctx .breakLoop before ⟨before,.breakLoop⟩
  | continueLoop (before : State) : Exec ctx .continueLoop before ⟨before,.continueLoop⟩
def only (names : List Name) : Stmt → Bool
  | .skip | .scalar _ | .declarePtr _ | .assign _ _ | .ret _ | .breakLoop | .continueLoop => true
  | .pointer _ e => KeygenIntermediateMemory.only names e
  | .store name _ _ => names.contains name
  | .move dst _ _ => KeygenIntermediateMemory.only names dst
  | .call kind args dst => KeygenIntermediateCalls.arguments names (KeygenIntermediateCalls.writable kind)
      (KeygenIntermediateCalls.params kind) args && KeygenZintCall.destOnly names dst
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ _ body => only names body
theorem blocks_outside (s : State) (names : List Name) (block offset : Nat) (source : Blocks s names block) :
    C99ArrayFrame.Outside s names block offset := fun n hn p hp => Or.inl (source n hn p hp)
theorem frame (ctx : Context) (body : Stmt) (before : State) (out : Result) (source : Exec ctx body before out)
    (names : List Name) (checked : only names body=true) (block offset : Nat)
    (outside : Blocks before names block) (tables : TableBlocks before block) (scratch : block≠ctx.scratch.block) :
    Blocks out.state names block ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | skip | scalar | assign | loopFalse | ret | breakLoop | continueLoop => exact ⟨outside,rfl,rfl⟩
  | declarePtr name before =>
    refine ⟨?_,rfl,rfl⟩
    intro n hn p hp
    by_cases he : n=name
    · simp [clearPointer,he] at hp
    · exact outside n hn p (by simpa [clearPointer,he] using hp)
  | pointer name e before p source =>
    have ho := KeygenIntermediateMemory.eval_block ctx before e p source names checked block outside scratch
    refine ⟨?_,rfl,rfl⟩
    intro n hn q hq
    by_cases he : n=name
    · have hpq : p=q := Option.some.inj (by simpa [bindPointer,he] using hq)
      subst q
      exact ho
    · exact outside n hn q (by simpa [bindPointer,he] using hq)
  | store name index e before after p v address value write =>
    exact ⟨outside,rfl,write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names name index p 4 address (List.contains_iff_mem.mp checked)
        write.1 write.2.1 block offset (blocks_outside _ _ _ _ outside))⟩
  | move dst src count before after p q word destination source length copy =>
    have ho := KeygenIntermediateMemory.eval_block ctx before dst p destination names checked block outside scratch
    exact ⟨outside,rfl,KeygenSearchMemory.memmove_frame before.heap after p q word.toNat block offset copy (Or.inl ho)⟩
  | call kind args dst before middle after v source receive =>
    obtain ⟨hc,hd⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨ha,ht,hf⟩ := KeygenIntermediateCalls.call_frame ctx kind before middle args v source names block offset hc outside tables scratch
    have om : Blocks middle names block := by simpa only [Blocks,ha] using outside
    have keep := (KeygenZintCall.receive_bytes dst middle after v receive names hd block offset
      (blocks_outside _ _ _ _ om)).2
    have arrays : after.arrays=middle.arrays := by cases receive <;> rfl
    refine ⟨?_,(KeygenZintCall.receive_tables dst middle after v receive).trans ht,keep.trans hf⟩
    simpa only [Blocks,arrays] using om
  | seqNormal a b before middle out first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa (by simpa only [TableBlocks,KeygenZintScaled.TableBlocks,ta] using tables)
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out first exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | scope locals pointers body before out source ih =>
    obtain ⟨ho,ht,hf⟩ := ih checked outside tables
    refine ⟨?_,ht,hf⟩
    intro n hn p hp
    dsimp [restoreScope] at hp
    split at hp
    · exact outside n hn p hp
    · exact ho n hn p hp
  | branchTrue condition yes no before out v guard nonzero source ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | branchFalse condition yes no before out v guard zero source ih => exact ih (Bool.and_eq_true_iff.mp checked).2 outside tables
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3
  | loopContinue condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa (by simpa only [TableBlocks,KeygenZintScaled.TableBlocks,ta] using tables)
    change next.tables=middle.tables at tb
    obtain ⟨oc,tc,fc⟩ := ih3 checked ob (by simpa only [TableBlocks,KeygenZintScaled.TableBlocks,tb,ta] using tables)
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | loopBreak condition body increment before after v guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables

end FT1536.Source3.KeygenIntermediateExec
