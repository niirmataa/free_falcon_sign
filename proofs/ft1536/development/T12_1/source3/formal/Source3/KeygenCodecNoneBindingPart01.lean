import Source3.KeygenCodecNoneBindingPart00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNoneBinding
open KeygenCodecSyntax KeygenCodecGrammar

def node027 : Stmt := (.seq node025 node026)
def node027Tokens : List B20.C.Token := node025Tokens++node026Tokens
theorem node027_source : Body node027 node027Tokens := by exact .cons _ _ _ _ node025_source node026_source

def node028 : Stmt := (.seq node024 node027)
def node028Tokens : List B20.C.Token := node024Tokens++node027Tokens
theorem node028_source : Body node028 node028Tokens := by exact .cons _ _ _ _ node024_source node027_source

def node029 : Stmt := (.seq node023 node028)
def node029Tokens : List B20.C.Token := node023Tokens++node028Tokens
theorem node029_source : Body node029 node029Tokens := by exact .cons _ _ _ _ node023_source node028_source

def node030 : Stmt := (.seq node022 node029)
def node030Tokens : List B20.C.Token := node022Tokens++node029Tokens
theorem node030_source : Body node030 node030Tokens := by exact .cons _ _ _ _ node022_source node029_source

def node031 : Stmt := (.scope node030)
def node031Tokens : List B20.C.Token := [['{']]++node030Tokens++[['}']]
theorem node031_source : Statement node031 node031Tokens := by exact .scope _ _ node030_source

def loop032Init : Stmt := (.write (.variable "u".toList) .set (.number .i32 0))
def loop032Update : Stmt := (.write (.variable "u".toList) .add (.number .i32 2))
def loop032Test : Option Expr := (some (.binary .lt (.variable "u".toList) (.variable "len".toList)))
def loop032First : List B20.C.Token := ["u","=","0"].map String.toList
def loop032Middle : List B20.C.Token := ["u","<","len"].map String.toList
def loop032Last : List B20.C.Token := ["u","+=","2"].map String.toList
theorem loop032_initial : initialClause loop032Init loop032First := by rfl
theorem loop032_increment : incrementClause loop032Update loop032Last := by rfl
theorem loop032_condition : Test loop032Test loop032Middle := by exact .present _ _ (by rfl)

def node032 : Stmt := (.loop loop032Init loop032Test loop032Update node031)
def node032Tokens : List B20.C.Token := ["for".toList,['(']]++loop032First++[[';']]++loop032Middle++[[';']]++loop032Last++[[')']]++node031Tokens
theorem node032_source : Statement node032 node032Tokens := by exact .loop _ _ _ _ _ _ _ _ loop032_initial loop032_condition loop032_increment node031_source

def node033 : Stmt := (.ret (.variable "len".toList))
def node033Tokens : List B20.C.Token := ["return","len",";"].map String.toList
theorem node033_source : Statement node033 node033Tokens := by exact .simple _ _ (by rfl)

def node034 : Stmt := .skip
def node034Tokens : List B20.C.Token := []
theorem node034_source : Body node034 node034Tokens := by exact .nil

def node035 : Stmt := (.seq node033 node034)
def node035Tokens : List B20.C.Token := node033Tokens++node034Tokens
theorem node035_source : Body node035 node035Tokens := by exact .cons _ _ _ _ node033_source node034_source

def node036 : Stmt := (.seq node032 node035)
def node036Tokens : List B20.C.Token := node032Tokens++node035Tokens
theorem node036_source : Body node036 node036Tokens := by exact .cons _ _ _ _ node032_source node035_source

def node037 : Stmt := (.seq node021 node036)
def node037Tokens : List B20.C.Token := node021Tokens++node036Tokens
theorem node037_source : Body node037 node037Tokens := by exact .cons _ _ _ _ node021_source node036_source

def node038 : Stmt := (.seq node020 node037)
def node038Tokens : List B20.C.Token := node020Tokens++node037Tokens
theorem node038_source : Body node038 node038Tokens := by exact .cons _ _ _ _ node020_source node037_source

def node039 : Stmt := (.seq node015 node038)
def node039Tokens : List B20.C.Token := node015Tokens++node038Tokens
theorem node039_source : Body node039 node039Tokens := by exact .cons _ _ _ _ node015_source node038_source

def node040 : Stmt := (.seq node010 node039)
def node040Tokens : List B20.C.Token := node010Tokens++node039Tokens
theorem node040_source : Body node040 node040Tokens := by exact .cons _ _ _ _ node010_source node039_source

def node041 : Stmt := (.seq node001 node040)
def node041Tokens : List B20.C.Token := node001Tokens++node040Tokens
theorem node041_source : Body node041 node041Tokens := by exact .cons _ _ _ _ node001_source node040_source

def node042 : Stmt := (.seq node000 node041)
def node042Tokens : List B20.C.Token := node000Tokens++node041Tokens
theorem node042_source : Body node042 node042Tokens := by exact .cons _ _ _ _ node000_source node041_source

end FT1536.Source3.KeygenCodecNoneBinding
