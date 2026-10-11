import Source3.KeygenCodecStaticBindingPart01

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticBinding
open KeygenCodecSyntax KeygenCodecGrammar

def node056 : Stmt := (.seq node054 node055)
def node056Tokens : List B20.C.Token := node054Tokens++node055Tokens
theorem node056_source : Body node056 node056Tokens := by exact .cons _ _ _ _ node054_source node055_source

def node057 : Stmt := (.seq node053 node056)
def node057Tokens : List B20.C.Token := node053Tokens++node056Tokens
theorem node057_source : Body node057 node057Tokens := by exact .cons _ _ _ _ node053_source node056_source

def node058 : Stmt := (.seq node042 node057)
def node058Tokens : List B20.C.Token := node042Tokens++node057Tokens
theorem node058_source : Body node058 node058Tokens := by exact .cons _ _ _ _ node042_source node057_source

def node059 : Stmt := (.scope node058)
def node059Tokens : List B20.C.Token := [['{']]++node058Tokens++[['}']]
theorem node059_source : Statement node059 node059Tokens := by exact .scope _ _ node058_source

def guard060 : Expr := (.binary .ge (.variable "acc_len".toList) (.number .i32 8))
def guard060Tokens : List B20.C.Token := ["acc_len",">=","8"].map String.toList
theorem guard060_source : guard guard060 guard060Tokens := by rfl

def node060 : Stmt := (.whileLoop guard060 node059)
def node060Tokens : List B20.C.Token := ["while".toList,['(']]++guard060Tokens++[[')']]++node059Tokens
theorem node060_source : Statement node060 node060Tokens := by exact .whileLoop _ _ _ _ guard060_source node059_source

def node061 : Stmt := (.write (.variable "acc".toList) .shl (.number .i32 1))
def node061Tokens : List B20.C.Token := ["acc","<<=","1",";"].map String.toList
theorem node061_source : Statement node061 node061Tokens := by exact .simple _ _ (by rfl)

def node062 : Stmt := (.write (.variable "acc".toList) .add (.binary .band (.binary .shr (.cast .u32 (.variable "ne".toList)) (.number .i32 15)) (.number .i32 1)))
def node062Tokens : List B20.C.Token := ["acc","+=","(","(","unsigned",")","ne",">>","15",")","&","1",";"].map String.toList
theorem node062_source : Statement node062 node062Tokens := by exact .simple _ _ (by rfl)

def node063 : Stmt := (.ret (.number .i32 0))
def node063Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node063_source : Statement node063 node063Tokens := by exact .simple _ _ (by rfl)

def node064 : Stmt := .skip
def node064Tokens : List B20.C.Token := []
theorem node064_source : Body node064 node064Tokens := by exact .nil

def node065 : Stmt := (.seq node063 node064)
def node065Tokens : List B20.C.Token := node063Tokens++node064Tokens
theorem node065_source : Body node065 node065Tokens := by exact .cons _ _ _ _ node063_source node064_source

def node066 : Stmt := (.scope node065)
def node066Tokens : List B20.C.Token := [['{']]++node065Tokens++[['}']]
theorem node066_source : Statement node066 node066Tokens := by exact .scope _ _ node065_source

def guard067 : Expr := (.binary .ge (.variable "u".toList) (.variable "max_out_len".toList))
def guard067Tokens : List B20.C.Token := ["u",">=","max_out_len"].map String.toList
theorem guard067_source : guard guard067 guard067Tokens := by rfl

def node067 : Stmt := (.branch guard067 node066 .skip)
def node067Tokens : List B20.C.Token := ["if".toList,['(']]++guard067Tokens++[[')']]++node066Tokens
theorem node067_source : Statement node067 node067Tokens := by exact .ifOnly _ _ _ _ guard067_source node066_source

