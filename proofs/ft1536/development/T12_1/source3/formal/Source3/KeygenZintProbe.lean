import Source3.KeygenZintCall

/- Diagnostic probe: retained as evidence of parser localization, not proof.
   Stdout is intentionally nonempty (DIAGNOSTIC, never accepted evidence). -/
open FT1536.Source3.KeygenZintCall

#eval (calleeParsed .subMod).map callShape
#eval (calleeParsed .normZero).map callShape
#eval (calleeParsed .rshiftMod).map callShape
#eval (calleeParsed .modSigned).map callShape
#eval (calleeParsed .rebuildCrt).map callShape
#eval (calleeParsed .rebuildCrt).isSome
#eval (List.range 53).map (fun k => (region (widths .rebuildCrt) ["x".toList] 3581 (k+1)).isSome)
#eval (List.range 3).map (fun k => (region (widths .subMod) [] 3507 (k+1)).isSome)
#eval (FT1536.Source3.C99ProcedureParser.tokens "tmp[0] = primes[0].p;\n".toList).map (fun ts => fresh [] ts)
#eval (FT1536.Source3.C99ProcedureParser.tokens "tmp[0] = primes[0].p;\n".toList).map (fun ts => FT1536.Source3.C99ArrayParser.pureExpr (ts.drop 2))
#eval FT1536.Source3.KeygenZintCall.primeRead "primes".toList [["0".toList.head!],[']'],['.'],['p'],[';']] (fun i f t => some (.retVoid,[],[]))
#eval FT1536.Source3.KeygenLevelParser.field "p".toList
