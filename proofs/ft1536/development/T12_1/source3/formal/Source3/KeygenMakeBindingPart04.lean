import Source3.KeygenMakeBindingPart03

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

def node109 : Stmt := (.seq node027 node108)
def node109Tokens : List B20.C.Token := node027Tokens++node108Tokens
theorem node109_source : Body node109 node109Tokens := by exact .cons _ _ _ _ node027_source node108_source

def node110 : Stmt := (.seq node026 node109)
def node110Tokens : List B20.C.Token := node026Tokens++node109Tokens
theorem node110_source : Body node110 node110Tokens := by exact .cons _ _ _ _ node026_source node109_source

def node111 : Stmt := (.seq node025 node110)
def node111Tokens : List B20.C.Token := node025Tokens++node110Tokens
theorem node111_source : Body node111 node111Tokens := by exact .cons _ _ _ _ node025_source node110_source

def node112 : Stmt := (.seq node024 node111)
def node112Tokens : List B20.C.Token := node024Tokens++node111Tokens
theorem node112_source : Body node112 node112Tokens := by exact .cons _ _ _ _ node024_source node111_source

def node113 : Stmt := (.seq node023 node112)
def node113Tokens : List B20.C.Token := node023Tokens++node112Tokens
theorem node113_source : Body node113 node113Tokens := by exact .cons _ _ _ _ node023_source node112_source

def node114 : Stmt := (.seq node018 node113)
def node114Tokens : List B20.C.Token := node018Tokens++node113Tokens
theorem node114_source : Body node114 node114Tokens := by exact .cons _ _ _ _ node018_source node113_source

def node115 : Stmt := (.scope node114)
def node115Tokens : List B20.C.Token := [['{']]++node114Tokens++[['}']]
theorem node115_source : Statement node115 node115Tokens := by exact .scope _ _ node114_source

def node116 : Stmt := (.declare [⟨"rt1".toList,(.pointer .fpr),none⟩,⟨"rt2".toList,(.pointer .fpr),none⟩,⟨"rt3".toList,(.pointer .fpr),none⟩])
def node116Tokens : List B20.C.Token := ["fpr","*","rt1",",","*","rt2",",","*","rt3",";"].map String.toList
theorem node116_source : Statement node116 node116Tokens := by exact .simple _ _ (by rfl)

def node117 : Stmt := (.declare [⟨"bnorm".toList,.fpr,none⟩])
def node117Tokens : List B20.C.Token := ["fpr","bnorm",";"].map String.toList
theorem node117_source : Statement node117 node117Tokens := by exact .simple _ _ (by rfl)

def node118 : Stmt := (.declare [⟨"normf".toList,.u32,none⟩,⟨"normg".toList,.u32,none⟩,⟨"norm".toList,.u32,none⟩])
def node118Tokens : List B20.C.Token := ["uint32_t","normf",",","normg",",","norm",";"].map String.toList
theorem node118_source : Statement node118 node118Tokens := by exact .simple _ _ (by rfl)

def node119 : Stmt := (.evaluate (.call .mkgauss (argumentTree [(.variable "fk".toList),(.variable "f".toList),(.variable "logn".toList)])))
def node119Tokens : List B20.C.Token := ["poly_small_mkgauss","(","fk",",","f",",","logn",")",";"].map String.toList
theorem node119_source : Statement node119 node119Tokens := by exact .simple _ _ (by rfl)

def node120 : Stmt := (.evaluate (.call .mkgauss (argumentTree [(.variable "fk".toList),(.variable "g".toList),(.variable "logn".toList)])))
def node120Tokens : List B20.C.Token := ["poly_small_mkgauss","(","fk",",","g",",","logn",")",";"].map String.toList
theorem node120_source : Statement node120 node120Tokens := by exact .simple _ _ (by rfl)

def node121 : Stmt := (.write (.variable "normf".toList) .set (.call .sqnorm (argumentTree [(.variable "f".toList),(.variable "logn".toList),(.variable "ter".toList)])))
def node121Tokens : List B20.C.Token := ["normf","=","poly_small_sqnorm","(","f",",","logn",",","ter",")",";"].map String.toList
theorem node121_source : Statement node121 node121Tokens := by exact .simple _ _ (by rfl)

def node122 : Stmt := (.write (.variable "normg".toList) .set (.call .sqnorm (argumentTree [(.variable "g".toList),(.variable "logn".toList),(.variable "ter".toList)])))
def node122Tokens : List B20.C.Token := ["normg","=","poly_small_sqnorm","(","g",",","logn",",","ter",")",";"].map String.toList
theorem node122_source : Statement node122 node122Tokens := by exact .simple _ _ (by rfl)

def node123 : Stmt := (.write (.variable "norm".toList) .set (.binary .bor (.binary .add (.variable "normf".toList) (.variable "normg".toList)) (.unary .neg (.binary .shr (.binary .bor (.variable "normf".toList) (.variable "normg".toList)) (.number .i32 31)))))
def node123Tokens : List B20.C.Token := ["norm","=","(","normf","+","normg",")","|","-","(","(","normf","|","normg",")",">>","31",")",";"].map String.toList
theorem node123_source : Statement node123 node123Tokens := by exact .simple _ _ (by rfl)

