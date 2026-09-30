import Source3.FprAddTail

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprAddTotal
open B20.C

theorem add_total (x y : BitVec 64) : (FprPrimitives.add x y).isSome := by
  obtain ⟨s,hpre,hgood⟩ := FprUnsignedPrefixes.add_prefix_total x y
  have ht : s.types=FprUnsignedPrefixes.addTypes := hgood.1.trans FprUnsignedPrefixes.add_context_types
  obtain ⟨x',hx⟩ := FprScalarSequence.get_u64 _ s ['x'] hgood FprUnsignedPrefixes.add_ctx_x
  obtain ⟨y',hy⟩ := FprScalarSequence.get_u64 _ s ['y'] hgood FprUnsignedPrefixes.add_ctx_y
  let s1 := FprAddDecode.after s false x'
  have hdecodeX := FprAddDecode.decode_total s false x' ht hx
  have hy' : s1.values (FprAddDecode.sourceName true)=some (.u64 y') := by
    simpa [s1,FprAddDecode.after,FprAddDecode.sourceName,FprAddDecode.expName,
      FprAddDecode.signName,FprAddDecode.mantName,update] using hy
  let s2 := FprAddDecode.after s1 true y'
  have hdecodeY := FprAddDecode.decode_total s1 true y' ht hy'
  have hex : s2.values ['e','x']=some (.i32 (FprAddDecode.expValue x')) := by
    simp [s2,s1,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have hey : s2.values ['e','y']=some (.i32 (FprAddDecode.expValue y')) := by
    simp [s2,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have hsx : s2.values ['s','x']=some (.i32 (FprAddDecode.signWord x')) := by
    simp [s2,s1,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have hsy : s2.values ['s','y']=some (.i32 (FprAddDecode.signWord y')) := by
    simp [s2,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have hxu : s2.values ['x','u']=some (.u64 (FprAddDecode.mantWord x')) := by
    simp [s2,s1,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have hyu : s2.values ['y','u']=some (.u64 (FprAddDecode.mantWord y')) := by
    simp [s2,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have hbx := FprAddDecode.exponent_bounds x'
  have hby := FprAddDecode.exponent_bounds y'
  obtain ⟨s3,mant,hcombine,ht3,he3,hs3,hm3⟩ := FprAddCombine.combine_total s2
    (FprAddDecode.expValue x') (FprAddDecode.expValue y')
    (FprAddDecode.signWord x') (FprAddDecode.signWord y')
    (FprAddDecode.mantWord x') (FprAddDecode.mantWord y') ht hex hey hsx hsy hxu hyu hbx hby
  obtain ⟨out,word,htail⟩ := FprAddTail.norm_tail_total s3 (FprAddDecode.expValue x')
    (FprAddDecode.signWord x') mant (ht3.trans ht) he3 hm3 hs3 hbx
  have shape21 : FprAST.addCode.body.drop 21=
      FprAddCombine.statements.map FprPrimitives.Instr.scalar ++ FprAST.addCode.body.drop 28 := by rfl
  have h21 : FprPrimitives.execBlock 235 .u64 (FprAST.addCode.body.drop 21) s2=
      some (out,some (.u64 word)) := by
    rw [shape21,show 235=228+FprAddCombine.statements.length by decide]
    rw [FprScalarSequence.scalar_prefix _ _ _ hcombine]
    exact htail
  have shape15 : FprAST.addCode.body.drop 15=
      (FprAddDecode.statements true).map FprPrimitives.Instr.scalar ++ FprAST.addCode.body.drop 21 := by rfl
  have h15 : FprPrimitives.execBlock 241 .u64 (FprAST.addCode.body.drop 15) s1=
      some (out,some (.u64 word)) := by
    rw [shape15,show 241=235+(FprAddDecode.statements true).length by decide]
    rw [FprScalarSequence.scalar_prefix _ _ _ hdecodeY]
    exact h21
  have shape9 : FprAST.addCode.body.drop 9=
      (FprAddDecode.statements false).map FprPrimitives.Instr.scalar ++ FprAST.addCode.body.drop 15 := by rfl
  have h9 : FprPrimitives.execBlock 247 .u64 (FprAST.addCode.body.drop 9) s=
      some (out,some (.u64 word)) := by
    rw [shape9,show 247=241+(FprAddDecode.statements false).length by decide]
    rw [FprScalarSequence.scalar_prefix _ _ _ hdecodeX]
    exact h15
  have shape0 : FprAST.addCode.body=
      FprUnsignedPrefixes.addPrefix.map FprPrimitives.Instr.scalar ++ FprAST.addCode.body.drop 9 := by rfl
  have hfull : FprPrimitives.execBlock 256 .u64 FprAST.addCode.body
      (FprUnsignedPrefixes.initial x y)=some (out,some (.u64 word)) := by
    rw [shape0,show 256=247+FprUnsignedPrefixes.addPrefix.length by decide]
    rw [FprScalarSequence.scalar_prefix _ _ _ hpre]
    exact h9
  have hexec : FprPrimitives.execute FprAST.addCode [.u64 x,.u64 y]=some (.u64 word) := by
    unfold FprPrimitives.execute
    change (do
      let s ← B20.C.Scalar.bindArgs [(.u64,['x']),(.u64,['y'])] [.u64 x,.u64 y]
      let (_,ret) ← FprPrimitives.execBlock 256 .u64 FprAST.addCode.body s
      ret)=some (.u64 word)
    simp [FprUnsignedPrefixes.bind_xy,hfull]
  simp [FprPrimitives.add,FprPrimitives.call,FprAST.add_binding,hexec]

end FT1536.Source3.FprAddTotal

#check @FT1536.Source3.FprAddTotal.add_total
#print axioms FT1536.Source3.FprAddTotal.add_total
