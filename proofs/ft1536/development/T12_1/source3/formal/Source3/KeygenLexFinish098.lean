import Source3.KeygenLexCompose098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexFinish098
open B20.C (Token)
open KeygenZintCall (tokenize)
open KeygenLexCompose098 (Chunk)

def chars (lines : List String) : List Char := lines.flatMap String.toList ++ ['}']

/-- Keep this conversion generic so checking its closed instances never
    asks the kernel to normalize a complete source tokenizer invocation. -/
theorem raw (chunk : Chunk) : tokenize [] ((chars chunk.lines).length + 1) (chars chunk.lines) =
    some (chunk.raw ++ [['}']]) := by
  unfold chars
  rw [List.length_append]
  change tokenize [] ((chunk.lines.flatMap String.toList).length + 2)
    (chunk.lines.flatMap String.toList ++ ['}']) = _
  exact KeygenLexCompose098.finish _ _ chunk.steps chunk.equation chunk.bound

theorem normalized (chunk : Chunk) : KeygenZintCall.tokens (chars chunk.lines) =
    some (C99ArrayParser.normalizeTypes (chunk.raw ++ [['}']])) := by
  unfold KeygenZintCall.tokens
  rw [raw, Option.map_some]

end FT1536.Source3.KeygenLexFinish098
