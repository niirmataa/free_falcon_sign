import Source3.KeygenZintCall098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC parse-dump probe (not proof evidence): prints the parsed
   statement shapes consumed by the part-3 zint_rebuild_CRT calls and by
   the zint_rebuild_CRT / zint_norm_zero / zint_sub callee bodies at the
   selected instance (xlen = 1). Retained as a record in the failures
   register; no execution or numerical property is claimed here. -/
namespace FT1536.Source3.ZintCrtParseProbe194

def part3 : KeygenMakeFgSource.Stmt := KeygenMakeFgSource.part .step 3

#eval IO.println (repr part3)
#eval IO.println (repr (KeygenZintCall.calleeBody .rebuildCrt))
#eval IO.println (repr (KeygenZintCall.calleeBody .normZero))
#eval IO.println (repr (KeygenZintCall.calleeBody (.leaf .sub)))

end FT1536.Source3.ZintCrtParseProbe194
