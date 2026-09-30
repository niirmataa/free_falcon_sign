import Source3.BitcastObjects
import Source3.KeygenSource
import Run2.KeygenLeafGate

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenHelpers
open B20.C CLogic

def slice (start count : Nat) : List Char :=
  ((Pinned.keygenLines.drop start).take count).flatMap String.toList

def bitsName : B20.C.Name := "ft_fpr_bits_keygen".toList
def fromBitsName : B20.C.Name := "ft_fpr_from_bits_keygen".toList
def positiveName : B20.C.Name := "ft_fpr_is_positive_finite_keygen".toList

def bitsProgram : BitcastObjects.Function :=
  ⟨bitsName,"x".toList,"w".toList,"w".toList,"x".toList,"w".toList,"w".toList⟩
def fromBitsProgram : BitcastObjects.Function :=
  ⟨fromBitsName,"w".toList,"x".toList,"x".toList,"w".toList,"x".toList,"x".toList⟩

theorem fpr_typedef_source : Pinned.fprLines[15]?=some "typedef uint64_t fpr;\n" := by decide

theorem bits_parses : BitcastObjects.parse (slice 7452 7)=some bitsProgram := by decide
theorem fromBits_parses : BitcastObjects.parse (slice 7460 7)=some fromBitsProgram := by decide

theorem bits_execution (w : BitVec 64) : BitcastObjects.execute bitsProgram w=some w :=
  BitcastObjects.copy_local_roundtrip bitsName "x".toList "w".toList (by decide) w
theorem fromBits_execution (w : BitVec 64) : BitcastObjects.execute fromBitsProgram w=some w :=
  BitcastObjects.copy_local_roundtrip fromBitsName "w".toList "x".toList (by decide) w

theorem bits_source_refines (w : BitVec 64) :
    (BitcastObjects.parse (slice 7452 7)).bind (fun f => BitcastObjects.execute f w)=some w := by
  rw [bits_parses,Option.bind_some,bits_execution]
theorem fromBits_source_refines (w : BitVec 64) :
    (BitcastObjects.parse (slice 7460 7)).bind (fun f => BitcastObjects.execute f w)=some w := by
  rw [fromBits_parses,Option.bind_some,fromBits_execution]

def calls : B20.C.Scalar.Calls := fun name args =>
  match args with
  | [.u64 w] =>
      if name=bitsName then (BitcastObjects.execute bitsProgram w).map Val.u64
      else if name=fromBitsName then (BitcastObjects.execute fromBitsProgram w).map Val.u64
      else none
  | _ => none

theorem bits_call (w : BitVec 64) : calls bitsName [.u64 w]=some (.u64 w) := by
  simp only [calls,ite_true,bits_execution,Option.map_some]

def positiveProgram : CLogic.Function where
  name := positiveName
  result := .i32
  params := [(.u64,"x".toList)]
  body := [
    .declare .u64 ["w".toList,"e".toList],
    .assign "w".toList (.call1 bitsName (.var "x".toList)),
    .assign "e".toList (.bin .band (.bin .shr (.var "w".toList) (.literal .i32 52)) (.literal .i32 0x7FF)),
    .ret (.cast .i32 (.land
      (.land (.cmp .eq (.bin .shr (.var "w".toList) (.literal .i32 63)) (.literal .i32 0))
        (.cmp .ne (.var "e".toList) (.literal .i32 0x7FF)))
      (.cmp .ne (.bin .shl (.var "w".toList) (.literal .i32 1)) (.literal .i32 0))))]

theorem positive_parses : CLogicParser.parseFunction (slice 7468 8)=some positiveProgram := by decide

theorem cast_boolean (b : Bool) : B20.C.cast .i32 (boolean b)=boolean b := by cases b <;> rfl

theorem positive_execution (w : BitVec 64) :
    CLogic.execute calls positiveProgram [.u64 w]=some (boolean (Run2.KeygenLeafGate.positive w)) := by
  simp [CLogic.execute,positiveProgram,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
    B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,B20.C.Scalar.assign,B20.C.update,
    CLogic.evalBody,CLogic.step,CLogic.eval,bits_call,
    B20.C.bin,B20.C.shift,B20.C.commonTy,B20.C.Val.ty,B20.C.cast,B20.C.literalValue,
    B20.C.bitsOp,CLogic.compare,CLogic.boolean,CLogic.truth,B20.C.Val.integer,
    Run2.KeygenLeafGate.positive,Bool.beq_eq_decide_eq]
  by_cases hs : w >>> 63=0#64 <;>
    by_cases he : (w >>> 52 &&& 2047#64)=2047#64 <;>
    by_cases hz : w <<< 1=0#64 <;>
    simp [hs,he,hz,B20.C.cast]

theorem positive_source_refines (w : BitVec 64) :
    (CLogicParser.parseFunction (slice 7468 8)).bind (fun f => CLogic.execute calls f [.u64 w])=
      some (boolean (Run2.KeygenLeafGate.positive w)) := by
  rw [positive_parses,Option.bind_some,positive_execution]

end FT1536.Source3.KeygenHelpers

#print FT1536.Source3.KeygenHelpers.bits_source_refines
#print FT1536.Source3.KeygenHelpers.positive_source_refines
#print axioms FT1536.Source3.KeygenHelpers.fpr_typedef_source
#print axioms FT1536.Source3.KeygenHelpers.bits_source_refines
#print axioms FT1536.Source3.KeygenHelpers.fromBits_source_refines
#print axioms FT1536.Source3.KeygenHelpers.positive_source_refines
