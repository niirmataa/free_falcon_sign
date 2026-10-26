import Source3.StepAddEntry195
import Source3.StepAddForwardProduct195
import Source3.StepWalkKeep195
import Source3.StepAddProductKeep195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepAddBasic195
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open SelectedStepLayout187 (fd gd fs gs gm igm t1)
open KeygenFullData127 (primes)
open SelectedStepAddPrime195 (p1 p0i1 r21 rx1)
open StepCopyBody190 (addr elem)

structure Basic (s : State) : Prop where
  tables : s.tables=(C99CompactState115.reference KeygenFullData127.base).tables
  outside : C99ArrayFrame.Outside s KeygenMakeFgSource.writable 0 0
  writable : s.heap.writable 31=true
  allocated : ∀ i : Nat, i<71680 → Allocated s.heap {KeygenFullData127.env.ctx.scratch with index:=i}
  nCell : Cell s "n".toList 512
  hnCell : Cell s "hn".toList 256
  slenCell : Cell s "slen".toList 1
  tlenCell : Cell s "tlen".toList 2
  uCell : Cell s "u".toList 1
  pSlot : Slot s "p" p1
  p0iSlot : Slot s "p0i" p0i1
  R2Slot : Slot s "R2" r21
  RxSlot : Slot s "Rx" rx1
  lognSlot : Slot s "logn" 9
  terSlot : Slot s "ter" 1
  outCell : s.locals "out_ntt".toList=some (.int32,some (.int32 1))
  vDeclared : ∃ old, s.locals "v".toList=some (.uint64,old)
  fdBinding : s.arrays "fd".toList=some fd
  gdBinding : s.arrays "gd".toList=some gd
  fsBinding : s.arrays "fs".toList=some fs
  gsBinding : s.arrays "gs".toList=some gs
  gmBinding : s.arrays "gm".toList=some gm
  igmBinding : s.arrays "igm".toList=some igm
  t1Binding : s.arrays "t1".toList=some t1
  primesBinding : s.arrays "primes".toList=some primes

theorem transport {s out : State} {code : KeygenMakeFgSource.Stmt} (input : Basic s)
    (run : KeygenMakeFgSource.Exec code s ⟨out,.normal⟩)
    (checked : KeygenMakeFgSource.only KeygenMakeFgSource.writable code=true)
    (locals : ∀ name : Name, name≠"v".toList → out.locals name=s.locals name)
    (arrays : ∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name)
    (vDeclared : ∃ old, out.locals "v".toList=some (.uint64,old)) : Basic out := by
  have stable := KeygenHelperStability.make _ _ _ run
  have frame := KeygenMakeFgSource.frame _ _ _ run KeygenMakeFgSource.writable checked 0 0
    input.outside (StepAddEntry195.tables_zero s input.tables)
  refine ⟨frame.2.1.trans input.tables,frame.1,?_,?_,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_,vDeclared,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ⟩
  · rw [stable.writable]; exact input.writable
  · intro i bound
    unfold Allocated
    rw [stable.size]
    exact input.allocated i bound
  · exact (locals "n".toList (by decide)).trans input.nCell
  · exact (locals "hn".toList (by decide)).trans input.hnCell
  · exact (locals "slen".toList (by decide)).trans input.slenCell
  · exact (locals "tlen".toList (by decide)).trans input.tlenCell
  · exact (locals "u".toList (by decide)).trans input.uCell
  · exact (locals "p".toList (by decide)).trans input.pSlot
  · exact (locals "p0i".toList (by decide)).trans input.p0iSlot
  · exact (locals "R2".toList (by decide)).trans input.R2Slot
  · exact (locals "Rx".toList (by decide)).trans input.RxSlot
  · exact (locals "logn".toList (by decide)).trans input.lognSlot
  · exact (locals "ter".toList (by decide)).trans input.terSlot
  · exact (locals "out_ntt".toList (by decide)).trans input.outCell
  · exact (arrays "fd".toList (by decide)).trans input.fdBinding
  · exact (arrays "gd".toList (by decide)).trans input.gdBinding
  · exact (arrays "fs".toList (by decide)).trans input.fsBinding
  · exact (arrays "gs".toList (by decide)).trans input.gsBinding
  · exact (arrays "gm".toList (by decide)).trans input.gmBinding
  · exact (arrays "igm".toList (by decide)).trans input.igmBinding
  · exact (arrays "t1".toList (by decide)).trans input.t1Binding
  · exact (arrays "primes".toList (by decide)).trans input.primesBinding

