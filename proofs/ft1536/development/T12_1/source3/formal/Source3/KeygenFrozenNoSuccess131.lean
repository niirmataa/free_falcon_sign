import Source3.FprSqrtMissing131
import Source3.KeygenSuccessCount110

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Consequences for the FROZEN incomplete reference only. This is NOT a
   failure theorem for the real C implementation or its measured success. -/
namespace FT1536.Source3.KeygenFrozenNoSuccess131
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem ternary_continue (ctx : Context) (before : State) (out : Result)
    (source : KeygenCallerPrefix.Ternary ctx before out) : out.flow=.continueLoop := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected => exact rejected
  | norm middle sampled res out first second resultants norm =>
      exact (FprSqrtMissing131.no_norm_execution ctx res out norm).elim

theorem gates_continue (ctx : Context) (saved entry : State) (out : Result)
    (source : KeygenMakeSearchPrefix.Gates ctx saved entry out) : out.flow=.continueLoop := by
  cases source with
  | ternaryRejected raw source rejected => exact rejected
  | publicRejected normed raw source gate rejected => exact rejected
  | solver normed publicState raw source publicGate gate =>
      have impossible := ternary_continue ctx entry ⟨normed,.normal⟩ source
      cases impossible

theorem sampled_continue (ctx : Context) (before : State) (out : Result)
    (source : KeygenMakeSearchPrefix.Sampled ctx before out) : out.flow=.continueLoop := by
  cases source with
  | run entry out cap gates => exact gates_continue ctx before entry out gates

theorem attempt_continue (ctx : Context) (before : State) (out : Result)
    (source : KeygenCertificateSource080.Attempt ctx before out) : out.flow=.continueLoop := by
  cases source with
  | earlyRejected raw sample rejected => exact rejected
  | throughCertificate raw sample atCert out gate =>
      have impossible := sampled_continue ctx before raw sample
      rw [atCert] at impossible
      cases impossible

theorem no_normal_loop (ctx : Context) (before : State) (out : Result)
    (attempts : List (KeygenCertificateSource080.AttemptExecution ctx))
    (source : KeygenCertificateSource080.Loop ctx before out attempts) : out.flow≠.normal := by
  induction source with
  | exhausted before out cap exit => exact exit
  | accepted attempt accepted =>
      have impossible := attempt_continue ctx attempt.before attempt.out attempt.source
      rw [accepted] at impossible
      cases impossible
  | retry attempt out rest rejected tail ih => exact ih

theorem failure_present (env : KeygenMakeInvocation.Env) (caller : State)
    (trace : KeygenWholeCall088.Trace env caller) : trace.failure≠none := by
  cases trace with
  | readiness bound events raw binding ready exit => intro impossible; cases impossible
  | capped bound entry events out attempts binding ready loop aborted => intro impossible; cases impossible
  | tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected =>
      exact (no_normal_loop env.ctx entry loopOut attempts loop normal).elim
  | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
      exact (no_normal_loop env.ctx entry loopOut attempts loop normal).elim

theorem no_packet (env : KeygenMakeInvocation.Env) (input : KeygenWholeStages109.Input env)
    (seed : KeygenSeedEntry089.Seed) (packet : KeygenWholeBytes088.Packet) :
    KeygenByteGame109.evaluate env input seed≠some (.inr packet) := by
  intro observed
  obtain ⟨run,emitted⟩ := (KeygenByteGame109.some_iff env input seed _).mp observed
  have success := ((KeygenWholeBytes088.observe_right_iff run.domain run.consumer packet).mp emitted).1
  exact failure_present _ _ run.consumer (run.consumer.failure_none_iff.mpr success)

theorem unsuccessful (env : KeygenMakeInvocation.Env) (input : KeygenWholeStages109.Input env)
    (seed : KeygenSeedEntry089.Seed) :
    ¬KeygenSuccessCount110.Successful (KeygenByteGame109.evaluate env input seed) := by
  rintro ⟨packet,emitted⟩
  exact no_packet env input seed packet emitted

/-- The frozen law110 has zero success because its mandatory sqrt call
    has no source execution rule. This is a MODEL COVERAGE diagnosis. -/
theorem success_mass_zero (env : KeygenMakeInvocation.Env) (input : KeygenWholeStages109.Input env) :
    KeygenProbability110.successMass env input=0 := by
  classical
  rw [KeygenSuccessCount110.success_count]
  have empty : (Finset.univ.filter (fun seed : KeygenSeedEntry089.Seed =>
      KeygenSuccessCount110.Successful (KeygenByteGame109.evaluate env input seed)))=∅ := by
    ext seed
    constructor
    · intro member
      exact (unsuccessful env input seed (Finset.mem_filter.mp member).2).elim
    · intro member
      simp at member
  rw [empty]
  simp

theorem successful_law_none (env : KeygenMakeInvocation.Env) (input : KeygenWholeStages109.Input env) :
    KeygenProbability110.successfulLaw env input=none :=
  (KeygenProbability110.zero_success env input).mpr (success_mass_zero env input)

end FT1536.Source3.KeygenFrozenNoSuccess131
