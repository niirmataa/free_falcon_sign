import Source3.KeygenDeepestSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Diagnostic serialization of source-bound syntax only.
   Subsequent shape equalities are independently checked in the kernel. -/
#eval do
  for i in List.range 5 do
    IO.FS.writeFile ("../DEEPEST175_PART_" ++ toString i ++ ".txt")
      (reprStr (FT1536.Source3.KeygenDeepestSource.part i) ++ "\n")
