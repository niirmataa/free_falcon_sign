import Source3.FprDivSuffix

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprDivTotal
open B20.C
open FprDivLoopTotal

theorem div_total (x y : BitVec 64) : (FprPrimitives.div x y).isSome := by
  obtain ⟨s,hpre,hgood⟩ := FprUnsignedPrefixes.div_prefix_total x y
  have htypes : s.types=FprUnsignedPrefixes.divTypes :=
    hgood.1.trans FprUnsignedPrefixes.div_context_types
  obtain ⟨x',hx⟩ := FprScalarSequence.get_u64 _ s ['x'] hgood FprUnsignedPrefixes.div_ctx_x
  obtain ⟨y',hy⟩ := FprScalarSequence.get_u64 _ s ['y'] hgood FprUnsignedPrefixes.div_ctx_y
  obtain ⟨xu,hxu⟩ := FprScalarSequence.get_u64 _ s ['x','u'] hgood FprUnsignedPrefixes.div_ctx_xu
  obtain ⟨yu,hyu⟩ := FprScalarSequence.get_u64 _ s ['y','u'] hgood FprUnsignedPrefixes.div_ctx_yu
  obtain ⟨q,hq⟩ := FprScalarSequence.get_u64 _ s ['q'] hgood FprUnsignedPrefixes.div_ctx_q
  let start : B20.C.Scalar.State := {s with values := update s.values ['i'] (.i32 0)}
  have hstart : Inv start 0 := by
    refine ⟨htypes,⟨x',?_⟩,⟨y',?_⟩,⟨xu,?_⟩,⟨yu,?_⟩,⟨q,?_⟩,?_⟩ <;>
      simp [start,update,hx,hy,hxu,hyu,hq]
  obtain ⟨last,hfold,hlast⟩ := iterations_total start hstart 55 (by omega)
  obtain ⟨lx,hlx⟩ := hlast.x
  obtain ⟨ly,hly⟩ := hlast.y
  obtain ⟨lxu,hlxu⟩ := hlast.xu
  obtain ⟨lq,hlq⟩ := hlast.q
  obtain ⟨out,word,hsuffix⟩ := FprDivSuffix.suffix_total last lx ly lxu lq
    hlast.types hlx hly hlxu hlq
  have hassign : B20.C.Scalar.assign s ['i'] (.i32 0)=some start := by
    simp [B20.C.Scalar.assign,htypes,FprUnsignedPrefixes.divTypes,
      FprUnsignedPrefixes.xyTypes,UnsignedState.setType,List.foldl,B20.C.cast,start]
  have hguard : FprPrimitives.guard ['i'] 55 last=some false := by
    simpa using index_guard last 55 (by omega) hlast.index
  have hloopShape : FprAST.divCode.body.drop 5=
      .forInc ['i'] 55 FprDivRound.roundCode :: FprAST.divCode.body.drop 6 := by rfl
  have hloop : FprPrimitives.execBlock 251 .u64 (FprAST.divCode.body.drop 5) s=
      some (out,some (.u64 word)) := by
    rw [hloopShape]
    change (B20.C.Scalar.assign s ['i'] (.i32 0)).bind
      (fun first => ((List.range 55).foldlM (fun acc _ => oneStep acc) first).bind
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
      FprUnsignedPrefixes.divPrefix.map FprPrimitives.Instr.scalar ++
        FprAST.divCode.body.drop 5 := by
    rw [← FprUnsignedPrefixes.div_prefix_shape]
    exact (List.take_append_drop 5 FprAST.divCode.body).symm
  have hlen : FprUnsignedPrefixes.divPrefix.length=5 := by decide
  have hfull : FprPrimitives.execBlock 256 .u64 FprAST.divCode.body
      (FprUnsignedPrefixes.initial x y)=some (out,some (.u64 word)) := by
    rw [hbody,show 256=251+FprUnsignedPrefixes.divPrefix.length by rw [hlen]]
    rw [FprScalarSequence.scalar_prefix _ _ _ hpre]
    exact hloop
  have hexec : FprPrimitives.execute FprAST.divCode [.u64 x,.u64 y]=some (.u64 word) := by
    unfold FprPrimitives.execute
    change (do
      let s ← B20.C.Scalar.bindArgs [(.u64,['x']),(.u64,['y'])] [.u64 x,.u64 y]
      let (_,ret) ← FprPrimitives.execBlock 256 .u64 FprAST.divCode.body s
      ret)=some (.u64 word)
    simp [FprUnsignedPrefixes.bind_xy,hfull]
  simp [FprPrimitives.div,FprPrimitives.call,FprAST.div_binding,hexec]

end FT1536.Source3.FprDivTotal

#check @FT1536.Source3.FprDivTotal.div_total
#print FT1536.Source3.FprDivTotal.div_total
#print axioms FT1536.Source3.FprDivTotal.div_total
