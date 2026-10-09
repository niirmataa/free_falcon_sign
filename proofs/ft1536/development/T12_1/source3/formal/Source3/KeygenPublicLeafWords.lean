import Source3.KeygenPublicLinear
import Source3.KeygenModpSet

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact uint32 expressions for the public modular leaves. The complete
   operational Body, including parameter/return conversion, is the input.
   Canonical range and residue algebra are proved separately. -/
namespace FT1536.Source3.KeygenPublicLeafWords
open B20.C C99ValueBridge
open KeygenPublicScalar (Kind)

def var (n : String) : CLogic.Expr := .var n.toList
def correction (n : String) : CLogic.Expr :=
  .bin .band (var "q") (.neg (.bin .shr (var n) (.literal .i32 31)))
def code (kind : Kind) : CLogic.Function :=
  ⟨KeygenPublicScalar.name kind,.u32,
    (KeygenPublicScalar.params kind).map (fun (ty,n) =>
      (if ty=.int32 then Ty.i32 else Ty.u32,n)),
    match kind with
    | .conv => [.declare .u32 ["y".toList],.assign "y".toList (.cast .u32 (var "x")),
        .update "y".toList .add (correction "y"),.ret (var "y")]
    | .add | .sub => [.declare .u32 ["d".toList],
        .assign "d".toList (if kind=.add then .bin .sub (.bin .add (var "x") (var "y")) (var "q")
          else .bin .sub (var "x") (var "y")),
        .update "d".toList .add (correction "d"),.ret (var "d")]
    | .half => [.update "x".toList .add (.bin .band (var "q") (.neg (.bin .band (var "x") (.literal .i32 1)))),
        .ret (.bin .shr (var "x") (.literal .i32 1))]
    | .mul => [.declare .u32 ["z".toList,"w".toList],
        .assign "z".toList (.bin .mul (var "x") (var "y")),
        .assign "w".toList (.bin .mul (.bin .band (.bin .mul (var "z") (var "q0i")) (.literal .i32 65535)) (var "q")),
        .assign "z".toList (.bin .shr (.bin .add (var "z") (var "w")) (.literal .i32 16)),
        .update "z".toList .sub (var "q"),.update "z".toList .add (correction "z"),.ret (var "z")]
    | _ => []⟩
def locals : Kind → List B20.C.Name
  | .conv => ["y".toList]
  | .add | .sub => ["d".toList]
  | .mul => ["z".toList,"w".toList]
  | _ => []
def Supported (kind : Kind) : Prop := kind∈[Kind.conv,.add,.sub,.half,.mul]
instance (kind : Kind) : Decidable (Supported kind) :=
  inferInstanceAs (Decidable (kind∈[Kind.conv,.add,.sub,.half,.mul]))
theorem source_binding (kind : Kind) (supported : Supported kind) :
    KeygenPublicScalar.code kind=KeygenPublicLinear.body (code kind).body := by
  cases kind with
  | conv | add | sub | half | mul => decide
  | square | divB | divT | rev => simp [Supported] at supported
theorem checked (kind : Kind) (supported : Supported kind) :
    C99HeaderProof.checked C99HeaderProof.noSignature (code kind)=true := by
  cases kind with
  | conv | add | sub | half | mul => decide
  | square | divB | divT | rev => simp [Supported] at supported

