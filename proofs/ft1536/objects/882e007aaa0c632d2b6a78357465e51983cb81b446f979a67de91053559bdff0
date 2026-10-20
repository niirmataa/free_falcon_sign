import Source3.StableTop001Outcome

namespace FT1536.Source3.StableTop001Audit
open StableTopSyntax

theorem wrong_u_step_detected : parseFor ((tokens "for (u = 0, v = 0; u < 768; u += 2, v ++) {").getD [])=
    some ⟨0,0,768,2,1⟩ ∧ parseFor ((tokens "for (u = 0, v = 0; u < 768; u += 2, v ++) {").getD [])≠some expected.loop := by decide
theorem wrong_v_step_detected : parseFor ((tokens "for (u = 0, v = 0; u < 768; u += 3, v += 2) {").getD [])=none := by decide

def swappedStores : List Stmt := expected.body.map fun s => match s with
  | .storeCheck 0 e => .storeCheck 256 e
  | .storeCheck 256 e => .storeCheck 0 e
  | other => other
theorem swapped_offsets_break_source_binding : source≠some {expected with body := swappedStores} := by
  rw [pinned_source]
  decide

theorem association_is_preserved :
    wordExpr ((CLogicParser.expression 16 ((tokens "fpr_add(fpr_add(a,b),c)").getD [])).getD (.var [],[])).1=
      some (.bin .add (.bin .add (v "a") (v "b")) (v "c")) ∧
    (.bin .add (.bin .add (v "a") (v "b")) (v "c") : Expr)≠.bin .add (v "a") (.bin .add (v "b") (v "c")) := by decide
theorem callee_mutation_changes_expr :
    wordExpr (.call2 "fpr_mul".toList (.var ['a','b']) (.var ['c']))≠
      wordExpr (.call2 "fpr_add".toList (.var ['a','b']) (.var ['c'])) := by decide
theorem wrong_binary_address_breaks_binding : source≠some {expected with branches := [⟨0,256⟩,⟨0,256⟩,⟨512,256⟩]} := by
  rw [pinned_source]
  decide

theorem reference_step_records_one (l : StableTopMemory.Layout) (u v : Nat) (stmt : Stmt)
    (s out : StableTopReference.State) (h : StableTopReference.Step l u v stmt s out) :
    out.memory.checks.length=s.memory.checks.length+1 := by
  cases h with
  | read name delta s mid raw w _ hc | «local» name expr s mid raw w _ hc => simp [hc.2]
  | write off expr s mid out raw w _ hc hw => simp [hw.2,hc.2]

theorem omitted_control_detected (l : StableTopMemory.Layout) (u v : Nat) (stmt : Stmt)
    (s out : StableTopReference.State) (h : StableTopReference.Step l u v stmt s out) :
    out.memory.checks.length≠s.memory.checks.length := by
  have hc := reference_step_records_one l u v stmt s out h
  omega

theorem reset_between_branches_impossible (l : StableTopMemory.Layout)
    (before after : C99MemoryReference.Memory) (checks : List (BitVec 64))
    (hl : StableTopMemory.WellFormed l) (legal : StableTopMemory.Legal l (C99MemoryBridge.encode before))
    (source : StableTopReference.PinnedExec l before after checks)
    (initial : StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some 7) :
    StableBinaryByteView.flagRead (C99MemoryBridge.encode after) l.bad≠some 0 := by
  have h := StableTop001Outcome.source_outcome l before after checks hl legal source
  exact h.2.2.2.2.2.1 7 initial (by decide)

end FT1536.Source3.StableTop001Audit

#print axioms FT1536.Source3.StableTop001Audit.wrong_u_step_detected
#print axioms FT1536.Source3.StableTop001Audit.association_is_preserved
#print axioms FT1536.Source3.StableTop001Audit.omitted_control_detected
#print axioms FT1536.Source3.StableTop001Audit.reset_between_branches_impossible
