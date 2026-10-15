import Source3.FprMulMantissa137
import Source3.FprMulSuffix

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprMulSuffix137
open B20.C
open FprSmallSigned

def normalized (zu : BitVec 64) : BitVec 64 :=
  let zv := (zu >>> 1) ||| (zu &&& 1)
  let w := zu >>> 55
  zu ^^^ ((zu ^^^ zv) &&& (-w))

def zeroFlag (x y : BitVec 64) : BitVec 32 :=
  ((exponent x+2047#32) &&& (exponent y+2047#32)).sshiftRight 11

def result (x y zu : BitVec 64) : BitVec 64 :=
  FprHeaderTotal.packWord (((x ^^^ y) >>> 63).setWidth 32) (mulExponent x y zu)
    (normalized zu &&& (-((zeroFlag x y).signExtend 64)))

theorem source (s : B20.C.Scalar.State) (x y zu : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.mulTypes)
    (hx : s.values ['x']=some (.u64 x)) (hy : s.values ['y']=some (.u64 y))
    (hz : s.values ['z','u']=some (.u64 zu)) :
    ∃ out, FprPrimitives.execBlock 233 .u64 (FprAST.mulCode.body.drop 23) s=
      some (out,some (.u64 (result x y zu))) := by
  obtain ⟨hsum,hsub,hweight,hxplus,hyplus,hpack⟩ := mul_signed_obligations x y zu
  simp [exponent,weight,mulExponent] at hsum hsub hweight hxplus hyplus hpack
  simp (config := { maxSteps := 200000 })
    [FprPrimitives.execBlock,FprPrimitives.execScalar,FprAST.mulCode,
     CLogic.step,CLogic.eval,B20.C.Scalar.assign,B20.C.update,B20.C.cast,
     ht,hx,hy,hz,FprUnsignedPrefixes.mulTypes,List.foldl,
     FprUnsignedPrefixes.xyTypes,UnsignedState.setType,
     literalValue,bin,commonTy,Val.ty,bitsOp,shift,neg,
     FprHeaderTotal.signed_band32,FprHeaderTotal.header_pack,
     hsum,hsub,hweight,hxplus,hyplus,hpack,result,normalized,zeroFlag,
     exponent,weight,mulExponent]

end FT1536.Source3.FprMulSuffix137
