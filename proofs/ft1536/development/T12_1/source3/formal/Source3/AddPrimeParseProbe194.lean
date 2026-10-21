import Source3.KeygenZintCall098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC parse-dump probe (not proof evidence): prints the parsed
   statement shapes of the make_fg_step additional-prime section
   (`KeygenMakeFgSource.part .step 4`, the remaining-words loop at the
   selected instance slen = 1 / tlen = 2) and of the consumed callee
   bodies (zint_mod_small_signed at dlen = 1 and its zint_mod_small_unsigned
   leaf). Retained as a record in the failures register; the shape module
   binds these parses by decide; no execution or numerical property is
   claimed here. -/
namespace FT1536.Source3.AddPrimeParseProbe194

def part4 : KeygenMakeFgSource.Stmt := KeygenMakeFgSource.part .step 4

#eval IO.println (repr part4)
#eval IO.println (repr (KeygenZintCall.calleeBody .modSigned))
#eval IO.println (repr (KeygenZintCall.calleeBody (.leaf .reduce)))

end FT1536.Source3.AddPrimeParseProbe194
