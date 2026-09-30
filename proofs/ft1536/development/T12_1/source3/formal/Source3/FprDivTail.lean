import Source3.FprDivLoopTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprDivTail
open B20.C
open FprSmallSigned

theorem neg_unsigned (w : BitVec 64) : B20.C.neg (.u64 w)=some (.u64 (-w)) := rfl

theorem tail_total (s : B20.C.Scalar.State) (x y quotient q : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.divTypes)
    (hx : s.values ['x']=some (.u64 x)) (hy : s.values ['y']=some (.u64 y))
    (hw : s.values ['w']=some (.u64 (quotient >>> 55)))
    (hq : s.values ['q']=some (.u64 q)) :
    ∃ out word,
      FprPrimitives.execBlock 246 .u64 (FprAST.divCode.body.drop 10) s=
        some (out,some (.u64 word)) := by
  obtain ⟨hdiff,hsub,hweight,hxplus,hneg,hpack⟩ := div_signed_obligations x y quotient
  simp [exponent,weight,divExponent,nonzeroExponent] at hdiff hsub hweight hxplus hneg hpack
  simp (config := { maxSteps := 200000 })
    [FprPrimitives.execBlock,FprPrimitives.execScalar,FprAST.divCode,
     CLogic.step,CLogic.eval,B20.C.Scalar.assign,B20.C.update,B20.C.cast,
     ht,hx,hy,hw,hq,FprUnsignedPrefixes.divTypes,List.foldl,
     FprUnsignedPrefixes.xyTypes,UnsignedState.setType,
     literalValue,bin,commonTy,Val.ty,bitsOp,shift,neg_unsigned,
     FprHeaderTotal.signed_band32,FprHeaderTotal.header_pack,
     hdiff,hsub,hweight,hxplus,hneg,hpack]

end FT1536.Source3.FprDivTail

#print axioms FT1536.Source3.FprDivTail.tail_total
