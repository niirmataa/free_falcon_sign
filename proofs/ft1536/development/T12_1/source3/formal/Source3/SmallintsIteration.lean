import Source3.SmallintsProgram
import Source3.C99CountedWords
import Source3.C99ProcedureScalars

namespace FT1536.Source3.SmallintsIteration
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Exec Result)
open C99CountedWords (Counter Limit)

theorem of_word (args : List C99IntegerReference.Value) (value : C99IntegerReference.Value)
    (source : FprPrefixCalls.calls "fpr_of".toList args value) :
    ∃ w : BitVec 64, value=.uint64 w := by
  change FprPrefixCalls.ValueCall FprPrefixCalls.baseCalls FprScaledAST.ofCode args value at source
  cases source
  exact ⟨_,rfl⟩

theorem source_step (dst src : ArrayPointer) (i : Nat) (before : State) (result : Result)
    (hi : i≤1536) (counter : Counter before i)
    (destination : before.arrays "r".toList=some dst) (input : before.arrays "t".toList=some src)
    (source : Exec FftProcedurePrograms.program SmallintsProgram.iteration before result) :
    ∃ (after : Memory) (w : BitVec 16) (z : BitVec 64),
      result=⟨{before with heap := after},.normal⟩ ∧
      C99NarrowReads.Load16 before.heap (KeygenSmallOutput.element src i) w ∧
      FprPrefixCalls.calls "fpr_of".toList [C99NarrowReads.signedPromotion w] (.uint64 z) ∧
      Store64 before.heap (KeygenSmallOutput.element dst i) z after := by
  cases source with
  | scope _ _ _ _ inner execution =>
      obtain ⟨middle,writeStep,tail⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program
        SmallintsProgram.store SmallintsProgram.skip before inner execution
      have he := C99ProcedureScalars.skip_result FftProcedurePrograms.program middle inner tail
      subst inner
      cases writeStep with
      | store64 before after array index expression p value address evaluated write =>
          have hp := C99CountedWords.pointer_exact before "r".toList dst p i hi counter destination address
          rw [hp] at write
          cases evaluated with
          | call1 _ _ x _ argument call =>
              cases argument
              rename_i q w read readAddress
              have hq := C99CountedWords.pointer_exact before "t".toList src q i hi counter input readAddress
              rw [hq] at read
              obtain ⟨z,hz⟩ := of_word _ value call
              subst value
              refine ⟨after,w,z,rfl,read,call,?_⟩
              simpa [C99IntegerReference.Value.integer,KeygenSmallOutput.element] using write

end FT1536.Source3.SmallintsIteration
