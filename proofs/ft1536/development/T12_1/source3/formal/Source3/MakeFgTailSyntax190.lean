import Source3.StepPrimeShape188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Prepared diagnostic only; no execution or numerical claim.
   Serializes the source-bound tail syntax after the full0 generator call
   so that the shape modules name the exact original statements. -/
#eval do
  let tail := FT1536.Source3.StepPrimeShape188.tail
  let front := FT1536.Source3.MakeFgSpine188.take 32 tail
  let mut index := 0
  for item in front do
    IO.FS.writeFile ("../MAKEFG190_TAIL_" ++ toString index ++ ".txt") (reprStr item ++ "\n")
    index := index + 1
  IO.FS.writeFile "../MAKEFG190_TAIL_REST32.txt"
    (reprStr (FT1536.Source3.MakeFgSpine188.drop 32 tail) ++ "\n")
  IO.FS.writeFile "../MAKEFG190_TAIL_REST64.txt"
    (reprStr (FT1536.Source3.MakeFgSpine188.drop 64 tail) ++ "\n")
  IO.FS.writeFile "../MAKEFG190_REMAINING.txt"
    (reprStr FT1536.Source3.StepPrimeShape188.remaining ++ "\n")
