import Source3.FprASTBinding
import Source3.UnsignedState

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprUnsignedPrefixes
open B20.C
open UnsignedState

def xyTypes : UnsignedSafety.TEnv :=
  setType (setType (fun _ => none) ['y'] .u64) ['x'] .u64
def xyCtx : Ctx := ⟨xyTypes,xyTypes⟩
def initial (x y : BitVec 64) : B20.C.Scalar.State :=
  ⟨xyTypes,B20.C.update (B20.C.update (fun _ => none) ['y'] (.u64 y)) ['x'] (.u64 x)⟩

theorem initial_good (x y : BitVec 64) : Good xyCtx (initial x y) := by
  refine ⟨rfl,?_⟩
  intro name ty ht
  by_cases hx : name=['x']
  · subst name
    have heq : ty=.u64 := by simpa [xyCtx,xyTypes,setType] using ht.symm
    subst ty
    exact ⟨.u64 x,by simp [initial,B20.C.update],rfl⟩
  · by_cases hy : name=['y']
    · subst name
      have heq : ty=.u64 := by simpa [xyCtx,xyTypes,setType] using ht.symm
      subst ty
      exact ⟨.u64 y,by simp [initial,B20.C.update],rfl⟩
    · simp [xyCtx,xyTypes,setType,hx,hy] at ht

theorem bind_xy (x y : BitVec 64) :
    B20.C.Scalar.bindArgs [(.u64,['x']),(.u64,['y'])] [.u64 x,.u64 y]=
      some (initial x y) := by
  simp [B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,
    B20.C.Scalar.assign,B20.C.cast,initial,xyTypes]
  rfl

def scalars : List FprPrimitives.Instr → Option (List CLogic.Stmt)
  | [] => some []
  | .scalar stmt::rest => (scalars rest).map (stmt::·)
  | _ => none

def describe : FprPrimitives.Instr → String
  | .scalar (.declare _ _) => "declare"
  | .scalar (.assign n _) | .scalar (.update n _ _) => String.ofList n
  | .scalar (.ret _) => "return"
  | .norm _ _ => "norm"
  | .forInc _ n _ => "for " ++ toString n

def mulPrefix := (scalars (FprAST.mulCode.body.take 23)).getD []
def mulCtx := (UnsignedState.run xyCtx mulPrefix).getD xyCtx
def mulTypes : UnsignedSafety.TEnv :=
  ([['x','u'],['y','u'],['w'],['z','u'],['z','v']].map (fun n => (Ty.u64,n)) ++
    [['x','0'],['x','1'],['y','0'],['y','1'],['z','0'],['z','1'],['z','2']].map (fun n => (Ty.u32,n)) ++
    [['e','x'],['e','y'],['d'],['e'],['s']].map (fun n => (Ty.i32,n))).foldl
      (fun env (ty,name) => setType env name ty) xyTypes
theorem mul_context_types : mulCtx.types=mulTypes := by rfl
theorem mul_prefix_shape : FprAST.mulCode.body.take 23=mulPrefix.map FprPrimitives.Instr.scalar := by rfl
theorem mul_prefix_safe : (UnsignedState.run xyCtx mulPrefix).isSome := by decide
theorem mul_prefix_ctx : UnsignedState.run xyCtx mulPrefix=some mulCtx := by
  have hs := mul_prefix_safe
  unfold mulCtx
  cases he : UnsignedState.run xyCtx mulPrefix with
  | none => simp [he] at hs
  | some ctx => rfl

theorem mul_prefix_total (x y : BitVec 64) :
    ∃ out, UnsignedState.exec FprPrimitives.headerCalls (initial x y) mulPrefix=some out ∧
      Good mulCtx out :=
  UnsignedState.run_total _ xyCtx mulCtx (initial x y) mulPrefix (initial_good x y) mul_prefix_ctx

theorem mul_ctx_x : mulCtx.initialized ['x']=some .u64 := by rfl
theorem mul_ctx_y : mulCtx.initialized ['y']=some .u64 := by rfl
theorem mul_ctx_zu : mulCtx.initialized ['z','u']=some .u64 := by rfl

