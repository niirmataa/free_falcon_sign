import Source3.KeygenMakeSearchMaterial
import Source3.KeygenPublicAccepted

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Consume046 at the actual caller Call, not at an unrelated already-bound
   public function. Argument conversion and observed nonzero return DERIVE
   its successful entry/result. The legal/input boundary remains explicit. -/
namespace FT1536.Source3.KeygenMakePublicCall
open C99ArrayReference (State Name bindValue bindPointer)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenPublicExec (Stmt Exec)

def boolReturns : Stmt → Bool
  | .ret (some e) => e==KeygenPublicTableAtoms.literal 0 || e==KeygenPublicTableAtoms.literal 1
  | .ret none => false
  | .seq a b | .branch _ a b | .loop _ a b => boolReturns a && boolReturns b
  | .scope _ _ body | .arrayScope _ _ body => boolReturns body
  | _ => true
def BooleanFlow (out : Result) : Prop := out.flow=.normal ∨
  out.flow=.returned (some (.int32 0)) ∨ out.flow=.returned (some (.int32 1))
theorem body_flow (program : KeygenPublicExec.Program) (signed : List Name) (code : Stmt)
    (before : State) (out : Result) (source : Exec program signed code before out)
    (checked : boolReturns code=true) : BooleanFlow out := by
  induction source with
  | skip | scalar | assign | declarePointer | pointer | store | call | loopFalse => exact Or.inl rfl
  | ret e before v value =>
    have choices : e=KeygenPublicTableAtoms.literal 0 ∨ e=KeygenPublicTableAtoms.literal 1 := by
      simpa only [boolReturns,Bool.or_eq_true,beq_iff_eq] using checked
    rcases choices with equal | equal <;> subst e
    · rw [KeygenPublicTableAtoms.literal_value _ before 0 v value]; exact Or.inr (Or.inl rfl)
    · rw [KeygenPublicTableAtoms.literal_value _ before 1 v value]; exact Or.inr (Or.inr rfl)
  | retVoid => cases checked
  | seqNormal a b before middle out head tail ih1 ih2 => exact ih2 (Bool.and_eq_true_iff.mp checked).2
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out source ih => exact ih checked
  | arrayScope name count body before out block positive size fresh source ih => exact ih checked
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 => exact ih3 checked
  | loopReturn condition body increment before after v ret guard nonzero source ih => exact ih (Bool.and_eq_true_iff.mp checked).1
theorem bool_returns_source : boolReturns (KeygenPublicSource.code .compute)=true := by decide +kernel
theorem nonzero_success (before : State) (out : Result) (v : Value)
    (source : Exec KeygenPublicSource.program (KeygenPublicSource.signed .compute) (KeygenPublicSource.code .compute) before out)
    (converted : C99ProcedureReference.ReturnValue (KeygenPublicSource.result .compute) out.flow (some v))
    (nonzero : v.integer≠0) : KeygenPublicSuccessfulSuffix.Success out := by
  rcases body_flow _ _ _ before out source bool_returns_source with normal | zero | one
  · rw [normal] at converted; cases converted
  · rw [zero] at converted; cases converted; exact (nonzero rfl).elim
  · exact one

def bound (s : State) (f g h : ArrayPointer) : State :=
  bindPointer (bindPointer (bindPointer (bindValue (bindValue
    ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩ "ternary".toList .int32 (.uint32 1))
    "logn".toList .uint32 (.uint32 10)) "g".toList g) "f".toList f) "h".toList h
theorem address_zero (s : State) (n : Name) (root p : ArrayPointer) (binding : s.arrays n=some root)
    (source : KeygenPublicWord.Address s n C99ProcedureParser.zero p) : p=root := by
  cases source with
  | add p q v binding' value nonnegative within =>
    have equal := Option.some.inj (binding'.symm.trans binding)
    subst p
    cases value
    cases within
    cases root
    rfl
theorem scalar_variable (s : State) (n : Name) (ty : C99IntegerReference.Ty) (v expected : Value)
    (binding : s.locals n=some (ty,some expected)) (source : KeygenPublicWord.scalar s (.var n) v) : v=expected := by
  cases source with
  | «variable» _ _ _ binding' => exact Option.some.inj (congrArg Prod.snd (Option.some.inj (binding'.symm.trans binding)))
