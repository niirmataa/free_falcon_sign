import Source3.FprAllTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprBlockFuel
open B20.C

theorem more_fuel_same (fuel extra : Nat) (body : List FprPrimitives.Instr)
    (result : Ty) (s : B20.C.Scalar.State)
    (h : ExpressionFuel.bodyFits fuel body=true) :
    FprPrimitives.execBlock (fuel+extra) result body s=
      FprPrimitives.execBlock fuel result body s := by
  induction fuel generalizing body s with
  | zero => simp [ExpressionFuel.bodyFits] at h
  | succ fuel ih =>
      cases body with
      | nil => simp [Nat.succ_add,FprPrimitives.execBlock]
      | cons stmt rest =>
          cases stmt with
          | scalar statement =>
              have hr : ExpressionFuel.bodyFits fuel rest=true := by
                exact (Bool.and_eq_true _ _ |>.mp h).2
              cases statement with
              | ret _ => simp [Nat.succ_add,FprPrimitives.execBlock]
              | declare ty names => simp [FprPrimitives.execBlock,Nat.succ_add,ih rest _ hr]
              | assign name e => simp [FprPrimitives.execBlock,Nat.succ_add,ih rest _ hr]
              | update name op e => simp [FprPrimitives.execBlock,Nat.succ_add,ih rest _ hr]
          | norm mant exp =>
              have hr : ExpressionFuel.bodyFits fuel rest=true := by
                exact (Bool.and_eq_true _ _ |>.mp h).2
              simp [FprPrimitives.execBlock,Nat.succ_add,ih rest _ hr]
          | forInc index n inner =>
              have hb : ExpressionFuel.bodyFits fuel inner=true := (Bool.and_eq_true _ _ |>.mp h).1
              have hr : ExpressionFuel.bodyFits fuel rest=true := (Bool.and_eq_true _ _ |>.mp h).2
              simp [FprPrimitives.execBlock,Nat.succ_add,ih inner _ hb,ih rest _ hr]

theorem pinned_add_fuel (s : B20.C.Scalar.State) (extra : Nat) :
    FprPrimitives.execBlock (256+extra) .u64 FprAST.addCode.body s=
      FprPrimitives.execBlock 256 .u64 FprAST.addCode.body s := by
  have h := ExpressionFuel.add_exprs_fit
  rw [FprAST.add_binding] at h
  exact more_fuel_same 256 extra _ _ s (Option.some.inj h)

theorem pinned_mul_fuel (s : B20.C.Scalar.State) (extra : Nat) :
    FprPrimitives.execBlock (256+extra) .u64 FprAST.mulCode.body s=
      FprPrimitives.execBlock 256 .u64 FprAST.mulCode.body s := by
  have h := ExpressionFuel.mul_exprs_fit
  rw [FprAST.mul_binding] at h
  exact more_fuel_same 256 extra _ _ s (Option.some.inj h)

theorem pinned_div_fuel (s : B20.C.Scalar.State) (extra : Nat) :
    FprPrimitives.execBlock (256+extra) .u64 FprAST.divCode.body s=
      FprPrimitives.execBlock 256 .u64 FprAST.divCode.body s := by
  have h := ExpressionFuel.div_exprs_fit
  rw [FprAST.div_binding] at h
  exact more_fuel_same 256 extra _ _ s (Option.some.inj h)

end FT1536.Source3.FprBlockFuel

#print axioms FT1536.Source3.FprBlockFuel.more_fuel_same
#print axioms FT1536.Source3.FprBlockFuel.pinned_add_fuel
#print axioms FT1536.Source3.FprBlockFuel.pinned_mul_fuel
#print axioms FT1536.Source3.FprBlockFuel.pinned_div_fuel
