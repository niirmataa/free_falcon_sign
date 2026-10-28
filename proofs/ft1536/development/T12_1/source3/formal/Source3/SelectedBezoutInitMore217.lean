import Source3.BezoutInitMoreFrame217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Selected good branch through u1/v1 copies and v1 low-bit update. -/
namespace FT1536.Source3.SelectedBezoutInitMore217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99MemoryReference (Load32)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b v1)
open DeepestSelectedCrt217 (tmp)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)

def code : KeygenZintCall.Stmt := .seq SelectedBezoutInitZero217.code BezoutInitMore217.code
noncomputable def after (rebuilt : State) (F G : Nat → BitVec 32) :=
  BezoutInitMore217.after (SelectedBezoutInitZero217.after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335) (X F G)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → KeygenZintCall.Exec code (state rebuilt F G) ⟨after rebuilt F G,.normal⟩ ∧
      Load32 (after rebuilt F G).heap Gp 1 ∧
      Data (after rebuilt F G) BezoutInitZero217.firstPtr (highest (Y F G) 335-1) (fun _ => 0) ∧
      Data (after rebuilt F G) Fp (highest (X F G) 335) (fun _ => 0) ∧
      Data (after rebuilt F G) fd 335 (X F G) ∧ Data (after rebuilt F G) gd 335 (Y F G) ∧
      Data (after rebuilt F G) a (highest (X F G) 335) (X F G) ∧ Data (after rebuilt F G) b (highest (Y F G) 335) (Y F G) ∧
      Data (after rebuilt F G) tmp (highest (Y F G) 335) (Y F G) ∧
      Data (after rebuilt F G) v1 (highest (X F G) 335) (BezoutInitLowBit217.image (X F G))) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutInitZeroImage217.selected
  let s := state rebuilt F G
  let fin := SelectedBezoutInitCopies217.finish rebuilt F G
  let stored := SelectedBezoutInitStore217.after rebuilt F G
  let zeroed := SelectedBezoutInitZero217.after rebuilt F G
  let nx := highest (X F G) 335
  let ny := highest (Y F G) 335
  have nxBound : nx≤335 := ExactLengthProgram217.highest_le _ _
  have nyBound : ny≤335 := ExactLengthProgram217.highest_le _ _
  have initExtent : 4*71680≤SelectedDeepestConfig175.after.heap.size 31 := by
    change 4*71680≤SelectedMakeFgSetup176.after.heap.size 31; exact SelectedMakeFgDomains176.extent
  have initSize : SelectedDeepestConfig175.after.heap.size 31<2^64 := by
    change SelectedMakeFgSetup176.after.heap.size 31<2^64; exact SelectedMakeFgDomains176.size_bound
  have initWritable : SelectedDeepestConfig175.after.heap.writable 31=true := by
    change SelectedMakeFgSetup176.after.heap.writable 31=true; exact SelectedMakeFgDomains176.writable
  have stable := KeygenMemoryStability.trans _ _ _ (KeygenSearchStability.deepest env.ctx _ _ _ part2) (KeygenSearchStability.deepest env.ctx _ _ _ crt)
  have sameHeap : s.heap=rebuilt.heap := (BezoutLengthCells217.heap _ _ _).trans (BezoutPointerSetup217.heap rebuilt)
  have finSize : fin.heap.size=s.heap.size := rfl
  have finWrite : fin.heap.writable=s.heap.writable := rfl
  have storeSize : stored.heap.size=fin.heap.size := BezoutInitStoreFrame217.size fin nx ny
  have storeWrite : stored.heap.writable=fin.heap.writable := BezoutInitStoreFrame217.writable fin nx ny
  have zeroSize : zeroed.heap.size=stored.heap.size := BezoutInitMoreFrame217.zero_size stored nx ny
  have zeroWrite : zeroed.heap.writable=stored.heap.writable := BezoutInitMoreFrame217.zero_writable stored nx ny
  have extent : 4*71680≤zeroed.heap.size 31 := by rw [zeroSize,storeSize,finSize,sameHeap,stable.size]; exact initExtent
  have size : zeroed.heap.size 31<2^64 := by rw [zeroSize,storeSize,finSize,sameHeap,stable.size]; exact initSize
  have writable : zeroed.heap.writable 31=true := by rw [zeroWrite,storeWrite,finWrite,sameHeap,stable.writable]; exact initWritable
  have xBefore : Cell fin "xlen".toList nx := BezoutLengthCells217.xcell (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)
  have yBefore : Cell fin "ylen".toList ny := BezoutLengthCells217.ycell (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)
  have xc : Cell zeroed "xlen".toList nx := BezoutInitStoreFrame217.xlen fin nx ny xBefore
  have yc : Cell zeroed "ylen".toList ny := BezoutInitStoreFrame217.ylen fin nx ny yBefore
  have u1 : zeroed.arrays "u1".toList=some tmp := BezoutInitMoreFrame217.u1_binding rebuilt
  have v1b : zeroed.arrays "v1".toList=some v1 := BezoutInitMoreFrame217.v1_binding rebuilt
  have xb : zeroed.arrays "x".toList=some fd := BezoutPointerSetup217.x_binding rebuilt
  have yb : zeroed.arrays "y".toList=some gd := BezoutPointerSetup217.y_binding rebuilt
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨pre,one,zeroU,zeroV,xf,yf,af,bf⟩:=prior good
  have nz : nx≠0 := (SelectedBezoutOutcome217.good_constraints F G good).1
  have positive : 0<nx := Nat.pos_of_ne_zero nz
  have input : BezoutInitMoreCopies217.Input zeroed nx ny (X F G) (Y F G) :=
    ⟨nxBound,nyBound,xc,yc,u1,v1b,xb,yb,xf,yf,extent,size,writable⟩
  obtain ⟨moreRun,xafter,yafter,uafter,vafter⟩:=BezoutInitMore217.source zeroed nx ny _ _ input positive
  have sepU0 : ∀ i<ny-1, (StepCopyBody190.elem BezoutInitZero217.firstPtr i).block≠tmp.block ∨ (StepCopyBody190.elem BezoutInitZero217.firstPtr i).offset+4≤tmp.offset ∨ tmp.offset+4*ny≤(StepCopyBody190.elem BezoutInitZero217.firstPtr i).offset := by
    intro i ib; right; left; change 0+4*(336+i)+4≤0+4*1340; omega
  have sepV0 : ∀ i<nx, (StepCopyBody190.elem Fp i).block≠tmp.block ∨ (StepCopyBody190.elem Fp i).offset+4≤tmp.offset ∨ tmp.offset+4*ny≤(StepCopyBody190.elem Fp i).offset := by
    intro i ib; right; left; change 0+4*(0+i)+4≤0+4*1340; omega
  have sepA : ∀ i<nx, (StepCopyBody190.elem a i).block≠tmp.block ∨ (StepCopyBody190.elem a i).offset+4≤tmp.offset ∨ tmp.offset+4*ny≤(StepCopyBody190.elem a i).offset := by
    intro i ib; right; right; change 0+4*1340+4*ny≤0+4*(2010+i); omega
  have sepB : ∀ i<ny, (StepCopyBody190.elem b i).block≠tmp.block ∨ (StepCopyBody190.elem b i).offset+4≤tmp.offset ∨ tmp.offset+4*ny≤(StepCopyBody190.elem b i).offset := by
    intro i ib; right; right; change 0+4*1340+4*ny≤0+4*(2345+i); omega
  have sepU0V : ∀ i<ny-1, (StepCopyBody190.elem BezoutInitZero217.firstPtr i).block≠v1.block ∨ (StepCopyBody190.elem BezoutInitZero217.firstPtr i).offset+4≤v1.offset ∨ v1.offset+4*nx≤(StepCopyBody190.elem BezoutInitZero217.firstPtr i).offset := by
    intro i ib; right; left; change 0+4*(336+i)+4≤0+4*1675; omega
  have sepV0V : ∀ i<nx, (StepCopyBody190.elem Fp i).block≠v1.block ∨ (StepCopyBody190.elem Fp i).offset+4≤v1.offset ∨ v1.offset+4*nx≤(StepCopyBody190.elem Fp i).offset := by
    intro i ib; right; left; change 0+4*(0+i)+4≤0+4*1675; omega
  have sepAV : ∀ i<nx, (StepCopyBody190.elem a i).block≠v1.block ∨ (StepCopyBody190.elem a i).offset+4≤v1.offset ∨ v1.offset+4*nx≤(StepCopyBody190.elem a i).offset := by
    intro i ib; right; right; change 0+4*1675+4*nx≤0+4*(2010+i); omega
  have sepBV : ∀ i<ny, (StepCopyBody190.elem b i).block≠v1.block ∨ (StepCopyBody190.elem b i).offset+4≤v1.offset ∨ v1.offset+4*nx≤(StepCopyBody190.elem b i).offset := by
    intro i ib; right; right; change 0+4*1675+4*nx≤0+4*(2345+i); omega
  have sepU0Word : ∀ i<ny-1, Word32Memory176.Separate v1 (StepCopyBody190.elem BezoutInitZero217.firstPtr i) := by
    intro i ib; right; right; change 0+4*(336+i)+4≤0+4*1675; omega
  have sepV0Word : ∀ i<nx, Word32Memory176.Separate v1 (StepCopyBody190.elem Fp i) := by
    intro i ib; right; right; change 0+4*(0+i)+4≤0+4*1675; omega
  have sepAWord : ∀ i<nx, Word32Memory176.Separate v1 (StepCopyBody190.elem a i) := by
    intro i ib; right; left; change 0+4*1675+4≤0+4*(2010+i); omega
  have sepBWord : ∀ i<ny, Word32Memory176.Separate v1 (StepCopyBody190.elem b i) := by
    intro i ib; right; left; change 0+4*1675+4≤0+4*(2345+i); omega
  have readU : Load32 (BezoutInitMoreCopies217.middle zeroed ny).heap Gp 1 :=
    BezoutCopyFrame217.outside zeroed.heap tmp gd Gp (4*ny) 1
      (by right; left; change 0+4*335+4≤0+4*1340; decide) one
  have readV : Load32 (BezoutInitMoreCopies217.after zeroed nx ny).heap Gp 1 :=
    BezoutCopyFrame217.outside (BezoutInitMoreCopies217.middle zeroed ny).heap v1 fd Gp (4*nx) 1
      (by right; left; change 0+4*335+4≤0+4*1675; decide) readU
  have oneAfter : Load32 (after rebuilt F G).heap Gp 1 :=
    Word32Memory176.outside _ v1 Gp _ 1 (by right; right; change 0+4*335+4≤0+4*1675; decide) readV
  exact ⟨.seqNormal _ _ _ _ _ pre moreRun,oneAfter,
    BezoutInitMore217.keep_data zeroed nx ny _ _ _ _ zeroU sepU0 sepU0V sepU0Word,
    BezoutInitMore217.keep_data zeroed nx ny _ _ _ _ zeroV sepV0 sepV0V sepV0Word,
    xafter,yafter,
    BezoutInitMore217.keep_data zeroed nx ny _ _ _ _ af sepA sepAV sepAWord,
    BezoutInitMore217.keep_data zeroed nx ny _ _ _ _ bf sepB sepBV sepBWord,uafter,vafter⟩

end FT1536.Source3.SelectedBezoutInitMore217
