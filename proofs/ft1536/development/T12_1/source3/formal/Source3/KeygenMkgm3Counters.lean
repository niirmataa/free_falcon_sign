import Source3.KeygenMkgm3LastRow

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMkgm3Counters
open C99IntegerReference (Value Ty)
open C99ArrayReference (State)
open C99ModularReference (Stmt Exec)
open C99ProcedureReference (Result)
open KeygenMkgm3Program (var num)
open KeygenNttLoopSupport (USlot u64)
open KeygenNttButterflyCalls (U32Slot)

def single (name : String) (w : BitVec 32) : B20.C.Scalar.State :=
  (B20.C.Scalar.bindArgs [(.u32,name.toList)] [.u32 w]).getD B20.C.Scalar.emptyState

theorem single_typed (name : String) (w : BitVec 32) : C99Typing.WellTyped (single name w) :=
  (C99HeaderSound.bind_sound [(.u32,name.toList)] [.u32 w] (single name w) (by
    simp [single,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,
      B20.C.Scalar.assign,B20.C.cast])).2

theorem single_value (s : State) (name : String) (w : BitVec 32) (e : CLogic.Expr)
    (ty : B20.C.Ty) (expected : B20.C.Val) (v : Value)
    (slot : U32Slot s name w)
    (reads : C99ExpressionEnvironment.readNames (C99Frontend.expression e)=[name.toList])
    (typed : C99Typing.infer CertificatePrologue.noSignatures (single name w).types e=some ty)
    (model : ExpressionFuel.unbounded CertificatePrologue.emptyCalls (single name w).values e=some expected)
    (source : C99ArrayReference.scalar s e v) : v=C99ValueBridge.value expected := by
  have agree : C99ExpressionEnvironment.Agree s.locals (C99Typing.environment (single name w))
      (C99ExpressionEnvironment.readNames (C99Frontend.expression e)) := by
    intro n hn
    rw [reads] at hn
    have hn' : n=name.toList := List.mem_singleton.mp hn
    subst n
    simpa [single,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,
      B20.C.Scalar.assign,B20.C.update,C99Typing.environment,B20.C.cast,C99ValueBridge.value,
      U32Slot,C99ValueBridge.type] using slot
  have transported := C99ExpressionEnvironment.transport FprPrefixCalls.calls s.locals
    (C99Typing.environment (single name w)) _ v source agree
  have he := (C99ExpressionBridge.expression_complete CertificatePrologue.noSignatures FprPrefixCalls.calls
    CertificatePrologue.emptyCalls CertificatePrologue.pure_calls_complete (single name w)
    (single_typed name w) e ty v typed transported).1
  rw [model] at he
  have hv := congrArg C99ValueBridge.value (Option.some.inj he)
  rw [C99ValueBridge.value_encode] at hv
  exact hv.symm

def cubeLimit : CLogic.Expr := .bin .shl (.cast .u64 (num 1)) (.bin .add (var "k") (num 1))
def cubeStart : CLogic.Expr := .bin .shl (.cast .u64 (num 1)) (var "k")
def squareStart : CLogic.Expr := .bin .sub cubeStart (num 1)

theorem cube_limit (s : State) (v : Value) (slot : U32Slot s "k" 8)
    (source : C99ArrayReference.scalar s cubeLimit v) : v=u64 512 :=
  single_value s "k" 8 cubeLimit .u64 (.u64 512) v slot rfl rfl (by decide) source
theorem cube_start (s : State) (v : Value) (slot : U32Slot s "k" 8)
    (source : C99ArrayReference.scalar s cubeStart v) : v=u64 256 :=
  single_value s "k" 8 cubeStart .u64 (.u64 256) v slot rfl rfl (by decide) source
theorem square_start (s : State) (v : Value) (slot : U32Slot s "k" 8)
    (source : C99ArrayReference.scalar s squareStart v) : v=u64 255 :=
  single_value s "k" 8 squareStart .u64 (.u64 255) v slot rfl rfl (by decide) source

