import Source3.BezoutParserBodyHead217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Extract the actual successful part7 body parse without evaluating its AST. -/
namespace FT1536.Source3.BezoutParserPart7Body217
open B20.C (Token)
open BezoutLexerPrefix217 (emitted)
open BezoutLexerPart7Input217 (whole)

theorem actual : ∃ (suffix : List Token) (outPtrs : List C99ArrayReference.Name) (rest : List Token),
    KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 512
      (C99ArrayParser.normalizeTypes emitted++suffix)=some (KeygenZintCall.bezoutPart 7,outPtrs,rest) ∧
    rest.isEmpty=true := by
  obtain ⟨ts,suffix,ht,eq⟩:=BezoutLexerPart7Tokens217.actual
  have hp := KeygenZintCore.bezout_parsed_part 7 KeygenZintCore.bezout_audit7
  change KeygenZintCall.region (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 4015 185 =
    some (KeygenZintCall.bezoutPart 7) at hp
  change (do
    let lexed ← KeygenZintCall.tokens whole
    let (code,_,rest) ← KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 512 lexed
    if rest.isEmpty then pure code else none)=some (KeygenZintCall.bezoutPart 7) at hp
  rw [ht] at hp
  change (do
    let (code,_,rest) ← KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 512 ts
    if rest.isEmpty then pure code else none)=some (KeygenZintCall.bezoutPart 7) at hp
  cases hb : KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 512 ts with
  | none => simp [hb] at hp
  | some result =>
    rcases result with ⟨code,outPtrs,rest⟩
    rw [hb] at hp
    change (if rest.isEmpty then some code else none)=some (KeygenZintCall.bezoutPart 7) at hp
    cases he : rest.isEmpty with
    | false => simp [he] at hp
    | true =>
      simp only [he,ite_true,Option.some.injEq] at hp
      subst code
      rw [eq] at hb
      exact ⟨suffix,outPtrs,rest,hb,he⟩

end FT1536.Source3.BezoutParserPart7Body217
