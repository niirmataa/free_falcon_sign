import Source3.PublicMiddleReads161
import Source3.PublicAppendSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseReads173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec Stmt chain)
open KeygenSmallOutput (element)
open KeygenPublicTableAtoms (Slot var)
open KeygenNttLoopSupport (USlot)
open PublicGenerateTable159 (Written)
open PublicGenerateRow159 (keep_slot keep_u64 rowValue mont_var u32_slot_after chain_step)
open PublicTailShape159 (load cvar cadd mont)

open PublicMiddleReads161 (names declared Ready)

def head : Stmt := chain [
  .scalar (.declare .u32 names),
  .assign "a0".toList (load "a" (cvar "v")),
  .assign "a1".toList (load "a" (cadd (cvar "v") (cvar "ht")))]

theorem source (s : State) (a : ArrayPointer) (v ht : Nat) (twiddle : BitVec 32)
    (bound : v+ht < 2^64) (capacity : a.index+(v+ht) ≤ a.count)
    (binding : s.arrays "a".toList=some a)
    (counter : USlot s "v" v) (half : USlot s "ht" ht) (factor : Slot s "s" twiddle)
    (low : Written s.heap (element a v)) (high : Written s.heap (element a (v+ht))) :
    ∃ after x y, Exec KeygenPublicSource.program [] head s ⟨after,.normal⟩ ∧
      Ready after a v ht x y ∧ Slot after "s" twiddle ∧ after.heap=s.heap := by
  let d := declared s
  have declRun : Exec KeygenPublicSource.program [] (.scalar (.declare .u32 names)) s ⟨d,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32 names s.locals)
  have vD : USlot d "v" v := counter
  have htD : USlot d "ht" ht := half
  have sD : Slot d "s" twiddle := factor
  have aD : d.arrays "a".toList=some a := binding
  obtain ⟨w0,read0,slot0⟩ := PublicWordSteps161.load_assign d "a0" "a" (cvar "v")
    (element a v) none (by rfl)
    (PublicWordSteps161.address_var d "a" "v" a v (by omega) aD vD (by omega)) low
  let s1 := bindValue d "a0".toList .uint32 (C99NarrowReads.unsignedPromotion w0)
  have v1 := keep_u64 d "v" "a0" .uint32 (C99NarrowReads.unsignedPromotion w0) v (by decide) vD
  have ht1 := keep_u64 d "ht" "a0" .uint32 (C99NarrowReads.unsignedPromotion w0) ht (by decide) htD
  have s1Slot := keep_slot d "s" "a0" .uint32 (C99NarrowReads.unsignedPromotion w0)
    twiddle (by decide) sD
  obtain ⟨w1,read1,slot1⟩ := PublicWordSteps161.load_assign s1 "a1" "a"
    (cadd (cvar "v") (cvar "ht")) (element a (v+ht)) none (by rfl)
    (PublicWordSteps161.address_sum s1 "a" "v" "ht" a v ht bound binding v1 ht1 capacity) high
  let s2 := bindValue s1 "a1".toList .uint32 (C99NarrowReads.unsignedPromotion w1)
  have v2 := keep_u64 s1 "v" "a1" .uint32 (C99NarrowReads.unsignedPromotion w1) v (by decide) v1
  have ht2 := keep_u64 s1 "ht" "a1" .uint32 (C99NarrowReads.unsignedPromotion w1) ht (by decide) ht1
  have s2Slot := keep_slot s1 "s" "a1" .uint32 (C99NarrowReads.unsignedPromotion w1)
    twiddle (by decide) s1Slot
  have x2 := keep_slot s1 "a0" "a1" .uint32 (C99NarrowReads.unsignedPromotion w1)
    (BitVec.ofNat 32 w0.toNat) (by decide) slot0
  exact ⟨s2,_,_,chain_step _ _ s d ⟨s2,.normal⟩ declRun
    (chain_step _ _ d s1 ⟨s2,.normal⟩ read0
      (chain_step _ _ s1 s2 ⟨s2,.normal⟩ read1 (.skip s2))),
    ⟨binding,v2,ht2,x2,slot1⟩,s2Slot,rfl⟩

end FT1536.Source3.PublicReverseReads173
