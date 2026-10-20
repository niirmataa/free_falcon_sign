import Source3.FprUnsignedPrefixes

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprDivRound
open B20.C

def roundCode : List FprPrimitives.Instr :=
  match (FprAST.divCode.body[5]? : Option FprPrimitives.Instr) with
  | some (FprPrimitives.Instr.forInc _ _ body) => body
  | _ => []

def mask (xu yu : BitVec 64) : BitVec 64 := ((xu-yu) >>> 63)-1
def nextX (xu yu : BitVec 64) : BitVec 64 := (xu-(mask xu yu &&& yu)) <<< 1
def nextQ (xu yu q : BitVec 64) : BitVec 64 := (q ||| (mask xu yu &&& 1)) <<< 1

def rawAfter (s : B20.C.Scalar.State) (xu yu q : BitVec 64) : B20.C.Scalar.State :=
  { types := UnsignedState.setType s.types ['b'] .u64,
    values := update (update (update s.values ['b'] (.u64 (mask xu yu)))
      ['x','u'] (.u64 (nextX xu yu))) ['q'] (.u64 (nextQ xu yu q)) }

theorem round_execution (s : B20.C.Scalar.State) (xu yu q : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.divTypes)
    (hx : s.values ['x','u']=some (.u64 xu))
    (hy : s.values ['y','u']=some (.u64 yu))
    (hq : s.values ['q']=some (.u64 q)) :
    FprPrimitives.execBlock 250 .u64 roundCode s=some (rawAfter s xu yu q,none) := by
  simp [roundCode,FprAST.divCode,FprPrimitives.execBlock,FprPrimitives.execScalar,
    CLogic.step,CLogic.eval,B20.C.Scalar.declareMany,B20.C.Scalar.declareOne,
    B20.C.Scalar.assign,B20.C.update,B20.C.cast,literalValue,bin,commonTy,Val.ty,bitsOp,shift,
    ht,hx,hy,hq,FprUnsignedPrefixes.divTypes,FprUnsignedPrefixes.xyTypes,
    UnsignedState.setType,List.foldl,rawAfter,mask,nextX,nextQ]
  constructor
  · rfl
  · funext name
    by_cases hq : name=['q'] <;> by_cases hx : name=['x','u'] <;>
      simp [B20.C.update,hq,hx]

def cleaned (s : B20.C.Scalar.State) (xu yu q : BitVec 64) : B20.C.Scalar.State :=
  FprPrimitives.leaveBlock s (rawAfter s xu yu q) (FprPrimitives.blockDecls roundCode)

theorem clean_types (s : B20.C.Scalar.State) (xu yu q : BitVec 64) :
    (cleaned s xu yu q).types=s.types := by
  funext name
  by_cases hb : name=['b']
  · subst name
    simp [cleaned,FprPrimitives.leaveBlock,FprPrimitives.blockDecls,roundCode,FprAST.divCode]
  · simp [cleaned,FprPrimitives.leaveBlock,FprPrimitives.blockDecls,roundCode,
      FprAST.divCode,rawAfter,UnsignedState.setType,hb]

theorem clean_values (s : B20.C.Scalar.State) (xu yu q : BitVec 64) :
    (cleaned s xu yu q).values =
      update (update s.values ['x','u'] (.u64 (nextX xu yu))) ['q'] (.u64 (nextQ xu yu q)) := by
  funext name
  by_cases hb : name=['b']
  · subst name
    simp [cleaned,FprPrimitives.leaveBlock,FprPrimitives.blockDecls,roundCode,FprAST.divCode,update]
  · simp [cleaned,FprPrimitives.leaveBlock,FprPrimitives.blockDecls,roundCode,
      FprAST.divCode,rawAfter,update,hb]

end FT1536.Source3.FprDivRound

#print axioms FT1536.Source3.FprDivRound.round_execution
#print axioms FT1536.Source3.FprDivRound.clean_values
