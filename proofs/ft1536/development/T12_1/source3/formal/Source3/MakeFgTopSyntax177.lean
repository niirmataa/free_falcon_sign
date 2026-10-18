import Source3.KeygenMakeFgTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Prepared diagnostic serialization only, not execution evidence. -/
#eval IO.FS.writeFile "../MAKEFG_TOP177_SYNTAX.txt"
  (reprStr FT1536.Source3.KeygenMakeFgTop.code ++ "\n")
