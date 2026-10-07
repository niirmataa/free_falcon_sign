import Source3.KeygenSmallSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The existing scalar lexer rejects remainder. Preserve that observation
   and bind the entire alignment helper by its literal source scaffold.
   No character or statement is discarded by the specialized lowering. -/
namespace FT1536.Source3.KeygenSearchProbe

def alignLines : List String := (Pinned.keygenLines.drop 5318).take 11
def alignScaffold : List String := [
  "\tunsigned char *cb, *cd;\n","\tsize_t k, km;\n","\n",
  "\tcb = base;\n","\tcd = data;\n","\tk = (size_t)(cd - cb);\n",
  "\tkm = k % sizeof(fpr);\n","\tif (km) {\n",
  "\t\tk += (sizeof(fpr)) - km;\n","\t}\n","\treturn (fpr *)(cb + k);\n"]
theorem alignment_source : alignLines=alignScaffold := by decide
theorem remainder_lexer_rejects : C99ProcedureParser.tokens (alignLines.flatMap String.toList)=none := by decide

end FT1536.Source3.KeygenSearchProbe
