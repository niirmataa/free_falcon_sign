import Source3.KeygenMakeGrammar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

def node000 : Stmt := (.declare [⟨"logn".toList,.u32,none⟩,⟨"ter".toList,.u32,none⟩])
def node000Tokens : List B20.C.Token := ["unsigned","logn",",","ter",";"].map String.toList
theorem node000_source : Statement node000 node000Tokens := by exact .simple _ _ (by rfl)

def node001 : Stmt := (.declare [⟨"n".toList,.size,none⟩,⟨"u".toList,.size,none⟩])
def node001Tokens : List B20.C.Token := ["size_t","n",",","u",";"].map String.toList
theorem node001_source : Statement node001 node001Tokens := by exact .simple _ _ (by rfl)

def node002 : Stmt := (.declare [⟨"f".toList,.i16,some 3072⟩,⟨"g".toList,.i16,some 3072⟩,⟨"F".toList,.i16,some 3072⟩,⟨"G".toList,.i16,some 3072⟩])
def node002Tokens : List B20.C.Token := ["int16_t","f","[","3072","]",",","g","[","3072","]",",","F","[","3072","]",",","G","[","3072","]",";"].map String.toList
theorem node002_source : Statement node002 node002Tokens := by exact .simple _ _ (by rfl)

def node003 : Stmt := (.declare [⟨"h".toList,.u16,some 3072⟩])
def node003Tokens : List B20.C.Token := ["uint16_t","h","[","3072","]",";"].map String.toList
theorem node003_source : Statement node003 node003Tokens := by exact .simple _ _ (by rfl)

def node004 : Stmt := (.declare [⟨"klen".toList,.size,none⟩,⟨"skoff".toList,.size,none⟩])
def node004Tokens : List B20.C.Token := ["size_t","klen",",","skoff",";"].map String.toList
theorem node004_source : Statement node004 node004Tokens := by exact .simple _ _ (by rfl)

def node005 : Stmt := (.declare [⟨"skbuf".toList,(.pointer .byte),none⟩])
def node005Tokens : List B20.C.Token := ["unsigned","char","*","skbuf",";"].map String.toList
theorem node005_source : Statement node005 node005Tokens := by exact .simple _ _ (by rfl)

def node006 : Stmt := (.declare [⟨"ske".toList,(.pointer .i16),some 4⟩])
def node006Tokens : List B20.C.Token := ["int16_t","*","ske","[","4","]",";"].map String.toList
theorem node006_source : Statement node006 node006Tokens := by exact .simple _ _ (by rfl)

def node007 : Stmt := (.declare [⟨"i".toList,.i32,none⟩])
def node007Tokens : List B20.C.Token := ["int","i",";"].map String.toList
theorem node007_source : Statement node007 node007Tokens := by exact .simple _ _ (by rfl)

def node008 : Stmt := (.declare [⟨"local_attempts".toList,.u64,none⟩])
def node008Tokens : List B20.C.Token := ["uint64_t","local_attempts",";"].map String.toList
theorem node008_source : Statement node008 node008Tokens := by exact .simple _ _ (by rfl)

def node009 : Stmt := (.write (.variable "local_attempts".toList) .set (.number .i32 0))
def node009Tokens : List B20.C.Token := ["local_attempts","=","0",";"].map String.toList
theorem node009_source : Statement node009 node009Tokens := by exact .simple _ _ (by rfl)

def node010 : Stmt := (.write (.variable "logn".toList) .set (.member (.variable "fk".toList) "logn".toList))
def node010Tokens : List B20.C.Token := ["logn","=","fk","-",">","logn",";"].map String.toList
theorem node010_source : Statement node010 node010Tokens := by exact .simple _ _ (by rfl)

def node011 : Stmt := (.write (.variable "ter".toList) .set (.member (.variable "fk".toList) "ternary".toList))
def node011Tokens : List B20.C.Token := ["ter","=","fk","-",">","ternary",";"].map String.toList
theorem node011_source : Statement node011 node011Tokens := by exact .simple _ _ (by rfl)