def node068 : Stmt := (.write (.index (.variable "buf".toList) (.variable "u".toList)) .set (.cast .byte (.variable "acc".toList)))
def node068Tokens : List B20.C.Token := ["buf","[","u","]","=","(","unsigned","char",")","acc",";"].map String.toList
theorem node068_source : Statement node068 node068Tokens := by exact .simple _ _ (by rfl)

def node069 : Stmt := .skip
def node069Tokens : List B20.C.Token := []
theorem node069_source : Body node069 node069Tokens := by exact .nil

def node070 : Stmt := (.seq node068 node069)
def node070Tokens : List B20.C.Token := node068Tokens++node069Tokens
theorem node070_source : Body node070 node070Tokens := by exact .cons _ _ _ _ node068_source node069_source

def node071 : Stmt := (.seq node067 node070)
def node071Tokens : List B20.C.Token := node067Tokens++node070Tokens
theorem node071_source : Body node071 node071Tokens := by exact .cons _ _ _ _ node067_source node070_source

def node072 : Stmt := (.scope node071)
def node072Tokens : List B20.C.Token := [['{']]++node071Tokens++[['}']]
theorem node072_source : Statement node072 node072Tokens := by exact .scope _ _ node071_source

def guard073 : Expr := (.binary .ne (.variable "buf".toList) (.variable "NULL".toList))
def guard073Tokens : List B20.C.Token := ["buf","!=","NULL"].map String.toList
theorem guard073_source : guard guard073 guard073Tokens := by rfl

def node073 : Stmt := (.branch guard073 node072 .skip)
def node073Tokens : List B20.C.Token := ["if".toList,['(']]++guard073Tokens++[[')']]++node072Tokens
theorem node073_source : Statement node073 node073Tokens := by exact .ifOnly _ _ _ _ guard073_source node072_source

def node074 : Stmt := (.evaluate (.postInc (.variable "u".toList)))
def node074Tokens : List B20.C.Token := ["u","++",";"].map String.toList
theorem node074_source : Statement node074 node074Tokens := by exact .simple _ _ (by rfl)

def node075 : Stmt := (.write (.variable "acc_len".toList) .set (.number .i32 0))
def node075Tokens : List B20.C.Token := ["acc_len","=","0",";"].map String.toList
theorem node075_source : Statement node075 node075Tokens := by exact .simple _ _ (by rfl)

def node076 : Stmt := .skip
def node076Tokens : List B20.C.Token := []
theorem node076_source : Body node076 node076Tokens := by exact .nil

def node077 : Stmt := (.seq node075 node076)
def node077Tokens : List B20.C.Token := node075Tokens++node076Tokens
theorem node077_source : Body node077 node077Tokens := by exact .cons _ _ _ _ node075_source node076_source

def node078 : Stmt := (.seq node074 node077)
def node078Tokens : List B20.C.Token := node074Tokens++node077Tokens
theorem node078_source : Body node078 node078Tokens := by exact .cons _ _ _ _ node074_source node077_source

def node079 : Stmt := (.seq node073 node078)
def node079Tokens : List B20.C.Token := node073Tokens++node078Tokens
theorem node079_source : Body node079 node079Tokens := by exact .cons _ _ _ _ node073_source node078_source

def node080 : Stmt := (.scope node079)
def node080Tokens : List B20.C.Token := [['{']]++node079Tokens++[['}']]
theorem node080_source : Statement node080 node080Tokens := by exact .scope _ _ node079_source

def guard081 : Expr := (.binary .eq (.preInc (.variable "acc_len".toList)) (.number .i32 8))
def guard081Tokens : List B20.C.Token := ["++","acc_len","==","8"].map String.toList
theorem guard081_source : guard guard081 guard081Tokens := by rfl

def node081 : Stmt := (.branch guard081 node080 .skip)
def node081Tokens : List B20.C.Token := ["if".toList,['(']]++guard081Tokens++[[')']]++node080Tokens
theorem node081_source : Statement node081 node081Tokens := by exact .ifOnly _ _ _ _ guard081_source node080_source

end FT1536.Source3.KeygenCodecStaticBinding
