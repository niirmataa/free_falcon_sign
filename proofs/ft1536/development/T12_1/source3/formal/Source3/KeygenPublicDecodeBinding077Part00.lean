import Source3.KeygenDecodeGrammar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeBinding077
open KeygenDecodeSyntax KeygenDecodeGrammar

def node000 : Stmt := (.declare [⟨"buf".toList,(.pointer (.readonly .byte)),none⟩])
def node000Tokens : List B20.C.Token := ["const","unsigned","char","*","buf",";"].map String.toList
theorem node000_source : Statement node000 node000Tokens := by exact .simple _ _ (by rfl)

def node001 : Stmt := (.declare [⟨"n".toList,.size,none⟩,⟨"u".toList,.size,none⟩])
def node001Tokens : List B20.C.Token := ["size_t","n",",","u",";"].map String.toList
theorem node001_source : Statement node001 node001Tokens := by exact .simple _ _ (by rfl)

def node002 : Stmt := (.declare [⟨"acc".toList,.u32,none⟩])
def node002Tokens : List B20.C.Token := ["uint32_t","acc",";"].map String.toList
theorem node002_source : Statement node002 node002Tokens := by exact .simple _ _ (by rfl)

def node003 : Stmt := (.declare [⟨"acc_len".toList,.i32,none⟩])
def node003Tokens : List B20.C.Token := ["int","acc_len",";"].map String.toList
theorem node003_source : Statement node003 node003Tokens := by exact .simple _ _ (by rfl)

def node004 : Stmt := (.write (.variable "n".toList) .set (.binary .shl (.cast .size (.number .i32 3)) (.binary .sub (.variable "logn".toList) (.number .i32 1))))
def node004Tokens : List B20.C.Token := ["n","=","(","size_t",")","3","<<","(","logn","-","1",")",";"].map String.toList
theorem node004_source : Statement node004 node004Tokens := by exact .simple _ _ (by rfl)

def node005 : Stmt := (.write (.variable "buf".toList) .set (.variable "data".toList))
def node005Tokens : List B20.C.Token := ["buf","=","data",";"].map String.toList
theorem node005_source : Statement node005 node005Tokens := by exact .simple _ _ (by rfl)

def node006 : Stmt := (.write (.variable "u".toList) .set (.number .i32 0))
def node006Tokens : List B20.C.Token := ["u","=","0",";"].map String.toList
theorem node006_source : Statement node006 node006Tokens := by exact .simple _ _ (by rfl)

def node007 : Stmt := (.write (.variable "acc".toList) .set (.number .i32 0))
def node007Tokens : List B20.C.Token := ["acc","=","0",";"].map String.toList
theorem node007_source : Statement node007 node007Tokens := by exact .simple _ _ (by rfl)

def node008 : Stmt := (.write (.variable "acc_len".toList) .set (.number .i32 0))
def node008Tokens : List B20.C.Token := ["acc_len","=","0",";"].map String.toList
theorem node008_source : Statement node008 node008Tokens := by exact .simple _ _ (by rfl)

def node009 : Stmt := (.ret (.number .i32 0))
def node009Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node009_source : Statement node009 node009Tokens := by exact .simple _ _ (by rfl)

def node010 : Stmt := .skip
def node010Tokens : List B20.C.Token := []
theorem node010_source : Body node010 node010Tokens := by exact .nil

def node011 : Stmt := (.seq node009 node010)
def node011Tokens : List B20.C.Token := node009Tokens++node010Tokens
theorem node011_source : Body node011 node011Tokens := by exact .cons _ _ _ _ node009_source node010_source

def node012 : Stmt := (.scope node011)
def node012Tokens : List B20.C.Token := [['{']]++node011Tokens++[['}']]
theorem node012_source : Statement node012 node012Tokens := by exact .scope _ _ node011_source

def guard013 : Expr := (.binary .ge (.variable "u".toList) (.variable "len".toList))
def guard013Tokens : List B20.C.Token := ["u",">=","len"].map String.toList
theorem guard013_source : guard guard013 guard013Tokens := by rfl

def node013 : Stmt := (.branch guard013 node012 .skip)
def node013Tokens : List B20.C.Token := ["if".toList,['(']]++guard013Tokens++[[')']]++node012Tokens
theorem node013_source : Statement node013 node013Tokens := by exact .ifOnly _ _ _ _ guard013_source node012_source

