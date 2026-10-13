import Source3.KeygenDecodeNoneBindingPart00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeNoneBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

def node028 : Stmt := (.scope node027)
def node028Tokens : List B20.C.Token := [['{']]++node027Tokens++[['}']]
theorem node028_source : Statement node028 node028Tokens := by exact .scope _ _ node027_source

def guard029 : Expr := (.unary .logicalNot (.binary .shr (.binary .band (.binary .sub (.variable "hq".toList) (.variable "w".toList)) (.binary .sub (.variable "w".toList) (.variable "tq".toList))) (.number .i32 31)))
def guard029Tokens : List B20.C.Token := ["!","(","(","(","hq","-","w",")","&","(","w","-","tq",")",")",">>","31",")"].map String.toList
theorem guard029_source : guard guard029 guard029Tokens := by rfl

def node029 : Stmt := (.branch guard029 node028 .skip)
def node029Tokens : List B20.C.Token := ["if".toList,['(']]++guard029Tokens++[[')']]++node028Tokens
theorem node029_source : Statement node029 node029Tokens := by exact .ifOnly _ _ _ _ guard029_source node028_source

def node030 : Stmt := (.write (.variable "y".toList) .set (.binary .sub (.cast .long (.variable "w".toList)) (.cast .long (.variable "q".toList))))
def node030Tokens : List B20.C.Token := ["y","=","(","long",")","w","-","(","long",")","q",";"].map String.toList
theorem node030_source : Statement node030 node030Tokens := by exact .simple _ _ (by rfl)

def node031 : Stmt := (.write (.index (.variable "x".toList) (.variable "u".toList)) .set (.cast .i16 (.variable "y".toList)))
def node031Tokens : List B20.C.Token := ["x","[","u","]","=","(","int16_t",")","y",";"].map String.toList
theorem node031_source : Statement node031 node031Tokens := by exact .simple _ _ (by rfl)

def node032 : Stmt := .skip
def node032Tokens : List B20.C.Token := []
theorem node032_source : Body node032 node032Tokens := by exact .nil

def node033 : Stmt := (.seq node031 node032)
def node033Tokens : List B20.C.Token := node031Tokens++node032Tokens
theorem node033_source : Body node033 node033Tokens := by exact .cons _ _ _ _ node031_source node032_source

def node034 : Stmt := (.seq node030 node033)
def node034Tokens : List B20.C.Token := node030Tokens++node033Tokens
theorem node034_source : Body node034 node034Tokens := by exact .cons _ _ _ _ node030_source node033_source

def node035 : Stmt := (.seq node029 node034)
def node035Tokens : List B20.C.Token := node029Tokens++node034Tokens
theorem node035_source : Body node035 node035Tokens := by exact .cons _ _ _ _ node029_source node034_source

def node036 : Stmt := (.seq node024 node035)
def node036Tokens : List B20.C.Token := node024Tokens++node035Tokens
theorem node036_source : Body node036 node036Tokens := by exact .cons _ _ _ _ node024_source node035_source

def node037 : Stmt := (.seq node023 node036)
def node037Tokens : List B20.C.Token := node023Tokens++node036Tokens
theorem node037_source : Body node037 node037Tokens := by exact .cons _ _ _ _ node023_source node036_source

def node038 : Stmt := (.seq node022 node037)
def node038Tokens : List B20.C.Token := node022Tokens++node037Tokens
theorem node038_source : Body node038 node038Tokens := by exact .cons _ _ _ _ node022_source node037_source

def node039 : Stmt := (.seq node021 node038)
def node039Tokens : List B20.C.Token := node021Tokens++node038Tokens
theorem node039_source : Body node039 node039Tokens := by exact .cons _ _ _ _ node021_source node038_source

def node040 : Stmt := (.seq node020 node039)
def node040Tokens : List B20.C.Token := node020Tokens++node039Tokens
theorem node040_source : Body node040 node040Tokens := by exact .cons _ _ _ _ node020_source node039_source

def node041 : Stmt := (.scope node040)
def node041Tokens : List B20.C.Token := [['{']]++node040Tokens++[['}']]
theorem node041_source : Statement node041 node041Tokens := by exact .scope _ _ node040_source

