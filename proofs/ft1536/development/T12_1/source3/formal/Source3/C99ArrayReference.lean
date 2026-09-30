import Source3.FprPrefixCalls
import Source3.C99InitializationTrace

/- Natural semantics for the array/control fragment used by the certificate
   prefix. Calls execute bodies from the supplied source program table; they
   are not arbitrary heap transformers or assumed postconditions. Source
   parsing, the closed table and function-specific invariants are separate
   obligations. No full certificate/KeyGen result is asserted by this file. -/
namespace FT1536.Source3.C99ArrayReference
open C99MemoryReference
abbrev Name := B20.C.Name

structure State where
  heap : Memory
  locals : C99ScalarReference.Env
  arrays : Name → Option ArrayPointer
  globals : C99ScalarReference.Env
  tables : Name → Option ArrayPointer

def scalar (s : State) (e : CLogic.Expr) (v : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.Eval FprPrefixCalls.calls s.locals (C99Frontend.expression e) v

inductive Pointer (s : State) : Name → CLogic.Expr → ArrayPointer → Prop where
  | add (name : Name) (index : CLogic.Expr) (p q : ArrayPointer) (i : C99IntegerReference.Value)
      (binding : s.arrays name=some p) (value : scalar s index i)
      (nonnegative : (0 : Int) ≤ i.integer)
      (within : PointerAdd p i.integer.toNat q) : Pointer s name index q

inductive Expr where
  | scalar (e : CLogic.Expr)
  | load (array : Name) (index : CLogic.Expr)
  | call1 (name : Name) (a : Expr)
  | call2 (name : Name) (a b : Expr)
  deriving DecidableEq, Repr

inductive Eval (s : State) : Expr → C99IntegerReference.Value → Prop where
  | scalar (e : CLogic.Expr) (v : C99IntegerReference.Value) (h : scalar s e v) : Eval s (.scalar e) v
  | load (name : Name) (index : CLogic.Expr) (p : ArrayPointer) (w : BitVec 64)
      (address : Pointer s name index p) (read : Load64 s.heap p w) : Eval s (.load name index) (.uint64 w)
  | call1 (name : Name) (a : Expr) (x z : C99IntegerReference.Value)
      (arg : Eval s a x) (body : FprPrefixCalls.calls name [x] z) : Eval s (.call1 name a) z
  | call2 (name : Name) (a b : Expr) (x y z : C99IntegerReference.Value)
      (left : Eval s a x) (right : Eval s b y)
      (body : FprPrefixCalls.calls name [x,y] z) : Eval s (.call2 name a b) z

inductive Arg where
  | scalar (e : CLogic.Expr)
  | pointer (name : Name) (index : CLogic.Expr)
  deriving DecidableEq, Repr
inductive Param where
  | scalar (ty : C99IntegerReference.Ty) (name : Name)
  | pointer (name : Name)
  deriving DecidableEq, Repr

def bindValue (s : State) (name : Name) (ty : C99IntegerReference.Ty)
    (v : C99IntegerReference.Value) : State :=
  {s with locals := C99ScalarReference.set s.locals name (ty,some (C99IntegerReference.convert ty v.integer))}
def bindPointer (s : State) (name : Name) (p : ArrayPointer) : State :=
  {s with arrays := fun n => if n=name then some p else s.arrays n}

inductive Bind (caller : State) : List Param → List Arg → State → Prop where
  | nil : Bind caller [] [] ⟨caller.heap,caller.globals,caller.tables,caller.globals,caller.tables⟩
  | scalar (ty : C99IntegerReference.Ty) (name : Name) (e : CLogic.Expr)
      (ps : List Param) (args : List Arg) (out : State) (v : C99IntegerReference.Value)
      (value : scalar caller e v) (rest : Bind caller ps args out) :
      Bind caller (.scalar ty name::ps) (.scalar e::args) (bindValue out name ty v)
  | pointer (name source : Name) (index : CLogic.Expr) (p : ArrayPointer)
      (ps : List Param) (args : List Arg) (out : State)
      (value : Pointer caller source index p) (rest : Bind caller ps args out) :
      Bind caller (.pointer name::ps) (.pointer source index::args) (bindPointer out name p)

theorem bind_heap (caller : State) (ps : List Param) (args : List Arg) (out : State)
    (h : Bind caller ps args out) : out.heap=caller.heap := by
  induction h with
  | nil => rfl
  | scalar _ _ _ _ _ _ _ _ _ ih => exact ih
  | pointer _ _ _ _ _ _ _ _ _ ih => exact ih

inductive Stmt where
  | skip
  | scalar (s : CLogic.Stmt)
  | assign (name : Name) (value : Expr)
  | declarePtr (name : Name)
  | bindPtr (name source : Name) (index : CLogic.Expr)
  | store64 (array : Name) (index : CLogic.Expr) (value : Expr)
  | store32 (array : Name) (index : CLogic.Expr) (value : Expr)
  | copy (dst src : Name) (dstIndex srcIndex count : CLogic.Expr)
  | seq (a b : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | while (condition : CLogic.Expr) (body : Stmt)
  | call (name : Name) (args : List Arg)
  deriving DecidableEq, Repr

structure Function where
  params : List Param
  body : Stmt
  deriving DecidableEq, Repr

abbrev Program := Name → Option Function

def restoreScope (before after : State) (locals pointers : List Name) : State :=
  {after with
    locals := C99ScalarReference.restore before.locals after.locals locals
    arrays := fun n => if pointers.contains n then before.arrays n else after.arrays n}

inductive Exec (program : Program) : Stmt → State → State → Prop where
  | skip (s : State) : Exec program .skip s s
  | scalar (before : State) (env : C99ScalarReference.Env) (stmt : CLogic.Stmt)
      (body : C99ScalarReference.Exec FprPrefixCalls.calls before.locals
        (C99Frontend.scalar stmt) (.normal env)) :
      Exec program (.scalar stmt) before {before with locals := env}
  | assign (before : State) (name : Name) (e : Expr) (ty : C99IntegerReference.Ty)
      (old : Option C99IntegerReference.Value) (v : C99IntegerReference.Value)
      (declared : before.locals name=some (ty,old)) (value : Eval before e v) :
      Exec program (.assign name e) before (bindValue before name ty v)
  | declarePtr (before : State) (name : Name) :
      Exec program (.declarePtr name) before
        {before with arrays := fun n => if n=name then none else before.arrays n}
  | bindPtr (before : State) (name source : Name) (index : CLogic.Expr) (p : ArrayPointer)
      (value : Pointer before source index p) :
      Exec program (.bindPtr name source index) before (bindPointer before name p)
  | store64 (before : State) (after : Memory) (array : Name) (index : CLogic.Expr)
      (e : Expr) (p : ArrayPointer) (v : C99IntegerReference.Value)
      (address : Pointer before array index p) (value : Eval before e v)
      (write : Store64 before.heap p (BitVec.ofInt 64 v.integer) after) :
      Exec program (.store64 array index e) before {before with heap := after}
  | store32 (before : State) (after : Memory) (array : Name) (index : CLogic.Expr)
      (e : Expr) (p : ArrayPointer) (v : C99IntegerReference.Value)
      (address : Pointer before array index p) (value : Eval before e v)
      (write : Store32 before.heap p (BitVec.ofInt 32 v.integer) after) :
      Exec program (.store32 array index e) before {before with heap := after}
  | copy (before : State) (after : Memory) (dst src : Name) (di si count : CLogic.Expr)
      (p q : ArrayPointer) (n : BitVec 64)
      (destination : Pointer before dst di p) (source : Pointer before src si q)
      (length : scalar before count (.uint64 n))
      (destinationObject : p.offset+n.toNat≤p.base+p.elementBytes*p.count)
      (sourceObject : q.offset+n.toNat≤q.base+q.elementBytes*q.count)
      (copy : Memcpy before.heap p q n.toNat after) :
      Exec program (.copy dst src di si count) before {before with heap := after}
  | seq (a b : Stmt) (before middle after : State)
      (first : Exec program a before middle) (second : Exec program b middle after) :
      Exec program (.seq a b) before after
  | scope (locals pointers : List Name) (body : Stmt) (before after : State)
      (inner : Exec program body before after) :
      Exec program (.scope locals pointers body) before (restoreScope before after locals pointers)
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before after : State)
      (v : C99IntegerReference.Value) (guard : scalar before condition v) (nonzero : v.integer≠0)
      (body : Exec program yes before after) : Exec program (.branch condition yes no) before after
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before after : State)
      (v : C99IntegerReference.Value) (guard : scalar before condition v) (zero : v.integer=0)
      (body : Exec program no before after) : Exec program (.branch condition yes no) before after
  | whileFalse (condition : CLogic.Expr) (body : Stmt) (s : State) (v : C99IntegerReference.Value)
      (guard : scalar s condition v) (zero : v.integer=0) : Exec program (.while condition body) s s
  | whileTrue (condition : CLogic.Expr) (body : Stmt) (before middle after : State)
      (v : C99IntegerReference.Value) (guard : scalar before condition v) (nonzero : v.integer≠0)
      (step : Exec program body before middle) (rest : Exec program (.while condition body) middle after) :
      Exec program (.while condition body) before after
  | call (name : Name) (args : List Arg) (f : Function) (before entry result : State)
      (source : program name=some f) (parameters : Bind before f.params args entry)
      (body : Exec program f.body entry result) :
      Exec program (.call name args) before {before with heap := result.heap}

