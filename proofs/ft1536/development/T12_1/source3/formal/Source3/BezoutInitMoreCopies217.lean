import Source3.SelectedBezoutInitZeroImage217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original u1<-y and v1<-x initialization copies at selected geometry. -/
namespace FT1536.Source3.BezoutInitMoreCopies217
open C99ArrayReference (State)
open C99MemoryReference (Allocated Load32)
open C99LoopScalar141 (Cell)
open KeygenZintCall (Exec Stmt)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open NinthStepLayout217 (fd gd)
open DeepestSelectedCrt217 (tmp)
open BezoutPointerSetup217 (v1)
open ZintNormWalkFlat208 (Data)

def first : Stmt := BezoutCopySource217.copy "u1" "y" "ylen"
def second : Stmt := BezoutCopySource217.copy "v1" "x" "xlen"
def tail : Stmt := match BezoutInitZero217.tail with | .seq _ (.seq _ rest) => rest | _ => KeygenZintCall.skip
def middle (s : State) (ny : Nat) := BezoutCopySource217.after s tmp gd ny
def after (s : State) (nx ny : Nat) := BezoutCopySource217.after (middle s ny) v1 fd nx

theorem shape : BezoutInitZero217.tail=.seq first (.seq second tail) := by decide
theorem tmp_shape : tmp=⟨31,0,71680,4,1340⟩ := rfl
theorem v1_shape : v1=⟨31,0,71680,4,1675⟩ := rfl

structure Input (s : State) (nx ny : Nat) (X Y : Nat → BitVec 32) : Prop where
  nxBound : nx≤335
  nyBound : ny≤335
  xlen : Cell s "xlen".toList nx
  ylen : Cell s "ylen".toList ny
  u1Binding : s.arrays "u1".toList=some tmp
  v1Binding : s.arrays "v1".toList=some v1
  xBinding : s.arrays "x".toList=some fd
  yBinding : s.arrays "y".toList=some gd
  xData : Data s fd 335 X
  yData : Data s gd 335 Y
  extent : 4*71680≤s.heap.size 31
  size : s.heap.size 31<2^64
  writable : s.heap.writable 31=true

