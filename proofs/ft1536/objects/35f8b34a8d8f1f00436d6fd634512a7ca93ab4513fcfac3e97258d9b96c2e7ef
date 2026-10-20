import Source3.KeygenMontgomery

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenNinv31
open B20.C C99ValueBridge

def updateExpr : CLogic.Expr := .bin .sub (.literal .i32 2)
  (.bin .mul (.var "p".toList) (.var "y".toList))
def code : CLogic.Function where
  name := "modp_ninv31".toList
  result := .u32
  params := [(.u32,"p".toList)]
  body := [.declare .u32 ["y".toList],
    .assign "y".toList (.bin .sub (.literal .i32 2) (.var "p".toList)),
    .update "y".toList .mul updateExpr,
    .update "y".toList .mul updateExpr,
    .update "y".toList .mul updateExpr,
    .update "y".toList .mul updateExpr,
    .ret (.bin .band (.cast .u32 (.literal .i32 0x7fffffff)) (.neg (.var "y".toList)))]

theorem source_parses : CLogicParser.parseFunction
    (((Pinned.keygenLines.drop 2499).take 12).flatMap String.toList)=some code := by decide

def round (p y : BitVec 32) : BitVec 32 := y*(2-p*y)
def word (p : BitVec 32) : BitVec 32 :=
  let y := 2-p
  let y := round p y
  let y := round p y
  let y := round p y
  let y := round p y
  0x7fffffff#32 &&& -y

def initial (p : BitVec 32) : B20.C.Scalar.State where
  types n := if n="p".toList then some .u32 else none
  values n := if n="p".toList then some (.u32 p) else none
def declared (p : BitVec 32) : B20.C.Scalar.State where
  types n := if n="y".toList then some .u32 else (initial p).types n
  values := (initial p).values
def state (p y : BitVec 32) : B20.C.Scalar.State :=
  {(declared p) with values := update (initial p).values "y".toList (.u32 y)}
def updateStmt : CLogic.Stmt := .update "y".toList .mul updateExpr
def returnStmt : CLogic.Stmt :=
  .ret (.bin .band (.cast .u32 (.literal .i32 0x7fffffff)) (.neg (.var "y".toList)))

theorem declaration (p : BitVec 32) :
    CLogic.step (fun _ _ => none) (initial p) (.declare .u32 ["y".toList])=some (declared p) := by rfl
theorem initialization (p : BitVec 32) :
    CLogic.step (fun _ _ => none) (declared p)
      (.assign "y".toList (.bin .sub (.literal .i32 2) (.var "p".toList)))=some (state p (2-p)) := by
  simp [CLogic.step,CLogic.eval,declared,initial,state,B20.C.Scalar.assign,
    B20.C.cast,literalValue,B20.C.bin,commonTy,Val.ty,bitsOp]
theorem update_step (p y : BitVec 32) :
    CLogic.step (fun _ _ => none) (state p y) updateStmt=some (state p (round p y)) := by
  simp [CLogic.step,CLogic.eval,updateStmt,updateExpr,state,declared,initial,
    B20.C.Scalar.assign,update,B20.C.cast,literalValue,B20.C.bin,commonTy,Val.ty,bitsOp,round]
  funext n
  by_cases hy : n=['y'] <;> simp [update,hy]

def iterate (p : BitVec 32) : Nat → BitVec 32 → BitVec 32
  | 0,y => y
  | n+1,y => iterate p n (round p y)

