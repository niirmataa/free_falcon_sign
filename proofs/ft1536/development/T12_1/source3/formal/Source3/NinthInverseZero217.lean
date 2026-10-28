import Source3.NttInversePrologue201
import Source3.NinthStepPrefix217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-level inverse at logn zero takes its actual early return before
   touching the data; this is needed by the true d9 !out_ntt branch. -/
namespace FT1536.Source3.NinthInverseZero217
open C99ArrayReference (State restoreScope)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open NttInversePrologue192 (afterSize afterMixed names wordNames)
open NttInversePrograms192

noncomputable def returned (s : State) : State := restoreScope (afterMixed s) (afterMixed s) [] []

theorem heap (s : State) : (returned s).heap=s.heap := rfl

theorem guard (s : State) (logn : Slot s "logn" 0) :
    Exec guardPart (afterMixed s) ⟨returned s,.returned none⟩ := by
  have lognAfter : Slot (afterMixed s) "logn" 0 :=
    (NttInversePrologue192.mixed_locals_outside s "logn".toList (by simp [names,wordNames])).trans logn
  have branch : Exec earlyExit (afterMixed s) ⟨returned s,.returned none⟩ := by
    refine .branchTrue _ _ _ _ _ (.int32 1)
      (.compare .eq _ _ _ _ _ (.variable _ _ _ lognAfter) (.literal .int32 0)
        (.step .eq (.uint32 0) (.int32 0) .uint32 rfl (.uint32 0) (.uint32 0) rfl rfl)) (by decide) ?_
    exact .scope [] _ _ _ (.seqExit _ _ _ _ (.retVoid _) (by intro h; cases h))
  exact .seqExit _ _ _ _ branch (by intro h; cases h)

theorem source (s : State) (logn : Slot s "logn" 0) :
    Exec KeygenLevelNtt.inverse s ⟨returned s,.returned none⟩ := by
  rw [NttInversePrograms192.body_source]
  exact .seqNormal _ _ s (afterSize s) _ (NttInversePrologue192.size_run s)
    (.seqNormal _ _ (afterSize s) (afterMixed s) _ (NttInversePrologue192.mixed_run s)
      (.seqExit _ _ _ _ (guard s logn) (by intro h; cases h)))

end FT1536.Source3.NinthInverseZero217
