import Source3.KeygenCodecStaticBindingPart00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticBinding
open KeygenCodecSyntax KeygenCodecGrammar

def node029 : Stmt := .skip
def node029Tokens : List B20.C.Token := []
theorem node029_source : Body node029 node029Tokens := by exact .nil

def node030 : Stmt := (.seq node028 node029)
def node030Tokens : List B20.C.Token := node028Tokens++node029Tokens
theorem node030_source : Body node030 node030Tokens := by exact .cons _ _ _ _ node028_source node029_source

def node031 : Stmt := (.seq node027 node030)
def node031Tokens : List B20.C.Token := node027Tokens++node030Tokens
theorem node031_source : Body node031 node031Tokens := by exact .cons _ _ _ _ node027_source node030_source

def node032 : Stmt := (.scope node031)
def node032Tokens : List B20.C.Token := [['{']]++node031Tokens++[['}']]
theorem node032_source : Statement node032 node032Tokens := by exact .scope _ _ node031_source

def node033 : Stmt := (.write (.variable "lo".toList) .set (.number .i32 0))
def node033Tokens : List B20.C.Token := ["lo","=","0",";"].map String.toList
theorem node033_source : Statement node033 node033Tokens := by exact .simple _ _ (by rfl)

def node034 : Stmt := .skip
def node034Tokens : List B20.C.Token := []
theorem node034_source : Body node034 node034Tokens := by exact .nil

def node035 : Stmt := (.seq node033 node034)
def node035Tokens : List B20.C.Token := node033Tokens++node034Tokens
theorem node035_source : Body node035 node035Tokens := by exact .cons _ _ _ _ node033_source node034_source

def node036 : Stmt := (.scope node035)
def node036Tokens : List B20.C.Token := [['{']]++node035Tokens++[['}']]
theorem node036_source : Statement node036 node036Tokens := by exact .scope _ _ node035_source

def guard037 : Expr := (.binary .lt (.variable "w".toList) (.number .i32 0))
def guard037Tokens : List B20.C.Token := ["w","<","0"].map String.toList
theorem guard037_source : guard guard037 guard037Tokens := by rfl

def node037 : Stmt := (.branch guard037 node032 node036)
def node037Tokens : List B20.C.Token := ["if".toList,['(']]++guard037Tokens++[[')']]++node032Tokens++["else".toList]++node036Tokens
theorem node037_source : Statement node037 node037Tokens := by exact .ifElse _ _ _ _ _ _ guard037_source node032_source node036_source

def node038 : Stmt := (.write (.variable "lo".toList) .bor (.binary .band (.variable "w".toList) (.variable "mask".toList)))
def node038Tokens : List B20.C.Token := ["lo","|=","w","&","mask",";"].map String.toList
theorem node038_source : Statement node038 node038Tokens := by exact .simple _ _ (by rfl)

def node039 : Stmt := (.write (.variable "ne".toList) .set (.binary .shr (.variable "w".toList) (.variable "j".toList)))
def node039Tokens : List B20.C.Token := ["ne","=","w",">>","j",";"].map String.toList
theorem node039_source : Statement node039 node039Tokens := by exact .simple _ _ (by rfl)

def node040 : Stmt := (.write (.variable "acc".toList) .set (.binary .bor (.binary .shl (.variable "acc".toList) (.binary .add (.variable "j".toList) (.number .i32 1))) (.variable "lo".toList)))
def node040Tokens : List B20.C.Token := ["acc","=","(","acc","<<","(","j","+","1",")",")","|","lo",";"].map String.toList
theorem node040_source : Statement node040 node040Tokens := by exact .simple _ _ (by rfl)

def node041 : Stmt := (.write (.variable "acc_len".toList) .add (.binary .add (.variable "j".toList) (.number .i32 1)))
def node041Tokens : List B20.C.Token := ["acc_len","+=","j","+","1",";"].map String.toList
theorem node041_source : Statement node041 node041Tokens := by exact .simple _ _ (by rfl)

def node042 : Stmt := (.write (.variable "acc_len".toList) .sub (.number .i32 8))
def node042Tokens : List B20.C.Token := ["acc_len","-=","8",";"].map String.toList
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

def guard047 : Expr := (.binary .ge (.variable "u".toList) (.variable "max_out_len".toList))
def guard047Tokens : List B20.C.Token := ["u",">=","max_out_len"].map String.toList
theorem guard047_source : guard guard047 guard047Tokens := by rfl

def node047 : Stmt := (.branch guard047 node046 .skip)
def node047Tokens : List B20.C.Token := ["if".toList,['(']]++guard047Tokens++[[')']]++node046Tokens
theorem node047_source : Statement node047 node047Tokens := by exact .ifOnly _ _ _ _ guard047_source node046_source

def node048 : Stmt := (.write (.index (.variable "buf".toList) (.variable "u".toList)) .set (.cast .byte (.binary .shr (.variable "acc".toList) (.variable "acc_len".toList))))
def node048Tokens : List B20.C.Token := ["buf","[","u","]","=","(","unsigned","char",")","(","acc",">>","acc_len",")",";"].map String.toList
theorem node048_source : Statement node048 node048Tokens := by exact .simple _ _ (by rfl)

def node049 : Stmt := .skip
def node049Tokens : List B20.C.Token := []
theorem node049_source : Body node049 node049Tokens := by exact .nil

def node050 : Stmt := (.seq node048 node049)
def node050Tokens : List B20.C.Token := node048Tokens++node049Tokens
theorem node050_source : Body node050 node050Tokens := by exact .cons _ _ _ _ node048_source node049_source

def node051 : Stmt := (.seq node047 node050)
def node051Tokens : List B20.C.Token := node047Tokens++node050Tokens
theorem node051_source : Body node051 node051Tokens := by exact .cons _ _ _ _ node047_source node050_source

def node052 : Stmt := (.scope node051)
def node052Tokens : List B20.C.Token := [['{']]++node051Tokens++[['}']]
theorem node052_source : Statement node052 node052Tokens := by exact .scope _ _ node051_source

def guard053 : Expr := (.binary .ne (.variable "buf".toList) (.variable "NULL".toList))
def guard053Tokens : List B20.C.Token := ["buf","!=","NULL"].map String.toList
theorem guard053_source : guard guard053 guard053Tokens := by rfl

def node053 : Stmt := (.branch guard053 node052 .skip)
def node053Tokens : List B20.C.Token := ["if".toList,['(']]++guard053Tokens++[[')']]++node052Tokens
theorem node053_source : Statement node053 node053Tokens := by exact .ifOnly _ _ _ _ guard053_source node052_source

def node054 : Stmt := (.evaluate (.postInc (.variable "u".toList)))
def node054Tokens : List B20.C.Token := ["u","++",";"].map String.toList
theorem node054_source : Statement node054 node054Tokens := by exact .simple _ _ (by rfl)

def node055 : Stmt := .skip
def node055Tokens : List B20.C.Token := []
theorem node055_source : Body node055 node055Tokens := by exact .nil

end FT1536.Source3.KeygenCodecStaticBinding
