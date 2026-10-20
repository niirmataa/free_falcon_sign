import Source3.ExpressionFuel

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.UnsignedSafety
open B20.C

def unsigned : Ty → Bool
  | .u64 | .u32 => true
  | _ => false

def ordinary : BinOp → Bool
  | .shl | .shr => false
  | _ => true

def width : Ty → Nat
  | .u64 | .i64 => 64
  | .u32 | .i32 => 32

theorem cast_type (t : Ty) (v : Val) : (B20.C.cast t v).ty=t := by
  cases t <;> cases v <;> rfl

theorem bin_unsigned_total (op : BinOp) (x y : Val)
    (ho : ordinary op=true) (ht : unsigned (commonTy x.ty y.ty)=true) :
    ∃ z, bin op x y=some z ∧ z.ty=commonTy x.ty y.ty := by
  cases op <;> cases x <;> cases y <;>
    simp_all [ordinary,unsigned,bin,commonTy,Val.ty,B20.C.cast,bitsOp]

theorem shift_literal_total (op : BinOp) (x : Val) (n : Nat)
    (ho : op=.shl ∨ op=.shr) (hu : unsigned x.ty=true)
    (hn : n<width x.ty) :
    ∃ z, bin op x (.i32 (BitVec.ofNat 32 n))=some z ∧ z.ty=x.ty := by
  have hn64 : n<64 := by cases x <;> simp_all [width,Val.ty] <;> omega
  have hn32 : n<2^32 := by omega
  rcases ho with rfl | rfl <;> cases x <;>
    simp_all [unsigned,width,Val.ty,bin,shift,BitVec.toNat_ofNat,Nat.mod_eq_of_lt]

theorem unsigned_neg_total (x : Val) (hu : unsigned x.ty=true) :
    ∃ z, neg x=some z ∧ z.ty=x.ty := by
  cases x <;> simp_all [unsigned,Val.ty,neg]

abbrev TEnv := B20.C.Name → Option Ty

def fixedCount : CLogic.Expr → Option Nat
  | .literal .i32 n => some n
  | _ => none

theorem fixed_count (e : CLogic.Expr) (n : Nat) (h : fixedCount e=some n) :
    e=CLogic.Expr.literal .i32 n := by
  cases e with
  | literal t k => cases t <;> simp_all [fixedCount]
  | _ => simp [fixedCount] at h

def infer (ctx : TEnv) : CLogic.Expr → Option Ty
  | .literal t _ => some t
  | .var name => ctx name
  | .cast ty e => do let _ ← infer ctx e; pure ty
  | .neg e => do
      let ty ← infer ctx e
      if unsigned ty then some ty else none
  | .bitNot e => infer ctx e
  | .bin op a b => do
      let ta ← infer ctx a
      let tb ← infer ctx b
      if op=.shl ∨ op=.shr then do
        let n ← fixedCount b
        if unsigned ta && n<width ta then some ta else none
      else if ordinary op && unsigned (commonTy ta tb) then some (commonTy ta tb) else none
  | _ => none

def EnvTyped (ctx : TEnv) (env : Env) : Prop :=
  ∀ name ty, ctx name=some ty → ∃ v, env name=some v ∧ v.ty=ty

theorem expr_total (calls : B20.C.Scalar.Calls) (ctx : TEnv) (env : Env) (e : CLogic.Expr) (ty : Ty)
    (hctx : EnvTyped ctx env) (hinfer : infer ctx e=some ty) :
    ∃ v, ExpressionFuel.unbounded calls env e=some v ∧ v.ty=ty := by
  induction e generalizing ty with
  | literal t n =>
      have heq : t=ty := Option.some.inj hinfer
      subst ty
      exact ⟨literalValue t n,rfl,by cases t <;> rfl⟩
  | var name => exact hctx name ty hinfer
  | cast target arg ih =>
      obtain ⟨t,hi,hret⟩ := Option.bind_eq_some_iff.mp hinfer
      have heq : target=ty := Option.some.inj hret
      subst ty
      obtain ⟨v,hv,_⟩ := ih t hi
      exact ⟨B20.C.cast target v,by simp [ExpressionFuel.unbounded,hv],cast_type target v⟩
  | neg arg ih =>
      obtain ⟨t,hi,hret⟩ := Option.bind_eq_some_iff.mp hinfer
      have hu : unsigned t=true := by
        by_contra no
        simp [no] at hret
      have heq : t=ty := Option.some.inj (by simpa [hu] using hret)
      subst ty
      obtain ⟨v,hv,hvt⟩ := ih t hi
      obtain ⟨z,hz,hzt⟩ := unsigned_neg_total v (by simpa [hvt] using hu)
      exact ⟨z,by simp [ExpressionFuel.unbounded,hv,hz],hzt.trans hvt⟩
  | bitNot arg ih =>
      obtain ⟨v,hv,hvt⟩ := ih ty hinfer
      refine ⟨notBits v,by simp [ExpressionFuel.unbounded,hv],?_⟩
      cases v <;> exact hvt
  | bin op a b iha ihb =>
      obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp hinfer
      obtain ⟨tb,hb,hr⟩ := Option.bind_eq_some_iff.mp hr
      obtain ⟨x,hx,hxt⟩ := iha ta ha
      obtain ⟨y,hy,hyt⟩ := ihb tb hb
      by_cases ho : op=.shl ∨ op=.shr
      · simp only [ho,ite_true] at hr
        obtain ⟨n,hcount,hr⟩ := Option.bind_eq_some_iff.mp hr
        have hfixed : b=CLogic.Expr.literal .i32 n := fixed_count b n hcount
        have hcond : unsigned ta=true ∧ n<width ta := by
          by_cases hg : unsigned ta && decide (n<width ta)
          · simpa using hg
          · simp [hg] at hr
        have heq : ta=ty := by simpa [hcond.1,hcond.2] using hr
        subst ty
        have hyval : y=Val.i32 (BitVec.ofNat 32 n) := by
          rw [hfixed] at hy
          exact (Option.some.inj hy).symm
        subst y
        obtain ⟨z,hz,hzt⟩ := shift_literal_total op x n ho (by simpa [hxt] using hcond.1)
          (by simpa [hxt] using hcond.2)
        exact ⟨z,by simp [ExpressionFuel.unbounded,hx,hy,hz],hzt.trans hxt⟩
      · simp only [ho,ite_false] at hr
        have hcond : ordinary op=true ∧ unsigned (commonTy ta tb)=true := by
          by_cases hg : ordinary op && unsigned (commonTy ta tb)
          · simpa using hg
          · simp [hg] at hr
        have heq : commonTy ta tb=ty := Option.some.inj (by simpa [hcond.1,hcond.2] using hr)
        obtain ⟨z,hz,hzt⟩ := bin_unsigned_total op x y hcond.1 (by
          simpa [hxt,hyt] using hcond.2)
        exact ⟨z,by simp [ExpressionFuel.unbounded,hx,hy,hz],by simpa [hxt,hyt,heq] using hzt⟩
  | cmp _ _ _ _ _ | land _ _ _ _ | lor _ _ _ _ | lnot _ _ | call1 _ _ _ | call2 _ _ _ _ _ | call3 _ _ _ _ _ _ _ => simp [infer] at hinfer

end FT1536.Source3.UnsignedSafety

#print axioms FT1536.Source3.UnsignedSafety.bin_unsigned_total
#print axioms FT1536.Source3.UnsignedSafety.shift_literal_total
