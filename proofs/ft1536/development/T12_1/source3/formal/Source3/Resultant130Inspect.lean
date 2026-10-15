import Source3.KeygenResultantRun130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Diagnostic serialization of already source-bound syntax, not a proof
   of any execution or numerical result. -/
#eval IO.FS.writeFile "../RESULTANT130_SYNTAX.txt"
  ("SETUP\n" ++ reprStr FT1536.Source3.KeygenResultantSource.setup ++
   "\nPACKING\n" ++ reprStr FT1536.Source3.KeygenResultantSource.packing ++
   "\nSWITCH10\n" ++ reprStr (FT1536.Source3.KeygenResultantSource.switchCode 10) ++
   "\nTAIL\n" ++ reprStr FT1536.Source3.KeygenResultantSource.tailCode ++ "\n")
