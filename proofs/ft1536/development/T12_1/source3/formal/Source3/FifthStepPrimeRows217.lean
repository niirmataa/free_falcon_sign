import Source3.FifthStepFirst217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FifthStepPrimeRows217
open KeygenStaticTables (rows row values)

def v12 : Nat×Nat×Nat := (2146738177,1162041962,196967660)
theorem row12 : ((rows .ternary)[12]?).bind row=some v12 := by decide +kernel
theorem row12_value : (values .ternary)[12]?=some v12 := (KeygenStaticReads.indexed_source .ternary 12).symm.trans row12

def v13 : Nat×Nat×Nat := (2146646017,726398168,672200588)
theorem row13 : ((rows .ternary)[13]?).bind row=some v13 := by decide +kernel
theorem row13_value : (values .ternary)[13]?=some v13 := (KeygenStaticReads.indexed_source .ternary 13).symm.trans row13

def v14 : Nat×Nat×Nat := (2146599937,1057553451,1817004162)
theorem row14 : ((rows .ternary)[14]?).bind row=some v14 := by decide +kernel
theorem row14_value : (values .ternary)[14]?=some v14 := (KeygenStaticReads.indexed_source .ternary 14).symm.trans row14

def v15 : Nat×Nat×Nat := (2146572289,637715109,269732777)
theorem row15 : ((rows .ternary)[15]?).bind row=some v15 := by decide +kernel
theorem row15_value : (values .ternary)[15]?=some v15 := (KeygenStaticReads.indexed_source .ternary 15).symm.trans row15

def v16 : Nat×Nat×Nat := (2146544641,444752022,1328058681)
theorem row16 : ((rows .ternary)[16]?).bind row=some v16 := by decide +kernel
theorem row16_value : (values .ternary)[16]?=some v16 := (KeygenStaticReads.indexed_source .ternary 16).symm.trans row16

def v17 : Nat×Nat×Nat := (2146507777,490896612,838252098)
theorem row17 : ((rows .ternary)[17]?).bind row=some v17 := by decide +kernel
theorem row17_value : (values .ternary)[17]?=some v17 := (KeygenStaticReads.indexed_source .ternary 17).symm.trans row17

def v18 : Nat×Nat×Nat := (2146406401,1004568183,869184085)
theorem row18 : ((rows .ternary)[18]?).bind row=some v18 := by decide +kernel
theorem row18_value : (values .ternary)[18]?=some v18 := (KeygenStaticReads.indexed_source .ternary 18).symm.trans row18

def v19 : Nat×Nat×Nat := (2146378753,2116137511,721799116)
theorem row19 : ((rows .ternary)[19]?).bind row=some v19 := by decide +kernel
theorem row19_value : (values .ternary)[19]?=some v19 := (KeygenStaticReads.indexed_source .ternary 19).symm.trans row19

def v20 : Nat×Nat×Nat := (2146203649,1543684282,978176226)
theorem row20 : ((rows .ternary)[20]?).bind row=some v20 := by decide +kernel
theorem row20_value : (values .ternary)[20]?=some v20 := (KeygenStaticReads.indexed_source .ternary 20).symm.trans row20

def v21 : Nat×Nat×Nat := (2146093057,523004126,855356548)
theorem row21 : ((rows .ternary)[21]?).bind row=some v21 := by decide +kernel
theorem row21_value : (values .ternary)[21]?=some v21 := (KeygenStaticReads.indexed_source .ternary 21).symm.trans row21

end FT1536.Source3.FifthStepPrimeRows217
