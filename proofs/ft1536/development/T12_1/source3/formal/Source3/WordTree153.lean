import Init.Data.BitVec.Basic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.WordTree153

/-- Literal certificate data with logarithmic access, independent of source semantics. -/
inductive Tree where
  | leaf (word : BitVec 64)
  | node (even odd : Tree)

def read : Tree → Nat → BitVec 64
  | .leaf word,_ => word
  | .node even odd,index => if index%2=0 then read even (index/2) else read odd (index/2)

end FT1536.Source3.WordTree153
