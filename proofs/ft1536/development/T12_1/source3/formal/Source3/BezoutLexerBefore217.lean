import Source3.BezoutLexerBeforeAtoms217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The source prefix before the comment lexes compositionally. -/
namespace FT1536.Source3.BezoutLexerBefore217
open B20.C (Token)
open BezoutLexerPieces217 (whitespace newline space)
open BezoutLexerAtoms217 (close_space brace_newline)
open BezoutLexerBeforeAtoms217 (word_for word_int word_r open_semi semi_semi semi_close semi_newline)

def textBefore : String := "\tfor (;;) {\n\t\tint r;\n\n\t\t"
def emittedBefore : List Token := ["for".toList,"(".toList,";".toList,";".toList,")".toList,"{".toList,
  "int".toList,"r".toList,";".toList]

theorem tokenize_before (fuel : Nat) (tail : List Char) :
    KeygenZintCall.tokenize [] (fuel+20) (textBefore.toList++tail)=
      (KeygenZintCall.tokenize [] fuel tail).map (emittedBefore++·) := by
  change KeygenZintCall.tokenize [] (fuel+20)
    (['\t','f','o','r',' ','(',';',';',')',' ','{','\n','\t','\t','i','n','t',' ','r',';','\n','\n','\t','\t']++tail)=_
  simp only [List.cons_append,List.nil_append,newline,whitespace,space,word_for,word_int,word_r,
    open_semi,semi_semi,semi_close,semi_newline,close_space,brace_newline,Option.map_map]
  cases KeygenZintCall.tokenize [] fuel tail <;> rfl

end FT1536.Source3.BezoutLexerBefore217
