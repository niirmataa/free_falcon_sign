import Source3.GeneratedSampler129F07
import Source3.ShakeEventFrame128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ProcessSite129F07
open C99CompactState115 (State reference)

def event : ShakeProcessEvents128.Event := GeneratedSampler129F07.output.2[0]'(by rw [GeneratedSampler129F07.event_count]; decide)
def caller := event.before
def ctx := SelectedFullSampler128.ctx
def pointer := ShakeExtractSource.field ctx .a
def table : C99MemoryReference.ArrayPointer := ⟨20,0,24,8,0⟩
def blockEntry := ShakeProcessCompute116.entry caller pointer table

theorem pointer_exact : pointer=ShakeExtractSource.field ctx .a := rfl
theorem event_pointer : event.pointer=pointer := by decide +kernel
theorem name_exact : event.name="A".toList := by decide +kernel
theorem table_binding : (reference caller).tables "RC".toList=some table := by decide +kernel
theorem static_checked : ShakeProcessCompute116.StaticGuard caller.heap table := by decide +kernel

theorem one_list (values : List α) (length : values.length=1) :
    values=[values[0]'(by omega)] := by
  cases values with
  | nil => cases length
  | cons head tail =>
      have empty : tail=[] := List.eq_nil_of_length_eq_zero (by simpa using length)
      subst tail
      rfl

theorem event_list : GeneratedSampler129F07.output.2=[event] := one_list _ GeneratedSampler129F07.event_count

theorem obligations (valid : ShakeProcessEvents128.Valid ctx event) : GeneratedSampler129F07.Obligations := by
  intro member present
  rw [event_list] at present
  have same := List.mem_singleton.mp present
  subst member
  exact valid

end FT1536.Source3.ProcessSite129F07
