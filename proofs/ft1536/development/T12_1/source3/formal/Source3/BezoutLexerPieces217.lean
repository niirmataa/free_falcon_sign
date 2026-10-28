import Source3.BezoutLexerPrefix217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Lexer equations for concrete boundaries; no generated simp equations. -/
namespace FT1536.Source3.BezoutLexerPieces217
open B20.C (Token)

def commentBody : List Char := "\n\t\t * If either word is large enough, we use the\n\t\t * accelerated approximation.\n\t\t */".toList

theorem skip_comment (tail : List Char) :
    B20.C.Scalar.skipBlock ((commentBody++tail).length+1) (commentBody++tail)=some tail := by rfl

theorem comment (fuel : Nat) (tail : List Char) :
    KeygenZintCall.tokenize [] (fuel+1) ('/'::'*'::(commentBody++tail))=KeygenZintCall.tokenize [] fuel tail := by
  change (do let rest ← B20.C.Scalar.skipBlock ((commentBody++tail).length+1) (commentBody++tail)
             KeygenZintCall.tokenize [] fuel rest)=KeygenZintCall.tokenize [] fuel tail
  rw [skip_comment]
  rfl

theorem whitespace (fuel : Nat) (tail : List Char) :
    KeygenZintCall.tokenize [] (fuel+1) ('\t'::tail)=KeygenZintCall.tokenize [] fuel tail := by rfl

theorem newline (fuel : Nat) (tail : List Char) :
    KeygenZintCall.tokenize [] (fuel+1) ('\n'::tail)=KeygenZintCall.tokenize [] fuel tail := by rfl

theorem space (fuel : Nat) (tail : List Char) :
    KeygenZintCall.tokenize [] (fuel+1) (' '::tail)=KeygenZintCall.tokenize [] fuel tail := by rfl

end FT1536.Source3.BezoutLexerPieces217
