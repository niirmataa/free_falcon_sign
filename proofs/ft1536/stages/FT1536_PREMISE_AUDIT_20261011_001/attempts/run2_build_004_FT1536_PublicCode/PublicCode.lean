import FT1536.PublicSimulation
import FT1536.ROM

namespace FT1536.PublicSimulation
open ROM
variable {H History M R C S : Type} [DecidableEq M] [DecidableEq R]

/- Executable relative to the supplied public sampler. Returned outer `none`
means stopped/no win; `some none` is observable PRE_ABORT. The state on every
branch records the submitted message. A target list and a secret are absent
from this interface. -/
def simSign (sam : PublicSampler H History M R C (Option S))
    (project : State R M C → History) (h : H) (s : State R M C)
    (m : M) (ready : Bool) (r : R) (coins : Fin sam.coinCount) :
    State R M C × Option (MathSign.Observation R S) :=
  let st := submit m s
  if ready then
    match lookup (r,m) st with
    | some _ => (st, none)
    | none =>
      let co := sam.run h (project st) m r coins
      (⟨⟨(r,m),co.1,none⟩ :: st.table, st.seen, st.used⟩, some (some (r,co.2)))
  else (st, some none)

theorem simSign_invariants (sam : PublicSampler H History M R C (Option S))
    (project : State R M C → History) (h : H) (s : State R M C)
    (m : M) (ready : Bool) (r : R) (coins : Fin sam.coinCount)
    (targets : ℕ → C) (hg : Good targets s) :
    Good targets (simSign sam project h s m ready r coins).1 ∧
    (simSign sam project h s m ready r coins).1.used = s.used ∧
    m ∈ (simSign sam project h s m ready r coins).1.seen := by
  unfold simSign
  dsimp only
  split
  · split
    · exact ⟨submit_good _ _ _ hg, rfl, submitted_even_on_abort _ _⟩
    · refine ⟨?_, rfl, submitted_even_on_abort _ _⟩
      intro e he
      rcases List.mem_cons.mp he with rfl | he
      · exact submitted_even_on_abort _ _
      · exact submit_good targets m s hg e he
  · exact ⟨submit_good _ _ _ hg, rfl, submitted_even_on_abort _ _⟩

theorem simSign_table_growth (sam : PublicSampler H History M R C (Option S))
    (project : State R M C → History) (h : H) (s : State R M C)
    (m : M) (ready : Bool) (r : R) (coins : Fin sam.coinCount) :
    (simSign sam project h s m ready r coins).1.table.length ≤ s.table.length+1 := by
  unfold simSign
  dsimp only
  split
  · split
    · exact Nat.le_succ _
    · exact Nat.le_refl _
  · exact Nat.le_succ _

end FT1536.PublicSimulation