def node012 : Stmt := (.write (.variable "n".toList) .set (.call .mkn (argumentTree [(.variable "logn".toList),(.variable "ter".toList)])))
def node012Tokens : List B20.C.Token := ["n","=","MKN","(","logn",",","ter",")",";"].map String.toList
theorem node012_source : Statement node012 node012Tokens := by exact .simple _ _ (by rfl)

def node013 : Stmt := (.ret (.number .i32 0))
def node013Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node013_source : Statement node013 node013Tokens := by exact .simple _ _ (by rfl)

def node014 : Stmt := .skip
def node014Tokens : List B20.C.Token := []
theorem node014_source : Body node014 node014Tokens := by exact .nil

def node015 : Stmt := (.seq node013 node014)
def node015Tokens : List B20.C.Token := node013Tokens++node014Tokens
theorem node015_source : Body node015 node015Tokens := by exact .cons _ _ _ _ node013_source node014_source

def node016 : Stmt := (.scope node015)
def node016Tokens : List B20.C.Token := [['{']]++node015Tokens++[['}']]
theorem node016_source : Statement node016 node016Tokens := by exact .scope _ _ node015_source

def guard017 : Expr := (.unary .logicalNot (.call .ready (argumentTree [(.variable "fk".toList)])))
def guard017Tokens : List B20.C.Token := ["!","rng_ready","(","fk",")"].map String.toList
theorem guard017_source : guard guard017 guard017Tokens := by rfl

def node017 : Stmt := (.branch guard017 node016 .skip)
def node017Tokens : List B20.C.Token := ["if".toList,['(']]++guard017Tokens++[[')']]++node016Tokens
theorem node017_source : Statement node017 node017Tokens := by exact .ifOnly _ _ _ _ guard017_source node016_source

def node018 : Stmt := (.increment (.variable "local_attempts".toList))
def node018Tokens : List B20.C.Token := ["local_attempts","++",";"].map String.toList
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

def guard023 : Expr := (.binary .gt (.variable "local_attempts".toList) (.number .i32 3000000))
def guard023Tokens : List B20.C.Token := ["local_attempts",">","3000000"].map String.toList
theorem guard023_source : guard guard023 guard023Tokens := by rfl

def node023 : Stmt := (.branch guard023 node022 .skip)
def node023Tokens : List B20.C.Token := ["if".toList,['(']]++guard023Tokens++[[')']]++node022Tokens
theorem node023_source : Statement node023 node023Tokens := by exact .ifOnly _ _ _ _ guard023_source node022_source

def node024 : Stmt := (.declare [⟨"rt1".toList,(.pointer .fpr),none⟩,⟨"rt2".toList,(.pointer .fpr),none⟩,⟨"rt3".toList,(.pointer .fpr),none⟩])
def node024Tokens : List B20.C.Token := ["fpr","*","rt1",",","*","rt2",",","*","rt3",";"].map String.toList
theorem node024_source : Statement node024 node024Tokens := by exact .simple _ _ (by rfl)

def node025 : Stmt := (.declare [⟨"norm".toList,.fpr,none⟩,⟨"bound".toList,.fpr,none⟩])
def node025Tokens : List B20.C.Token := ["fpr","norm",",","bound",";"].map String.toList
theorem node025_source : Statement node025 node025Tokens := by exact .simple _ _ (by rfl)

def node026 : Stmt := (.write (.variable "rt1".toList) .set (.cast (.pointer .fpr) (.member (.variable "fk".toList) "tmp".toList)))
def node026Tokens : List B20.C.Token := ["rt1","=","(","fpr","*",")","fk","-",">","tmp",";"].map String.toList
theorem node026_source : Statement node026 node026Tokens := by exact .simple _ _ (by rfl)

def node027 : Stmt := (.write (.variable "rt2".toList) .set (.binary .add (.variable "rt1".toList) (.variable "n".toList)))
def node027Tokens : List B20.C.Token := ["rt2","=","rt1","+","n",";"].map String.toList
theorem node027_source : Statement node027 node027Tokens := by exact .simple _ _ (by rfl)

end FT1536.Source3.KeygenMakeBinding
