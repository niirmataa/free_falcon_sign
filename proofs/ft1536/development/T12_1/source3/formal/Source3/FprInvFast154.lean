import Source3.FprDivFast154
import Source3.FprHeaderEval137

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprInvFast154
open B20.C (Val)
open FprHeaderEval137

def calls (name : B20.C.Name) (args : List Val) : Option Val :=
  if name="fpr_div".toList then
    match args with
    | [x,y] => match x,y with
      | .u64 x,.u64 y => some (.u64 (FprDivFast154.word x y))
      | _,_ => none
    | _ => none
  else none

theorem sound : C99ExpressionSound.CallsSound FprPrefixCalls.ofCalls calls := by
  intro name args out computed
  unfold calls at computed
  split_ifs at computed with divName
  subst name
  cases args with
  | nil => cases computed
  | cons x rest =>
    cases rest with
    | nil => cases computed
    | cons y tail =>
      cases tail with
      | cons _ _ => cases computed
      | nil =>
        cases x <;> cases y <;> try (solve | cases computed)
        case u64.u64 x y =>
          have same := Option.some.inj computed
          subst out
          exact FprDivFast154.source x y

def word (x : BitVec 64) : BitVec 64 := FprDivFast154.word Run2.KeygenLeafGate.oneBits x

theorem computed (x : BitVec 64) : returning calls FprPrefixCalls.invCode.body (unaryLocals x)=some (.u64 (word x)) := by
  simp [returning,FprPrefixCalls.invCode,unaryLocals,word,calls,
    C99CompactScalar115.evaluate,ExpressionFuel.unbounded,C99CompactCells115.model,
    C99NameMap115.lookup,C99CompactCells115.Cell.value]

theorem source (x : BitVec 64) : FprPrefixCalls.calls "fpr_inv".toList [.uint64 x] (.uint64 (word x)) := by
  unfold FprPrefixCalls.calls
  rw [show FprPrefixCalls.lookup "fpr_inv".toList=some FprPrefixCalls.invCode by exact FprPrefixCalls.inv_source]
  exact unary _ calls sound _ rfl rfl x (word x) (computed x)

end FT1536.Source3.FprInvFast154
