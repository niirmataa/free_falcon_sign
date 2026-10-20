import Source3.FprNormRound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprNormTotal
open B20.C

def normTypes := UnsignedState.setType FprUnsignedPrefixes.addTypes ['n','t'] .u32

structure Ready (s : B20.C.Scalar.State) (e : BitVec 32) (m : BitVec 64) (sx : BitVec 32) : Prop where
  types : s.types=normTypes
  exponent : s.values ['e','x']=some (.i32 e)
  mantissa : s.values ['x','u']=some (.u64 m)
  sign : s.values ['s','x']=some (.i32 sx)

theorem start_total (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (he : s.values ['e','x']=some (.i32 e)) (hm : s.values ['x','u']=some (.u64 m))
    (hs : s.values ['s','x']=some (.i32 sx))
    (hb : -1078≤e.toInt ∧ e.toInt≤969) :
    ∃ out e', UnsignedState.exec FprPrimitives.headerCalls s (FprAST.normCode.take 2)=some out ∧
      Ready out e' m sx ∧ -1141≤e'.toInt ∧ e'.toInt≤906 := by
  have c : (63#32).toInt=(63 : Int) := by decide
  have ha := FprSmallSigned.sub32 e 63#32 (by rw [c]; omega)
  let out : B20.C.Scalar.State := {types := normTypes,values := update s.values ['e','x'] (.i32 (e-63#32))}
  refine ⟨out,e-63#32,?_,?_,by omega,by omega⟩
  · simp [UnsignedState.exec,FprAST.normCode,CLogic.step,CLogic.eval,B20.C.Scalar.declareMany,
      B20.C.Scalar.declareOne,B20.C.Scalar.assign,B20.C.cast,ht,he,
      FprUnsignedPrefixes.addTypes,FprUnsignedPrefixes.xyTypes,UnsignedState.setType,List.foldl,
      normTypes,out,literalValue,bin,commonTy,Val.ty,bitsOp,ha.1]
    rfl
  · exact ⟨rfl,by simp [out,update],by simp [out,update,hm],by simp [out,update,hs]⟩

theorem round_total (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (rs ms : Nat) (es : Fin 6) (hrs : rs<64) (hms : ms<64)
    (hr : Ready s e m sx) (hb : -2000≤e.toInt ∧ e.toInt≤2000) :
    ∃ out e' m', UnsignedState.exec FprPrimitives.headerCalls s (FprNormRound.code rs ms es)=some out ∧
      Ready out e' m' sx ∧ e.toInt≤e'.toInt ∧ e'.toInt≤e.toInt+32 := by
  have htn : s.types ['n','t']=some .u32 := by rw [hr.types]; rfl
  have htm : s.types ['x','u']=some .u64 := by rw [hr.types]; rfl
  have hte : s.types ['e','x']=some .i32 := by rw [hr.types]; rfl
  obtain ⟨hcode,hlo,hhi⟩ := FprNormRound.round_exec s m e rs ms es hrs hms
    htn htm hte hr.mantissa hr.exponent hb
  refine ⟨FprNormRound.after s m e rs ms es,e+FprNormRound.delta m rs es,
    FprNormRound.nextM m rs ms,hcode,?_,hlo,hhi⟩
  exact ⟨hr.types,by simp [FprNormRound.after,update],by simp [FprNormRound.after,update],
    by simp [FprNormRound.after,update,hr.sign]⟩

theorem last_total (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (hr : Ready s e m sx) (hb : -2000≤e.toInt ∧ e.toInt≤2000) :
    ∃ out e' m', UnsignedState.exec FprPrimitives.headerCalls s (FprAST.normCode.drop 22)=some out ∧
      Ready out e' m' sx ∧ e.toInt≤e'.toInt ∧ e'.toInt≤e.toInt+1 := by
  let nt := (m >>> 63).setWidth 32
  have hn : nt.toNat≤1 := by
    have h := m.isLt
    simp only [nt,BitVec.toNat_setWidth,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
    omega
  have hnat := BitVec.toInt_eq_toNat_of_lt (x:=nt) (by omega)
  have ha := FprSmallSigned.add32 e nt (by omega)
  let mant := m ^^^ ((m ^^^ (m <<< 1)) &&& (nt.setWidth 64-1))
  let out : B20.C.Scalar.State :=
    {s with values := update (update (update s.values ['n','t'] (.u32 nt))
      ['x','u'] (.u64 mant)) ['e','x'] (.i32 (e+nt))}
  refine ⟨out,e+nt,mant,?_,?_,by omega,by omega⟩
  · simp [UnsignedState.exec,FprAST.normCode,CLogic.step,CLogic.eval,B20.C.Scalar.assign,
      B20.C.update,B20.C.cast,hr.types,hr.exponent,hr.mantissa,
      normTypes,FprUnsignedPrefixes.addTypes,FprUnsignedPrefixes.xyTypes,UnsignedState.setType,List.foldl,
      out,mant,literalValue,bin,commonTy,Val.ty,bitsOp,shift,ha.1,nt]
  · exact ⟨hr.types,by simp [out,update],by simp [out,update],by simp [out,update,hr.sign]⟩

theorem norm_total (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (he : s.values ['e','x']=some (.i32 e)) (hm : s.values ['x','u']=some (.u64 m))
    (hs : s.values ['s','x']=some (.i32 sx)) (hb : -1078≤e.toInt ∧ e.toInt≤969) :
    ∃ out e' m', FprPrimitives.execScalars FprAST.normCode s=some out ∧
      Ready out e' m' sx ∧ -1141≤e'.toInt ∧ e'.toInt≤1067 := by
  obtain ⟨s0,e0,h0,r0,l0,u0⟩ := start_total s e sx m ht he hm hs hb
  obtain ⟨s1,e1,m1,h1,r1,l1,u1⟩ := round_total s0 e0 sx m 32 32 5 (by decide) (by decide) r0 (by omega)
  obtain ⟨s2,e2,m2,h2,r2,l2,u2⟩ := round_total s1 e1 sx m1 48 16 4 (by decide) (by decide) r1 (by omega)
  obtain ⟨s3,e3,m3,h3,r3,l3,u3⟩ := round_total s2 e2 sx m2 56 8 3 (by decide) (by decide) r2 (by omega)
  obtain ⟨s4,e4,m4,h4,r4,l4,u4⟩ := round_total s3 e3 sx m3 60 4 2 (by decide) (by decide) r3 (by omega)
  obtain ⟨s5,e5,m5,h5,r5,l5,u5⟩ := round_total s4 e4 sx m4 62 2 1 (by decide) (by decide) r4 (by omega)
  obtain ⟨s6,e6,m6,h6,r6,l6,u6⟩ := last_total s5 e5 sx m5 r5 (by omega)
  refine ⟨s6,e6,m6,?_,r6,by omega,by omega⟩
  have hcode : FprAST.normCode = FprAST.normCode.take 2 ++
      (FprNormRound.code 32 32 5 ++ FprNormRound.code 48 16 4 ++
       FprNormRound.code 56 8 3 ++ FprNormRound.code 60 4 2 ++
       FprNormRound.code 62 2 1 ++ FprAST.normCode.drop 22) := by rfl
  rw [FprScalarSequence.exec_scalars,hcode]
  simp only [FprScalarSequence.exec_append,h0,h1,h2,h3,h4,h5,h6,Option.bind_some]

theorem clean_norm (s out : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes) (ready : Ready out e m sx) :
    let clean := FprPrimitives.leaveBlock s out (FprPrimitives.scalarDecls FprAST.normCode)
    clean.types=s.types ∧ clean.values ['e','x']=some (.i32 e) ∧
    clean.values ['x','u']=some (.u64 m) ∧ clean.values ['s','x']=some (.i32 sx) := by
  refine ⟨?_,?_,?_,?_⟩
  · funext name
    by_cases hnt : name=['n','t']
    · subst name
      rfl
    · simp [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,FprAST.normCode,
        ready.types,normTypes,UnsignedState.setType,hnt,ht]
  · simpa [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,FprAST.normCode] using ready.exponent
  · simpa [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,FprAST.normCode] using ready.mantissa
  · simpa [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,FprAST.normCode] using ready.sign

end FT1536.Source3.FprNormTotal

#print axioms FT1536.Source3.FprNormTotal.start_total
#print axioms FT1536.Source3.FprNormTotal.round_total
#print axioms FT1536.Source3.FprNormTotal.last_total
#print axioms FT1536.Source3.FprNormTotal.norm_total
#print axioms FT1536.Source3.FprNormTotal.clean_norm
