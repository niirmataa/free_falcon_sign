import Source3.FprMulSuffix
import Source3.FprScalarSequence

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprMulTotal
open B20.C

theorem mul_total (x y : BitVec 64) : (FprPrimitives.mul x y).isSome := by
  obtain ⟨s,hpre,hgood⟩ := FprUnsignedPrefixes.mul_prefix_total x y
  obtain ⟨x',hx⟩ := FprScalarSequence.get_u64 _ s ['x'] hgood FprUnsignedPrefixes.mul_ctx_x
  obtain ⟨y',hy⟩ := FprScalarSequence.get_u64 _ s ['y'] hgood FprUnsignedPrefixes.mul_ctx_y
  obtain ⟨zu,hzu⟩ := FprScalarSequence.get_u64 _ s ['z','u'] hgood FprUnsignedPrefixes.mul_ctx_zu
  obtain ⟨out,word,hsuffix⟩ := FprMulSuffix.suffix_total s x' y' zu
    (hgood.1.trans FprUnsignedPrefixes.mul_context_types) hx hy hzu
  have hlen : FprUnsignedPrefixes.mulPrefix.length=23 := by decide
  have hbody : FprAST.mulCode.body =
      FprUnsignedPrefixes.mulPrefix.map FprPrimitives.Instr.scalar ++
      FprAST.mulCode.body.drop 23 := by
    rw [← FprUnsignedPrefixes.mul_prefix_shape]
    exact (List.take_append_drop 23 FprAST.mulCode.body).symm
  have hfull : FprPrimitives.execBlock 256 .u64 FprAST.mulCode.body
      (FprUnsignedPrefixes.initial x y)=some (out,some (.u64 word)) := by
    rw [hbody]
    rw [show 256=233+FprUnsignedPrefixes.mulPrefix.length by rw [hlen]]
    rw [FprScalarSequence.scalar_prefix _ _ _ hpre]
    exact hsuffix
  have hexec : FprPrimitives.execute FprAST.mulCode [.u64 x,.u64 y]=some (.u64 word) := by
    unfold FprPrimitives.execute
    change (do
      let s ← B20.C.Scalar.bindArgs [(.u64,['x']),(.u64,['y'])] [.u64 x,.u64 y]
      let (_,ret) ← FprPrimitives.execBlock 256 .u64 FprAST.mulCode.body s
      ret)=some (.u64 word)
    simp [FprUnsignedPrefixes.bind_xy,hfull]
  simp [FprPrimitives.mul,FprPrimitives.call,FprAST.mul_binding,hexec]

end FT1536.Source3.FprMulTotal

#print axioms FT1536.Source3.FprMulTotal.mul_total
