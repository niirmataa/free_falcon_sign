import Source3.FprNormFast137
import Source3.FprAddTail

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprAddTail137
open B20.C

def packed (e sx : BitVec 32) (m : BitVec 64) : BitVec 64 :=
  FprHeaderTotal.packWord sx (e+9#32)
    ((m ||| ((m.setWidth 32 &&& 0x1ff#32)+0x1ff#32).setWidth 64) >>> 9)

def result (e sx : BitVec 32) (m : BitVec 64) : BitVec 64 :=
  let normalized := FprNormSteps137.result e m
  packed normalized.1 sx normalized.2

theorem tail_source (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (he : s.values ['e','x']=some (.i32 e)) (hm : s.values ['x','u']=some (.u64 m))
    (hs : s.values ['s','x']=some (.i32 sx)) (hb : -1141≤e.toInt ∧ e.toInt≤1067) :
    ∃ out, FprPrimitives.execBlock 227 .u64 (FprAST.addCode.body.drop 29) s=
      some (out,some (.u64 (packed e sx m))) := by
  have constant : (9#32).toInt=(9 : Int) := by decide +kernel
  have safe := FprSmallSigned.add32 e 9#32 (by rw [constant]; omega)
  have packBounds : -2147483648≤(e+9#32).toInt+1076 ∧ (e+9#32).toInt+1076<2147483648 := by omega
  have call (word : BitVec 64) := FprHeaderTotal.header_pack sx (e+9#32) word packBounds
  simp (config := { maxSteps := 200000 })
    [FprPrimitives.execBlock,FprPrimitives.execScalar,FprAST.addCode,CLogic.step,CLogic.eval,
     B20.C.Scalar.assign,B20.C.update,B20.C.cast,ht,he,hm,hs,
     FprUnsignedPrefixes.addTypes,FprUnsignedPrefixes.xyTypes,UnsignedState.setType,List.foldl,
     literalValue,bin,commonTy,Val.ty,bitsOp,shift,safe.1,call,packed]

theorem source (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (he : s.values ['e','x']=some (.i32 e)) (hm : s.values ['x','u']=some (.u64 m))
    (hs : s.values ['s','x']=some (.i32 sx)) (hb : -1078≤e.toInt ∧ e.toInt≤969) :
    ∃ out, FprPrimitives.execBlock 228 .u64 (FprAST.addCode.body.drop 28) s=
      some (out,some (.u64 (result e sx m))) := by
  obtain ⟨normalized,macroRun,ready,low,high⟩ := FprNormFast137.source s e sx m ht he hm hs hb
  obtain ⟨types,exponent,mantissa,sign⟩ := FprNormTotal.clean_norm s normalized
    (FprNormSteps137.result e m).1 sx (FprNormSteps137.result e m).2 ht ready
  let clean := FprPrimitives.leaveBlock s normalized (FprPrimitives.scalarDecls FprAST.normCode)
  obtain ⟨out,tailRun⟩ := tail_source clean (FprNormSteps137.result e m).1 sx (FprNormSteps137.result e m).2
    (types.trans ht) exponent mantissa sign ⟨low,high⟩
  have shape : FprAST.addCode.body.drop 28=.norm ['x','u'] ['e','x']::FprAST.addCode.body.drop 29 := by rfl
  refine ⟨out,?_⟩
  rw [shape,FprPrimitives.execBlock,FprAST.norm_binding]
  change (FprPrimitives.execScalars FprAST.normCode s).bind
    (fun next => FprPrimitives.execBlock 227 .u64 (FprAST.addCode.body.drop 29)
      (FprPrimitives.leaveBlock s next (FprPrimitives.scalarDecls FprAST.normCode)))=_
  rw [macroRun]
  exact tailRun

end FT1536.Source3.FprAddTail137
