import Source3.ModularAtoms178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModpDivSelect178
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenModpR2Exec (Slot)

def index (n : Nat) : BitVec 32 := BitVec.ofInt 32 (n : Int)
def word (z z2 e : BitVec 32) (n : Nat) : BitVec 32 := z ^^^ ((z ^^^ z2) &&& -((e >>> n) &&& 1#32))
def expression : CLogic.Expr := .bin .xor (.var "z".toList) C99ModularReference.divSelect
def params : List (B20.C.Ty×B20.C.Name) :=
  [(.u32,"z".toList),(.u32,"z2".toList),(.u32,"e".toList),(.i32,"i".toList)]
def model (z z2 e : BitVec 32) (n : Nat) : B20.C.Scalar.State :=
  (B20.C.Scalar.bindArgs params [.u32 z,.u32 z2,.u32 e,.i32 (index n)]).getD B20.C.Scalar.emptyState

theorem index_value (n : Nat) (bound : n<31) : (index n).toInt=(n : Int) := by
  apply BitVec.toInt_ofInt_eq_self <;> omega

theorem index_nat (n : Nat) (bound : n<31) : (index n).toNat=n := by
  simp only [index,BitVec.ofInt_natCast,BitVec.toNat_ofNat]
  exact Nat.mod_eq_of_lt (by omega)

theorem typed (z z2 e : BitVec 32) (n : Nat) : C99Typing.WellTyped (model z z2 e n) :=
  (C99HeaderSound.bind_sound params [.u32 z,.u32 z2,.u32 e,.i32 (index n)] (model z z2 e n) rfl).2

theorem computed (z z2 e : BitVec 32) (n : Nat) (bound : n<31) :
    ExpressionFuel.unbounded CertificatePrologue.emptyCalls (model z z2 e n).values expression=
      some (.u32 (word z z2 e n)) := by
  have count : n<32 := by omega
  simp [ExpressionFuel.unbounded,model,params,expression,C99ModularReference.divSelect,word,
    B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,B20.C.Scalar.assign,
    B20.C.update,B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,
    B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,B20.C.shift,B20.C.neg,index_nat n bound,count]

theorem agreement (s : State) (z z2 e : BitVec 32) (n : Nat)
    (hz : Slot s "z" z) (hz2 : Slot s "z2" z2) (he : Slot s "e" e)
    (hi : s.locals "i".toList=some (.int32,some (.int32 (index n)))) :
    C99ExpressionEnvironment.Agree s.locals (C99Typing.environment (model z z2 e n))
      (C99ExpressionEnvironment.readNames (C99Frontend.expression expression)) := by
  intro name member
  change name∈["z".toList,"z".toList,"z2".toList,"e".toList,"i".toList] at member
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl
  · exact hz
  · exact hz
  · exact hz2
  · exact he
  · exact hi

theorem source (s : State) (z z2 e : BitVec 32) (n : Nat) (bound : n<31)
    (hz : Slot s "z" z) (hz2 : Slot s "z2" z2) (he : Slot s "e" e)
    (hi : s.locals "i".toList=some (.int32,some (.int32 (index n)))) :
    C99ArrayReference.scalar s expression (.uint32 (word z z2 e n)) := by
  have run := C99ExpressionSound.expression_sound FprPrefixCalls.calls CertificatePrologue.emptyCalls
    CertificatePrologue.pure_calls_sound (model z z2 e n) (typed z z2 e n) expression _ (computed z z2 e n bound)
  exact C99ExpressionEnvironment.transport FprPrefixCalls.calls
    (C99Typing.environment (model z z2 e n)) s.locals _ _ run
    (fun name member => (agreement s z z2 e n hz hz2 he hi name member).symm)

end FT1536.Source3.ModpDivSelect178
