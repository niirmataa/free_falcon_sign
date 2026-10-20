import Source3.SelectedStepChain193
import Source3.MakeFgInverseShape192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC workshop record (not proof evidence): the draft
   caller-local safety checker of the s0-s3 re-assembly, with the values
   it takes on the projections of the parsed s3 tree. The draft checker
   rejected the false-ter projection terNoCall (and its supersets) while
   accepting the skip leaf, the inverse call leaf and the true-ter
   subtree; the accepted checker accepts base-layer statement calls
   (whose rule returns the caller state with the callee heap) and scope
   bodies with arbitrary restore lists. -/
namespace FT1536.Source3.NttInverseLocalSafeProbe194

def arraySafe : C99ArrayReference.Stmt → Bool
  | .skip => true
  | _ => false

def modularSafe : C99ModularReference.Stmt → Bool
  | .base code => arraySafe code
  | _ => false

def levelSafe : KeygenLevelExec.Stmt → Bool
  | .modular code => modularSafe code
  | .call _ _ => true
  | _ => false

def localSafe : KeygenMakeFgSource.Stmt → Bool
  | .level body => levelSafe body
  | .seq a b => localSafe a && localSafe b
  | .branch _ a b => localSafe a && localSafe b
  | .scope locals pointers a => locals.isEmpty && pointers.isEmpty && localSafe a
  | _ => false

example : localSafe KeygenMakeFgSource.skip = true := by decide
example : localSafe MakeFgInverseShape192.inverseCall = true := by decide
example : localSafe MakeFgInverseShape192.terYes = true := by decide
example : localSafe MakeFgInverseShape192.terNoCall = false := by decide
example : localSafe MakeFgInverseShape192.terNo = false := by decide
example : localSafe MakeFgInverseShape192.terBranch = false := by decide
example : localSafe MakeFgInverseShape192.inner = false := by decide
example : localSafe MakeFgTailShape190.s3Yes = false := by decide
example : localSafe MakeFgTailShape190.s3 = false := by decide

end FT1536.Source3.NttInverseLocalSafeProbe194
