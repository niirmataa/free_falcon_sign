import Source3.KeygenMakeBindingPart04

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

def node138 : Stmt := (.evaluate (.call .adj (argumentTree [(.variable "rt2".toList),(.variable "logn".toList)])))
def node138Tokens : List B20.C.Token := ["falcon_poly_adj_fft","(","rt2",",","logn",")",";"].map String.toList
theorem node138_source : Statement node138 node138Tokens := by exact .simple _ _ (by rfl)

def node139 : Stmt := (.evaluate (.call .mulconst (argumentTree [(.variable "rt1".toList),(.call .of (argumentTree [(.number .i32 12289)])),(.variable "logn".toList)])))
def node139Tokens : List B20.C.Token := ["falcon_poly_mulconst_fft","(","rt1",",","fpr_of","(","12289",")",",","logn",")",";"].map String.toList
theorem node139_source : Statement node139 node139Tokens := by exact .simple _ _ (by decide +kernel)

def node140 : Stmt := (.evaluate (.call .mulconst (argumentTree [(.variable "rt2".toList),(.call .of (argumentTree [(.number .i32 12289)])),(.variable "logn".toList)])))
def node140Tokens : List B20.C.Token := ["falcon_poly_mulconst_fft","(","rt2",",","fpr_of","(","12289",")",",","logn",")",";"].map String.toList
theorem node140_source : Statement node140 node140Tokens := by exact .simple _ _ (by decide +kernel)

def node141 : Stmt := (.evaluate (.call .mulauto (argumentTree [(.variable "rt1".toList),(.variable "rt3".toList),(.variable "logn".toList)])))
def node141Tokens : List B20.C.Token := ["falcon_poly_mul_autoadj_fft","(","rt1",",","rt3",",","logn",")",";"].map String.toList
theorem node141_source : Statement node141 node141Tokens := by exact .simple _ _ (by rfl)

def node142 : Stmt := (.evaluate (.call .mulauto (argumentTree [(.variable "rt2".toList),(.variable "rt3".toList),(.variable "logn".toList)])))
def node142Tokens : List B20.C.Token := ["falcon_poly_mul_autoadj_fft","(","rt2",",","rt3",",","logn",")",";"].map String.toList
theorem node142_source : Statement node142 node142Tokens := by exact .simple _ _ (by rfl)

def node143 : Stmt := (.evaluate (.call .ifft (argumentTree [(.variable "rt1".toList),(.variable "logn".toList)])))
def node143Tokens : List B20.C.Token := ["falcon_iFFT","(","rt1",",","logn",")",";"].map String.toList
theorem node143_source : Statement node143 node143Tokens := by exact .simple _ _ (by rfl)

def node144 : Stmt := (.evaluate (.call .ifft (argumentTree [(.variable "rt2".toList),(.variable "logn".toList)])))
def node144Tokens : List B20.C.Token := ["falcon_iFFT","(","rt2",",","logn",")",";"].map String.toList
theorem node144_source : Statement node144 node144Tokens := by exact .simple _ _ (by rfl)

def node145 : Stmt := (.write (.variable "bnorm".toList) .set (.call .of (argumentTree [(.number .i32 0)])))
def node145Tokens : List B20.C.Token := ["bnorm","=","fpr_of","(","0",")",";"].map String.toList
theorem node145_source : Statement node145 node145Tokens := by exact .simple _ _ (by rfl)

def node146 : Stmt := (.write (.variable "bnorm".toList) .set (.call .add (argumentTree [(.variable "bnorm".toList),(.call .sqr (argumentTree [(.index (.variable "rt1".toList) (.variable "u".toList))]))])))
def node146Tokens : List B20.C.Token := ["bnorm","=","fpr_add","(","bnorm",",","fpr_sqr","(","rt1","[","u","]",")",")",";"].map String.toList
theorem node146_source : Statement node146 node146Tokens := by exact .simple _ _ (by decide +kernel)

def node147 : Stmt := (.write (.variable "bnorm".toList) .set (.call .add (argumentTree [(.variable "bnorm".toList),(.call .sqr (argumentTree [(.index (.variable "rt2".toList) (.variable "u".toList))]))])))
def node147Tokens : List B20.C.Token := ["bnorm","=","fpr_add","(","bnorm",",","fpr_sqr","(","rt2","[","u","]",")",")",";"].map String.toList
theorem node147_source : Statement node147 node147Tokens := by exact .simple _ _ (by decide +kernel)

def node148 : Stmt := .skip
def node148Tokens : List B20.C.Token := []
theorem node148_source : Body node148 node148Tokens := by exact .nil

def node149 : Stmt := (.seq node147 node148)
def node149Tokens : List B20.C.Token := node147Tokens++node148Tokens
theorem node149_source : Body node149 node149Tokens := by exact .cons _ _ _ _ node147_source node148_source

