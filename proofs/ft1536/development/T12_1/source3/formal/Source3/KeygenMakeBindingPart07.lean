import Source3.KeygenMakeBindingPart06

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

theorem guard193_source : guard guard193 guard193Tokens := by rfl

def node193 : Stmt := (.branch guard193 node192 .skip)
def node193Tokens : List B20.C.Token := ["if".toList,['(']]++guard193Tokens++[[')']]++node192Tokens
theorem node193_source : Statement node193 node193Tokens := by exact .ifOnly _ _ _ _ guard193_source node192_source

def node194 : Stmt := .continueLoop
def node194Tokens : List B20.C.Token := ["continue",";"].map String.toList
theorem node194_source : Statement node194 node194Tokens := by exact .simple _ _ (by rfl)

def node195 : Stmt := .skip
def node195Tokens : List B20.C.Token := []
theorem node195_source : Body node195 node195Tokens := by exact .nil

def node196 : Stmt := (.seq node194 node195)
def node196Tokens : List B20.C.Token := node194Tokens++node195Tokens
theorem node196_source : Body node196 node196Tokens := by exact .cons _ _ _ _ node194_source node195_source

def node197 : Stmt := (.scope node196)
def node197Tokens : List B20.C.Token := [['{']]++node196Tokens++[['}']]
theorem node197_source : Statement node197 node197Tokens := by exact .scope _ _ node196_source

def guard198 : Expr := (.unary .logicalNot (.call .solve (argumentTree [(.variable "fk".toList),(.variable "F".toList),(.variable "G".toList),(.variable "f".toList),(.variable "g".toList)])))
def guard198Tokens : List B20.C.Token := ["!","solve_NTRU","(","fk",",","F",",","G",",","f",",","g",")"].map String.toList
theorem guard198_source : guard guard198 guard198Tokens := by rfl

def node198 : Stmt := (.branch guard198 node197 .skip)
def node198Tokens : List B20.C.Token := ["if".toList,['(']]++guard198Tokens++[[')']]++node197Tokens
theorem node198_source : Statement node198 node198Tokens := by exact .ifOnly _ _ _ _ guard198_source node197_source

def node199 : Stmt := .continueLoop
def node199Tokens : List B20.C.Token := ["continue",";"].map String.toList
theorem node199_source : Statement node199 node199Tokens := by exact .simple _ _ (by rfl)

def node200 : Stmt := .skip
def node200Tokens : List B20.C.Token := []
theorem node200_source : Body node200 node200Tokens := by exact .nil

def node201 : Stmt := (.seq node199 node200)
def node201Tokens : List B20.C.Token := node199Tokens++node200Tokens
theorem node201_source : Body node201 node201Tokens := by exact .cons _ _ _ _ node199_source node200_source

def node202 : Stmt := (.scope node201)
def node202Tokens : List B20.C.Token := [['{']]++node201Tokens++[['}']]
theorem node202_source : Statement node202 node202Tokens := by exact .scope _ _ node201_source

def guard203 : Expr := (.unary .logicalNot (.call .certificate (argumentTree [(.cast (.pointer .fpr) (.member (.variable "fk".toList) "tmp".toList)),(.variable "f".toList),(.variable "g".toList),(.variable "F".toList),(.variable "G".toList),(.variable "logn".toList),(.variable "ter".toList)])))
def guard203Tokens : List B20.C.Token := ["!","ft_keygen_leaf_certificate","(","(","fpr","*",")","fk","-",">","tmp",",","f",",","g",",","F",",","G",",","logn",",","ter",")"].map String.toList
theorem guard203_source : guard guard203 guard203Tokens := by rfl

def node203 : Stmt := (.branch guard203 node202 .skip)
def node203Tokens : List B20.C.Token := ["if".toList,['(']]++guard203Tokens++[[')']]++node202Tokens
theorem node203_source : Statement node203 node203Tokens := by exact .ifOnly _ _ _ _ guard203_source node202_source

def node204 : Stmt := .skip
def node204Tokens : List B20.C.Token := []
theorem node204_source : Body node204 node204Tokens := by exact .nil

