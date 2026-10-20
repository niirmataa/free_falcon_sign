import Source3.KeygenLevelNtt

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC syntax probe (no proof claim): print the parsed statement
   trees of the accepted KeygenLevelNtt corpus parts so the transcription
   module can be matched exactly. Output is retained in the job log. -/
namespace FT1536.Source3.NttInverseShapeProbe192

#eval repr (KeygenLevelNtt.part 0)
#eval repr (KeygenLevelNtt.part 1)
#eval repr (KeygenLevelNtt.part 2)
#eval repr (KeygenLevelNtt.part 3)
#eval repr (KeygenLevelNtt.part 4)

end FT1536.Source3.NttInverseShapeProbe192
