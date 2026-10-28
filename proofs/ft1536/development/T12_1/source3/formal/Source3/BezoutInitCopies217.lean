import Source3.BezoutCopyFrame217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The first two original Bezout initialization copies at selected geometry. -/
namespace FT1536.Source3.BezoutInitCopies217
open C99ArrayReference (State)
open C99MemoryReference (Allocated)
open C99LoopScalar141 (Cell)
open KeygenZintCall (Exec Stmt)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b)
open ZintNormWalkFlat208 (Data)

def first : Stmt := BezoutCopySource217.copy "a" "x" "xlen"
def second : Stmt := BezoutCopySource217.copy "b" "y" "ylen"
def tail : Stmt := match KeygenZintCall.bezoutPart 4 with | .seq _ (.seq _ rest) => rest | _ => KeygenZintCall.skip
def code : Stmt := .seq first (.seq second ZintNormWord194.wskip)
def middle (s : State) (nx : Nat) := BezoutCopySource217.after s a fd nx
def after (s : State) (nx ny : Nat) := BezoutCopySource217.after (middle s nx) b gd ny

theorem a_shape : a=⟨31,0,71680,4,2010⟩ := rfl
theorem b_shape : b=⟨31,0,71680,4,2345⟩ := rfl

theorem shape : KeygenZintCall.bezoutPart 4=.seq first (.seq second tail) := by decide

structure Input (s : State) (nx ny : Nat) (X Y : Nat → BitVec 32) : Prop where
  nxBound : nx≤335
  nyBound : ny≤335
  xlen : Cell s "xlen".toList nx
  ylen : Cell s "ylen".toList ny
  aBinding : s.arrays "a".toList=some a
  bBinding : s.arrays "b".toList=some b
  xBinding : s.arrays "x".toList=some fd
  yBinding : s.arrays "y".toList=some gd
  xData : Data s fd 335 X
  yData : Data s gd 335 Y
  extent : 4*71680≤s.heap.size 31
  size : s.heap.size 31<2^64
  writable : s.heap.writable 31=true

theorem allocated_at (heap : C99MemoryReference.Memory) (start i : Nat)
    (extent : 4*71680≤heap.size 31) (size : heap.size 31<2^64) (inside : start+i<71680) :
    Allocated heap (element ⟨31,0,71680,4,start⟩ i) := by
  simp only [C99MemoryReference.Allocated,element,Nat.zero_add]
  exact ⟨by decide,by decide,inside,extent,size⟩

