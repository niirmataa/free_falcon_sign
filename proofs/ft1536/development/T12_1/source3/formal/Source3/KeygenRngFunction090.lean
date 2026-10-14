import Source3.KeygenRngDeterminism090
import Mathlib.Data.Part

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRngFunction090
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open ShakeExtractSource (Layout)
open KeygenRngSource (allocated disposed)
open RngTemporarySwap090 (TablesLive)

theorem extract_metadata (ctx : Layout) (before after : State) (out : ArrayPointer) (length : Value)
    (source : ShakeExtractFrame.Call ctx before out length after) :
    after.heap.size = before.heap.size ∧ after.heap.writable = before.heap.writable := by
  let spare := max ctx.block out.block + 1
  have ctxOutside : ctx.block ≠ spare := by dsimp [spare]; omega
  have outOutside : out.block ≠ spare := by dsimp [spare]; omega
  have keep := ShakeExtractFrame.call_frame ctx before after out length spare ctxOutside outOutside source
  exact ⟨keep.1, keep.2.1⟩

theorem call_metadata (ctx : Layout) (before after : State) (word : BitVec 64)
    (source : KeygenRngSource.Call ctx before after word) :
    after.heap.size = before.heap.size ∧ after.heap.writable = before.heap.writable := by
  cases source with
  | run block drawn word fresh extract read =>
      have memoryInfo := extract_metadata ctx {before with heap := allocated before.heap block}
        drawn (KeygenRngSource.bytes block) (.uint64 8) extract
      constructor
      · funext b
        by_cases equal : b = block
        · simp only [disposed, equal, ite_true]
        · simpa only [disposed, allocated, equal, ite_false] using congrFun memoryInfo.1 b
      · funext b
        by_cases equal : b = block
        · simp only [disposed, equal, ite_true]
        · simpa only [disposed, allocated, equal, ite_false] using congrFun memoryInfo.2 b

theorem call_tables (ctx : Layout) (before after : State) (word : BitVec 64)
    (source : KeygenRngSource.Call ctx before after word) : after.tables = before.tables := by
  cases source
  rfl

theorem preserves_live (ctx : Layout) (before after : State) (word : BitVec 64)
    (ctxLive : 0 < before.heap.size ctx.block) (tablesLive : TablesLive before)
    (source : KeygenRngSource.Call ctx before after word) :
    0 < after.heap.size ctx.block ∧ TablesLive after := by
  have sizes := (call_metadata ctx before after word source).1
  have tables := call_tables ctx before after word source
  refine ⟨by rw [sizes]; exact ctxLive, ?_⟩
  intro name p binding
  rw [tables] at binding
  rw [sizes]
  exact tablesLive name p binding

structure Input (ctx : Layout) where
  before : State
  contextLive : 0 < before.heap.size ctx.block
  tablesLive : TablesLive before

/-- The real source draw, with no fair-word or independence assumption.
    Memory-domain witnesses enter as typed input legality, and are
    preserved by every source return. No totality is claimed here. -/
noncomputable def draw (ctx : Layout) (input : Input ctx) : Part (State × BitVec 64) where
  Dom := ∃ result : State × BitVec 64, KeygenRngSource.Call ctx input.before result.1 result.2
  get domain := Classical.choose domain

theorem draw_spec (ctx : Layout) (input : Input ctx) (result : State × BitVec 64) :
    result ∈ draw ctx input ↔ KeygenRngSource.Call ctx input.before result.1 result.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ value : State × BitVec 64, KeygenRngSource.Call ctx input.before value.1 value.2 := ⟨result, source⟩
    refine ⟨domain, ?_⟩
    have unique := KeygenRngDeterminism090.call_unique ctx input.before
      (Classical.choose domain).1 result.1 (Classical.choose domain).2 result.2
      input.contextLive input.tablesLive (Classical.choose_spec domain) source
    exact Prod.ext unique.1 unique.2

def successor (ctx : Layout) (input : Input ctx) (result : State × BitVec 64)
    (source : result ∈ draw ctx input) : Input ctx where
  before := result.1
  contextLive := (preserves_live ctx input.before result.1 result.2 input.contextLive input.tablesLive
    ((draw_spec ctx input result).mp source)).1
  tablesLive := (preserves_live ctx input.before result.1 result.2 input.contextLive input.tablesLive
    ((draw_spec ctx input result).mp source)).2

end FT1536.Source3.KeygenRngFunction090
