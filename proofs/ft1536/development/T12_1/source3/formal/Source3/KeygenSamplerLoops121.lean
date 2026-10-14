import Source3.KeygenSamplerRefill121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerLoops121
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeExtractSource (Layout)

def inner (ctx : Layout) (rngFuel block : Nat) : Nat → State → Option State
  | 0, _ => none
  | fuel+1, before => do
      let refilled ← KeygenSamplerRefill121.refill ctx rngFuel block before
      let (next,accepted) ← KeygenSamplerTail121.tail refilled
      if accepted then pure next else inner ctx rngFuel block fuel next

theorem inner_sound (ctx : Layout) (rngFuel block fuel : Nat) (before after : State)
    (computed : inner ctx rngFuel block fuel before=some after) :
    KeygenSamplerSource.Inner ctx (reference before) (reference after) := by
  induction fuel generalizing before with
  | zero => cases computed
  | succ fuel ih =>
      obtain ⟨refilled,refill,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨⟨next,accepted⟩,tail,rest⟩ := Option.bind_eq_some_iff.mp rest
      have head := KeygenSamplerRefill121.refill_sound ctx rngFuel block before refilled refill
      have last := KeygenSamplerTail121.tail_sound refilled next accepted tail
      cases accepted with
      | true =>
          have same := Option.some.inj rest
          subst after
          exact .accepted (reference before) (reference refilled) (reference next) head last
      | false =>
          exact .rejected (reference before) (reference refilled) (reference next) (reference after) head last (ih next rest)

def outer (ctx : Layout) (rngFuel block innerFuel : Nat) : Nat → State → Option State
  | 0, _ => none
  | fuel+1, before => do
      let value ← C99CompactScalar115.evaluate noCalls before.locals C99CountedWords.condition
      if value.integer=0 then pure before else do
        let declared ← KeygenScalarCompute121.run 16 KeygenSamplerSource.declareX before
        let sampled ← inner ctx rngFuel block innerFuel declared
        let restored := C99CompactState115.restoreScope before sampled ["x".toList] []
        let updated ← KeygenScalarCompute121.run 16 KeygenSamplerSource.increment restored
        outer ctx rngFuel block innerFuel fuel updated

theorem outer_sound (ctx : Layout) (rngFuel block innerFuel fuel : Nat) (before after : State)
    (computed : outer ctx rngFuel block innerFuel fuel before=some after) :
    KeygenSamplerSource.Outer ctx (reference before) (reference after) := by
  induction fuel generalizing before with
  | zero => cases computed
  | succ fuel ih =>
      obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
      have guard := C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
        before.locals C99CountedWords.condition value evaluated
      split at rest
      next zero =>
        have same := Option.some.inj rest
        subst after
        exact .done (reference before) (C99ValueBridge.value value) guard
          (by simpa only [C99ValueBridge.integer_matches] using zero)
      next nonzero =>
        let declared : State := {before with locals := C99CompactScalar115.declareMany before.locals .u32 ["x".toList]}
        have declaration : KeygenScalarCompute121.run 16 KeygenSamplerSource.declareX before=some declared := rfl
        change (do
          let sampled ← inner ctx rngFuel block innerFuel declared
          let updated ← KeygenScalarCompute121.run 16 KeygenSamplerSource.increment
            (C99CompactState115.restoreScope before sampled ["x".toList] [])
          outer ctx rngFuel block innerFuel fuel updated)=some after at rest
        obtain ⟨sampled,iteration,rest⟩ := Option.bind_eq_some_iff.mp rest
        obtain ⟨updated,increment,following⟩ := Option.bind_eq_some_iff.mp rest
        have update := KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.increment
          (C99CompactState115.restoreScope before sampled ["x".toList] []) updated increment
        rw [C99CompactState115.reference_restoreScope] at update
        exact .next (reference before) (reference declared) (reference sampled) (reference updated) (reference after)
          (C99ValueBridge.value value) guard (by simpa only [C99ValueBridge.integer_matches] using nonzero)
          (KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.declareX before declared declaration)
          (inner_sound ctx rngFuel block innerFuel declared sampled iteration) update (ih updated following)

def run (ctx : Layout) (rngFuel block innerFuel outerFuel : Nat) (before : State) : Option State := do
  let declared ← KeygenScalarCompute121.run 16 KeygenSamplerSource.prologue before
  let ready ← KeygenScalarCompute121.run 16 KeygenSamplerSource.initial declared
  outer ctx rngFuel block innerFuel outerFuel ready

theorem run_sound (ctx : Layout) (rngFuel block innerFuel outerFuel : Nat) (before after : State)
    (computed : run ctx rngFuel block innerFuel outerFuel before=some after) :
    KeygenSamplerSource.Exec ctx (reference before) (reference after) := by
  obtain ⟨declared,setup,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨ready,initialized,body⟩ := Option.bind_eq_some_iff.mp rest
  exact .run (reference declared) (reference ready) (reference after)
    (KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.prologue before declared setup)
    (KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.initial declared ready initialized)
    (outer_sound ctx rngFuel block innerFuel outerFuel ready after body)

end FT1536.Source3.KeygenSamplerLoops121
