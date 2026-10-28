import Source3.SelectedBezoutPrefix217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Pinned source shape and exact highest nonzero word index for the length scan. -/
namespace FT1536.Source3.ExactLengthProgram217
open C99ArrayReference (Name)
open KeygenZintCall (Stmt)
open KeygenWordExpr (Expr)
open ZintNormWord194 (wskip)

def var (n : String) : CLogic.Expr := .var n.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def counter : Expr := .scalar (var "xlen")
def cond : Expr := .cmp .gt counter (.scalar (num 0))
def index : CLogic.Expr := .bin .sub (var "xlen") (num 1)
def test : Expr := .cmp .ne (.load32 "x".toList index) (.scalar (num 0))
def ret : Stmt := .word (.ret counter)
def dec : Stmt := ZintNormWord194.wordScalar (.update "xlen".toList .sub (num 1))
def yes : Stmt := .scope [] [] (.seq ret wskip)
def body : Stmt := .scope [] [] (.seq (.branch test yes wskip) (.seq dec wskip))
def loop : Stmt := .loop cond body wskip
def code : Stmt := .seq loop (.seq ret wskip)

theorem shape : KeygenZintCall.calleeBody .exactLen=code := by decide

def nonzero (w : BitVec 32) : Prop := (C99IntegerReference.Value.uint32 w).integer≠0
instance (w : BitVec 32) : Decidable (nonzero w) := by unfold nonzero; infer_instance
noncomputable def highest (W : Nat → BitVec 32) : Nat → Nat
  | 0 => 0
  | n+1 => by
    classical
    exact if nonzero (W n) then n+1 else highest W n

theorem highest_le (W : Nat → BitVec 32) (n : Nat) : highest W n ≤ n := by
  classical
  induction n with
  | zero => simp [highest]
  | succ n ih =>
    by_cases h : nonzero (W n)
    · simp [highest,h]
    · simp only [highest,h,ite_false]; omega

theorem highest_suffix_zero (W : Nat → BitVec 32) (n i : Nat) (lo : highest W n ≤ i) (hi : i<n) :
    ¬ nonzero (W i) := by
  classical
  induction n with
  | zero => omega
  | succ n ih =>
    by_cases h : nonzero (W n)
    · simp [highest,h] at lo; omega
    · by_cases equal : i=n
      · subst i; exact h
      · apply ih <;> simp [highest,h] at lo ⊢ <;> omega

theorem highest_last_nonzero (W : Nat → BitVec 32) (n : Nat) (positive : 0<highest W n) :
    nonzero (W (highest W n-1)) := by
  classical
  induction n with
  | zero => simp [highest] at positive
  | succ n ih =>
    by_cases h : nonzero (W n)
    · simp [highest,h]
    · have hp : 0<highest W n := by simpa [highest,h] using positive
      simpa [highest,h] using ih hp

end FT1536.Source3.ExactLengthProgram217
