import Source3.KeygenDecodeDispatchBinding
import Source3.KeygenDecodeNoneComplete

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Dispatcher reference for the NONE mode and fallback. Every reachable
   NONE callee executes its complete pinned body. STATIC is outside this
   mode-specific relation and must receive its own fixed-body semantics;
   there is no arbitrary or assumed-correct STATIC call constructor. -/
namespace FT1536.Source3.KeygenDecodeNoneDispatchExecution
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference

/-- The five actual source arguments are evaluated in the caller activation.
    comp is retained reference metadata, unused by uncompress_none; it is
    not an extra C argument and does not assert a codec result. -/
structure CallArgs (args : Args) (s : State) (called : Args) : Prop where
  data : called.data=args.data
  x : called.x=s.locals.x
  q : s.locals.scalars "q".toList=some (.uint32,some (.uint32 called.q))
  logn : s.locals.scalars "logn".toList=some (.uint32,some (.uint32 called.logn))
  len : s.locals.scalars "len".toList=some (.uint64,some (.uint64 called.len))
  metadata : called.comp=args.comp

inductive Exec : Args → Stmt → State → State → Flow → Prop where
  | skip (args : Args) (s : State) : Exec args .skip s s .normal
  | seq (args : Args) (a b : Stmt) (s middle t : State) (flow : Flow)
      (first : Exec args a s middle .normal) (second : Exec args b middle t flow) : Exec args (.seq a b) s t flow
  | seqReturn (args : Args) (a b : Stmt) (s t : State) (ret : BitVec 64)
      (first : Exec args a s t (.returned ret)) : Exec args (.seq a b) s t (.returned ret)
  | scope (args : Args) (body : Stmt) (s t : State) (flow : Flow)
      (inside : Exec args body s t flow) : Exec args (.scope body) s (scopeExit body s t) flow
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
  | callNone (args called : Args) (s t : State) (ret : BitVec 64)
      (arguments : CallArgs args s called)
      (execution : KeygenDecodeExecution.Exec called KeygenDecodeNoneBinding.code (initial called s.heap) t (.returned ret)) :
      Exec args (.ret (.call .none calleeArgs)) s t (.returned ret)

def Call (args : Args) (before after : Memory) (ret : BitVec 64) : Prop :=
  ∃ final, Exec args KeygenDecodeDispatchBinding.code (initial args before) final (.returned ret) ∧ final.heap=after

end FT1536.Source3.KeygenDecodeNoneDispatchExecution
