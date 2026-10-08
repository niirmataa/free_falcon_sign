import Source3.KeygenLevelCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenLevelExec
open C99ArrayReference (State Name Pointer bindValue restoreScope)
open C99ProcedureReference (Result)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open KeygenLevelCalls (Kind Arg)

inductive Stmt where
  | modular (body : C99ModularReference.Stmt)
  | prime (dst src : Name) (index : CLogic.Expr) (field : KeygenLevelCalls.Field)
  | call (kind : Kind) (args : List Arg)
  | move (dst src : Name) (di si count : CLogic.Expr)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  deriving DecidableEq, Repr
def skip : Stmt := .modular (.base .skip)
def chain : List Stmt → Stmt
  | [] => skip
  | s::ss => .seq s (chain ss)
inductive Exec : Stmt → State → Result → Prop where
  | modular (code : C99ModularReference.Stmt) (before : State) (out : Result)
      (source : C99ModularReference.Exec code before out) : Exec (.modular code) before out
  | prime (dst src : Name) (index : CLogic.Expr) (field : KeygenLevelCalls.Field)
      (before : State) (ty : Ty) (old : Option Value) (v : Value)
      (declared : before.locals dst=some (ty,old)) (source : KeygenLevelCalls.PrimeRead before src index field v) :
      Exec (.prime dst src index field) before ⟨bindValue before dst ty v,.normal⟩
  | call (kind : Kind) (args : List Arg) (before after : State) (source : KeygenLevelCalls.Call kind before args after) :
      Exec (.call kind args) before ⟨after,.normal⟩
  | move (dst src : Name) (di si count : CLogic.Expr) (before : State) (after : Memory)
      (p q : ArrayPointer) (word : BitVec 64) (destination : Pointer before dst di p)
      (source : Pointer before src si q) (length : C99ArrayReference.scalar before count (.uint64 word))
      (copy : KeygenSearchMemory.Memmove before.heap p q word.toNat after) :
      Exec (.move dst src di si count) before ⟨{before with heap := after},.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (head : Exec a before ⟨middle,.normal⟩) (tail : Exec b middle out) : Exec (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result) (head : Exec a before out)
      (exit : out.flow≠.normal) : Exec (.seq a b) before out
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (out : Result)
      (inner : Exec body before out) : Exec (.scope locals pointers body) before
        ⟨restoreScope before out.state locals pointers,out.flow⟩
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (body : Exec yes before out) : Exec (.branch condition yes no) before out
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0)
      (body : Exec no before out) : Exec (.branch condition yes no) before out
  | loopFalse (condition : CLogic.Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0) :
      Exec (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State)
      (out : Result) (v : Value) (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨middle,.normal⟩) (update : Exec increment middle ⟨next,.normal⟩)
      (rest : Exec (.loop condition body increment) next out) : Exec (.loop condition body increment) before out
  | loopReturn (condition : CLogic.Expr) (body increment : Stmt) (before after : State)
      (v ret : Value) (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨after,.returned (some ret)⟩) :
      Exec (.loop condition body increment) before ⟨after,.returned (some ret)⟩

def only (names : List Name) : Stmt → Bool
  | .modular code => KeygenLevelModularFrame.only names code
  | .prime _ _ _ _ => true
  | .call kind args => KeygenLevelCalls.arguments names (KeygenLevelCalls.writable kind) (KeygenLevelCalls.params kind) args
  | .move dst _ _ _ _ => names.contains dst
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ _ body => only names body
theorem body_frame (code : Stmt) (before : State) (out : Result) (source : Exec code before out)
    (names : List Name) (checked : only names code=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | modular code before out source =>
    exact KeygenLevelModularFrame.body_frame code before out source names checked block offset outside
  | prime | loopFalse => exact ⟨outside,rfl,rfl⟩
  | call kind args before after source =>
    have keep := KeygenLevelCalls.call_frame kind before after args source names block offset checked outside tables
    cases source
    exact ⟨outside,rfl,keep⟩
  | move dst src di si count before after p q word destination source length copy =>
    exact ⟨outside,rfl,KeygenSearchMemory.memmove_frame before.heap after p q word.toNat block offset copy
      (C99PointerFootprint.pointer_outside before names dst di p destination
        (List.contains_iff_mem.mp checked) block offset outside)⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa (by simpa only [C99PointerFootprint.TablesOutside,ta] using tables)
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | scope locals pointers body before out inner ih =>
    obtain ⟨ho,ht,hf⟩ := ih checked outside tables
    exact ⟨C99PointerFootprint.restore_outside before out.state locals pointers names block offset outside ho,ht,hf⟩
  | branchTrue condition yes no before out v guard nonzero body ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | branchFalse condition yes no before out v guard zero body ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).2 outside tables
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

end FT1536.Source3.KeygenLevelExec
