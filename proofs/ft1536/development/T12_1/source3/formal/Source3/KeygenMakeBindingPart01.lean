import Source3.KeygenMakeBindingPart00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

def node028 : Stmt := (.write (.variable "rt3".toList) .set (.binary .add (.variable "rt2".toList) (.variable "n".toList)))
def node028Tokens : List B20.C.Token := ["rt3","=","rt2","+","n",";"].map String.toList
theorem node028_source : Statement node028 node028Tokens := by exact .simple _ _ (by rfl)

def node029 : Stmt := (.evaluate (.call .sample (argumentTree [(.variable "fk".toList),(.variable "f".toList),(.variable "n".toList)])))
def node029Tokens : List B20.C.Token := ["sample_true_ternary_secret","(","fk",",","f",",","n",")",";"].map String.toList
theorem node029_source : Statement node029 node029Tokens := by exact .simple _ _ (by rfl)
run_cmd IO.FS.writeFile "../MAKE_BINDING_PART01_PROGRESS.json" "{\"boundary\":\"node029\"}\n"

def node030 : Stmt := (.evaluate (.call .sample (argumentTree [(.variable "fk".toList),(.variable "g".toList),(.variable "n".toList)])))
def node030Tokens : List B20.C.Token := ["sample_true_ternary_secret","(","fk",",","g",",","n",")",";"].map String.toList
theorem node030_source : Statement node030 node030Tokens := by exact .simple _ _ (by rfl)

def node031 : Stmt := .continueLoop
def node031Tokens : List B20.C.Token := ["continue",";"].map String.toList
theorem node031_source : Statement node031 node031Tokens := by exact .simple _ _ (by rfl)

def node032 : Stmt := .skip
def node032Tokens : List B20.C.Token := []
theorem node032_source : Body node032 node032Tokens := by exact .nil

def node033 : Stmt := (.seq node031 node032)
def node033Tokens : List B20.C.Token := node031Tokens++node032Tokens
theorem node033_source : Body node033 node033Tokens := by exact .cons _ _ _ _ node031_source node032_source

def node034 : Stmt := (.scope node033)
def node034Tokens : List B20.C.Token := [['{']]++node033Tokens++[['}']]
theorem node034_source : Statement node034 node034Tokens := by exact .scope _ _ node033_source

def guard035 : Expr := (.binary .eq (.call .resultant (argumentTree [(.variable "f".toList),(.variable "logn".toList)])) (.number .i32 0))
def guard035Tokens : List B20.C.Token := ["mod2_res_ternary","(","f",",","logn",")","==","0"].map String.toList
theorem guard035_source : guard guard035 guard035Tokens := by rfl
run_cmd IO.FS.writeFile "../MAKE_BINDING_PART01_PROGRESS.json" "{\"boundary\":\"guard035\"}\n"

def node035 : Stmt := (.branch guard035 node034 .skip)
def node035Tokens : List B20.C.Token := ["if".toList,['(']]++guard035Tokens++[[')']]++node034Tokens
theorem node035_source : Statement node035 node035Tokens := by exact .ifOnly _ _ _ _ guard035_source node034_source

def node036 : Stmt := .continueLoop
def node036Tokens : List B20.C.Token := ["continue",";"].map String.toList
theorem node036_source : Statement node036 node036Tokens := by exact .simple _ _ (by rfl)

def node037 : Stmt := .skip
def node037Tokens : List B20.C.Token := []
theorem node037_source : Body node037 node037Tokens := by exact .nil

def node038 : Stmt := (.seq node036 node037)
def node038Tokens : List B20.C.Token := node036Tokens++node037Tokens
theorem node038_source : Body node038 node038Tokens := by exact .cons _ _ _ _ node036_source node037_source

def node039 : Stmt := (.scope node038)
def node039Tokens : List B20.C.Token := [['{']]++node038Tokens++[['}']]
theorem node039_source : Statement node039 node039Tokens := by exact .scope _ _ node038_source

def guard040 : Expr := (.binary .eq (.call .resultant (argumentTree [(.variable "g".toList),(.variable "logn".toList)])) (.number .i32 0))
def guard040Tokens : List B20.C.Token := ["mod2_res_ternary","(","g",",","logn",")","==","0"].map String.toList
theorem guard040_source : guard guard040 guard040Tokens := by rfl
run_cmd IO.FS.writeFile "../MAKE_BINDING_PART01_PROGRESS.json" "{\"boundary\":\"guard040\"}\n"

def node040 : Stmt := (.branch guard040 node039 .skip)
def node040Tokens : List B20.C.Token := ["if".toList,['(']]++guard040Tokens++[[')']]++node039Tokens
theorem node040_source : Statement node040 node040Tokens := by exact .ifOnly _ _ _ _ guard040_source node039_source

def node041 : Stmt := (.write (.variable "bound".toList) .set (.call .div (argumentTree [(.call .of (argumentTree [(.binary .mul (.number .long 73732) (.cast .long (.variable "n".toList)))])),(.call .sqrt (argumentTree [(.call .of (argumentTree [(.number .i32 8)]))]))])))
def node041Tokens : List B20.C.Token := ["bound","=","fpr_div","(","fpr_of","(","73732L","*","(","long",")","n",")",",","fpr_sqrt","(","fpr_of","(","8",")",")",")",";"].map String.toList
theorem node041_source : Statement node041 node041Tokens := by exact .simple _ _ (by decide +kernel)
run_cmd IO.FS.writeFile "../MAKE_BINDING_PART01_PROGRESS.json" "{\"boundary\":\"node041\"}\n"