theorem source (s : State) (nx ny : Nat) (X Y : Nat → BitVec 32) (h : Input s nx ny X Y) :
    Exec first s ⟨middle s nx,.normal⟩ ∧ Exec second (middle s nx) ⟨after s nx ny,.normal⟩ ∧
    Data (after s nx ny) fd 335 X ∧ Data (after s nx ny) gd 335 Y ∧
    Data (after s nx ny) a nx X ∧ Data (after s nx ny) b ny Y := by
  have drA : a.offset+4*nx≤a.base+a.elementBytes*a.count := by change 4*2010+4*nx≤4*71680; have h:=h.nxBound; omega
  have srX : fd.offset+4*nx≤fd.base+fd.elementBytes*fd.count := by change 4*670+4*nx≤4*71680; have h:=h.nxBound; omega
  have objectA : a.base+a.elementBytes*a.count≤s.heap.size a.block := by change 4*71680≤s.heap.size 31; exact h.extent
  have objectX : fd.base+fd.elementBytes*fd.count≤s.heap.size fd.block := by change 4*71680≤s.heap.size 31; exact h.extent
  have apartA : a.block≠fd.block ∨ a.offset+4*nx≤fd.offset ∨ fd.offset+4*nx≤a.offset := by
    right; right; change 4*670+4*nx≤4*2010; have h:=h.nxBound; omega
  have xprefix : Data s fd nx X := by intro i bound; exact h.xData i (by have q:=h.nxBound; omega)
  have runA := BezoutCopySource217.source s "a" "x" "xlen" a fd nx h.nxBound h.aBinding h.xBinding h.xlen
    drA srX objectA objectX h.size h.size h.writable rfl rfl xprefix apartA
  have yAtA : Data (middle s nx) gd 335 Y := by
    intro i bound
    apply BezoutCopyFrame217.outside s.heap a fd (elem gd i) (4*nx) (Y i) ?_ (h.yData i bound)
    right; left
    change 0+4*(1005+i)+4≤0+4*2010
    omega
  have xAtA : Data (middle s nx) fd 335 X := by
    intro i bound
    apply BezoutCopyFrame217.outside s.heap a fd (elem fd i) (4*nx) (X i) ?_ (h.xData i bound)
    right; left
    change 0+4*(670+i)+4≤0+4*2010
    omega
  have extentA : 4*71680≤(middle s nx).heap.size 31 := h.extent
  have sizeA : (middle s nx).heap.size 31<2^64 := h.size
  have writableA : (middle s nx).heap.writable 31=true := h.writable
  have drB : b.offset+4*ny≤b.base+b.elementBytes*b.count := by change 4*2345+4*ny≤4*71680; have h:=h.nyBound; omega
  have srY : gd.offset+4*ny≤gd.base+gd.elementBytes*gd.count := by change 4*1005+4*ny≤4*71680; have h:=h.nyBound; omega
  have objectB : b.base+b.elementBytes*b.count≤(middle s nx).heap.size b.block := by change 4*71680≤(middle s nx).heap.size 31; exact extentA
  have objectY : gd.base+gd.elementBytes*gd.count≤(middle s nx).heap.size gd.block := by change 4*71680≤(middle s nx).heap.size 31; exact extentA
  have apartB : b.block≠gd.block ∨ b.offset+4*ny≤gd.offset ∨ gd.offset+4*ny≤b.offset := by
    right; right; change 4*1005+4*ny≤4*2345; have h:=h.nyBound; omega
  have yprefix : Data (middle s nx) gd ny Y := by intro i bound; exact yAtA i (by have q:=h.nyBound; omega)
  have runB := BezoutCopySource217.source (middle s nx) "b" "y" "ylen" b gd ny h.nyBound h.bBinding h.yBinding h.ylen
    drB srY objectB objectY sizeA sizeA writableA rfl rfl yprefix apartB
  have xFinal : Data (after s nx ny) fd 335 X := by
    intro i bound
    apply BezoutCopyFrame217.outside (middle s nx).heap b gd (elem fd i) (4*ny) (X i) ?_ (xAtA i bound)
    right; left
    change 0+4*(670+i)+4≤0+4*2345
    omega
  have yFinal : Data (after s nx ny) gd 335 Y := by
    intro i bound
    apply BezoutCopyFrame217.outside (middle s nx).heap b gd (elem gd i) (4*ny) (Y i) ?_ (yAtA i bound)
    right; left
    change 0+4*(1005+i)+4≤0+4*2345
    omega
  have aAtA : Data (middle s nx) a nx X := by
    intro i bound
    have alloc : Allocated (middle s nx).heap (element a i) := by
      rw [a_shape]
      exact allocated_at (middle s nx).heap 2010 i extentA sizeA (by have h:=h.nxBound; omega)
    exact BezoutCopyFrame217.copied s.heap a fd nx i (X i) drA srX objectA objectX h.size h.size h.writable rfl rfl
      (fun j jb => ⟨X j,xprefix j jb⟩) bound alloc (xprefix i bound)
  have aFinal : Data (after s nx ny) a nx X := by
    intro i bound
    apply BezoutCopyFrame217.outside (middle s nx).heap b gd (elem a i) (4*ny) (X i) ?_ (aAtA i bound)
    right; left
    change 0+4*(2010+i)+4≤0+4*2345
    have h:=h.nxBound; omega
  have bFinal : Data (after s nx ny) b ny Y := by
    intro i bound
    have alloc : Allocated (after s nx ny).heap (element b i) := by
      rw [b_shape]
      apply allocated_at (after s nx ny).heap 2345 i
      · exact extentA
      · exact sizeA
      · have h:=h.nyBound; omega
    exact BezoutCopyFrame217.copied (middle s nx).heap b gd ny i (Y i) drB srY objectB objectY sizeA sizeA writableA rfl rfl
      (fun j jb => ⟨Y j,yprefix j jb⟩) bound alloc (yprefix i bound)
  exact ⟨runA,runB,xFinal,yFinal,aFinal,bFinal⟩

theorem continue_part (s : State) (nx ny : Nat) (X Y : Nat → BitVec 32) (h : Input s nx ny X Y)
    (out : C99ProcedureReference.Result) (rest : Exec tail (after s nx ny) out) : Exec (KeygenZintCall.bezoutPart 4) s out := by
  rw [shape]
  obtain ⟨firstRun,secondRun,_,_,_,_⟩:=source s nx ny X Y h
  exact .seqNormal _ _ _ _ _ firstRun (.seqNormal _ _ _ _ _ secondRun rest)

end FT1536.Source3.BezoutInitCopies217
