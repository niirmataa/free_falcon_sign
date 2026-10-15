import Source3.GeneratedBound135
import Source3.KeygenBoundFrame135
import Source3.SelectedResultantGate130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedBound135
open C99CompactState115 (State reference)
open GeneratedBound135

def before : State := NormalizedSamples129.after

def after : State := {before with locals := C99NameMap115.put before.locals "bound".toList (.u64 (some finalWord))}

theorem valid : ∀ event∈events, FprBoundEvents135.Valid event := by
  intro event member
  simp only [events,List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl
  · exact valid0
  · exact valid1
  · exact valid2
  · exact valid3
  · exact valid4
  · exact valid5
  · exact valid6
  · exact valid7

theorem checked_locals :
    (KeygenBoundModel135.run (FprBoundEvents135.lookup events) 16 code before).map State.locals=some after.locals := by
  decide +kernel

theorem computed : KeygenBoundModel135.run (FprBoundEvents135.lookup events) 16 code before=some after := by
  obtain ⟨out,run,locals⟩ := Option.map_eq_some_iff.mp checked_locals
  have frame := KeygenBoundFrame135.frame _ _ _ before out run
  have same : out=after := frame.trans (congrArg (fun cells => {before with locals := cells}) locals)
  exact run.trans (congrArg some same)

theorem source : KeygenSearchExtended133.Exec KeygenFullData127.env.ctx KeygenAttemptNorm.boundCode
    (reference before) ⟨reference after,.normal⟩ := by
  rw [GeneratedBound135.source]
  exact KeygenBoundSound135.run_sound (FprBoundEvents135.lookup events)
    (FprBoundEvents135.sound events valid) KeygenFullData127.env.ctx 16 code before after computed

theorem bound_word : (reference after).locals "bound".toList=some (.uint64,some (.uint64 finalWord)) := by
  simp [after,reference,C99CompactCells115.environment,C99NameMap115.lookup_put,C99CompactCells115.Cell.reference,
    C99CompactCells115.Cell.ty,C99CompactCells115.Cell.value,C99ValueBridge.type,C99ValueBridge.value]

theorem heap_same : after.heap=before.heap := rfl
theorem arrays_same : after.arrays=before.arrays := rfl
theorem globals_same : after.globals=before.globals := rfl
theorem tables_same : after.tables=before.tables := rfl

theorem other_local (name : C99ArrayReference.Name) (other : name≠"bound".toList) :
    (reference after).locals name=(reference before).locals name := by
  simp only [after,reference,C99CompactCells115.environment,C99NameMap115.lookup_put,ite_eq_right other]

end FT1536.Source3.SelectedBound135
