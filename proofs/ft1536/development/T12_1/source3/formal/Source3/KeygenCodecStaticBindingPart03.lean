import Source3.KeygenCodecStaticBindingPart02

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticBinding
open KeygenCodecSyntax KeygenCodecGrammar

def node082 : Stmt := .skip
def node082Tokens : List B20.C.Token := []
theorem node082_source : Body node082 node082Tokens := by exact .nil

def node083 : Stmt := (.seq node081 node082)
def node083Tokens : List B20.C.Token := node081Tokens++node082Tokens
theorem node083_source : Body node083 node083Tokens := by exact .cons _ _ _ _ node081_source node082_source

def node084 : Stmt := (.seq node062 node083)
def node084Tokens : List B20.C.Token := node062Tokens++node083Tokens
theorem node084_source : Body node084 node084Tokens := by exact .cons _ _ _ _ node062_source node083_source

def node085 : Stmt := (.seq node061 node084)
def node085Tokens : List B20.C.Token := node061Tokens++node084Tokens
theorem node085_source : Body node085 node085Tokens := by exact .cons _ _ _ _ node061_source node084_source

def node086 : Stmt := (.scope node085)
def node086Tokens : List B20.C.Token := [['{']]++node085Tokens++[['}']]
theorem node086_source : Statement node086 node086Tokens := by exact .scope _ _ node085_source

def guard087 : Expr := (.binary .ge (.postDec (.variable "ne".toList)) (.number .i32 0))
def guard087Tokens : List B20.C.Token := ["ne","-","-",">=","0"].map String.toList
theorem guard087_source : guard guard087 guard087Tokens := by rfl

def node087 : Stmt := (.whileLoop guard087 node086)
def node087Tokens : List B20.C.Token := ["while".toList,['(']]++guard087Tokens++[[')']]++node086Tokens
theorem node087_source : Statement node087 node087Tokens := by exact .whileLoop _ _ _ _ guard087_source node086_source

def node088 : Stmt := .skip
def node088Tokens : List B20.C.Token := []
theorem node088_source : Body node088 node088Tokens := by exact .nil

def node089 : Stmt := (.seq node087 node088)
def node089Tokens : List B20.C.Token := node087Tokens++node088Tokens
theorem node089_source : Body node089 node089Tokens := by exact .cons _ _ _ _ node087_source node088_source

def node090 : Stmt := (.seq node060 node089)
def node090Tokens : List B20.C.Token := node060Tokens++node089Tokens
theorem node090_source : Body node090 node090Tokens := by exact .cons _ _ _ _ node060_source node089_source

def node091 : Stmt := (.seq node041 node090)
def node091Tokens : List B20.C.Token := node041Tokens++node090Tokens
theorem node091_source : Body node091 node091Tokens := by exact .cons _ _ _ _ node041_source node090_source

def node092 : Stmt := (.seq node040 node091)
def node092Tokens : List B20.C.Token := node040Tokens++node091Tokens
theorem node092_source : Body node092 node092Tokens := by exact .cons _ _ _ _ node040_source node091_source

def node093 : Stmt := (.seq node039 node092)
def node093Tokens : List B20.C.Token := node039Tokens++node092Tokens
theorem node093_source : Body node093 node093Tokens := by exact .cons _ _ _ _ node039_source node092_source

def node094 : Stmt := (.seq node038 node093)
def node094Tokens : List B20.C.Token := node038Tokens++node093Tokens
theorem node094_source : Body node094 node094Tokens := by exact .cons _ _ _ _ node038_source node093_source

def node095 : Stmt := (.seq node037 node094)
def node095Tokens : List B20.C.Token := node037Tokens++node094Tokens
theorem node095_source : Body node095 node095Tokens := by exact .cons _ _ _ _ node037_source node094_source

def node096 : Stmt := (.seq node026 node095)
def node096Tokens : List B20.C.Token := node026Tokens++node095Tokens
theorem node096_source : Body node096 node096Tokens := by exact .cons _ _ _ _ node026_source node095_source

def node097 : Stmt := (.seq node025 node096)
def node097Tokens : List B20.C.Token := node025Tokens++node096Tokens
theorem node097_source : Body node097 node097Tokens := by exact .cons _ _ _ _ node025_source node096_source

def node098 : Stmt := (.seq node024 node097)
def node098Tokens : List B20.C.Token := node024Tokens++node097Tokens
theorem node098_source : Body node098 node098Tokens := by exact .cons _ _ _ _ node024_source node097_source

def node099 : Stmt := (.seq node023 node098)
def node099Tokens : List B20.C.Token := node023Tokens++node098Tokens
theorem node099_source : Body node099 node099Tokens := by exact .cons _ _ _ _ node023_source node098_source

def node100 : Stmt := (.seq node022 node099)
def node100Tokens : List B20.C.Token := node022Tokens++node099Tokens
theorem node100_source : Body node100 node100Tokens := by exact .cons _ _ _ _ node022_source node099_source

def node101 : Stmt := (.scope node100)
def node101Tokens : List B20.C.Token := [['{']]++node100Tokens++[['}']]
theorem node101_source : Statement node101 node101Tokens := by exact .scope _ _ node100_source

def guard102 : Expr := (.binary .gt (.variable "n".toList) (.number .i32 0))
def guard102Tokens : List B20.C.Token := ["n",">","0"].map String.toList
theorem guard102_source : guard guard102 guard102Tokens := by rfl

def node102 : Stmt := (.whileLoop guard102 node101)
def node102Tokens : List B20.C.Token := ["while".toList,['(']]++guard102Tokens++[[')']]++node101Tokens
theorem node102_source : Statement node102 node102Tokens := by exact .whileLoop _ _ _ _ guard102_source node101_source

def node103 : Stmt := (.ret (.number .i32 0))
def node103Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node103_source : Statement node103 node103Tokens := by exact .simple _ _ (by rfl)

def node104 : Stmt := .skip
def node104Tokens : List B20.C.Token := []
theorem node104_source : Body node104 node104Tokens := by exact .nil

def node105 : Stmt := (.seq node103 node104)
def node105Tokens : List B20.C.Token := node103Tokens++node104Tokens
theorem node105_source : Body node105 node105Tokens := by exact .cons _ _ _ _ node103_source node104_source

def node106 : Stmt := (.scope node105)
def node106Tokens : List B20.C.Token := [['{']]++node105Tokens++[['}']]
theorem node106_source : Statement node106 node106Tokens := by exact .scope _ _ node105_source

def guard107 : Expr := (.binary .ge (.variable "u".toList) (.variable "max_out_len".toList))
def guard107Tokens : List B20.C.Token := ["u",">=","max_out_len"].map String.toList
theorem guard107_source : guard guard107 guard107Tokens := by rfl

def node107 : Stmt := (.branch guard107 node106 .skip)
def node107Tokens : List B20.C.Token := ["if".toList,['(']]++guard107Tokens++[[')']]++node106Tokens
theorem node107_source : Statement node107 node107Tokens := by exact .ifOnly _ _ _ _ guard107_source node106_source

def node108 : Stmt := (.write (.index (.variable "buf".toList) (.variable "u".toList)) .set (.cast .byte (.binary .shl (.variable "acc".toList) (.binary .sub (.number .i32 8) (.variable "acc_len".toList)))))
def node108Tokens : List B20.C.Token := ["buf","[","u","]","=","(","unsigned","char",")","(","acc","<<","(","8","-","acc_len",")",")",";"].map String.toList
theorem node108_source : Statement node108 node108Tokens := by exact .simple _ _ (by rfl)

end FT1536.Source3.KeygenCodecStaticBinding