def node014 : Stmt := (.write (.variable "acc".toList) .set (.binary .bor (.binary .shl (.variable "acc".toList) (.number .i32 8)) (.index (.variable "buf".toList) (.postInc (.variable "u".toList)))))
def node014Tokens : List B20.C.Token := ["acc","=","(","acc","<<","8",")","|","buf","[","u","++","]",";"].map String.toList
theorem node014_source : Statement node014 node014Tokens := by exact .simple _ _ (by rfl)

def node015 : Stmt := (.write (.variable "acc_len".toList) .add (.number .i32 8))
def node015Tokens : List B20.C.Token := ["acc_len","+=","8",";"].map String.toList
theorem node015_source : Statement node015 node015Tokens := by exact .simple _ _ (by rfl)

def node016 : Stmt := (.declare [⟨"w".toList,.u32,none⟩])
def node016Tokens : List B20.C.Token := ["uint32_t","w",";"].map String.toList
theorem node016_source : Statement node016 node016Tokens := by exact .simple _ _ (by rfl)

def node017 : Stmt := (.write (.variable "acc_len".toList) .sub (.number .i32 15))
def node017Tokens : List B20.C.Token := ["acc_len","-=","15",";"].map String.toList
theorem node017_source : Statement node017 node017Tokens := by exact .simple _ _ (by rfl)

def node018 : Stmt := (.write (.variable "w".toList) .set (.binary .shr (.variable "acc".toList) (.variable "acc_len".toList)))
def node018Tokens : List B20.C.Token := ["w","=","acc",">>","acc_len",";"].map String.toList
theorem node018_source : Statement node018 node018Tokens := by exact .simple _ _ (by rfl)

def node019 : Stmt := (.ret (.number .i32 0))
def node019Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node019_source : Statement node019 node019Tokens := by exact .simple _ _ (by rfl)

def node020 : Stmt := .skip
def node020Tokens : List B20.C.Token := []
theorem node020_source : Body node020 node020Tokens := by exact .nil

def node021 : Stmt := (.seq node019 node020)
def node021Tokens : List B20.C.Token := node019Tokens++node020Tokens
theorem node021_source : Body node021 node021Tokens := by exact .cons _ _ _ _ node019_source node020_source

def node022 : Stmt := (.scope node021)
def node022Tokens : List B20.C.Token := [['{']]++node021Tokens++[['}']]
theorem node022_source : Statement node022 node022Tokens := by exact .scope _ _ node021_source

def guard023 : Expr := (.binary .ge (.variable "w".toList) (.number .i32 18433))
def guard023Tokens : List B20.C.Token := ["w",">=","18433"].map String.toList
theorem guard023_source : guard guard023 guard023Tokens := by rfl

def node023 : Stmt := (.branch guard023 node022 .skip)
def node023Tokens : List B20.C.Token := ["if".toList,['(']]++guard023Tokens++[[')']]++node022Tokens
theorem node023_source : Statement node023 node023Tokens := by exact .ifOnly _ _ _ _ guard023_source node022_source

def node024 : Stmt := (.write (.unary .dereference (.postInc (.variable "x".toList))) .set (.cast .u16 (.variable "w".toList)))
def node024Tokens : List B20.C.Token := ["*","x","++","=","(","uint16_t",")","w",";"].map String.toList
theorem node024_source : Statement node024 node024Tokens := by exact .simple _ _ (by rfl)

def node025 : Stmt := (.evaluate (.postDec (.variable "n".toList)))
def node025Tokens : List B20.C.Token := ["n","-","-",";"].map String.toList
theorem node025_source : Statement node025 node025Tokens := by exact .simple _ _ (by rfl)

def node026 : Stmt := (.write (.variable "acc".toList) .band (.binary .sub (.binary .shl (.number .u32 1) (.variable "acc_len".toList)) (.number .u32 1)))
def node026Tokens : List B20.C.Token := ["acc","&=","(","1U","<<","acc_len",")","-","1U",";"].map String.toList
theorem node026_source : Statement node026 node026Tokens := by exact .simple _ _ (by rfl)

def node027 : Stmt := .skip
def node027Tokens : List B20.C.Token := []
theorem node027_source : Body node027 node027Tokens := by exact .nil

end FT1536.Source3.KeygenPublicDecodeBinding077
