import Source3.KeygenModpAddSub
import Source3.KeygenNinv31
import Source3.KeygenModpSet
import Source3.C99ProcedureReference

/- Read-only uint32 expressions and ordinary block/loop control. Primitive
   calls execute their pinned scalar bodies. This reference judgment does
   not use the modular equations that will be proved about its executions. -/
namespace FT1536.Source3.C99ModularReference
open C99ArrayReference (Name State scalar bindValue restoreScope Pointer)
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)

inductive Expr where
  | scalar (e : CLogic.Expr)
  | load32 (array : Name) (index : CLogic.Expr)
  | load16 (array : Name) (index : CLogic.Expr)
  | call1 (name : Name) (a : Expr)
  | call2 (name : Name) (a b : Expr)
  | call3 (name : Name) (a b c : Expr)
  | call4 (name : Name) (a b c d : Expr)
  deriving DecidableEq, Repr

inductive Call : Name → List Value → Value → Prop where
  | montgomery (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenModpWord.montgomeryCode) args out) :
      Call "modp_montymul".toList args out
  | add (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction (KeygenModpAddSub.code .add)) args out) :
      Call "modp_add".toList args out
  | sub (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction (KeygenModpAddSub.code .sub)) args out) :
      Call "modp_sub".toList args out
  | inverse (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenNinv31.code) args out) :
      Call "modp_ninv31".toList args out
  | set (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenModpSet.code) args out) :
      Call "modp_set".toList args out

inductive Eval (s : State) : Expr → Value → Prop where
  | scalar (e : CLogic.Expr) (v : Value) (source : scalar s e v) : Eval s (.scalar e) v
  | load32 (name : Name) (index : CLogic.Expr) (p : C99MemoryReference.ArrayPointer) (w : BitVec 32)
      (address : Pointer s name index p) (read : C99MemoryReference.Load32 s.heap p w) :
      Eval s (.load32 name index) (.uint32 w)
  | load16 (name : Name) (index : CLogic.Expr) (p : C99MemoryReference.ArrayPointer) (w : BitVec 16)
      (address : Pointer s name index p) (read : C99NarrowReads.Load16 s.heap p w) :
      Eval s (.load16 name index) (C99NarrowReads.signedPromotion w)
  | call1 (name : Name) (a : Expr) (x out : Value)
      (arg : Eval s a x) (call : Call name [x] out) : Eval s (.call1 name a) out
  | call2 (name : Name) (a b : Expr) (x y out : Value)
      (first : Eval s a x) (second : Eval s b y) (call : Call name [x,y] out) : Eval s (.call2 name a b) out
  | call3 (name : Name) (a b c : Expr) (x y z out : Value)
      (first : Eval s a x) (second : Eval s b y) (third : Eval s c z)
      (call : Call name [x,y,z] out) : Eval s (.call3 name a b c) out
  | call4 (name : Name) (a b c d : Expr) (x y z t out : Value)
      (first : Eval s a x) (second : Eval s b y) (third : Eval s c z) (fourth : Eval s d t)
      (call : Call name [x,y,z,t] out) : Eval s (.call4 name a b c d) out

inductive Stmt where
  | base (code : C99ArrayReference.Stmt)
  | assign (name : Name) (value : Expr)
  | store32 (array : Name) (index : CLogic.Expr) (value : Expr)
  | seq (first second : Stmt)
  | scope (locals : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  | ret (value : Expr)
  deriving DecidableEq, Repr

inductive Exec : Stmt → State → Result → Prop where
  | base (code : C99ArrayReference.Stmt) (before after : State)
      (source : C99ArrayReference.Exec FftLeafPrograms.program code before after) :
      Exec (.base code) before ⟨after,.normal⟩
  | assign (name : Name) (e : Expr) (before : State) (ty : C99IntegerReference.Ty)
      (old : Option Value) (v : Value) (declared : before.locals name=some (ty,old)) (value : Eval before e v) :
      Exec (.assign name e) before ⟨bindValue before name ty v,.normal⟩
  | store32 (name : Name) (index : CLogic.Expr) (e : Expr) (before : State)
      (after : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer) (v : Value)
      (address : Pointer before name index p) (value : Eval before e v)
      (write : C99MemoryReference.Store32 before.heap p (BitVec.ofInt 32 v.integer) after) :
      Exec (.store32 name index e) before ⟨{before with heap := after},.normal⟩
  | seqNormal (first second : Stmt) (before middle : State) (result : Result)
      (head : Exec first before ⟨middle,.normal⟩) (tail : Exec second middle result) :
      Exec (.seq first second) before result
  | seqExit (first second : Stmt) (before : State) (result : Result)
      (head : Exec first before result) (exit : result.flow≠.normal) : Exec (.seq first second) before result
  | scope (locals : List Name) (body : Stmt) (before : State) (result : Result) (inner : Exec body before result) :
      Exec (.scope locals body) before ⟨restoreScope before result.state locals [],result.flow⟩
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State) (result : Result) (v : Value)
      (guard : scalar before condition v) (nonzero : v.integer≠0) (body : Exec yes before result) :
      Exec (.branch condition yes no) before result
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State) (result : Result) (v : Value)
      (guard : scalar before condition v) (zero : v.integer=0) (body : Exec no before result) :
      Exec (.branch condition yes no) before result
  | loopFalse (condition : CLogic.Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : scalar before condition v) (zero : v.integer=0) :
      Exec (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State)
      (result : Result) (v : Value) (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨middle,.normal⟩) (update : Exec increment middle ⟨next,.normal⟩)
      (rest : Exec (.loop condition body increment) next result) : Exec (.loop condition body increment) before result
  | loopReturn (condition : CLogic.Expr) (body increment : Stmt) (before after : State) (v value : Value)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨after,.returned (some value)⟩) :
      Exec (.loop condition body increment) before ⟨after,.returned (some value)⟩
  | ret (e : Expr) (before : State) (v : Value) (value : Eval before e v) :
      Exec (.ret e) before ⟨before,.returned (some v)⟩

theorem base_before_tail (code : C99ArrayReference.Stmt) (tail : Stmt) (before : State) (result : Result)
    (source : Exec (.seq (.base code) tail) before result) :
    ∃ middle, C99ArrayReference.Exec FftLeafPrograms.program code before middle ∧ Exec tail middle result := by
  cases source with
  | seqNormal _ _ _ middle _ head rest => cases head; exact ⟨middle,‹_›,rest⟩
  | seqExit _ _ _ _ head exit => cases head; exact False.elim (exit rfl)

theorem skip_result (before : State) (result : Result) (source : Exec (.base .skip) before result) :
    result=⟨before,.normal⟩ := by cases source; cases ‹C99ArrayReference.Exec _ _ _ _›; rfl

theorem continuation (head tail : Stmt) (before middle : State) (result : Result)
    (unique : ∀ out, Exec head before out → out=⟨middle,.normal⟩)
    (source : Exec (.seq head tail) before result) : Exec tail middle result := by
  cases source with
  | seqNormal _ _ _ actual _ first rest =>
      have he := congrArg Result.state (unique ⟨actual,.normal⟩ first)
      change actual=middle at he
      subst actual
      exact rest
  | seqExit _ _ _ _ first exit => exact False.elim (exit (congrArg Result.flow (unique result first)))

end FT1536.Source3.C99ModularReference
