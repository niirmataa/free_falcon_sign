import Source3.BezoutParserIf217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source prefix through the first if, retaining arbitrary following text. -/
namespace FT1536.Source3.BezoutLexerPrefix217
open B20.C (Token)

def sourceText : String := "\tfor (;;) {\n\t\tint r;\n\n\t\t/*\n\t\t * If either word is large enough, we use the\n\t\t * accelerated approximation.\n\t\t */\n\t\tif (alen >= 3 || blen >= 3) {\n"
def emitted : List Token := ["for".toList,"(".toList,";".toList,";".toList,")".toList,"{".toList,
  "int".toList,"r".toList,";".toList,"if".toList,"(".toList,"alen".toList,">=".toList,"3".toList,
  "||".toList,"blen".toList,">=".toList,"3".toList,")".toList,"{".toList]

theorem pinned_prefix : ((Pinned.keygenLines.drop 4014).take 8).flatMap String.toList=sourceText.toList := by decide

theorem tokenized : KeygenZintCall.tokens sourceText.toList=some (C99ArrayParser.normalizeTypes emitted) := by decide

end FT1536.Source3.BezoutLexerPrefix217
