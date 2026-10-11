import Source3.KeygenCodecGrammar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNoneBinding
open KeygenCodecSyntax KeygenCodecGrammar

def node000 : Stmt := (.declare [⟨"len".toList,.size,none⟩,⟨"u".toList,.size,none⟩])
def node000Tokens : List B20.C.Token := ["size_t","len",",","u",";"].map String.toList
theorem node000_source : Statement node000 node000Tokens := by exact .simple _ _ (by rfl)

def node001 : Stmt := (.declare [⟨"buf".toList,(.pointer .byte),none⟩])
def node001Tokens : List B20.C.Token := ["unsigned","char","*","buf",";"].map String.toList
theorem node001_source : Statement node001 node001Tokens := by exact .simple _ _ (by rfl)

def node002 : Stmt := (.write (.variable "len".toList) .set (.binary .shl (.cast .size (.number .i32 2)) (.variable "logn".toList)))
def node002Tokens : List B20.C.Token := ["len","=","(","size_t",")","2","<<","logn",";"].map String.toList
theorem node002_source : Statement node002 node002Tokens := by exact .simple _ _ (by rfl)

def node003 : Stmt := .skip
def node003Tokens : List B20.C.Token := []
theorem node003_source : Body node003 node003Tokens := by exact .nil

def node004 : Stmt := (.seq node002 node003)
def node004Tokens : List B20.C.Token := node002Tokens++node003Tokens
theorem node004_source : Body node004 node004Tokens := by exact .cons _ _ _ _ node002_source node003_source

def node005 : Stmt := (.scope node004)
def node005Tokens : List B20.C.Token := [['{']]++node004Tokens++[['}']]
theorem node005_source : Statement node005 node005Tokens := by exact .scope _ _ node004_source

def node006 : Stmt := (.write (.variable "len".toList) .set (.binary .shl (.cast .size (.number .i32 3)) (.variable "logn".toList)))
def node006Tokens : List B20.C.Token := ["len","=","(","size_t",")","3","<<","logn",";"].map String.toList
theorem node006_source : Statement node006 node006Tokens := by exact .simple _ _ (by rfl)

def node007 : Stmt := .skip
def node007Tokens : List B20.C.Token := []
theorem node007_source : Body node007 node007Tokens := by exact .nil

def node008 : Stmt := (.seq node006 node007)
def node008Tokens : List B20.C.Token := node006Tokens++node007Tokens
theorem node008_source : Body node008 node008Tokens := by exact .cons _ _ _ _ node006_source node007_source

def node009 : Stmt := (.scope node008)
def node009Tokens : List B20.C.Token := [['{']]++node008Tokens++[['}']]
theorem node009_source : Statement node009 node009Tokens := by exact .scope _ _ node008_source

def guard010 : Expr := (.binary .eq (.variable "q".toList) (.number .i32 12289))
def guard010Tokens : List B20.C.Token := ["q","==","12289"].map String.toList
theorem guard010_source : guard guard010 guard010Tokens := by rfl

def node010 : Stmt := (.branch guard010 node005 node009)
def node010Tokens : List B20.C.Token := ["if".toList,['(']]++guard010Tokens++[[')']]++node005Tokens++["else".toList]++node009Tokens
theorem node010_source : Statement node010 node010Tokens := by exact .ifElse _ _ _ _ _ _ guard010_source node005_source node009_source

def node011 : Stmt := (.ret (.variable "len".toList))
def node011Tokens : List B20.C.Token := ["return","len",";"].map String.toList
theorem node011_source : Statement node011 node011Tokens := by exact .simple _ _ (by rfl)

def node012 : Stmt := .skip
def node012Tokens : List B20.C.Token := []
theorem node012_source : Body node012 node012Tokens := by exact .nil

def node013 : Stmt := (.seq node011 node012)
def node013Tokens : List B20.C.Token := node011Tokens++node012Tokens
theorem node013_source : Body node013 node013Tokens := by exact .cons _ _ _ _ node011_source node012_source

