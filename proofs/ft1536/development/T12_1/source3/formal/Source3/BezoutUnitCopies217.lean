import Source3.BezoutUnitY217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual two unit-case copies in the selected workspace geometry. -/
namespace FT1536.Source3.BezoutUnitCopies217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99MemoryReference (Allocated)
open KeygenZintCall (Exec)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open DeepestBezoutEntry217 (Fp Gp)
open DeepestSelectedCrt217 (tmp)
open BezoutPointerSetup217 (v1)
open ZintNormWalkFlat208 (Data)

def middle (s : State) (ny : Nat) := BezoutCopySource217.after s Gp tmp ny
def after (s : State) (nx ny : Nat) := BezoutCopySource217.after (middle s ny) Fp v1 nx

structure Input (s : State) (nx ny : Nat) (U V : Nat → BitVec 32) : Prop where
  nxBound : nx≤335
  nyBound : ny≤335
  xc : Cell s "xlen".toList nx
  yc : Cell s "ylen".toList ny
  ub : s.arrays "u".toList=some Gp
  vb : s.arrays "v".toList=some Fp
  u1b : s.arrays "u1".toList=some tmp
  v1b : s.arrays "v1".toList=some v1
  ud : Data s tmp ny U
  vd : Data s v1 nx V
  extent : 4*71680≤s.heap.size 31
  size : s.heap.size 31<2^64
  writable : s.heap.writable 31=true

theorem source (s : State) (nx ny : Nat) (U V : Nat → BitVec 32) (h : Input s nx ny U V) :
    Exec BezoutUnitY217.first s ⟨middle s ny,.normal⟩ ∧
    Exec BezoutUnitY217.second (middle s ny) ⟨after s nx ny,.normal⟩ ∧
    Data (after s nx ny) Gp ny U ∧ Data (after s nx ny) Fp nx V := by
  have drU : Gp.offset+4*ny≤Gp.base+Gp.elementBytes*Gp.count := by change 4*335+4*ny≤4*71680; have q:=h.nyBound; omega
  have srU : tmp.offset+4*ny≤tmp.base+tmp.elementBytes*tmp.count := by change 4*1340+4*ny≤4*71680; have q:=h.nyBound; omega
  have objU : Gp.base+Gp.elementBytes*Gp.count≤s.heap.size Gp.block := by change 4*71680≤s.heap.size 31; exact h.extent
  have objS : tmp.base+tmp.elementBytes*tmp.count≤s.heap.size tmp.block := by change 4*71680≤s.heap.size 31; exact h.extent
  have apartU : Gp.block≠tmp.block ∨ Gp.offset+4*ny≤tmp.offset ∨ tmp.offset+4*ny≤Gp.offset := by
    right; left; change 4*335+4*ny≤4*1340; have q:=h.nyBound; omega
  have runU := BezoutCopySource217.source s "u" "u1" "ylen" Gp tmp ny h.nyBound h.ub h.u1b h.yc
    drU srU objU objS h.size h.size h.writable rfl rfl h.ud apartU
  have vd : Data (middle s ny) v1 nx V := by
    intro i ib
    apply BezoutCopyFrame217.outside s.heap Gp tmp (elem v1 i) (4*ny) (V i) ?_ (h.vd i ib)
    right; right; change 0+4*335+4*ny≤0+4*(1675+i); have q:=h.nyBound; omega
  have drV : Fp.offset+4*nx≤Fp.base+Fp.elementBytes*Fp.count := by change 4*0+4*nx≤4*71680; have q:=h.nxBound; omega
  have srV : v1.offset+4*nx≤v1.base+v1.elementBytes*v1.count := by change 4*1675+4*nx≤4*71680; have q:=h.nxBound; omega
  have objV : Fp.base+Fp.elementBytes*Fp.count≤(middle s ny).heap.size Fp.block := by change 4*71680≤s.heap.size 31; exact h.extent
  have objT : v1.base+v1.elementBytes*v1.count≤(middle s ny).heap.size v1.block := by change 4*71680≤s.heap.size 31; exact h.extent
  have apartV : Fp.block≠v1.block ∨ Fp.offset+4*nx≤v1.offset ∨ v1.offset+4*nx≤Fp.offset := by
    right; left; change 4*0+4*nx≤4*1675; have q:=h.nxBound; omega
  have runV := BezoutCopySource217.source (middle s ny) "v" "v1" "xlen" Fp v1 nx h.nxBound h.vb h.v1b h.xc
    drV srV objV objT h.size h.size h.writable rfl rfl vd apartV
  have umid : Data (middle s ny) Gp ny U := by
    intro i ib
    have alloc : Allocated (middle s ny).heap (element Gp i) := by
      change Allocated (middle s ny).heap (element ⟨31,0,71680,4,335⟩ i)
      exact BezoutInitCopies217.allocated_at _ 335 i h.extent h.size (by have q:=h.nyBound; omega)
    exact BezoutCopyFrame217.copied s.heap Gp tmp ny i (U i) drU srU objU objS h.size h.size h.writable rfl rfl
      (fun j jb => ⟨U j,h.ud j jb⟩) ib alloc (h.ud i ib)
  have ufinal : Data (after s nx ny) Gp ny U := by
    intro i ib
    apply BezoutCopyFrame217.outside (middle s ny).heap Fp v1 (elem Gp i) (4*nx) (U i) ?_ (umid i ib)
    right; right; change 0+4*0+4*nx≤0+4*(335+i); have q:=h.nxBound; omega
  have vfinal : Data (after s nx ny) Fp nx V := by
    intro i ib
    have alloc : Allocated (after s nx ny).heap (element Fp i) := by
      rw [BezoutInitZeroImages217.Fp_shape]
      exact BezoutInitCopies217.allocated_at _ 0 i h.extent h.size (by have q:=h.nxBound; omega)
    exact BezoutCopyFrame217.copied (middle s ny).heap Fp v1 nx i (V i) drV srV objV objT h.size h.size h.writable rfl rfl
      (fun j jb => ⟨V j,vd j jb⟩) ib alloc (vd i ib)
  exact ⟨runU,runV,ufinal,vfinal⟩

end FT1536.Source3.BezoutUnitCopies217
