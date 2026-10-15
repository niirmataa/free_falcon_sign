import Source3.FprDivSuffix

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprDivSuffix154
open B20.C
open FprSmallSigned

def tailWord (x y quotient q : BitVec 64) : BitVec 64 :=
  FprHeaderTotal.packWord ((((x ^^^ y) >>> 63).setWidth 32) &&& nonzeroExponent x)
    (divExponent x y quotient &&& -(nonzeroExponent x))
    (q &&& (-((nonzeroExponent x).signExtend 64)))

theorem tail_source (s : B20.C.Scalar.State) (x y quotient q : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.divTypes)
    (hx : s.values ['x']=some (.u64 x)) (hy : s.values ['y']=some (.u64 y))
    (hw : s.values ['w']=some (.u64 (quotient >>> 55)))
    (hq : s.values ['q']=some (.u64 q)) :
    ∃ out, FprPrimitives.execBlock 246 .u64 (FprAST.divCode.body.drop 10) s=
      some (out,some (.u64 (tailWord x y quotient q))) := by
  obtain ⟨hdiff,hsub,hweight,hxplus,hneg,hpack⟩ := div_signed_obligations x y quotient
  simp [exponent,weight,divExponent,nonzeroExponent] at hdiff hsub hweight hxplus hneg hpack
  simp (config := { maxSteps := 200000 })
    [FprPrimitives.execBlock,FprPrimitives.execScalar,FprAST.divCode,
     CLogic.step,CLogic.eval,B20.C.Scalar.assign,B20.C.update,B20.C.cast,
     ht,hx,hy,hw,hq,FprUnsignedPrefixes.divTypes,List.foldl,
     FprUnsignedPrefixes.xyTypes,UnsignedState.setType,
     literalValue,bin,commonTy,Val.ty,bitsOp,shift,FprDivTail.neg_unsigned,
     FprHeaderTotal.signed_band32,FprHeaderTotal.header_pack,
     hdiff,hsub,hweight,hxplus,hneg,hpack,tailWord,exponent,weight,divExponent,nonzeroExponent]

def word (x y xu q : BitVec 64) : BitVec 64 :=
  tailWord x y (FprDivSuffix.sticky xu q) (FprDivSuffix.normalWord xu q)

theorem source (s : B20.C.Scalar.State) (x y xu q : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.divTypes)
    (hx : s.values ['x']=some (.u64 x)) (hy : s.values ['y']=some (.u64 y))
    (hxu : s.values ['x','u']=some (.u64 xu)) (hq : s.values ['q']=some (.u64 q)) :
    ∃ out, FprPrimitives.execBlock 250 .u64 (FprAST.divCode.body.drop 6) s=
      some (out,some (.u64 (word x y xu q))) := by
  have hnormalize := FprDivSuffix.normalize_exec s xu q ht hxu hq
  have hx' : (FprDivSuffix.normalized s xu q).values ['x']=some (.u64 x) := by
    simpa [FprDivSuffix.normalized,update] using hx
  have hy' : (FprDivSuffix.normalized s xu q).values ['y']=some (.u64 y) := by
    simpa [FprDivSuffix.normalized,update] using hy
  obtain ⟨out,hout⟩ := tail_source (FprDivSuffix.normalized s xu q) x y (FprDivSuffix.sticky xu q)
    (FprDivSuffix.normalWord xu q) ht hx' hy'
    (by simp [FprDivSuffix.normalized,update]) (by simp [FprDivSuffix.normalized,update])
  have hshape : FprAST.divCode.body.drop 6 =
      FprDivSuffix.normalization.map FprPrimitives.Instr.scalar ++ FprAST.divCode.body.drop 10 := by rfl
  have hlen : FprDivSuffix.normalization.length=4 := by decide
  refine ⟨out,?_⟩
  rw [hshape,show 250=246+FprDivSuffix.normalization.length by rw [hlen]]
  rw [FprScalarSequence.scalar_prefix _ _ _ hnormalize]
  exact hout

end FT1536.Source3.FprDivSuffix154
