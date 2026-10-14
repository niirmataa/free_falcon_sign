import Source3.KeygenZintExtractArity098
import Lean

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Data generation only. The emitted public source-token list is not
   accepted mathematical evidence until a separate kernel equality checks
   it against the original pinned tokenizer and exact source bytes. -/
#eval do
  let lines := (FT1536.Source3.Pinned.keygenLines.drop 4014).take 185
  let chars := lines.flatMap String.toList ++ ['}']
  IO.FS.writeFile "../BEZOUT_LINES_098.json" (Lean.toJson lines).pretty
  IO.FS.writeFile "../BEZOUT_CHARS_098.json" (Lean.toJson (String.ofList chars)).pretty
  match FT1536.Source3.KeygenZintCall.tokens chars with
  | none => throw (IO.userError "The original Bezout source tokenizer returned none")
  | some tokens =>
      IO.FS.writeFile "../BEZOUT_TOKENS_098.json" (Lean.toJson (tokens.map String.ofList)).pretty
