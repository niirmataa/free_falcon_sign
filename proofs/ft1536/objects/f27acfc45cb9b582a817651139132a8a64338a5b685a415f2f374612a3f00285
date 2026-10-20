import Source3.StableTopExec

/- Natural source-fragment semantics. Neither Eval nor execution rules
   call the operational evaluator. By-value locals are private to one
   iteration. The comma operator sequences u initialization/increment
   before v; indices below are their exact nonwrapping size_t views. -/
namespace FT1536.Source3.StableTopReference
open StableTopSyntax StableTopMemory
abbrev Word := BitVec 64
structure State where
  memory : C99HelperReference.State
  locals : StableTopExpr.Env

inductive Step (l : Layout) (u v : Nat) : Stmt → State → State → Prop where
  | read (name : B20.C.Name) (delta : Nat) (s : State) (mid : C99HelperReference.State) (raw w : Word)
      (load : C99MemoryReference.Load64 s.memory.heap (rootsPtr l (u+delta)) raw)
      (check : C99HelperReference.Positive (branch l 0) s.memory raw w mid) :
      Step l u v (.readCheck name delta) s ⟨mid,StableTopExpr.put s.locals name w⟩
  | local (name : B20.C.Name) (expr : Expr) (s : State) (mid : C99HelperReference.State) (raw w : Word)
      (evaluated : StableTopExpr.Eval s.locals expr raw)
      (check : C99HelperReference.Positive (branch l 0) s.memory raw w mid) :
      Step l u v (.letCheck name expr) s ⟨mid,StableTopExpr.put s.locals name w⟩
  | write (offset : Nat) (expr : Expr) (s : State) (mid out : C99HelperReference.State) (raw w : Word)
      (evaluated : StableTopExpr.Eval s.locals expr raw)
      (check : C99HelperReference.Positive (branch l 0) s.memory raw w mid)
      (write : C99HelperReference.Store (leavesPtr l (offset+v)) mid w out) :
      Step l u v (.storeCheck offset expr) s ⟨out,s.locals⟩

inductive Body (l : Layout) (u v : Nat) : List Stmt → State → State → Prop where
  | nil (s : State) : Body l u v [] s s
  | cons (stmt : Stmt) (rest : List Stmt) (s mid out : State)
      (first : Step l u v stmt s mid) (tail : Body l u v rest mid out) : Body l u v (stmt::rest) s out

def initialLocals (three : Word) : StableTopExpr.Env := fun n => if n="three".toList then some three else none
inductive Loop (l : Layout) (code : Code) (three : Word) :
    Nat → C99HelperReference.State → C99HelperReference.State → Prop where
  | zero (s : C99HelperReference.State) : Loop l code three 0 s s
  | next (i : Nat) (s mid : C99HelperReference.State) (out : State)
      (earlier : Loop l code three i s mid)
      (guard : code.loop.initialU+code.loop.stepU*i<code.loop.bound)
      (iteration : Body l (code.loop.initialU+code.loop.stepU*i) (code.loop.initialV+code.loop.stepV*i)
        code.body ⟨mid,initialLocals three⟩ out) : Loop l code three (i+1) s out.memory

def binaryLayout (l : Layout) (offset size : Nat) : StableBinary.Layout :=
  ⟨l.leaves+8*offset,l.scratch,l.bad,size⟩
def Binary (l : Layout) (b : Branch) (s out : C99HelperReference.State) : Prop :=
  ∃ checks, C99HelperReference.PinnedExec (binaryLayout l b.offset b.size) b.size s.heap out.heap checks ∧
    out.checks=checks++s.checks
inductive Branches (l : Layout) : List Branch → C99HelperReference.State → C99HelperReference.State → Prop where
  | nil (s : C99HelperReference.State) : Branches l [] s s
  | cons (b : Branch) (rest : List Branch) (s mid out : C99HelperReference.State)
      (call : Binary l b s mid) (tail : Branches l rest mid out) : Branches l (b::rest) s out

inductive Exec (l : Layout) (code : Code) (before : C99MemoryReference.Memory) :
    C99MemoryReference.Memory → List Word → Prop where
  | call (three : Word) (iterations : Nat) (loopOut out : C99HelperReference.State)
      (initial : FprOfThree.SourceExec (.uint64 three))
      (loop : Loop l code three iterations ⟨before,[]⟩ loopOut)
      (falseGuard : ¬code.loop.initialU+code.loop.stepU*iterations<code.loop.bound)
      (branches : Branches l code.branches loopOut out) : Exec l code before out.heap out.checks

def PinnedExec (l : Layout) (before after : C99MemoryReference.Memory) (checks : List Word) : Prop :=
  ∃ code, StableTopSyntax.source=some code ∧ Exec l code before after checks

end FT1536.Source3.StableTopReference
