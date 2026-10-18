import Source3.TopProductLoop186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.LevelInitialization186
open C99ArrayReference (State)
open C99MemoryReference (Memory ArrayPointer)
open C99ProcedureReference (Result)
open C99InitializationTrace (Preserves)

theorem move (before after : Memory) (dst src : ArrayPointer) (count : Nat)
    (run : KeygenSearchMemory.Memmove before dst src count after) : Preserves before after := by
  obtain ⟨_,_,_,_,_,_,_,read,size,writable,copy,frame⟩ := run
  refine ⟨size,writable,?_⟩
  intro block offset initialized
  by_cases inside : block=dst.block ∧ dst.offset≤offset ∧ offset<dst.offset+count
  · obtain ⟨rfl,lo,hi⟩ := inside
    have bound : offset-dst.offset<count := by omega
    have equal : dst.offset+(offset-dst.offset)=offset := by omega
    have copied := copy (offset-dst.offset) bound
    rw [equal] at copied
    rw [copied]
    exact read _ bound
  · rw [frame block offset (by omega)]
    exact initialized

theorem modular (code : C99ModularReference.Stmt) (before : State) (out : Result)
    (run : C99ModularReference.Exec code before out) : Preserves before.heap out.state.heap :=
  C99InitializationTrace.steps_preserve _ _ (KeygenMkgm3RevMemory.memory_steps _ _ _ run)

theorem call (kind : KeygenLevelCalls.Kind) (before after : State) (args : List KeygenLevelCalls.Arg)
    (run : KeygenLevelCalls.Call kind before args after) : Preserves before.heap after.heap := by
  cases run with
  | run entry out binding source returned =>
    have result := modular _ entry out source
    rw [KeygenLevelCalls.bind_heap before entry _ _ binding] at result
    exact result

theorem source (code : KeygenLevelExec.Stmt) (before : State) (out : Result)
    (run : KeygenLevelExec.Exec code before out) : Preserves before.heap out.state.heap := by
  induction run with
  | modular code before out run => exact modular code before out run
  | prime => exact C99InitializationTrace.preserves_refl _
  | call kind args before after run => exact call kind before after args run
  | move dst src di si count before after p q word destination source length copy =>
    exact move before.heap after p q word.toNat copy
  | seqNormal a b before middle out head tail ih1 ih2 =>
    exact C99InitializationTrace.preserves_trans _ _ _ ih1 ih2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact C99InitializationTrace.preserves_trans _ _ _ ih1 (C99InitializationTrace.preserves_trans _ _ _ ih2 ih3)
  | loopFalse => exact C99InitializationTrace.preserves_refl _
  | seqExit | scope | branchTrue | branchFalse | loopReturn => assumption

end FT1536.Source3.LevelInitialization186
