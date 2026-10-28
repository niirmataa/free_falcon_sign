import Source3.BezoutParserBodyInner217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original part7 loop body begins with declaration r and the exact first guard. -/
namespace FT1536.Source3.BezoutParserActualBranch217
open KeygenZintCall (Stmt)
open B20.C (Token)

theorem actual : ∃ (vars ptrVars : List C99ArrayReference.Name) (yes no rest after : Stmt),
    KeygenZintCall.bezoutPart 7=.seq
      (.loop (.scalar (.literal .i32 1))
        (.scope vars ptrVars (.seq BezoutParserDecl217.declaration
          (.seq (.branch BezoutLoopGuard217.condition yes no) rest))) KeygenZintCall.skip) after := by
  obtain ⟨suffix,outPtrs,finalRest,bodyParsed,_⟩:=BezoutParserPart7Body217.actual
  let afterGuard : List Token := "{".toList::suffix
  let afterDecl : List Token := ["if".toList,"(".toList]++BezoutParserPrefix217.guardTokens++afterGuard
  let inScope : List Token := ["int".toList,"r".toList,";".toList]++afterDecl
  let following : List Token := "{".toList::inScope
  let afterFor : List Token := ["(".toList,";".toList,";".toList,")".toList]++following
  change KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (511+1)
    ("for".toList::afterFor)=some (KeygenZintCall.bezoutPart 7,outPtrs,finalRest) at bodyParsed
  obtain ⟨first,next,mid,after,forParsed,_,topShape⟩:=BezoutParserBodyHead217.head _ _ 511 afterFor _ _ _ bodyParsed
  change KeygenZintCall.parseStatement (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (510+1)
    (["for".toList,"(".toList,";".toList,";".toList,")".toList]++following)=some (first,next,mid) at forParsed
  obtain ⟨inner,innerParsed,loopShape⟩:=BezoutParserLoopScope217.loop_body _ _ 510 following first next mid forParsed
  change KeygenZintCall.parseStatement (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (509+1)
    ("{".toList::inScope)=some (inner,next,mid) at innerParsed
  obtain ⟨innerCode,innerPtrs,scopeParsed,scopeShape,_⟩:=BezoutParserLoopScope217.scope_body _ _ 509 inScope inner next mid innerParsed
  let afterIntHead : List Token := ["r".toList,";".toList]++afterDecl
  change KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (508+1)
    ("int".toList::afterIntHead)=some (innerCode,innerPtrs,mid) at scopeParsed
  obtain ⟨decl,declPtrs,declRest,followingCode,declParsed,followingParsed,bodyShape⟩:=
    BezoutParserBodyInner217.int_head _ _ 508 afterIntHead innerCode innerPtrs mid scopeParsed
  have knownDecl := BezoutParserDecl217.parsed (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 507 afterDecl
  change KeygenZintCall.parseStatement (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (507+1)
    (["int".toList,"r".toList,";".toList]++afterDecl)=some (decl,declPtrs,declRest) at declParsed
  have equalDecl := Option.some.inj (declParsed.symm.trans knownDecl)
  have declEq : decl=BezoutParserDecl217.declaration := congrArg Prod.fst equalDecl
  have declTail : (declPtrs,declRest)=(KeygenZintCall.bezoutPtrs,afterDecl) := congrArg Prod.snd equalDecl
  cases declTail
  let afterIfHead : List Token := "(".toList::BezoutParserPrefix217.guardTokens++afterGuard
  change KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (507+1)
    ("if".toList::afterIfHead)=some (followingCode,innerPtrs,mid) at followingParsed
  obtain ⟨ifStmt,ifPtrs,ifRest,rest,ifParsed,_,followingShape⟩:=
    BezoutParserBodyInner217.if_head _ _ 507 afterIfHead followingCode innerPtrs mid followingParsed
  change KeygenZintCall.parseStatement (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs (506+1)
    (["if".toList,"(".toList]++BezoutParserPrefix217.guardTokens++afterGuard)=some (ifStmt,ifPtrs,ifRest) at ifParsed
  obtain ⟨yes,no,ifShape⟩:=BezoutParserIf217.branch _ _ 506 afterGuard ifStmt ifPtrs ifRest ifParsed
  subst decl
  subst ifStmt
  rw [followingShape] at bodyShape
  rw [bodyShape] at scopeShape
  rw [scopeShape] at loopShape
  rw [loopShape] at topShape
  exact ⟨_,_,yes,no,rest,after,topShape⟩

end FT1536.Source3.BezoutParserActualBranch217