theorem bind_exact (s entry : State) (f g h : ArrayPointer) (dimensions : KeygenMakeSearchPrefix.Dimensions s)
    (arrays : s.arrays "f".toList=some f ∧ s.arrays "g".toList=some g ∧ s.arrays "h".toList=some h)
    (source : KeygenPublicWord.Bind s (KeygenPublicSource.params .compute) KeygenPublicSource.arguments entry) : entry=bound s f g h := by
  cases source with
  | pointer _ _ _ hp _ _ _ hRead rest =>
    cases rest with
    | pointer _ _ _ fp _ _ _ fRead rest =>
      cases rest with
      | pointer _ _ _ gp _ _ _ gRead rest =>
        cases rest with
        | scalar _ _ _ _ _ _ logn lognRead rest =>
          cases rest with
          | scalar _ _ _ _ _ _ ter terRead rest =>
            cases rest
            have hh := address_zero s _ h hp arrays.2.2 hRead
            have hf := address_zero s _ f fp arrays.1 fRead
            have hg := address_zero s _ g gp arrays.2.1 gRead
            have hl := scalar_variable s _ .uint32 logn (.uint32 10) dimensions.2.1 lognRead
            have ht := scalar_variable s _ .uint32 ter (.uint32 1) dimensions.2.2 terRead
            subst hp fp gp logn ter
            rfl
def Material (heap : Memory) (f g h : ArrayPointer) (fv gv : Geometry.Vec) : Prop :=
  KeygenMaterial.Represents heap f fv ∧ KeygenMaterial.Represents heap g gv ∧
  ∃ hv fInv : Relation.Rq, KeygenPublicNormalizePolynomial.Represents heap h hv ∧
    KeygenPublicSuccessfulSuffix.Nonzero fv ∧ Relation.mulRq hv (Relation.reduceVec fv)=Relation.reduceVec gv ∧
    Relation.mulRq fInv (Relation.reduceVec fv)=FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R)
theorem source_same_material (before after : State) (v : Value) (f g h : ArrayPointer) (fv gv : Geometry.Vec)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (arrays : before.arrays "f".toList=some f ∧ before.arrays "g".toList=some g ∧ before.arrays "h".toList=some h)
    (legalF : KeygenPublicInputMaterial.Legal before.heap f) (legalG : KeygenPublicInputMaterial.Legal before.heap g)
    (legalH : KeygenPublicInputMaterial.Legal before.heap h)
    (materialF : KeygenMaterial.Represents before.heap f fv) (materialG : KeygenMaterial.Represents before.heap g gv)
    (boundF : KeygenIntegerLift.Bound fv 1) (boundG : KeygenIntegerLift.Bound gv 1)
    (hf : h.block≠f.block) (hg : h.block≠g.block) (liveTables : KeygenPublicInputLifetime.LiveTables before)
    (hTables : KeygenPublicFrame.Tables before h.block) (source : KeygenPublicSource.Call before after v) (nonzero : v.integer≠0) :
    Material after.heap f g h fv gv := by
  cases source with
  | run entry out v binding source returned =>
    have success := nonzero_success entry out v source returned nonzero
    have equal := bind_exact before entry f g h dimensions arrays binding
    subst entry
    exact KeygenPublicAccepted.source_same_material (bound before f g h) out f g h fv gv
      rfl rfl ⟨rfl,rfl,rfl⟩ legalF legalG legalH materialF materialG boundF boundG hf hg liveTables hTables success source

end FT1536.Source3.KeygenMakePublicCall
