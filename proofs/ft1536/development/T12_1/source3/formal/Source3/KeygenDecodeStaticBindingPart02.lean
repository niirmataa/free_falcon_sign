import Source3.KeygenDecodeStaticBindingPart01

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

def node055 : Stmt := (.branch guard055 node054 .skip)
def node055Tokens : List B20.C.Token := ["if".toList,['(']]++guard055Tokens++[[')']]++node054Tokens
theorem node055_source : Statement node055 node055Tokens := by exact .ifOnly _ _ _ _ guard055_source node054_source

def node056 : Stmt := (.evaluate (.postDec (.variable "db_len".toList)))
def node056Tokens : List B20.C.Token := ["db_len","-","-",";"].map String.toList
theorem node056_source : Statement node056 node056Tokens := by exact .simple _ _ (by rfl)

def node057 : Stmt := (.write (.variable "bit".toList) .set (.binary .band (.binary .shr (.variable "db".toList) (.variable "db_len".toList)) (.number .i32 1)))
def node057Tokens : List B20.C.Token := ["bit","=","(","db",">>","db_len",")","&","1",";"].map String.toList
theorem node057_source : Statement node057 node057Tokens := by exact .simple _ _ (by rfl)

def node058 : Stmt := .breakLoop
def node058Tokens : List B20.C.Token := ["break",";"].map String.toList
theorem node058_source : Statement node058 node058Tokens := by exact .simple _ _ (by rfl)

def node059 : Stmt := .skip
def node059Tokens : List B20.C.Token := []
theorem node059_source : Body node059 node059Tokens := by exact .nil

def node060 : Stmt := (.seq node058 node059)
def node060Tokens : List B20.C.Token := node058Tokens++node059Tokens
theorem node060_source : Body node060 node060Tokens := by exact .cons _ _ _ _ node058_source node059_source

def node061 : Stmt := (.scope node060)
def node061Tokens : List B20.C.Token := [['{']]++node060Tokens++[['}']]
theorem node061_source : Statement node061 node061Tokens := by exact .scope _ _ node060_source

def guard062 : Expr := (.variable "bit".toList)
def guard062Tokens : List B20.C.Token := ["bit"].map String.toList
theorem guard062_source : guard guard062 guard062Tokens := by rfl

def node062 : Stmt := (.branch guard062 node061 .skip)
def node062Tokens : List B20.C.Token := ["if".toList,['(']]++guard062Tokens++[[')']]++node061Tokens
theorem node062_source : Statement node062 node062Tokens := by exact .ifOnly _ _ _ _ guard062_source node061_source

def node063 : Stmt := .skip
def node063Tokens : List B20.C.Token := []
theorem node063_source : Body node063 node063Tokens := by exact .nil

def node064 : Stmt := (.seq node062 node063)
def node064Tokens : List B20.C.Token := node062Tokens++node063Tokens
theorem node064_source : Body node064 node064Tokens := by exact .cons _ _ _ _ node062_source node063_source

def node065 : Stmt := (.seq node057 node064)
def node065Tokens : List B20.C.Token := node057Tokens++node064Tokens
theorem node065_source : Body node065 node065Tokens := by exact .cons _ _ _ _ node057_source node064_source

def node066 : Stmt := (.seq node056 node065)
def node066Tokens : List B20.C.Token := node056Tokens++node065Tokens
theorem node066_source : Body node066 node066Tokens := by exact .cons _ _ _ _ node056_source node065_source

def node067 : Stmt := (.seq node055 node066)
def node067Tokens : List B20.C.Token := node055Tokens++node066Tokens
theorem node067_source : Body node067 node067Tokens := by exact .cons _ _ _ _ node055_source node066_source

def node068 : Stmt := (.seq node042 node067)
def node068Tokens : List B20.C.Token := node042Tokens++node067Tokens
theorem node068_source : Body node068 node068Tokens := by exact .cons _ _ _ _ node042_source node067_source