def node205 : Stmt := (.seq node203 node204)
def node205Tokens : List B20.C.Token := node203Tokens++node204Tokens
theorem node205_source : Body node205 node205Tokens := by exact .cons _ _ _ _ node203_source node204_source

def node206 : Stmt := (.scope node205)
def node206Tokens : List B20.C.Token := [['{']]++node205Tokens++[['}']]
theorem node206_source : Statement node206 node206Tokens := by exact .scope _ _ node205_source

def guard207 : Expr := (.binary .land (.binary .land (.variable "ter".toList) (.binary .eq (.variable "logn".toList) (.number .i32 10))) (.binary .eq (.variable "n".toList) (.number .i32 1536)))
def guard207Tokens : List B20.C.Token := ["ter","&&","logn","==","10","&&","n","==","1536"].map String.toList
theorem guard207_source : guard guard207 guard207Tokens := by rfl

def node207 : Stmt := (.branch guard207 node206 .skip)
def node207Tokens : List B20.C.Token := ["if".toList,['(']]++guard207Tokens++[[')']]++node206Tokens
theorem node207_source : Statement node207 node207Tokens := by exact .ifOnly _ _ _ _ guard207_source node206_source

def node208 : Stmt := .breakLoop
def node208Tokens : List B20.C.Token := ["break",";"].map String.toList
theorem node208_source : Statement node208 node208Tokens := by exact .simple _ _ (by rfl)

def node209 : Stmt := .skip
def node209Tokens : List B20.C.Token := []
theorem node209_source : Body node209 node209Tokens := by exact .nil

def node210 : Stmt := (.seq node208 node209)
def node210Tokens : List B20.C.Token := node208Tokens++node209Tokens
theorem node210_source : Body node210 node210Tokens := by exact .cons _ _ _ _ node208_source node209_source

def node211 : Stmt := (.seq node207 node210)
def node211Tokens : List B20.C.Token := node207Tokens++node210Tokens
theorem node211_source : Body node211 node211Tokens := by exact .cons _ _ _ _ node207_source node210_source

def node212 : Stmt := (.seq node198 node211)
def node212Tokens : List B20.C.Token := node198Tokens++node211Tokens
theorem node212_source : Body node212 node212Tokens := by exact .cons _ _ _ _ node198_source node211_source

def node213 : Stmt := (.seq node193 node212)
def node213Tokens : List B20.C.Token := node193Tokens++node212Tokens
theorem node213_source : Body node213 node213Tokens := by exact .cons _ _ _ _ node193_source node212_source

def node214 : Stmt := (.seq node188 node213)
def node214Tokens : List B20.C.Token := node188Tokens++node213Tokens
theorem node214_source : Body node214 node214Tokens := by exact .cons _ _ _ _ node188_source node213_source

def node215 : Stmt := (.scope node214)
def node215Tokens : List B20.C.Token := [['{']]++node214Tokens++[['}']]
theorem node215_source : Statement node215 node215Tokens := by exact .scope _ _ node214_source

def loop216Init : Stmt := .skip
def loop216Update : Stmt := .skip
def loop216Test : Option Expr := none
def loop216First : List B20.C.Token := [].map String.toList
def loop216Middle : List B20.C.Token := [].map String.toList
def loop216Last : List B20.C.Token := [].map String.toList
theorem loop216_initial : initialClause loop216Init loop216First := by rfl
theorem loop216_increment : incrementClause loop216Update loop216Last := by rfl
theorem loop216_condition : Test loop216Test loop216Middle := by exact .absent

def node216 : Stmt := (.loop loop216Init loop216Test loop216Update node215)
def node216Tokens : List B20.C.Token := ["for".toList,['(']]++loop216First++[[';']]++loop216Middle++[[';']]++loop216Last++[[')']]++node215Tokens
theorem node216_source : Statement node216 node216Tokens := by exact .loop _ _ _ _ _ _ _ _ loop216_initial loop216_condition loop216_increment node215_source

end FT1536.Source3.KeygenMakeBinding
