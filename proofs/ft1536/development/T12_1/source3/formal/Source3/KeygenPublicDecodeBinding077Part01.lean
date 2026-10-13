import Source3.KeygenPublicDecodeBinding077Part00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeBinding077
open KeygenDecodeSyntax KeygenDecodeGrammar

def node028 : Stmt := (.seq node026 node027)
def node028Tokens : List B20.C.Token := node026Tokens++node027Tokens
theorem node028_source : Body node028 node028Tokens := by exact .cons _ _ _ _ node026_source node027_source

def node029 : Stmt := (.seq node025 node028)
def node029Tokens : List B20.C.Token := node025Tokens++node028Tokens
theorem node029_source : Body node029 node029Tokens := by exact .cons _ _ _ _ node025_source node028_source

def node030 : Stmt := (.seq node024 node029)
def node030Tokens : List B20.C.Token := node024Tokens++node029Tokens
theorem node030_source : Body node030 node030Tokens := by exact .cons _ _ _ _ node024_source node029_source

def node031 : Stmt := (.seq node023 node030)
def node031Tokens : List B20.C.Token := node023Tokens++node030Tokens
theorem node031_source : Body node031 node031Tokens := by exact .cons _ _ _ _ node023_source node030_source

def node032 : Stmt := (.seq node018 node031)
def node032Tokens : List B20.C.Token := node018Tokens++node031Tokens
theorem node032_source : Body node032 node032Tokens := by exact .cons _ _ _ _ node018_source node031_source

def node033 : Stmt := (.seq node017 node032)
def node033Tokens : List B20.C.Token := node017Tokens++node032Tokens
theorem node033_source : Body node033 node033Tokens := by exact .cons _ _ _ _ node017_source node032_source

def node034 : Stmt := (.seq node016 node033)
def node034Tokens : List B20.C.Token := node016Tokens++node033Tokens
theorem node034_source : Body node034 node034Tokens := by exact .cons _ _ _ _ node016_source node033_source

def node035 : Stmt := (.scope node034)
def node035Tokens : List B20.C.Token := [['{']]++node034Tokens++[['}']]
theorem node035_source : Statement node035 node035Tokens := by exact .scope _ _ node034_source

def guard036 : Expr := (.binary .ge (.variable "acc_len".toList) (.number .i32 15))
def guard036Tokens : List B20.C.Token := ["acc_len",">=","15"].map String.toList
theorem guard036_source : guard guard036 guard036Tokens := by rfl

def node036 : Stmt := (.branch guard036 node035 .skip)
def node036Tokens : List B20.C.Token := ["if".toList,['(']]++guard036Tokens++[[')']]++node035Tokens
theorem node036_source : Statement node036 node036Tokens := by exact .ifOnly _ _ _ _ guard036_source node035_source

def node037 : Stmt := .skip
def node037Tokens : List B20.C.Token := []
theorem node037_source : Body node037 node037Tokens := by exact .nil

def node038 : Stmt := (.seq node036 node037)
def node038Tokens : List B20.C.Token := node036Tokens++node037Tokens
theorem node038_source : Body node038 node038Tokens := by exact .cons _ _ _ _ node036_source node037_source

def node039 : Stmt := (.seq node015 node038)
def node039Tokens : List B20.C.Token := node015Tokens++node038Tokens
theorem node039_source : Body node039 node039Tokens := by exact .cons _ _ _ _ node015_source node038_source

def node040 : Stmt := (.seq node014 node039)
def node040Tokens : List B20.C.Token := node014Tokens++node039Tokens
theorem node040_source : Body node040 node040Tokens := by exact .cons _ _ _ _ node014_source node039_source

def node041 : Stmt := (.seq node013 node040)
def node041Tokens : List B20.C.Token := node013Tokens++node040Tokens
theorem node041_source : Body node041 node041Tokens := by exact .cons _ _ _ _ node013_source node040_source

def node042 : Stmt := (.scope node041)
def node042Tokens : List B20.C.Token := [['{']]++node041Tokens++[['}']]
theorem node042_source : Statement node042 node042Tokens := by exact .scope _ _ node041_source

def guard043 : Expr := (.binary .gt (.variable "n".toList) (.number .i32 0))
def guard043Tokens : List B20.C.Token := ["n",">","0"].map String.toList
theorem guard043_source : guard guard043 guard043Tokens := by rfl

def node043 : Stmt := (.whileLoop guard043 node042)
def node043Tokens : List B20.C.Token := ["while".toList,['(']]++guard043Tokens++[[')']]++node042Tokens
theorem node043_source : Statement node043 node043Tokens := by exact .whileLoop _ _ _ _ guard043_source node042_source

def node044 : Stmt := (.ret (.number .i32 0))
def node044Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node044_source : Statement node044 node044Tokens := by exact .simple _ _ (by rfl)

def node045 : Stmt := .skip
def node045Tokens : List B20.C.Token := []
theorem node045_source : Body node045 node045Tokens := by exact .nil

def node046 : Stmt := (.seq node044 node045)
def node046Tokens : List B20.C.Token := node044Tokens++node045Tokens
theorem node046_source : Body node046 node046Tokens := by exact .cons _ _ _ _ node044_source node045_source

def node047 : Stmt := (.scope node046)
def node047Tokens : List B20.C.Token := [['{']]++node046Tokens++[['}']]
theorem node047_source : Statement node047 node047Tokens := by exact .scope _ _ node046_source

def guard048 : Expr := (.binary .ne (.variable "acc".toList) (.number .i32 0))
def guard048Tokens : List B20.C.Token := ["acc","!=","0"].map String.toList
theorem guard048_source : guard guard048 guard048Tokens := by rfl

def node048 : Stmt := (.branch guard048 node047 .skip)
def node048Tokens : List B20.C.Token := ["if".toList,['(']]++guard048Tokens++[[')']]++node047Tokens
theorem node048_source : Statement node048 node048Tokens := by exact .ifOnly _ _ _ _ guard048_source node047_source

def node049 : Stmt := (.ret (.variable "len".toList))
def node049Tokens : List B20.C.Token := ["return","len",";"].map String.toList
theorem node049_source : Statement node049 node049Tokens := by exact .simple _ _ (by rfl)

def node050 : Stmt := .skip
def node050Tokens : List B20.C.Token := []
theorem node050_source : Body node050 node050Tokens := by exact .nil

def node051 : Stmt := (.seq node049 node050)
def node051Tokens : List B20.C.Token := node049Tokens++node050Tokens
theorem node051_source : Body node051 node051Tokens := by exact .cons _ _ _ _ node049_source node050_source

def node052 : Stmt := (.seq node048 node051)
def node052Tokens : List B20.C.Token := node048Tokens++node051Tokens
theorem node052_source : Body node052 node052Tokens := by exact .cons _ _ _ _ node048_source node051_source

def node053 : Stmt := (.seq node043 node052)
def node053Tokens : List B20.C.Token := node043Tokens++node052Tokens
theorem node053_source : Body node053 node053Tokens := by exact .cons _ _ _ _ node043_source node052_source

def node054 : Stmt := (.seq node008 node053)
def node054Tokens : List B20.C.Token := node008Tokens++node053Tokens
theorem node054_source : Body node054 node054Tokens := by exact .cons _ _ _ _ node008_source node053_source

end FT1536.Source3.KeygenPublicDecodeBinding077
