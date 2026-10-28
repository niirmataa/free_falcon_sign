import Source3.BezoutLexerBefore217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source prefix tokenization composes across arbitrary following text. -/
namespace FT1536.Source3.BezoutLexerCompose217
open BezoutLexerPrefix217 (sourceText emitted)
open BezoutLexerBefore217 (textBefore emittedBefore tokenize_before)
open BezoutLexerAfter217 (textAfter emittedAfter tokenize_after)
open BezoutLexerPieces217 (commentBody comment)

theorem text_shape (tail : List Char) : sourceText.toList++tail =
    textBefore.toList++('/'::'*'::(commentBody++(textAfter.toList++tail))) := by rfl

theorem tokenize_prefix (fuel : Nat) (tail : List Char) :
    KeygenZintCall.tokenize [] (fuel+44) (sourceText.toList++tail)=
      (KeygenZintCall.tokenize [] fuel tail).map (emitted++·) := by
  rw [text_shape]
  change KeygenZintCall.tokenize [] ((fuel+23+1)+20)
    (textBefore.toList++('/'::'*'::(commentBody++(textAfter.toList++tail))))=_
  rw [tokenize_before]
  rw [comment]
  rw [tokenize_after]
  cases KeygenZintCall.tokenize [] fuel tail <;> rfl

end FT1536.Source3.BezoutLexerCompose217
