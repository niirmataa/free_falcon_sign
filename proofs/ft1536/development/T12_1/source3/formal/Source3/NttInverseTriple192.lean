import Source3.NttInversePrologue192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Execution of the full-only divide-by-three pass of the accepted
   modp_iNTT3_ext corpus at full=0: the guard is false and the pass is the
   original skipped branch. No full=1 instance is constructed here. -/
namespace FT1536.Source3.NttInverseTriple192
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)

theorem no_skip : NttInversePrograms192.tripleNo=
    C99ModularReference.Stmt.base C99ArrayReference.Stmt.skip := by decide

theorem source (s : State) (full : Slot s "full" 0) :
    Exec NttInversePrograms192.triplePass s ⟨s,.normal⟩ := by
  have guard : C99ArrayReference.scalar s (CLogic.Expr.var "full".toList) (.uint32 0) :=
    .variable _ _ _ full
  have zero : (C99IntegerReference.Value.uint32 0).integer=0 := rfl
  have branchRun : Exec NttInversePrograms192.tripleGuard s ⟨s,.normal⟩ := by
    exact .branchFalse _ _ _ s ⟨s,.normal⟩ (.uint32 0) guard zero
      (by rw [no_skip]; exact .base _ _ _ (.skip s))
  exact .seqNormal _ _ s s _ branchRun (.base _ _ _ (.skip s))

end FT1536.Source3.NttInverseTriple192
