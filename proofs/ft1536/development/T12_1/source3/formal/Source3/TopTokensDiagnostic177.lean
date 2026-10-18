import Source3.KeygenMakeFgTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Diagnostic serialization only; all generated equalities need kernel proofs. -/
#eval do
  let chars := ((FT1536.Source3.Pinned.keygenLines.drop 5581).take 86).flatMap String.toList++['}']
  let tokens := (FT1536.Source3.KeygenLevelParser.tokenize (chars.length+1) chars).getD []
  IO.FS.writeFile "../TOP177_RAW_TOKENS.txt" (reprStr tokens)
  let normalized := (FT1536.Source3.KeygenSearchParser.sizes FT1536.Source3.KeygenMakeFgTop.types
    (FT1536.Source3.C99ArrayParser.normalizeTypes tokens)).getD []
  IO.FS.writeFile "../TOP177_NORMAL_TOKENS.txt" (reprStr normalized)
