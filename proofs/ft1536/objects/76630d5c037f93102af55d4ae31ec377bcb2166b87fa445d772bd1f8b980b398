import Source3.CRefWord
import Source3.KeygenHelpers

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StablePositive
open B20.C CLogic KeygenHelpers CRefWord

def pureCalls : B20.C.Scalar.Calls := fun name args =>
  if name=positiveName then CLogic.execute KeygenHelpers.calls positiveProgram args
  else KeygenHelpers.calls name args

theorem positive_call (w : BitVec 64) : pureCalls positiveName [.u64 w]=some (boolean (Run2.KeygenLeafGate.positive w)) := by
  simp only [pureCalls,ite_true,positive_execution]
theorem bits_call (w : BitVec 64) : pureCalls bitsName [.u64 w]=some (.u64 w) := by
  have hn : bitsName≠positiveName := by decide
  simp only [pureCalls,hn,ite_false,KeygenHelpers.bits_call]
theorem fromBits_call (w : BitVec 64) : pureCalls fromBitsName [.u64 w]=some (.u64 w) := by
  have hp : fromBitsName≠positiveName := by decide
  have hb : fromBitsName≠bitsName := by decide
  simp only [pureCalls,hp,ite_false,KeygenHelpers.calls,hb,ite_true,fromBits_execution,Option.map_some]

def globals : Globals := fun name => if name="fpr_one".toList then some (.u64 Run2.KeygenLeafGate.oneBits) else none

theorem one_source : Pinned.fprLines[76]?=some "static const fpr fpr_one = 0x3ff0000000000000ULL;\n" := by decide

def program : CRefWord.Function where
  name := "ft_stable_positive_keygen".toList
  result := .u64
  params := [.word .u64 "x".toList,.ref32 "bad".toList]
  body := [
    .localStmt (.declare .u64 ["mask".toList,"xb".toList]),
    .localStmt (.declare .u32 ["valid".toList]),
    .localStmt (.assign "valid".toList (.cast .u32 (.call1 positiveName (.var "x".toList)))),
    .updateRef "bad".toList .bor (.bin .xor (.var "valid".toList) (.literal .u32 1)),
    .localStmt (.assign "mask".toList (.bin .sub (.cast .u64 (.literal .i32 0)) (.cast .u64 (.var "valid".toList)))),
    .localStmt (.assign "xb".toList (.call1 bitsName (.var "x".toList))),
    .localStmt (.ret (.call1 fromBitsName (.bin .bor
      (.bin .band (.var "xb".toList) (.var "mask".toList))
      (.bin .band (.call1 bitsName (.var "fpr_one".toList)) (.bitNot (.var "mask".toList))))))]

theorem source_parses : CRefWord.parse (slice 7477 12)=some program := by decide

theorem execute_word (w : BitVec 64) (bad : BitVec 32) (m : Heap) (p : Nat) (hp : m p=some bad) :
    CRefWord.execute pureCalls globals program m [.word (.u64 w),.ref32 p]=
      some (.u64 (Run2.KeygenLeafGate.stableWord w),store m p (Run2.KeygenLeafGate.stableBad w bad)) := by
  cases hw : Run2.KeygenLeafGate.positive w <;>
    simp [CRefWord.execute,program,CRefWord.bindArgs,CRefWord.evalBody,CRefWord.step,CRefWord.values,
      B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,B20.C.Scalar.assign,B20.C.update,
      CLogic.eval,globals,positive_call,bits_call,fromBits_call,hp,hw,
      B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,B20.C.bitsOp,
      CLogic.boolean,B20.C.notBits,Run2.KeygenLeafGate.stableWord_cases,Run2.KeygenLeafGate.stableBad,
      Run2.KeygenLeafGate.positiveFlag]
  all_goals exact BitVec.and_allOnes

theorem source_refines (w : BitVec 64) (bad : BitVec 32) (m : Heap) (p : Nat) (hp : m p=some bad) :
    (CRefWord.parse (slice 7477 12)).bind
      (fun f => CRefWord.execute pureCalls globals f m [.word (.u64 w),.ref32 p])=
      some (.u64 (Run2.KeygenLeafGate.stableWord w),store m p (Run2.KeygenLeafGate.stableBad w bad)) := by
  rw [source_parses,Option.bind_some,execute_word w bad m p hp]

theorem clear_result (w : BitVec 64) (bad : BitVec 32)
    (hc : Run2.KeygenLeafGate.stableBad w bad=0#32) :
    bad=0#32 ∧ Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w := by
  obtain ⟨hb,hp⟩:=Run2.KeygenLeafGate.stableBad_clear w bad |>.mp hc
  exact ⟨hb,hp,by rw [Run2.KeygenLeafGate.stableWord_cases,hp]; rfl⟩

end FT1536.Source3.StablePositive

#print FT1536.Source3.StablePositive.source_refines
#print axioms FT1536.Source3.StablePositive.source_parses
#print axioms FT1536.Source3.StablePositive.source_refines
#print axioms FT1536.Source3.StablePositive.clear_result
