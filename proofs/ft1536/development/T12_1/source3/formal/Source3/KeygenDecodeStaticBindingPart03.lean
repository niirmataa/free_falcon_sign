import Source3.KeygenDecodeStaticBindingPart02

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

theorem node080_source : Statement node080 node080Tokens := by exact .scope _ _ node079_source

def node081 : Stmt := (.write (.index (.variable "x".toList) (.variable "u".toList)) .set (.cast .i16 (.variable "lo".toList)))
def node081Tokens : List B20.C.Token := ["x","[","u","]","=","(","int16_t",")","lo",";"].map String.toList
theorem node081_source : Statement node081 node081Tokens := by exact .simple _ _ (by rfl)

def node082 : Stmt := .skip
def node082Tokens : List B20.C.Token := []
theorem node082_source : Body node082 node082Tokens := by exact .nil

def node083 : Stmt := (.seq node081 node082)
def node083Tokens : List B20.C.Token := node081Tokens++node082Tokens
theorem node083_source : Body node083 node083Tokens := by exact .cons _ _ _ _ node081_source node082_source

def node084 : Stmt := (.scope node083)
def node084Tokens : List B20.C.Token := [['{']]++node083Tokens++[['}']]
theorem node084_source : Statement node084 node084Tokens := by exact .scope _ _ node083_source

def guard085 : Expr := (.variable "sign".toList)
def guard085Tokens : List B20.C.Token := ["sign"].map String.toList
theorem guard085_source : guard guard085 guard085Tokens := by rfl

def node085 : Stmt := (.branch guard085 node080 node084)
def node085Tokens : List B20.C.Token := ["if".toList,['(']]++guard085Tokens++[[')']]++node080Tokens++["else".toList]++node084Tokens
theorem node085_source : Statement node085 node085Tokens := by exact .ifElse _ _ _ _ _ _ guard085_source node080_source node084_source

def node086 : Stmt := (.ret (.number .i32 0))
def node086Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node086_source : Statement node086 node086Tokens := by exact .simple _ _ (by rfl)

def node087 : Stmt := .skip
def node087Tokens : List B20.C.Token := []
theorem node087_source : Body node087 node087Tokens := by exact .nil

def node088 : Stmt := (.seq node086 node087)
def node088Tokens : List B20.C.Token := node086Tokens++node087Tokens
theorem node088_source : Body node088 node088Tokens := by exact .cons _ _ _ _ node086_source node087_source

def node089 : Stmt := (.scope node088)
def node089Tokens : List B20.C.Token := [['{']]++node088Tokens++[['}']]
theorem node089_source : Statement node089 node089Tokens := by exact .scope _ _ node088_source

def guard090 : Expr := (.binary .ne (.binary .band (.variable "db".toList) (.binary .sub (.binary .shl (.number .u32 1) (.variable "db_len".toList)) (.number .u32 1))) (.number .i32 0))
def guard090Tokens : List B20.C.Token := ["(","db","&","(","(","1U","<<","db_len",")","-","1U",")",")","!=","0"].map String.toList
theorem guard090_source : guard guard090 guard090Tokens := by rfl

def node090 : Stmt := (.branch guard090 node089 .skip)
def node090Tokens : List B20.C.Token := ["if".toList,['(']]++guard090Tokens++[[')']]++node089Tokens
theorem node090_source : Statement node090 node090Tokens := by exact .ifOnly _ _ _ _ guard090_source node089_source

def node091 : Stmt := (.ret (.variable "v".toList))
def node091Tokens : List B20.C.Token := ["return","v",";"].map String.toList
theorem node091_source : Statement node091 node091Tokens := by exact .simple _ _ (by rfl)

def node092 : Stmt := .skip
def node092Tokens : List B20.C.Token := []
theorem node092_source : Body node092 node092Tokens := by exact .nil

def node093 : Stmt := (.seq node091 node092)
def node093Tokens : List B20.C.Token := node091Tokens++node092Tokens
theorem node093_source : Body node093 node093Tokens := by exact .cons _ _ _ _ node091_source node092_source

def node094 : Stmt := (.seq node090 node093)
def node094Tokens : List B20.C.Token := node090Tokens++node093Tokens
theorem node094_source : Body node094 node094Tokens := by exact .cons _ _ _ _ node090_source node093_source

def node095 : Stmt := (.scope node094)
def node095Tokens : List B20.C.Token := [['{']]++node094Tokens++[['}']]
theorem node095_source : Statement node095 node095Tokens := by exact .scope _ _ node094_source

def guard096 : Expr := (.binary .ge (.preInc (.variable "u".toList)) (.variable "n".toList))
def guard096Tokens : List B20.C.Token := ["++","u",">=","n"].map String.toList
theorem guard096_source : guard guard096 guard096Tokens := by rfl

def node096 : Stmt := (.branch guard096 node095 .skip)
def node096Tokens : List B20.C.Token := ["if".toList,['(']]++guard096Tokens++[[')']]++node095Tokens
theorem node096_source : Statement node096 node096Tokens := by exact .ifOnly _ _ _ _ guard096_source node095_source

def node097 : Stmt := .skip
def node097Tokens : List B20.C.Token := []
theorem node097_source : Body node097 node097Tokens := by exact .nil

def node098 : Stmt := (.seq node096 node097)
def node098Tokens : List B20.C.Token := node096Tokens++node097Tokens
theorem node098_source : Body node098 node098Tokens := by exact .cons _ _ _ _ node096_source node097_source

def node099 : Stmt := (.seq node085 node098)
def node099Tokens : List B20.C.Token := node085Tokens++node098Tokens
theorem node099_source : Body node099 node099Tokens := by exact .cons _ _ _ _ node085_source node098_source

def node100 : Stmt := (.seq node076 node099)
def node100Tokens : List B20.C.Token := node076Tokens++node099Tokens
theorem node100_source : Body node100 node100Tokens := by exact .cons _ _ _ _ node076_source node099_source

def node101 : Stmt := (.seq node075 node100)
def node101Tokens : List B20.C.Token := node075Tokens++node100Tokens
theorem node101_source : Body node101 node101Tokens := by exact .cons _ _ _ _ node075_source node100_source

def node102 : Stmt := (.seq node070 node101)
def node102Tokens : List B20.C.Token := node070Tokens++node101Tokens
theorem node102_source : Body node102 node102Tokens := by exact .cons _ _ _ _ node070_source node101_source

def node103 : Stmt := (.seq node041 node102)
def node103Tokens : List B20.C.Token := node041Tokens++node102Tokens
theorem node103_source : Body node103 node103Tokens := by exact .cons _ _ _ _ node041_source node102_source

def node104 : Stmt := (.seq node040 node103)
def node104Tokens : List B20.C.Token := node040Tokens++node103Tokens
theorem node104_source : Body node104 node104Tokens := by exact .cons _ _ _ _ node040_source node103_source

def node105 : Stmt := (.seq node039 node104)
def node105Tokens : List B20.C.Token := node039Tokens++node104Tokens
theorem node105_source : Body node105 node105Tokens := by exact .cons _ _ _ _ node039_source node104_source

def node106 : Stmt := (.seq node038 node105)
def node106Tokens : List B20.C.Token := node038Tokens++node105Tokens
theorem node106_source : Body node106 node106Tokens := by exact .cons _ _ _ _ node038_source node105_source

def node107 : Stmt := (.seq node025 node106)
def node107Tokens : List B20.C.Token := node025Tokens++node106Tokens
end FT1536.Source3.KeygenDecodeStaticBinding
