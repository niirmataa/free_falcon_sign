import Source3.KeygenMakeBindingPart01

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

theorem loop054_condition : Test loop054Test loop054Middle := by exact .present _ _ (by rfl)

def node054 : Stmt := (.loop loop054Init loop054Test loop054Update node053)
def node054Tokens : List B20.C.Token := ["for".toList,['(']]++loop054First++[[';']]++loop054Middle++[[';']]++loop054Last++[[')']]++node053Tokens
theorem node054_source : Statement node054 node054Tokens := by exact .loop _ _ _ _ _ _ _ _ loop054_initial loop054_condition loop054_increment node053_source

def node055 : Stmt := (.write (.variable "norm".toList) .set (.call .double (argumentTree [(.variable "norm".toList)])))
def node055Tokens : List B20.C.Token := ["norm","=","fpr_double","(","norm",")",";"].map String.toList
theorem node055_source : Statement node055 node055Tokens := by exact .simple _ _ (by rfl)

def node056 : Stmt := .continueLoop
def node056Tokens : List B20.C.Token := ["continue",";"].map String.toList
theorem node056_source : Statement node056 node056Tokens := by exact .simple _ _ (by rfl)

def node057 : Stmt := .skip
def node057Tokens : List B20.C.Token := []
theorem node057_source : Body node057 node057Tokens := by exact .nil

def node058 : Stmt := (.seq node056 node057)
def node058Tokens : List B20.C.Token := node056Tokens++node057Tokens
theorem node058_source : Body node058 node058Tokens := by exact .cons _ _ _ _ node056_source node057_source

def node059 : Stmt := (.scope node058)
def node059Tokens : List B20.C.Token := [['{']]++node058Tokens++[['}']]
theorem node059_source : Statement node059 node059Tokens := by exact .scope _ _ node058_source

def guard060 : Expr := (.unary .logicalNot (.call .lt (argumentTree [(.variable "norm".toList),(.variable "bound".toList)])))
def guard060Tokens : List B20.C.Token := ["!","fpr_lt","(","norm",",","bound",")"].map String.toList
theorem guard060_source : guard guard060 guard060Tokens := by rfl

def node060 : Stmt := (.branch guard060 node059 .skip)
def node060Tokens : List B20.C.Token := ["if".toList,['(']]++guard060Tokens++[[')']]++node059Tokens
theorem node060_source : Statement node060 node060Tokens := by exact .ifOnly _ _ _ _ guard060_source node059_source

def node061 : Stmt := (.evaluate (.call .invnorm3 (argumentTree [(.variable "rt3".toList),(.variable "rt1".toList),(.variable "rt2".toList),(.variable "logn".toList),(.number .i32 1)])))
def node061Tokens : List B20.C.Token := ["falcon_poly_invnorm2_fft3","(","rt3",",","rt1",",","rt2",",","logn",",","1",")",";"].map String.toList
theorem node061_source : Statement node061 node061Tokens := by exact .simple _ _ (by rfl)

def node062 : Stmt := (.evaluate (.call .adj3 (argumentTree [(.variable "rt1".toList),(.variable "logn".toList),(.number .i32 1)])))
def node062Tokens : List B20.C.Token := ["falcon_poly_adj_fft3","(","rt1",",","logn",",","1",")",";"].map String.toList
theorem node062_source : Statement node062 node062Tokens := by exact .simple _ _ (by rfl)

def node063 : Stmt := (.evaluate (.call .adj3 (argumentTree [(.variable "rt2".toList),(.variable "logn".toList),(.number .i32 1)])))
def node063Tokens : List B20.C.Token := ["falcon_poly_adj_fft3","(","rt2",",","logn",",","1",")",";"].map String.toList
theorem node063_source : Statement node063 node063Tokens := by exact .simple _ _ (by rfl)

def node064 : Stmt := (.evaluate (.call .mulconst3 (argumentTree [(.variable "rt1".toList),(.call .of (argumentTree [(.number .i32 18433)])),(.variable "logn".toList),(.number .i32 1)])))
def node064Tokens : List B20.C.Token := ["falcon_poly_mulconst_fft3","(","rt1",",","fpr_of","(","18433",")",",","logn",",","1",")",";"].map String.toList
theorem node064_source : Statement node064 node064Tokens := by exact .simple _ _ (by decide +kernel)

def node065 : Stmt := (.evaluate (.call .mulconst3 (argumentTree [(.variable "rt2".toList),(.call .of (argumentTree [(.number .i32 18433)])),(.variable "logn".toList),(.number .i32 1)])))
def node065Tokens : List B20.C.Token := ["falcon_poly_mulconst_fft3","(","rt2",",","fpr_of","(","18433",")",",","logn",",","1",")",";"].map String.toList
theorem node065_source : Statement node065 node065Tokens := by exact .simple _ _ (by decide +kernel)

def node066 : Stmt := (.evaluate (.call .mulauto3 (argumentTree [(.variable "rt1".toList),(.variable "rt3".toList),(.variable "logn".toList),(.number .i32 1)])))
def node066Tokens : List B20.C.Token := ["falcon_poly_mul_autoadj_fft3","(","rt1",",","rt3",",","logn",",","1",")",";"].map String.toList
theorem node066_source : Statement node066 node066Tokens := by exact .simple _ _ (by rfl)

