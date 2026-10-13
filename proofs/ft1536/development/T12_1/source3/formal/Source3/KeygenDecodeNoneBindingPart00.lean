import Source3.KeygenDecodeGrammar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeNoneBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

def node000 : Stmt := (.declare [⟨"n".toList,.size,none⟩,⟨"u".toList,.size,none⟩])
def node000Tokens : List B20.C.Token := ["size_t","n",",","u",";"].map String.toList
theorem node000_source : Statement node000 node000Tokens := by exact .simple _ _ (by rfl)

def node001 : Stmt := (.declare [⟨"buf".toList,(.pointer (.readonly .byte)),none⟩])
def node001Tokens : List B20.C.Token := ["const","unsigned","char","*","buf",";"].map String.toList
theorem node001_source : Statement node001 node001Tokens := by exact .simple _ _ (by rfl)

def node002 : Stmt := (.declare [⟨"hq".toList,.u32,none⟩,⟨"tq".toList,.u32,none⟩])
def node002Tokens : List B20.C.Token := ["uint32_t","hq",",","tq",";"].map String.toList
theorem node002_source : Statement node002 node002Tokens := by exact .simple _ _ (by rfl)

def node003 : Stmt := (.write (.variable "n".toList) .set (.binary .shl (.cast .size (.number .i32 1)) (.variable "logn".toList)))
def node003Tokens : List B20.C.Token := ["n","=","(","size_t",")","1","<<","logn",";"].map String.toList
theorem node003_source : Statement node003 node003Tokens := by exact .simple _ _ (by rfl)

def node004 : Stmt := .skip
def node004Tokens : List B20.C.Token := []
theorem node004_source : Body node004 node004Tokens := by exact .nil

def node005 : Stmt := (.seq node003 node004)
def node005Tokens : List B20.C.Token := node003Tokens++node004Tokens
theorem node005_source : Body node005 node005Tokens := by exact .cons _ _ _ _ node003_source node004_source

def node006 : Stmt := (.scope node005)
def node006Tokens : List B20.C.Token := [['{']]++node005Tokens++[['}']]
theorem node006_source : Statement node006 node006Tokens := by exact .scope _ _ node005_source

def node007 : Stmt := (.write (.variable "n".toList) .set (.binary .shl (.cast .size (.number .i32 3)) (.binary .sub (.variable "logn".toList) (.number .i32 1))))
def node007Tokens : List B20.C.Token := ["n","=","(","size_t",")","3","<<","(","logn","-","1",")",";"].map String.toList
theorem node007_source : Statement node007 node007Tokens := by exact .simple _ _ (by rfl)

def node008 : Stmt := .skip
def node008Tokens : List B20.C.Token := []
theorem node008_source : Body node008 node008Tokens := by exact .nil

def node009 : Stmt := (.seq node007 node008)
def node009Tokens : List B20.C.Token := node007Tokens++node008Tokens
theorem node009_source : Body node009 node009Tokens := by exact .cons _ _ _ _ node007_source node008_source

def node010 : Stmt := (.scope node009)
def node010Tokens : List B20.C.Token := [['{']]++node009Tokens++[['}']]
theorem node010_source : Statement node010 node010Tokens := by exact .scope _ _ node009_source

def guard011 : Expr := (.binary .eq (.variable "q".toList) (.number .i32 12289))
def guard011Tokens : List B20.C.Token := ["q","==","12289"].map String.toList
theorem guard011_source : guard guard011 guard011Tokens := by rfl

def node011 : Stmt := (.branch guard011 node006 node010)
def node011Tokens : List B20.C.Token := ["if".toList,['(']]++guard011Tokens++[[')']]++node006Tokens++["else".toList]++node010Tokens
theorem node011_source : Statement node011 node011Tokens := by exact .ifElse _ _ _ _ _ _ guard011_source node006_source node010_source

def node012 : Stmt := (.ret (.number .i32 0))
def node012Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node012_source : Statement node012 node012Tokens := by exact .simple _ _ (by rfl)

def node013 : Stmt := .skip
def node013Tokens : List B20.C.Token := []
theorem node013_source : Body node013 node013Tokens := by exact .nil

def node014 : Stmt := (.seq node012 node013)
def node014Tokens : List B20.C.Token := node012Tokens++node013Tokens
theorem node014_source : Body node014 node014Tokens := by exact .cons _ _ _ _ node012_source node013_source

