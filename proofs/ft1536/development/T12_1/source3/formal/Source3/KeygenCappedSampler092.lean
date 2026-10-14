import Source3.KeygenPrefixFunction092

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCappedSampler092
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSamplerTail091 (Legal)
open C99Metadata091 (Stable)

theorem load32_live (heap : Memory) (p : ArrayPointer) (word : BitVec 32)
    (source : Load32 heap p word) : 0 < heap.size p.block := by
  cases source with
  | load bytes allocated width values => exact KeygenCallerEntry.allocated_live heap p allocated

theorem initial_legal (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) : Legal (KeygenSamplerContext.rng ctx) s := by
  refine ⟨?_, initial.staticLive⟩
  exact load32_live s.heap (KeygenSearchContext.field ctx 0 4) 10 initial.profile.1

theorem context_unique (ctx : Context) (before a b : State) (name : String)
    (legal : Legal (KeygenSamplerContext.rng ctx) before)
    (first : KeygenSamplerContext.Call ctx before name a)
    (second : KeygenSamplerContext.Call ctx before name b) : a = b := by
  cases first
  cases second
  exact KeygenSamplerOuter091.call_unique _ before a b _ legal (by assumption) (by assumption)

theorem context_stable (ctx : Context) (before after : State) (name : String)
    (source : KeygenSamplerContext.Call ctx before name after) : Stable before after := by
  cases source
  exact KeygenSamplerOuter091.call_stable _ before after _ (by assumption)

theorem context_legal (ctx : Context) (before after : State) (name : String)
    (source : KeygenSamplerContext.Call ctx before name after)
    (legal : Legal (KeygenSamplerContext.rng ctx) before) : Legal (KeygenSamplerContext.rng ctx) after :=
  KeygenSamplerTail091.stable_legal _ before after (context_stable ctx before after name source) legal

theorem cap_unique (ctx : Context) (before : State) (i : Nat) (a b : Result)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (first : KeygenMakeSampling.CappedSetup ctx before a)
    (second : KeygenMakeSampling.CappedSetup ctx before b) : a = b := by
  have left := KeygenMakeSampling.cap_before_setup ctx before i a remaining.2.2 remaining.1 remaining.2.1.1 first
  have right := KeygenMakeSampling.cap_before_setup ctx before i b remaining.2.2 remaining.1 remaining.2.1.1 second
  rcases left with exhausted | running <;> rcases right with exhausted' | running' <;> grind

theorem cap_stable (ctx : Context) (before : State) (i : Nat) (out : Result)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeSampling.CappedSetup ctx before out) : Stable before out.state := by
  rcases KeygenMakeSampling.cap_before_setup ctx before i out remaining.2.2 remaining.1 remaining.2.1.1 source with
      exhausted | running
  · rw [exhausted.2]
    exact ⟨rfl, rfl, rfl, rfl⟩
  · rw [running.2.1]
    exact ⟨rfl, rfl, rfl, rfl⟩

theorem capped_samples_unique (ctx : Context) (before : State) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (legal : Legal (KeygenSamplerContext.rng ctx) before)
    (entry1 middle1 after1 entry2 middle2 after2 : State)
    (cap1 : KeygenMakeSampling.CappedSetup ctx before ⟨entry1, .normal⟩)
    (first1 : KeygenSamplerContext.Call ctx entry1 "f" middle1)
    (second1 : KeygenSamplerContext.Call ctx middle1 "g" after1)
    (cap2 : KeygenMakeSampling.CappedSetup ctx before ⟨entry2, .normal⟩)
    (first2 : KeygenSamplerContext.Call ctx entry2 "f" middle2)
    (second2 : KeygenSamplerContext.Call ctx middle2 "g" after2) : after1 = after2 := by
  have same := congrArg Result.state (cap_unique ctx before i _ _ remaining cap1 cap2)
  change entry1 = entry2 at same
  subst entry2
  have entryLegal := KeygenSamplerTail091.stable_legal _ before entry1 (cap_stable ctx before i _ remaining cap1) legal
  have middleSame := context_unique ctx entry1 middle1 middle2 "f" entryLegal first1 first2
  subst middle2
  exact context_unique ctx middle1 after1 after2 "g" (context_legal ctx entry1 middle1 "f" first1 entryLegal) second1 second2

theorem prefix_remaining (ctx : Context) (input : KeygenPrefixFunction092.Input ctx) (after : State)
    (returned : after ∈ KeygenPrefixFunction092.runPrefix ctx input) :
    KeygenMakeSearchPrefix.Remaining after 0 ∧ Legal (KeygenSamplerContext.rng ctx) after := by
  have source := (KeygenPrefixFunction092.prefix_spec ctx input after).mp returned
  have info := KeygenMakeReady.normal_prefix ctx input.before after input.blocks input.primes input.rev input.original [] source
  have locals := KeygenMakeReady.normal_prefix_locals ctx input.before after input.blocks input.primes input.rev input.original [] source
  refine ⟨⟨info.1, ?_, by decide⟩, initial_legal ctx after _ _ _ _ info.2.1⟩
  change C99CountedWords.Limit after ∧ _
  unfold C99CountedWords.Limit
  rw [locals]
  exact ⟨rfl, rfl, rfl⟩

end FT1536.Source3.KeygenCappedSampler092
