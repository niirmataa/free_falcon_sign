import Source3.SelectedBezoutGuard217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The bad input case closes the actual callee body, not merely its prefix. -/
namespace FT1536.Source3.BezoutEarlyReturn217
open C99ArrayReference (State)
open KeygenZintCall (Exec)

theorem split_prefix (s mid : State) (run : Exec SelectedBezoutPrefix217.prefixCode s ⟨mid,.normal⟩) :
    ∃ p, Exec (KeygenZintCall.bezoutPart 0) s ⟨p,.normal⟩ ∧ Exec (KeygenZintCall.bezoutPart 1) p ⟨mid,.normal⟩ := by
  cases run with
  | seqNormal _ _ _ p _ first second => exact ⟨p,first,second⟩
  | seqExit _ _ _ _ _ exit => exact False.elim (exit rfl)

theorem source (s p q r : State)
    (decl : Exec (KeygenZintCall.bezoutPart 0) s ⟨p,.normal⟩)
    (ptr : Exec (KeygenZintCall.bezoutPart 1) p ⟨q,.normal⟩)
    (lengths : Exec (KeygenZintCall.bezoutPart 2) q ⟨r,.normal⟩)
    (bad : Exec (KeygenZintCall.bezoutPart 3) r ⟨r,.returned (some (.int32 0))⟩) :
    Exec (KeygenZintCall.calleeBody .bezout) s ⟨r,.returned (some (.int32 0))⟩ := by
  change Exec (KeygenZintCall.chain [KeygenZintCall.bezoutPart 0,KeygenZintCall.bezoutPart 1,
    KeygenZintCall.bezoutPart 2,KeygenZintCall.bezoutPart 3,KeygenZintCall.bezoutPart 4,
    KeygenZintCall.bezoutPart 5,KeygenZintCall.bezoutPart 6,KeygenZintCall.bezoutPart 7]) s
      ⟨r,.returned (some (.int32 0))⟩
  exact .seqNormal _ _ s p _ decl (.seqNormal _ _ p q _ ptr
    (.seqNormal _ _ q r _ lengths (.seqExit _ _ _ _ bad (by intro impossible; cases impossible))))

end FT1536.Source3.BezoutEarlyReturn217
