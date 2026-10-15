import Source3.FprNormTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprNormSteps137
open B20.C
open FprNormTotal (Ready normTypes)

def step (value : BitVec 32 × BitVec 64) (rs ms : Nat) (es : Fin 6) : BitVec 32 × BitVec 64 :=
  (value.1+FprNormRound.delta value.2 rs es,FprNormRound.nextM value.2 rs ms)

def lastE (e : BitVec 32) (m : BitVec 64) : BitVec 32 := e+(m >>> 63).setWidth 32

def lastM (m : BitVec 64) : BitVec 64 :=
  m ^^^ ((m ^^^ (m <<< 1)) &&& (((m >>> 63).setWidth 32).setWidth 64-1))

def result (e : BitVec 32) (m : BitVec 64) : BitVec 32 × BitVec 64 :=
  let v0 := (e-63#32,m)
  let v1 := step v0 32 32 5
  let v2 := step v1 48 16 4
  let v3 := step v2 56 8 3
  let v4 := step v3 60 4 2
  let v5 := step v4 62 2 1
  (lastE v5.1 v5.2,lastM v5.2)

theorem start_source (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (he : s.values ['e','x']=some (.i32 e)) (hm : s.values ['x','u']=some (.u64 m))
    (hs : s.values ['s','x']=some (.i32 sx)) (hb : -1078≤e.toInt ∧ e.toInt≤969) :
    ∃ out, UnsignedState.exec FprPrimitives.headerCalls s (FprAST.normCode.take 2)=some out ∧
      Ready out (e-63#32) m sx ∧ -1141≤(e-63#32).toInt ∧ (e-63#32).toInt≤906 := by
  have constant : (63#32).toInt=(63 : Int) := by decide +kernel
  have safe := FprSmallSigned.sub32 e 63#32 (by rw [constant]; omega)
  let out : B20.C.Scalar.State := {types := normTypes,values := update s.values ['e','x'] (.i32 (e-63#32))}
  refine ⟨out,?_,?_,by omega,by omega⟩
  · simp [UnsignedState.exec,FprAST.normCode,CLogic.step,CLogic.eval,B20.C.Scalar.declareMany,
      B20.C.Scalar.declareOne,B20.C.Scalar.assign,B20.C.cast,ht,he,
      FprUnsignedPrefixes.addTypes,FprUnsignedPrefixes.xyTypes,UnsignedState.setType,List.foldl,
      normTypes,out,literalValue,bin,commonTy,Val.ty,bitsOp,safe.1]
    rfl
  · exact ⟨rfl,by simp [out,update],by simp [out,update,hm],by simp [out,update,hs]⟩

theorem round_source (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (rs ms : Nat) (es : Fin 6) (hrs : rs<64) (hms : ms<64)
    (ready : Ready s e m sx) (bounds : -2000≤e.toInt ∧ e.toInt≤2000) :
    ∃ out, UnsignedState.exec FprPrimitives.headerCalls s (FprNormRound.code rs ms es)=some out ∧
      Ready out (step (e,m) rs ms es).1 (step (e,m) rs ms es).2 sx ∧
      e.toInt≤(step (e,m) rs ms es).1.toInt ∧ (step (e,m) rs ms es).1.toInt≤e.toInt+32 := by
  have nt : s.types ['n','t']=some .u32 := by rw [ready.types]; rfl
  have mant : s.types ['x','u']=some .u64 := by rw [ready.types]; rfl
  have exp : s.types ['e','x']=some .i32 := by rw [ready.types]; rfl
  obtain ⟨source,low,high⟩ := FprNormRound.round_exec s m e rs ms es hrs hms nt mant exp ready.mantissa ready.exponent bounds
  refine ⟨FprNormRound.after s m e rs ms es,source,?_,low,high⟩
  exact ⟨ready.types,by simp [step,FprNormRound.after,update],by simp [step,FprNormRound.after,update],
    by simp [FprNormRound.after,update,ready.sign]⟩

theorem last_source (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ready : Ready s e m sx) (bounds : -2000≤e.toInt ∧ e.toInt≤2000) :
    ∃ out, UnsignedState.exec FprPrimitives.headerCalls s (FprAST.normCode.drop 22)=some out ∧
      Ready out (lastE e m) (lastM m) sx ∧ e.toInt≤(lastE e m).toInt ∧ (lastE e m).toInt≤e.toInt+1 := by
  let nt := (m >>> 63).setWidth 32
  have small : nt.toNat≤1 := by
    have bound := m.isLt
    simp only [nt,BitVec.toNat_setWidth,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
    omega
  have integer := BitVec.toInt_eq_toNat_of_lt (x:=nt) (by omega)
  have safe := FprSmallSigned.add32 e nt (by omega)
  let out : B20.C.Scalar.State := {s with values := update (update (update s.values
    ['n','t'] (.u32 nt)) ['x','u'] (.u64 (lastM m))) ['e','x'] (.i32 (lastE e m))}
  refine ⟨out,?_,?_,?_,?_⟩
  · simp [UnsignedState.exec,FprAST.normCode,CLogic.step,CLogic.eval,B20.C.Scalar.assign,
      B20.C.update,B20.C.cast,ready.types,ready.exponent,ready.mantissa,
      normTypes,FprUnsignedPrefixes.addTypes,FprUnsignedPrefixes.xyTypes,UnsignedState.setType,List.foldl,
      out,lastM,lastE,literalValue,bin,commonTy,Val.ty,bitsOp,shift,safe.1,nt]
  · exact ⟨ready.types,by simp [out,update],by simp [out,update],by simp [out,update,ready.sign]⟩
  · change e.toInt≤(e+nt).toInt
    omega
  · change (e+nt).toInt≤e.toInt+1
    omega

end FT1536.Source3.FprNormSteps137