def loop042Init : Stmt := (.write (.variable "u".toList) .set (.number .i32 0))
def loop042Update : Stmt := (.evaluate (.postInc (.variable "u".toList)))
def loop042Test : Option Expr := (some (.binary .lt (.variable "u".toList) (.variable "n".toList)))
def loop042First : List B20.C.Token := ["u","=","0"].map String.toList
def loop042Middle : List B20.C.Token := ["u","<","n"].map String.toList
def loop042Last : List B20.C.Token := ["u","++"].map String.toList
theorem loop042_initial : initialClause loop042Init loop042First := by rfl
theorem loop042_increment : incrementClause loop042Update loop042Last := by rfl
theorem loop042_condition : Test loop042Test loop042Middle := by exact .present _ _ (by rfl)

def node042 : Stmt := (.loop loop042Init loop042Test loop042Update node041)
def node042Tokens : List B20.C.Token := ["for".toList,['(']]++loop042First++[[';']]++loop042Middle++[[';']]++loop042Last++[[')']]++node041Tokens
theorem node042_source : Statement node042 node042Tokens := by exact .loop _ _ _ _ _ _ _ _ loop042_initial loop042_condition loop042_increment node041_source

def node043 : Stmt := (.ret (.binary .shl (.variable "n".toList) (.number .i32 1)))
def node043Tokens : List B20.C.Token := ["return","n","<<","1",";"].map String.toList
theorem node043_source : Statement node043 node043Tokens := by exact .simple _ _ (by rfl)

def node044 : Stmt := .skip
def node044Tokens : List B20.C.Token := []
theorem node044_source : Body node044 node044Tokens := by exact .nil

def node045 : Stmt := (.seq node043 node044)
def node045Tokens : List B20.C.Token := node043Tokens++node044Tokens
theorem node045_source : Body node045 node045Tokens := by exact .cons _ _ _ _ node043_source node044_source

def node046 : Stmt := (.seq node042 node045)
def node046Tokens : List B20.C.Token := node042Tokens++node045Tokens
theorem node046_source : Body node046 node046Tokens := by exact .cons _ _ _ _ node042_source node045_source

def node047 : Stmt := (.seq node019 node046)
def node047Tokens : List B20.C.Token := node019Tokens++node046Tokens
theorem node047_source : Body node047 node047Tokens := by exact .cons _ _ _ _ node019_source node046_source

def node048 : Stmt := (.seq node018 node047)
def node048Tokens : List B20.C.Token := node018Tokens++node047Tokens
theorem node048_source : Body node048 node048Tokens := by exact .cons _ _ _ _ node018_source node047_source

def node049 : Stmt := (.seq node017 node048)
def node049Tokens : List B20.C.Token := node017Tokens++node048Tokens
theorem node049_source : Body node049 node049Tokens := by exact .cons _ _ _ _ node017_source node048_source

def node050 : Stmt := (.seq node016 node049)
def node050Tokens : List B20.C.Token := node016Tokens++node049Tokens
theorem node050_source : Body node050 node050Tokens := by exact .cons _ _ _ _ node016_source node049_source

def node051 : Stmt := (.seq node011 node050)
def node051Tokens : List B20.C.Token := node011Tokens++node050Tokens
theorem node051_source : Body node051 node051Tokens := by exact .cons _ _ _ _ node011_source node050_source

def node052 : Stmt := (.seq node002 node051)
def node052Tokens : List B20.C.Token := node002Tokens++node051Tokens
theorem node052_source : Body node052 node052Tokens := by exact .cons _ _ _ _ node002_source node051_source

def node053 : Stmt := (.seq node001 node052)
def node053Tokens : List B20.C.Token := node001Tokens++node052Tokens
theorem node053_source : Body node053 node053Tokens := by exact .cons _ _ _ _ node001_source node052_source

def node054 : Stmt := (.seq node000 node053)
def node054Tokens : List B20.C.Token := node000Tokens++node053Tokens
end FT1536.Source3.KeygenDecodeNoneBinding
