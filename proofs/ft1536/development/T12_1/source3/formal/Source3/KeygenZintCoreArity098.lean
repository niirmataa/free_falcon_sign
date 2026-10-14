import Source3.KeygenZintDeterminism098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenZintCoreArity098
open KeygenZintCall
open KeygenZintDeterminism098 (checkedCode)

theorem leaf (kind : KeygenZintLeaves.Kind) : checkedCode (calleeBody (.leaf kind)) = true :=
  KeygenZintLeafDet097.body_checked kind

theorem modSigned : checkedCode (calleeBody .modSigned) = true := by decide +kernel
theorem normZero : checkedCode (calleeBody .normZero) = true := by decide +kernel
theorem exactLen : checkedCode (calleeBody .exactLen) = true := by decide +kernel
theorem rshiftMod : checkedCode (calleeBody .rshiftMod) = true := by decide +kernel
theorem subMod : checkedCode (calleeBody .subMod) = true := by decide +kernel
theorem rebuildCrt : checkedCode (calleeBody .rebuildCrt) = true := by decide +kernel
theorem coReduce : checkedCode (calleeBody .coReduce) = true := by decide +kernel
theorem coReduceMod : checkedCode (calleeBody .coReduceMod) = true := by decide +kernel
theorem reduce : checkedCode (calleeBody .reduce) = true := by decide +kernel
theorem reduceMod : checkedCode (calleeBody .reduceMod) = true := by decide +kernel

end FT1536.Source3.KeygenZintCoreArity098
