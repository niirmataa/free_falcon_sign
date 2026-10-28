import Source3.BezoutPart4Compose217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Reassociate selected execution as original bezout parts3/4/5. -/
namespace FT1536.Source3.BezoutPart5Compose217
open C99ArrayReference (State)
open KeygenZintCall (Exec)
open BezoutPart4Compose217 (split)

theorem source (s out : State) (run : Exec SelectedBezoutABZero217.code s ⟨out,.normal⟩) :
    ∃ guardAfter part4After, Exec (KeygenZintCall.bezoutPart 3) s ⟨guardAfter,.normal⟩ ∧
      Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨part4After,.normal⟩ ∧
      Exec (KeygenZintCall.bezoutPart 5) part4After ⟨out,.normal⟩ := by
  obtain ⟨upper,upperRun,ab⟩:=split _ _ s out run
  obtain ⟨part4After,earlier,upperOps⟩:=split _ _ s upper upperRun
  obtain ⟨guardAfter,guard,part4⟩:=BezoutPart4Compose217.source s part4After earlier
  obtain ⟨uDone,zeroU,upperTail⟩:=split _ _ part4After upper upperOps
  obtain ⟨vDone,zeroV,select⟩:=split _ _ uDone upper upperTail
  obtain ⟨aDone,zeroA,zeroB⟩:=split _ _ upper out ab
  have part5 : Exec (KeygenZintCall.bezoutPart 5) part4After ⟨out,.normal⟩ := by
    rw [BezoutUpperSequence217.shape,BezoutABZero217.shape]
    exact .seqNormal _ _ _ _ _ zeroU (.seqNormal _ _ _ _ _ zeroV
      (.seqNormal _ _ _ _ _ select (.seqNormal _ _ _ _ _ zeroA (.seqNormal _ _ _ _ _ zeroB (ZintNormWord194.word_skip _)))))
  exact ⟨guardAfter,part4After,guard,part4,part5⟩

end FT1536.Source3.BezoutPart5Compose217