def node014 : Stmt := (.scope node013)
def node014Tokens : List B20.C.Token := [['{']]++node013Tokens++[['}']]
theorem node014_source : Statement node014 node014Tokens := by exact .scope _ _ node013_source

def guard015 : Expr := (.binary .eq (.variable "out".toList) (.variable "NULL".toList))
def guard015Tokens : List B20.C.Token := ["out","==","NULL"].map String.toList
theorem guard015_source : guard guard015 guard015Tokens := by rfl

def node015 : Stmt := (.branch guard015 node014 .skip)
def node015Tokens : List B20.C.Token := ["if".toList,['(']]++guard015Tokens++[[')']]++node014Tokens
theorem node015_source : Statement node015 node015Tokens := by exact .ifOnly _ _ _ _ guard015_source node014_source

def node016 : Stmt := (.ret (.number .i32 0))
def node016Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node016_source : Statement node016 node016Tokens := by exact .simple _ _ (by rfl)

def node017 : Stmt := .skip
def node017Tokens : List B20.C.Token := []
theorem node017_source : Body node017 node017Tokens := by exact .nil

def node018 : Stmt := (.seq node016 node017)
def node018Tokens : List B20.C.Token := node016Tokens++node017Tokens
theorem node018_source : Body node018 node018Tokens := by exact .cons _ _ _ _ node016_source node017_source

def node019 : Stmt := (.scope node018)
def node019Tokens : List B20.C.Token := [['{']]++node018Tokens++[['}']]
theorem node019_source : Statement node019 node019Tokens := by exact .scope _ _ node018_source

def guard020 : Expr := (.binary .lt (.variable "max_out_len".toList) (.variable "len".toList))
def guard020Tokens : List B20.C.Token := ["max_out_len","<","len"].map String.toList
theorem guard020_source : guard guard020 guard020Tokens := by rfl

def node020 : Stmt := (.branch guard020 node019 .skip)
def node020Tokens : List B20.C.Token := ["if".toList,['(']]++guard020Tokens++[[')']]++node019Tokens
theorem node020_source : Statement node020 node020Tokens := by exact .ifOnly _ _ _ _ guard020_source node019_source

def node021 : Stmt := (.write (.variable "buf".toList) .set (.variable "out".toList))
def node021Tokens : List B20.C.Token := ["buf","=","out",";"].map String.toList
theorem node021_source : Statement node021 node021Tokens := by exact .simple _ _ (by rfl)

def node022 : Stmt := (.declare [⟨"w".toList,.u32,none⟩])
def node022Tokens : List B20.C.Token := ["unsigned","w",";"].map String.toList
theorem node022_source : Statement node022 node022Tokens := by exact .simple _ _ (by rfl)

def node023 : Stmt := (.write (.variable "w".toList) .set (.unary .dereference (.postInc (.variable "x".toList))))
def node023Tokens : List B20.C.Token := ["w","=","*","x","++",";"].map String.toList
theorem node023_source : Statement node023 node023Tokens := by exact .simple _ _ (by rfl)

def node024 : Stmt := (.write (.index (.variable "buf".toList) (.binary .add (.variable "u".toList) (.number .i32 0))) .set (.cast .byte (.binary .shr (.variable "w".toList) (.number .i32 8))))
def node024Tokens : List B20.C.Token := ["buf","[","u","+","0","]","=","(","unsigned","char",")","(","w",">>","8",")",";"].map String.toList
theorem node024_source : Statement node024 node024Tokens := by exact .simple _ _ (by rfl)

def node025 : Stmt := (.write (.index (.variable "buf".toList) (.binary .add (.variable "u".toList) (.number .i32 1))) .set (.cast .byte (.variable "w".toList)))
def node025Tokens : List B20.C.Token := ["buf","[","u","+","1","]","=","(","unsigned","char",")","w",";"].map String.toList
theorem node025_source : Statement node025 node025Tokens := by exact .simple _ _ (by rfl)

def node026 : Stmt := .skip
def node026Tokens : List B20.C.Token := []
theorem node026_source : Body node026 node026Tokens := by exact .nil

end FT1536.Source3.KeygenCodecNoneBinding
