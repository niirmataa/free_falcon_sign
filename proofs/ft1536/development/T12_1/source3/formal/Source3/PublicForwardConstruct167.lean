import Source3.PublicForwardCleanup167

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicForwardConstruct167
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec allocated)
open PublicForwardEntry159 (entryT)
open PublicForwardBody159 (gmPointer igmPointer generateEntry)
open PublicForwardMemory167 (Data)

theorem source (s : State) (a : ArrayPointer) (g i : Nat) (data : Data s.heap a)
    (freshG : KeygenRngSource.Fresh s.heap g)
    (freshI : KeygenRngSource.Fresh (allocated s.heap g 2048) i) :
    ∃ after, Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT)
      (entryT s a) ⟨after,.normal⟩ ∧ KeygenRngSource.Fresh after.heap g ∧ KeygenRngSource.Fresh after.heap i := by
  have different := PublicForwardMemory167.distinct_tables s.heap g i freshI
  have tables := PublicForwardMemory167.generate_tables s a g i different
  obtain ⟨generated,generateRun,gmWritten,_,memory⟩ := PublicGenerateComplete166.source
    (generateEntry (entryT s a) g i) (gmPointer g) (igmPointer i) tables rfl
  have retained := PublicForwardMemory167.retained s.heap a g i data freshG freshI
  have afterData := PublicForwardMemory167.after_generator _ generated.heap a retained memory
  obtain ⟨last,tailRun⟩ := PublicForwardDomains167.tail s a g i generated afterData different
    (PublicForwardMemory167.outside_g s.heap a g data freshG).symm gmWritten memory
  exact ⟨_,PublicForwardBody159.source s a g i (by change 0 ≤ 2048; decide) (by change 0 ≤ 2048; decide) freshG freshI
    generated last generateRun tailRun,PublicForwardCleanup167.fresh_g s a g i last freshG,
    PublicForwardCleanup167.fresh_i s a g i last freshI⟩

theorem call (s : State) (name : String) (a : ArrayPointer) (g i : Nat) (data : Data s.heap a)
    (freshG : KeygenRngSource.Fresh s.heap g)
    (freshI : KeygenRngSource.Fresh (allocated s.heap g 2048) i)
    (profile : KeygenPublicTableAtoms.Slot s "logn" 10)
    (ternary : KeygenPublicForwardWrapper.Ternary s) (binding : s.arrays name.toList=some a) :
    ∃ after, Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
      (KeygenPublicFirstCalls.call name) s ⟨after,.normal⟩ := by
  obtain ⟨body,run,_,_⟩ := source s a g i data freshG freshI
  have cap := PublicForwardMemory167.capacity s.heap a data
  exact ⟨_,PublicForwardEntry159.source_call s name a body profile ternary binding (by omega) run⟩

end FT1536.Source3.PublicForwardConstruct167