def node124 : Stmt := .continueLoop
def node124Tokens : List B20.C.Token := ["continue",";"].map String.toList
theorem node124_source : Statement node124 node124Tokens := by exact .simple _ _ (by rfl)

def node125 : Stmt := .skip
def node125Tokens : List B20.C.Token := []
theorem node125_source : Body node125 node125Tokens := by exact .nil

def node126 : Stmt := (.seq node124 node125)
def node126Tokens : List B20.C.Token := node124Tokens++node125Tokens
theorem node126_source : Body node126 node126Tokens := by exact .cons _ _ _ _ node124_source node125_source

def node127 : Stmt := (.scope node126)
def node127Tokens : List B20.C.Token := [['{']]++node126Tokens++[['}']]
theorem node127_source : Statement node127 node127Tokens := by exact .scope _ _ node126_source

def guard128 : Expr := (.binary .ge (.variable "norm".toList) (.number .i32 16823))
def guard128Tokens : List B20.C.Token := ["norm",">=","16823"].map String.toList
theorem guard128_source : guard guard128 guard128Tokens := by rfl

def node128 : Stmt := (.branch guard128 node127 .skip)
def node128Tokens : List B20.C.Token := ["if".toList,['(']]++guard128Tokens++[[')']]++node127Tokens
theorem node128_source : Statement node128 node128Tokens := by exact .ifOnly _ _ _ _ guard128_source node127_source

def node129 : Stmt := (.write (.variable "rt1".toList) .set (.cast (.pointer .fpr) (.member (.variable "fk".toList) "tmp".toList)))
def node129Tokens : List B20.C.Token := ["rt1","=","(","fpr","*",")","fk","-",">","tmp",";"].map String.toList
theorem node129_source : Statement node129 node129Tokens := by exact .simple _ _ (by rfl)

def node130 : Stmt := (.write (.variable "rt2".toList) .set (.binary .add (.variable "rt1".toList) (.variable "n".toList)))
def node130Tokens : List B20.C.Token := ["rt2","=","rt1","+","n",";"].map String.toList
theorem node130_source : Statement node130 node130Tokens := by exact .simple _ _ (by rfl)

def node131 : Stmt := (.write (.variable "rt3".toList) .set (.binary .add (.variable "rt2".toList) (.variable "n".toList)))
def node131Tokens : List B20.C.Token := ["rt3","=","rt2","+","n",";"].map String.toList
theorem node131_source : Statement node131 node131Tokens := by exact .simple _ _ (by rfl)

def node132 : Stmt := (.evaluate (.call .smallToFp (argumentTree [(.variable "rt1".toList),(.variable "f".toList),(.variable "logn".toList),(.number .i32 0)])))
def node132Tokens : List B20.C.Token := ["poly_small_to_fp","(","rt1",",","f",",","logn",",","0",")",";"].map String.toList
theorem node132_source : Statement node132 node132Tokens := by exact .simple _ _ (by rfl)

def node133 : Stmt := (.evaluate (.call .smallToFp (argumentTree [(.variable "rt2".toList),(.variable "g".toList),(.variable "logn".toList),(.number .i32 0)])))
def node133Tokens : List B20.C.Token := ["poly_small_to_fp","(","rt2",",","g",",","logn",",","0",")",";"].map String.toList
theorem node133_source : Statement node133 node133Tokens := by exact .simple _ _ (by rfl)

def node134 : Stmt := (.evaluate (.call .fft (argumentTree [(.variable "rt1".toList),(.variable "logn".toList)])))
def node134Tokens : List B20.C.Token := ["falcon_FFT","(","rt1",",","logn",")",";"].map String.toList
theorem node134_source : Statement node134 node134Tokens := by exact .simple _ _ (by rfl)

def node135 : Stmt := (.evaluate (.call .fft (argumentTree [(.variable "rt2".toList),(.variable "logn".toList)])))
def node135Tokens : List B20.C.Token := ["falcon_FFT","(","rt2",",","logn",")",";"].map String.toList
theorem node135_source : Statement node135 node135Tokens := by exact .simple _ _ (by rfl)

def node136 : Stmt := (.evaluate (.call .invnorm (argumentTree [(.variable "rt3".toList),(.variable "rt1".toList),(.variable "rt2".toList),(.variable "logn".toList)])))
def node136Tokens : List B20.C.Token := ["falcon_poly_invnorm2_fft","(","rt3",",","rt1",",","rt2",",","logn",")",";"].map String.toList
theorem node136_source : Statement node136 node136Tokens := by exact .simple _ _ (by rfl)

def node137 : Stmt := (.evaluate (.call .adj (argumentTree [(.variable "rt1".toList),(.variable "logn".toList)])))
def node137Tokens : List B20.C.Token := ["falcon_poly_adj_fft","(","rt1",",","logn",")",";"].map String.toList
theorem node137_source : Statement node137 node137Tokens := by exact .simple _ _ (by rfl)

end FT1536.Source3.KeygenMakeBinding
