import Source3.BezoutLexerPart7Input217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Any successful tokenization of actual part7 begins with the pinned prefix. -/
namespace FT1536.Source3.BezoutLexerPart7Tokens217
open B20.C (Token)
open BezoutLexerPrefix217 (emitted)
open BezoutLexerPart7Input217 (whole tail)

theorem prefix_result (ts : List Token) (h : KeygenZintCall.tokens whole=some ts) :
    ∃ rest, ts=C99ArrayParser.normalizeTypes emitted++rest := by
  rw [BezoutLexerPart7Input217.tokens] at h
  cases htail : KeygenZintCall.tokenize [] (BezoutLexerNormalized217.fuel tail) tail with
  | none => simp [htail] at h
  | some rest =>
    rw [htail] at h
    change some (C99ArrayParser.normalizeTypes emitted++C99ArrayParser.normalizeTypes rest)=some ts at h
    exact ⟨C99ArrayParser.normalizeTypes rest,(Option.some.inj h).symm⟩

theorem actual : ∃ ts rest, KeygenZintCall.tokens whole=some ts ∧
    ts=C99ArrayParser.normalizeTypes emitted++rest := by
  have h := KeygenZintCore.bezout_parsed_part 7 KeygenZintCore.bezout_audit7
  change KeygenZintCall.region (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 4015 185 =
    some (KeygenZintCall.bezoutPart 7) at h
  change (do
    let lexed ← KeygenZintCall.tokens whole
    let (code,_,rest) ← KeygenZintCall.parseBody (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 512 lexed
    if rest.isEmpty then pure code else none)=some (KeygenZintCall.bezoutPart 7) at h
  cases ht : KeygenZintCall.tokens whole with
  | none => simp [ht] at h
  | some ts =>
    obtain ⟨rest,eq⟩:=prefix_result ts ht
    exact ⟨ts,rest,rfl,eq⟩

end FT1536.Source3.BezoutLexerPart7Tokens217
