import Source3.KeygenRootSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRootCaller
open C99ArrayReference (State bindPointer)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)

def booleanReturns : C99ModularReference.Stmt → Bool
  | .ret e => e==.scalar (.literal .i32 0) || e==.scalar (.literal .i32 1)
  | .retVoid => false
  | .seq a b | .branch _ a b | .loop _ a b => booleanReturns a && booleanReturns b
  | .scope _ body => booleanReturns body
  | _ => true
def BooleanFlow (out : Result) : Prop :=
  out.flow=.normal ∨ out.flow=.returned (some (.int32 0)) ∨ out.flow=.returned (some (.int32 1))
theorem modular_flow (code : C99ModularReference.Stmt) (before : State) (out : Result)
    (source : C99ModularReference.Exec code before out) (checked : booleanReturns code=true) : BooleanFlow out := by
  induction source with
  | base | assign | store32 | storeRev | loopFalse => exact Or.inl rfl
  | ret e before v value =>
    have choices : e=.scalar (.literal .i32 0) ∨ e=.scalar (.literal .i32 1) := by simpa only [booleanReturns,Bool.or_eq_true,beq_iff_eq] using checked
    rcases choices with he | he <;> subst e
    · have scalar := KeygenNttForwardExec.eval_scalar _ _ _ value
      cases scalar
      exact Or.inr (Or.inl rfl)
    · have scalar := KeygenNttForwardExec.eval_scalar _ _ _ value
      cases scalar
      exact Or.inr (Or.inr rfl)
  | retVoid => cases checked
  | seqNormal first second before middle out head tail ih1 ih2 => exact ih2 (Bool.and_eq_true_iff.mp checked).2
  | seqExit first second before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope names body before out execution ih => exact ih checked
  | branchTrue condition yes no before out v guard nonzero execution ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse condition yes no before out v guard zero execution ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 => exact ih3 checked
  | loopReturn condition body increment before after v value guard nonzero iteration ih => exact ih (Bool.and_eq_true_iff.mp checked).1
theorem target_boolean : booleanReturns KeygenSolverTarget.code=true := by decide
theorem root_flow (ctx : Context) (before : State) (out : Result) (source : KeygenRootSource.Exec ctx before out) : BooleanFlow out := by
  cases source with
  | searchRejected out search rejected | outputRejected searched out search gate rejected => exact Or.inr (Or.inl rejected)
  | validated searched passed out search gate validation =>
    cases validation with
    | run prepared entry generated converted transformed out gt nt prep gm gn binding generation genReturn conversion convNormal nm nn transforms check =>
      exact modular_flow _ _ _ check target_boolean
theorem return_one (ctx : Context) (before : State) (out : Result) (v : Value)
    (source : KeygenRootSource.Exec ctx before out)
    (conversion : C99ProcedureReference.ReturnValue (some .int32) out.flow (some v)) (one : v=.int32 1) :
    out.flow=.returned (some (.int32 1)) := by
  rcases root_flow ctx before out source with normal | zero | success
  · rw [normal] at conversion; cases conversion
  · rw [zero] at conversion
    cases conversion
    cases one
  · exact success

structure Legal (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer) : Prop where
  context : s.arrays "fk".toList=some ctx.object
  inputs : ∀ slot, s.arrays (KeygenResidueTrace.names slot).2.toList=some (input slot)
  profile : KeygenSearchContext.M0 s.heap ctx
  table : s.tables "PRIMES3".toList=some primes
  primeObject : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  scratch : KeygenMkgm3Layout.Legal s.heap ctx.scratch
  width : ∀ slot, (input slot).elementBytes=2
  separate : ∀ slot, KeygenMkgm3Layout.DisjointBytes (input slot) 3072 ctx.scratch (KeygenMkgm3Frame.objectBytes ctx.scratch)
  disjoint : ∀ a b : Fin 4, a≠b → KeygenMkgm3Layout.DisjointBytes (input a) 3072 (input b) 3072
  contextProtected : KeygenRootSearch.Protected ctx s ctx.object.block
  fProtected : KeygenRootSearch.Protected ctx s (input 0).block
  gProtected : KeygenRootSearch.Protected ctx s (input 1).block
def bound (before : State) (ctx : Context) (input : Fin 4 → ArrayPointer) : State :=
  bindPointer (bindPointer (bindPointer (bindPointer (bindPointer
    ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩
    "g".toList (input 1)) "f".toList (input 0)) "G".toList (input 3)) "F".toList (input 2)) "fk".toList ctx.object
theorem bind_exact (ctx : Context) (before entry : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx before input primes rev)
    (binding : C99ArrayReference.Bind before KeygenRootSource.params KeygenRootSource.arguments entry) :
    entry=bound before ctx input := by
  cases binding with
  | pointer _ _ _ fk _ _ _ fkRead rest =>
    cases rest with
    | pointer _ _ _ F _ _ _ fRead rest =>
      cases rest with
      | pointer _ _ _ G _ _ _ gRead rest =>
        cases rest with
        | pointer _ _ _ f _ _ _ sfRead rest =>
          cases rest with
          | pointer _ _ _ g _ _ _ sgRead rest =>
            cases rest
            have hc := KeygenSolverNttCalls.pointer_zero before "fk" ctx.object fk legal.context fkRead
            have hF := KeygenSolverNttCalls.pointer_zero before "F" (input 2) F (legal.inputs 2) fRead
            have hG := KeygenSolverNttCalls.pointer_zero before "G" (input 3) G (legal.inputs 3) gRead
            have hf := KeygenSolverNttCalls.pointer_zero before "f" (input 0) f (legal.inputs 0) sfRead
            have hg := KeygenSolverNttCalls.pointer_zero before "g" (input 1) g (legal.inputs 1) sgRead
            subst fk F G f g
            rfl
theorem bound_entry (ctx : Context) (before : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx before input primes rev) : KeygenRootSource.Entry ctx (bound before ctx input) input primes rev := by
  refine ⟨legal.profile,?_,legal.table,legal.primeObject,legal.revBinding,legal.revSource,legal.scratch,
    legal.width,legal.separate,legal.disjoint,legal.contextProtected,legal.fProtected,legal.gProtected⟩
  intro slot
  fin_cases slot <;> rfl

theorem success (ctx : Context) (before after : State) (v : Value) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx before input primes rev) (source : KeygenRootSource.Call ctx before after v) (returned : v=.int32 1)
    (f g : Geometry.Vec) (fRepr : KeygenMaterial.Represents before.heap (input 0) f)
    (gRepr : KeygenMaterial.Represents before.heap (input 1) g)
    (fBound : KeygenIntegerLift.Bound f 1) (gBound : KeygenIntegerLift.Bound g 1) :
    ∃ F G : Geometry.Vec, KeygenSolverEquation.Bounds (KeygenOutputGateValidation.material f g F G) ∧
      KeygenSolverEquation.Equation (KeygenOutputGateValidation.material f g F G) ∧
      ∀ slot, KeygenMaterial.Represents after.heap (input slot) (KeygenOutputGateValidation.material f g F G slot) := by
  cases source with
  | run entry out v binding source conversion =>
    have state := bind_exact ctx before entry input primes rev legal binding
    subst entry
    exact KeygenRootSource.success ctx (bound before ctx input) out input primes rev (bound_entry ctx before input primes rev legal)
      source (return_one ctx _ out v source conversion returned) f g fRepr gRepr fBound gBound

end FT1536.Source3.KeygenRootCaller
