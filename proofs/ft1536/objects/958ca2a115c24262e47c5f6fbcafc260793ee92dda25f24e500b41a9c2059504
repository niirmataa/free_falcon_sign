import Source3.FprNormTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprAddTail
open B20.C

theorem tail_total (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (he : s.values ['e','x']=some (.i32 e)) (hm : s.values ['x','u']=some (.u64 m))
    (hs : s.values ['s','x']=some (.i32 sx)) (hb : -1141≤e.toInt ∧ e.toInt≤1067) :
    ∃ out word, FprPrimitives.execBlock 227 .u64 (FprAST.addCode.body.drop 29) s=
      some (out,some (.u64 word)) := by
  have c9 : (9#32).toInt=(9 : Int) := by decide
  have ha := FprSmallSigned.add32 e 9#32 (by rw [c9]; omega)
  have hpack : -2147483648≤(e+9#32).toInt+1076 ∧ (e+9#32).toInt+1076<2147483648 := by omega
  have hcall (m' : BitVec 64) := FprHeaderTotal.header_pack sx (e+9#32) m' hpack
  simp (config := { maxSteps := 200000 })
    [FprPrimitives.execBlock,FprPrimitives.execScalar,FprAST.addCode,CLogic.step,CLogic.eval,
     B20.C.Scalar.assign,B20.C.update,B20.C.cast,ht,he,hm,hs,
     FprUnsignedPrefixes.addTypes,FprUnsignedPrefixes.xyTypes,UnsignedState.setType,List.foldl,
     literalValue,bin,commonTy,Val.ty,bitsOp,shift,ha.1,hcall]

theorem norm_tail_total (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (he : s.values ['e','x']=some (.i32 e)) (hm : s.values ['x','u']=some (.u64 m))
    (hs : s.values ['s','x']=some (.i32 sx)) (hb : -1078≤e.toInt ∧ e.toInt≤969) :
    ∃ out word, FprPrimitives.execBlock 228 .u64 (FprAST.addCode.body.drop 28) s=
      some (out,some (.u64 word)) := by
  obtain ⟨sm,em,mm,hmacro,ready,hlo,hhi⟩ := FprNormTotal.norm_total s e sx m ht he hm hs hb
  obtain ⟨ht',he',hm',hs'⟩ := FprNormTotal.clean_norm s sm em sx mm ht ready
  let clean := FprPrimitives.leaveBlock s sm (FprPrimitives.scalarDecls FprAST.normCode)
  obtain ⟨out,word,htail⟩ := tail_total clean em sx mm (ht'.trans ht) he' hm' hs' ⟨hlo,hhi⟩
  have hshape : FprAST.addCode.body.drop 28 =
      .norm ['x','u'] ['e','x']::FprAST.addCode.body.drop 29 := by rfl
  refine ⟨out,word,?_⟩
  rw [hshape,FprPrimitives.execBlock,FprAST.norm_binding]
  change (FprPrimitives.execScalars FprAST.normCode s).bind
    (fun next => FprPrimitives.execBlock 227 .u64 (FprAST.addCode.body.drop 29)
      (FprPrimitives.leaveBlock s next (FprPrimitives.scalarDecls FprAST.normCode))) = _
  rw [hmacro]
  exact htail

end FT1536.Source3.FprAddTail

#print axioms FT1536.Source3.FprAddTail.tail_total
#print axioms FT1536.Source3.FprAddTail.norm_tail_total
