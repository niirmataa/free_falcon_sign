import Source3.BezoutParserPart7Body217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original part7 begins with a real for(;;) loop, via structural parser proofs. -/
namespace FT1536.Source3.BezoutParserActualLoop217
open KeygenZintCall (Stmt)
open B20.C (Token)

theorem actual : ∃ inner after, KeygenZintCall.bezoutPart 7=
    .seq (.loop (.scalar (.literal .i32 1)) inner KeygenZintCall.skip) after := by
  obtain ⟨suffix,outPtrs,rest,bodyParsed,_⟩:=BezoutParserPart7Body217.actual
  let following : List Token := ["{".toList,"int".toList,"r".toList,";".toList,"if".toList,"(".toList,
    "alen".toList,">=".toList,"3".toList,"||".toList,"blen".toList,">=".toList,"3".toList,")".toList,"{".toList]++suffix
  let afterFor : List Token := ["(".toList,";".toList,";".toList,")".toList]++following
  change KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (511+1)
    ("for".toList::afterFor)=some (KeygenZintCall.bezoutPart 7,outPtrs,rest) at bodyParsed
  obtain ⟨first,next,mid,after,head,_,shape⟩:=BezoutParserBodyHead217.head _ _ 511 afterFor _ _ _ bodyParsed
  change KeygenZintCall.parseStatement (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (510+1)
    (["for".toList,"(".toList,";".toList,";".toList,")".toList]++following)=some (first,next,mid) at head
  obtain ⟨inner,loopShape⟩:=BezoutParserLoop217.infinite_loop _ _ 510 following first next mid head
  exact ⟨inner,after,shape.trans (congrArg (fun x => Stmt.seq x after) loopShape)⟩

end FT1536.Source3.BezoutParserActualLoop217
