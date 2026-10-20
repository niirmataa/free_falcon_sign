import Source3.CertificatePrologue
import Source3.C99ExpressionEnvironment

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.MknReference
open C99ExpressionEnvironment
open C99ArrayReference (State)

def expression : CLogic.Expr := C99ArrayParser.mkn (.var "logn".toList) (.var "ter".toList)
def Profile (s : State) : Prop :=
  s.locals "logn".toList=some (.uint32,some (.uint32 10)) ∧
  s.locals "ter".toList=some (.uint32,some (.uint32 1))

theorem macro_source : Pinned.keygenLines[60]?=
    some "#define MKN(logn, full)   ((size_t)(1 + ((full) << 1)) << ((logn) - (full)))\n" := by decide
theorem reads : readNames (C99Frontend.expression expression)=["ter","logn","ter"].map String.toList := by rfl
theorem model_checked : C99Typing.infer CertificatePrologue.noSignatures CertificatePrologue.initial.types expression=some .u64 := by decide
theorem model_result : ExpressionFuel.unbounded CertificatePrologue.emptyCalls CertificatePrologue.initial.values expression=
    some (.u64 1536) := by decide
theorem initial_logn : (C99Typing.environment CertificatePrologue.initial) "logn".toList=some (.uint32,some (.uint32 10)) := by decide
theorem initial_ter : (C99Typing.environment CertificatePrologue.initial) "ter".toList=some (.uint32,some (.uint32 1)) := by decide

theorem agreement (before : State) (profile : Profile before) :
    Agree before.locals (C99Typing.environment CertificatePrologue.initial) (readNames (C99Frontend.expression expression)) := by
  intro name member
  rw [reads] at member
  change name∈["ter".toList,"logn".toList,"ter".toList] at member
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl | rfl
  · exact profile.2.trans initial_ter.symm
  · exact profile.1.trans initial_logn.symm
  · exact profile.2.trans initial_ter.symm

theorem source_value (before : State) (value : C99IntegerReference.Value)
    (profile : Profile before) (source : C99ArrayReference.scalar before expression value) : value=.uint64 1536 := by
  have hsource := transport FprPrefixCalls.calls before.locals (C99Typing.environment CertificatePrologue.initial)
    (C99Frontend.expression expression) value source (agreement before profile)
  have he := (C99ExpressionBridge.expression_complete CertificatePrologue.noSignatures FprPrefixCalls.calls
    CertificatePrologue.emptyCalls CertificatePrologue.pure_calls_complete CertificatePrologue.initial
    CertificatePrologue.initial_typed expression .u64 value model_checked hsource).1
  rw [model_result] at he
  have hv := congrArg C99ValueBridge.value (Option.some.inj he)
  rw [C99ValueBridge.value_encode] at hv
  exact hv.symm

theorem source_exists (before : State) (profile : Profile before) :
    C99ArrayReference.scalar before expression (.uint64 1536) := by
  have hsource := C99ExpressionSound.expression_sound FprPrefixCalls.calls CertificatePrologue.emptyCalls
    CertificatePrologue.pure_calls_sound CertificatePrologue.initial CertificatePrologue.initial_typed
    expression (.u64 1536) model_result
  exact transport FprPrefixCalls.calls (C99Typing.environment CertificatePrologue.initial) before.locals
    (C99Frontend.expression expression) (.uint64 1536) hsource
    (fun name member => (agreement before profile name member).symm)

end FT1536.Source3.MknReference
