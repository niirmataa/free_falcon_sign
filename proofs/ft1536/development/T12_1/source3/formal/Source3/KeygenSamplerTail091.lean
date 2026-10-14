import Source3.C99SimpleModular091
import Source3.KeygenRngFunction090
import Source3.KeygenSamplerCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerTail091
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open ShakeExtractSource (Layout)
open C99Metadata091 (Stable)
open RngTemporarySwap090 (TablesLive)

def Legal (ctx : Layout) (s : State) : Prop := 0 < s.heap.size ctx.block ∧ TablesLive s

theorem stable_legal (ctx : Layout) (before after : State) (stable : Stable before after)
    (legal : Legal ctx before) : Legal ctx after := by
  refine ⟨?_, ?_⟩
  · rw [stable.sizes]
    exact legal.1
  · intro name p binding
    rw [stable.tables] at binding
    rw [stable.sizes]
    exact legal.2 name p binding

theorem modular_legal (ctx : Layout) (code : C99ModularReference.Stmt) (before : State) (out : Result)
    (source : C99ModularReference.Exec code before out) (legal : Legal ctx before) : Legal ctx out.state :=
  stable_legal ctx before out.state (C99Metadata091.modular _ code before out source) legal

theorem store16 (before : Memory) (p : ArrayPointer) (word : BitVec 16) (a b : Memory)
    (first : KeygenSmallOutput.Store16 before p word a) (second : KeygenSmallOutput.Store16 before p word b) : a = b := by
  obtain ⟨_, _, _, sa, wa, ba, fa⟩ := first
  obtain ⟨_, _, _, sb, wb, bb, fb⟩ := second
  exact C99HeapDeterminism089.write_unique before p 2 (KeygenSmallOutput.byte16 word) a b
    ⟨sa, wa, ba, fa⟩ ⟨sb, wb, bb, fb⟩

theorem store_execution (before : State) (a b : Result)
    (first : KeygenSmallSource.Exec KeygenTernaryStore.store before a)
    (second : KeygenSmallSource.Exec KeygenTernaryStore.store before b) : a = b := by
  cases first
  cases second
  grind only [C99ScalarCallsDeterminism089.array_pointer, C99ScalarCallsDeterminism089.array_scalar, store16]

theorem store_stable (before : State) (out : Result)
    (source : KeygenSmallSource.Exec KeygenTernaryStore.store before out) : Stable before out.state := by
  cases source with
  | store16 dst index value before after p v address evaluated write =>
      exact ⟨write.2.2.2.1, write.2.2.2.2.1, rfl, rfl⟩

theorem branch_unique (before : State) (a b : Result)
    (first : KeygenTernaryStore.Branch before a) (second : KeygenTernaryStore.Branch before b) : a = b := by
  cases first <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar, store_execution]

theorem branch_stable (before : State) (out : Result)
    (source : KeygenTernaryStore.Branch before out) : Stable before out.state := by
  cases source with
  | rejected => exact ⟨rfl, rfl, rfl, rfl⟩
  | accepted middle v guard nonzero write => exact store_stable before ⟨middle, .normal⟩ write

theorem draw_checked : C99SimpleModular091.checkedCode KeygenTernaryStore.draw = true := by decide

theorem draw_unique (before : State) (a b : Result)
    (first : C99ModularReference.Exec KeygenTernaryStore.draw before a)
    (second : C99ModularReference.Exec KeygenTernaryStore.draw before b) : a = b :=
  C99SimpleModular091.execution _ _ before a b draw_checked first second

theorem tail_unique (before : State) (a b : Result)
    (first : KeygenTernaryStore.Exec before a) (second : KeygenTernaryStore.Exec before b) : a = b := by
  cases first
  cases second
  grind only [draw_unique, branch_unique]

theorem tail_stable (before : State) (out : Result) (source : KeygenTernaryStore.Exec before out) :
    Stable before out.state := by
  cases source with
  | tail middle out first branch =>
      exact C99Metadata091.trans before middle out.state
        (C99Metadata091.modular _ _ before ⟨middle, .normal⟩ first) (branch_stable middle out branch)

theorem tail_legal (ctx : Layout) (before : State) (out : Result)
    (source : KeygenTernaryStore.Exec before out) (legal : Legal ctx before) : Legal ctx out.state :=
  stable_legal ctx before out.state (tail_stable before out source) legal

end FT1536.Source3.KeygenSamplerTail091
