import Source3.KeygenZintCall

/- Diagnostic probe: retained as evidence of parser localization, not proof.
   Stdout is intentionally nonempty (DIAGNOSTIC, never accepted evidence).
   BATCH_027 localization: piece 7 of zint_bezout (the `for (;;)` statement,
   region start 4018 count 182) fails to parse although the monolithic body
   region parses. Cut sweep inside the piece for the failing construction. -/
open FT1536.Source3.KeygenZintCall

#eval (bezoutParsed 7).isSome
#eval (bezoutParsed 7).map callShape
#eval (bezoutParsed 7).map bitcastCount
#eval (region (widths .bezout) bezoutPtrs 4018 1).isSome
#eval (region (widths .bezout) bezoutPtrs 4018 3).isSome
#eval (List.range 182).filter (fun k => (region (widths .bezout) bezoutPtrs 4018 (k+1)).isSome)
#eval FT1536.Source3.Pinned.keygenLines[4017]?
#eval FT1536.Source3.Pinned.keygenLines[4198]?
