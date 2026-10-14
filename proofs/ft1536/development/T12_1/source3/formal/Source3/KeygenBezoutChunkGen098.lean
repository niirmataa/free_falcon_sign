import Source3.KeygenBezoutText098
import Lean

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Candidate prefix data only. Each subsequent symbolic prefix equation
   must be proved by the kernel; native generation is not proof evidence. -/
#eval do
  let lines := FT1536.Source3.KeygenBezoutText098.lines
  let mut start := 0
  let mut chunks : Array Lean.Json := #[]
  let mut joined : List B20.C.Token := []
  let mut totalSteps := 0
  while start < lines.length do
    let mut count := min 4 (lines.length - start)
    let mut parsed : Option (List B20.C.Token) := none
    let mut chars : List Char := []
    while parsed.isNone && start + count <= lines.length do
      chars := ((lines.drop start).take count).flatMap String.toList
      parsed := FT1536.Source3.KeygenZintCall.tokenize [] (chars.length + 1) chars
      if parsed.isNone then count := count + 1
    let some tokens := parsed | throw (IO.userError "No complete lexical prefix")
    if chars.getLast? != some '\n' || chars.contains '#' then
      throw (IO.userError "Prefix must end in newline and contain no directive")
    let some least := (List.range (chars.length + 2)).find? (fun fuel =>
      (FT1536.Source3.KeygenZintCall.tokenize [] fuel chars).isSome)
      | throw (IO.userError "No candidate fuel")
    let steps := least - 1
    totalSteps := totalSteps + steps
    joined := joined ++ tokens
    chunks := chunks.push (Lean.Json.mkObj [
      ("start", Lean.toJson start), ("count", Lean.toJson count),
      ("steps", Lean.toJson steps), ("chars", Lean.toJson chars.length),
      ("tokens", Lean.toJson (tokens.map String.ofList))])
    start := start + count
  let allChars := lines.flatMap String.toList
  if FT1536.Source3.KeygenZintCall.tokenize [] (allChars.length + 1) allChars != some joined then
    throw (IO.userError "Candidate lexical chunks do not reproduce token data")
  IO.FS.writeFile "../BEZOUT_CHUNKS_098.json" (Lean.Json.mkObj [
    ("chunks", Lean.Json.arr chunks), ("total_steps", Lean.toJson totalSteps),
    ("raw_tokens", Lean.toJson (joined.map String.ofList))]).pretty
