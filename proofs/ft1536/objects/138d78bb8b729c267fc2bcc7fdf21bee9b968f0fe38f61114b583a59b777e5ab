import Source3.SmallintsLoopBridge
import Source3.MknReference
import Source3.C99DeclarationCells
import Source3.C99SequenceInversion

namespace FT1536.Source3.SmallintsPrelude
open C99ArrayReference (State)
open C99ProcedureReference (Exec Result)

def declaration : C99ArrayReference.Stmt := .scalar (.declare .u64 ["n".toList,"u".toList])
def sizeAssignment : C99ArrayReference.Stmt := .assign "n".toList (.scalar MknReference.expression)
def declared (before : State) : State :=
  {before with locals := C99DeclarationCells.declareCells .uint64 ["n".toList,"u".toList] before.locals}
def sized (before : State) : State := C99ArrayReference.bindValue (declared before) "n".toList .uint64 (.uint64 1536)
def ready (before : State) : State := C99ArrayReference.bindValue (sized before) "u".toList .uint64 (.int32 0)

theorem declared_profile (before : State) (profile : MknReference.Profile before) : MknReference.Profile (declared before) := by
  simpa [MknReference.Profile,declared,C99DeclarationCells.declareCells,C99ScalarReference.set] using profile
theorem declared_n (before : State) : (declared before).locals "n".toList=some (.uint64,none) := by
  simp [declared,C99DeclarationCells.declareCells,C99ScalarReference.set]
theorem sized_u (before : State) : (sized before).locals "u".toList=some (.uint64,none) := by
  simp [sized,declared,C99DeclarationCells.declareCells,C99ArrayReference.bindValue,C99ScalarReference.set]
theorem ready_counter (before : State) : C99CountedWords.Counter (ready before) 0 := by
  simp [C99CountedWords.Counter,ready,C99ArrayReference.bindValue,C99ScalarReference.set,
    C99IntegerReference.convert,C99IntegerReference.Value.integer]
theorem ready_limit (before : State) : C99CountedWords.Limit (ready before) := by
  simp [C99CountedWords.Limit,ready,sized,C99ArrayReference.bindValue,C99ScalarReference.set,
    C99IntegerReference.convert,C99IntegerReference.Value.integer]
theorem ready_heap (before : State) : (ready before).heap=before.heap := rfl
theorem ready_arrays (before : State) : (ready before).arrays=before.arrays := rfl

theorem declaration_result (before after : State)
    (source : C99ArrayReference.Exec FftLeafPrograms.program declaration before after) : after=declared before := by
  cases source with
  | scalar before env statement body =>
      have he := C99DeclarationCells.complete FprPrefixCalls.calls .uint64 ["n".toList,"u".toList] before.locals (.normal env) body
      have hh := C99ScalarReference.Result.normal.inj he
      rw [hh]
      rfl

theorem size_result (before after : State) (profile : MknReference.Profile before)
    (source : C99ArrayReference.Exec FftLeafPrograms.program sizeAssignment (declared before) after) : after=sized before := by
  cases source with
  | assign state name expression ty old value declaration evaluated =>
      have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declaration.symm.trans (declared_n before)))
      subst ty
      cases evaluated with
      | scalar _ _ execution =>
          have hv := MknReference.source_value (declared before) value (declared_profile before profile) execution
          subst value
          rfl

theorem counter_result (before : State) (result : Result)
    (source : Exec FftProcedurePrograms.program SmallintsProgram.initialCounter (sized before) result) :
    result=⟨ready before,.normal⟩ := by
  cases source with
  | base _ _ _ execution =>
      cases execution with
      | scalar state env statement body =>
          obtain ⟨ty,old,value,declaration,evaluated,he⟩ := C99ControlInversion.assign_inv _ _ _ _ _ body
          have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declaration.symm.trans (sized_u before)))
          subst ty
          cases evaluated
          have hh := C99ScalarReference.Result.normal.inj he
          rw [hh]
          rfl

theorem extract_for (before : State) (result : Result) (profile : MknReference.Profile before)
    (source : Exec FftProcedurePrograms.program SmallintsProgram.body before result) :
    Exec FftProcedurePrograms.program (.seq (.seq SmallintsProgram.initialCounter SmallintsProgram.loop) SmallintsProgram.skip)
      (sized before) result := by
  obtain ⟨first,hs,ht⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program declaration _ before result source
  have he := declaration_result before first hs
  subst first
  obtain ⟨second,hs,ht⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program sizeAssignment _ (declared before) result ht
  have he := size_result before second profile hs
  subst second
  exact ht

theorem source_loop (dst src : C99MemoryReference.ArrayPointer) (before : State) (result : Result)
    (profile : MknReference.Profile before)
    (destination : before.arrays "r".toList=some dst) (input : before.arrays "t".toList=some src)
    (source : Exec FftProcedurePrograms.program SmallintsProgram.body before result) :
    result.flow=.normal ∧ SmallintsConversion.Loop dst src 0 before.heap result.state.heap := by
  have hfor := extract_for before result profile source
  cases hfor with
  | seqNormal first tail entry middle result execution rest =>
      have hloop := C99SequenceInversion.continuation FftProcedurePrograms.program
        SmallintsProgram.initialCounter SmallintsProgram.loop (sized before) (ready before) ⟨middle,.normal⟩
        (fun out h => counter_result before out h) execution
      have hl := SmallintsLoopBridge.complete dst src SmallintsProgram.loop (ready before) ⟨middle,.normal⟩ hloop rfl
        0 (by decide) (ready_counter before) (ready_limit before) destination input
      have he := C99ProcedureScalars.skip_result FftProcedurePrograms.program middle result rest
      rw [he]
      exact hl
  | seqExit first tail entry result execution exit =>
      have hloop := C99SequenceInversion.continuation FftProcedurePrograms.program
        SmallintsProgram.initialCounter SmallintsProgram.loop (sized before) (ready before) result
        (fun out h => counter_result before out h) execution
      have hl := SmallintsLoopBridge.complete dst src SmallintsProgram.loop (ready before) result hloop rfl
        0 (by decide) (ready_counter before) (ready_limit before) destination input
      exact False.elim (exit hl.1)

theorem output_initialized (dst src : C99MemoryReference.ArrayPointer) (before : State) (result : Result)
    (profile : MknReference.Profile before)
    (destination : before.arrays "r".toList=some dst) (input : before.arrays "t".toList=some src)
    (width : dst.elementBytes=8)
    (source : Exec FftProcedurePrograms.program SmallintsProgram.body before result) :
    C99InitializationTrace.Initialized result.state.heap dst.block dst.offset 12288 :=
  SmallintsConversion.output_initialized dst src before.heap result.state.heap
    (source_loop dst src before result profile destination input source).2 width

end FT1536.Source3.SmallintsPrelude
