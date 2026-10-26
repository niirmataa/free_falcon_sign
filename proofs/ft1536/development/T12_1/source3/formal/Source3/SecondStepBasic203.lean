import Source3.SecondStepGeneratorKeep203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepBasic203
open C99ArrayReference (State Name)
open C99MemoryReference (Allocated ArrayPointer)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open SecondStepLayout197 (fd gd fs gs gm igm t1)
open KeygenFullData127 (primes)

structure Basic (s : State) (u : Nat) (p p0i r2 : BitVec 32) : Prop where
  nCell : USlot s "n" 256
  hnCell : USlot s "hn" 128
  slenCell : USlot s "slen" 2
  tlenCell : USlot s "tlen" 3
  uCell : USlot s "u" u
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  r2Cell : Slot s "R2" r2
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

theorem transport {s out : State} {code : KeygenMakeFgSource.Stmt} {u : Nat} {p p0i r2 : BitVec 32}
    (h : Basic s u p p0i r2) (run : KeygenMakeFgSource.Exec code s ⟨out,.normal⟩)
    (locals : ∀ name : Name, name≠"v".toList → out.locals name=s.locals name)
    (arrays : ∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) : Basic out u p p0i r2 := by
  have stable:=KeygenHelperStability.make _ _ _ run
  have size : out.heap.size=s.heap.size := stable.size
  have writable : out.heap.writable=s.heap.writable := stable.writable
  refine ⟨(locals _ (by decide)).trans h.nCell,(locals _ (by decide)).trans h.hnCell,
    (locals _ (by decide)).trans h.slenCell,(locals _ (by decide)).trans h.tlenCell,
    (locals _ (by decide)).trans h.uCell,(locals _ (by decide)).trans h.pCell,
    (locals _ (by decide)).trans h.iCell,(locals _ (by decide)).trans h.r2Cell,
    (locals _ (by decide)).trans h.lognCell,(locals _ (by decide)).trans h.terCell,
    (locals _ (by decide)).trans h.inCell,(locals _ (by decide)).trans h.outCell,
    (arrays _ (by decide)).trans h.fdBinding,(arrays _ (by decide)).trans h.gdBinding,
    (arrays _ (by decide)).trans h.fsBinding,(arrays _ (by decide)).trans h.gsBinding,
    (arrays _ (by decide)).trans h.gmBinding,(arrays _ (by decide)).trans h.igmBinding,
    (arrays _ (by decide)).trans h.t1Binding,(arrays _ (by decide)).trans h.primesBinding,?_,?_⟩
  · rw [writable]; exact h.writable
  · intro index bound; simpa only [Allocated,size] using h.allocated index bound

theorem prime_before (callee : State)
    (run : KeygenMakeFgSource.Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    Basic (SecondStepPrime200.after callee) 0 SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2 := by
  refine ⟨rfl,rfl,rfl,rfl,rfl,SecondStepPrime200.p_cell callee,SecondStepPrime200.i_cell callee,
    SecondStepPrime200.r2_cell callee,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,?_,?_⟩
  · rw [SecondStepPrime200.heap]; exact SecondStepStatic200.writable callee run
  · intro index bound
    rw [SecondStepPrime200.heap]
    exact SecondStepStatic200.allocated callee run index bound

end FT1536.Source3.SecondStepBasic203
