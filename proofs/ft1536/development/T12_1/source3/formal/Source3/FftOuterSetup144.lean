import Source3.FftOuterStates144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterSetup144
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open FftOuterStates144 (declared halfT halfM zeroU initial)

theorem declaration (s : State) : C99ProcedureReference.Exec KeygenSearchFft.program FftOuterShape144.declaration s
    ⟨declared s,.normal⟩ := .base _ _ _ (C99DeclarationStatements.source_exists _ .u64 FftOuterShape144.names s)

theorem half_t (s : State) (t : Nat) (bound : t<2^64) (cell : Cell s "t".toList t) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftOuterShape144.halfT (declared s) ⟨halfT s t,.normal⟩ :=
  C99OuterScalar144.assign_half _ _ _ _ none t bound (FftOuterStates144.ht_declared s)
    ((FftOuterStates144.declared_outside s "t".toList (by decide)).trans cell)

theorem half_m (s : State) (t m : Nat) (bound : m<2^64) (cell : Cell s "m".toList m) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftOuterShape144.halfM (halfT s t) ⟨halfM s t m,.normal⟩ :=
  C99OuterScalar144.assign_half _ _ _ _ none m bound
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftOuterStates144.hm_declared s))
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftOuterStates144.declared_outside s "m".toList (by decide)).trans cell))

theorem prologue (s : State) (t m : Nat) (tBound : t<2^64) (mBound : m<2^64)
    (tCell : Cell s "t".toList t) (mCell : Cell s "m".toList m) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.outerPrologue s ⟨halfM s t m,.normal⟩ := by
  rw [FftOuterShape144.prologue]
  exact .seqNormal _ _ _ _ _ (declaration s)
    (.seqNormal _ _ _ _ _ (half_t s t tBound tCell)
      (.seqNormal _ _ _ _ _ (half_m s t m mBound mCell) (.base _ _ _ (.skip _))))

theorem initialization (s : State) (t m : Nat) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.groupInitial (halfM s t m) ⟨initial s t m,.normal⟩ := by
  rw [FftOuterShape144.initialization]
  refine .seqNormal _ _ _ (zeroU s t m) _ ?_ ?_
  · exact C99OuterScalar144.clear _ _ _ none ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftOuterStates144.u_declared s)))
  · exact C99OuterScalar144.clear _ _ _ none ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
        ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftOuterStates144.v_declared s))))

end FT1536.Source3.FftOuterSetup144
