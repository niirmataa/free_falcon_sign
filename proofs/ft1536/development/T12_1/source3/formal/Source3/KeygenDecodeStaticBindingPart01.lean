import Source3.KeygenDecodeStaticBindingPart00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

def node029 : Stmt := (.scope node028)
def node029Tokens : List B20.C.Token := [['{']]++node028Tokens++[['}']]
theorem node029_source : Statement node029 node029Tokens := by exact .scope _ _ node028_source

def guard030 : Expr := (.binary .ge (.variable "v".toList) (.variable "len".toList))
def guard030Tokens : List B20.C.Token := ["v",">=","len"].map String.toList
theorem guard030_source : guard guard030 guard030Tokens := by rfl

def node030 : Stmt := (.branch guard030 node029 .skip)
def node030Tokens : List B20.C.Token := ["if".toList,['(']]++guard030Tokens++[[')']]++node029Tokens
theorem node030_source : Statement node030 node030Tokens := by exact .ifOnly _ _ _ _ guard030_source node029_source

def node031 : Stmt := (.write (.variable "db".toList) .set (.binary .add (.binary .shl (.variable "db".toList) (.number .i32 8)) (.index (.variable "buf".toList) (.postInc (.variable "v".toList)))))
def node031Tokens : List B20.C.Token := ["db","=","(","db","<<","8",")","+","buf","[","v","++","]",";"].map String.toList
theorem node031_source : Statement node031 node031Tokens := by exact .simple _ _ (by rfl)

def node032 : Stmt := (.write (.variable "db_len".toList) .add (.number .i32 8))
def node032Tokens : List B20.C.Token := ["db_len","+=","8",";"].map String.toList
theorem node032_source : Statement node032 node032Tokens := by exact .simple _ _ (by rfl)

def node033 : Stmt := .skip
def node033Tokens : List B20.C.Token := []
theorem node033_source : Body node033 node033Tokens := by exact .nil

def node034 : Stmt := (.seq node032 node033)
def node034Tokens : List B20.C.Token := node032Tokens++node033Tokens
theorem node034_source : Body node034 node034Tokens := by exact .cons _ _ _ _ node032_source node033_source

def node035 : Stmt := (.seq node031 node034)
def node035Tokens : List B20.C.Token := node031Tokens++node034Tokens
theorem node035_source : Body node035 node035Tokens := by exact .cons _ _ _ _ node031_source node034_source

def node036 : Stmt := (.seq node030 node035)
def node036Tokens : List B20.C.Token := node030Tokens++node035Tokens
theorem node036_source : Body node036 node036Tokens := by exact .cons _ _ _ _ node030_source node035_source

def node037 : Stmt := (.scope node036)
def node037Tokens : List B20.C.Token := [['{']]++node036Tokens++[['}']]
theorem node037_source : Statement node037 node037Tokens := by exact .scope _ _ node036_source

def guard038 : Expr := (.binary .le (.variable "db_len".toList) (.variable "j".toList))
def guard038Tokens : List B20.C.Token := ["db_len","<=","j"].map String.toList
theorem guard038_source : guard guard038 guard038Tokens := by rfl

def node038 : Stmt := (.whileLoop guard038 node037)
def node038Tokens : List B20.C.Token := ["while".toList,['(']]++guard038Tokens++[[')']]++node037Tokens
theorem node038_source : Statement node038 node038Tokens := by exact .whileLoop _ _ _ _ guard038_source node037_source

def node039 : Stmt := (.write (.variable "sign".toList) .set (.binary .band (.binary .shr (.variable "db".toList) (.binary .sub (.variable "db_len".toList) (.number .i32 1))) (.number .i32 1)))
def node039Tokens : List B20.C.Token := ["sign","=","(","db",">>","(","db_len","-","1",")",")","&","1",";"].map String.toList
theorem node039_source : Statement node039 node039Tokens := by exact .simple _ _ (by rfl)

def node040 : Stmt := (.write (.variable "db_len".toList) .sub (.binary .add (.variable "j".toList) (.number .i32 1)))
def node040Tokens : List B20.C.Token := ["db_len","-=","j","+","1",";"].map String.toList
theorem node040_source : Statement node040 node040Tokens := by exact .simple _ _ (by rfl)

def node041 : Stmt := (.write (.variable "lo".toList) .set (.binary .band (.binary .shr (.variable "db".toList) (.variable "db_len".toList)) (.variable "mask".toList)))
def node041Tokens : List B20.C.Token := ["lo","=","(","db",">>","db_len",")","&","mask",";"].map String.toList
theorem node041_source : Statement node041 node041Tokens := by exact .simple _ _ (by rfl)

def node042 : Stmt := (.declare [⟨"bit".toList,.u32,none⟩])
def node042Tokens : List B20.C.Token := ["unsigned","bit",";"].map String.toList
theorem node042_source : Statement node042 node042Tokens := by exact .simple _ _ (by rfl)

def node043 : Stmt := (.ret (.number .i32 0))
def node043Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node043_source : Statement node043 node043Tokens := by exact .simple _ _ (by rfl)

def node044 : Stmt := .skip
def node044Tokens : List B20.C.Token := []
theorem node044_source : Body node044 node044Tokens := by exact .nil

def node045 : Stmt := (.seq node043 node044)
def node045Tokens : List B20.C.Token := node043Tokens++node044Tokens
theorem node045_source : Body node045 node045Tokens := by exact .cons _ _ _ _ node043_source node044_source

def node046 : Stmt := (.scope node045)
def node046Tokens : List B20.C.Token := [['{']]++node045Tokens++[['}']]
theorem node046_source : Statement node046 node046Tokens := by exact .scope _ _ node045_source

def guard047 : Expr := (.binary .ge (.variable "v".toList) (.variable "len".toList))
def guard047Tokens : List B20.C.Token := ["v",">=","len"].map String.toList
theorem guard047_source : guard guard047 guard047Tokens := by rfl

def node047 : Stmt := (.branch guard047 node046 .skip)
def node047Tokens : List B20.C.Token := ["if".toList,['(']]++guard047Tokens++[[')']]++node046Tokens
theorem node047_source : Statement node047 node047Tokens := by exact .ifOnly _ _ _ _ guard047_source node046_source

def node048 : Stmt := (.write (.variable "db".toList) .set (.index (.variable "buf".toList) (.postInc (.variable "v".toList))))
def node048Tokens : List B20.C.Token := ["db","=","buf","[","v","++","]",";"].map String.toList
theorem node048_source : Statement node048 node048Tokens := by exact .simple _ _ (by rfl)

def node049 : Stmt := (.write (.variable "db_len".toList) .set (.number .i32 8))
def node049Tokens : List B20.C.Token := ["db_len","=","8",";"].map String.toList
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

def node053 : Stmt := (.seq node047 node052)
def node053Tokens : List B20.C.Token := node047Tokens++node052Tokens
theorem node053_source : Body node053 node053Tokens := by exact .cons _ _ _ _ node047_source node052_source

def node054 : Stmt := (.scope node053)
def node054Tokens : List B20.C.Token := [['{']]++node053Tokens++[['}']]
theorem node054_source : Statement node054 node054Tokens := by exact .scope _ _ node053_source

def guard055 : Expr := (.binary .eq (.variable "db_len".toList) (.number .i32 0))
def guard055Tokens : List B20.C.Token := ["db_len","==","0"].map String.toList
theorem guard055_source : guard guard055 guard055Tokens := by rfl

end FT1536.Source3.KeygenDecodeStaticBinding
