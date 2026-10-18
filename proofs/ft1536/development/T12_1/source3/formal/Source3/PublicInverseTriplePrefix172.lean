import Source3.PublicInverseTripleStart172

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicInverseTriplePrefix172
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open PublicInverseDomains172 (Arrays TailEntry)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableAtoms (Slot)

structure After (s : State) (a table : ArrayPointer) : Prop extends Arrays s a table where
  profile : Slot s "logn" 10
  nCell : USlot s "n" 1536
  hnCell : USlot s "hn" 768
  uCell : USlot s "u" 1536
  vCell : USlot s "v" 1024
  tType : KeygenPublicSizeOps.Declared s "t"
  mType : KeygenPublicSizeOps.Declared s "m"
  rType : PublicU32Locals165.Declared s "r"
  niType : PublicU32Locals165.Declared s "ni"

theorem source (s : State) (a table : ArrayPointer) (entry : TailEntry s a table) :
    ∃ after, Exec KeygenPublicSource.program [] PublicInverseTripleStart172.segment s ⟨after,.normal⟩ ∧
      After after a table := by
  obtain ⟨after,run,fixed,u,v⟩ := PublicInverseTripleStart172.source s a table entry.toArrays entry.cubic
    entry.nCell entry.profile entry.uType entry.vType entry.wType
  have frame := PublicScopedFrame162.frame _ _ _ _ _ (by decide) run
  refine ⟨after,run,⟨fixed.arrays,?_,fixed.length,?_,u,v,?_,?_,?_,?_⟩⟩
  · exact (frame.2.2 _ (by decide)).trans entry.profile
  · exact (frame.2.2 _ (by decide)).trans entry.hnCell
  · obtain ⟨old,cell⟩ := entry.tType
    exact ⟨old,(frame.2.2 _ (by decide)).trans cell⟩
  · obtain ⟨old,cell⟩ := entry.mType
    exact ⟨old,(frame.2.2 _ (by decide)).trans cell⟩
  · obtain ⟨old,cell⟩ := entry.rType
    exact ⟨old,(frame.2.2 _ (by decide)).trans cell⟩
  · obtain ⟨old,cell⟩ := entry.niType
    exact ⟨old,(frame.2.2 _ (by decide)).trans cell⟩

end FT1536.Source3.PublicInverseTriplePrefix172
