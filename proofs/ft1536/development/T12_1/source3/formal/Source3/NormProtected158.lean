import Source3.KeygenAttemptNorm133
import Source3.C99CompactState115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NormProtected158

theorem lookup_property {α : Type} (rows : C99NameMap115.Table α) (predicate : α → Bool)
    (checked : rows.all (fun row => predicate row.2)=true) (name : C99ArrayReference.Name) (value : α)
    (found : C99NameMap115.lookup rows name=some value) : predicate value=true := by
  induction rows with
  | nil => cases found
  | cons row rest ih =>
    rcases row with ⟨key,item⟩
    have checks := Bool.and_eq_true_iff.mp checked
    by_cases same : name=key
    · simp only [C99NameMap115.lookup,ite_eq_left same] at found
      have equal := Option.some.inj found
      subst value
      exact checks.1
    · simp only [C99NameMap115.lookup,ite_eq_right same] at found
      exact ih checks.2 found

def arraysCheck (before : C99CompactState115.State) (block : Nat) : Bool :=
  KeygenAttemptNorm.writable.all (fun name =>
    ((C99NameMap115.lookup before.arrays name).map (fun p => decide (p.block≠block))).getD true)
def tablesCheck (before : C99CompactState115.State) (block : Nat) : Bool :=
  before.tables.all (fun row => decide (row.2.block≠block))

theorem source (ctx : KeygenSearchContext.Context) (before : C99CompactState115.State) (block : Nat)
    (scratch : ctx.scratch.block≠block) (arrays : arraysCheck before block=true) (tables : tablesCheck before block=true) :
    KeygenAttemptNorm133.Protected ctx (C99CompactState115.reference before) block := by
  refine ⟨scratch,?_,?_⟩
  · intro name member p binding
    have checked := List.all_eq_true.mp arrays name member
    change C99NameMap115.lookup before.arrays name=some p at binding
    rw [binding] at checked
    exact of_decide_eq_true checked
  · intro name p binding
    exact of_decide_eq_true (lookup_property before.tables (fun p => decide (p.block≠block)) tables name p binding)

end FT1536.Source3.NormProtected158