theorem memory_steps (program : Program) (code : Stmt) (before after : State)
    (h : Exec program code before after) : C99InitializationTrace.Steps before.heap after.heap := by
  induction h with
  | skip | scalar | assign | declarePtr | bindPtr | whileFalse => exact C99InitializationTrace.Steps.done _
  | store64 before after array index e p v address value write =>
      exact .write64 before.heap after after p _ write (.done after)
  | store32 before after array index e p v address value write =>
      exact .write32 before.heap after after p _ write (.done after)
  | copy before after dst src di si count p q n destination source length destinationObject sourceObject copy =>
      exact .copy before.heap after after p q n.toNat copy (.done after)
  | seq a b before middle after first second ih1 ih2 =>
      exact C99InitializationTrace.steps_trans _ _ _ ih1 ih2
  | scope locals pointers body before after inner ih => exact ih
  | branchTrue condition yes no before after v guard nonzero body ih => exact ih
  | branchFalse condition yes no before after v guard zero body ih => exact ih
  | whileTrue condition body before middle after v guard nonzero step rest ih1 ih2 =>
      exact C99InitializationTrace.steps_trans _ _ _ ih1 ih2
  | call name args f before entry result source parameters body ih =>
      rw [bind_heap before f.params args entry parameters] at ih
      exact ih

end FT1536.Source3.C99ArrayReference
