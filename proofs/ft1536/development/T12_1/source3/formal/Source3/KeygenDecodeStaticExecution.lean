import Source3.KeygenDecodeValues
import Source3.KeygenDecodeExecution
import Source3.KeygenDecodeStaticBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Finite defined executions of the complete bound codec syntax. Tests,
   reads, assignments and returned values are evaluated, rather than
   selected nondeterministically. The body has no callees.
   No codec value, length, frame or projected execution is a premise. -/
namespace FT1536.Source3.KeygenDecodeStaticExecution
open KeygenDecodeSyntax KeygenDecodeValues C99MemoryReference

abbrev Store16 := KeygenDecodeExecution.Store16

inductive Flow where
  | normal
  | broken
  | returned (value : BitVec 64)
  deriving DecidableEq, Repr

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

/- Complete STATIC body control, including break propagation through lexical
   scope and absorption by the innermost loop. All reads, scalar operations
   and physical stores reuse the same independent decoder value semantics.
   No call or switch oracle is part of this fixed-body relation. -/
inductive Exec : Args → Stmt → State → State → Flow → Prop where
  | skip (args : Args) (s : State) : Exec args .skip s s .normal
  | declare (args : Args) (s : State) (objects : List Object) (locals : Locals)
      (declarations : declareLocals objects s.locals=some locals) :
      Exec args (.declare objects) s (declared s objects locals) .normal
  | bind (args : Args) (s : State) :
      Exec args (.write (.variable "buf".toList) .set ( .variable "data".toList))
        s {s with buf := some args.data} .normal
  | scalar (args : Args) (s : State) (name : List Char) (op : Assign) (rhs : Expr)
      (ty : C99IntegerReference.Ty) (old : Option C99IntegerReference.Value)
      (value result : C99IntegerReference.Value) (locals : Locals)
      (notBuf : name≠"buf".toList) (notData : name≠"data".toList)
      (declared : s.locals.scalars name=some (ty,old))
      (evaluated : Eval args s.heap s.buf rhs s.locals (.integer value) locals)
      (assigned : Assigned op old value result) :
      Exec args (.write (.variable name) op rhs) s
        (withLocals s (localSet locals name ty (some (C99IntegerReference.convert ty result.integer)))) .normal
  | store (args : Args) (s : State) (index rhs : Expr) (m t : Locals)
      (ptr atWord : ArrayPointer) (offset value : C99IntegerReference.Value) (after : Memory)
      (held : s.locals.x=some ptr)
      (indexValue : Eval args s.heap s.buf index s.locals (.integer offset) m)
      (nonnegative : 0≤offset.integer)
      (advance : PointerAdd ptr offset.integer.toNat atWord)
      (rhsValue : Eval args s.heap s.buf rhs m (.integer value) t)
      (write : Store16 s.heap atWord (BitVec.ofInt 16 value.integer) after) :
      Exec args (.write (.index (.variable "x".toList) index) .set rhs)
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
  | breakLoop (args : Args) (s : State) : Exec args .breakLoop s s .broken
  | seqBreak (args : Args) (a b : Stmt) (s t : State)
      (first : Exec args a s t .broken) : Exec args (.seq a b) s t .broken
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
  | whileBreak (args : Args) (test : Expr) (a : Stmt) (s t : State)
      (value : Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals value locals) (yes : truth value=true)
      (iteration : Exec args a (withLocals s locals) t .broken) :
      Exec args (.whileLoop test a) s t .normal
  | whileReturn (args : Args) (test : Expr) (a : Stmt) (s t : State) (ret : BitVec 64)
      (value : Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf test s.locals value locals) (yes : truth value=true)
      (iteration : Exec args a (withLocals s locals) t (.returned ret)) :
      Exec args (.whileLoop test a) s t (.returned ret)
  | forLoop (args : Args) (initial : Stmt) (test : Option Expr) (increment body : Stmt)
      (s t : State) (flow : Flow)
      (expanded : Exec args (desugar initial test increment body) s t flow) :
      Exec args (.loop initial test increment body) s t flow
  | ret (args : Args) (s : State) (e : Expr) (value : C99IntegerReference.Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf e s.locals (.integer value) locals) :
      Exec args (.ret e) s (withLocals s locals) (.returned (BitVec.ofInt 64 value.integer))

end FT1536.Source3.KeygenDecodeStaticExecution
