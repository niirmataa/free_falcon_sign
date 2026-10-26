import Source3.StepNttProductImage195
import Source3.StepGsProductKeep194
import Source3.StepProductLoop191
import Source3.SelectedStepAddPrime195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Concrete additional-prime products at u=1, tlen=2, hn=256.
   Their source words are the forward image of job 577/578; destination
   allocation and separation are proved at the selected layout. -/
namespace FT1536.Source3.StepAddProduct195
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open KeygenMakeFgSource (Exec)
open Word32Memory176 (Separate)
open StepCopyBody190 (addr elem)
open SelectedStepLayout187 (fd gd t1)
open SelectedStepAddPrime195 (p1 p0i1 r21)

structure Input (s : State) (W : Nat → BitVec 32) : Prop where
  image : StepNttImage195.Image s t1 W
  writable : s.heap.writable 31=true
  fdBinding : s.arrays "fd".toList=some fd
  gdBinding : s.arrays "gd".toList=some gd
  t1Binding : s.arrays "t1".toList=some t1
  hnCell : Cell s "hn".toList 256
  tlenCell : Cell s "tlen".toList 2
  uCell : Cell s "u".toList 1
  vDeclared : ∃ old, s.locals "v".toList=some (.uint64,old)
  pCell : Slot s "p" p1
  iCell : Slot s "p0i" p0i1
  rCell : Slot s "R2" r21

def fdMid (s : State) : State :=
  bindPointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
    "x".toList (addr fd 1 0 2)

theorem fd_locals (s : State) (other : Name) (different : other≠"v".toList) :
    (fdMid s).locals other=s.locals other :=
  FftLocalCells140.outside s "v".toList other (C99NatWord141.word 0) different

theorem fd_arrays (s : State) (other : Name) (different : other≠"x".toList) :
    (fdMid s).arrays other=s.arrays other :=
  StepProductFixed191.bindPointer_arrays _ _ _ _ different

theorem fd_separate (i : Fin 256) (j : Fin 512) :
    Separate (addr fd 1 i.val 2) (elem t1 j.val) := by
  change 31≠31 ∨ (0+4*(670+1+i.val*2))+4≤0+4*(3742+j.val) ∨
    (0+4*(3742+j.val))+4≤0+4*(670+1+i.val*2)
  omega

theorem fd_distinct (i j : Fin 256) (different : i≠j) :
    Separate (addr fd 1 i.val 2) (addr fd 1 j.val 2) := by
  have distinct : i.val≠j.val := fun h => different (Fin.ext h)
  change 31≠31 ∨ (0+4*(670+1+i.val*2))+4≤0+4*(670+1+j.val*2) ∨
    (0+4*(670+1+j.val*2))+4≤0+4*(670+1+i.val*2)
  omega

theorem fd_allocated (s : State) (W : Nat → BitVec 32) (input : Input s W) (i : Fin 256) :
    Allocated s.heap (addr fd 1 i.val 2) := by
  have source := StepNttFirstLoop195.load_allocated (input.image 0 (by decide))
  have lower : 0+4*71680≤s.heap.size 31 := source.2.2.2.1
  have upper : s.heap.size 31<2^64 := source.2.2.2.2
  refine ⟨by change 0<4; decide,by change 0%4=0; decide,?_,lower,upper⟩
  change 670+1+i.val*2<71680
  omega

