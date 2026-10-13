import Source3.KeygenPublicEncodeValues077
import Source3.KeygenPublicEncodeBinding077
import Source3.KeygenCodecExecution

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete public encoder source control with actual unsigned reads and
   physical byte stores. There are no arbitrary calls or result oracles. -/
namespace FT1536.Source3.KeygenPublicEncodeExecution077
open KeygenCodecSyntax KeygenPublicEncodeValues077 C99MemoryReference

abbrev byteOff := KeygenCodecExecution.byteOff
abbrev StoreByte := KeygenCodecExecution.StoreByte
abbrev Flow := KeygenCodecExecution.Flow
abbrev testExpr := KeygenCodecExecution.testExpr
abbrev desugar := KeygenCodecExecution.desugar
abbrev scopeObjects := KeygenCodecExecution.scopeObjects
abbrev scopeExit := KeygenCodecExecution.scopeExit

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
  | ret (args : Args) (s : State) (e : Expr) (value : C99IntegerReference.Value) (locals : Locals)
      (evaluated : Eval args s.heap s.buf e s.locals (.integer value) locals) :
      Exec args (.ret e) s (withLocals s locals) (.returned (BitVec.ofInt 64 value.integer))

def Call (args : Args) (before after : Memory) (ret : BitVec 64) : Prop :=
  ∃ final, Exec args KeygenPublicEncodeBinding077.code (initial args before) final (.returned ret) ∧ final.heap=after

end FT1536.Source3.KeygenPublicEncodeExecution077
