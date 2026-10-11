import Source3.KeygenCodecGrammar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticBinding
open KeygenCodecSyntax KeygenCodecGrammar

def node000 : Stmt := (.declare [⟨"buf".toList,(.pointer .byte),none⟩])
def node000Tokens : List B20.C.Token := ["unsigned","char","*","buf",";"].map String.toList
theorem node000_source : Statement node000 node000Tokens := by exact .simple _ _ (by rfl)

def node001 : Stmt := (.declare [⟨"n".toList,.size,none⟩,⟨"u".toList,.size,none⟩])
def node001Tokens : List B20.C.Token := ["size_t","n",",","u",";"].map String.toList
theorem node001_source : Statement node001 node001Tokens := by exact .simple _ _ (by rfl)

def node002 : Stmt := (.declare [⟨"acc".toList,.u32,none⟩,⟨"mask".toList,.u32,none⟩])
def node002Tokens : List B20.C.Token := ["unsigned","acc",",","mask",";"].map String.toList
theorem node002_source : Statement node002 node002Tokens := by exact .simple _ _ (by rfl)

def node003 : Stmt := (.declare [⟨"acc_len".toList,.i32,none⟩,⟨"j".toList,.i32,none⟩])
def node003Tokens : List B20.C.Token := ["int","acc_len",",","j",";"].map String.toList
theorem node003_source : Statement node003 node003Tokens := by exact .simple _ _ (by rfl)

def node004 : Stmt := (.write (.variable "n".toList) .set (.binary .shl (.cast .size (.number .i32 1)) (.variable "logn".toList)))
def node004Tokens : List B20.C.Token := ["n","=","(","size_t",")","1","<<","logn",";"].map String.toList
theorem node004_source : Statement node004 node004Tokens := by exact .simple _ _ (by rfl)

def node005 : Stmt := (.write (.variable "j".toList) .set (.number .i32 7))
def node005Tokens : List B20.C.Token := ["j","=","7",";"].map String.toList
theorem node005_source : Statement node005 node005Tokens := by exact .simple _ _ (by rfl)

def node006 : Stmt := .skip
def node006Tokens : List B20.C.Token := []
theorem node006_source : Body node006 node006Tokens := by exact .nil

def node007 : Stmt := (.seq node005 node006)
def node007Tokens : List B20.C.Token := node005Tokens++node006Tokens
theorem node007_source : Body node007 node007Tokens := by exact .cons _ _ _ _ node005_source node006_source

def node008 : Stmt := (.seq node004 node007)
def node008Tokens : List B20.C.Token := node004Tokens++node007Tokens
theorem node008_source : Body node008 node008Tokens := by exact .cons _ _ _ _ node004_source node007_source

def node009 : Stmt := (.scope node008)
def node009Tokens : List B20.C.Token := [['{']]++node008Tokens++[['}']]
theorem node009_source : Statement node009 node009Tokens := by exact .scope _ _ node008_source

def node010 : Stmt := (.write (.variable "n".toList) .set (.binary .shl (.cast .size (.number .i32 3)) (.binary .sub (.variable "logn".toList) (.number .i32 1))))
def node010Tokens : List B20.C.Token := ["n","=","(","size_t",")","3","<<","(","logn","-","1",")",";"].map String.toList
theorem node010_source : Statement node010 node010Tokens := by exact .simple _ _ (by rfl)

def node011 : Stmt := (.write (.variable "j".toList) .set (.number .i32 8))
def node011Tokens : List B20.C.Token := ["j","=","8",";"].map String.toList
theorem node011_source : Statement node011 node011Tokens := by exact .simple _ _ (by rfl)

def node012 : Stmt := .skip
def node012Tokens : List B20.C.Token := []
theorem node012_source : Body node012 node012Tokens := by exact .nil

def node013 : Stmt := (.seq node011 node012)
def node013Tokens : List B20.C.Token := node011Tokens++node012Tokens
theorem node013_source : Body node013 node013Tokens := by exact .cons _ _ _ _ node011_source node012_source

def node014 : Stmt := (.seq node010 node013)
def node014Tokens : List B20.C.Token := node010Tokens++node013Tokens
theorem node014_source : Body node014 node014Tokens := by exact .cons _ _ _ _ node010_source node013_source

