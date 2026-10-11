import Source3.KeygenCodecValues
import Source3.KeygenCodecNoneBinding
import Source3.KeygenCodecStaticBinding
import Source3.KeygenCodecDispatchBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Finite defined executions of the complete bound codec syntax. Tests,
   reads, assignments and returned values are evaluated, rather than
   selected nondeterministically. Callees are the fixed source bodies.
   No codec value, length, frame or projected execution is a premise. -/
namespace FT1536.Source3.KeygenCodecExecution
open KeygenCodecSyntax KeygenCodecValues C99MemoryReference

/-- Independent byte-view and store rule on the shared reference memory.
    These unfold to the pinned caller's byte rule without importing its
    entire certificate graph into the value interpreter. -/
def byteOff (p : ArrayPointer) (n : Nat) : ArrayPointer :=
  ⟨p.block,p.base,p.count*p.elementBytes,1,p.offset+n-p.base⟩
def StoreByte (before : Memory) (p : ArrayPointer) (w : BitVec 8) (after : Memory) : Prop :=
  Allocated before p ∧ p.elementBytes=1 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  after.bytes p.block p.offset=some w ∧
  (∀ block offset, block≠p.block ∨ offset≠p.offset →
    after.bytes block offset=before.bytes block offset)

inductive Flow where
  | normal
  | returned (value : BitVec 64)
  deriving DecidableEq, Repr

def body : Callee → Stmt
  | .none => KeygenCodecNoneBinding.code
  | .static => KeygenCodecStaticBinding.code
def testExpr (test : Option Expr) : Expr := test.getD (.number .i32 1)
def desugar (initial : Stmt) (test : Option Expr) (increment body : Stmt) : Stmt :=
  .seq initial (.whileLoop (testExpr test) (.seq body increment))

/-- Objects belonging to this lexical scope; nested scopes own their own
    declarations. Restore only these cells on either normal or return exit. -/
def scopeObjects : Stmt → List Object
  | .declare objects => objects
  | .seq a b => scopeObjects a ++ scopeObjects b
  | _ => []
def scopeExit (body : Stmt) (outer inner : State) : State :=
  let objects := scopeObjects body
  ⟨inner.heap,⟨fun name => if objects.any (fun o => o.name==name)
    then outer.locals.scalars name else inner.locals.scalars name,inner.locals.x⟩,
    if hasBuf objects then outer.buf else inner.buf⟩

/-- A terminal fixed call evaluates all five argument variables in the
    current activation and converts them at the bound callee signature.
    In particular the passed x is the current pointer, not the entry x.
    The tail call replaces the private activation, retaining its heap. -/
structure CallArgs (args : Args) (s : State) (called : Args) : Prop where
  out : called.out=args.out
  capacity : s.locals.scalars "max_out_len".toList=some (.uint64,some (.uint64 called.capacity))
  q : s.locals.scalars "q".toList=some (.uint32,some (.uint32 called.q))
  x : called.x=s.locals.x
  logn : s.locals.scalars "logn".toList=some (.uint32,some (.uint32 called.logn))

/-- Shadow-free activation semantics. Scope markers do not expose or
    allocate heap objects: declarations refresh each private scalar on
    every iteration, and function calls own their entire activation.
    Break/continue, arbitrary calls and pointer stores have no rules in
    this codec fragment; the complete pinned bodies use none of them. -/