theorem product_input {s : State} (b : Basic s) (W : Nat → BitVec 32)
    (image : StepNttImage195.Image s t1 W) : StepAddProduct195.Input s W :=
  ⟨image,b.writable,b.fdBinding,b.gdBinding,b.t1Binding,b.hnCell,b.tlenCell,b.uCell,b.vDeclared,
    b.pSlot,b.p0iSlot,b.R2Slot⟩

/-- Literal march word family, observed below 512. -/
def marchWords (F : Fin 512 → BitVec 32) (j : Nat) : BitVec 32 :=
  ZintModSignedWord194.modSignedWord (F ⟨j%512,Nat.mod_lt _ (by decide)⟩) p1 p0i1 r21 rx1

theorem march_word (F : Fin 512 → BitVec 32) (i : Fin 512) :
    marchWords F i.val=ZintModSignedWord194.modSignedWord (F i) p1 p0i1 r21 rx1 := by
  have equal : (⟨i.val%512,Nat.mod_lt _ (by decide)⟩ : Fin 512)=i :=
    Fin.ext (Nat.mod_eq_of_lt i.isLt)
  simp only [marchWords,equal]

theorem fs_fixed (s : State) (b : Basic s) (F : Fin 512 → BitVec 32)
    (loads : ∀ i : Fin 512, Load32 s.heap (elem fs i.val) (F i)) :
    StepWalkFixed195.Fixed s "fs".toList fs t1 512 F p1 p0i1 r21 rx1 := by
  refine ⟨by decide,rfl,rfl,by decide,by decide,b.writable,by decide,b.fsBinding,
    b.t1Binding,b.nCell,b.slenCell,b.pSlot,b.p0iSlot,b.R2Slot,b.RxSlot,?_,?_,?_,?_⟩
  · intro i
    exact b.allocated (3742+i.val) (by omega)
  · intro i j
    change 31≠31 ∨ (0+4*(3742+i.val))+4≤0+4*(1694+0+j.val*1) ∨
      (0+4*(1694+0+j.val*1))+4≤0+4*(3742+i.val)
    omega
  · intro i j different
    have distinct : i.val≠j.val := fun h => different (Fin.ext h)
    change 31≠31 ∨ (0+4*(3742+i.val))+4≤0+4*(3742+j.val) ∨
      (0+4*(3742+j.val))+4≤0+4*(3742+i.val)
    omega
  · intro i
    simpa only [addr,elem,Nat.mul_one,Nat.add_zero] using loads i


theorem gs_fixed (s : State) (b : Basic s) (F : Fin 512 → BitVec 32)
    (loads : ∀ i : Fin 512, Load32 s.heap (elem gs i.val) (F i)) :
    StepWalkFixed195.Fixed s "gs".toList gs t1 512 F p1 p0i1 r21 rx1 := by
  refine ⟨by decide,rfl,rfl,by decide,by decide,b.writable,by decide,b.gsBinding,
    b.t1Binding,b.nCell,b.slenCell,b.pSlot,b.p0iSlot,b.R2Slot,b.RxSlot,?_,?_,?_,?_⟩
  · intro i
    exact b.allocated (3742+i.val) (by omega)
  · intro i j
    change 31≠31 ∨ (0+4*(3742+i.val))+4≤0+4*(2206+0+j.val*1) ∨
      (0+4*(2206+0+j.val*1))+4≤0+4*(3742+i.val)
    omega
  · intro i j different
    have distinct : i.val≠j.val := fun h => different (Fin.ext h)
    change 31≠31 ∨ (0+4*(3742+i.val))+4≤0+4*(3742+j.val) ∨
      (0+4*(3742+j.val))+4≤0+4*(3742+i.val)
    omega
  · intro i
    simpa only [addr,elem,Nat.mul_one,Nat.add_zero] using loads i


end FT1536.Source3.StepAddBasic195
