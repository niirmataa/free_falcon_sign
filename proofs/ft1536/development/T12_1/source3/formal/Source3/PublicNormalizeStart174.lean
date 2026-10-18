import Source3.PublicNormalizeLoop174
import Source3.PublicDivisionSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicNormalizeStart174
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableAtoms (Slot var)

def niWord : BitVec 32 := KeygenPublicDivisionWords.division
  (PublicArgumentSource157.word (.i32 10237)) (PublicArgumentSource157.word (.u32 1536))

theorem value (s : State) (n : USlot s "n" 1536) :
    Eval [] s KeygenPublicNormalizeProgram.live (.uint32 niWord) := by
  have castN : Eval [] s (.cast .uint32 (var "n")) (.uint32 1536) :=
    .cast .uint32 _ (u64 1536) (.scalar _ _ (PublicGenerateIndex159.var_u64 s "n" 1536 n))
  exact .call2 _ _ _ (.int32 10237) (.uint32 1536) _ (PublicGenerateHead159.eval_lit s 10237) castN
    (PublicDivisionSource157.source (.i32 10237) (.u32 1536))

theorem source (s : State) (a : ArrayPointer) (data : PublicForwardMemory167.Data s.heap a)
    (binding : s.arrays "a".toList=some a) (n : USlot s "n" 1536) (profile : Slot s "logn" 10)
    (niType : PublicU32Locals165.Declared s "ni") (uType : KeygenPublicSizeOps.Declared s "u") :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicNormalizeProgram.complete s ⟨after,.normal⟩ ∧
      PublicNormalizeBody174.Fixed after a ∧ USlot after "u" 1536 := by
  obtain ⟨oldNi,niCell⟩ := niType
  obtain ⟨oldU,uCell⟩ := uType
  let withNi := bindValue s "ni".toList .uint32 (.uint32 niWord)
  let initial := bindValue withNi "u".toList .uint64 (u64 0)
  have dynamic : Exec KeygenPublicSource.program [] KeygenPublicNormalizeProgram.dynamic s ⟨withNi,.normal⟩ :=
    .assign _ _ _ .uint32 oldNi (.uint32 niWord) niCell (value s n)
  have niRun : Exec KeygenPublicSource.program [] KeygenPublicNormalizeProgram.niSet s ⟨withNi,.normal⟩ :=
    .branchFalse _ _ _ _ _ (.int32 0) (PublicForwardBody159.guard_eval s profile) PublicForwardBody159.guard_zero dynamic
  have init : Exec KeygenPublicSource.program [] KeygenPublicNormalizeProgram.initU withNi ⟨initial,.normal⟩ :=
    .assign _ _ _ .uint64 oldU (.int32 0) uCell (.scalar _ _ (.literal .int32 0))
  have factor := PublicGenerateRow159.keep_slot withNi "ni" "u" .uint64 (u64 0) niWord (by decide)
    (PublicGenerateRow159.u32_slot_after s "ni" niWord)
  have fixed : PublicNormalizeBody174.Fixed initial a := ⟨data,binding,n,niWord,factor⟩
  obtain ⟨after,loop,last,counter,_⟩ := PublicNormalizeLoop174.remaining 1536 0 initial a fixed
    (PublicGenerateRow159.u64_slot_after withNi "u" 0 (by decide)) rfl
  exact ⟨after,.seqNormal _ _ s withNi ⟨after,.normal⟩ niRun
    (.seqNormal _ _ withNi after ⟨after,.normal⟩
      (.seqNormal _ _ withNi initial ⟨after,.normal⟩ init loop) (.skip after)),last,counter⟩

end FT1536.Source3.PublicNormalizeStart174
