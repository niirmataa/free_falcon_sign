import Source3.StepProductLoop191
import Source3.SelectedStepCopy190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original pair-product loop (statement s2 of the first-prime tail) at
   the actual selected seed9 copy output: productInit, all 256 product
   iterations with the exact walked x pointer, and the written image as
   executed loads and nested Montgomery products. Locals outside v and
   arrays outside x stay readable to the root state. -/
namespace FT1536.Source3.SelectedStepProduct191
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec skip)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open SelectedStepLayout187 (fd t1)
open SelectedTopInit178 (p p0i r2)
open StepCopyBody190 (addr elem)
open StepProductBody191 (value output next)
open StepProductFixed191 (Fixed Image)

noncomputable abbrev base : State := SelectedGen0Call189.after

noncomputable def fvs (i : Nat) : BitVec 32 :=
  SelectedStepCopy190.fv ⟨i % 512,Nat.mod_lt _ (by decide)⟩

theorem fvs_read (i : Nat) (bound : i<512) : fvs i=SelectedStepCopy190.fv ⟨i,bound⟩ := by
  have key : (⟨i % 512,Nat.mod_lt _ (by decide)⟩ : Fin 512)=⟨i,bound⟩ :=
    Fin.ext (Nat.mod_eq_of_lt bound)
  exact congrArg SelectedStepCopy190.fv key

theorem fd_offset (i : Nat) : C99MemoryReference.ArrayPointer.offset (addr fd 0 i 2)=0+4*(670+0+i*2) := rfl
theorem t1_offset (i : Nat) : C99MemoryReference.ArrayPointer.offset (elem t1 i)=0+4*(3742+i) := rfl

theorem dst_src_separate (i : Fin 256) (j : Fin 512) : Separate (addr fd 0 i.val 2) (elem t1 j.val) := by
  unfold Separate
  rw [fd_offset i.val,t1_offset j.val]
  change 31≠31 ∨ (0+4*(670+0+i.val*2))+4≤0+4*(3742+j.val) ∨
    (0+4*(3742+j.val))+4≤0+4*(670+0+i.val*2)
  omega

theorem dst_separate (i j : Fin 256) (different : i≠j) :
    Separate (addr fd 0 i.val 2) (addr fd 0 j.val 2) := by
  have distinct : i.val≠j.val := fun equal => different (Fin.ext equal)
  unfold Separate
  rw [fd_offset i.val,fd_offset j.val]
  change 31≠31 ∨ (0+4*(670+0+i.val*2))+4≤0+4*(670+0+j.val*2) ∨
    (0+4*(670+0+j.val*2))+4≤0+4*(670+0+i.val*2)
  omega

theorem fd_allocated (s : State) (j : Nat) (bound : j<256)
    (source : Allocated s.heap (elem t1 0)) : Allocated s.heap (addr fd 0 j 2) := by
  have sizeLower : 0+4*71680≤s.heap.size 31 := source.2.2.2.1
  have sizeUpper : s.heap.size 31<2^64 := source.2.2.2.2
  refine ⟨?_,?_,?_,sizeLower,sizeUpper⟩
  · change 0<4
    decide
  · change 0%4=0
    decide
  · change 670+0+j*2<71680
    omega

