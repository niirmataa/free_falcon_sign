import Source3.StepGsProductKeep194
import Source3.MakeFgGsShape194
import Source3.SelectedStepLayout187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The gd pair-product step (statement s6) of the make_fg_step first-prime
   gs path at the SelectedStepGsCopy194 copy output: the original product
   init (v = 0, x = gd + u at the u = 0 cell), all 256 product iterations
   through StepGsProductKeep194 with the two kept read images (the gs
   source words and the igm twiddle reads), the FixedGd frame and the
   written gd image as the executed `value (gvs (2v)) (gvs (2v+1)) R2 p
   p0i` words over the copied t1 image. The t1 image, the gs source words
   and the igm reads at the input state are hypotheses of this stage
   statement (the copy output of SelectedStepGsCopy194 carries them);
   values stay the executed load and Montgomery product words and no
   product or transform property is claimed. -/
namespace FT1536.Source3.SelectedStepGsProduct194
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (addr elem)
open StepProductBody191 (value)
open StepProductFixed191 (Image)
open StepCopyKeep193 (Reads)
open StepGsProductKeep194 (FixedGd)
open SelectedStepLayout187 (gs gd t1 igm)

theorem gd_offset (i : Nat) :
    C99MemoryReference.ArrayPointer.offset (addr gd 0 i 2)=0+4*(1182+0+i*2) := rfl
theorem t1_offset (i : Nat) : C99MemoryReference.ArrayPointer.offset (elem t1 i)=0+4*(3742+i) := rfl
theorem gs_offset_raw (k : Nat) :
    C99MemoryReference.ArrayPointer.offset ({gs with index := gs.index+k})=0+4*(2206+k) := rfl
theorem igm_offset (k : Nat) :
    C99MemoryReference.ArrayPointer.offset ({igm with index := igm.index+k})=0+4*(3230+k) := rfl

theorem dst_src_separate (i : Fin 256) (j : Fin 512) :
    Separate (addr gd 0 i.val 2) (elem t1 j.val) := by
  unfold Separate
  rw [gd_offset i.val,t1_offset j.val]
  change 31≠31 ∨ (0+4*(1182+0+i.val*2))+4≤0+4*(3742+j.val) ∨
    (0+4*(3742+j.val))+4≤0+4*(1182+0+i.val*2)
  omega

theorem dst_separate (i j : Fin 256) (different : i≠j) :
    Separate (addr gd 0 i.val 2) (addr gd 0 j.val 2) := by
  have distinct : i.val≠j.val := fun equal => different (Fin.ext equal)
  unfold Separate
  rw [gd_offset i.val,gd_offset j.val]
  change 31≠31 ∨ (0+4*(1182+0+i.val*2))+4≤0+4*(1182+0+j.val*2) ∨
    (0+4*(1182+0+j.val*2))+4≤0+4*(1182+0+i.val*2)
  omega

theorem gd_gs_separate (i : Fin 256) (k : Nat) :
    Separate (addr gd 0 i.val 2) ({gs with index := gs.index+k}) := by
  unfold Separate
  rw [gd_offset i.val,gs_offset_raw]
  change 31≠31 ∨ (0+4*(1182+0+i.val*2))+4≤0+4*(2206+k) ∨
    (0+4*(2206+k))+4≤0+4*(1182+0+i.val*2)
  omega

theorem gd_igm_separate (i : Fin 256) (k : Nat) :
    Separate (addr gd 0 i.val 2) ({igm with index := igm.index+k}) := by
  unfold Separate
  rw [gd_offset i.val,igm_offset]
  change 31≠31 ∨ (0+4*(1182+0+i.val*2))+4≤0+4*(3230+k) ∨
    (0+4*(3230+k))+4≤0+4*(1182+0+i.val*2)
  omega

theorem load_allocated {h : C99MemoryReference.Memory} {p : ArrayPointer} {w : BitVec 32}
    (read : Load32 h p w) : Allocated h p := by
  cases read with
  | load b allocated width init => exact allocated

