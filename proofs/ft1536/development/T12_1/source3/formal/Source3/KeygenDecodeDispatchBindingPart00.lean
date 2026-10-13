import Source3.KeygenDecodeGrammar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeDispatchBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

def switch000Test : Expr := (.variable "comp".toList)
def switch000TestTokens : List B20.C.Token := ["comp"].map String.toList
def switch000Value0 : Expr := (.call .none (argumentTree [(.variable "x".toList),(.variable "logn".toList),(.variable "q".toList),(.variable "data".toList),(.variable "len".toList)]))
def switch000Tokens0 : List B20.C.Token := ["return","uncompress_none","(","x",",","logn",",","q",",","data",",","len",")",";"].map String.toList
def switch000Value1 : Expr := (.call .static (argumentTree [(.variable "x".toList),(.variable "logn".toList),(.variable "q".toList),(.variable "data".toList),(.variable "len".toList)]))
def switch000Tokens1 : List B20.C.Token := ["return","uncompress_static","(","x",",","logn",",","q",",","data",",","len",")",";"].map String.toList
def switch000Value2 : Expr := (.number .i32 0)
def switch000Tokens2 : List B20.C.Token := ["return","0",";"].map String.toList
theorem switch000_test : guard switch000Test switch000TestTokens := by rfl
theorem switch000_arm0 : KeygenDecodeSyntax.simple switch000Tokens0=some (.ret switch000Value0,[]) := by decide +kernel
theorem switch000_arm1 : KeygenDecodeSyntax.simple switch000Tokens1=some (.ret switch000Value1,[]) := by decide +kernel
theorem switch000_arm2 : KeygenDecodeSyntax.simple switch000Tokens2=some (.ret switch000Value2,[]) := by decide +kernel
def node000 : Stmt := (.switch switch000Test (.ret switch000Value0) (.ret switch000Value1) (.ret switch000Value2))
def node000Tokens : List B20.C.Token := ["switch".toList,['(']]++switch000TestTokens++[[')'],['{'],"case".toList,['0'],[':']]++switch000Tokens0++["case".toList,['1'],[':']]++switch000Tokens1++["default".toList,[':']]++switch000Tokens2++[['}']]
theorem node000_source : Statement node000 node000Tokens := by exact Statement.switch switch000Test switch000Value0 switch000Value1 switch000Value2 switch000TestTokens switch000Tokens0 switch000Tokens1 switch000Tokens2 switch000_test switch000_arm0 switch000_arm1 switch000_arm2

def node001 : Stmt := .skip
def node001Tokens : List B20.C.Token := []
theorem node001_source : Body node001 node001Tokens := by exact .nil

def node002 : Stmt := (.seq node000 node001)
def node002Tokens : List B20.C.Token := node000Tokens++node001Tokens
theorem node002_source : Body node002 node002Tokens := by exact .cons _ _ _ _ node000_source node001_source

end FT1536.Source3.KeygenDecodeDispatchBinding