theorem rounds_model (p y : BitVec 32) (n : Nat) :
    CLogic.evalBody (fun _ _ => none) .u32 (List.replicate n updateStmt++[returnStmt]) (state p y)=
      some (.u32 (0x7fffffff#32 &&& -(iterate p n y))) := by
  induction n generalizing y with
  | zero =>
    simp [iterate,returnStmt,CLogic.evalBody,CLogic.eval,state,declared,initial,
      B20.C.cast,literalValue,B20.C.bin,commonTy,Val.ty,bitsOp,B20.C.neg,update]
  | succ n ih =>
    rw [List.replicate_succ,List.cons_append]
    change (CLogic.step (fun _ _ => none) (state p y) updateStmt).bind
      (fun next => CLogic.evalBody (fun _ _ => none) .u32 (List.replicate n updateStmt++[returnStmt]) next)=_
    rw [update_step]
    exact ih (round p y)

theorem bound_execute (f : CLogic.Function) (args : List Val) (s : B20.C.Scalar.State)
    (h : B20.C.Scalar.bindArgs f.params args=some s) :
    CLogic.execute (fun _ _ => none) f args=CLogic.evalBody (fun _ _ => none) f.result f.body s := by
  simp only [CLogic.execute,h,Bind.bind,Option.bind]

theorem declaration_prefix (p : BitVec 32) (rest : List CLogic.Stmt) :
    CLogic.evalBody (fun _ _ => none) .u32 (.declare .u32 ["y".toList]::rest) (initial p)=
      CLogic.evalBody (fun _ _ => none) .u32 rest (declared p) := by
  change (CLogic.step (fun _ _ => none) (initial p) (.declare .u32 ["y".toList])).bind
    (fun next => CLogic.evalBody (fun _ _ => none) .u32 rest next)=_
  rw [declaration]
  rfl

theorem initialization_prefix (p : BitVec 32) (rest : List CLogic.Stmt) :
    CLogic.evalBody (fun _ _ => none) .u32
      (.assign "y".toList (.bin .sub (.literal .i32 2) (.var "p".toList))::rest) (declared p)=
      CLogic.evalBody (fun _ _ => none) .u32 rest (state p (2-p)) := by
  change (CLogic.step (fun _ _ => none) (declared p)
    (.assign "y".toList (.bin .sub (.literal .i32 2) (.var "p".toList)))).bind
      (fun next => CLogic.evalBody (fun _ _ => none) .u32 rest next)=_
  rw [initialization]
  rfl

theorem model_exact (p : BitVec 32) :
    CLogic.execute (fun _ _ => none) code [.u32 p]=some (.u32 (word p)) := by
  have hp : B20.C.Scalar.bindArgs code.params [.u32 p]=some (initial p) := by rfl
  calc
    _ = CLogic.evalBody (fun _ _ => none) .u32 code.body (initial p) := bound_execute code [.u32 p] (initial p) hp
    _ = CLogic.evalBody (fun _ _ => none) .u32 (code.body.drop 1) (declared p) := declaration_prefix p _
    _ = CLogic.evalBody (fun _ _ => none) .u32 (List.replicate 4 updateStmt++[returnStmt]) (state p (2-p)) := initialization_prefix p _
    _ = some (.u32 (word p)) := rounds_model p (2-p) 4

theorem checked : C99HeaderProof.checked C99HeaderProof.noSignature code=true := by decide
def SourceExec (p : BitVec 32) (z : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction code) [.uint32 p] z
theorem source_exists (p : BitVec 32) : SourceExec p (.uint32 (word p)) :=
  C99HeaderSound.function_sound _ _ _ C99HeaderSound.no_calls_sound code [.u32 p] _ checked (model_exact p)
theorem source_exact (p : BitVec 32) (z : C99IntegerReference.Value) (h : SourceExec p z) : z=.uint32 (word p) := by
  have he := C99HeaderProof.function_complete _ _ _ C99HeaderProof.no_calls_ok code [.u32 p] z checked h
  rw [model_exact] at he
  have hv := congrArg value (Option.some.inj he)
  rw [value_encode] at hv
  exact hv.symm

def prime : BitVec 32 := 2147355649
theorem inverse_identity : 2^31∣prime.toNat*(word prime).toNat+1 := by decide

theorem initialized_montgomery_contract (a b p0i : BitVec 32) (z : C99IntegerReference.Value)
    (ha : a.toNat<prime.toNat) (hb : b.toNat<prime.toNat)
    (initialization : SourceExec prime (.uint32 p0i))
    (multiplication : KeygenModpWord.SourceExec a b prime p0i z) :
    ∃ w : BitVec 32, z=.uint32 w ∧ w.toNat<prime.toNat ∧
      (w.toNat*2^31)%prime.toNat=(a.toNat*b.toNat)%prime.toNat := by
  have he : p0i=word prime := C99IntegerReference.Value.uint32.inj (source_exact _ _ initialization)
  subst p0i
  exact KeygenMontgomery.source_reduction_contract a b prime (word prime) z
    (by decide) (by decide) ha hb inverse_identity multiplication

end FT1536.Source3.KeygenNinv31