def node069 : Stmt := (.scope node068)
def node069Tokens : List B20.C.Token := [['{']]++node068Tokens++[['}']]
theorem node069_source : Statement node069 node069Tokens := by exact .scope _ _ node068_source

def loop070Init : Stmt := (.write (.variable "ne".toList) .set (.number .i32 0))
def loop070Update : Stmt := (.evaluate (.postInc (.variable "ne".toList)))
def loop070Test : Option Expr := none
def loop070First : List B20.C.Token := ["ne","=","0"].map String.toList
def loop070Middle : List B20.C.Token := [].map String.toList
def loop070Last : List B20.C.Token := ["ne","++"].map String.toList
theorem loop070_initial : initialClause loop070Init loop070First := by rfl
theorem loop070_increment : incrementClause loop070Update loop070Last := by rfl
theorem loop070_condition : Test loop070Test loop070Middle := by exact .absent

def node070 : Stmt := (.loop loop070Init loop070Test loop070Update node069)
def node070Tokens : List B20.C.Token := ["for".toList,['(']]++loop070First++[[';']]++loop070Middle++[[';']]++loop070Last++[[')']]++node069Tokens
theorem node070_source : Statement node070 node070Tokens := by exact .loop _ _ _ _ _ _ _ _ loop070_initial loop070_condition loop070_increment node069_source

def node071 : Stmt := (.ret (.number .i32 0))
def node071Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node071_source : Statement node071 node071Tokens := by exact .simple _ _ (by rfl)

def node072 : Stmt := .skip
def node072Tokens : List B20.C.Token := []
theorem node072_source : Body node072 node072Tokens := by exact .nil

def node073 : Stmt := (.seq node071 node072)
def node073Tokens : List B20.C.Token := node071Tokens++node072Tokens
theorem node073_source : Body node073 node073Tokens := by exact .cons _ _ _ _ node071_source node072_source

def node074 : Stmt := (.scope node073)
def node074Tokens : List B20.C.Token := [['{']]++node073Tokens++[['}']]
theorem node074_source : Statement node074 node074Tokens := by exact .scope _ _ node073_source

def guard075 : Expr := (.binary .gt (.variable "ne".toList) (.number .i32 255))
def guard075Tokens : List B20.C.Token := ["ne",">","255"].map String.toList
theorem guard075_source : guard guard075 guard075Tokens := by rfl

def node075 : Stmt := (.branch guard075 node074 .skip)
def node075Tokens : List B20.C.Token := ["if".toList,['(']]++guard075Tokens++[[')']]++node074Tokens
theorem node075_source : Statement node075 node075Tokens := by exact .ifOnly _ _ _ _ guard075_source node074_source

def node076 : Stmt := (.write (.variable "lo".toList) .add (.binary .shl (.variable "ne".toList) (.variable "j".toList)))
def node076Tokens : List B20.C.Token := ["lo","+=","(","ne","<<","j",")",";"].map String.toList
theorem node076_source : Statement node076 node076Tokens := by exact .simple _ _ (by rfl)

def node077 : Stmt := (.write (.index (.variable "x".toList) (.variable "u".toList)) .set (.unary .neg (.cast .i16 (.variable "lo".toList))))
def node077Tokens : List B20.C.Token := ["x","[","u","]","=","-","(","int16_t",")","lo",";"].map String.toList
theorem node077_source : Statement node077 node077Tokens := by exact .simple _ _ (by rfl)

def node078 : Stmt := .skip
def node078Tokens : List B20.C.Token := []
theorem node078_source : Body node078 node078Tokens := by exact .nil

def node079 : Stmt := (.seq node077 node078)
def node079Tokens : List B20.C.Token := node077Tokens++node078Tokens
theorem node079_source : Body node079 node079Tokens := by exact .cons _ _ _ _ node077_source node078_source

def node080 : Stmt := (.scope node079)
def node080Tokens : List B20.C.Token := [['{']]++node079Tokens++[['}']]
end FT1536.Source3.KeygenDecodeStaticBinding
