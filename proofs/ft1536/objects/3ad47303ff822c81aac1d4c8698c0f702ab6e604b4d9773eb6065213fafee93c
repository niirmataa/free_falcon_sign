import Source3.FprDivTail
import Source3.FprScalarSequence

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprDivSuffix
open B20.C
open FprSmallSigned

theorem neg_unsigned (w : BitVec 64) : B20.C.neg (.u64 w)=some (.u64 (-w)) := rfl

def normalization := (FprUnsignedPrefixes.scalars ((FprAST.divCode.body.drop 6).take 4)).getD []
def sticky (xu q : BitVec 64) : BitVec 64 := q ||| ((xu ||| -xu) >>> 63)
def normalWord (xu q : BitVec 64) : BitVec 64 :=
  let z := sticky xu q
  z ^^^ ((z ^^^ ((z >>> 1) ||| (z &&& 1))) &&& -(z >>> 55))
def normalized (s : B20.C.Scalar.State) (xu q : BitVec 64) : B20.C.Scalar.State :=
  {s with values :=
    update (update (update (update s.values ['q'] (.u64 (sticky xu q)))
      ['q','2'] (.u64 ((sticky xu q >>> 1) ||| (sticky xu q &&& 1))))
      ['w'] (.u64 (sticky xu q >>> 55))) ['q'] (.u64 (normalWord xu q))}

theorem normalize_exec (s : B20.C.Scalar.State) (xu q : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.divTypes)
    (hxu : s.values ['x','u']=some (.u64 xu)) (hq : s.values ['q']=some (.u64 q)) :
    UnsignedState.exec FprPrimitives.headerCalls s normalization=some (normalized s xu q) := by
  simp [UnsignedState.exec,normalization,FprUnsignedPrefixes.scalars,FprAST.divCode,
    CLogic.step,CLogic.eval,B20.C.Scalar.assign,B20.C.update,B20.C.cast,
    ht,hxu,hq,FprUnsignedPrefixes.divTypes,List.foldl,FprUnsignedPrefixes.xyTypes,
    UnsignedState.setType,literalValue,bin,commonTy,Val.ty,bitsOp,shift,neg_unsigned,
    normalized,normalWord,sticky]

theorem suffix_total (s : B20.C.Scalar.State) (x y xu q : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.divTypes)
    (hx : s.values ['x']=some (.u64 x)) (hy : s.values ['y']=some (.u64 y))
    (hxu : s.values ['x','u']=some (.u64 xu)) (hq : s.values ['q']=some (.u64 q)) :
    ∃ out word,
      FprPrimitives.execBlock 250 .u64 (FprAST.divCode.body.drop 6) s=
        some (out,some (.u64 word)) := by
  have hnormalize := normalize_exec s xu q ht hxu hq
  have hx' : (normalized s xu q).values ['x']=some (.u64 x) := by
    simpa [normalized,update] using hx
  have hy' : (normalized s xu q).values ['y']=some (.u64 y) := by
    simpa [normalized,update] using hy
  obtain ⟨out,word,hout⟩ := FprDivTail.tail_total (normalized s xu q) x y (sticky xu q)
    (normalWord xu q) ht hx' hy'
    (by simp [normalized,update]) (by simp [normalized,update])
  have hshape : FprAST.divCode.body.drop 6 =
      normalization.map FprPrimitives.Instr.scalar ++ FprAST.divCode.body.drop 10 := by rfl
  have hlen : normalization.length=4 := by decide
  refine ⟨out,word,?_⟩
  rw [hshape,show 250=246+normalization.length by rw [hlen]]
  rw [FprScalarSequence.scalar_prefix _ _ _ hnormalize]
  exact hout

end FT1536.Source3.FprDivSuffix

#print axioms FT1536.Source3.FprDivSuffix.suffix_total