def divPrefix := (scalars (FprAST.divCode.body.take 5)).getD []
def divCtx := (UnsignedState.run xyCtx divPrefix).getD xyCtx
def divTypes : UnsignedSafety.TEnv :=
  ([['x','u'],['y','u'],['q'],['q','2'],['w']].map (fun n => (Ty.u64,n)) ++
    [['i'],['e','x'],['e','y'],['e'],['d'],['s']].map (fun n => (Ty.i32,n))).foldl
      (fun env (ty,name) => setType env name ty) xyTypes
theorem div_context_types : divCtx.types=divTypes := by rfl
theorem div_prefix_shape : FprAST.divCode.body.take 5=divPrefix.map FprPrimitives.Instr.scalar := by rfl
theorem div_prefix_safe : (UnsignedState.run xyCtx divPrefix).isSome := by decide
theorem div_prefix_ctx : UnsignedState.run xyCtx divPrefix=some divCtx := by
  have hs := div_prefix_safe
  unfold divCtx
  cases he : UnsignedState.run xyCtx divPrefix with
  | none => simp [he] at hs
  | some ctx => rfl
theorem div_prefix_total (x y : BitVec 64) :
    ∃ out, UnsignedState.exec FprPrimitives.headerCalls (initial x y) divPrefix=some out ∧
      Good divCtx out :=
  UnsignedState.run_total _ xyCtx divCtx (initial x y) divPrefix (initial_good x y) div_prefix_ctx
theorem div_ctx_x : divCtx.initialized ['x']=some .u64 := by rfl
theorem div_ctx_y : divCtx.initialized ['y']=some .u64 := by rfl
theorem div_ctx_xu : divCtx.initialized ['x','u']=some .u64 := by rfl
theorem div_ctx_yu : divCtx.initialized ['y','u']=some .u64 := by rfl
theorem div_ctx_q : divCtx.initialized ['q']=some .u64 := by rfl

def addPrefix := (scalars (FprAST.addCode.body.take 9)).getD []
def addCtx := (UnsignedState.run xyCtx addPrefix).getD xyCtx
def addTypes : UnsignedSafety.TEnv :=
  ([['m'],['x','u'],['y','u'],['z','a']].map (fun n => (Ty.u64,n)) ++
    [(Ty.u32,['c','s'])] ++
    [['e','x'],['e','y'],['s','x'],['s','y'],['c','c']].map (fun n => (Ty.i32,n))).foldl
      (fun env (ty,name) => setType env name ty) xyTypes
theorem add_context_types : addCtx.types=addTypes := by rfl
theorem add_prefix_shape : FprAST.addCode.body.take 9=addPrefix.map FprPrimitives.Instr.scalar := by rfl
theorem add_prefix_safe : (UnsignedState.run xyCtx addPrefix).isSome := by decide
theorem add_prefix_ctx : UnsignedState.run xyCtx addPrefix=some addCtx := by
  have hs := add_prefix_safe
  unfold addCtx
  cases he : UnsignedState.run xyCtx addPrefix with
  | none => simp [he] at hs
  | some ctx => rfl
theorem add_prefix_total (x y : BitVec 64) :
    ∃ out, UnsignedState.exec FprPrimitives.headerCalls (initial x y) addPrefix=some out ∧
      Good addCtx out :=
  UnsignedState.run_total _ xyCtx addCtx (initial x y) addPrefix (initial_good x y) add_prefix_ctx
theorem add_ctx_x : addCtx.initialized ['x']=some .u64 := by rfl
theorem add_ctx_y : addCtx.initialized ['y']=some .u64 := by rfl

#eval FprAST.mulCode.body.zipIdx |>.map (fun (s,i) => (i,describe s))
#eval FprAST.divCode.body.zipIdx |>.map (fun (s,i) => (i,describe s))
#eval FprAST.addCode.body.zipIdx |>.map (fun (s,i) => (i,describe s))

end FT1536.Source3.FprUnsignedPrefixes
