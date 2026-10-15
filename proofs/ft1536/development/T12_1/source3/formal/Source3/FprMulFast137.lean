import Source3.FprMulSuffix137
import Source3.C99PrimitiveExists
import Source3.FprPrefixCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprMulFast137
open B20.C

def word (x y : BitVec 64) : BitVec 64 := FprMulSuffix137.result x y (FprMulMantissa137.raw x y)

theorem execution (x y : BitVec 64) :
    FprPrimitives.execute FprAST.mulCode [.u64 x,.u64 y]=some (.u64 (word x y)) := by
  obtain ⟨state,headRun,typed⟩ := FprUnsignedPrefixes.mul_prefix_total x y
  have first := FprMulMantissa137.source_x x y
  have second := FprMulMantissa137.source_y x y
  have raw := FprMulMantissa137.source_result x y
  unfold FprMulMantissa137.execution at first second raw
  rw [headRun] at first second raw
  change state.values ['x']=some (.u64 x) at first
  change state.values ['y']=some (.u64 y) at second
  change state.values ['z','u']=some (.u64 (FprMulMantissa137.raw x y)) at raw
  obtain ⟨out,suffix⟩ := FprMulSuffix137.source state x y (FprMulMantissa137.raw x y)
    (typed.1.trans FprUnsignedPrefixes.mul_context_types) first second raw
  have length : FprUnsignedPrefixes.mulPrefix.length=23 := by decide +kernel
  have shape : FprAST.mulCode.body=FprUnsignedPrefixes.mulPrefix.map FprPrimitives.Instr.scalar ++
      FprAST.mulCode.body.drop 23 := by
    rw [← FprUnsignedPrefixes.mul_prefix_shape]
    exact (List.take_append_drop 23 FprAST.mulCode.body).symm
  have body : FprPrimitives.execBlock 256 .u64 FprAST.mulCode.body (FprUnsignedPrefixes.initial x y)=
      some (out,some (.u64 (word x y))) := by
    rw [shape,show 256=233+FprUnsignedPrefixes.mulPrefix.length by rw [length]]
    rw [FprScalarSequence.scalar_prefix _ _ _ headRun]
    exact suffix
  unfold FprPrimitives.execute
  change (do
    let initial ← B20.C.Scalar.bindArgs [(.u64,['x']),(.u64,['y'])] [.u64 x,.u64 y]
    let (_,returned) ← FprPrimitives.execBlock 256 .u64 FprAST.mulCode.body initial
    returned)=some (.u64 (word x y))
  simp [FprUnsignedPrefixes.bind_xy,body]

theorem model (x y : BitVec 64) : FprPrimitives.mul x y=some (word x y) := by
  simp [FprPrimitives.mul,FprPrimitives.call,FprAST.mul_binding,execution]

theorem source (x y : BitVec 64) : FprPrefixCalls.calls "fpr_mul".toList
    [.uint64 x,.uint64 y] (.uint64 (word x y)) := C99PrimitiveExists.mul_sound x y (word x y) (model x y)

end FT1536.Source3.FprMulFast137
