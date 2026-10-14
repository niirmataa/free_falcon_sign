import Source3.KeygenLoopDomain105

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLoopFunction105
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenCertificateSource080
open KeygenLoopDomain105 (Input)

/-- Erase only the list of proof-carrying attempt records. The source
    transitions, cap test, shared states and every exit remain explicit. -/
inductive Run (ctx : Context) : State → Result → Prop where
  | exhausted (before : State) (out : Result)
      (cap : KeygenMakeSampling.CappedSetup ctx before out) (exit : out.flow ≠ .normal) : Run ctx before out
  | accepted (before : State) (out : Result) (source : Attempt ctx before out)
      (accept : out.flow = .breakLoop) : Run ctx before ⟨out.state,.normal⟩
  | retry (before : State) (middle out : Result) (source : Attempt ctx before middle)
      (reject : middle.flow = .continueLoop) (rest : Run ctx middle.state out) : Run ctx before out

theorem erase (ctx : Context) (before : State) (out : Result) (attempts : List (AttemptExecution ctx))
    (source : Loop ctx before out attempts) : Run ctx before out := by
  induction source with
  | exhausted before out cap exit => exact .exhausted before out cap exit
  | accepted current accept => exact .accepted current.before current.out current.source accept
  | retry current out rest reject tail ih => exact .retry current.before current.out out current.source reject ih

theorem restore (ctx : Context) (before : State) (out : Result) (source : Run ctx before out) :
    ∃ attempts, Loop ctx before out attempts := by
  induction source with
  | exhausted before out cap exit => exact ⟨[], .exhausted before out cap exit⟩
  | accepted before out source accept => exact ⟨[⟨before,out,source⟩], .accepted ⟨before,out,source⟩ accept⟩
  | retry before middle out source reject rest ih =>
      obtain ⟨attempts, tail⟩ := ih
      exact ⟨⟨before,middle,source⟩ :: attempts, .retry ⟨before,middle,source⟩ out attempts reject tail⟩

theorem source_iff (ctx : Context) (before : State) (out : Result) :
    Run ctx before out ↔ ∃ attempts, Loop ctx before out attempts :=
  ⟨restore ctx before out, fun ⟨attempts, source⟩ => erase ctx before out attempts source⟩

theorem run_unique (ctx : Context) (before : State) (a b : Result)
    (first : Run ctx before a) (second : Run ctx before b) (input : Input ctx before) : a = b := by
  revert input
  induction first generalizing b with
  | exhausted before out cap exit =>
      intro input
      have caps := KeygenLoopDomain105.cap_unique ctx before input
      have excluded := KeygenLoopDomain105.excludes ctx before input
      cases second <;> grind
  | accepted before out source accept =>
      intro input
      have attempts := KeygenLoopDomain105.attempt_unique ctx before input
      have excluded := KeygenLoopDomain105.excludes ctx before input
      cases second <;> grind
  | retry before middle out source reject rest ih =>
      intro input
      have following := KeygenLoopDomain105.next ctx before input middle source
      have later : ∀ result, Run ctx middle.state result → out = result := fun result proof => ih result proof following
      have attempts := KeygenLoopDomain105.attempt_unique ctx before input
      have excluded := KeygenLoopDomain105.excludes ctx before input
      cases second <;> grind

theorem execution (ctx : Context) (before : State) (a b : Result)
    (xs ys : List (AttemptExecution ctx))
    (first : Loop ctx before a xs) (second : Loop ctx before b ys) (input : Input ctx before) : a = b :=
  run_unique ctx before a b (erase ctx before a xs first) (erase ctx before b ys second) input

structure Domain (ctx : Context) where
  before : State
  entry : Input ctx before

/-- Exact stopped source loop, including exhausted-cap returns and every
    rejected certificate. No independent input is drawn at a retry. -/
noncomputable def runLoop (ctx : Context) (input : Domain ctx) : Part Result where
  Dom := ∃ out, ∃ attempts, Loop ctx input.before out attempts
  get domain := Classical.choose domain

theorem runLoop_spec (ctx : Context) (input : Domain ctx) (out : Result) :
    out ∈ runLoop ctx input ↔ ∃ attempts, Loop ctx input.before out attempts := by
  constructor
  · rintro ⟨domain, equal⟩
    rw [← equal]
    exact Classical.choose_spec domain
  · rintro ⟨attempts, source⟩
    let domain : ∃ result, ∃ trace, Loop ctx input.before result trace := ⟨out, attempts, source⟩
    obtain ⟨trace, actual⟩ := Classical.choose_spec domain
    exact ⟨domain, execution ctx input.before (Classical.choose domain) out trace attempts actual source input.entry⟩

end FT1536.Source3.KeygenLoopFunction105
