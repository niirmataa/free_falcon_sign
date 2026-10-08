import Source3.KeygenZintCall

/- Diagnostic probe: retained as evidence of parser localization, not proof.
   Stdout is intentionally nonempty (DIAGNOSTIC, never accepted evidence).
   The member-access lines exercise KeygenZintCall.tokens (trap 110 rule). -/
open FT1536.Source3.KeygenZintCall

#eval (calleeParsed .subMod).map callShape
#eval (calleeParsed .normZero).map callShape
#eval (calleeParsed .rshiftMod).map callShape
#eval (calleeParsed .modSigned).map callShape
#eval (calleeParsed .rebuildCrt).map callShape
#eval (calleeParsed .rebuildCrt).isSome
#eval (List.range 53).map (fun k => (region (widths .rebuildCrt) ["x".toList] 3581 (k+1)).isSome)
#eval (List.range 3).map (fun k => (region (widths .subMod) [] 3507 (k+1)).isSome)
#eval (FT1536.Source3.KeygenZintCall.tokens "tmp[0] = primes[0].p;\n".toList).map (fun ts => fresh [] ts)
#eval (FT1536.Source3.KeygenZintCall.tokens "tmp[0] = primes[0].p;\n".toList).map (fun ts => FT1536.Source3.C99ArrayParser.pureExpr (ts.drop 2))
#eval FT1536.Source3.KeygenZintCall.primeRead "primes".toList [["0".toList.head!],[']'],['.'],['p'],[';']] (fun _ _ _ => some (.retVoid,[],[]))
#eval FT1536.Source3.KeygenLevelParser.field "p".toList

/- KROK 2 localization: which construction of the reduce family fails. -/
#eval (calleeParsed .coReduce).isSome
#eval (List.range 55).map (fun k => (region (widths .coReduce) [] 3670 (k+1)).isSome)
#eval (List.range 34).map (fun k => (region (widths .reduce) [] 3811 (k+1)).isSome)
#eval (tokens "cc = *(int32_t *)&tt;\n".toList).map (fun ts => fresh [] ts)
#eval tokens "cc = *(int32_t *)&tt;\n".toList
#eval FT1536.Source3.KeygenWordExpr.typeToken "int32_t".toList
#eval fresh [] ["cc".toList,['='],['*'],['('],"int32_t".toList,[')'],['&'],"tt".toList,[';']]
#eval (tokens "wa = (int32_t)a[u];\n".toList).map (fun ts => FT1536.Source3.KeygenWordParser.statement [("a".toList,4)] 64 ts)
#eval (tokens "a[u] = w & 0x7FFFFFFF;\n".toList).map (fun ts => FT1536.Source3.KeygenWordParser.statement [("a".toList,4),("w".toList,4)] 64 ts)
#eval (tokens "r |= 1;\n".toList).map (fun ts => FT1536.Source3.KeygenWordParser.statement [] 64 ts)
#eval (tokens "return 1;\n".toList).map (fun ts => FT1536.Source3.KeygenWordParser.statement [] 64 ts)
#eval (tokens "tt = (uint32_t)((uint64_t)z >> 31);\n".toList).map (fun ts => FT1536.Source3.KeygenWordParser.statement [] 64 ts)
#eval (tokens "z = (int64_t)wb * k + (int64_t)wa + cc;\n".toList).map (fun ts => FT1536.Source3.KeygenWordParser.statement [] 64 ts)
#eval (tokens "for (u = 0; u < len; u ++) { x = 1; }\n".toList).map (fun ts => FT1536.Source3.KeygenWordParser.statement [("x".toList,4)] 64 ts)
