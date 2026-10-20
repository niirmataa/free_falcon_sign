import Source3.FprUnsignedPrefixes
import Source3.FprSmallSigned

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprMulSuffix
open B20.C
open FprSmallSigned

theorem suffix_total (s : B20.C.Scalar.State) (x y zu : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.mulTypes)
    (hx : s.values ['x']=some (.u64 x))
    (hy : s.values ['y']=some (.u64 y))
    (hz : s.values ['z','u']=some (.u64 zu)) :
    ∃ out word,
      FprPrimitives.execBlock 233 .u64 (FprAST.mulCode.body.drop 23) s=
        some (out,some (.u64 word)) := by
  obtain ⟨hsum,hsub,hweight,hxplus,hyplus,hpack⟩ := mul_signed_obligations x y zu
  simp [exponent,weight,mulExponent] at hsum hsub hweight hxplus hyplus hpack
  simp (config := { maxSteps := 200000 })
    [FprPrimitives.execBlock,FprPrimitives.execScalar,FprAST.mulCode,
     CLogic.step,CLogic.eval,B20.C.Scalar.assign,B20.C.update,B20.C.cast,
     ht,hx,hy,hz,FprUnsignedPrefixes.mulTypes,List.foldl,
     FprUnsignedPrefixes.xyTypes,UnsignedState.setType,
     literalValue,bin,commonTy,Val.ty,bitsOp,shift,neg,
     FprHeaderTotal.signed_band32,
     FprHeaderTotal.header_pack,hsum,hsub,hweight,hxplus,hyplus,hpack]

end FT1536.Source3.FprMulSuffix

#print axioms FT1536.Source3.FprMulSuffix.suffix_total
