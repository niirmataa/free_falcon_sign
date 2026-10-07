import Source3.KeygenSmallCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The actual short-circuit F/G gate. Context is the typed, read-only
   falcon_keygen field view at this local source boundary. The enclosing
   solver must derive that view and its preservation from its own execution.
   No search call, output bound or NTRU equation is an execution rule. -/
namespace FT1536.Source3.KeygenOutputGateSource
open C99ArrayReference (State Name Arg Bind)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)

structure Context where
  ternary : BitVec 32
  tmp : ArrayPointer

/- These synthetic names cannot be C identifiers. They are only the local
   lowering of the explicitly parsed member-access arguments below. -/
def view (ctx : Context) (s : State) : State :=
  { s with
    locals := C99ScalarReference.set s.locals "$fk.ternary".toList (.uint32,some (.uint32 ctx.ternary))
    arrays := fun name => if name="$fk.tmp".toList then some ctx.tmp else s.arrays name }

inductive Argument where
  | pointer (name : Name) (index : CLogic.Expr)
  | scalar (value : CLogic.Expr)
  | tmp (index : CLogic.Expr)
  | ternary
  deriving DecidableEq, Repr

def lower : Argument → Arg
  | .pointer name index => .pointer name index
  | .scalar value => .scalar value
  | .tmp index => .pointer "$fk.tmp".toList index
  | .ternary => .scalar (.var "$fk.ternary".toList)

def zero : CLogic.Expr := C99ProcedureParser.zero
def arguments (second : Bool) : List Argument := [
  .pointer (if second then "G".toList else "F".toList) zero,
  .tmp (if second then .var "n".toList else zero),
  .scalar (.var "logn".toList),.ternary]

inductive Condition where
  | call (args : List Argument)
  | negate (value : Condition)
  | either (left right : Condition)
  deriving DecidableEq, Repr

def condition : Condition := .either (.negate (.call (arguments false))) (.negate (.call (arguments true)))

def memberPointer : List B20.C.Token → Option (Argument × List B20.C.Token)
  | ['f','k']::['-']::['>']::['t','m','p']::['+']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      pure (.tmp index,rest)
  | ['f','k']::['-']::['>']::['t','m','p']::rest => some (.tmp zero,rest)
  | rest => do
      let (arg,rest) ← C99ProcedureParser.pointerExpr rest
      match arg with
      | .pointer name index => pure (.pointer name index,rest)
      | _ => none

def callTokens : List B20.C.Token → Option (Condition × List B20.C.Token)
  | ['p','o','l','y','_','b','i','g','_','t','o','_','s','m','a','l','l']::['(']::rest => do
      let (dst,rest) ← memberPointer rest
      match rest with
      | [',']::rest => do
          let (src,rest) ← memberPointer rest
          match rest with
          | [',']::rest => do
              let (logn,rest) ← C99ArrayParser.pureExpr rest
              match rest with
              | [',']::['f','k']::['-']::['>']::['t','e','r','n','a','r','y']::[')']::rest =>
                  pure (.call [dst,src,.scalar logn,.ternary],rest)
              | _ => none
          | _ => none
      | _ => none
  | _ => none

def gateTokens : List B20.C.Token → Option Condition
  | ['i','f']::['(']::['!']::rest => do
      let (first,rest) ← callTokens rest
      match rest with
      | ['|','|']::['!']::rest => do
          let (second,rest) ← callTokens rest
          if rest=[[')'],['{'],['r','e','t','u','r','n'],['0'],[';'],['}']] then
            pure (.either (.negate first) (.negate second)) else none
      | _ => none
  | _ => none

def parsed : Option Condition :=
  (C99ProcedureParser.tokens (((Pinned.keygenLines.drop 7341).take 5).flatMap String.toList)).bind gateTokens

theorem source_bound : parsed=some condition := by decide

inductive Call (ctx : Context) (args : List Argument) (before : State) : State → Value → Prop where
  | run (entry : State) (out : Result) (v : Value)
      (binding : Bind (view ctx before) KeygenSmallCalls.params (args.map lower) entry)
      (body : KeygenSmallSource.Exec KeygenSmallSource.code entry out)
      (returned : out.flow=.returned (some v)) :
      Call ctx args before {before with heap := out.state.heap} (C99IntegerReference.convert .int32 v.integer)

inductive Evaluate (ctx : Context) : Condition → State → State → Bool → Prop where
  | call (args : List Argument) (before after : State) (v : Value)
      (body : Call ctx args before after v) : Evaluate ctx (.call args) before after (decide (v.integer≠0))
  | negate (value : Condition) (before after : State) (v : Bool)
      (inner : Evaluate ctx value before after v) : Evaluate ctx (.negate value) before after (!v)
  | shortCircuit (left right : Condition) (before after : State)
      (first : Evaluate ctx left before after true) : Evaluate ctx (.either left right) before after true
  | second (left right : Condition) (before middle after : State) (v : Bool)
      (first : Evaluate ctx left before middle false) (second : Evaluate ctx right middle after v) :
      Evaluate ctx (.either left right) before after v

inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | failed (middle : State) (out : Result) (guard : Evaluate ctx condition before middle true)
      (body : KeygenSmallSource.Exec (.scope [] (KeygenSmallSource.chain [KeygenSmallSource.ret 0])) middle out) :
      Exec ctx before out
  | passed (after : State) (guard : Evaluate ctx condition before after false) : Exec ctx before ⟨after,.normal⟩

theorem call_frame (ctx : Context) (args : List Argument) (before after : State) (v : Value)
    (source : Call ctx args before after v) : after.locals=before.locals ∧ after.arrays=before.arrays := by
  cases source
  exact ⟨rfl,rfl⟩

theorem negate_call_false (ctx : Context) (args : List Argument) (before after : State)
    (source : Evaluate ctx (.negate (.call args)) before after false) :
    ∃ v : Value, Call ctx args before after v ∧ v.integer≠0 := by
  generalize equal : false=flag at source
  cases source with
  | negate value before after v inner =>
    cases inner with
    | call args before after v body =>
      refine ⟨v,body,?_⟩
      simpa using equal

theorem passed_calls (ctx : Context) (before : State) (out : Result)
    (source : Exec ctx before out) (normal : out.flow=.normal) :
    ∃ middle a b, Call ctx (arguments false) before middle a ∧ a.integer≠0 ∧
      Call ctx (arguments true) middle out.state b ∧ b.integer≠0 := by
  cases source with
  | failed middle out guard body =>
    have aborted := KeygenSmallStep.reject_result middle out body
    rw [aborted] at normal
    cases normal
  | passed after guard =>
    cases guard with
    | second left right before middle after v first second =>
      obtain ⟨a,ha,hna⟩ := negate_call_false ctx (arguments false) before middle first
      obtain ⟨b,hb,hnb⟩ := negate_call_false ctx (arguments true) middle after second
      exact ⟨middle,a,b,ha,hna,hb,hnb⟩

end FT1536.Source3.KeygenOutputGateSource
