import Source3.KeygenSamplerTail091

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerInner091
open C99ArrayReference (State bindValue)
open C99ProcedureReference (Result)
open C99Metadata091 (Stable)
open ShakeExtractSource (Layout)
open KeygenSamplerSource (Refill Inner)
open KeygenSamplerTail091 (Legal)

theorem bits_checked : C99SimpleModular091.checkedCode KeygenSamplerSource.assignBits = true := by decide

theorem bits_unique (before : State) (a b : Result)
    (first : C99ModularReference.Exec KeygenSamplerSource.assignBits before a)
    (second : C99ModularReference.Exec KeygenSamplerSource.assignBits before b) : a = b :=
  C99SimpleModular091.execution _ _ before a b bits_checked first second

theorem refill_unique (ctx : Layout) (before a b : State) (legal : Legal ctx before)
    (first : Refill ctx before a) (second : Refill ctx before b) : a = b := by
  obtain ⟨contextLive, tablesLive⟩ := legal
  cases first <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar,
    KeygenRngDeterminism090.call_unique, bits_unique]

theorem refill_stable (ctx : Layout) (before after : State) (source : Refill ctx before after) :
    Stable before after := by
  cases source with
  | skip => exact ⟨rfl, rfl, rfl, rfl⟩
  | fill drawn after v w ty old guard nonzero declared draw bits =>
      have memoryInfo := KeygenRngFunction090.call_metadata ctx before drawn w draw
      have tables := KeygenRngFunction090.call_tables ctx before drawn w draw
      have globals : drawn.globals = before.globals := by cases draw; rfl
      have first : Stable before (bindValue drawn "rb".toList ty (.uint64 w)) :=
        ⟨memoryInfo.1, memoryInfo.2, tables, globals⟩
      exact C99Metadata091.trans _ _ _ first (C99Metadata091.modular _ _ _ _ bits)

theorem refill_legal (ctx : Layout) (before after : State) (source : Refill ctx before after)
    (legal : Legal ctx before) : Legal ctx after :=
  KeygenSamplerTail091.stable_legal ctx before after (refill_stable ctx before after source) legal

/-- Finite executions of the actual scalar rejection loop are unique.
    The induction follows rejection chronologically, retaining the same
    SHAKE state. It makes no claim of termination or independent draws. -/
theorem inner_unique (ctx : Layout) (before a b : State) (legal : Legal ctx before)
    (first : Inner ctx before a) (second : Inner ctx before b) : a = b := by
  revert legal
  induction first generalizing b <;> intro legal <;> cases second
  all_goals grind only [refill_unique, → refill_legal,
    KeygenSamplerTail091.tail_unique, → KeygenSamplerTail091.tail_legal]

theorem inner_stable (ctx : Layout) (before after : State) (source : Inner ctx before after) :
    Stable before after := by
  induction source with
  | accepted before refilled after refill tail =>
      exact C99Metadata091.trans before refilled after (refill_stable ctx before refilled refill)
        (KeygenSamplerTail091.tail_stable refilled ⟨after, .breakLoop⟩ tail)
  | rejected before refilled next after refill tail rest ih =>
      exact C99Metadata091.trans before next after
        (C99Metadata091.trans before refilled next (refill_stable ctx before refilled refill)
          (KeygenSamplerTail091.tail_stable refilled ⟨next, .normal⟩ tail)) ih

theorem inner_legal (ctx : Layout) (before after : State) (source : Inner ctx before after)
    (legal : Legal ctx before) : Legal ctx after :=
  KeygenSamplerTail091.stable_legal ctx before after (inner_stable ctx before after source) legal

end FT1536.Source3.KeygenSamplerInner091
