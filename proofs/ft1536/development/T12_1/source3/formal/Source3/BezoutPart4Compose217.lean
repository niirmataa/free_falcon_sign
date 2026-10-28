import Source3.SelectedBezoutABImages217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Reassociate the executed source fragments as the original bezout part4. -/
namespace FT1536.Source3.BezoutPart4Compose217
open C99ArrayReference (State)
open KeygenZintCall (Exec Stmt)

theorem split (a b : Stmt) (s out : State) (run : Exec (.seq a b) s ⟨out,.normal⟩) :
    ∃ mid, Exec a s ⟨mid,.normal⟩ ∧ Exec b mid ⟨out,.normal⟩ := by
  cases run with
  | seqNormal _ _ _ mid _ first second => exact ⟨mid,first,second⟩
  | seqExit _ _ _ _ _ exit => exact False.elim (exit rfl)

theorem skip_identity (s out : State) (run : Exec ZintNormWord194.wskip s ⟨out,.normal⟩) : out=s := by
  cases run with
  | word _ _ _ w =>
    cases w with
    | modular _ _ _ m =>
      cases m with
      | base _ _ _ a => cases a; rfl

theorem source (s out : State) (run : Exec SelectedBezoutInitMore217.code s ⟨out,.normal⟩) :
    ∃ guardAfter, Exec (KeygenZintCall.bezoutPart 3) s ⟨guardAfter,.normal⟩ ∧
      Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨out,.normal⟩ := by
  obtain ⟨p,pre,more⟩:=split _ _ s out run
  obtain ⟨q,preStore,zeroes⟩:=split _ _ s p pre
  obtain ⟨r,preCopies,storeCode⟩:=split _ _ s q preStore
  obtain ⟨guardAfter,guard,copies⟩:=split _ _ s r preCopies
  obtain ⟨s1,copyA,copyB⟩:=split _ _ guardAfter r copies
  obtain ⟨s2,assignA,storeTail⟩:=split _ _ r q storeCode
  obtain ⟨s3,assignB,storeTail2⟩:=split _ _ s2 q storeTail
  obtain ⟨s4,store,skipped⟩:=split _ _ s3 q storeTail2
  have same : s4=q := (skip_identity s4 q skipped).symm
  subst s4
  obtain ⟨s5,zeroU,zeroV⟩:=split _ _ q p zeroes
  obtain ⟨s6,copyU,moreTail⟩:=split _ _ p out more
  obtain ⟨s7,copyV,mask⟩:=split _ _ s6 out moreTail
  have maskTail : Exec BezoutInitMoreCopies217.tail s7 ⟨out,.normal⟩ := by
    rw [BezoutInitLowBit217.shape]
    exact .seqNormal _ _ _ _ _ mask (ZintNormWord194.word_skip _)
  have moreRun : Exec BezoutInitZero217.tail p ⟨out,.normal⟩ := by
    rw [BezoutInitMoreCopies217.shape]
    exact .seqNormal _ _ _ _ _ copyU (.seqNormal _ _ _ _ _ copyV maskTail)
  have zeroRun : Exec BezoutInitStore217.rest q ⟨out,.normal⟩ := by
    rw [BezoutInitZero217.shape]
    exact .seqNormal _ _ _ _ _ zeroU (.seqNormal _ _ _ _ _ zeroV moreRun)
  have storesRun : Exec BezoutInitCopies217.tail r ⟨out,.normal⟩ := by
    rw [BezoutInitStore217.shape]
    exact .seqNormal _ _ _ _ _ assignA (.seqNormal _ _ _ _ _ assignB (.seqNormal _ _ _ _ _ store zeroRun))
  have part4 : Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨out,.normal⟩ := by
    rw [BezoutInitCopies217.shape]
    exact .seqNormal _ _ _ _ _ copyA (.seqNormal _ _ _ _ _ copyB storesRun)
  exact ⟨guardAfter,guard,part4⟩

end FT1536.Source3.BezoutPart4Compose217
