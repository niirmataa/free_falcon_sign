import Source3.KeygenPublicWord

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Uint16 array procedure semantics, including automatic array lifetime.
   Program tables are fixed by the source binding module. -/
namespace FT1536.Source3.KeygenPublicExec
open C99ArrayReference (State Name Arg Param bindValue bindPointer restoreScope)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenPublicWord (Eval Address Bind)
open KeygenWordExpr (Expr)

inductive Stmt where
  | skip
  | scalar (code : CLogic.Stmt)
  | assign (name : Name) (value : Expr)
  | declarePointer (name : Name)
  | pointer (dst src : Name) (index : CLogic.Expr)
  | store (array : Name) (index : CLogic.Expr) (explicitCast : Bool) (value : Expr)
  | call (name : Name) (args : List Arg)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | arrayScope (name : Name) (count : Nat) (body : Stmt)
  | branch (condition : Expr) (yes no : Stmt)
  | loop (condition : Expr) (body increment : Stmt)
  | ret (value : Option Expr)
  deriving DecidableEq, Repr
def chain : List Stmt → Stmt
  | [] => .skip
  | s::ss => .seq s (chain ss)
structure Function where
  params : List Param
  signed : List Name
  result : Option Ty
  body : Stmt
  deriving DecidableEq, Repr
abbrev Program := Name → Option Function
def allocated (heap : Memory) (block count : Nat) : Memory :=
  {bytes := fun b o => if b=block then none else heap.bytes b o
   size := fun b => if b=block then 2*count else heap.size b
   writable := fun b => if b=block then true else heap.writable b}
def localPointer (block count : Nat) : ArrayPointer := ⟨block,0,count,2,0⟩
def localEntry (before : State) (name : Name) (block count : Nat) : State :=
  bindPointer {before with heap := allocated before.heap block count} name (localPointer block count)
def localExit (before after : State) (name : Name) (block : Nat) : State :=
  restoreScope before {after with heap := KeygenRngSource.disposed before.heap after.heap block} [] [name]
inductive Exec (program : Program) : List Name → Stmt → State → Result → Prop where
  | skip (s : State) : Exec program signed .skip s ⟨s,.normal⟩
  | scalar (code : CLogic.Stmt) (before : State) (env : C99ScalarReference.Env)
      (source : C99ScalarReference.Exec KeygenPublicScalar.Call before.locals (C99Frontend.scalar code) (.normal env)) :
      Exec program signed (.scalar code) before ⟨{before with locals := env},.normal⟩
  | assign (name : Name) (e : Expr) (before : State) (ty : Ty) (old : Option Value) (v : Value)
      (declared : before.locals name=some (ty,old)) (source : Eval signed before e v) :
      Exec program signed (.assign name e) before ⟨bindValue before name ty v,.normal⟩
  | declarePointer (name : Name) (s : State) : Exec program signed (.declarePointer name) s
      ⟨{s with arrays := fun n => if n=name then none else s.arrays n},.normal⟩
  | pointer (dst src : Name) (index : CLogic.Expr) (s : State) (p : ArrayPointer) (source : Address s src index p) :
      Exec program signed (.pointer dst src index) s ⟨bindPointer s dst p,.normal⟩
  | store (name : Name) (index : CLogic.Expr) (cast : Bool) (e : Expr) (before : State) (heap : Memory)
      (p : ArrayPointer) (v : Value) (address : Address before name index p) (value : Eval signed before e v)
      (write : KeygenSmallOutput.Store16 before.heap p (KeygenPublicWord.narrow v) heap) :
      Exec program signed (.store name index cast e) before ⟨{before with heap := heap},.normal⟩
  | call (name : Name) (args : List Arg) (f : Function) (before entry : State) (out : Result)
      (lookup : program name=some f) (binding : Bind before f.params args entry)
      (source : Exec program f.signed f.body entry out)
      (returned : C99ProcedureReference.ReturnValue f.result out.flow none) :
      Exec program signed (.call name args) before ⟨{before with heap := out.state.heap},.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (head : Exec program signed a before ⟨middle,.normal⟩) (tail : Exec program signed b middle out) :
      Exec program signed (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result) (head : Exec program signed a before out)
      (exit : out.flow≠.normal) : Exec program signed (.seq a b) before out
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (out : Result)
      (source : Exec program signed body before out) :
      Exec program signed (.scope locals pointers body) before ⟨restoreScope before out.state locals pointers,out.flow⟩
  | arrayScope (name : Name) (count : Nat) (body : Stmt) (before : State) (out : Result) (block : Nat)
      (positive : 0<count) (size : 2*count<2^64) (fresh : KeygenRngSource.Fresh before.heap block)
      (source : Exec program signed body (localEntry before name block count) out) :
      Exec program signed (.arrayScope name count body) before ⟨localExit before out.state name block,out.flow⟩
  | branchTrue (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : Eval signed before condition v) (nonzero : v.integer≠0) (body : Exec program signed yes before out) :
      Exec program signed (.branch condition yes no) before out
  | branchFalse (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : Eval signed before condition v) (zero : v.integer=0) (body : Exec program signed no before out) :
      Exec program signed (.branch condition yes no) before out
  | loopFalse (condition : Expr) (body increment : Stmt) (s : State) (v : Value)
      (guard : Eval signed s condition v) (zero : v.integer=0) : Exec program signed (.loop condition body increment) s ⟨s,.normal⟩
  | loopNormal (condition : Expr) (body increment : Stmt) (before middle next : State) (out : Result) (v : Value)
      (guard : Eval signed before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program signed body before ⟨middle,.normal⟩) (update : Exec program signed increment middle ⟨next,.normal⟩)
      (rest : Exec program signed (.loop condition body increment) next out) : Exec program signed (.loop condition body increment) before out
  | loopReturn (condition : Expr) (body increment : Stmt) (before after : State) (v : Value) (ret : Option Value)
      (guard : Eval signed before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program signed body before ⟨after,.returned ret⟩) :
      Exec program signed (.loop condition body increment) before ⟨after,.returned ret⟩
  | ret (e : Expr) (before : State) (v : Value) (value : Eval signed before e v) :
      Exec program signed (.ret (some e)) before ⟨before,.returned (some v)⟩
  | retVoid (before : State) : Exec program signed (.ret none) before ⟨before,.returned none⟩

end FT1536.Source3.KeygenPublicExec
