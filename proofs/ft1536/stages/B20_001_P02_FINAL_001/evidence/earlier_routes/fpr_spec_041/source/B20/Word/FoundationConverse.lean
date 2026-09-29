import B20.Foundation.CExec

namespace B20.Foundation

/-- The missing converse for exactly P01's existing inductive relation.
It does not add abort or alter P01's sequencing/memory semantics. -/
theorem CExec_eval {p : Program} {s : State} {o : Outcome} (h : CExec p s o) :
    evalStmt p s = o := by
  induction h with
  | skip => rfl
  | assign_ok h => simp [evalStmt, h]
  | assign_err h => simp [evalStmt, h]
  | store_ok h => simp [evalStmt, h]
  | store_err h => simp [evalStmt, h]
  | ret_ok h => simp [evalStmt, h]
  | ret_err h => simp [evalStmt, h]
  | seq_returned _ _ ihp ihq => simp [evalStmt, ihp, ihq]
  | seq_stuck _ ih => simp [evalStmt, ih]
  | seq_abort _ ih => simp [evalStmt, ih]
  | seq_nonreturn _ ih => simp [evalStmt, ih]
  | seq_fault _ ih => simp [evalStmt, ih]
  | assume_false => rfl
  | unimplemented => rfl

theorem CExec_iff_eval (p : Program) (s : State) (o : Outcome) :
    CExec p s o ↔ evalStmt p s = o :=
  ⟨CExec_eval, evalStmt_sound_gen p s o⟩

theorem CExec_deterministic {p : Program} {s : State} {o₁ o₂ : Outcome}
    (h₁ : CExec p s o₁) (h₂ : CExec p s o₂) : o₁ = o₂ :=
  (CExec_eval h₁).symm.trans (CExec_eval h₂)

#print axioms CExec_eval
#print axioms CExec_iff_eval
#print axioms CExec_deterministic

end B20.Foundation