def node015 : Stmt := (.scope node014)
def node015Tokens : List B20.C.Token := [['{']]++node014Tokens++[['}']]
theorem node015_source : Statement node015 node015Tokens := by exact .scope _ _ node014_source

def guard016 : Expr := (.binary .eq (.variable "q".toList) (.number .i32 12289))
def guard016Tokens : List B20.C.Token := ["q","==","12289"].map String.toList
theorem guard016_source : guard guard016 guard016Tokens := by rfl

def node016 : Stmt := (.branch guard016 node009 node015)
def node016Tokens : List B20.C.Token := ["if".toList,['(']]++guard016Tokens++[[')']]++node009Tokens++["else".toList]++node015Tokens
theorem node016_source : Statement node016 node016Tokens := by exact .ifElse _ _ _ _ _ _ guard016_source node009_source node015_source

def node017 : Stmt := (.write (.variable "mask".toList) .set (.binary .sub (.binary .shl (.number .u32 1) (.variable "j".toList)) (.number .u32 1)))
def node017Tokens : List B20.C.Token := ["mask","=","(","1U","<<","j",")","-","1U",";"].map String.toList
theorem node017_source : Statement node017 node017Tokens := by exact .simple _ _ (by rfl)

def node018 : Stmt := (.write (.variable "buf".toList) .set (.variable "out".toList))
def node018Tokens : List B20.C.Token := ["buf","=","out",";"].map String.toList
theorem node018_source : Statement node018 node018Tokens := by exact .simple _ _ (by rfl)

def node019 : Stmt := (.write (.variable "u".toList) .set (.number .i32 0))
def node019Tokens : List B20.C.Token := ["u","=","0",";"].map String.toList
theorem node019_source : Statement node019 node019Tokens := by exact .simple _ _ (by rfl)

def node020 : Stmt := (.write (.variable "acc".toList) .set (.number .i32 0))
def node020Tokens : List B20.C.Token := ["acc","=","0",";"].map String.toList
theorem node020_source : Statement node020 node020Tokens := by exact .simple _ _ (by rfl)

def node021 : Stmt := (.write (.variable "acc_len".toList) .set (.number .i32 0))
def node021Tokens : List B20.C.Token := ["acc_len","=","0",";"].map String.toList
theorem node021_source : Statement node021 node021Tokens := by exact .simple _ _ (by rfl)

def node022 : Stmt := (.declare [⟨"w".toList,.i32,none⟩])
def node022Tokens : List B20.C.Token := ["int","w",";"].map String.toList
theorem node022_source : Statement node022 node022Tokens := by exact .simple _ _ (by rfl)

def node023 : Stmt := (.declare [⟨"lo".toList,.u32,none⟩])
def node023Tokens : List B20.C.Token := ["unsigned","lo",";"].map String.toList
theorem node023_source : Statement node023 node023Tokens := by exact .simple _ _ (by rfl)

def node024 : Stmt := (.declare [⟨"ne".toList,.i32,none⟩])
def node024Tokens : List B20.C.Token := ["int","ne",";"].map String.toList
theorem node024_source : Statement node024 node024Tokens := by exact .simple _ _ (by rfl)

def node025 : Stmt := (.write (.variable "w".toList) .set (.unary .dereference (.postInc (.variable "x".toList))))
def node025Tokens : List B20.C.Token := ["w","=","*","x","++",";"].map String.toList
theorem node025_source : Statement node025 node025Tokens := by exact .simple _ _ (by rfl)

def node026 : Stmt := (.evaluate (.postDec (.variable "n".toList)))
def node026Tokens : List B20.C.Token := ["n","-","-",";"].map String.toList
theorem node026_source : Statement node026 node026Tokens := by exact .simple _ _ (by rfl)

def node027 : Stmt := (.write (.variable "w".toList) .set (.unary .neg (.variable "w".toList)))
def node027Tokens : List B20.C.Token := ["w","=","-","w",";"].map String.toList
theorem node027_source : Statement node027 node027Tokens := by exact .simple _ _ (by rfl)

def node028 : Stmt := (.write (.variable "lo".toList) .set (.binary .shl (.number .u32 1) (.variable "j".toList)))
def node028Tokens : List B20.C.Token := ["lo","=","1U","<<","j",";"].map String.toList
theorem node028_source : Statement node028 node028Tokens := by exact .simple _ _ (by rfl)

end FT1536.Source3.KeygenCodecStaticBinding
