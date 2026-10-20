import Source3.StepProductKeep193
import Source3.SelectedStepInverse192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Step assembly of the make_fg_step first-prime prefix s0-s3 at the actual
   selected seed9 state: the fs-image and igm twiddle reads are kept through
   the copy and product writes (separation of the fs/gm/igm regions from the
   t1/fd walk positions), the product-output caller frame comes from the
   kept executions, and every product-output hypothesis of the sealed s3
   inverse call (SelectedStepInverse192.source) is discharged there, so the
   stage statement `KeygenMakeFgSource.Exec MakeFgTailShape190.s3 out after`
   holds unconditionally at the assembled product output. Values stay the
   executed words: no transform property, table law, root law or positivity
   claim; the gs path s4-s7 and everything after stay open. -/
namespace FT1536.Source3.SelectedStepChain193
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open KeygenSmallOutput (element)
open StepCopyBody190 (addr elem)
open SelectedStepLayout187 (fs t1 fd igm)
open StepCopyKeep193 (Reads)
open NttInverseWholeBridges192 (scaledWord)

noncomputable abbrev base : State := SelectedGen0Call189.after

/- The igm twiddle reads as the actual executed load words at the selected
   state; no table law is assumed. -/
noncomputable def tws (k : Nat) : BitVec 32 :=
  if h : k<512 then Classical.choose (SelectedGen0Frame189.igm_read k h) else 0

theorem tws_read (k : Nat) (bound : k<512) :
    Load32 base.heap ({igm with index := igm.index+k}) (tws k) := by
  have read := Classical.choose_spec (SelectedGen0Frame189.igm_read k bound)
  have key : tws k=Classical.choose (SelectedGen0Frame189.igm_read k bound) := by
    unfold tws
    split_ifs
    rfl
  rw [key]
  exact read

theorem t1_offset (i : Nat) : C99MemoryReference.ArrayPointer.offset (elem t1 i)=0+4*(3742+i) :=
  rfl
theorem igm_offset (k : Nat) :
    C99MemoryReference.ArrayPointer.offset ({igm with index := igm.index+k})=0+4*(3230+k) := rfl
theorem fs_offset (k : Nat) :
    C99MemoryReference.ArrayPointer.offset (elem fs k)=0+4*(1694+k) := rfl
theorem fs_offset_raw (k : Nat) :
    C99MemoryReference.ArrayPointer.offset ({fs with index := fs.index+k})=0+4*(1694+k) := rfl
theorem fd_offset (v : Nat) :
    C99MemoryReference.ArrayPointer.offset (addr fd 0 v 2)=0+4*(670+0+v*2) := rfl

theorem t1_igm_separate (i k : Nat) (bound : k<512) :
    Separate (elem t1 i) ({igm with index := igm.index+k}) := by
  unfold Separate
  rw [t1_offset,igm_offset]
  change 31≠31 ∨ (0+4*(3742+i))+4≤0+4*(3230+k) ∨ (0+4*(3230+k))+4≤0+4*(3742+i)
  omega

theorem fd_fs_separate (v k : Nat) (bound : v<256) :
    Separate (addr fd 0 v 2) ({fs with index := fs.index+k}) := by
  unfold Separate
  rw [fd_offset,fs_offset_raw]
  change 31≠31 ∨ (0+4*(670+0+v*2))+4≤0+4*(1694+k) ∨ (0+4*(1694+k))+4≤0+4*(670+0+v*2)
  omega

theorem fd_igm_separate (v k : Nat) (bound : v<256) :
    Separate (addr fd 0 v 2) ({igm with index := igm.index+k}) := by
  unfold Separate
  rw [fd_offset,igm_offset]
  change 31≠31 ∨ (0+4*(670+0+v*2))+4≤0+4*(3230+k) ∨ (0+4*(3230+k))+4≤0+4*(670+0+v*2)
  omega

theorem fs_fs_separate (j k : Nat) (different : j≠k) : Separate (elem fs j) (elem fs k) := by
  unfold Separate
  rw [fs_offset,fs_offset]
  change 31≠31 ∨ (0+4*(1694+j))+4≤0+4*(1694+k) ∨ (0+4*(1694+k))+4≤0+4*(1694+j)
  omega

theorem fs_igm_separate (j k : Nat) (bound : j<512) :
    Separate (elem fs j) ({igm with index := igm.index+k}) := by
  unfold Separate
  rw [fs_offset,igm_offset]
  change 31≠31 ∨ (0+4*(1694+j))+4≤0+4*(3230+k) ∨ (0+4*(3230+k))+4≤0+4*(1694+j)
  omega

