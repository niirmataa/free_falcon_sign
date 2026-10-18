import Source3.PublicInverseTripleWrites172
import Source3.KeygenPublicRootInverseProgram
import Source3.PublicAppendSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRootReads174
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec Stmt chain)
open KeygenSmallOutput (element)
open KeygenPublicTableAtoms (Slot var)
open KeygenNttLoopSupport (USlot)
open PublicGenerateTable159 (Written)
open PublicGenerateRow159 (keep_slot keep_u64 rowValue mont_var u32_slot_after chain_step)
open PublicTailShape159 (load cvar cadd mont)

def names : List C99ArrayReference.Name := ["a0".toList,"a1".toList,"b".toList]
def declared (s : State) : State :=
  {s with locals := C99DeclarationCells.declareCells .uint32 names s.locals}

structure Ready (s : State) (a : ArrayPointer) (u : Nat) (x y twiddle : BitVec 32) : Prop where
  binding : s.arrays "a".toList=some a
  counter : USlot s "u" u
  half : USlot s "hn" 768
  first : Slot s "a0" x
  second : Slot s "a1" y
  factor : Slot s "r" twiddle
  bCell : s.locals "b".toList=some (.uint32,none)

def head : Stmt := chain [
  .scalar (.declare .u32 names),
  .assign "a0".toList (load "a" (cvar "u")),
  .assign "a1".toList (load "a" (cadd (cvar "u") (cvar "hn")))]

theorem source (s : State) (a : ArrayPointer) (v : Nat) (twiddle : BitVec 32)
    (bound : v+768 < 2^64) (capacity : a.index+(v+768) ≤ a.count)
    (binding : s.arrays "a".toList=some a)
    (counter : USlot s "u" v) (half : USlot s "hn" 768) (factor : Slot s "r" twiddle)
    (low : Written s.heap (element a v)) (high : Written s.heap (element a (v+768))) :
    ∃ after x y, Exec KeygenPublicSource.program [] head s ⟨after,.normal⟩ ∧
      Ready after a v x y twiddle ∧ after.heap=s.heap := by
  let d := declared s
  have declRun : Exec KeygenPublicSource.program [] (.scalar (.declare .u32 names)) s ⟨d,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32 names s.locals)
  have vD : USlot d "u" v := counter
  have htD : USlot d "hn" 768 := half
  have sD : Slot d "r" twiddle := factor
  have aD : d.arrays "a".toList=some a := binding
  obtain ⟨w0,read0,slot0⟩ := PublicWordSteps161.load_assign d "a0" "a" (cvar "u")
    (element a v) none (by rfl)
    (PublicWordSteps161.address_var d "a" "u" a v (by omega) aD vD (by omega)) low
  let s1 := bindValue d "a0".toList .uint32 (C99NarrowReads.unsignedPromotion w0)
  have v1 := keep_u64 d "u" "a0" .uint32 (C99NarrowReads.unsignedPromotion w0) v (by decide) vD
  have ht1 := keep_u64 d "hn" "a0" .uint32 (C99NarrowReads.unsignedPromotion w0) 768 (by decide) htD
  have s1Slot := keep_slot d "r" "a0" .uint32 (C99NarrowReads.unsignedPromotion w0)
    twiddle (by decide) sD
  obtain ⟨w1,read1,slot1⟩ := PublicWordSteps161.load_assign s1 "a1" "a"
    (cadd (cvar "u") (cvar "hn")) (element a (v+768)) none (by rfl)
    (PublicWordSteps161.address_sum s1 "a" "u" "hn" a v 768 bound binding v1 ht1 capacity) high
  let s2 := bindValue s1 "a1".toList .uint32 (C99NarrowReads.unsignedPromotion w1)
  have v2 := keep_u64 s1 "u" "a1" .uint32 (C99NarrowReads.unsignedPromotion w1) v (by decide) v1
  have ht2 := keep_u64 s1 "hn" "a1" .uint32 (C99NarrowReads.unsignedPromotion w1) 768 (by decide) ht1
  have s2Slot := keep_slot s1 "r" "a1" .uint32 (C99NarrowReads.unsignedPromotion w1)
    twiddle (by decide) s1Slot
  have x2 := keep_slot s1 "a0" "a1" .uint32 (C99NarrowReads.unsignedPromotion w1)
    (BitVec.ofNat 32 w0.toNat) (by decide) slot0
  exact ⟨s2,_,_,chain_step _ _ s d ⟨s2,.normal⟩ declRun
    (chain_step _ _ d s1 ⟨s2,.normal⟩ read0
      (chain_step _ _ s1 s2 ⟨s2,.normal⟩ read1 (.skip s2))),
    ⟨binding,v2,ht2,x2,slot1,s2Slot,rfl⟩,rfl⟩

end FT1536.Source3.PublicRootReads174
