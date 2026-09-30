import Source3.FprUnsignedPrefixes

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprScalarSequence
open B20.C

theorem scalar_prefix (stmts : List CLogic.Stmt) (s out : B20.C.Scalar.State)
    (h : UnsignedState.exec FprPrimitives.headerCalls s stmts=some out)
    (rest : List FprPrimitives.Instr) (fuel : Nat) (result : Ty) :
    FprPrimitives.execBlock (fuel+stmts.length) result
      (stmts.map FprPrimitives.Instr.scalar ++ rest) s =
      FprPrimitives.execBlock fuel result rest out := by
  induction stmts generalizing s with
  | nil =>
      have heq : s=out := Option.some.inj h
      subst out
      rfl
  | cons stmt tail ih =>
      obtain ⟨next,hstep,htail⟩ := Option.bind_eq_some_iff.mp h
      have hf : fuel+(stmt::tail).length=(fuel+tail.length)+1 := by simp; omega
      rw [hf]
      cases stmt with
      | ret _ => simp [CLogic.step] at hstep
      | declare ty names =>
          simp only [List.map_cons,List.cons_append,FprPrimitives.execBlock]
          have he : FprPrimitives.execScalar s (.declare ty names)=some next := hstep
          rw [he]
          exact ih next htail
      | assign name e =>
          simp only [List.map_cons,List.cons_append,FprPrimitives.execBlock]
          have he : FprPrimitives.execScalar s (.assign name e)=some next := hstep
          rw [he]
          exact ih next htail
      | update name op e =>
          simp only [List.map_cons,List.cons_append,FprPrimitives.execBlock]
          have he : FprPrimitives.execScalar s (.update name op e)=some next := hstep
          rw [he]
          exact ih next htail

theorem get_u64 (ctx : UnsignedState.Ctx) (s : B20.C.Scalar.State) (name : Name)
    (hg : UnsignedState.Good ctx s) (ht : ctx.initialized name=some .u64) :
    ∃ w : BitVec 64, s.values name=some (.u64 w) := by
  obtain ⟨v,hv,hvt⟩ := hg.2 name .u64 ht
  cases v with
  | u64 w => exact ⟨w,hv⟩
  | i64 _ | i32 _ | u32 _ => contradiction

theorem exec_append (a b : List CLogic.Stmt) (s : B20.C.Scalar.State) :
    UnsignedState.exec FprPrimitives.headerCalls s (a++b)=
      (UnsignedState.exec FprPrimitives.headerCalls s a).bind
        (fun t => UnsignedState.exec FprPrimitives.headerCalls t b) := by
  induction a generalizing s with
  | nil => rfl
  | cons stmt rest ih =>
      simp [UnsignedState.exec,ih,Option.bind_assoc]

theorem exec_scalars (body : List CLogic.Stmt) (s : B20.C.Scalar.State) :
    FprPrimitives.execScalars body s=UnsignedState.exec FprPrimitives.headerCalls s body := by
  induction body generalizing s with
  | nil => rfl
  | cons stmt rest ih =>
      simp [FprPrimitives.execScalars,FprPrimitives.execScalar,UnsignedState.exec,ih]

end FT1536.Source3.FprScalarSequence

#print axioms FT1536.Source3.FprScalarSequence.scalar_prefix
