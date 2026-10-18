import Source3.KeygenPublicInverseCalls
import Source3.PublicForwardEntry159
import Source3.SelectedQuotient171

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicInverseEntry172
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open PublicForwardEntry159 (outer entryT)

theorem parameters : KeygenPublicSource.params .inverse=KeygenPublicSource.params .forward := by decide
theorem parametersT : KeygenPublicSource.params .inverseT=KeygenPublicSource.params .forwardT := by decide

theorem binding (s : State) (a : ArrayPointer)
    (profile : KeygenPublicTableAtoms.Slot s "logn" 10) (ternary : KeygenPublicForwardWrapper.Ternary s)
    (input : s.arrays "h".toList=some a) (capacity : a.index≤a.count) :
    KeygenPublicWord.Bind s (KeygenPublicSource.params .inverse) KeygenPublicInputProgram.hArgs (outer s a) := by
  rw [parameters]
  exact PublicForwardEntry159.forward_bind s "h" a profile ternary input capacity

theorem bindingT (s : State) (a : ArrayPointer) (capacity : a.index≤a.count) :
    KeygenPublicWord.Bind (outer s a) (KeygenPublicSource.params .inverseT)
      KeygenPublicForwardWrapper.arguments (entryT s a) := by
  rw [parametersT]
  exact PublicForwardEntry159.forwardT_bind s a capacity

theorem lookup : KeygenPublicSource.program (KeygenPublicSource.name .inverse)=some (KeygenPublicSource.function .inverse) := by decide

theorem wrapper (s : State) (a : ArrayPointer) (body : State) (capacity : a.index≤a.count)
    (inner : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT) (entryT s a) ⟨body,.normal⟩) :
    Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverse) (outer s a)
      ⟨{outer s a with heap:=body.heap},.normal⟩ := by
  rw [KeygenPublicInverseCalls.source_complete]
  exact .seqNormal _ _ _ ({outer s a with heap:=body.heap}) _
    (.branchTrue _ _ _ _ _ (.int32 1)
      (.scalar _ _ (.variable "ternary".toList .int32 (.int32 1) (PublicForwardEntry159.ternary_slot s a))) (by decide)
      (.scope _ _ _ _ _
        (.seqNormal _ _ _ ({outer s a with heap:=body.heap}) _
          (.call (KeygenPublicSource.name .inverseT) KeygenPublicForwardWrapper.arguments
            (KeygenPublicSource.function .inverseT) (outer s a) (entryT s a) ⟨body,.normal⟩
            KeygenPublicInverseCalls.inverse_lookup (bindingT s a capacity) inner .voidEnd)
          (.skip _)))) (.skip _)

theorem source_call (s : State) (a : ArrayPointer) (body : State)
    (profile : KeygenPublicTableAtoms.Slot s "logn" 10) (ternary : KeygenPublicForwardWrapper.Ternary s)
    (input : s.arrays "h".toList=some a) (capacity : a.index≤a.count)
    (inner : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT) (entryT s a) ⟨body,.normal⟩) :
    Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicSuffixProgram.inverse s
      ⟨{s with heap:=body.heap},.normal⟩ :=
  .call (KeygenPublicSource.name .inverse) KeygenPublicInputProgram.hArgs (KeygenPublicSource.function .inverse)
    s (outer s a) ⟨{outer s a with heap:=body.heap},.normal⟩ lookup (binding s a profile ternary input capacity)
    (wrapper s a body capacity inner) .voidEnd

theorem selected (body : State)
    (inner : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT)
      (entryT SelectedQuotient171.after SelectedPublicBinding157.h) ⟨body,.normal⟩) :
    Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicSuffixProgram.inverse
      SelectedQuotient171.after ⟨{SelectedQuotient171.after with heap:=body.heap},.normal⟩ :=
  source_call SelectedQuotient171.after SelectedPublicBinding157.h body SelectedQuotient171.output_fixed.profile
    SelectedQuotient171.output_fixed.ternary SelectedQuotient171.output_fixed.hBinding (by decide) inner

end FT1536.Source3.PublicInverseEntry172
