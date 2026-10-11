import Source3.KeygenCodecStaticBindingPart03

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticBinding
open KeygenCodecSyntax KeygenCodecGrammar

def node109 : Stmt := .skip
def node109Tokens : List B20.C.Token := []
theorem node109_source : Body node109 node109Tokens := by exact .nil

def node110 : Stmt := (.seq node108 node109)
def node110Tokens : List B20.C.Token := node108Tokens++node109Tokens
theorem node110_source : Body node110 node110Tokens := by exact .cons _ _ _ _ node108_source node109_source

def node111 : Stmt := (.seq node107 node110)
def node111Tokens : List B20.C.Token := node107Tokens++node110Tokens
theorem node111_source : Body node111 node111Tokens := by exact .cons _ _ _ _ node107_source node110_source

def node112 : Stmt := (.scope node111)
def node112Tokens : List B20.C.Token := [['{']]++node111Tokens++[['}']]
theorem node112_source : Statement node112 node112Tokens := by exact .scope _ _ node111_source

def guard113 : Expr := (.binary .ne (.variable "buf".toList) (.variable "NULL".toList))
def guard113Tokens : List B20.C.Token := ["buf","!=","NULL"].map String.toList
theorem guard113_source : guard guard113 guard113Tokens := by rfl

def node113 : Stmt := (.branch guard113 node112 .skip)
def node113Tokens : List B20.C.Token := ["if".toList,['(']]++guard113Tokens++[[')']]++node112Tokens
theorem node113_source : Statement node113 node113Tokens := by exact .ifOnly _ _ _ _ guard113_source node112_source

def node114 : Stmt := (.evaluate (.postInc (.variable "u".toList)))
def node114Tokens : List B20.C.Token := ["u","++",";"].map String.toList
theorem node114_source : Statement node114 node114Tokens := by exact .simple _ _ (by rfl)

def node115 : Stmt := .skip
def node115Tokens : List B20.C.Token := []
theorem node115_source : Body node115 node115Tokens := by exact .nil

def node116 : Stmt := (.seq node114 node115)
def node116Tokens : List B20.C.Token := node114Tokens++node115Tokens
theorem node116_source : Body node116 node116Tokens := by exact .cons _ _ _ _ node114_source node115_source

def node117 : Stmt := (.seq node113 node116)
def node117Tokens : List B20.C.Token := node113Tokens++node116Tokens
theorem node117_source : Body node117 node117Tokens := by exact .cons _ _ _ _ node113_source node116_source

def node118 : Stmt := (.scope node117)
def node118Tokens : List B20.C.Token := [['{']]++node117Tokens++[['}']]
theorem node118_source : Statement node118 node118Tokens := by exact .scope _ _ node117_source

def guard119 : Expr := (.binary .gt (.variable "acc_len".toList) (.number .i32 0))
def guard119Tokens : List B20.C.Token := ["acc_len",">","0"].map String.toList
theorem guard119_source : guard guard119 guard119Tokens := by rfl

def node119 : Stmt := (.branch guard119 node118 .skip)
def node119Tokens : List B20.C.Token := ["if".toList,['(']]++guard119Tokens++[[')']]++node118Tokens
theorem node119_source : Statement node119 node119Tokens := by exact .ifOnly _ _ _ _ guard119_source node118_source

def node120 : Stmt := (.ret (.variable "u".toList))
def node120Tokens : List B20.C.Token := ["return","u",";"].map String.toList
theorem node120_source : Statement node120 node120Tokens := by exact .simple _ _ (by rfl)

def node121 : Stmt := .skip
def node121Tokens : List B20.C.Token := []
theorem node121_source : Body node121 node121Tokens := by exact .nil

def node122 : Stmt := (.seq node120 node121)
def node122Tokens : List B20.C.Token := node120Tokens++node121Tokens
theorem node122_source : Body node122 node122Tokens := by exact .cons _ _ _ _ node120_source node121_source

def node123 : Stmt := (.seq node119 node122)
def node123Tokens : List B20.C.Token := node119Tokens++node122Tokens
theorem node123_source : Body node123 node123Tokens := by exact .cons _ _ _ _ node119_source node122_source

def node124 : Stmt := (.seq node102 node123)
def node124Tokens : List B20.C.Token := node102Tokens++node123Tokens
theorem node124_source : Body node124 node124Tokens := by exact .cons _ _ _ _ node102_source node123_source

def node125 : Stmt := (.seq node021 node124)
def node125Tokens : List B20.C.Token := node021Tokens++node124Tokens
theorem node125_source : Body node125 node125Tokens := by exact .cons _ _ _ _ node021_source node124_source

def node126 : Stmt := (.seq node020 node125)
def node126Tokens : List B20.C.Token := node020Tokens++node125Tokens
theorem node126_source : Body node126 node126Tokens := by exact .cons _ _ _ _ node020_source node125_source

def node127 : Stmt := (.seq node019 node126)
def node127Tokens : List B20.C.Token := node019Tokens++node126Tokens
theorem node127_source : Body node127 node127Tokens := by exact .cons _ _ _ _ node019_source node126_source

def node128 : Stmt := (.seq node018 node127)
def node128Tokens : List B20.C.Token := node018Tokens++node127Tokens
theorem node128_source : Body node128 node128Tokens := by exact .cons _ _ _ _ node018_source node127_source

def node129 : Stmt := (.seq node017 node128)
def node129Tokens : List B20.C.Token := node017Tokens++node128Tokens
theorem node129_source : Body node129 node129Tokens := by exact .cons _ _ _ _ node017_source node128_source

def node130 : Stmt := (.seq node016 node129)
def node130Tokens : List B20.C.Token := node016Tokens++node129Tokens
theorem node130_source : Body node130 node130Tokens := by exact .cons _ _ _ _ node016_source node129_source

def node131 : Stmt := (.seq node003 node130)
def node131Tokens : List B20.C.Token := node003Tokens++node130Tokens
theorem node131_source : Body node131 node131Tokens := by exact .cons _ _ _ _ node003_source node130_source

def node132 : Stmt := (.seq node002 node131)
def node132Tokens : List B20.C.Token := node002Tokens++node131Tokens
theorem node132_source : Body node132 node132Tokens := by exact .cons _ _ _ _ node002_source node131_source

def node133 : Stmt := (.seq node001 node132)
def node133Tokens : List B20.C.Token := node001Tokens++node132Tokens
theorem node133_source : Body node133 node133Tokens := by exact .cons _ _ _ _ node001_source node132_source

def node134 : Stmt := (.seq node000 node133)
def node134Tokens : List B20.C.Token := node000Tokens++node133Tokens
theorem node134_source : Body node134 node134Tokens := by exact .cons _ _ _ _ node000_source node133_source

end FT1536.Source3.KeygenCodecStaticBinding
