import Source3.FprAddSwap137
import Source3.FprAddCombine137
import Source3.FprAddTail137
import Source3.C99PrimitiveExists
import Source3.FprPrefixCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprAddFast137
open B20.C

def word (x y : BitVec 64) : BitVec 64 :=
  let first := FprAddSwap137.first x y
  let second := FprAddSwap137.second x y
  let ex := FprAddDecode.expValue first
  let ey := FprAddDecode.expValue second
  let sx := FprAddDecode.signWord first
  let sy := FprAddDecode.signWord second
  let mantissa := FprAddCombine137.mantissa ex ey sx sy (FprAddDecode.mantWord first) (FprAddDecode.mantWord second)
  FprAddTail137.result ex sx mantissa

theorem execution (x y : BitVec 64) :
    FprPrimitives.execute FprAST.addCode [.u64 x,.u64 y]=some (.u64 (word x y)) := by
  obtain ⟨s,headRun,good⟩ := FprUnsignedPrefixes.add_prefix_total x y
  have types : s.types=FprUnsignedPrefixes.addTypes := good.1.trans FprUnsignedPrefixes.add_context_types
  let first := FprAddSwap137.first x y
  let second := FprAddSwap137.second x y
  have hx := FprAddSwap137.source_first x y
  have hy := FprAddSwap137.source_second x y
  unfold FprAddSwap137.execution at hx hy
  rw [headRun] at hx hy
  change s.values ['x']=some (.u64 first) at hx
  change s.values ['y']=some (.u64 second) at hy
  let s1 := FprAddDecode.after s false first
  have decodeFirst := FprAddDecode.decode_total s false first types hx
  have keptSecond : s1.values (FprAddDecode.sourceName true)=some (.u64 second) := by
    simpa [s1,FprAddDecode.after,FprAddDecode.sourceName,FprAddDecode.expName,
      FprAddDecode.signName,FprAddDecode.mantName,update] using hy
  let s2 := FprAddDecode.after s1 true second
  have decodeSecond := FprAddDecode.decode_total s1 true second types keptSecond
  have ex : s2.values ['e','x']=some (.i32 (FprAddDecode.expValue first)) := by
    simp [s2,s1,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have ey : s2.values ['e','y']=some (.i32 (FprAddDecode.expValue second)) := by
    simp [s2,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have sx : s2.values ['s','x']=some (.i32 (FprAddDecode.signWord first)) := by
    simp [s2,s1,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have sy : s2.values ['s','y']=some (.i32 (FprAddDecode.signWord second)) := by
    simp [s2,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have xu : s2.values ['x','u']=some (.u64 (FprAddDecode.mantWord first)) := by
    simp [s2,s1,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have yu : s2.values ['y','u']=some (.u64 (FprAddDecode.mantWord second)) := by
    simp [s2,FprAddDecode.after,FprAddDecode.expName,FprAddDecode.signName,FprAddDecode.mantName,update]
  have boundsFirst := FprAddDecode.exponent_bounds first
  have boundsSecond := FprAddDecode.exponent_bounds second
  obtain ⟨s3,combine,types3,ex3,sx3,mant3⟩ := FprAddCombine137.source s2
    (FprAddDecode.expValue first) (FprAddDecode.expValue second)
    (FprAddDecode.signWord first) (FprAddDecode.signWord second)
    (FprAddDecode.mantWord first) (FprAddDecode.mantWord second)
    types ex ey sx sy xu yu boundsFirst boundsSecond
  obtain ⟨out,tailRun⟩ := FprAddTail137.source s3 (FprAddDecode.expValue first) (FprAddDecode.signWord first)
    _ (types3.trans types) ex3 mant3 sx3 boundsFirst
  have shape21 : FprAST.addCode.body.drop 21=
      FprAddCombine.statements.map FprPrimitives.Instr.scalar ++ FprAST.addCode.body.drop 28 := by rfl
  have at21 : FprPrimitives.execBlock 235 .u64 (FprAST.addCode.body.drop 21) s2=some (out,some (.u64 (word x y))) := by
    rw [shape21,show 235=228+FprAddCombine.statements.length by decide +kernel]
    rw [FprScalarSequence.scalar_prefix _ _ _ combine]
    exact tailRun
  have shape15 : FprAST.addCode.body.drop 15=
      (FprAddDecode.statements true).map FprPrimitives.Instr.scalar ++ FprAST.addCode.body.drop 21 := by rfl
  have at15 : FprPrimitives.execBlock 241 .u64 (FprAST.addCode.body.drop 15) s1=some (out,some (.u64 (word x y))) := by
    rw [shape15,show 241=235+(FprAddDecode.statements true).length by decide +kernel]
    rw [FprScalarSequence.scalar_prefix _ _ _ decodeSecond]
    exact at21
  have shape9 : FprAST.addCode.body.drop 9=
      (FprAddDecode.statements false).map FprPrimitives.Instr.scalar ++ FprAST.addCode.body.drop 15 := by rfl
  have at9 : FprPrimitives.execBlock 247 .u64 (FprAST.addCode.body.drop 9) s=some (out,some (.u64 (word x y))) := by
    rw [shape9,show 247=241+(FprAddDecode.statements false).length by decide +kernel]
    rw [FprScalarSequence.scalar_prefix _ _ _ decodeFirst]
    exact at15
  have shape0 : FprAST.addCode.body=FprUnsignedPrefixes.addPrefix.map FprPrimitives.Instr.scalar ++ FprAST.addCode.body.drop 9 := by rfl
  have body : FprPrimitives.execBlock 256 .u64 FprAST.addCode.body (FprUnsignedPrefixes.initial x y)=some (out,some (.u64 (word x y))) := by
    rw [shape0,show 256=247+FprUnsignedPrefixes.addPrefix.length by decide +kernel]
    rw [FprScalarSequence.scalar_prefix _ _ _ headRun]
    exact at9
  unfold FprPrimitives.execute
  change (do
    let initial ← B20.C.Scalar.bindArgs [(.u64,['x']),(.u64,['y'])] [.u64 x,.u64 y]
    let (_,returned) ← FprPrimitives.execBlock 256 .u64 FprAST.addCode.body initial
    returned)=some (.u64 (word x y))
  simp [FprUnsignedPrefixes.bind_xy,body]

theorem model (x y : BitVec 64) : FprPrimitives.add x y=some (word x y) := by
  simp [FprPrimitives.add,FprPrimitives.call,FprAST.add_binding,execution]

theorem source (x y : BitVec 64) : FprPrefixCalls.calls "fpr_add".toList
    [.uint64 x,.uint64 y] (.uint64 (word x y)) := C99PrimitiveExists.add_sound x y (word x y) (model x y)

end FT1536.Source3.FprAddFast137
