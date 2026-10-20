import Source3.KeygenWordExpr

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenWordExec
open C99ArrayReference (State Name Pointer bindValue restoreScope)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenWordExpr (Expr Eval)

inductive Stmt where
  | modular (code : C99ModularReference.Stmt)
  | assign (name : Name) (value : Expr)
  | store (name : Name) (index : CLogic.Expr) (value : Expr)
  | seq (first second : Stmt)
  | scope (locals : List Name) (body : Stmt)
  | branch (condition : Expr) (yes no : Stmt)
  | loop (condition : Expr) (body increment : Stmt)
  | ret (value : Expr)
  deriving DecidableEq, Repr
def skip : Stmt := .modular (.base .skip)
def chain : List Stmt → Stmt
  | [] => skip
  | s::ss => .seq s (chain ss)
inductive Exec : Stmt → State → Result → Prop where
  | modular (code : C99ModularReference.Stmt) (before : State) (out : Result)
      (source : C99ModularReference.Exec code before out) : Exec (.modular code) before out
  | assign (name : Name) (e : Expr) (before : State) (ty : Ty) (old : Option Value) (v : Value)
      (declared : before.locals name=some (ty,old)) (source : Eval before e v) :
      Exec (.assign name e) before ⟨bindValue before name ty v,.normal⟩
  | store (name : Name) (index : CLogic.Expr) (e : Expr) (before : State) (after : Memory)
      (p : ArrayPointer) (v : Value) (address : Pointer before name index p) (value : Eval before e v)
      (write : Store32 before.heap p (BitVec.ofInt 32 v.integer) after) :
      Exec (.store name index e) before ⟨{before with heap := after},.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (head : Exec a before ⟨middle,.normal⟩) (tail : Exec b middle out) : Exec (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result) (head : Exec a before out)
      (exit : out.flow≠.normal) : Exec (.seq a b) before out
  | scope (locals : List Name) (body : Stmt) (before : State) (out : Result) (inner : Exec body before out) :
      Exec (.scope locals body) before ⟨restoreScope before out.state locals [],out.flow⟩
  | branchTrue (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : Eval before condition v) (nonzero : v.integer≠0) (body : Exec yes before out) :
      Exec (.branch condition yes no) before out
  | branchFalse (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : Eval before condition v) (zero : v.integer=0) (body : Exec no before out) :
      Exec (.branch condition yes no) before out
  | loopFalse (condition : Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : Eval before condition v) (zero : v.integer=0) : Exec (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : Expr) (body increment : Stmt) (before middle next : State)
      (out : Result) (v : Value) (guard : Eval before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨middle,.normal⟩) (update : Exec increment middle ⟨next,.normal⟩)
      (rest : Exec (.loop condition body increment) next out) : Exec (.loop condition body increment) before out
  | loopReturn (condition : Expr) (body increment : Stmt) (before after : State)
      (v ret : Value) (guard : Eval before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨after,.returned (some ret)⟩) :
      Exec (.loop condition body increment) before ⟨after,.returned (some ret)⟩
  | ret (e : Expr) (before : State) (v : Value) (source : Eval before e v) :
      Exec (.ret e) before ⟨before,.returned (some v)⟩

def only (names : List Name) : Stmt → Bool
  | .modular code => KeygenLevelModularFrame.only names code
  | .assign _ _ | .ret _ => true
  | .store name _ _ => names.contains name
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ body => only names body
theorem body_frame (code : Stmt) (before : State) (out : Result) (source : Exec code before out)
    (names : List Name) (checked : only names code=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | modular code before out source =>
    exact KeygenLevelModularFrame.body_frame code before out source names checked block offset outside
  | assign | ret | loopFalse => exact ⟨outside,rfl,rfl⟩
  | store name index e before after p v address value write =>
    exact ⟨outside,rfl,write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names name index p 4 address
        (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | scope locals body before out inner ih => exact ih checked outside
  | branchTrue condition yes no before out v guard nonzero body ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | branchFalse condition yes no before out v guard zero body ih => exact ih (Bool.and_eq_true_iff.mp checked).2 outside
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa
    obtain ⟨oc,tc,fc⟩ := ih3 checked ob
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside

end FT1536.Source3.KeygenWordExec
