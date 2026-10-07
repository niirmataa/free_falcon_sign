import Source3.KeygenSearchLeaves
import Source3.KeygenSearchMemory
import Source3.KeygenSearchContext

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Operational language needed by ternary_depth0. The extra productions
   execute fixed bodies for alignment, zint, FPEMU rounding and conversion.
   There is no search oracle or postcondition in this execution relation. -/
namespace FT1536.Source3.KeygenSearchExec
open C99ArrayReference (State Name Arg Pointer bindValue bindPointer restoreScope)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

inductive PointerExpr where
  | named (name : Name) (index : CLogic.Expr)
  | tmp
  | cast (width : Nat) (value : PointerExpr)
  | align (base data : PointerExpr)
  deriving DecidableEq, Repr

inductive EvalPointer (ctx : Context) (s : State) : PointerExpr → ArrayPointer → Prop where
  | named (name : Name) (index : CLogic.Expr) (p : ArrayPointer)
      (value : Pointer s name index p) : EvalPointer ctx s (.named name index) p
  | tmp (p : ArrayPointer) (value : KeygenSearchContext.ReadTmp ctx s p) : EvalPointer ctx s .tmp p
  | cast (width : Nat) (e : PointerExpr) (p q : ArrayPointer) (value : EvalPointer ctx s e p)
      (view : KeygenSearchMemory.Cast p width q) : EvalPointer ctx s (.cast width e) q
  | align (base data : PointerExpr) (p q out : ArrayPointer)
      (first : EvalPointer ctx s base p) (second : EvalPointer ctx s data q)
      (source : KeygenSearchMemory.Align s p q out) : EvalPointer ctx s (.align base data) out

inductive Expr where
  | base (value : C99ArrayReference.Expr)
  | plain (pointer : PointerExpr)
  | unary (name : Name) (arg : Expr)
  | binary (name : Name) (first second : Expr)
  | cast (ty : Ty) (value : Expr)
  deriving DecidableEq, Repr

def ScalarCall (name : Name) (args : List Value) (out : Value) : Prop :=
  if name="fpr_rint".toList then KeygenSearchLeaves.Rint args out else FprPrefixCalls.calls name args out

inductive Eval (ctx : Context) (s : State) : Expr → Value → Prop where
  | base (e : C99ArrayReference.Expr) (v : Value) (source : C99ArrayReference.Eval s e v) : Eval ctx s (.base e) v
  | plain (e : PointerExpr) (p : ArrayPointer) (v : Value)
      (address : EvalPointer ctx s e p) (source : KeygenSmallSource.PlainCall s p v) : Eval ctx s (.plain e) v
  | unary (name : Name) (arg : Expr) (v out : Value) (value : Eval ctx s arg v)
      (call : ScalarCall name [v] out) : Eval ctx s (.unary name arg) out
  | binary (name : Name) (a b : Expr) (x y out : Value) (first : Eval ctx s a x) (second : Eval ctx s b y)
      (call : ScalarCall name [x,y] out) : Eval ctx s (.binary name a b) out
  | cast (ty : Ty) (e : Expr) (v : Value) (value : Eval ctx s e v) :
      Eval ctx s (.cast ty e) (C99IntegerReference.convert ty v.integer)

inductive Stmt where
  | procedure (code : C99ProcedureReference.Stmt)
  | logn (destination : Name)
  | pointer (destination : Name) (value : PointerExpr)
  | assign (destination : Name) (value : Expr)
  | store (width : Nat) (destination : Name) (index : CLogic.Expr) (value : Expr)
  | move (destination source : PointerExpr) (count : CLogic.Expr)
  | small (args : List Arg)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  deriving DecidableEq, Repr

def skip : Stmt := .procedure (.base .skip)
def chain : List Stmt → Stmt
  | [] => skip
  | s::ss => .seq s (chain ss)