theorem less_value (s : State) (rhs : CLogic.Expr) (i bound : Nat) (v : Value)
    (hi : i<2^64) (hb : bound<2^64) (counter : USlot s "u" i)
    (right : ∀ w, C99ArrayReference.scalar s rhs w → w=u64 bound)
    (source : C99ArrayReference.scalar s (.cmp .lt (var "u") rhs) v) :
    v=C99ScalarReference.boolean (decide (i<bound)) := by
  obtain ⟨x,y,hx,hy,operation⟩ := KeygenNttForwardExec.eval_compare s.locals .lt _ _ v source
  have hx' := KeygenNttLoopSupport.variable_u64 s "u" i x counter hx
  have hy' := right y hy
  subst x; subst y
  have he := C99CountedWords.uint64_comparison .lt (BitVec.ofNat 64 i) (BitVec.ofNat 64 bound) v operation
  have hni : (BitVec.ofNat 64 i).toNat=i := Nat.mod_eq_of_lt hi
  have hnb : (BitVec.ofNat 64 bound).toNat=bound := Nat.mod_eq_of_lt hb
  rw [hni,hnb] at he
  change v=C99ScalarReference.boolean (decide ((i : Int)<(bound : Int))) at he
  have hlt : ((i : Int)<(bound : Int)) ↔ i<bound := by omega
  simpa only [hlt] using he

theorem boolean_true (b : Prop) [Decidable b] (v : Value)
    (he : v=C99ScalarReference.boolean (decide b)) (nonzero : v.integer≠0) : b := by
  by_contra h
  simp [he,h,C99ScalarReference.boolean,Value.integer] at nonzero

theorem boolean_false (b : Prop) [Decidable b] (v : Value)
    (he : v=C99ScalarReference.boolean (decide b)) (zero : v.integer=0) : ¬b := by
  intro h
  simp [he,h,C99ScalarReference.boolean,Value.integer] at zero

theorem positive_value (s : State) (i : Nat) (v : Value) (hi : i<2^64) (counter : USlot s "u" i)
    (source : C99ArrayReference.scalar s (.cmp .gt (var "u") (num 0)) v) :
    v=C99ScalarReference.boolean (decide (0 < i)) := by
  obtain ⟨x,y,hx,hy,operation⟩ := KeygenNttForwardExec.eval_compare s.locals .gt _ _ v source
  have hx' := KeygenNttLoopSupport.variable_u64 s "u" i x counter hx
  have hy' := KeygenNttLoopSupport.literal_i32 s 0 y hy
  subst x; subst y
  have he := C99CountedWords.comparison_result .gt (u64 i) (C99IntegerReference.convert .int32 0) v operation
  change v=C99ScalarReference.boolean (C99IntegerReference.compare .gt
    (C99IntegerReference.convert .uint64 (u64 i).integer).integer 0) at he
  rw [KeygenNttLoopSupport.convert_u64_self i hi,KeygenNttLoopSupport.u64_integer i hi] at he
  change v=C99ScalarReference.boolean (decide ((0 : Int)<(i : Int))) at he
  have hlt : ((0 : Int)<(i : Int)) ↔ 0 < i := by omega
  simpa only [hlt] using he

theorem add_two (i : Nat) (hi : i<2^64) (v : Value)
    (source : C99IntegerReference.ArithmeticExec .plus (u64 i) (C99IntegerReference.convert .int32 2) v) :
    v=u64 (i+2) := by
  have he := ((C99IntegerReference.arithmetic_iff _ _ _ _).mp source).2
  change v=C99IntegerReference.convert .uint64
    ((C99IntegerReference.convert .uint64 (u64 i).integer).integer+2) at he
  rw [KeygenNttLoopSupport.convert_u64_self i hi,KeygenNttLoopSupport.u64_integer i hi] at he
  have hadd : (i : Int)+2=((i+2 : Nat) : Int) := by omega
  rw [he,hadd,KeygenNttLoopSupport.convert_u64_nat]

