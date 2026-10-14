import Source3.ShakeXorCompute117
import Source3.ShakeProcessCompute116

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedRead118
open C99CompactState115 (State reference)
open ShakeExtractSource (Layout Field field)
open B20.C (Val)

def readCall (ctx : Layout) (state : State) (member : Field) : List Val → Option Val
  | [_] => (C99FiniteRead114.read64 state.heap (field ctx member)).map Val.u64
  | _ => none

theorem dptr_sound (ctx : Layout) (state : State) (args : List Val) (value : Val)
    (computed : readCall ctx state .dptr args=some value) :
    ShakeSeedReference.ReadCall ctx (reference state) (ShakeSeedProgram.readName .dptr)
      (args.map C99ValueBridge.value) (C99ValueBridge.value value) := by
  cases args with
  | nil => cases computed
  | cons dummy rest =>
      cases rest with
      | cons head tail => cases computed
      | nil =>
          obtain ⟨word,read,same⟩ := Option.map_eq_some_iff.mp computed
          subst value
          exact .dptr (C99ValueBridge.value dummy) word (C99FiniteRead114.read64_sound state.heap _ word read)

theorem rate_sound (ctx : Layout) (state : State) (args : List Val) (value : Val)
    (computed : readCall ctx state .rate args=some value) :
    ShakeSeedReference.ReadCall ctx (reference state) (ShakeSeedProgram.readName .rate)
      (args.map C99ValueBridge.value) (C99ValueBridge.value value) := by
  cases args with
  | nil => cases computed
  | cons dummy rest =>
      cases rest with
      | cons head tail => cases computed
      | nil =>
          obtain ⟨word,read,same⟩ := Option.map_eq_some_iff.mp computed
          subst value
          exact .rate (C99ValueBridge.value dummy) word (C99FiniteRead114.read64_sound state.heap _ word read)

def calls (ctx : Layout) (state : State) (name : C99ArrayReference.Name) (args : List Val) : Option Val :=
  if name=ShakeSeedProgram.readName .dptr then readCall ctx state .dptr args
  else if name=ShakeSeedProgram.readName .rate then readCall ctx state .rate args
  else none

theorem calls_sound (ctx : Layout) (state : State) :
    C99ExpressionSound.CallsSound (ShakeSeedReference.ReadCall ctx (reference state)) (calls ctx state) := by
  intro name args value computed
  unfold calls at computed
  split at computed
  next dptr => subst name; exact dptr_sound ctx state args value computed
  next other =>
    split at computed
    next rate => subst name; exact rate_sound ctx state args value computed
    next absent => cases computed

def evaluate (ctx : Layout) (state : State) (expression : CLogic.Expr) : Option Val :=
  C99CompactScalar115.evaluate (calls ctx state) state.locals expression

theorem evaluate_sound (ctx : Layout) (state : State) (expression : CLogic.Expr) (value : Val)
    (computed : evaluate ctx state expression=some value) :
    ShakeSeedReference.Eval ctx (reference state) expression (C99ValueBridge.value value) :=
  C99CompactScalar115.evaluate_sound (ShakeSeedReference.ReadCall ctx (reference state)) (calls ctx state)
    (calls_sound ctx state) state.locals expression value computed

end FT1536.Source3.ShakeSeedRead118
