import Source3.FprDivWords154
import Source3.FprDivSuffix154
import Source3.C99PrimitiveExists
import Source3.FprPrefixCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprDivFast154
open B20.C

def quotient (x y : BitVec 64) : BitVec 64 × BitVec 64 :=
  FprDivWords154.iterate (FprMulMantissa137.mantissa y) 55 (FprMulMantissa137.mantissa x,0)

def word (x y : BitVec 64) : BitVec 64 :=
  FprDivSuffix154.word x y (quotient x y).1 (quotient x y).2

theorem execution (x y : BitVec 64) :
    FprPrimitives.execute FprAST.divCode [.u64 x,.u64 y]=some (.u64 (word x y)) := by
  obtain ⟨s,hpre,hgood⟩ := FprUnsignedPrefixes.div_prefix_total x y
  have ht : s.types=FprUnsignedPrefixes.divTypes := hgood.1.trans FprUnsignedPrefixes.div_context_types
  have hx := FprDivWords154.prefix_x x y
  have hy := FprDivWords154.prefix_y x y
  have hxu := FprDivWords154.prefix_xu x y
  have hyu := FprDivWords154.prefix_yu x y
  have hq := FprDivWords154.prefix_q x y
  unfold FprDivWords154.prefixRun at hx hy hxu hyu hq
  rw [hpre] at hx hy hxu hyu hq
  change s.values ['x']=some (.u64 x) at hx
  change s.values ['y']=some (.u64 y) at hy
  change s.values ['x','u']=some (.u64 (FprMulMantissa137.mantissa x)) at hxu
  change s.values ['y','u']=some (.u64 (FprMulMantissa137.mantissa y)) at hyu
  change s.values ['q']=some (.u64 0) at hq
  let start : B20.C.Scalar.State := {s with values := update s.values ['i'] (.i32 0)}
  have hstart : FprDivWords154.Exact start x y (FprMulMantissa137.mantissa x) (FprMulMantissa137.mantissa y) 0 0 := by
    refine ⟨ht,?_,?_,?_,?_,?_,?_⟩ <;> simp [start,update,hx,hy,hxu,hyu,hq]
  obtain ⟨last,hfold,hlast⟩ := FprDivWords154.iterations start x y _ _ 0 hstart 55 (by omega)
  obtain ⟨out,hsuffix⟩ := FprDivSuffix154.source last x y (quotient x y).1 (quotient x y).2
    hlast.types hlast.xValue hlast.yValue hlast.xuValue hlast.qValue
  have hassign : B20.C.Scalar.assign s ['i'] (.i32 0)=some start := by
    simp [B20.C.Scalar.assign,ht,FprUnsignedPrefixes.divTypes,
      FprUnsignedPrefixes.xyTypes,UnsignedState.setType,List.foldl,B20.C.cast,start]
  have hguard : FprPrimitives.guard ['i'] 55 last=some false := by
    simpa using FprDivLoopTotal.index_guard last 55 (by omega) hlast.index
  have hloopShape : FprAST.divCode.body.drop 5=
      .forInc ['i'] 55 FprDivRound.roundCode :: FprAST.divCode.body.drop 6 := by rfl
  have hloop : FprPrimitives.execBlock 251 .u64 (FprAST.divCode.body.drop 5) s=
      some (out,some (.u64 (word x y))) := by
    rw [hloopShape]
    change (B20.C.Scalar.assign s ['i'] (.i32 0)).bind
      (fun first => ((List.range 55).foldlM (fun acc _ => FprDivLoopTotal.oneStep acc) first).bind
        (fun after => (FprPrimitives.guard ['i'] 55 after).bind
          (fun g => if g then none else
            FprPrimitives.execBlock 250 .u64 (FprAST.divCode.body.drop 6) after)))=_
    rw [hassign]
    dsimp only [Option.bind]
    rw [hfold]
    dsimp only [Option.bind]
    rw [hguard]
    exact hsuffix
  have hbody : FprAST.divCode.body =
      FprUnsignedPrefixes.divPrefix.map FprPrimitives.Instr.scalar ++ FprAST.divCode.body.drop 5 := by
    rw [← FprUnsignedPrefixes.div_prefix_shape]
    exact (List.take_append_drop 5 FprAST.divCode.body).symm
  have hlen : FprUnsignedPrefixes.divPrefix.length=5 := by decide
  have hfull : FprPrimitives.execBlock 256 .u64 FprAST.divCode.body (FprUnsignedPrefixes.initial x y)=
      some (out,some (.u64 (word x y))) := by
    rw [hbody,show 256=251+FprUnsignedPrefixes.divPrefix.length by rw [hlen]]
    rw [FprScalarSequence.scalar_prefix _ _ _ hpre]
    exact hloop
  unfold FprPrimitives.execute
  change (do
    let s ← B20.C.Scalar.bindArgs [(.u64,['x']),(.u64,['y'])] [.u64 x,.u64 y]
    let (_,ret) ← FprPrimitives.execBlock 256 .u64 FprAST.divCode.body s
    ret)=some (.u64 (word x y))
  simp [FprUnsignedPrefixes.bind_xy,hfull]

theorem model (x y : BitVec 64) : FprPrimitives.div x y=some (word x y) := by
  simp [FprPrimitives.div,FprPrimitives.call,FprAST.div_binding,execution]

theorem source (x y : BitVec 64) : FprPrefixCalls.calls "fpr_div".toList
    [.uint64 x,.uint64 y] (.uint64 (word x y)) := C99PrimitiveExists.div_sound x y (word x y) (model x y)

end FT1536.Source3.FprDivFast154