theorem product_init (copyOut : State) (copyV : Cell copyOut "v".toList 512)
    (uCell : Cell copyOut "u".toList 0) (fdBinding : copyOut.arrays "fd".toList=some fd) :
    C99ModularReference.Exec MakeFgProductShape191.productInitCode copyOut
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

def tailPrefix : KeygenMakeFgSource.Stmt :=
  .seq MakeFgTailShape190.s0 (.seq MakeFgTailShape190.s1
    (.seq MakeFgTailShape190.s2 MakeFgTailShape190.s3))

theorem source : ∃ copyOut out after,
    Exec MakeFgTailShape190.copyF base ⟨copyOut,.normal⟩ ∧
    Exec MakeFgTailShape190.s1 copyOut ⟨copyOut,.normal⟩ ∧
    Exec MakeFgTailShape190.s2 copyOut ⟨out,.normal⟩ ∧
    Exec MakeFgTailShape190.s3 out ⟨after,.normal⟩ ∧
    Exec tailPrefix base ⟨after,.normal⟩ ∧
    (∀ i : Fin 512, Load32 after.heap (elem fs i.val)
      (scaledWord SelectedStepProduct191.fvs tws SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    (∀ name : Name, name≠"v".toList → after.locals name=base.locals name) ∧
    (∀ name : Name, name≠"x".toList → after.arrays name=base.arrays name) := by
  have midIgm : Reads SelectedStepCopy190.mid igm 512 tws := by
    intro k bound
    rw [SelectedStepCopy190.mid_heap]
    exact tws_read k bound
  have copySeparate : ∀ i : Fin 512, ∀ k : Nat, k<512 →
      Separate (elem t1 i.val) ({igm with index := igm.index+k}) :=
    fun i k bound => t1_igm_separate i.val k bound
  obtain ⟨copyOut,copyLoopRun,copyFixed,copyV,copyX,copyPrefix,copyLocals,copyArrays,copyIgm⟩ :=
    StepCopyKeep193.source SelectedStepCopy190.mid fs t1 0 1 512 SelectedStepCopy190.fv
      SelectedStepCopy190.mid_fixed SelectedStepCopy190.mid_v SelectedStepCopy190.mid_x
      SelectedStepCopy190.mid_copied igm 512 tws midIgm copySeparate
  have copyFRun : Exec MakeFgTailShape190.copyF base ⟨copyOut,.normal⟩ :=
    .seqNormal _ _ base SelectedStepCopy190.mid ⟨copyOut,.normal⟩
      SelectedStepCopy190.init_source copyLoopRun
  have s0Run : Exec MakeFgTailShape190.s0 base ⟨copyOut,.normal⟩ := by
    rw [MakeFgTailShape190.s0_shape]
    exact copyFRun
  have copyLocalsBase : ∀ name : Name, name≠"v".toList → copyOut.locals name=base.locals name := by
    intro name different
    exact (copyLocals name different).trans (SelectedStepCopy190.mid_locals name different)
  have copyArraysBase : ∀ name : Name, name≠"x".toList → copyOut.arrays name=base.arrays name := by
    intro name different
    exact (copyArrays name different).trans (SelectedStepCopy190.mid_arrays name different)
  have skipRun : Exec MakeFgTailShape190.s1 copyOut ⟨copyOut,.normal⟩ :=
    SelectedStepCopy190.skip_source copyOut copyLocalsBase
  have copyAllocated : Allocated copyOut.heap (elem t1 0) := copyFixed.t1Allocated ⟨0,by decide⟩
  have uCell : Cell copyOut "u".toList 0 :=
    (copyLocalsBase "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have fdBinding : copyOut.arrays "fd".toList=some fd :=
    (copyArraysBase "fd".toList (by decide)).trans (by exact SelectedGen0Ready189.fd_binding)
  have t1Binding : copyOut.arrays "t1".toList=some t1 :=
    (copyArraysBase "t1".toList (by decide)).trans (by exact SelectedGen0Ready189.t1_binding)
  have hnCell : Cell copyOut "hn".toList 256 :=
    (copyLocalsBase "hn".toList (by decide)).trans (by exact SelectedGen0Ready189.hn_cell)
  have tlenCell : Cell copyOut "tlen".toList 2 :=
    (copyLocalsBase "tlen".toList (by decide)).trans (by exact SelectedGen0Ready189.tlen_cell)
  have pCell : Slot copyOut "p" SelectedTopInit178.p :=
    (copyLocalsBase "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have iCell : Slot copyOut "p0i" SelectedTopInit178.p0i :=
    (copyLocalsBase "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have r2Cell : Slot copyOut "R2" SelectedTopInit178.r2 :=
    (copyLocalsBase "R2".toList (by decide)).trans (by exact SelectedGen0Ready189.r2_cell)
  have writable : copyOut.heap.writable fd.block=true := by
    exact copyFixed.t1Writable
  have initRun : C99ModularReference.Exec MakeFgProductShape191.productInitCode copyOut
      ⟨bindPointer (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
        "x".toList (addr fd 0 0 2),.normal⟩ :=
    product_init copyOut copyV uCell fdBinding
  set mid2 : State := bindPointer (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
    "x".toList (addr fd 0 0 2) with midEq
  have productInitRun : Exec MakeFgProductShape191.productInit copyOut ⟨mid2,.normal⟩ := by
    rw [midEq]
    exact .level _ _ _ (.modular _ _ _ initRun)
  have midFixed : StepProductFixed191.Fixed mid2 fd t1 0 2 256
      SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2
      SelectedStepProduct191.fvs := by
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
      exact SelectedStepProduct191.fd_allocated copyOut i.val i.isLt copyAllocated
    · exact SelectedStepProduct191.dst_src_separate
    · exact SelectedStepProduct191.dst_separate
    · intro i
      have read := copyPrefix i i.isLt
      rw [SelectedStepProduct191.fvs_read i.val i.isLt]
      exact read
  have midV : Cell mid2 "v".toList 0 := by
    rw [midEq]
    exact FftLocalCells140.cell_at copyOut "v".toList (C99NatWord141.word 0)
  have midX : mid2.arrays "x".toList=some (addr fd 0 0 2) := by
    rw [midEq]
    rfl
  have midImage : StepProductFixed191.Image mid2 fd 0 2 256
      SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2
      SelectedStepProduct191.fvs 0 :=
    StepProductFixed191.empty_image mid2 fd 0 2 256
      SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2 SelectedStepProduct191.fvs
  have midReadsFs : Reads mid2 fs 512 SelectedStepProduct191.fvs := by
    intro k bound
    have read := copyFixed.src ⟨k,bound⟩
    rw [SelectedStepCopy190.addr_zero_one fs k] at read
    rw [← SelectedStepProduct191.fvs_read k bound] at read
    rw [midEq]
    exact read
  have midReadsIgm : Reads mid2 igm 512 tws := by
    intro k bound
    rw [midEq]
    exact copyIgm k bound
  have productSeparateFs : ∀ i : Fin 256, ∀ k : Nat, k<512 →
      Separate (addr fd 0 i.val 2) ({fs with index := fs.index+k}) :=
    fun i k _ => fd_fs_separate i.val k i.isLt
  have productSeparateIgm : ∀ i : Fin 256, ∀ k : Nat, k<512 →
      Separate (addr fd 0 i.val 2) ({igm with index := igm.index+k}) :=
    fun i k _ => fd_igm_separate i.val k i.isLt
  obtain ⟨out,loopRun,outFixed,outV,outX,outImage,outLocals,outArrays,outReadsFs,outReadsIgm⟩ :=
    StepProductKeep193.source mid2 fd t1 0 2 256
      SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2 SelectedStepProduct191.fvs
      midFixed midV midX midImage
      fs 512 SelectedStepProduct191.fvs midReadsFs productSeparateFs
      igm 512 tws midReadsIgm productSeparateIgm
  have productRun : Exec MakeFgTailShape190.s2 copyOut ⟨out,.normal⟩ := by
    rw [MakeFgProductShape191.s2_shape]
    exact .seqNormal _ _ copyOut mid2 ⟨out,.normal⟩ productInitRun loopRun
  have outLocalsBase : ∀ name : Name, name≠"v".toList → out.locals name=base.locals name := by
    intro name different
    have first : mid2.locals name=copyOut.locals name := by
      rw [midEq]
      exact (FftLocalCells140.outside copyOut "v".toList name
        (C99NatWord141.word 0) different).trans rfl
    exact (outLocals name different).trans (first.trans (copyLocalsBase name different))
  have outArraysBase : ∀ name : Name, name≠"x".toList → out.arrays name=base.arrays name := by
    intro name different
    have first : mid2.arrays name=copyOut.arrays name := by
      rw [midEq]
      rw [StepProductFixed191.bindPointer_arrays
        (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0)) "x".toList
        (addr fd 0 0 2) name different]
      rfl
    exact (outArrays name different).trans (first.trans (copyArraysBase name different))
  have uCellOut : Cell out "u".toList 0 :=
    (outLocalsBase "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have slenCellOut : USlot out "slen" 1 :=
    (outLocalsBase "slen".toList (by decide)).trans (by exact SelectedGen0Ready189.slen_cell)
  have lognCellOut : Slot out "logn" 9 :=
    (outLocalsBase "logn".toList (by decide)).trans (by exact SelectedGen0Ready189.logn_cell)
  have terCellOut : Slot out "ter" 1 :=
    (outLocalsBase "ter".toList (by decide)).trans (by exact SelectedGen0Ready189.ternary_cell)
  have inNttCellOut : out.locals "in_ntt".toList=some (.int32,some (.int32 1)) :=
    (outLocalsBase "in_ntt".toList (by decide)).trans
      (by exact SelectedGen0Ready189.in_ntt_cell)
  have pcOut : Slot out "p" SelectedTopInit178.p :=
    (outLocalsBase "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have icOut : Slot out "p0i" SelectedTopInit178.p0i :=
    (outLocalsBase "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have fsBindingOut : out.arrays "fs".toList=some fs :=
    (outArraysBase "fs".toList (by decide)).trans (by exact SelectedGen0Ready189.fs_binding)
  have igmBindingOut : out.arrays "igm".toList=some igm :=
    (outArraysBase "igm".toList (by decide)).trans (by exact SelectedGen0Ready189.igm_binding)
  have fsWritableOut : out.heap.writable fs.block=true := by
    exact outFixed.fdWritable
  have fsCapacityOut : (addr fs 0 0 1).index+512≤(addr fs 0 0 1).count := by decide
  have igmCapacityOut : igm.index+512≤C99MemoryReference.ArrayPointer.count igm := by decide
  have fsSeparateOut : ∀ j k : Nat, j<512 → k<512 → j≠k →
      Separate (NttInverseCorrectionLoop192.walk (addr fs 0 0 1) j 1)
        (NttInverseCorrectionLoop192.walk (addr fs 0 0 1) k 1) := by
    intro j k bj bk different
    rw [SelectedStepInverse192.walk_fs j,SelectedStepInverse192.walk_fs k]
    exact fs_fs_separate j k different
  have twSeparateOut : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (NttInverseCorrectionLoop192.walk (addr fs 0 0 1) j 1)
        ({igm with index := igm.index+k}) := by
    intro k bk j bj
    rw [SelectedStepInverse192.walk_fs j]
    exact fs_igm_separate j k bj
  have twLoadsOut : ∀ k : Nat, k<512 → Load32 out.heap ({igm with index := igm.index+k}) (tws k) :=
    outReadsIgm
  have fsImageOut : ∀ i : Fin 512, Load32 out.heap (elem fs i.val)
      (SelectedStepProduct191.fvs i.val) := fun i => outReadsFs i.val i.isLt
  have localsKeepOut : ∀ name : Name, name≠"v".toList →
      out.locals name=SelectedStepProduct191.base.locals name := outLocalsBase
  have arraysKeepOut : ∀ name : Name, name≠"x".toList →
      out.arrays name=SelectedStepProduct191.base.arrays name := outArraysBase
  obtain ⟨after,s3Run,s3Image,s3Locals,s3Arrays⟩ :=
    SelectedStepInverse192.source out SelectedTopInit178.p SelectedTopInit178.p0i tws
      uCellOut slenCellOut lognCellOut terCellOut inNttCellOut pcOut icOut fsBindingOut
      igmBindingOut fsWritableOut fsCapacityOut igmCapacityOut fsSeparateOut twSeparateOut
      twLoadsOut fsImageOut localsKeepOut arraysKeepOut
  have prefixRun : Exec tailPrefix base ⟨after,.normal⟩ :=
    .seqNormal _ _ base copyOut ⟨after,.normal⟩ s0Run
      (.seqNormal _ _ copyOut copyOut ⟨after,.normal⟩ skipRun
        (.seqNormal _ _ copyOut out ⟨after,.normal⟩ productRun s3Run))
  exact ⟨copyOut,out,after,copyFRun,skipRun,productRun,s3Run,prefixRun,s3Image,s3Locals,s3Arrays⟩

end FT1536.Source3.SelectedStepChain193
