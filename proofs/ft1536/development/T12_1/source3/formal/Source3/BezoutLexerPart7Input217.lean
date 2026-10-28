import Source3.BezoutLexerNormalized217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual part7 input splits into the pinned lexer prefix and the remaining lines. -/
namespace FT1536.Source3.BezoutLexerPart7Input217
open BezoutLexerPrefix217 (sourceText emitted)

def whole : List Char := ((Pinned.keygenLines.drop 4014).take 185).flatMap String.toList++['}']
def tail : List Char := ((Pinned.keygenLines.drop 4022).take 177).flatMap String.toList++['}']

theorem split_lines (xs : List String) : xs.take 185=xs.take 8++(xs.drop 8).take 177 := by
  change xs.take (8+177)=xs.take 8++(xs.drop 8).take 177
  exact List.take_add

theorem whole_shape : whole=sourceText.toList++tail := by
  unfold whole tail
  rw [split_lines,List.flatMap_append,BezoutLexerPrefix217.pinned_prefix]
  simp only [List.drop_drop,show 4014+8=4022 by decide,List.append_assoc]

theorem tokens : KeygenZintCall.tokens whole=
    (KeygenZintCall.tokenize [] (BezoutLexerNormalized217.fuel tail) tail).map
      (fun rest => C99ArrayParser.normalizeTypes emitted++C99ArrayParser.normalizeTypes rest) := by
  rw [whole_shape]
  exact BezoutLexerNormalized217.tokens tail

end FT1536.Source3.BezoutLexerPart7Input217
