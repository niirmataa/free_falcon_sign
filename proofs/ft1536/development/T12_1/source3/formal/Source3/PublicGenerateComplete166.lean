import Source3.PublicGenerateEntry166
import Source3.PublicInitializedFrame164
import Source3.PublicAppendSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicGenerateComplete166
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec chain)
open KeygenPublicWord (Eval)
open KeygenPublicTableAtoms (Slot var literal)
open PublicGenerateTable159 (Tables WrittenRange)

theorem body_shape : KeygenPublicTableRows.body =
    KeygenPublicInputProgram.append (chain KeygenPublicTableRows.rowSteps) KeygenPublicTableRows.remaining := rfl

theorem guard_false (s : State) (profile : Slot s "logn" 10) :
    Eval [] s (.cmp .eq (var "logn") (literal 1)) (C99ScalarReference.boolean false) :=
  .cmp .eq _ _ _ _ _ (PublicGenerateHead159.eval_var s "logn" 10 profile)
    (PublicGenerateHead159.eval_lit s 1)
    (C99IntegerReference.CompareExec.step .eq (.uint32 10) (.int32 1) .uint32 rfl
      (.uint32 10) (.uint32 1) (C99CountedWords.convert_self (.uint32 10)).symm rfl)

theorem restore_entry (before after : State) (gm igm : ArrayPointer)
    (entry : PublicGenerateUpper159.AfterEntry after gm igm) :
    PublicGenerateUpper159.AfterEntry (C99ArrayReference.restoreScope before after ["b".toList] []) gm igm :=
  ⟨PublicGenerateUpper159.tables_frame after _ gm igm entry.tables rfl rfl rfl,
    entry.lognSlot,entry.kCell,entry.uCell,entry.wCell,entry.coveredTop⟩

theorem source (s : State) (gm igm : ArrayPointer) (tables : Tables s gm igm)
    (profile : Slot s "logn" 10) :
    ∃ after, Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate) s ⟨after,.normal⟩ ∧
      WrittenRange after.heap gm 0 1024 ∧ WrittenRange after.heap igm 0 1024 ∧
      PublicInitializedFrame164.Frame s.heap after.heap := by
  obtain ⟨rowEntry,prefixRun,entry⟩ := PublicGenerateEntry166.source s gm igm tables profile
  obtain ⟨rowEnd,rowRun,afterEntry,_⟩ := PublicGenerateRemaining159.remaining_source rowEntry gm igm entry
  have bodyRun : Exec KeygenPublicSource.program [] KeygenPublicTableRows.body
      (KeygenPublicTableSeed.ready s) ⟨rowEnd,.normal⟩ := by
    rw [body_shape]
    exact PublicAppendSource157.source _ [] _ _ _ rowEntry ⟨rowEnd,.normal⟩ prefixRun rowRun
  let restored := C99ArrayReference.restoreScope (KeygenPublicTableSeed.ready s) rowEnd ["b".toList] []
  have lastRowRun : Exec KeygenPublicSource.program [] KeygenPublicTableRows.lastRow
      (KeygenPublicTableSeed.ready s) ⟨restored,.normal⟩ :=
    .scope ["b".toList] [] _ _ ⟨rowEnd,.normal⟩ bodyRun
  have branchRun : Exec KeygenPublicSource.program [] KeygenPublicTableRows.dispatch
      (KeygenPublicTableSeed.ready s) ⟨restored,.normal⟩ :=
    .branchFalse _ _ _ _ _ (C99ScalarReference.boolean false)
      (guard_false _ (KeygenPublicTableRows.seed_profile s profile)) (by decide) lastRowRun
  obtain ⟨after,tailRun,gmWritten,igmWritten⟩ := PublicGenerateUpper159.afterRows_source restored gm igm
    (restore_entry (KeygenPublicTableSeed.ready s) rowEnd gm igm afterEntry)
  have suffixRun : Exec KeygenPublicSource.program [] KeygenPublicTableSeed.suffix
      (KeygenPublicTableSeed.ready s) ⟨after,.normal⟩ := by
    rw [KeygenPublicTableRows.source_dispatch]
    exact .seqNormal _ _ _ restored ⟨after,.normal⟩ branchRun tailRun
  have run := PublicGenerateHead159.head_source s ⟨after,.normal⟩ profile suffixRun
  exact ⟨after,run,gmWritten,igmWritten,PublicInitializedFrame164.source _ _ _ _ _ (by decide) run⟩

end FT1536.Source3.PublicGenerateComplete166
