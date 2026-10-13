import Source3.KeygenPublicEncodeBinding077Part00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeBinding077
open KeygenCodecSyntax KeygenCodecGrammar

def node028 : Stmt := (.seq node024 node027)
def node028Tokens : List B20.C.Token := node024Tokens++node027Tokens
theorem node028_source : Body node028 node028Tokens := by exact .cons _ _ _ _ node024_source node027_source

def node029 : Stmt := (.seq node023 node028)
def node029Tokens : List B20.C.Token := node023Tokens++node028Tokens
theorem node029_source : Body node029 node029Tokens := by exact .cons _ _ _ _ node023_source node028_source

def node030 : Stmt := (.seq node012 node029)
def node030Tokens : List B20.C.Token := node012Tokens++node029Tokens
theorem node030_source : Body node030 node030Tokens := by exact .cons _ _ _ _ node012_source node029_source

def node031 : Stmt := (.scope node030)
def node031Tokens : List B20.C.Token := [['{']]++node030Tokens++[['}']]
theorem node031_source : Statement node031 node031Tokens := by exact .scope _ _ node030_source

def guard032 : Expr := (.binary .ge (.variable "acc_len".toList) (.number .i32 8))
def guard032Tokens : List B20.C.Token := ["acc_len",">=","8"].map String.toList
theorem guard032_source : guard guard032 guard032Tokens := by rfl

def node032 : Stmt := (.whileLoop guard032 node031)
def node032Tokens : List B20.C.Token := ["while".toList,['(']]++guard032Tokens++[[')']]++node031Tokens
theorem node032_source : Statement node032 node032Tokens := by exact .whileLoop _ _ _ _ guard032_source node031_source

def node033 : Stmt := .skip
def node033Tokens : List B20.C.Token := []
theorem node033_source : Body node033 node033Tokens := by exact .nil

def node034 : Stmt := (.seq node032 node033)
def node034Tokens : List B20.C.Token := node032Tokens++node033Tokens
theorem node034_source : Body node034 node034Tokens := by exact .cons _ _ _ _ node032_source node033_source

def node035 : Stmt := (.seq node011 node034)
def node035Tokens : List B20.C.Token := node011Tokens++node034Tokens
theorem node035_source : Body node035 node035Tokens := by exact .cons _ _ _ _ node011_source node034_source

def node036 : Stmt := (.seq node010 node035)
def node036Tokens : List B20.C.Token := node010Tokens++node035Tokens
theorem node036_source : Body node036 node036Tokens := by exact .cons _ _ _ _ node010_source node035_source

def node037 : Stmt := (.seq node009 node036)
def node037Tokens : List B20.C.Token := node009Tokens++node036Tokens
theorem node037_source : Body node037 node037Tokens := by exact .cons _ _ _ _ node009_source node036_source

def node038 : Stmt := (.scope node037)
def node038Tokens : List B20.C.Token := [['{']]++node037Tokens++[['}']]
theorem node038_source : Statement node038 node038Tokens := by exact .scope _ _ node037_source

def guard039 : Expr := (.binary .gt (.variable "n".toList) (.number .i32 0))
def guard039Tokens : List B20.C.Token := ["n",">","0"].map String.toList
theorem guard039_source : guard guard039 guard039Tokens := by rfl

def node039 : Stmt := (.whileLoop guard039 node038)
def node039Tokens : List B20.C.Token := ["while".toList,['(']]++guard039Tokens++[[')']]++node038Tokens
theorem node039_source : Statement node039 node039Tokens := by exact .whileLoop _ _ _ _ guard039_source node038_source

def node040 : Stmt := (.ret (.number .i32 0))
def node040Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node040_source : Statement node040 node040Tokens := by exact .simple _ _ (by rfl)

def node041 : Stmt := .skip
def node041Tokens : List B20.C.Token := []
theorem node041_source : Body node041 node041Tokens := by exact .nil

def node042 : Stmt := (.seq node040 node041)
def node042Tokens : List B20.C.Token := node040Tokens++node041Tokens
theorem node042_source : Body node042 node042Tokens := by exact .cons _ _ _ _ node040_source node041_source

def node043 : Stmt := (.scope node042)
def node043Tokens : List B20.C.Token := [['{']]++node042Tokens++[['}']]
theorem node043_source : Statement node043 node043Tokens := by exact .scope _ _ node042_source

def guard044 : Expr := (.binary .ge (.variable "u".toList) (.variable "max_out_len".toList))
def guard044Tokens : List B20.C.Token := ["u",">=","max_out_len"].map String.toList
theorem guard044_source : guard guard044 guard044Tokens := by rfl

def node044 : Stmt := (.branch guard044 node043 .skip)
def node044Tokens : List B20.C.Token := ["if".toList,['(']]++guard044Tokens++[[')']]++node043Tokens
theorem node044_source : Statement node044 node044Tokens := by exact .ifOnly _ _ _ _ guard044_source node043_source

def node045 : Stmt := (.write (.index (.variable "buf".toList) (.variable "u".toList)) .set (.cast .byte (.binary .shl (.variable "acc".toList) (.binary .sub (.number .i32 8) (.variable "acc_len".toList)))))
def node045Tokens : List B20.C.Token := ["buf","[","u","]","=","(","unsigned","char",")","(","acc","<<","(","8","-","acc_len",")",")",";"].map String.toList
theorem node045_source : Statement node045 node045Tokens := by exact .simple _ _ (by rfl)

def node046 : Stmt := .skip
def node046Tokens : List B20.C.Token := []
theorem node046_source : Body node046 node046Tokens := by exact .nil

def node047 : Stmt := (.seq node045 node046)
def node047Tokens : List B20.C.Token := node045Tokens++node046Tokens
theorem node047_source : Body node047 node047Tokens := by exact .cons _ _ _ _ node045_source node046_source

def node048 : Stmt := (.seq node044 node047)
def node048Tokens : List B20.C.Token := node044Tokens++node047Tokens
theorem node048_source : Body node048 node048Tokens := by exact .cons _ _ _ _ node044_source node047_source

def node049 : Stmt := (.scope node048)
def node049Tokens : List B20.C.Token := [['{']]++node048Tokens++[['}']]
theorem node049_source : Statement node049 node049Tokens := by exact .scope _ _ node048_source

def guard050 : Expr := (.binary .ne (.variable "out".toList) (.variable "NULL".toList))
def guard050Tokens : List B20.C.Token := ["out","!=","NULL"].map String.toList
theorem guard050_source : guard guard050 guard050Tokens := by rfl

def node050 : Stmt := (.branch guard050 node049 .skip)
def node050Tokens : List B20.C.Token := ["if".toList,['(']]++guard050Tokens++[[')']]++node049Tokens
theorem node050_source : Statement node050 node050Tokens := by exact .ifOnly _ _ _ _ guard050_source node049_source

def node051 : Stmt := (.evaluate (.postInc (.variable "u".toList)))
def node051Tokens : List B20.C.Token := ["u","++",";"].map String.toList
theorem node051_source : Statement node051 node051Tokens := by exact .simple _ _ (by rfl)

def node052 : Stmt := .skip
def node052Tokens : List B20.C.Token := []
theorem node052_source : Body node052 node052Tokens := by exact .nil

def node053 : Stmt := (.seq node051 node052)
def node053Tokens : List B20.C.Token := node051Tokens++node052Tokens
theorem node053_source : Body node053 node053Tokens := by exact .cons _ _ _ _ node051_source node052_source

end FT1536.Source3.KeygenPublicEncodeBinding077
