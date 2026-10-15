import Source3.ShakeExtractRun120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeProcessEvents128
open C99CompactState115 (State reference)

/-- Proposals supply only lane values. Pointer resolution is executed by
    the checker and retained as a source proof; the effect is explicit. -/
structure Event where
  before : State
  name : C99ArrayReference.Name
  pointer : C99MemoryReference.ArrayPointer
  words : List (BitVec 64)
  resolution : C99ArrayReference.Pointer (reference before) name ShakeExtractSource.zero pointer

def applyWords (heap : C99FiniteMemory114.Heap) (pointer : C99MemoryReference.ArrayPointer)
    (words : List (BitVec 64)) : C99FiniteMemory114.Heap :=
  words.zipIdx.foldl (fun heap pair => C99FiniteWrite114.write64 heap
    (KeygenSmallOutput.element pointer pair.2) pair.1) heap

def Event.after (event : Event) : State :=
  {event.before with heap := applyWords event.before.heap event.pointer event.words}

abbrev Proposal := State → C99MemoryReference.ArrayPointer → Option (List (BitVec 64))
abbrev Result := State × List Event

def request (propose : Proposal) (state : State) (name : C99ArrayReference.Name) : Option Result :=
  match address : C99CompactPointer115.pointer C99CompactPointer115.noCalls state name ShakeExtractSource.zero with
  | none => none
  | some pointer => (propose state pointer).map (fun words =>
      let event : Event := ⟨state,name,pointer,words,
        C99CompactPointer115.pointer_sound C99CompactPointer115.noCalls (C99CompactPointer115.noCalls_sound _)
          state name ShakeExtractSource.zero pointer address⟩
      (event.after,[event]))

def Valid (ctx : ShakeExtractSource.Layout) (event : Event) : Prop :=
  ShakeExtractSource.Exec ctx (.process event.name) (reference event.before) (reference event.after)

def All (ctx : ShakeExtractSource.Layout) (events : List Event) : Prop := ∀ event∈events, Valid ctx event

theorem left (ctx : ShakeExtractSource.Layout) (first second : List Event) (checked : All ctx (first++second)) : All ctx first :=
  fun event member => checked event (List.mem_append_left second member)

theorem right (ctx : ShakeExtractSource.Layout) (first second : List Event) (checked : All ctx (first++second)) : All ctx second :=
  fun event member => checked event (List.mem_append_right first member)

theorem singleton (ctx : ShakeExtractSource.Layout) (event : Event) (checked : All ctx [event]) : Valid ctx event :=
  checked event (List.mem_cons_self)

theorem request_sound (ctx : ShakeExtractSource.Layout) (propose : Proposal) (state after : State)
    (name : C99ArrayReference.Name) (events : List Event)
    (computed : request propose state name=some (after,events)) (checked : All ctx events) :
    ShakeExtractSource.Exec ctx (.process name) (reference state) (reference after) := by
  unfold request at computed
  split at computed
  next absent => cases computed
  next pointer address =>
    obtain ⟨words,_,result⟩ := Option.map_eq_some_iff.mp computed
    obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj result
    subst after
    subst events
    exact singleton ctx _ checked

end FT1536.Source3.ShakeProcessEvents128
