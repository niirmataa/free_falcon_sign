import ArenaProgram020E1

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 512
set_option pp.deepTerms true
set_option pp.maxSteps 1000000
/- Public-data extraction only; the separate equality is the binding theorem. -/
#reduce ((FT1536.S05.ArenaProgram020E1.image FT1536.S05.PairProgram020.program).map
  (fun c => [c.1.val,c.2.toNat]))