/- The copy output as produced by SelectedStepCopy190.source. -/
theorem source :
    ∃ copyOut out, Exec MakeFgTailShape190.copyF base ⟨copyOut,.normal⟩ ∧
      Exec MakeFgTailShape190.s1 copyOut ⟨copyOut,.normal⟩ ∧
      Exec MakeFgTailShape190.s2 copyOut ⟨out,.normal⟩ ∧
      Fixed out fd t1 0 2 256 p p0i r2 fvs ∧ Cell out "v".toList 256 ∧
      out.arrays "x".toList=some (addr fd 0 256 2) ∧
      Image out fd 0 2 256 p p0i r2 fvs 256 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=base.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=base.arrays name) := by
  obtain ⟨copyOut,copyRun,copyFixed,copyV,copyX,copyPrefix,copyLocals,copyArrays,skipRun⟩ :=
    SelectedStepCopy190.source
  have copyAllocated : Allocated copyOut.heap (elem t1 0) := copyFixed.t1Allocated ⟨0,by decide⟩
  have uCell : Cell copyOut "u".toList 0 :=
    (copyLocals "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have fdBinding : copyOut.arrays "fd".toList=some fd :=
    (copyArrays "fd".toList (by decide)).trans (by exact SelectedGen0Ready189.fd_binding)
  have t1Binding : copyOut.arrays "t1".toList=some t1 :=
    (copyArrays "t1".toList (by decide)).trans (by exact SelectedGen0Ready189.t1_binding)
  have hnCell : Cell copyOut "hn".toList 256 :=
    (copyLocals "hn".toList (by decide)).trans (by exact SelectedGen0Ready189.hn_cell)
  have tlenCell : Cell copyOut "tlen".toList 2 :=
    (copyLocals "tlen".toList (by decide)).trans (by exact SelectedGen0Ready189.tlen_cell)
  have pCell : Slot copyOut "p" p :=
    (copyLocals "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have iCell : Slot copyOut "p0i" p0i :=
    (copyLocals "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have r2Cell : Slot copyOut "R2" r2 :=
    (copyLocals "R2".toList (by decide)).trans (by exact SelectedGen0Ready189.r2_cell)
  have writable : copyOut.heap.writable fd.block=true := by
    exact copyFixed.t1Writable
  have put : C99ModularReference.Exec MakeFgProductShape191.productInitCode copyOut
      ⟨bindPointer (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
        "x".toList (addr fd 0 0 2),.normal⟩ := by
    have assign : C99ModularReference.Exec
        (.assign "v".toList (.scalar (MakeFgProductShape191.num 0)))
        copyOut ⟨FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0),.normal⟩ := by
      rw [FftLocalCells140.put_bind]
      exact .assign _ _ _ .uint64 (some (.uint64 (C99NatWord141.word 512))) (.int32 0) copyV
        (.scalar _ _ (.literal .int32 0))
    have uAfter : Cell (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
        "u".toList 0 :=
      (FftLocalCells140.outside copyOut "v".toList "u".toList (C99NatWord141.word 0) (by decide)).trans
        uCell
    have fdAfter : (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0)).arrays
        "fd".toList=some fd := fdBinding
    have walked : Pointer (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
        "fd".toList MakeFgProductShape191.varU (addr fd 0 0 2) :=
      .add "fd".toList MakeFgProductShape191.varU fd (addr fd 0 0 2)
        (.uint64 (C99NatWord141.word 0)) fdAfter
        (C99LoopScalar141.read _ _ _ uAfter) (by decide)
        (C99MemoryReference.PointerAdd.within fd 0 (by decide))
    have bind : C99ModularReference.Exec
        (.base (.bindPtr "x".toList "fd".toList MakeFgProductShape191.varU))
        (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
        ⟨bindPointer (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
          "x".toList (addr fd 0 0 2),.normal⟩ :=
      .base _ _ _ (.bindPtr _ _ _ _ _ walked)
    exact .seqNormal _ _ _ _ _ assign bind
  set mid : State := bindPointer (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
    "x".toList (addr fd 0 0 2) with midEq
  have initRun : Exec MakeFgProductShape191.productInit copyOut ⟨mid,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ put)
  have midFixed : Fixed mid fd t1 0 2 256 p p0i r2 fvs := by
    refine ⟨by decide,by decide,by decide,by decide,rfl,by decide,?_,?_,?_,?_,?_,?_,?_,?_,?_,
      ?_,?_,?_⟩
    · rw [midEq]
      exact writable
    · rw [midEq]
      rw [StepProductFixed191.bindPointer_arrays
        (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0)) "x".toList
        (addr fd 0 0 2) "fd".toList (by decide)]
      exact fdBinding
    · rw [midEq]
      rw [StepProductFixed191.bindPointer_arrays
        (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0)) "x".toList
        (addr fd 0 0 2) "t1".toList (by decide)]
      exact t1Binding
    · rw [midEq]
      exact (FftLocalCells140.outside copyOut "v".toList "hn".toList
        (C99NatWord141.word 0) (by decide)).trans hnCell
    · rw [midEq]
      exact (FftLocalCells140.outside copyOut "v".toList "tlen".toList
        (C99NatWord141.word 0) (by decide)).trans tlenCell
    · rw [midEq]
      exact (FftLocalCells140.outside copyOut "v".toList "p".toList
        (C99NatWord141.word 0) (by decide)).trans pCell
    · rw [midEq]
      exact (FftLocalCells140.outside copyOut "v".toList "p0i".toList
        (C99NatWord141.word 0) (by decide)).trans iCell
    · rw [midEq]
      exact (FftLocalCells140.outside copyOut "v".toList "R2".toList
        (C99NatWord141.word 0) (by decide)).trans r2Cell
    · intro i
      exact fd_allocated copyOut i.val i.isLt copyAllocated
    · exact dst_src_separate
    · exact dst_separate
    · intro i
      have read := copyPrefix i i.isLt
      rw [fvs_read i.val i.isLt]
      exact read
  have midV : Cell mid "v".toList 0 := by
    rw [midEq]
    exact FftLocalCells140.cell_at copyOut "v".toList (C99NatWord141.word 0)
  have midX : mid.arrays "x".toList=some (addr fd 0 0 2) := by
    rw [midEq]
    rfl
  have midImage : Image mid fd 0 2 256 p p0i r2 fvs 0 :=
    StepProductFixed191.empty_image mid fd 0 2 256 p p0i r2 fvs
  obtain ⟨out,loopRun,outFixed,outV,outX,outImage,outLocals,outArrays⟩ :=
    StepProductLoop191.source mid fd t1 0 2 256 p p0i r2 fvs midFixed midV midX midImage
  have whole : Exec MakeFgTailShape190.s2 copyOut ⟨out,.normal⟩ := by
    rw [MakeFgProductShape191.s2_shape]
    exact .seqNormal _ _ copyOut mid ⟨out,.normal⟩ initRun loopRun
  refine ⟨copyOut,out,copyRun,skipRun,whole,outFixed,outV,outX,outImage,?_,?_⟩
  · intro name different
    have first : mid.locals name=copyOut.locals name := by
      rw [midEq]
      exact (FftLocalCells140.outside copyOut "v".toList name
        (C99NatWord141.word 0) different).trans rfl
    exact (outLocals name different).trans (first.trans (copyLocals name different))
  · intro name different
    have first : mid.arrays name=copyOut.arrays name := by
      rw [midEq]
      rw [StepProductFixed191.bindPointer_arrays
        (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0)) "x".toList
        (addr fd 0 0 2) name different]
      rfl
    exact (outArrays name different).trans (first.trans (copyArrays name different))

end FT1536.Source3.SelectedStepProduct191