theorem gd_allocated (s : State) (j : Nat) (bound : j<256)
    (source : Allocated s.heap (elem t1 0)) : Allocated s.heap (addr gd 0 j 2) := by
  have sizeLower : 0+4*71680≤s.heap.size 31 := source.2.2.2.1
  have sizeUpper : s.heap.size 31<2^64 := source.2.2.2.2
  refine ⟨?_,?_,?_,sizeLower,sizeUpper⟩
  · change 0<4
    decide
  · change 0%4=0
    decide
  · change 1182+0+j*2<71680
    omega

noncomputable def mid (start : State) : State :=
  bindPointer (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
    "x".toList (addr gd 0 0 2)

theorem product_init (start : State) (vCell : Cell start "v".toList 512)
    (uCell : Cell start "u".toList 0) (gdBinding : start.arrays "gd".toList=some gd) :
    C99ModularReference.Exec MakeFgGsShape194.productInitGdCode start
      ⟨bindPointer (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
        "x".toList (addr gd 0 0 2),.normal⟩ := by
  have assign : C99ModularReference.Exec
      (.assign "v".toList (.scalar (MakeFgGsShape194.num 0)))
      start ⟨FftLocalCells140.put start "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 (some (.uint64 (C99NatWord141.word 512))) (.int32 0) vCell
      (.scalar _ _ (.literal .int32 0))
  have uAfter : Cell (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
      "u".toList 0 :=
    (FftLocalCells140.outside start "v".toList "u".toList (C99NatWord141.word 0) (by decide)).trans
      uCell
  have gdAfter : (FftLocalCells140.put start "v".toList (C99NatWord141.word 0)).arrays
      "gd".toList=some gd := gdBinding
  have walked : Pointer (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
      "gd".toList MakeFgGsShape194.varU (addr gd 0 0 2) :=
    .add "gd".toList MakeFgGsShape194.varU gd (addr gd 0 0 2)
      (.uint64 (C99NatWord141.word 0)) gdAfter
      (C99LoopScalar141.read _ _ _ uAfter) (by decide)
      (C99MemoryReference.PointerAdd.within gd 0 (by decide))
  have bind : C99ModularReference.Exec
      (.base (.bindPtr "x".toList "gd".toList MakeFgGsShape194.varU))
      (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
      ⟨bindPointer (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
        "x".toList (addr gd 0 0 2),.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ walked)
  exact .seqNormal _ _ _ _ _ assign bind

theorem mid_locals (start : State) (other : Name) (different : other≠"v".toList) :
    (mid start).locals other=start.locals other := by
  have first : (mid start).locals other=
      (FftLocalCells140.put start "v".toList (C99NatWord141.word 0)).locals other := rfl
  rw [first]
  exact (FftLocalCells140.outside start "v".toList other
    (C99NatWord141.word 0) different).trans rfl

theorem mid_arrays (start : State) (other : Name) (different : other≠"x".toList) :
    (mid start).arrays other=start.arrays other := by
  have first : (mid start).arrays other=
      (C99ArrayReference.bindPointer (FftLocalCells140.put start "v".toList
        (C99NatWord141.word 0)) "x".toList (addr gd 0 0 2)).arrays other := rfl
  rw [first]
  rw [StepProductFixed191.bindPointer_arrays _ _ _ _ different]
  rfl

theorem mid_heap (start : State) : (mid start).heap=start.heap := rfl

theorem source (start : State) (gvs tws : Nat → BitVec 32)
    (t1Image : ∀ i : Fin 512, Load32 start.heap (elem t1 i.val) (gvs i.val))
    (gsReads : ∀ k : Nat, k<512 → Load32 start.heap ({gs with index := gs.index+k}) (gvs k))
    (igmReads : ∀ k : Nat, k<512 → Load32 start.heap ({igm with index := igm.index+k}) (tws k))
    (vCell : Cell start "v".toList 512) (uCell : Cell start "u".toList 0)
    (hnCell : Cell start "hn".toList 256) (tlenCell : Cell start "tlen".toList 2)
    (pCell : Slot start "p" p) (iCell : Slot start "p0i" p0i) (r2Cell : Slot start "R2" r2)
    (gdBinding : start.arrays "gd".toList=some gd) (t1Binding : start.arrays "t1".toList=some t1)
    (gdWritable : start.heap.writable gd.block=true) :
    ∃ out, Exec MakeFgTailShape190.s6 start ⟨out,.normal⟩ ∧
      FixedGd out gd t1 0 2 256 p p0i r2 gvs ∧ Cell out "v".toList 256 ∧
      out.arrays "x".toList=some (addr gd 0 256 2) ∧
      Image out gd 0 2 256 p p0i r2 gvs 256 ∧
      Reads out gs 512 gvs ∧ Reads out igm 512 tws ∧
      (∀ name : Name, name≠"v".toList → out.locals name=start.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=start.arrays name) := by
  have allocated : Allocated start.heap (elem t1 0) := load_allocated (t1Image ⟨0,by decide⟩)
  have put : C99ModularReference.Exec MakeFgGsShape194.productInitGdCode start
      ⟨mid start,.normal⟩ := product_init start vCell uCell gdBinding
  have initRun : Exec MakeFgGsShape194.productInitGd start ⟨mid start,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ put)
  have midFixed : FixedGd (mid start) gd t1 0 2 256 p p0i r2 gvs := by
    refine ⟨by decide,by decide,by decide,by decide,by decide,by decide,?_,?_,?_,?_,?_,?_,?_,
      ?_,?_,?_,?_,?_⟩
    · rw [mid_heap]
      exact gdWritable
    · rw [mid_arrays start "gd".toList (by decide)]
      exact gdBinding
    · rw [mid_arrays start "t1".toList (by decide)]
      exact t1Binding
    · exact (mid_locals start "hn".toList (by decide)).trans hnCell
    · exact (mid_locals start "tlen".toList (by decide)).trans tlenCell
    · exact (mid_locals start "p".toList (by decide)).trans pCell
    · exact (mid_locals start "p0i".toList (by decide)).trans iCell
    · exact (mid_locals start "R2".toList (by decide)).trans r2Cell
    · intro i
      rw [mid_heap]
      exact gd_allocated start i.val i.isLt allocated
    · exact dst_src_separate
    · exact dst_separate
    · intro i
      rw [mid_heap]
      exact t1Image i
  have midV : Cell (mid start) "v".toList 0 :=
    FftLocalCells140.cell_at start "v".toList (C99NatWord141.word 0)
  have midX : (mid start).arrays "x".toList=some (addr gd 0 0 2) := rfl
  have midImage : Image (mid start) gd 0 2 256 p p0i r2 gvs 0 :=
    StepProductFixed191.empty_image (mid start) gd 0 2 256 p p0i r2 gvs
  have midReadsGs : Reads (mid start) gs 512 gvs := by
    intro k bound
    rw [mid_heap]
    exact gsReads k bound
  have midReadsIgm : Reads (mid start) igm 512 tws := by
    intro k bound
    rw [mid_heap]
    exact igmReads k bound
  obtain ⟨out,loopRun,outFixed,outV,outX,outImage,outLocals,outArrays,outReadsGs,outReadsIgm⟩ :=
    StepGsProductKeep194.source (mid start) gd t1 0 2 256 p p0i r2 gvs midFixed midV midX midImage
      gs 512 gvs midReadsGs (fun i k _ => gd_gs_separate i k)
      igm 512 tws midReadsIgm (fun i k _ => gd_igm_separate i k)
  have whole : Exec MakeFgTailShape190.s6 start ⟨out,.normal⟩ := by
    rw [MakeFgGsShape194.s6_shape]
    exact .seqNormal _ _ start (mid start) ⟨out,.normal⟩ initRun loopRun
  refine ⟨out,whole,outFixed,outV,outX,outImage,outReadsGs,outReadsIgm,?_,?_⟩
  · intro name different
    exact (outLocals name different).trans (mid_locals start name different)
  · intro name different
    exact (outArrays name different).trans (mid_arrays start name different)

end FT1536.Source3.SelectedStepGsProduct194
