import Source3.KeygenMakeFgSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Prepared diagnostic only; no execution or numerical claim. -/
#eval do
  for i in List.range 4 do
    IO.FS.writeFile ("../MAKEFG176_PART_" ++ toString i ++ ".txt")
      (reprStr (FT1536.Source3.KeygenMakeFgSource.part .make i) ++ "\n")
