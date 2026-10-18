import Source3.PublicRootLoop174

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRootStart174
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open PublicInverseDomains172 (Arrays)
open PublicRootLoop174 (Fixed)
open PublicMiddleWrites161 (MemoryFrame)

def segment : KeygenPublicExec.Stmt := .seq KeygenPublicRootInverseProgram.seed KeygenPublicRootInverseProgram.pass

theorem source (s : State) (a table : ArrayPointer) (arrays : Arrays s a table)
    (half : USlot s "hn" 768) (rType : PublicU32Locals165.Declared s "r")
    (uType : KeygenPublicSizeOps.Declared s "u") :
    ∃ after, Exec KeygenPublicSource.program [] segment s ⟨after,.normal⟩ ∧
      Fixed after a ∧ USlot after "u" 768 ∧ MemoryFrame s after a := by
  obtain ⟨oldR,rCell⟩ := rType
  obtain ⟨oldU,uCell⟩ := uType
  have cap := PublicInverseDomains172.table_capacity s a table arrays
  obtain ⟨w,seed,rSlot⟩ := PublicWordSteps161.load_assign s "r" "igm_square" (PublicTailShape159.clit 0)
    (element table 0) oldR rCell
    (PublicTailFirst159.address_lit s "igm_square" table 0 (by decide) arrays.square (by omega))
    (arrays.tableWritten 0 (by decide))
  let withR := bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w)
  let initial := bindValue withR "u".toList .uint64 (u64 0)
  have init : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.initU withR ⟨initial,.normal⟩ :=
    .assign _ _ _ .uint64 oldU (.int32 0) uCell (.scalar _ _ (.literal .int32 0))
  have factor := PublicGenerateRow159.keep_slot withR "r" "u" .uint64 (u64 0)
    (BitVec.ofNat 32 w.toNat) (by decide) rSlot
  have fixed : Fixed initial a := ⟨arrays.data,arrays.aBinding,half,_,factor⟩
  obtain ⟨after,loop,last,counter,memory⟩ := PublicRootLoop174.remaining 768 0 initial a fixed
    (PublicGenerateRow159.u64_slot_after withR "u" 0 (by decide)) rfl
  have totalMemory : MemoryFrame s after a := ⟨memory.size,memory.writable,memory.outside,memory.written⟩
  exact ⟨after,.seqNormal _ _ s withR ⟨after,.normal⟩ seed
    (.seqNormal _ _ withR initial ⟨after,.normal⟩ init loop),last,counter,totalMemory⟩

theorem continue_section (s after : State) (out : C99ProcedureReference.Result)
    (rootRun : Exec KeygenPublicSource.program [] segment s ⟨after,.normal⟩)
    (remaining : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.remaining after out) :
    Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.remaining s out := by
  rw [KeygenPublicRootInverseProgram.source_remaining]
  cases rootRun with
  | seqNormal _ _ _ middle _ first second =>
    exact .seqNormal _ _ s middle out first (.seqNormal _ _ middle after out second remaining)
  | seqExit _ _ _ _ _ exit => exact (exit rfl).elim

end FT1536.Source3.PublicRootStart174
