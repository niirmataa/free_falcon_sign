import Source3.KeygenPublicEncodeBinding077Part01

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeBinding077
open KeygenCodecSyntax KeygenCodecGrammar

def node054 : Stmt := (.seq node050 node053)
def node054Tokens : List B20.C.Token := node050Tokens++node053Tokens
theorem node054_source : Body node054 node054Tokens := by exact .cons _ _ _ _ node050_source node053_source

def node055 : Stmt := (.scope node054)
def node055Tokens : List B20.C.Token := [['{']]++node054Tokens++[['}']]
theorem node055_source : Statement node055 node055Tokens := by exact .scope _ _ node054_source

def guard056 : Expr := (.binary .gt (.variable "acc_len".toList) (.number .i32 0))
def guard056Tokens : List B20.C.Token := ["acc_len",">","0"].map String.toList
theorem guard056_source : guard guard056 guard056Tokens := by rfl

def node056 : Stmt := (.branch guard056 node055 .skip)
def node056Tokens : List B20.C.Token := ["if".toList,['(']]++guard056Tokens++[[')']]++node055Tokens
theorem node056_source : Statement node056 node056Tokens := by exact .ifOnly _ _ _ _ guard056_source node055_source

def node057 : Stmt := (.ret (.variable "u".toList))
def node057Tokens : List B20.C.Token := ["return","u",";"].map String.toList
theorem node057_source : Statement node057 node057Tokens := by exact .simple _ _ (by rfl)

def node058 : Stmt := .skip
def node058Tokens : List B20.C.Token := []
theorem node058_source : Body node058 node058Tokens := by exact .nil

def node059 : Stmt := (.seq node057 node058)
def node059Tokens : List B20.C.Token := node057Tokens++node058Tokens
theorem node059_source : Body node059 node059Tokens := by exact .cons _ _ _ _ node057_source node058_source

def node060 : Stmt := (.seq node056 node059)
def node060Tokens : List B20.C.Token := node056Tokens++node059Tokens
theorem node060_source : Body node060 node060Tokens := by exact .cons _ _ _ _ node056_source node059_source

def node061 : Stmt := (.seq node039 node060)
def node061Tokens : List B20.C.Token := node039Tokens++node060Tokens
theorem node061_source : Body node061 node061Tokens := by exact .cons _ _ _ _ node039_source node060_source

def node062 : Stmt := (.seq node008 node061)
def node062Tokens : List B20.C.Token := node008Tokens++node061Tokens
theorem node062_source : Body node062 node062Tokens := by exact .cons _ _ _ _ node008_source node061_source

def node063 : Stmt := (.seq node007 node062)
def node063Tokens : List B20.C.Token := node007Tokens++node062Tokens
theorem node063_source : Body node063 node063Tokens := by exact .cons _ _ _ _ node007_source node062_source

def node064 : Stmt := (.seq node006 node063)
def node064Tokens : List B20.C.Token := node006Tokens++node063Tokens
theorem node064_source : Body node064 node064Tokens := by exact .cons _ _ _ _ node006_source node063_source

def node065 : Stmt := (.seq node005 node064)
def node065Tokens : List B20.C.Token := node005Tokens++node064Tokens
theorem node065_source : Body node065 node065Tokens := by exact .cons _ _ _ _ node005_source node064_source

def node066 : Stmt := (.seq node004 node065)
def node066Tokens : List B20.C.Token := node004Tokens++node065Tokens
theorem node066_source : Body node066 node066Tokens := by exact .cons _ _ _ _ node004_source node065_source

def node067 : Stmt := (.seq node003 node066)
def node067Tokens : List B20.C.Token := node003Tokens++node066Tokens
theorem node067_source : Body node067 node067Tokens := by exact .cons _ _ _ _ node003_source node066_source

def node068 : Stmt := (.seq node002 node067)
def node068Tokens : List B20.C.Token := node002Tokens++node067Tokens
theorem node068_source : Body node068 node068Tokens := by exact .cons _ _ _ _ node002_source node067_source

def node069 : Stmt := (.seq node001 node068)
def node069Tokens : List B20.C.Token := node001Tokens++node068Tokens
theorem node069_source : Body node069 node069Tokens := by exact .cons _ _ _ _ node001_source node068_source

def node070 : Stmt := (.seq node000 node069)
def node070Tokens : List B20.C.Token := node000Tokens++node069Tokens
theorem node070_source : Body node070 node070Tokens := by exact .cons _ _ _ _ node000_source node069_source

end FT1536.Source3.KeygenPublicEncodeBinding077
