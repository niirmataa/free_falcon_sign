import Source3.KeygenCallerPrefix
import Source3.KeygenRootCoverage

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- B1.05 composition only. The finite selected caller/attempt fragments and
   the complete root call imply NTRU for the same retained arrays. This is
   not the whole KeyGen loop, an emitted-key theorem, or a security claim. -/
namespace FT1536.Source3.KeygenCallerSuccess
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open KeygenCallerEntry (Initial)
open FT1536.Run2.CoefficientQuotient (multiply constantCoeffs)

theorem call_boolean (ctx : Context) (before after : State) (v : Value)
    (source : KeygenRootSource.Call ctx before after v) : v=.int32 0 ∨ v=.int32 1 := by
  cases source with
  | run entry out v binding body returned =>
    rcases KeygenRootCaller.root_flow ctx entry out body with normal | zero | one
    · rw [normal] at returned; cases returned
    · rw [zero] at returned; cases returned; exact Or.inl rfl
    · rw [one] at returned; cases returned; exact Or.inr rfl
theorem nonzero_one (ctx : Context) (before after : State) (v : Value)
    (source : KeygenRootSource.Call ctx before after v) (nonzero : v.integer≠0) : v=.int32 1 := by
  rcases call_boolean ctx before after v source with zero | one
  · rw [zero] at nonzero; exact (nonzero rfl).elim
  · exact one
theorem root_gate_source : KeygenM0Preprocess.preprocess (KeygenRootSearch.lines 8097 10)=some [
    "\t\tif (!solve_NTRU(fk, F, G, f, g)) {\n","\t\t\tcontinue;\n","\t\t}\n"] := KeygenRootCoverage.caller_source
inductive RootGate (ctx : Context) (before : State) : Result → Prop where
  | reject (after : State) (v : Value) (source : KeygenRootSource.Call ctx before after v) (zero : v.integer=0) :
      RootGate ctx before ⟨after,.continueLoop⟩
  | accept (after : State) (v : Value) (source : KeygenRootSource.Call ctx before after v) (nonzero : v.integer≠0) :
      RootGate ctx before ⟨after,.normal⟩
inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | prefixRejected (out : Result) (preceding : KeygenCallerPrefix.Exec ctx before out) (rejected : out.flow=.continueLoop) : Exec ctx before out
  | rootGate (entry : State) (out : Result) (preceding : KeygenCallerPrefix.Exec ctx before ⟨entry,.normal⟩)
      (root : RootGate ctx entry out) : Exec ctx before out
def Solved (heap : Memory) (input : Fin 4 → ArrayPointer) : Prop := ∃ f g F G : Geometry.Vec,
  KeygenSolverEquation.Bounds (KeygenOutputGateValidation.material f g F G) ∧
  KeygenSolverEquation.Equation (KeygenOutputGateValidation.material f g F G) ∧
  ∀ slot, KeygenMaterial.Represents heap (input slot) (KeygenOutputGateValidation.material f g F G slot)
theorem success (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (source : Exec ctx before out) (normal : out.flow=.normal) : Solved out.state.heap input := by
  cases source with
  | prefixRejected out preceding rejected => rw [normal] at rejected; cases rejected
  | rootGate entry out preceding root =>
    have legal := KeygenCallerPrefix.root_legal ctx before ⟨entry,.normal⟩ input h primes rev initial preceding
    obtain ⟨f,g,hf,bf,hg,bg⟩ := KeygenCallerPrefix.material ctx before ⟨entry,.normal⟩ input h primes rev initial preceding
    cases root with
    | reject after v call zero => cases normal
    | accept after v call nonzero =>
      obtain ⟨F,G,bounds,equation,retained⟩ := KeygenRootCaller.success ctx entry after v input primes rev legal call
        (nonzero_one ctx entry after v call nonzero) f g hf hg bf bg
      exact ⟨f,g,F,G,bounds,equation,retained⟩
theorem exact_integer_ntru (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (source : Exec ctx before out) (normal : out.flow=.normal) :
    ∃ f g F G : Geometry.Vec, KeygenSolverEquation.Bounds (KeygenOutputGateValidation.material f g F G) ∧
      multiply f G - multiply g F = constantCoeffs (18433 : Int) ∧
      ∀ slot, KeygenMaterial.Represents out.state.heap (input slot) (KeygenOutputGateValidation.material f g F G slot) := by
  exact success ctx before out input h primes rev initial source normal

end FT1536.Source3.KeygenCallerSuccess
