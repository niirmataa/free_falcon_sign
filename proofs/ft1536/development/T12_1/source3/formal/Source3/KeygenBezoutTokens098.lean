import Source3.KeygenLexAll098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBezoutTokens098

def chars : List Char :=
  ((Pinned.keygenLines.drop 4014).take 185).flatMap String.toList ++ ['}']
abbrev tokens := KeygenLexData098.tokens

theorem input_chars : chars = KeygenBezoutText098.chars := KeygenBezoutText098.source_chars

/-- The actual pinned tokenizer result, obtained from41kernel-checked
    symbolic prefixes and exact generic composition. -/
theorem source : KeygenZintCall.tokens chars = some tokens :=
  (congrArg KeygenZintCall.tokens input_chars).trans KeygenLexAll098.tokens_source

end FT1536.Source3.KeygenBezoutTokens098
