import Source3.BezoutLexerCompose217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Normalized tokenization preserves the proven source prefix for any tail. -/
namespace FT1536.Source3.BezoutLexerNormalized217
open BezoutLexerPrefix217 (sourceText emitted)

def fuel (tail : List Char) := (sourceText.toList++tail).length+1-44

theorem enough (tail : List Char) : 44≤(sourceText.toList++tail).length+1 := by
  have fixed : 44≤sourceText.toList.length := by decide
  simp only [List.length_append]
  omega

theorem tokens (tail : List Char) :
    KeygenZintCall.tokens (sourceText.toList++tail)=
      (KeygenZintCall.tokenize [] (fuel tail) tail).map
        (fun rest => C99ArrayParser.normalizeTypes emitted++C99ArrayParser.normalizeTypes rest) := by
  unfold KeygenZintCall.tokens
  have eq : (sourceText.toList++tail).length+1=fuel tail+44 := by
    unfold fuel; have h:=enough tail; omega
  rw [eq,BezoutLexerCompose217.tokenize_prefix]
  cases KeygenZintCall.tokenize [] (fuel tail) tail <;>
    simp [C99ArrayParser.normalizeTypes,List.map_append]

end FT1536.Source3.BezoutLexerNormalized217
