import Source3.FourthStepFirst216

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FourthStepPrimeRows216
open KeygenStaticTables (rows row values)

def v6 : Nat×Nat×Nat := (2147079169,884642355,1325537405)
theorem row6 : ((rows .ternary)[6]?).bind row=some v6 := by decide +kernel
theorem row6_value : (values .ternary)[6]?=some v6 := (KeygenStaticReads.indexed_source .ternary 6).symm.trans row6

def v7 : Nat×Nat×Nat := (2147051521,2049970231,846062571)
theorem row7 : ((rows .ternary)[7]?).bind row=some v7 := by decide +kernel
theorem row7_value : (values .ternary)[7]?=some v7 := (KeygenStaticReads.indexed_source .ternary 7).symm.trans row7

def v8 : Nat×Nat×Nat := (2146959361,565744180,131144629)
theorem row8 : ((rows .ternary)[8]?).bind row=some v8 := by decide +kernel
theorem row8_value : (values .ternary)[8]?=some v8 := (KeygenStaticReads.indexed_source .ternary 8).symm.trans row8

def v9 : Nat×Nat×Nat := (2146885633,328643105,798140427)
theorem row9 : ((rows .ternary)[9]?).bind row=some v9 := by decide +kernel
theorem row9_value : (values .ternary)[9]?=some v9 := (KeygenStaticReads.indexed_source .ternary 9).symm.trans row9

def v10 : Nat×Nat×Nat := (2146775041,797860046,68264718)
theorem row10 : ((rows .ternary)[10]?).bind row=some v10 := by decide +kernel
theorem row10_value : (values .ternary)[10]?=some v10 := (KeygenStaticReads.indexed_source .ternary 10).symm.trans row10

def v11 : Nat×Nat×Nat := (2146756609,1681396397,459938921)
theorem row11 : ((rows .ternary)[11]?).bind row=some v11 := by decide +kernel
theorem row11_value : (values .ternary)[11]?=some v11 := (KeygenStaticReads.indexed_source .ternary 11).symm.trans row11

end FT1536.Source3.FourthStepPrimeRows216
