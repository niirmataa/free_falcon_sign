import Source3.SmallintsIteration
import Source3.SmallintsCounter

namespace FT1536.Source3.SmallintsLoopBridge
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Exec Result Stmt)
open C99CountedWords

theorem complete (dst src : ArrayPointer) (code : Stmt) (before : State) (result : Result)
    (source : Exec FftProcedurePrograms.program code before result)
    (shape : code=SmallintsProgram.loop) (i : Nat) (hi : i≤1536)
    (counter : Counter before i) (limit : Limit before)
    (destination : before.arrays "r".toList=some dst) (input : before.arrays "t".toList=some src) :
    result.flow=.normal ∧ SmallintsConversion.Loop dst src i before.heap result.state.heap := by
  induction source generalizing i with
  | base | seqNormal | seqExit | scope | branchTrue | branchFalse | returnVoid | returnValue |
    breakLoop | continueLoop | call => cases shape
  | loopFalse condition body increment before value guard zero =>
      cases shape
      exact ⟨rfl,.done i before.heap (guard_false before i value hi counter limit guard zero)⟩
  | loopNormal condition body increment before middle next result value guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      have strict := guard_true before i value hi counter limit guard nonzero
      obtain ⟨after,w,z,hm,read,conversion,write⟩ := SmallintsIteration.source_step dst src i before
        ⟨middle,.normal⟩ hi counter destination input iteration
      have hmiddle : middle={before with heap := after} := congrArg Result.state hm
      subst middle
      have hn := SmallintsCounter.source_increment {before with heap := after} i ⟨next,.normal⟩ hi counter update
      have hnext : next=SmallintsCounter.advanced {before with heap := after} i := congrArg Result.state hn
      subst next
      have finished := ih3 rfl (i+1) (by omega)
        (SmallintsCounter.advanced_counter {before with heap := after} i)
        (SmallintsCounter.advanced_limit {before with heap := after} i limit) destination input
      exact ⟨finished.1,.next i before.heap after result.state.heap w z strict read conversion write finished.2⟩
  | loopContinue condition body increment before middle next result value guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      obtain ⟨after,w,z,hm,_,_,_⟩ := SmallintsIteration.source_step dst src i before
        ⟨middle,.continueLoop⟩ hi counter destination input iteration
      have hflow := congrArg Result.flow hm
      cases hflow
  | loopBreak condition body increment before after value guard nonzero iteration ih =>
      cases shape
      obtain ⟨heap,w,z,hm,_,_,_⟩ := SmallintsIteration.source_step dst src i before
        ⟨after,.breakLoop⟩ hi counter destination input iteration
      have hflow := congrArg Result.flow hm
      cases hflow
  | loopReturn condition body increment before after value returned guard nonzero iteration ih =>
      cases shape
      obtain ⟨heap,w,z,hm,_,_,_⟩ := SmallintsIteration.source_step dst src i before
        ⟨after,.returned returned⟩ hi counter destination input iteration
      have hflow := congrArg Result.flow hm
      cases hflow

theorem initialized (dst src : ArrayPointer) (before : State) (result : Result)
    (counter : Counter before 0) (limit : Limit before)
    (destination : before.arrays "r".toList=some dst) (input : before.arrays "t".toList=some src)
    (width : dst.elementBytes=8)
    (source : Exec FftProcedurePrograms.program SmallintsProgram.loop before result) :
    C99InitializationTrace.Initialized result.state.heap dst.block dst.offset 12288 :=
  SmallintsConversion.output_initialized dst src before.heap result.state.heap
    (complete dst src SmallintsProgram.loop before result source rfl 0 (by decide) counter limit destination input).2 width

end FT1536.Source3.SmallintsLoopBridge
