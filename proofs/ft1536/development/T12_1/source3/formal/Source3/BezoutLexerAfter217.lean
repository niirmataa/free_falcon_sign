import Source3.BezoutLexerAtoms217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The post-comment source prefix lexes compositionally. -/
namespace FT1536.Source3.BezoutLexerAfter217
open B20.C (Token)
open BezoutLexerPieces217 (whitespace newline space)
open BezoutLexerAtoms217 (word_if word_alen word_blen digit_space digit_close open_alen ge lor close_space brace_newline)

def textAfter : String := "\n\t\tif (alen >= 3 || blen >= 3) {\n"
def emittedAfter : List Token := ["if".toList,"(".toList,"alen".toList,">=".toList,"3".toList,
  "||".toList,"blen".toList,">=".toList,"3".toList,")".toList,"{".toList]

theorem tokenize_after (fuel : Nat) (tail : List Char) :
    KeygenZintCall.tokenize [] (fuel+23) (textAfter.toList++tail)=
      (KeygenZintCall.tokenize [] fuel tail).map (emittedAfter++·) := by
  change KeygenZintCall.tokenize [] (fuel+23)
    (['\n','\t','\t','i','f',' ','(','a','l','e','n',' ','>','=',' ','3',' ','|','|',' ',
      'b','l','e','n',' ','>','=',' ','3',')',' ','{','\n']++tail)=_
  simp only [List.cons_append,List.nil_append,newline,whitespace,space,word_if,open_alen,word_alen,
    ge,digit_space,lor,word_blen,digit_close,close_space,brace_newline,Option.map_map]
  cases KeygenZintCall.tokenize [] fuel tail <;> rfl

end FT1536.Source3.BezoutLexerAfter217
