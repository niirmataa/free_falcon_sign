import Source3.KeygenDepth0Source
import Source3.KeygenOutputGateValidation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The last M0 search call preserves caller material by executing its entire
   source closure. The deepest/intermediate calls precede this boundary and
   remain separate obligations. This is not the whole solve_NTRU theorem. -/
namespace FT1536.Source3.KeygenDepth0Call
open C99ArrayReference (State Name Arg Param)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open C99IntegerReference (Value)

def params : List Param := [.pointer "fk".toList,.pointer "f".toList,.pointer "g".toList]
def arguments : List Arg := ["fk","f","g"].map (fun name => .pointer name.toList C99ProcedureParser.zero)
theorem call_source : (Pinned.keygenLines.drop 7319).take 3 = [
  "\t\t\tif (!solve_NTRU_ternary_depth0(fk, f, g)) {\n","\t\t\t\treturn 0;\n","\t\t\t}\n"] := by decide

inductive Call (ctx : Context) (before : State) : State → Value → Prop where
  | run (entry : State) (out : Result) (v : Value)
      (binding : C99ArrayReference.Bind before params arguments entry)
      (body : KeygenSearchExec.Exec ctx KeygenDepth0Source.code entry out)
      (returned : C99ProcedureReference.ReturnValue (some .int32) out.flow (some v)) :
      Call ctx before {before with heap := out.state.heap} v

def Protected (ctx : Context) (s : State) (block : Nat) : Prop :=
  ctx.scratch.block≠block ∧ ∀ name p, s.tables name=some p → p.block≠block

theorem arguments_readonly : C99PointerFootprint.arguments [] KeygenDepth0Source.writable params arguments=true := by decide

theorem frame (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v)
    (block : Nat) (separated : Protected ctx before block) :
    ∀ offset, after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out v binding body returned =>
    intro offset
    have tables : C99PointerFootprint.TablesOutside before block offset := by
      intro name p hp
      exact Or.inl (Ne.symm (separated.2 name p hp))
    obtain ⟨outside,te⟩ := C99PointerFootprint.bind_outside before params arguments entry binding []
      KeygenDepth0Source.writable arguments_readonly block offset (by intro n hn; cases hn) tables
    have result := KeygenSearchFrame.body_frame ctx KeygenDepth0Source.code entry out body
      KeygenDepth0Source.writable KeygenDepth0Source.code_checked block offset outside
      (by simpa only [C99PointerFootprint.TablesOutside,te] using tables) (Or.inl (Ne.symm separated.1))
    rw [C99ArrayReference.bind_heap before params arguments entry binding] at result
    exact result.2.2

theorem slots (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  cases source
  exact ⟨rfl,rfl,rfl⟩

theorem material (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v)
    (p : ArrayPointer) (separated : Protected ctx before p.block) (vector : Geometry.Vec)
    (represented : KeygenMaterial.Represents before.heap p vector) :
    KeygenMaterial.Represents after.heap p vector := by
  have keep := frame ctx before after v source p.block separated
  intro i
  constructor
  · intro byte
    exact (keep _).trans ((represented i).1 byte)
  · intro byte
    exact (keep _).trans ((represented i).2 byte)

theorem output_caller (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v)
    (F G : ArrayPointer) (caller : KeygenOutputGateBounds.Caller before F G) :
    KeygenOutputGateBounds.Caller after F G := by
  obtain ⟨hl,ha,_⟩ := slots ctx before after v source
  exact ⟨(congrFun hl _).trans caller.logn,(congrFun hl _).trans caller.size,
    (congrFun ha _).trans caller.first,(congrFun ha _).trans caller.second⟩

def MemberGate (ctx : Context) (before : State) (out : Result) : Prop :=
  ∃ ternary tmp, KeygenSearchContext.ReadTernary ctx before ternary ∧
    KeygenSearchContext.ReadTmp ctx before tmp ∧
    KeygenOutputGateSource.Exec ⟨ternary,tmp⟩ before out

theorem call_gate_validated (ctx : Context) (before after : State) (ret : Value)
    (source : Call ctx before after ret) (arrays : KeygenResidueTrace.Arrays)
    (caller : KeygenOutputGateBounds.Caller before (arrays.input 2) (arrays.input 3))
    (f g : Geometry.Vec) (fRepr : KeygenMaterial.Represents before.heap (arrays.input 0) f)
    (gRepr : KeygenMaterial.Represents before.heap (arrays.input 1) g)
    (fBound : KeygenIntegerLift.Bound f 1) (gBound : KeygenIntegerLift.Bound g 1)
    (fProtected : Protected ctx before (arrays.input 0).block)
    (gProtected : Protected ctx before (arrays.input 1).block)
    (m0 : KeygenSearchContext.M0 after.heap ctx)
    (disjoint : ∀ a b : Fin 4, a≠b → KeygenMkgm3Layout.DisjointBytes (arrays.input a) 3072 (arrays.input b) 3072)
    (gateOut : Result) (gate : MemberGate ctx after gateOut)
    (passed : gateOut.flow=.normal) (validation : KeygenOutputGateValidation.Validation arrays)
    (sameHeap : validation.start.heap=gateOut.state.heap) :
    ∃ F G : Geometry.Vec, KeygenSolverEquation.Bounds (KeygenOutputGateValidation.material f g F G) ∧
      KeygenSolverEquation.Equation (KeygenOutputGateValidation.material f g F G) ∧
      ∀ slot, KeygenMaterial.Represents validation.out.state.heap (arrays.input slot)
        (KeygenOutputGateValidation.material f g F G slot) := by
  obtain ⟨ternary,tmp,member,tmpMember,gate⟩ := gate
  have actual := KeygenSearchContext.tmp_value ctx after tmp tmpMember
  subst tmp
  exact KeygenOutputGateValidation.gate_validated (KeygenSearchContext.outputView ctx ternary) after gateOut arrays
    (KeygenSearchContext.ternary_m0 ctx after ternary m0 member)
    (output_caller ctx before after ret source _ _ caller) disjoint f g
    (material ctx before after ret source _ fProtected f fRepr)
    (material ctx before after ret source _ gProtected g gRepr) fBound gBound gate passed validation sameHeap

end FT1536.Source3.KeygenDepth0Call