def node067 : Stmt := (.evaluate (.call .mulauto3 (argumentTree [(.variable "rt2".toList),(.variable "rt3".toList),(.variable "logn".toList),(.number .i32 1)])))
def node067Tokens : List B20.C.Token := ["falcon_poly_mul_autoadj_fft3","(","rt2",",","rt3",",","logn",",","1",")",";"].map String.toList
theorem node067_source : Statement node067 node067Tokens := by exact .simple _ _ (by rfl)

def node068 : Stmt := (.write (.variable "norm".toList) .set (.call .of (argumentTree [(.number .i32 0)])))
def node068Tokens : List B20.C.Token := ["norm","=","fpr_of","(","0",")",";"].map String.toList
theorem node068_source : Statement node068 node068Tokens := by exact .simple _ _ (by rfl)

def node069 : Stmt := (.write (.variable "norm".toList) .set (.call .add (argumentTree [(.variable "norm".toList),(.call .sqr (argumentTree [(.index (.variable "rt1".toList) (.variable "u".toList))]))])))
def node069Tokens : List B20.C.Token := ["norm","=","fpr_add","(","norm",",","fpr_sqr","(","rt1","[","u","]",")",")",";"].map String.toList
theorem node069_source : Statement node069 node069Tokens := by exact .simple _ _ (by decide +kernel)

def node070 : Stmt := (.write (.variable "norm".toList) .set (.call .add (argumentTree [(.variable "norm".toList),(.call .sqr (argumentTree [(.index (.variable "rt2".toList) (.variable "u".toList))]))])))
def node070Tokens : List B20.C.Token := ["norm","=","fpr_add","(","norm",",","fpr_sqr","(","rt2","[","u","]",")",")",";"].map String.toList
theorem node070_source : Statement node070 node070Tokens := by exact .simple _ _ (by decide +kernel)

def node071 : Stmt := .skip
def node071Tokens : List B20.C.Token := []
theorem node071_source : Body node071 node071Tokens := by exact .nil

def node072 : Stmt := (.seq node070 node071)
def node072Tokens : List B20.C.Token := node070Tokens++node071Tokens
theorem node072_source : Body node072 node072Tokens := by exact .cons _ _ _ _ node070_source node071_source

def node073 : Stmt := (.seq node069 node072)
def node073Tokens : List B20.C.Token := node069Tokens++node072Tokens
theorem node073_source : Body node073 node073Tokens := by exact .cons _ _ _ _ node069_source node072_source

def node074 : Stmt := (.scope node073)
def node074Tokens : List B20.C.Token := [['{']]++node073Tokens++[['}']]
theorem node074_source : Statement node074 node074Tokens := by exact .scope _ _ node073_source

def loop075Init : Stmt := (.write (.variable "u".toList) .set (.number .i32 0))
def loop075Update : Stmt := (.increment (.variable "u".toList))
def loop075Test : Option Expr := (some (.binary .lt (.variable "u".toList) (.variable "n".toList)))
def loop075First : List B20.C.Token := ["u","=","0"].map String.toList
def loop075Middle : List B20.C.Token := ["u","<","n"].map String.toList
def loop075Last : List B20.C.Token := ["u","++"].map String.toList
theorem loop075_initial : initialClause loop075Init loop075First := by rfl
theorem loop075_increment : incrementClause loop075Update loop075Last := by rfl
theorem loop075_condition : Test loop075Test loop075Middle := by exact .present _ _ (by rfl)

def node075 : Stmt := (.loop loop075Init loop075Test loop075Update node074)
def node075Tokens : List B20.C.Token := ["for".toList,['(']]++loop075First++[[';']]++loop075Middle++[[';']]++loop075Last++[[')']]++node074Tokens
theorem node075_source : Statement node075 node075Tokens := by exact .loop _ _ _ _ _ _ _ _ loop075_initial loop075_condition loop075_increment node074_source

def node076 : Stmt := (.write (.variable "norm".toList) .set (.call .double (argumentTree [(.variable "norm".toList)])))
def node076Tokens : List B20.C.Token := ["norm","=","fpr_double","(","norm",")",";"].map String.toList
theorem node076_source : Statement node076 node076Tokens := by exact .simple _ _ (by rfl)

def node077 : Stmt := .continueLoop
def node077Tokens : List B20.C.Token := ["continue",";"].map String.toList
theorem node077_source : Statement node077 node077Tokens := by exact .simple _ _ (by rfl)

def node078 : Stmt := .skip
def node078Tokens : List B20.C.Token := []
theorem node078_source : Body node078 node078Tokens := by exact .nil

def node079 : Stmt := (.seq node077 node078)
def node079Tokens : List B20.C.Token := node077Tokens++node078Tokens
theorem node079_source : Body node079 node079Tokens := by exact .cons _ _ _ _ node077_source node078_source

end FT1536.Source3.KeygenMakeBinding
