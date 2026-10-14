import Source3.C99ScalarDeterminism089
import Source3.FprPrefixCalls
import Source3.C99ArrayReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Determinism is proved for the FIXED source call tables, not provided as
   a new assumption. These facts feed the pointer and SHAKE source proofs. -/
namespace FT1536.Source3.C99ScalarCallsDeterminism089
open C99IntegerReference (Value)
open C99ScalarReference
open C99ScalarDeterminism089

theorem no_calls : Deterministic C99Frontend.noCalls := by
  intro name args a b impossible _
  exact impossible.elim

theorem header_calls : Deterministic C99Frontend.headerCalls := by
  intro name args a b first second
  obtain ⟨f, lookup, execution⟩ := first
  obtain ⟨g, lookup', execution'⟩ := second
  have equal : f = g := Option.some.inj (lookup.symm.trans lookup')
  subst g
  exact function_unique C99Frontend.noCalls no_calls f args a b execution execution'

theorem primitive_calls : Deterministic C99Frontend.primitiveCall := by
  intro name args a b first second
  obtain ⟨f, lookup, execution⟩ := first
  obtain ⟨g, lookup', execution'⟩ := second
  have equal : f = g := Option.some.inj (lookup.symm.trans lookup')
  subst g
  exact function_unique C99Frontend.headerCalls header_calls f args a b execution execution'

theorem value_call (calls : CallRelation) (deterministic : Deterministic calls)
    (f : CLogic.Function) (args : List Value) (a b : Value)
    (first : FprPrefixCalls.ValueCall calls f args a)
    (second : FprPrefixCalls.ValueCall calls f args b) : a = b := by
  cases first with
  | call env value parameters body =>
      cases second with
      | call other value' parameters' body' =>
          have same := parameters_unique (C99Frontend.headerFunction f).params args env other parameters parameters'
          subst other
          have result := execution_unique calls deterministic (FprPrefixCalls.withGlobals env)
            (C99Frontend.scalars f.body) _ _ body body'
          cases result
          rfl

theorem base_calls : Deterministic FprPrefixCalls.baseCalls := by
  intro name args a b first second
  by_cases scaled : name = "fpr_scaled".toList
  · simp only [FprPrefixCalls.baseCalls, scaled, ite_true] at first second
    exact function_unique C99Frontend.headerCalls header_calls FprScaledBinding.refFunction
      args a b first second
  · simp only [FprPrefixCalls.baseCalls, scaled, ite_false] at first second
    exact primitive_calls name args a b first second

theorem of_calls : Deterministic FprPrefixCalls.ofCalls := by
  intro name args a b first second
  by_cases ofName : name = "fpr_of".toList
  · simp only [FprPrefixCalls.ofCalls, ofName, ite_true] at first second
    exact value_call FprPrefixCalls.baseCalls base_calls FprScaledAST.ofCode args a b first second
  · simp only [FprPrefixCalls.ofCalls, ofName, ite_false] at first second
    exact base_calls name args a b first second

theorem prefix_calls : Deterministic FprPrefixCalls.calls := by
  intro name args a b first second
  cases lookup : FprPrefixCalls.lookup name with
  | none =>
      simp only [FprPrefixCalls.calls, lookup] at first second
      exact of_calls name args a b first second
  | some f =>
      simp only [FprPrefixCalls.calls, lookup] at first second
      exact value_call FprPrefixCalls.ofCalls of_calls f args a b first second

theorem array_scalar (s : C99ArrayReference.State) (e : CLogic.Expr) (a b : Value)
    (first : C99ArrayReference.scalar s e a) (second : C99ArrayReference.scalar s e b) : a = b :=
  expression_unique FprPrefixCalls.calls prefix_calls s.locals (C99Frontend.expression e) a b first second

theorem array_pointer (s : C99ArrayReference.State) (name : Name) (index : CLogic.Expr)
    (a b : C99MemoryReference.ArrayPointer)
    (first : C99ArrayReference.Pointer s name index a) (second : C99ArrayReference.Pointer s name index b) :
    a = b := by
  cases first with
  | add root a value binding evaluated nonnegative address =>
      cases second with
      | add other b value' binding' evaluated' nonnegative' address' =>
          have valueEqual := array_scalar s index value value' evaluated evaluated'
          subst value'
          have rootEqual := Option.some.inj (binding.symm.trans binding')
          subst other
          cases address
          cases address'
          rfl

end FT1536.Source3.C99ScalarCallsDeterminism089
