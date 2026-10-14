import Source3.KeygenSamplerInner091

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerOuter091
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99Metadata091 (Stable)
open ShakeExtractSource (Layout)
open KeygenSamplerSource (Outer Exec)
open KeygenSamplerTail091 (Legal)

theorem declaration_checked : C99SimpleModular091.checkedCode KeygenSamplerSource.declareX = true := by decide
theorem increment_checked : C99SimpleModular091.checkedCode KeygenSamplerSource.increment = true := by decide
theorem prologue_checked : C99SimpleModular091.checkedCode KeygenSamplerSource.prologue = true := by decide
theorem initial_checked : C99SimpleModular091.checkedCode KeygenSamplerSource.initial = true := by decide

theorem declaration_unique (before : State) (a b : Result)
    (first : C99ModularReference.Exec KeygenSamplerSource.declareX before a)
    (second : C99ModularReference.Exec KeygenSamplerSource.declareX before b) : a = b :=
  C99SimpleModular091.execution _ _ before a b declaration_checked first second

theorem increment_unique (before : State) (a b : Result)
    (first : C99ModularReference.Exec KeygenSamplerSource.increment before a)
    (second : C99ModularReference.Exec KeygenSamplerSource.increment before b) : a = b :=
  C99SimpleModular091.execution _ _ before a b increment_checked first second

theorem prologue_unique (before : State) (a b : Result)
    (first : C99ModularReference.Exec KeygenSamplerSource.prologue before a)
    (second : C99ModularReference.Exec KeygenSamplerSource.prologue before b) : a = b :=
  C99SimpleModular091.execution _ _ before a b prologue_checked first second

theorem initial_unique (before : State) (a b : Result)
    (first : C99ModularReference.Exec KeygenSamplerSource.initial before a)
    (second : C99ModularReference.Exec KeygenSamplerSource.initial before b) : a = b :=
  C99SimpleModular091.execution _ _ before a b initial_checked first second

theorem scope_legal (ctx : Layout) (before after : State) (legal : Legal ctx after) :
    Legal ctx (KeygenSamplerSource.closedScope before after) := ⟨legal.1, legal.2⟩

theorem outer_unique (ctx : Layout) (before a b : State) (legal : Legal ctx before)
    (first : Outer ctx before a) (second : Outer ctx before b) : a = b := by
  revert legal
  induction first generalizing b with
  | done =>
      intro legal
      cases second <;> grind only [C99ScalarCallsDeterminism089.array_scalar]
  | next before declared inner updated after v guard nonzero declaration iteration update rest ih =>
      intro legal
      have declaredLegal := KeygenSamplerTail091.modular_legal ctx _ before _ declaration legal
      have innerLegal := KeygenSamplerInner091.inner_legal ctx declared inner iteration declaredLegal
      have updatedLegal := KeygenSamplerTail091.modular_legal ctx _ _ _ update
        (scope_legal ctx before inner innerLegal)
      cases second
      all_goals grind only [C99ScalarCallsDeterminism089.array_scalar, declaration_unique,
        KeygenSamplerInner091.inner_unique, increment_unique]

theorem outer_stable (ctx : Layout) (before after : State) (source : Outer ctx before after) :
    Stable before after := by
  induction source with
  | done => exact ⟨rfl, rfl, rfl, rfl⟩
  | next before declared inner updated after v guard nonzero declaration iteration update rest ih =>
      have initStable := C99Metadata091.modular _ _ _ _ declaration
      have loopStable := KeygenSamplerInner091.inner_stable ctx declared inner iteration
      have updateInfo := C99Metadata091.modular _ _ _ _ update
      have updateStable : Stable inner updated :=
        ⟨updateInfo.sizes, updateInfo.writable, updateInfo.tables, updateInfo.globals⟩
      exact C99Metadata091.trans before updated after
        (C99Metadata091.trans before inner updated
          (C99Metadata091.trans before declared inner initStable loopStable) updateStable) ih

theorem source_unique (ctx : Layout) (before a b : State) (legal : Legal ctx before)
    (first : Exec ctx before a) (second : Exec ctx before b) : a = b := by
  cases first
  cases second
  grind only [prologue_unique, initial_unique, → KeygenSamplerTail091.modular_legal, outer_unique]

theorem source_stable (ctx : Layout) (before after : State) (source : Exec ctx before after) :
    Stable before after := by
  cases source with
  | run declared ready after setup initialization loop =>
      exact C99Metadata091.trans before ready after
        (C99Metadata091.trans before declared ready
          (C99Metadata091.modular _ _ _ _ setup) (C99Metadata091.modular _ _ _ _ initialization))
        (outer_stable ctx ready after loop)

theorem binding_stable (before after : State) (params : List C99ArrayReference.Param)
    (args : List C99ArrayReference.Arg) (source : C99ArrayReference.Bind before params args after) :
    Stable before after := by
  induction source with
  | nil => exact ⟨rfl, rfl, rfl, rfl⟩
  | scalar ty name e ps args out v value rest ih => exact ⟨ih.sizes, ih.writable, ih.tables, ih.globals⟩
  | pointer name src index ps args p out value rest ih => exact ⟨ih.sizes, ih.writable, ih.tables, ih.globals⟩

theorem binding_legal (ctx : Layout) (before after : State) (params : List C99ArrayReference.Param)
    (args : List C99ArrayReference.Arg) (source : C99ArrayReference.Bind before params args after)
    (legal : Legal ctx before) : Legal ctx after :=
  KeygenSamplerTail091.stable_legal ctx before after (binding_stable before after params args source) legal

theorem call_unique (ctx : Layout) (before a b : State) (args : List C99ArrayReference.Arg)
    (legal : Legal ctx before)
    (first : KeygenSamplerCalls.Call ctx before args a) (second : KeygenSamplerCalls.Call ctx before args b) :
    a = b := by
  cases first
  cases second
  grind only [C99ArrayDeterminism089.parameters, → binding_legal, source_unique]

theorem call_stable (ctx : Layout) (before after : State) (args : List C99ArrayReference.Arg)
    (source : KeygenSamplerCalls.Call ctx before args after) : Stable before after := by
  cases source with
  | run entry after binding body =>
      have all := C99Metadata091.trans before entry after
        (binding_stable before entry KeygenSamplerCalls.params args binding) (source_stable ctx entry after body)
      exact ⟨all.sizes, all.writable, rfl, rfl⟩

end FT1536.Source3.KeygenSamplerOuter091
