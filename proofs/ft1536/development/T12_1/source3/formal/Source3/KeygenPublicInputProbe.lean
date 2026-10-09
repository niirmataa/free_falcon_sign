import Source3.KeygenPublicForwardWrapper

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Parser diagnostic only; no source correctness theorem is exported. -/
#eval IO.FS.writeFile "../INPUT_PROGRAM_PROBE.txt"
  ((repr (FT1536.Source3.KeygenPublicSource.code .compute)).pretty)
