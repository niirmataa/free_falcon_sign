import Source3.KeygenLoopFunction105
import Source3.KeygenLoopDomain105
import Source3.KeygenCertificateSource134
import Source3.KeygenLoopDomain134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenLoopFunction134
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenCertificateSource080 hiding Attempt AttemptExecution Loop attempt_projection loop_projection projected
open KeygenCertificateSource134
open KeygenLoopDomain105 (Input)




open KeygenLoopFunction105
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

theorem run_unique (ctx : Context) (before : State) (a b : Result)
    (first : Run ctx before a) (second : Run ctx before b) (input : Input ctx before) : a = b := by
  revert input
  induction first generalizing b with
  | exhausted before out cap exit =>
      intro input
      have caps := KeygenLoopDomain105.cap_unique ctx before input
      have excluded := KeygenLoopDomain134.excludes ctx before input
      cases second <;> grind
  | accepted before out source accept =>
      intro input
      have attempts := KeygenLoopDomain134.attempt_unique ctx before input
      have excluded := KeygenLoopDomain134.excludes ctx before input
      cases second <;> grind
  | retry before middle out source reject rest ih =>
      intro input
      have following := KeygenLoopDomain134.next ctx before input middle source
      have later : ∀ result, Run ctx middle.state result → out = result := fun result proof => ih result proof following
      have attempts := KeygenLoopDomain134.attempt_unique ctx before input
      have excluded := KeygenLoopDomain134.excludes ctx before input
      cases second <;> grind

theorem execution (ctx : Context) (before : State) (a b : Result)
    (xs ys : List (AttemptExecution ctx))
    (first : Loop ctx before a xs) (second : Loop ctx before b ys) (input : Input ctx before) : a = b :=
  run_unique ctx before a b (erase ctx before a xs first) (erase ctx before b ys second) input

end FT1536.Source3.KeygenLoopFunction134