def montgomery (x y q q0i : BitVec 32) : BitVec 32 :=
  let z := x*y
  let w := ((z*q0i) &&& 65535#32)*q
  KeygenMontgomery.conditionalSubtract ((z+w) >>> 16) q
def half (x q : BitVec 32) : BitVec 32 := (x+(q &&& -(x &&& 1#32))) >>> 1

theorem add_model (x y q : BitVec 32) :
    CLogic.execute (fun _ _ => none) (code .add) [.u32 x,.u32 y,.u32 q]=
      some (.u32 (KeygenModpAddSub.result .add x y q)) := by
  simp [CLogic.execute,code,var,correction,KeygenModpAddSub.result,
    B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,
    B20.C.Scalar.declareMany,B20.C.Scalar.assign,CLogic.evalBody,CLogic.step,CLogic.eval,
    B20.C.update,B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,
    B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,B20.C.shift,B20.C.neg,KeygenPublicScalar.params]
theorem sub_model (x y q : BitVec 32) :
    CLogic.execute (fun _ _ => none) (code .sub) [.u32 x,.u32 y,.u32 q]=
      some (.u32 (KeygenModpAddSub.result .sub x y q)) := by
  simp [CLogic.execute,code,var,correction,KeygenModpAddSub.result,
    B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,
    B20.C.Scalar.declareMany,B20.C.Scalar.assign,CLogic.evalBody,CLogic.step,CLogic.eval,
    B20.C.update,B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,
    B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,B20.C.shift,B20.C.neg,KeygenPublicScalar.params]
theorem mul_model (x y q q0i : BitVec 32) :
    CLogic.execute (fun _ _ => none) (code .mul) [.u32 x,.u32 y,.u32 q,.u32 q0i]=
      some (.u32 (montgomery x y q q0i)) := by
  simp [CLogic.execute,code,var,correction,montgomery,KeygenMontgomery.conditionalSubtract,
    B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,
    B20.C.Scalar.declareMany,B20.C.Scalar.assign,CLogic.evalBody,CLogic.step,CLogic.eval,
    B20.C.update,B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,
    B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,B20.C.shift,B20.C.neg,KeygenPublicScalar.params]
theorem conv_model (x q : BitVec 32) :
    CLogic.execute (fun _ _ => none) (code .conv) [.i32 x,.u32 q]=
      some (.u32 (KeygenModpSet.word x q)) := by
  simp [CLogic.execute,code,var,correction,KeygenModpSet.word,
    B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,
    B20.C.Scalar.declareMany,B20.C.Scalar.assign,CLogic.evalBody,CLogic.step,CLogic.eval,
    B20.C.update,B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,
    B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,B20.C.shift,B20.C.neg,KeygenPublicScalar.params]
theorem half_model (x q : BitVec 32) :
    CLogic.execute (fun _ _ => none) (code .half) [.u32 x,.u32 q]=some (.u32 (half x q)) := by
  simp [CLogic.execute,code,var,half,
    B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,
    B20.C.Scalar.assign,CLogic.evalBody,CLogic.step,CLogic.eval,
    B20.C.update,B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,
    B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,B20.C.shift,B20.C.neg,KeygenPublicScalar.params]

theorem body_complete (kind : Kind) (supported : Supported kind)
    (calls : C99ModularReference.CallRelation) (args : List Val) (v : C99IntegerReference.Value)
    (parameters : C99ScalarReference.BindArgs ((code kind).params.map (fun (t,n) => (type t,n)))
      (args.map value) (C99ModularReference.bindParams KeygenPublicScalar.empty
        (KeygenPublicScalar.params kind) (args.map value)).locals)
    (source : KeygenPublicScalar.Body calls kind (args.map value) v) :
    CLogic.execute (fun _ _ => none) (code kind) args=some (encode v) := by
  obtain ⟨out,execution,returned⟩ := source.2
  rw [source_binding kind supported] at execution
  have projected := (KeygenPublicLinear.body_projection calls (code kind).body _ out execution).2
  have hr := KeygenPublicLinear.return_value out.flow v returned
  obtain ⟨raw,flow,equal⟩ := hr
  have returnedProjection : C99ScalarReference.Exec FprPrefixCalls.calls
      (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params kind) (args.map value)).locals
      (C99Frontend.scalars (code kind).body) (.returned raw) := by
    simpa only [KeygenPublicLinear.observation,flow] using projected
  have function : C99ScalarReference.FunctionExec FprPrefixCalls.calls
      (C99Frontend.headerFunction (code kind)) (args.map value) v := by
    rw [equal]
    exact .call _ _ _ parameters returnedProjection
  apply C99HeaderProof.function_complete C99HeaderProof.noSignature FprPrefixCalls.calls
    (fun _ _ => none) _ (code kind) args v (checked kind supported) function
  intro name arguments result ty signature
  simp [C99HeaderProof.noSignature] at signature

theorem bound_add_sub (kind : Kind) (hkind : kind=.add ∨ kind=.sub) (x y q : BitVec 32) :
    C99ScalarReference.BindArgs ((code kind).params.map (fun (t,n) => (type t,n)))
      [.uint32 x,.uint32 y,.uint32 q]
      (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params kind)
        [.uint32 x,.uint32 y,.uint32 q]).locals := by
  rcases hkind with rfl | rfl
  all_goals
    have h := C99ScalarReference.BindArgs.cons .uint32 "x".toList _ (.uint32 x) _ _
      (C99ScalarReference.BindArgs.cons .uint32 "y".toList _ (.uint32 y) _ _
        (C99ScalarReference.BindArgs.cons .uint32 "q".toList _ (.uint32 q) _ _
          C99ScalarReference.BindArgs.nil))
    convert h using 1
    · rfl
    · funext n
      simp only [KeygenPublicScalar.params,C99ModularReference.bindParams,
        C99ArrayReference.bindValue,KeygenPublicScalar.empty,C99ScalarReference.set]
      split_ifs <;> simp_all

theorem bound_mul (x y q q0i : BitVec 32) :
    C99ScalarReference.BindArgs ((code .mul).params.map (fun (t,n) => (type t,n)))
      [.uint32 x,.uint32 y,.uint32 q,.uint32 q0i]
      (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params .mul)
        [.uint32 x,.uint32 y,.uint32 q,.uint32 q0i]).locals := by
  have h := C99ScalarReference.BindArgs.cons .uint32 "x".toList _ (.uint32 x) _ _
    (C99ScalarReference.BindArgs.cons .uint32 "y".toList _ (.uint32 y) _ _
      (C99ScalarReference.BindArgs.cons .uint32 "q".toList _ (.uint32 q) _ _
        (C99ScalarReference.BindArgs.cons .uint32 "q0i".toList _ (.uint32 q0i) _ _
          C99ScalarReference.BindArgs.nil)))
  convert h using 1
  · rfl
  · funext n
    simp only [KeygenPublicScalar.params,C99ModularReference.bindParams,
      C99ArrayReference.bindValue,KeygenPublicScalar.empty,C99ScalarReference.set]
    split_ifs <;> simp_all

theorem bound_two (kind : Kind) (hk : kind=.conv ∨ kind=.half) (x q : BitVec 32) :
    C99ScalarReference.BindArgs ((code kind).params.map (fun (t,n) => (type t,n)))
      [if kind=.conv then .int32 x else .uint32 x,.uint32 q]
      (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params kind)
        [if kind=.conv then .int32 x else .uint32 x,.uint32 q]).locals := by
  rcases hk with rfl | rfl
  · have h := C99ScalarReference.BindArgs.cons .int32 "x".toList _ (.int32 x) _ _
      (C99ScalarReference.BindArgs.cons .uint32 "q".toList _ (.uint32 q) _ _ C99ScalarReference.BindArgs.nil)
    convert h using 1
    · rfl
    · rfl
    · funext n
      simp only [KeygenPublicScalar.params,C99ModularReference.bindParams,
        ite_true,
        C99ArrayReference.bindValue,KeygenPublicScalar.empty,C99ScalarReference.set]
      split_ifs <;> simp_all
  · have h := C99ScalarReference.BindArgs.cons .uint32 "x".toList _ (.uint32 x) _ _
      (C99ScalarReference.BindArgs.cons .uint32 "q".toList _ (.uint32 q) _ _ C99ScalarReference.BindArgs.nil)
    convert h using 1
    · rfl
    · rfl
    · funext n
      simp only [KeygenPublicScalar.params,C99ModularReference.bindParams,
        show Kind.half≠Kind.conv from by decide,ite_false,
        C99ArrayReference.bindValue,KeygenPublicScalar.empty,C99ScalarReference.set]
      split_ifs <;> simp_all