theorem fd_init (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    Exec MakeFgProductShape191.productInit s ⟨fdMid s,.normal⟩ := by
  obtain ⟨old,vCell⟩ := input.vDeclared
  have assign : C99ModularReference.Exec
      (.assign "v".toList (.scalar (MakeFgProductShape191.num 0))) s
      ⟨FftLocalCells140.put s "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) vCell (.scalar _ _ (.literal .int32 0))
  have uAfter : Cell (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "u".toList 1 :=
    (FftLocalCells140.outside s "v".toList "u".toList (C99NatWord141.word 0) (by decide)).trans
      input.uCell
  have dstAfter : (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)).arrays
      "fd".toList=some fd := input.fdBinding
  have pointer : Pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      "fd".toList MakeFgProductShape191.varU (addr fd 1 0 2) :=
    .add _ _ fd (addr fd 1 0 2) (.uint64 (C99NatWord141.word 1)) dstAfter
      (C99LoopScalar141.read _ _ _ uAfter) (by decide)
      (C99MemoryReference.PointerAdd.within fd 1 (by decide))
  exact .level _ _ _ (.modular _ _ _
    (.seqNormal _ _ s _ ⟨fdMid s,.normal⟩ assign
      (.base _ _ _ (.bindPtr _ _ _ _ _ pointer))))

theorem fd_fixed (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    StepProductFixed191.Fixed (fdMid s) fd t1 1 2 256 p1 p0i1 r21 W := by
  refine ⟨by decide,by decide,by decide,by decide,rfl,by decide,input.writable,
    (fd_arrays s "fd".toList (by decide)).trans input.fdBinding,
    (fd_arrays s "t1".toList (by decide)).trans input.t1Binding,
    (fd_locals s "hn".toList (by decide)).trans input.hnCell,
    (fd_locals s "tlen".toList (by decide)).trans input.tlenCell,
    (fd_locals s "p".toList (by decide)).trans input.pCell,
    (fd_locals s "p0i".toList (by decide)).trans input.iCell,
    (fd_locals s "R2".toList (by decide)).trans input.rCell,
    fd_allocated s W input,fd_separate,fd_distinct,?_⟩
  intro i
  exact input.image i.val i.isLt

/-- Literal product reads consumed before the complete loop. -/
theorem fd_reads (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    C99ModularReference.Eval (fdMid s) (MakeFgProductShape191.readT1 0) (.uint32 (W 0)) ∧
    C99ModularReference.Eval (fdMid s) (MakeFgProductShape191.readT1 1) (.uint32 (W 1)) :=
  StepNttProductImage195.product_reads (out:=fdMid s) input.image rfl 0 (by decide)
    ((fd_arrays s "t1".toList (by decide)).trans input.t1Binding)
    (FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0))

theorem fd_source (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    ∃ out, Exec MakeFgAddPrimeShape194.productFd s ⟨out,.normal⟩ ∧
      StepProductFixed191.Image out fd 1 2 256 p1 p0i1 r21 W 256 ∧
      StepNttImage195.Image out t1 W ∧ Cell out "v".toList 256 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) := by
  have zero : Cell (fdMid s) "v".toList 0 :=
    FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)
  have empty := StepProductFixed191.empty_image (fdMid s) fd 1 2 256 p1 p0i1 r21 W
  obtain ⟨out,run,fixed,vCell,xCell,image,locals,arrays⟩ :=
    StepProductLoop191.source (fdMid s) fd t1 1 2 256 p1 p0i1 r21 W
      (fd_fixed s W input) zero rfl empty
  have sourceImage : StepNttImage195.Image out t1 W := fun j bound => fixed.src ⟨j,bound⟩
  refine ⟨out,?_,image,sourceImage,vCell,?_,?_⟩
  · rw [(StepNttProductImage195.product_shapes).1]
    exact .seqNormal _ _ s (fdMid s) ⟨out,.normal⟩ (fd_init s W input) run
  · intro name different
    exact (locals name different).trans (fd_locals s name different)
  · intro name different
    exact (arrays name different).trans (fd_arrays s name different)

def gdMid (s : State) : State :=
  bindPointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
    "x".toList (addr gd 1 0 2)

theorem gd_locals (s : State) (other : Name) (different : other≠"v".toList) :
    (gdMid s).locals other=s.locals other :=
  FftLocalCells140.outside s "v".toList other (C99NatWord141.word 0) different

theorem gd_arrays (s : State) (other : Name) (different : other≠"x".toList) :
    (gdMid s).arrays other=s.arrays other :=
  StepProductFixed191.bindPointer_arrays _ _ _ _ different

theorem gd_separate (i : Fin 256) (j : Fin 512) :
    Separate (addr gd 1 i.val 2) (elem t1 j.val) := by
  change 31≠31 ∨ (0+4*(1182+1+i.val*2))+4≤0+4*(3742+j.val) ∨
    (0+4*(3742+j.val))+4≤0+4*(1182+1+i.val*2)
  omega

theorem gd_distinct (i j : Fin 256) (different : i≠j) :
    Separate (addr gd 1 i.val 2) (addr gd 1 j.val 2) := by
  have distinct : i.val≠j.val := fun h => different (Fin.ext h)
  change 31≠31 ∨ (0+4*(1182+1+i.val*2))+4≤0+4*(1182+1+j.val*2) ∨
    (0+4*(1182+1+j.val*2))+4≤0+4*(1182+1+i.val*2)
  omega

theorem gd_allocated (s : State) (W : Nat → BitVec 32) (input : Input s W) (i : Fin 256) :
    Allocated s.heap (addr gd 1 i.val 2) := by
  have source := StepNttFirstLoop195.load_allocated (input.image 0 (by decide))
  have lower : 0+4*71680≤s.heap.size 31 := source.2.2.2.1
  have upper : s.heap.size 31<2^64 := source.2.2.2.2
  refine ⟨by change 0<4; decide,by change 0%4=0; decide,?_,lower,upper⟩
  change 1182+1+i.val*2<71680
  omega

theorem gd_init (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    Exec MakeFgGsShape194.productInitGd s ⟨gdMid s,.normal⟩ := by
  obtain ⟨old,vCell⟩ := input.vDeclared
  have assign : C99ModularReference.Exec
      (.assign "v".toList (.scalar (MakeFgProductShape191.num 0))) s
      ⟨FftLocalCells140.put s "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) vCell (.scalar _ _ (.literal .int32 0))
  have uAfter : Cell (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "u".toList 1 :=
    (FftLocalCells140.outside s "v".toList "u".toList (C99NatWord141.word 0) (by decide)).trans
      input.uCell
  have dstAfter : (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)).arrays
      "gd".toList=some gd := input.gdBinding
  have pointer : Pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      "gd".toList MakeFgProductShape191.varU (addr gd 1 0 2) :=
    .add _ _ gd (addr gd 1 0 2) (.uint64 (C99NatWord141.word 1)) dstAfter
      (C99LoopScalar141.read _ _ _ uAfter) (by decide)
      (C99MemoryReference.PointerAdd.within gd 1 (by decide))
  exact .level _ _ _ (.modular _ _ _
    (.seqNormal _ _ s _ ⟨gdMid s,.normal⟩ assign
      (.base _ _ _ (.bindPtr _ _ _ _ _ pointer))))

theorem gd_fixed (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    StepGsProductKeep194.FixedGd (gdMid s) gd t1 1 2 256 p1 p0i1 r21 W := by
  refine ⟨by decide,by decide,by decide,by decide,rfl,by decide,input.writable,
    (gd_arrays s "gd".toList (by decide)).trans input.gdBinding,
    (gd_arrays s "t1".toList (by decide)).trans input.t1Binding,
    (gd_locals s "hn".toList (by decide)).trans input.hnCell,
    (gd_locals s "tlen".toList (by decide)).trans input.tlenCell,
    (gd_locals s "p".toList (by decide)).trans input.pCell,
    (gd_locals s "p0i".toList (by decide)).trans input.iCell,
    (gd_locals s "R2".toList (by decide)).trans input.rCell,
    gd_allocated s W input,gd_separate,gd_distinct,?_⟩
  intro i
  exact input.image i.val i.isLt

/-- Literal product reads consumed before the complete loop. -/
theorem gd_reads (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    C99ModularReference.Eval (gdMid s) (MakeFgProductShape191.readT1 0) (.uint32 (W 0)) ∧
    C99ModularReference.Eval (gdMid s) (MakeFgProductShape191.readT1 1) (.uint32 (W 1)) :=
  StepNttProductImage195.product_reads (out:=gdMid s) input.image rfl 0 (by decide)
    ((gd_arrays s "t1".toList (by decide)).trans input.t1Binding)
    (FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0))

theorem gd_source (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    ∃ out, Exec MakeFgAddPrimeShape194.productGd s ⟨out,.normal⟩ ∧
      StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21 W 256 ∧
      StepNttImage195.Image out t1 W ∧ Cell out "v".toList 256 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) := by
  have zero : Cell (gdMid s) "v".toList 0 :=
    FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)
  have empty := StepProductFixed191.empty_image (gdMid s) gd 1 2 256 p1 p0i1 r21 W
  have reads : StepCopyKeep193.Reads (gdMid s) t1 512 W := fun j bound => input.image j bound
  have separate : ∀ i : Fin 256, ∀ k : Nat, k<512 →
      Separate (addr gd 1 i.val 2) ({t1 with index := t1.index+k}) :=
    fun i k bound => gd_separate i ⟨k,bound⟩
  obtain ⟨out,run,fixed,vCell,xCell,image,locals,arrays,keepA,keepB⟩ :=
    StepGsProductKeep194.source (gdMid s) gd t1 1 2 256 p1 p0i1 r21 W
      (gd_fixed s W input) zero rfl empty t1 512 W reads separate t1 512 W reads separate
  have sourceImage : StepNttImage195.Image out t1 W := fun j bound => fixed.src ⟨j,bound⟩
  refine ⟨out,?_,image,sourceImage,vCell,?_,?_⟩
  · rw [(StepNttProductImage195.product_shapes).2]
    exact .seqNormal _ _ s (gdMid s) ⟨out,.normal⟩ (gd_init s W input) run
  · intro name different
    exact (locals name different).trans (gd_locals s name different)
  · intro name different
    exact (arrays name different).trans (gd_arrays s name different)

end FT1536.Source3.StepAddProduct195
