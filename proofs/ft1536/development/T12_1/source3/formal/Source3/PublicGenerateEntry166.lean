import Source3.PublicGeneratePrefix166

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicGenerateEntry166
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec chain)
open KeygenPublicTableAtoms (Slot)
open PublicGenerateTable159 (Tables)
open PublicGenerateRemaining159 (RowEntry)
open PublicGeneratePrefix166 (targets inputs outputs)
open PublicU32Locals165 (Env Ready)

theorem seed_env (s : State) : Env (KeygenPublicTableSeed.ready s) targets := by
  intro name member
  exact ⟨none,(KeygenPublicTableRows.initial_owned s).2.2 name member⟩

theorem seed_ready (s : State) : Ready (KeygenPublicTableSeed.ready s) inputs := by
  intro name member
  simp [inputs] at member
  rcases member with rfl | rfl
  · exact ⟨_,(KeygenPublicTableRows.initial_owned s).1⟩
  · exact ⟨_,(KeygenPublicTableRows.initial_owned s).2.1⟩

theorem source (s : State) (gm igm : ArrayPointer) (tables : Tables s gm igm)
    (profile : Slot s "logn" 10) :
    ∃ after, Exec KeygenPublicSource.program [] (chain KeygenPublicTableRows.rowSteps)
      (KeygenPublicTableSeed.ready s) ⟨after,.normal⟩ ∧ RowEntry after gm igm := by
  obtain ⟨after,run,_,ready,bCell,heap⟩ :=
    PublicGeneratePrefix166.source (KeygenPublicTableSeed.ready s) (seed_env s) (seed_ready s)
  have frame := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) run
  have seedTables := PublicGenerateUpper159.tables_frame s (KeygenPublicTableSeed.ready s) gm igm tables rfl rfl rfl
  have afterTables := PublicGenerateUpper159.tables_frame (KeygenPublicTableSeed.ready s) after gm igm
    seedTables frame.2.1 (congrArg C99MemoryReference.Memory.size heap) (congrArg C99MemoryReference.Memory.writable heap)
  have logn := (frame.2.2 "logn".toList (by decide)).trans (KeygenPublicTableRows.seed_profile s profile)
  have k := (frame.2.2 "k".toList (by decide)).trans (KeygenPublicTableSeed.ready_slots s).2.2
  have u : after.locals "u".toList=some (.uint64,none) :=
    (frame.2.2 "u".toList (by decide)).trans (by rfl)
  have w : after.locals "w".toList=some (.uint32,none) :=
    (frame.2.2 "w".toList (by decide)).trans
      (KeygenPublicTableRows.ready_uninitialized s "w" (by decide) (by decide) (by decide) (by decide))
  exact ⟨after,run,afterTables,logn,⟨some (.uint32 12),k⟩,⟨none,bCell⟩,⟨none,u⟩,w,
    ready "x" (by decide),ready "ix" (by decide),ready "g2" (by decide),ready "g4" (by decide),
    ready "ig2" (by decide),ready "ig4" (by decide)⟩

end FT1536.Source3.PublicGenerateEntry166