theorem source_add (calls : C99ModularReference.CallRelation) (x y q : BitVec 32) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Body calls .add [.uint32 x,.uint32 y,.uint32 q] v) :
    v=.uint32 (KeygenModpAddSub.result .add x y q) := by
  have he := body_complete .add (by decide) calls [.u32 x,.u32 y,.u32 q] v
    (bound_add_sub .add (Or.inl rfl) x y q) source
  rw [add_model] at he
  exact (value_encode v).symm.trans (congrArg value (Option.some.inj he)).symm
theorem source_sub (calls : C99ModularReference.CallRelation) (x y q : BitVec 32) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Body calls .sub [.uint32 x,.uint32 y,.uint32 q] v) :
    v=.uint32 (KeygenModpAddSub.result .sub x y q) := by
  have he := body_complete .sub (by decide) calls [.u32 x,.u32 y,.u32 q] v
    (bound_add_sub .sub (Or.inr rfl) x y q) source
  rw [sub_model] at he
  exact (value_encode v).symm.trans (congrArg value (Option.some.inj he)).symm
theorem source_mul (calls : C99ModularReference.CallRelation) (x y q q0i : BitVec 32) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Body calls .mul [.uint32 x,.uint32 y,.uint32 q,.uint32 q0i] v) :
    v=.uint32 (montgomery x y q q0i) := by
  have he := body_complete .mul (by decide) calls [.u32 x,.u32 y,.u32 q,.u32 q0i] v (bound_mul x y q q0i) source
  rw [mul_model] at he
  exact (value_encode v).symm.trans (congrArg value (Option.some.inj he)).symm
theorem source_conv (calls : C99ModularReference.CallRelation) (x q : BitVec 32) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Body calls .conv [.int32 x,.uint32 q] v) :
    v=.uint32 (KeygenModpSet.word x q) := by
  have he := body_complete .conv (by decide) calls [.i32 x,.u32 q] v (bound_two .conv (Or.inl rfl) x q) source
  rw [conv_model] at he
  exact (value_encode v).symm.trans (congrArg value (Option.some.inj he)).symm
theorem source_half (calls : C99ModularReference.CallRelation) (x q : BitVec 32) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Body calls .half [.uint32 x,.uint32 q] v) :
    v=.uint32 (half x q) := by
  have he := body_complete .half (by decide) calls [.u32 x,.u32 q] v (bound_two .half (Or.inr rfl) x q) source
  rw [half_model] at he
  exact (value_encode v).symm.trans (congrArg value (Option.some.inj he)).symm

end FT1536.Source3.KeygenPublicLeafWords
