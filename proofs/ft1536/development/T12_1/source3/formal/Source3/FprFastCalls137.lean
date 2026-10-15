import Source3.FprHeadersFast137
import Source3.FprTernary136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprFastCalls137
open B20.C (Val Name)
open C99ValueBridge (value)

inductive Kind where
  | add | mul | sub | neg | sqr | half | double
  deriving DecidableEq, Repr

def name : Kind → Name
  | .add => "fpr_add".toList | .mul => "fpr_mul".toList | .sub => "fpr_sub".toList
  | .neg => "fpr_neg".toList | .sqr => "fpr_sqr".toList | .half => "fpr_half".toList
  | .double => "fpr_double".toList

def lookup (called : Name) : Option Kind :=
  if called="fpr_add".toList then some .add
  else if called="fpr_mul".toList then some .mul
  else if called="fpr_sub".toList then some .sub
  else if called="fpr_neg".toList then some .neg
  else if called="fpr_sqr".toList then some .sqr
  else if called="fpr_half".toList then some .half
  else if called="fpr_double".toList then some .double
  else none

theorem lookup_name (called : Name) (kind : Kind) (found : lookup called=some kind) : called=name kind := by
  unfold lookup at found
  split_ifs at found <;> cases found <;> assumption

def binary (f : BitVec 64 → BitVec 64 → BitVec 64) : List Val → Option Val
  | [x,y] => match x,y with
    | .u64 x,.u64 y => some (.u64 (f x y))
    | _,_ => none
  | _ => none

def unary (f : BitVec 64 → BitVec 64) : List Val → Option Val
  | [x] => match x with
    | .u64 x => some (.u64 (f x))
    | _ => none
  | _ => none

def evaluate : Kind → List Val → Option Val
  | .add => binary FprAddFast137.word
  | .mul => binary FprMulFast137.word
  | .sub => binary FprHeadersFast137.sub
  | .neg => unary FprHeadersFast137.neg
  | .sqr => unary FprHeadersFast137.sqr
  | .half => unary FprHeadersFast137.half
  | .double => unary FprHeadersFast137.double

theorem binary_sound (called : Name) (f : BitVec 64 → BitVec 64 → BitVec 64)
    (source : ∀ x y, FprPrefixCalls.calls called [.uint64 x,.uint64 y] (.uint64 (f x y)))
    (args : List Val) (out : Val) (computed : binary f args=some out) :
    FprPrefixCalls.calls called (args.map value) (value out) := by
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
          exact source x y

theorem unary_sound (called : Name) (f : BitVec 64 → BitVec 64)
    (source : ∀ x, FprPrefixCalls.calls called [.uint64 x] (.uint64 (f x)))
    (args : List Val) (out : Val) (computed : unary f args=some out) :
    FprPrefixCalls.calls called (args.map value) (value out) := by
  cases args with
  | nil => cases computed
  | cons x rest =>
    cases rest with
    | cons _ _ => cases computed
    | nil =>
      cases x <;> try (solve | cases computed)
      case u64 x =>
        have same := Option.some.inj computed
        subst out
        exact source x

theorem evaluate_sound (kind : Kind) (args : List Val) (out : Val) (computed : evaluate kind args=some out) :
    FprPrefixCalls.calls (name kind) (args.map value) (value out) := by
  cases kind with
  | add => exact binary_sound _ _ FprAddFast137.source args out computed
  | mul => exact binary_sound _ _ FprMulFast137.source args out computed
  | sub => exact binary_sound _ _ FprHeadersFast137.sub_source args out computed
  | neg => exact unary_sound _ _ FprHeadersFast137.neg_source args out computed
  | sqr => exact unary_sound _ _ FprHeadersFast137.sqr_source args out computed
  | half => exact unary_sound _ _ FprHeadersFast137.half_source args out computed
  | double => exact unary_sound _ _ FprHeadersFast137.double_source args out computed

def calls (called : Name) (args : List Val) : Option Val :=
  match lookup called with
  | some kind => evaluate kind args
  | none => FprTernary136.calls called args

theorem sound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls := by
  intro called args out computed
  cases found : lookup called with
  | none => exact FprTernary136.sound called args out (by simpa only [calls,found] using computed)
  | some kind =>
    have evaluated : evaluate kind args=some out := by simpa only [calls,found] using computed
    rw [lookup_name called kind found]
    exact evaluate_sound kind args out evaluated

end FT1536.Source3.FprFastCalls137
