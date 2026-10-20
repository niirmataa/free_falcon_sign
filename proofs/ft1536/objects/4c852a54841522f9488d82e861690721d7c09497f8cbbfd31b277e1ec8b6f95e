import Source3.KeygenMakeBindingPart02

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

def node080 : Stmt := (.scope node079)
def node080Tokens : List B20.C.Token := [['{']]++node079Tokens++[['}']]
theorem node080_source : Statement node080 node080Tokens := by exact .scope _ _ node079_source

def guard081 : Expr := (.unary .logicalNot (.call .lt (argumentTree [(.variable "norm".toList),(.variable "bound".toList)])))
def guard081Tokens : List B20.C.Token := ["!","fpr_lt","(","norm",",","bound",")"].map String.toList
theorem guard081_source : guard guard081 guard081Tokens := by rfl

def node081 : Stmt := (.branch guard081 node080 .skip)
def node081Tokens : List B20.C.Token := ["if".toList,['(']]++guard081Tokens++[[')']]++node080Tokens
theorem node081_source : Statement node081 node081Tokens := by exact .ifOnly _ _ _ _ guard081_source node080_source

def node082 : Stmt := .skip
def node082Tokens : List B20.C.Token := []
theorem node082_source : Body node082 node082Tokens := by exact .nil

def node083 : Stmt := (.seq node081 node082)
def node083Tokens : List B20.C.Token := node081Tokens++node082Tokens
theorem node083_source : Body node083 node083Tokens := by exact .cons _ _ _ _ node081_source node082_source

def node084 : Stmt := (.seq node076 node083)
def node084Tokens : List B20.C.Token := node076Tokens++node083Tokens
theorem node084_source : Body node084 node084Tokens := by exact .cons _ _ _ _ node076_source node083_source

def node085 : Stmt := (.seq node075 node084)
def node085Tokens : List B20.C.Token := node075Tokens++node084Tokens
theorem node085_source : Body node085 node085Tokens := by exact .cons _ _ _ _ node075_source node084_source

def node086 : Stmt := (.seq node068 node085)
def node086Tokens : List B20.C.Token := node068Tokens++node085Tokens
theorem node086_source : Body node086 node086Tokens := by exact .cons _ _ _ _ node068_source node085_source

def node087 : Stmt := (.seq node067 node086)
def node087Tokens : List B20.C.Token := node067Tokens++node086Tokens
theorem node087_source : Body node087 node087Tokens := by exact .cons _ _ _ _ node067_source node086_source

def node088 : Stmt := (.seq node066 node087)
def node088Tokens : List B20.C.Token := node066Tokens++node087Tokens
theorem node088_source : Body node088 node088Tokens := by exact .cons _ _ _ _ node066_source node087_source

def node089 : Stmt := (.seq node065 node088)
def node089Tokens : List B20.C.Token := node065Tokens++node088Tokens
theorem node089_source : Body node089 node089Tokens := by exact .cons _ _ _ _ node065_source node088_source

def node090 : Stmt := (.seq node064 node089)
def node090Tokens : List B20.C.Token := node064Tokens++node089Tokens
theorem node090_source : Body node090 node090Tokens := by exact .cons _ _ _ _ node064_source node089_source

def node091 : Stmt := (.seq node063 node090)
def node091Tokens : List B20.C.Token := node063Tokens++node090Tokens
theorem node091_source : Body node091 node091Tokens := by exact .cons _ _ _ _ node063_source node090_source

def node092 : Stmt := (.seq node062 node091)
def node092Tokens : List B20.C.Token := node062Tokens++node091Tokens
theorem node092_source : Body node092 node092Tokens := by exact .cons _ _ _ _ node062_source node091_source

def node093 : Stmt := (.seq node061 node092)
def node093Tokens : List B20.C.Token := node061Tokens++node092Tokens
theorem node093_source : Body node093 node093Tokens := by exact .cons _ _ _ _ node061_source node092_source

def node094 : Stmt := (.seq node060 node093)
def node094Tokens : List B20.C.Token := node060Tokens++node093Tokens
theorem node094_source : Body node094 node094Tokens := by exact .cons _ _ _ _ node060_source node093_source

def node095 : Stmt := (.seq node055 node094)
def node095Tokens : List B20.C.Token := node055Tokens++node094Tokens
theorem node095_source : Body node095 node095Tokens := by exact .cons _ _ _ _ node055_source node094_source

def node096 : Stmt := (.seq node054 node095)
def node096Tokens : List B20.C.Token := node054Tokens++node095Tokens
theorem node096_source : Body node096 node096Tokens := by exact .cons _ _ _ _ node054_source node095_source

def node097 : Stmt := (.seq node047 node096)
def node097Tokens : List B20.C.Token := node047Tokens++node096Tokens
theorem node097_source : Body node097 node097Tokens := by exact .cons _ _ _ _ node047_source node096_source

def node098 : Stmt := (.seq node046 node097)
def node098Tokens : List B20.C.Token := node046Tokens++node097Tokens
theorem node098_source : Body node098 node098Tokens := by exact .cons _ _ _ _ node046_source node097_source

def node099 : Stmt := (.seq node045 node098)
def node099Tokens : List B20.C.Token := node045Tokens++node098Tokens
theorem node099_source : Body node099 node099Tokens := by exact .cons _ _ _ _ node045_source node098_source

def node100 : Stmt := (.seq node044 node099)
def node100Tokens : List B20.C.Token := node044Tokens++node099Tokens
theorem node100_source : Body node100 node100Tokens := by exact .cons _ _ _ _ node044_source node099_source

def node101 : Stmt := (.seq node043 node100)
def node101Tokens : List B20.C.Token := node043Tokens++node100Tokens
theorem node101_source : Body node101 node101Tokens := by exact .cons _ _ _ _ node043_source node100_source

def node102 : Stmt := (.seq node042 node101)
def node102Tokens : List B20.C.Token := node042Tokens++node101Tokens
theorem node102_source : Body node102 node102Tokens := by exact .cons _ _ _ _ node042_source node101_source

def node103 : Stmt := (.seq node041 node102)
def node103Tokens : List B20.C.Token := node041Tokens++node102Tokens
theorem node103_source : Body node103 node103Tokens := by exact .cons _ _ _ _ node041_source node102_source

def node104 : Stmt := (.seq node040 node103)
def node104Tokens : List B20.C.Token := node040Tokens++node103Tokens
theorem node104_source : Body node104 node104Tokens := by exact .cons _ _ _ _ node040_source node103_source

def node105 : Stmt := (.seq node035 node104)
def node105Tokens : List B20.C.Token := node035Tokens++node104Tokens
theorem node105_source : Body node105 node105Tokens := by exact .cons _ _ _ _ node035_source node104_source

def node106 : Stmt := (.seq node030 node105)
def node106Tokens : List B20.C.Token := node030Tokens++node105Tokens
theorem node106_source : Body node106 node106Tokens := by exact .cons _ _ _ _ node030_source node105_source

def node107 : Stmt := (.seq node029 node106)
def node107Tokens : List B20.C.Token := node029Tokens++node106Tokens
theorem node107_source : Body node107 node107Tokens := by exact .cons _ _ _ _ node029_source node106_source

def node108 : Stmt := (.seq node028 node107)
def node108Tokens : List B20.C.Token := node028Tokens++node107Tokens
theorem node108_source : Body node108 node108Tokens := by exact .cons _ _ _ _ node028_source node107_source

end FT1536.Source3.KeygenMakeBinding