def node042 : Stmt := (.write (.variable "bound".toList) .set (.call .div (argumentTree [(.call .mul (argumentTree [(.variable "bound".toList),(.call .of (argumentTree [(.number .i32 1250)]))])),(.call .of (argumentTree [(.number .i32 100)]))])))
def node042Tokens : List B20.C.Token := ["bound","=","fpr_div","(","fpr_mul","(","bound",",","fpr_of","(","1250",")",")",",","fpr_of","(","100",")",")",";"].map String.toList
theorem node042_source : Statement node042 node042Tokens := by exact .simple _ _ (by decide +kernel)

def node043 : Stmt := (.evaluate (.call .smallToFp (argumentTree [(.variable "rt1".toList),(.variable "f".toList),(.variable "logn".toList),(.number .i32 1)])))
def node043Tokens : List B20.C.Token := ["poly_small_to_fp","(","rt1",",","f",",","logn",",","1",")",";"].map String.toList
theorem node043_source : Statement node043 node043Tokens := by exact .simple _ _ (by rfl)

def node044 : Stmt := (.evaluate (.call .smallToFp (argumentTree [(.variable "rt2".toList),(.variable "g".toList),(.variable "logn".toList),(.number .i32 1)])))
def node044Tokens : List B20.C.Token := ["poly_small_to_fp","(","rt2",",","g",",","logn",",","1",")",";"].map String.toList
theorem node044_source : Statement node044 node044Tokens := by exact .simple _ _ (by rfl)

def node045 : Stmt := (.evaluate (.call .fft3 (argumentTree [(.variable "rt1".toList),(.variable "logn".toList),(.number .i32 1)])))
def node045Tokens : List B20.C.Token := ["falcon_FFT3","(","rt1",",","logn",",","1",")",";"].map String.toList
theorem node045_source : Statement node045 node045Tokens := by exact .simple _ _ (by rfl)

def node046 : Stmt := (.evaluate (.call .fft3 (argumentTree [(.variable "rt2".toList),(.variable "logn".toList),(.number .i32 1)])))
def node046Tokens : List B20.C.Token := ["falcon_FFT3","(","rt2",",","logn",",","1",")",";"].map String.toList
theorem node046_source : Statement node046 node046Tokens := by exact .simple _ _ (by rfl)

def node047 : Stmt := (.write (.variable "norm".toList) .set (.call .of (argumentTree [(.number .i32 0)])))
def node047Tokens : List B20.C.Token := ["norm","=","fpr_of","(","0",")",";"].map String.toList
theorem node047_source : Statement node047 node047Tokens := by exact .simple _ _ (by rfl)

def node048 : Stmt := (.write (.variable "norm".toList) .set (.call .add (argumentTree [(.variable "norm".toList),(.call .sqr (argumentTree [(.index (.variable "rt1".toList) (.variable "u".toList))]))])))
def node048Tokens : List B20.C.Token := ["norm","=","fpr_add","(","norm",",","fpr_sqr","(","rt1","[","u","]",")",")",";"].map String.toList
theorem node048_source : Statement node048 node048Tokens := by exact .simple _ _ (by decide +kernel)

def node049 : Stmt := (.write (.variable "norm".toList) .set (.call .add (argumentTree [(.variable "norm".toList),(.call .sqr (argumentTree [(.index (.variable "rt2".toList) (.variable "u".toList))]))])))
def node049Tokens : List B20.C.Token := ["norm","=","fpr_add","(","norm",",","fpr_sqr","(","rt2","[","u","]",")",")",";"].map String.toList
theorem node049_source : Statement node049 node049Tokens := by exact .simple _ _ (by decide +kernel)

def node050 : Stmt := .skip
def node050Tokens : List B20.C.Token := []
theorem node050_source : Body node050 node050Tokens := by exact .nil

def node051 : Stmt := (.seq node049 node050)
def node051Tokens : List B20.C.Token := node049Tokens++node050Tokens
theorem node051_source : Body node051 node051Tokens := by exact .cons _ _ _ _ node049_source node050_source

def node052 : Stmt := (.seq node048 node051)
def node052Tokens : List B20.C.Token := node048Tokens++node051Tokens
theorem node052_source : Body node052 node052Tokens := by exact .cons _ _ _ _ node048_source node051_source

def node053 : Stmt := (.scope node052)
def node053Tokens : List B20.C.Token := [['{']]++node052Tokens++[['}']]
theorem node053_source : Statement node053 node053Tokens := by exact .scope _ _ node052_source

def loop054Init : Stmt := (.write (.variable "u".toList) .set (.number .i32 0))
def loop054Update : Stmt := (.increment (.variable "u".toList))
def loop054Test : Option Expr := (some (.binary .lt (.variable "u".toList) (.variable "n".toList)))
def loop054First : List B20.C.Token := ["u","=","0"].map String.toList
def loop054Middle : List B20.C.Token := ["u","<","n"].map String.toList
def loop054Last : List B20.C.Token := ["u","++"].map String.toList
theorem loop054_initial : initialClause loop054Init loop054First := by rfl
theorem loop054_increment : incrementClause loop054Update loop054Last := by rfl
end FT1536.Source3.KeygenMakeBinding