def node150 : Stmt := (.seq node146 node149)
def node150Tokens : List B20.C.Token := node146Tokens++node149Tokens
theorem node150_source : Body node150 node150Tokens := by exact .cons _ _ _ _ node146_source node149_source

def node151 : Stmt := (.scope node150)
def node151Tokens : List B20.C.Token := [['{']]++node150Tokens++[['}']]
theorem node151_source : Statement node151 node151Tokens := by exact .scope _ _ node150_source

def loop152Init : Stmt := (.write (.variable "u".toList) .set (.number .i32 0))
def loop152Update : Stmt := (.increment (.variable "u".toList))
def loop152Test : Option Expr := (some (.binary .lt (.variable "u".toList) (.variable "n".toList)))
def loop152First : List B20.C.Token := ["u","=","0"].map String.toList
def loop152Middle : List B20.C.Token := ["u","<","n"].map String.toList
def loop152Last : List B20.C.Token := ["u","++"].map String.toList
theorem loop152_initial : initialClause loop152Init loop152First := by rfl
theorem loop152_increment : incrementClause loop152Update loop152Last := by rfl
theorem loop152_condition : Test loop152Test loop152Middle := by exact .present _ _ (by rfl)

def node152 : Stmt := (.loop loop152Init loop152Test loop152Update node151)
def node152Tokens : List B20.C.Token := ["for".toList,['(']]++loop152First++[[';']]++loop152Middle++[[';']]++loop152Last++[[')']]++node151Tokens
theorem node152_source : Statement node152 node152Tokens := by exact .loop _ _ _ _ _ _ _ _ loop152_initial loop152_condition loop152_increment node151_source

def node153 : Stmt := .continueLoop
def node153Tokens : List B20.C.Token := ["continue",";"].map String.toList
theorem node153_source : Statement node153 node153Tokens := by exact .simple _ _ (by rfl)

def node154 : Stmt := .skip
def node154Tokens : List B20.C.Token := []
theorem node154_source : Body node154 node154Tokens := by exact .nil

def node155 : Stmt := (.seq node153 node154)
def node155Tokens : List B20.C.Token := node153Tokens++node154Tokens
theorem node155_source : Body node155 node155Tokens := by exact .cons _ _ _ _ node153_source node154_source

def node156 : Stmt := (.scope node155)
def node156Tokens : List B20.C.Token := [['{']]++node155Tokens++[['}']]
theorem node156_source : Statement node156 node156Tokens := by exact .scope _ _ node155_source

def guard157 : Expr := (.unary .logicalNot (.call .lt (argumentTree [(.variable "bnorm".toList),(.call .div (argumentTree [(.call .of (argumentTree [(.number .i32 168224121)])),(.call .of (argumentTree [(.number .i32 10000)]))]))])))
def guard157Tokens : List B20.C.Token := ["!","fpr_lt","(","bnorm",",","fpr_div","(","fpr_of","(","168224121",")",",","fpr_of","(","10000",")",")",")"].map String.toList
theorem guard157_source : guard guard157 guard157Tokens := by decide +kernel

def node157 : Stmt := (.branch guard157 node156 .skip)
def node157Tokens : List B20.C.Token := ["if".toList,['(']]++guard157Tokens++[[')']]++node156Tokens
theorem node157_source : Statement node157 node157Tokens := by exact .ifOnly _ _ _ _ guard157_source node156_source

def node158 : Stmt := .skip
def node158Tokens : List B20.C.Token := []
theorem node158_source : Body node158 node158Tokens := by exact .nil

def node159 : Stmt := (.seq node157 node158)
def node159Tokens : List B20.C.Token := node157Tokens++node158Tokens
theorem node159_source : Body node159 node159Tokens := by exact .cons _ _ _ _ node157_source node158_source

def node160 : Stmt := (.seq node152 node159)
def node160Tokens : List B20.C.Token := node152Tokens++node159Tokens
theorem node160_source : Body node160 node160Tokens := by exact .cons _ _ _ _ node152_source node159_source

def node161 : Stmt := (.seq node145 node160)
def node161Tokens : List B20.C.Token := node145Tokens++node160Tokens
theorem node161_source : Body node161 node161Tokens := by exact .cons _ _ _ _ node145_source node160_source

def node162 : Stmt := (.seq node144 node161)
def node162Tokens : List B20.C.Token := node144Tokens++node161Tokens
theorem node162_source : Body node162 node162Tokens := by exact .cons _ _ _ _ node144_source node161_source

def node163 : Stmt := (.seq node143 node162)
def node163Tokens : List B20.C.Token := node143Tokens++node162Tokens
theorem node163_source : Body node163 node163Tokens := by exact .cons _ _ _ _ node143_source node162_source

def node164 : Stmt := (.seq node142 node163)
def node164Tokens : List B20.C.Token := node142Tokens++node163Tokens
end FT1536.Source3.KeygenMakeBinding