def node015 : Stmt := (.scope node014)
def node015Tokens : List B20.C.Token := [['{']]++node014Tokens++[['}']]
theorem node015_source : Statement node015 node015Tokens := by exact .scope _ _ node014_source

def guard016 : Expr := (.binary .lt (.variable "len".toList) (.binary .shl (.variable "n".toList) (.number .i32 1)))
def guard016Tokens : List B20.C.Token := ["len","<","(","n","<<","1",")"].map String.toList
theorem guard016_source : guard guard016 guard016Tokens := by rfl

def node016 : Stmt := (.branch guard016 node015 .skip)
def node016Tokens : List B20.C.Token := ["if".toList,['(']]++guard016Tokens++[[')']]++node015Tokens
theorem node016_source : Statement node016 node016Tokens := by exact .ifOnly _ _ _ _ guard016_source node015_source

def node017 : Stmt := (.write (.variable "hq".toList) .set (.binary .shr (.variable "q".toList) (.number .i32 1)))
def node017Tokens : List B20.C.Token := ["hq","=","q",">>","1",";"].map String.toList
theorem node017_source : Statement node017 node017Tokens := by exact .simple _ _ (by rfl)

def node018 : Stmt := (.write (.variable "tq".toList) .set (.binary .add (.binary .add (.variable "hq".toList) (.variable "q".toList)) (.number .i32 1)))
def node018Tokens : List B20.C.Token := ["tq","=","hq","+","q","+","1",";"].map String.toList
theorem node018_source : Statement node018 node018Tokens := by exact .simple _ _ (by rfl)

def node019 : Stmt := (.write (.variable "buf".toList) .set (.variable "data".toList))
def node019Tokens : List B20.C.Token := ["buf","=","data",";"].map String.toList
theorem node019_source : Statement node019 node019Tokens := by exact .simple _ _ (by rfl)

def node020 : Stmt := (.declare [⟨"w".toList,.u32,none⟩])
def node020Tokens : List B20.C.Token := ["uint32_t","w",";"].map String.toList
theorem node020_source : Statement node020 node020Tokens := by exact .simple _ _ (by rfl)

def node021 : Stmt := (.declare [⟨"y".toList,.long,none⟩])
def node021Tokens : List B20.C.Token := ["long","y",";"].map String.toList
theorem node021_source : Statement node021 node021Tokens := by exact .simple _ _ (by rfl)

def node022 : Stmt := (.write (.variable "w".toList) .set (.binary .bor (.binary .shl (.cast .u32 (.index (.variable "buf".toList) (.binary .add (.binary .shl (.variable "u".toList) (.number .i32 1)) (.number .i32 0)))) (.number .i32 8)) (.cast .u32 (.index (.variable "buf".toList) (.binary .add (.binary .shl (.variable "u".toList) (.number .i32 1)) (.number .i32 1))))))
def node022Tokens : List B20.C.Token := ["w","=","(","(","uint32_t",")","buf","[","(","u","<<","1",")","+","0","]","<<","8",")","|","(","uint32_t",")","buf","[","(","u","<<","1",")","+","1","]",";"].map String.toList
theorem node022_source : Statement node022 node022Tokens := by exact .simple _ _ (by rfl)

def node023 : Stmt := (.write (.variable "w".toList) .bor (.unary .neg (.binary .band (.variable "w".toList) (.number .i32 32768))))
def node023Tokens : List B20.C.Token := ["w","|=","-","(","w","&","0x8000",")",";"].map String.toList
theorem node023_source : Statement node023 node023Tokens := by exact .simple _ _ (by rfl)

def node024 : Stmt := (.write (.variable "w".toList) .add (.variable "q".toList))
def node024Tokens : List B20.C.Token := ["w","+=","q",";"].map String.toList
theorem node024_source : Statement node024 node024Tokens := by exact .simple _ _ (by rfl)

def node025 : Stmt := (.ret (.number .i32 0))
def node025Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node025_source : Statement node025 node025Tokens := by exact .simple _ _ (by rfl)

def node026 : Stmt := .skip
def node026Tokens : List B20.C.Token := []
theorem node026_source : Body node026 node026Tokens := by exact .nil

def node027 : Stmt := (.seq node025 node026)
def node027Tokens : List B20.C.Token := node025Tokens++node026Tokens
theorem node027_source : Body node027 node027Tokens := by exact .cons _ _ _ _ node025_source node026_source

end FT1536.Source3.KeygenDecodeNoneBinding
