import Source3.FprPrimitives

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Fuel removal for the EXISTING integer interpreter. This module is a
   resource lemma (A.3), not the independent C99 reference semantics (B). -/
namespace FT1536.Source3.ExpressionFuel
open B20.C
open FT1536.Source3.CLogic

def depth : CLogic.Expr → Nat
  | .literal _ _ | .var _ => 1
  | .cast _ e | .neg e | .bitNot e | .lnot e | .call1 _ e => depth e + 1
  | .bin _ a b | .cmp _ a b | .land a b | .lor a b | .call2 _ a b =>
      max (depth a) (depth b) + 1
  | .call3 _ a b c => max (depth a) (max (depth b) (depth c)) + 1

def unbounded (calls : B20.C.Scalar.Calls) (env : Env) : CLogic.Expr → Option Val
  | .literal ty n => some (literalValue ty n)
  | .var name => env name
  | .cast ty e => (unbounded calls env e).map (B20.C.cast ty)
  | .neg e => (unbounded calls env e).bind B20.C.neg
  | .bitNot e => (unbounded calls env e).map notBits
  | .bin op a b => do B20.C.bin op (← unbounded calls env a) (← unbounded calls env b)
  | .cmp op a b => do pure (compare op (← unbounded calls env a) (← unbounded calls env b))
  | .land a b => do
      let x ← unbounded calls env a
      if truth x then (unbounded calls env b).map (boolean ∘ truth) else pure (boolean false)
  | .lor a b => do
      let x ← unbounded calls env a
      if truth x then pure (boolean true) else (unbounded calls env b).map (boolean ∘ truth)
  | .lnot e => (unbounded calls env e).map (fun x => boolean (!truth x))
  | .call1 name e => do calls name [← unbounded calls env e]
  | .call2 name a b => do calls name [← unbounded calls env a, ← unbounded calls env b]
  | .call3 name a b c => do
      calls name [← unbounded calls env a, ← unbounded calls env b, ← unbounded calls env c]

theorem fuel_adequate (calls : B20.C.Scalar.Calls) (env : Env) (e : CLogic.Expr)
    (fuel : Nat) (h : depth e≤fuel) :
    CLogic.eval calls env fuel e=unbounded calls env e := by
  induction e generalizing fuel with
  | literal ty n => cases fuel <;> simp_all [depth,CLogic.eval,unbounded]
  | var name => cases fuel <;> simp_all [depth,CLogic.eval,unbounded]
  | cast ty e ih | neg e ih | bitNot e ih | lnot e ih | call1 name e ih =>
      cases fuel with
      | zero => simp [depth] at h
      | succ fuel =>
          have he : depth e≤fuel := by simp only [depth] at h; omega
          simp only [CLogic.eval,unbounded,ih fuel he]
  | bin op a b iha ihb | cmp op a b iha ihb | land a b iha ihb | lor a b iha ihb | call2 name a b iha ihb =>
      cases fuel with
      | zero => simp [depth] at h
      | succ fuel =>
          have ha : depth a≤fuel := by simp only [depth] at h; omega
          have hb : depth b≤fuel := by simp only [depth] at h; omega
          simp only [CLogic.eval,unbounded,iha fuel ha,ihb fuel hb]
  | call3 name a b c iha ihb ihc =>
      cases fuel with
      | zero => simp [depth] at h
      | succ fuel =>
          have ha : depth a≤fuel := by simp only [depth] at h; omega
          have hb : depth b≤fuel := by simp only [depth] at h; omega
          have hc : depth c≤fuel := by simp only [depth] at h; omega
          simp only [CLogic.eval,unbounded,iha fuel ha,ihb fuel hb,ihc fuel hc]

def stmtFits : CLogic.Stmt → Bool
  | .declare _ _ => true
  | .assign _ e | .update _ _ e | .ret e => decide (depth e≤32)

def bodyFits : Nat → List FprPrimitives.Instr → Bool
  | 0,_ => false
  | _+1,[] => true
  | fuel+1,.scalar stmt::rest => stmtFits stmt && bodyFits fuel rest
  | fuel+1,.norm m e::rest =>
      ((FprPrimitives.normStatements m e).map (List.all · stmtFits)).getD false && bodyFits fuel rest
  | fuel+1,.forInc _ _ body::rest => bodyFits fuel body && bodyFits fuel rest

end FT1536.Source3.ExpressionFuel

#check @FT1536.Source3.ExpressionFuel.fuel_adequate
#print FT1536.Source3.ExpressionFuel.fuel_adequate
#print axioms FT1536.Source3.ExpressionFuel.fuel_adequate