theorem sub_one (i : Nat) (hi : i<2^64) (positive : 0 < i) (v : Value)
    (source : C99IntegerReference.ArithmeticExec .minus (u64 i) (C99IntegerReference.convert .int32 1) v) :
    v=u64 (i-1) := by
  have he := ((C99IntegerReference.arithmetic_iff _ _ _ _).mp source).2
  change v=C99IntegerReference.convert .uint64
    ((C99IntegerReference.convert .uint64 (u64 i).integer).integer-1) at he
  rw [KeygenNttLoopSupport.convert_u64_self i hi,KeygenNttLoopSupport.u64_integer i hi] at he
  have hsub : (i : Int)-1=((i-1 : Nat) : Int) := by omega
  rw [he,hsub,KeygenNttLoopSupport.convert_u64_nat]

def advanced (s : State) (i : Nat) : State := C99ArrayReference.bindValue s "u".toList .uint64 (u64 i)
theorem advanced_counter (s : State) (i : Nat) (hi : i<2^64) : USlot (advanced s i) "u" i := by
  simp [USlot,advanced,C99ArrayReference.bindValue,C99ScalarReference.set,KeygenNttLoopSupport.convert_u64_self i hi]

theorem update_result (s : State) (out : Result) (i next delta : Nat)
    (slot : USlot s "u" i) (op : B20.C.BinOp)
    (value : ∀ v, C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (C99Frontend.binary op (.variable "u".toList) (C99Frontend.expression (num delta))) v → v=u64 next)
    (source : Exec (.base (.scalar (.update "u".toList op (num delta)))) s out) :
    out=⟨advanced s next,.normal⟩ := by
  obtain ⟨ty,old,v,declared,ev,he⟩ := KeygenNttLoopSupport.update_result _ _ _ s out source
  have ht := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
  change ty=Ty.uint64 at ht
  subst ty
  rw [he,value v ev]
  rfl

theorem increment_one (s : State) (out : Result) (i : Nat) (hi : i<2^64) (slot : USlot s "u" i)
    (source : Exec (KeygenMkgm3Program.inc "u") s out) : out=⟨advanced s (i+1),.normal⟩ := by
  apply update_result s out i (i+1) 1 slot .add _ source
  intro v ev
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v ev
  have hx' := KeygenNttLoopSupport.variable_u64 s "u" i x slot hx
  have hy' := KeygenNttLoopSupport.literal_i32 s 1 y hy
  subst x; subst y
  exact KeygenNttLoopSupport.add_one_literal i hi v hop

theorem increment_two (s : State) (out : Result) (i : Nat) (hi : i<2^64) (slot : USlot s "u" i)
    (source : Exec (.base (.scalar (.update "u".toList .add (num 2)))) s out) :
    out=⟨advanced s (i+2),.normal⟩ := by
  apply update_result s out i (i+2) 2 slot .add _ source
  intro v ev
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v ev
  have hx' := KeygenNttLoopSupport.variable_u64 s "u" i x slot hx
  have hy' := KeygenNttLoopSupport.literal_i32 s 2 y hy
  subst x; subst y
  exact add_two i hi v hop

theorem decrement_one (s : State) (out : Result) (i : Nat) (hi : i<2^64) (positive : 0 < i)
    (slot : USlot s "u" i) (source : Exec (KeygenMkgm3Program.dec "u") s out) :
    out=⟨advanced s (i-1),.normal⟩ := by
  apply update_result s out i (i-1) 1 slot .sub _ source
  intro v ev
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .minus _ _ v ev
  have hx' := KeygenNttLoopSupport.variable_u64 s "u" i x slot hx
  have hy' := KeygenNttLoopSupport.literal_i32 s 1 y hy
  subst x; subst y
  exact sub_one i hi positive v hop

end FT1536.Source3.KeygenMkgm3Counters
