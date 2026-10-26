import Source3.SecondStepFirstBody203
import Source3.KeygenTables204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepOuter204
open C99ArrayReference (State Name)
open C99MemoryReference (Allocated ArrayPointer)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open SecondStepLayout197 (fd gd fs gs gm igm t1)
open KeygenFullData127 (primes)
open SecondStepBasic203 (Basic)
open SecondStepFirstBody203 (next bodyState scope_locals next_u next_heap)

structure Outer (s : State) (u : Nat) : Prop where
  nCell : USlot s "n" 256
  hnCell : USlot s "hn" 128
  slenCell : USlot s "slen" 2
  tlenCell : USlot s "tlen" 3
  uCell : USlot s "u" u
  lognCell : Slot s "logn" 8
  terCell : Slot s "ter" 1
  inCell : s.locals "in_ntt".toList=some (.int32,some (.int32 1))
  outCell : s.locals "out_ntt".toList=some (.int32,some (.int32 1))
  fdBinding : s.arrays "fd".toList=some fd
  gdBinding : s.arrays "gd".toList=some gd
  fsBinding : s.arrays "fs".toList=some fs
  gsBinding : s.arrays "gs".toList=some gs
  gmBinding : s.arrays "gm".toList=some gm
  igmBinding : s.arrays "igm".toList=some igm
  t1Binding : s.arrays "t1".toList=some t1
  primesBinding : s.arrays "primes".toList=some primes
  writable : s.heap.writable 31=true
  allocated : ∀ index<71680, Allocated s.heap (⟨31,0,71680,4,index⟩ : ArrayPointer)

theorem next_local (before out : State) (name : Name) (notU : name≠"u".toList)
    (absent : name∉StepPrimeShape188.localNames) : (next before out).locals name=out.locals name :=
  (FftLocalCells140.outside (bodyState before out) "u".toList name (C99NatWord141.word 1) notU).trans
    (scope_locals before out name absent)

theorem next_array (before out : State) (name : Name) (absent : name∉StepPrimeShape188.pointerNames) :
    (next before out).arrays name=out.arrays name := by
  change (if StepPrimeShape188.pointerNames.contains name then before.arrays name else out.arrays name)=out.arrays name
  simp only [List.contains_iff_mem,absent,ite_false]

theorem of_next (before out : State) (p p0i r2 : BitVec 32) (h : Basic out 0 p p0i r2) : Outer (next before out) 1 := by
  refine ⟨(next_local _ _ _ (by decide) (by decide)).trans h.nCell,
    (next_local _ _ _ (by decide) (by decide)).trans h.hnCell,
    (next_local _ _ _ (by decide) (by decide)).trans h.slenCell,
    (next_local _ _ _ (by decide) (by decide)).trans h.tlenCell,next_u before out,
    (next_local _ _ _ (by decide) (by decide)).trans h.lognCell,
    (next_local _ _ _ (by decide) (by decide)).trans h.terCell,
    (next_local _ _ _ (by decide) (by decide)).trans h.inCell,
    (next_local _ _ _ (by decide) (by decide)).trans h.outCell,
    (next_array _ _ _ (by decide)).trans h.fdBinding,(next_array _ _ _ (by decide)).trans h.gdBinding,
    (next_array _ _ _ (by decide)).trans h.fsBinding,(next_array _ _ _ (by decide)).trans h.gsBinding,
    (next_array _ _ _ (by decide)).trans h.gmBinding,(next_array _ _ _ (by decide)).trans h.igmBinding,
    (next_array _ _ _ (by decide)).trans h.t1Binding,(next_array _ _ _ (by decide)).trans h.primesBinding,?_,?_⟩
  · rw [next_heap]; exact h.writable
  · intro index bound
    rw [next_heap]
    exact h.allocated index bound

def counter (before out : State) (n : Nat) := FftLocalCells140.put (bodyState before out) "u".toList (C99NatWord141.word n)

theorem counter_heap (before out : State) (n : Nat) : (counter before out n).heap=out.heap := rfl

theorem counter_local (before out : State) (n : Nat) (name : Name) (notU : name≠"u".toList)
    (absent : name∉StepPrimeShape188.localNames) : (counter before out n).locals name=out.locals name :=
  (FftLocalCells140.outside (bodyState before out) "u".toList name (C99NatWord141.word n) notU).trans
    (scope_locals before out name absent)

theorem counter_array (before out : State) (n : Nat) (name : Name) (absent : name∉StepPrimeShape188.pointerNames) :
    (counter before out n).arrays name=out.arrays name := next_array before out name absent

theorem of_counter (before out : State) (u n : Nat) (p p0i r2 : BitVec 32) (h : Basic out u p p0i r2) :
    Outer (counter before out n) n := by
  refine ⟨(counter_local _ _ _ _ (by decide) (by decide)).trans h.nCell,
    (counter_local _ _ _ _ (by decide) (by decide)).trans h.hnCell,
    (counter_local _ _ _ _ (by decide) (by decide)).trans h.slenCell,
    (counter_local _ _ _ _ (by decide) (by decide)).trans h.tlenCell,FftLocalCells140.cell_at _ _ _,
    (counter_local _ _ _ _ (by decide) (by decide)).trans h.lognCell,
    (counter_local _ _ _ _ (by decide) (by decide)).trans h.terCell,
    (counter_local _ _ _ _ (by decide) (by decide)).trans h.inCell,
    (counter_local _ _ _ _ (by decide) (by decide)).trans h.outCell,
    (counter_array _ _ _ _ (by decide)).trans h.fdBinding,(counter_array _ _ _ _ (by decide)).trans h.gdBinding,
    (counter_array _ _ _ _ (by decide)).trans h.fsBinding,(counter_array _ _ _ _ (by decide)).trans h.gsBinding,
    (counter_array _ _ _ _ (by decide)).trans h.gmBinding,(counter_array _ _ _ _ (by decide)).trans h.igmBinding,
    (counter_array _ _ _ _ (by decide)).trans h.t1Binding,(counter_array _ _ _ _ (by decide)).trans h.primesBinding,?_,?_⟩
  · rw [counter_heap]; exact h.writable
  · intro index bound; rw [counter_heap]; exact h.allocated index bound

end FT1536.Source3.SecondStepOuter204
