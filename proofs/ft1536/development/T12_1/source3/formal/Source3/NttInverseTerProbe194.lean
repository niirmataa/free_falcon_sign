import Source3.SelectedStepChain193
import Source3.MakeFgInverseShape192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC workshop record (not proof evidence): the statement form of
   the false-ter projection terNoCall of the parsed s3 tree, by layer.
   The probe identified the make-level binary call form
   (`modp_iNTT2_ext` is bound through KeygenBinaryNtt) as the only
   matching layer; every other candidate form is recorded refuted. -/
namespace FT1536.Source3.NttInverseTerProbe194

def t01 : KeygenMakeFgSource.Stmt → Bool | .level _ => true | _ => false
def t02 : KeygenMakeFgSource.Stmt → Bool | .zint _ => true | _ => false
def t03 : KeygenMakeFgSource.Stmt → Bool | .word _ => true | _ => false
def t04 : KeygenMakeFgSource.Stmt → Bool | .binary _ _ => true | _ => false
def t05 : KeygenMakeFgSource.Stmt → Bool | .top _ => true | _ => false
def t06 : KeygenMakeFgSource.Stmt → Bool | .step _ => true | _ => false
def t07 : KeygenMakeFgSource.Stmt → Bool | .seq _ _ => true | _ => false
def t08 : KeygenMakeFgSource.Stmt → Bool | .scope _ _ _ => true | _ => false
def t09 : KeygenMakeFgSource.Stmt → Bool | .branch _ _ _ => true | _ => false
def t10 : KeygenMakeFgSource.Stmt → Bool | .loop _ _ _ => true | _ => false

example : t01 MakeFgInverseShape192.terNoCall = false := by decide
example : t02 MakeFgInverseShape192.terNoCall = false := by decide
example : t03 MakeFgInverseShape192.terNoCall = false := by decide
example : t04 MakeFgInverseShape192.terNoCall = true := by decide
example : t05 MakeFgInverseShape192.terNoCall = false := by decide
example : t06 MakeFgInverseShape192.terNoCall = false := by decide
example : t07 MakeFgInverseShape192.terNoCall = false := by decide
example : t08 MakeFgInverseShape192.terNoCall = false := by decide
example : t09 MakeFgInverseShape192.terNoCall = false := by decide
example : t10 MakeFgInverseShape192.terNoCall = false := by decide

end FT1536.Source3.NttInverseTerProbe194