theorem source (s : State) (nx ny : Nat) (X Y : Nat → BitVec 32) (h : Input s nx ny X Y) :
    Exec first s ⟨middle s ny,.normal⟩ ∧ Exec second (middle s ny) ⟨after s nx ny,.normal⟩ ∧
    Data (after s nx ny) fd 335 X ∧ Data (after s nx ny) gd 335 Y ∧
    Data (after s nx ny) tmp ny Y ∧ Data (after s nx ny) v1 nx X := by
  have drU : tmp.offset+4*ny≤tmp.base+tmp.elementBytes*tmp.count := by change 4*1340+4*ny≤4*71680; have q:=h.nyBound; omega
  have srY : gd.offset+4*ny≤gd.base+gd.elementBytes*gd.count := by change 4*1005+4*ny≤4*71680; have q:=h.nyBound; omega
  have objU : tmp.base+tmp.elementBytes*tmp.count≤s.heap.size tmp.block := by change 4*71680≤s.heap.size 31; exact h.extent
  have objY : gd.base+gd.elementBytes*gd.count≤s.heap.size gd.block := by change 4*71680≤s.heap.size 31; exact h.extent
  have apartU : tmp.block≠gd.block ∨ tmp.offset+4*ny≤gd.offset ∨ gd.offset+4*ny≤tmp.offset := by
    right; right; change 4*1005+4*ny≤4*1340; have q:=h.nyBound; omega
  have yp : Data s gd ny Y := by intro i bound; exact h.yData i (by have q:=h.nyBound; omega)
  have runU := BezoutCopySource217.source s "u1" "y" "ylen" tmp gd ny h.nyBound h.u1Binding h.yBinding h.ylen
    drU srY objU objY h.size h.size h.writable rfl rfl yp apartU
  have xAtU : Data (middle s ny) fd 335 X := by
    intro i bound
    apply BezoutCopyFrame217.outside s.heap tmp gd (elem fd i) (4*ny) (X i) ?_ (h.xData i bound)
    right; left; change 0+4*(670+i)+4≤0+4*1340; omega
  have yAtU : Data (middle s ny) gd 335 Y := by
    intro i bound
    apply BezoutCopyFrame217.outside s.heap tmp gd (elem gd i) (4*ny) (Y i) ?_ (h.yData i bound)
    right; left; change 0+4*(1005+i)+4≤0+4*1340; omega
  have extentU : 4*71680≤(middle s ny).heap.size 31 := h.extent
  have sizeU : (middle s ny).heap.size 31<2^64 := h.size
  have writableU : (middle s ny).heap.writable 31=true := h.writable
  have drV : v1.offset+4*nx≤v1.base+v1.elementBytes*v1.count := by change 4*1675+4*nx≤4*71680; have q:=h.nxBound; omega
  have srX : fd.offset+4*nx≤fd.base+fd.elementBytes*fd.count := by change 4*670+4*nx≤4*71680; have q:=h.nxBound; omega
  have objV : v1.base+v1.elementBytes*v1.count≤(middle s ny).heap.size v1.block := by change 4*71680≤(middle s ny).heap.size 31; exact extentU
  have objX : fd.base+fd.elementBytes*fd.count≤(middle s ny).heap.size fd.block := by change 4*71680≤(middle s ny).heap.size 31; exact extentU
  have apartV : v1.block≠fd.block ∨ v1.offset+4*nx≤fd.offset ∨ fd.offset+4*nx≤v1.offset := by
    right; right; change 4*670+4*nx≤4*1675; have q:=h.nxBound; omega
  have xp : Data (middle s ny) fd nx X := by intro i bound; exact xAtU i (by have q:=h.nxBound; omega)
  have runV := BezoutCopySource217.source (middle s ny) "v1" "x" "xlen" v1 fd nx h.nxBound h.v1Binding h.xBinding h.xlen
    drV srX objV objX sizeU sizeU writableU rfl rfl xp apartV
  have xf : Data (after s nx ny) fd 335 X := by
    intro i bound
    apply BezoutCopyFrame217.outside (middle s ny).heap v1 fd (elem fd i) (4*nx) (X i) ?_ (xAtU i bound)
    right; left; change 0+4*(670+i)+4≤0+4*1675; omega
  have yf : Data (after s nx ny) gd 335 Y := by
    intro i bound
    apply BezoutCopyFrame217.outside (middle s ny).heap v1 fd (elem gd i) (4*nx) (Y i) ?_ (yAtU i bound)
    right; left; change 0+4*(1005+i)+4≤0+4*1675; omega
  have uAtU : Data (middle s ny) tmp ny Y := by
    intro i bound
    have alloc : Allocated (middle s ny).heap (element tmp i) := by
      rw [tmp_shape]
      exact BezoutInitCopies217.allocated_at _ 1340 i extentU sizeU (by have q:=h.nyBound; omega)
    exact BezoutCopyFrame217.copied s.heap tmp gd ny i (Y i) drU srY objU objY h.size h.size h.writable rfl rfl
      (fun j jb => ⟨Y j,yp j jb⟩) bound alloc (yp i bound)
  have uf : Data (after s nx ny) tmp ny Y := by
    intro i bound
    apply BezoutCopyFrame217.outside (middle s ny).heap v1 fd (elem tmp i) (4*nx) (Y i) ?_ (uAtU i bound)
    right; left; change 0+4*(1340+i)+4≤0+4*1675; have q:=h.nyBound; omega
  have vf : Data (after s nx ny) v1 nx X := by
    intro i bound
    have alloc : Allocated (after s nx ny).heap (element v1 i) := by
      rw [v1_shape]
      apply BezoutInitCopies217.allocated_at _ 1675 i
      · exact extentU
      · exact sizeU
      · have q:=h.nxBound; omega
    exact BezoutCopyFrame217.copied (middle s ny).heap v1 fd nx i (X i) drV srX objV objX sizeU sizeU writableU rfl rfl
      (fun j jb => ⟨X j,xp j jb⟩) bound alloc (xp i bound)
  exact ⟨runU,runV,xf,yf,uf,vf⟩

theorem continue_part (s : State) (nx ny : Nat) (X Y : Nat → BitVec 32) (h : Input s nx ny X Y)
    (out : C99ProcedureReference.Result) (rest : Exec tail (after s nx ny) out) : Exec BezoutInitZero217.tail s out := by
  rw [shape]
  obtain ⟨firstRun,secondRun,_,_,_,_⟩:=source s nx ny X Y h
  exact .seqNormal _ _ _ _ _ firstRun (.seqNormal _ _ _ _ _ secondRun rest)

end FT1536.Source3.BezoutInitMoreCopies217