inductive Exec (ctx : Context) : Stmt → State → Result → Prop where
  | procedure (code : C99ProcedureReference.Stmt) (before : State) (out : Result)
      (source : C99ProcedureReference.Exec KeygenSearchFft.program code before out) :
      Exec ctx (.procedure code) before out
  | logn (dst : Name) (before : State) (ty : Ty) (old : Option Value) (word : BitVec 32)
      (declared : before.locals dst=some (ty,old)) (source : KeygenSearchContext.ReadLogn ctx before word) :
      Exec ctx (.logn dst) before ⟨bindValue before dst ty (.uint32 word),.normal⟩
  | pointer (dst : Name) (e : PointerExpr) (before : State) (p : ArrayPointer)
      (source : EvalPointer ctx before e p) : Exec ctx (.pointer dst e) before ⟨bindPointer before dst p,.normal⟩
  | assign (dst : Name) (e : Expr) (before : State) (ty : Ty) (old : Option Value) (v : Value)
      (declared : before.locals dst=some (ty,old)) (value : Eval ctx before e v) :
      Exec ctx (.assign dst e) before ⟨bindValue before dst ty v,.normal⟩
  | store32 (dst : Name) (index : CLogic.Expr) (e : Expr) (before : State) (after : Memory)
      (p : ArrayPointer) (v : Value) (address : Pointer before dst index p) (value : Eval ctx before e v)
      (write : Store32 before.heap p (BitVec.ofInt 32 v.integer) after) :
      Exec ctx (.store 4 dst index e) before ⟨{before with heap := after},.normal⟩
  | store64 (dst : Name) (index : CLogic.Expr) (e : Expr) (before : State) (after : Memory)
      (p : ArrayPointer) (v : Value) (address : Pointer before dst index p) (value : Eval ctx before e v)
      (write : Store64 before.heap p (BitVec.ofInt 64 v.integer) after) :
      Exec ctx (.store 8 dst index e) before ⟨{before with heap := after},.normal⟩
  | move (dst src : PointerExpr) (count : CLogic.Expr) (before : State) (after : Memory)
      (p q : ArrayPointer) (word : BitVec 64) (destination : EvalPointer ctx before dst p)
      (source : EvalPointer ctx before src q) (length : C99ArrayReference.scalar before count (.uint64 word))
      (copy : KeygenSearchMemory.Memmove before.heap p q word.toNat after) :
      Exec ctx (.move dst src count) before ⟨{before with heap := after},.normal⟩
  | small (args : List Arg) (before after : State) (source : KeygenSearchLeaves.SmallCall before args after) :
      Exec ctx (.small args) before ⟨after,.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (head : Exec ctx a before ⟨middle,.normal⟩) (tail : Exec ctx b middle out) : Exec ctx (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result) (head : Exec ctx a before out)
      (exit : out.flow≠.normal) : Exec ctx (.seq a b) before out
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (out : Result)
      (inner : Exec ctx body before out) :
      Exec ctx (.scope locals pointers body) before ⟨restoreScope before out.state locals pointers,out.flow⟩
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (body : Exec ctx yes before out) : Exec ctx (.branch condition yes no) before out
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0)
      (body : Exec ctx no before out) : Exec ctx (.branch condition yes no) before out
  | loopFalse (condition : CLogic.Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0) :
      Exec ctx (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State)
      (out : Result) (v : Value) (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec ctx body before ⟨middle,.normal⟩) (update : Exec ctx increment middle ⟨next,.normal⟩)
      (rest : Exec ctx (.loop condition body increment) next out) : Exec ctx (.loop condition body increment) before out
  | loopReturn (condition : CLogic.Expr) (body increment : Stmt) (before after : State)
      (v : Value) (ret : Option Value) (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec ctx body before ⟨after,.returned ret⟩) :
      Exec ctx (.loop condition body increment) before ⟨after,.returned ret⟩

end FT1536.Source3.KeygenSearchExec