inductive Exec : Args → Stmt → State → State → Flow → Prop where
  | skip (args : Args) (s : State) : Exec args .skip s s .normal
  | declare (args : Args) (s : State) (objects : List Object) (locals : Locals)
      (declarations : declareLocals objects s.locals=some locals) :
      Exec args (.declare objects) s (declared s objects locals) .normal
  | bind (args : Args) (s : State) :
      Exec args (.write (.variable "buf".toList) .set (.variable "out".toList))
        s {s with buf := some args.out} .normal
  | scalar (args : Args) (s : State) (name : List Char) (op : Assign) (rhs : Expr)
      (ty : C99IntegerReference.Ty) (old : Option C99IntegerReference.Value)
      (value result : C99IntegerReference.Value) (locals : Locals)
      (notBuf : name≠"buf".toList) (notOut : name≠"out".toList)
      (declared : s.locals.scalars name=some (ty,old))
      (evaluated : Eval args s.heap s.buf rhs s.locals (.integer value) locals)
      (assigned : Assigned op old value result) :
      Exec args (.write (.variable name) op rhs) s
        (withLocals s (localSet locals name ty (some (C99IntegerReference.convert ty result.integer)))) .normal
  | store (args : Args) (s : State) (index rhs : Expr) (m t : Locals)
      (p : ArrayPointer) (offset value : C99IntegerReference.Value) (after : Memory)
      (buffer : s.buf=some (some p))
      (indexValue : Eval args s.heap s.buf index s.locals (.integer offset) m)
      (nonnegative : 0≤offset.integer)
      (rhsValue : Eval args s.heap s.buf rhs m (.integer value) t)
      (write : StoreByte s.heap (byteOff p offset.integer.toNat) (BitVec.ofInt 8 value.integer) after) :
      Exec args (.write (.index (.variable "buf".toList) index) .set rhs)
        s ⟨after,t,s.buf⟩ .normal
  | increment (args : Args) (s : State) (name : List Char) (locals : Locals) (old value : Value)
      (step : Update name 1 s.locals old value locals) :
      Exec args (.increment (.variable name)) s (withLocals s locals) .normal
  | evaluate (args : Args) (s : State) (e : Expr) (value : Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf e s.locals value locals) :
      Exec args (.evaluate e) s (withLocals s locals) .normal
  | seq (args : Args) (a b : Stmt) (s m t : State) (flow : Flow)
      (first : Exec args a s m .normal) (second : Exec args b m t flow) :
      Exec args (.seq a b) s t flow
  | seqReturn (args : Args) (a b : Stmt) (s t : State) (value : BitVec 64)
      (first : Exec args a s t (.returned value)) :
      Exec args (.seq a b) s t (.returned value)
  | scope (args : Args) (a : Stmt) (s t : State) (flow : Flow)
      (noBufShadow : hasBuf (scopeObjects a)=true → s.buf=none)
      (inside : Exec args a s t flow) : Exec args (.scope a) s (scopeExit a s t) flow
  | branchTrue (args : Args) (test : Expr) (a b : Stmt) (s t : State) (flow : Flow)
      (value : Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals value locals) (yes : truth value=true)
      (selected : Exec args a (withLocals s locals) t flow) : Exec args (.branch test a b) s t flow
  | branchFalse (args : Args) (test : Expr) (a b : Stmt) (s t : State) (flow : Flow)
      (value : Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals value locals) (no : truth value=false)
      (selected : Exec args b (withLocals s locals) t flow) : Exec args (.branch test a b) s t flow
  | whileDone (args : Args) (test : Expr) (a : Stmt) (s : State) (value : Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals value locals) (no : truth value=false) :
      Exec args (.whileLoop test a) s (withLocals s locals) .normal
  | whileNext (args : Args) (test : Expr) (a : Stmt) (s m t : State) (flow : Flow)
      (value : Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals value locals) (yes : truth value=true)
      (iteration : Exec args a (withLocals s locals) m .normal)
      (rest : Exec args (.whileLoop test a) m t flow) : Exec args (.whileLoop test a) s t flow
  | whileReturn (args : Args) (test : Expr) (a : Stmt) (s t : State) (ret : BitVec 64)
      (value : Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals value locals) (yes : truth value=true)
      (iteration : Exec args a (withLocals s locals) t (.returned ret)) :
      Exec args (.whileLoop test a) s t (.returned ret)
  | forLoop (args : Args) (initial : Stmt) (test : Option Expr) (increment body : Stmt)
      (s t : State) (flow : Flow)
      (expanded : Exec args (desugar initial test increment body) s t flow) :
      Exec args (.loop initial test increment body) s t flow
  | switchNone (args : Args) (test : Expr) (a b c : Stmt) (s t : State) (flow : Flow)
      (value : C99IntegerReference.Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals (.integer value) locals) (zero : value.integer=0)
      (selected : Exec args a (withLocals s locals) t flow) : Exec args (.switch test a b c) s t flow
  | switchStatic (args : Args) (test : Expr) (a b c : Stmt) (s t : State) (flow : Flow)
      (value : C99IntegerReference.Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals (.integer value) locals) (one : value.integer=1)
      (selected : Exec args b (withLocals s locals) t flow) : Exec args (.switch test a b c) s t flow
  | switchOther (args : Args) (test : Expr) (a b c : Stmt) (s t : State) (flow : Flow)
      (value : C99IntegerReference.Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals (.integer value) locals)
      (notZero : value.integer≠0) (notOne : value.integer≠1)
      (selected : Exec args c (withLocals s locals) t flow) : Exec args (.switch test a b c) s t flow
  | ret (args : Args) (s : State) (e : Expr) (value : C99IntegerReference.Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf e s.locals (.integer value) locals) :
      Exec args (.ret e) s (withLocals s locals) (.returned (BitVec.ofInt 64 value.integer))
  | call (args called : Args) (destination : Callee) (s t : State) (ret : BitVec 64)
      (arguments : CallArgs args s called)
      (execution : Exec called (body destination) (initial called s.heap) t (.returned ret)) :
      Exec args (.ret (.call destination KeygenCodecValues.calleeArgs)) s t (.returned ret)

/-- Complete source dispatcher execution, with an observed return value.
    The return is an index of the execution judgment, not a correctness
    or length constraint. Both zero and nonzero results are admitted. -/
def Call (args : Args) (before after : Memory) (ret : BitVec 64) : Prop :=
  ∃ out, Exec args KeygenCodecDispatchBinding.code (initial args before) out (.returned ret) ∧ out.heap=after

end FT1536.Source3.KeygenCodecExecution
