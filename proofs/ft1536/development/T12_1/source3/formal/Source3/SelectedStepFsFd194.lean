import Source3.SelectedStepLoopTail194
import Source3.StepGsCopyKeepCell194
import Source3.StepGsProductKeepCell194
import Source3.KeygenMakeFgArity099

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Transport of the fs and fd bystander images from the assembled s0-s3
   state to the make_fg_step loop exit state (the keep-arity gap of the
   s4/s6 loops). The s4 copy loop and the s6 product loop run with the
   per-cell bystander keeps of StepGsCopyKeepCell194 /
   StepGsProductKeepCell194 (the NttInverseMiddleRounds192.source form),
   and the s7 per-cell keep of SelectedStepInverseKeep194 carries both
   images through the gs inverse; the loop tail (body scope restore, u
   increment, false guard, part-2 statement) is heap-free. The exit-state
   package (cells, caller frames, gs/gd images) is the sealed
   SelectedStepLoopTail194.source export, tied to this run by the
   KeygenMakeFgDeterminism099 execution determinism of part .step 2.
   Export at the loop exit state: the fs transformed words and the fd
   written image as executed words, the gs/gd images and the exit-state
   cells/frames, with the heap writability transport. Values stay
   executed words: no transform property, table law, root law or
   positivity claim. -/
namespace FT1536.Source3.SelectedStepFsFd194
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (addr elem)
open StepProductBody191 (value)
open StepProductFixed191 (Image)
open StepCopyKeep193 (Reads)
open StepGsProductKeep194 (FixedGd)
open SelectedStepLayout187 (fs fd gs gd t1 igm)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges192 (scaledWord)
open SelectedStepLoopTail194 (LocalsFrame)

noncomputable abbrev base : State := SelectedGen0Call189.after

/- Walk offsets of the bystander regions and their separation from the
   three writer walks (the t1 copy walk, the gd product walk and the gs
   inverse walk); pure index arithmetic on the pinned layout. -/
theorem fs_offset (i : Nat) :
    C99MemoryReference.ArrayPointer.offset (elem fs i)=0+4*(1694+i) := rfl
theorem fd_offset (v : Nat) :
    C99MemoryReference.ArrayPointer.offset (addr fd 0 v 2)=0+4*(670+0+v*2) := rfl

theorem t1_fs_separate (x i : Nat) (bx : x<512) (bi : i<512) : Separate (elem t1 x) (elem fs i) := by
  unfold Separate
  rw [SelectedStepGsCopy194.t1_offset x,fs_offset i]
  change 31≠31 ∨ (0+4*(3742+x))+4≤0+4*(1694+i) ∨ (0+4*(1694+i))+4≤0+4*(3742+x)
  omega

theorem t1_fd_separate (x v : Nat) (bx : x<512) (bv : v<256) : Separate (elem t1 x) (addr fd 0 v 2) := by
  unfold Separate
  rw [SelectedStepGsCopy194.t1_offset x,fd_offset v]
  change 31≠31 ∨ (0+4*(3742+x))+4≤0+4*(670+0+v*2) ∨ (0+4*(670+0+v*2))+4≤0+4*(3742+x)
  omega

theorem gd_fs_separate (x i : Nat) (bx : x<256) (bi : i<512) : Separate (addr gd 0 x 2) (elem fs i) := by
  unfold Separate
  rw [SelectedStepGsProduct194.gd_offset x,fs_offset i]
  change 31≠31 ∨ (0+4*(1182+0+x*2))+4≤0+4*(1694+i) ∨ (0+4*(1694+i))+4≤0+4*(1182+0+x*2)
  omega

theorem gd_fd_separate (x v : Nat) (bx : x<256) (bv : v<256) : Separate (addr gd 0 x 2) (addr fd 0 v 2) := by
  unfold Separate
  rw [SelectedStepGsProduct194.gd_offset x,fd_offset v]
  change 31≠31 ∨ (0+4*(1182+0+x*2))+4≤0+4*(670+0+v*2) ∨ (0+4*(670+0+v*2))+4≤0+4*(1182+0+x*2)
  omega

theorem gs_fs_separate (x i : Nat) (bx : x<512) (bi : i<512) : Separate (elem gs x) (elem fs i) := by
  unfold Separate
  rw [SelectedStepGsCopy194.gs_offset x,fs_offset i]
  change 31≠31 ∨ (0+4*(2206+x))+4≤0+4*(1694+i) ∨ (0+4*(1694+i))+4≤0+4*(2206+x)
  omega

theorem gs_fd_separate (x v : Nat) (bx : x<512) (bv : v<256) : Separate (elem gs x) (addr fd 0 v 2) := by
  unfold Separate
  rw [SelectedStepGsCopy194.gs_offset x,fd_offset v]
  change 31≠31 ∨ (0+4*(2206+x))+4≤0+4*(670+0+v*2) ∨ (0+4*(670+0+v*2))+4≤0+4*(2206+x)
  omega

theorem gs_walk_fs_separate (x i : Nat) (bx : x<512) (bi : i<512) :
    Separate (walk (addr gs 0 0 1) x 1) (elem fs i) := by
  rw [SelectedStepGsInverse194.walk_gs x]
  exact gs_fs_separate x i bx bi

theorem gs_walk_fd_separate (x v : Nat) (bx : x<512) (bv : v<256) :
    Separate (walk (addr gs 0 0 1) x 1) (addr fd 0 v 2) := by
  rw [SelectedStepGsInverse194.walk_gs x]
  exact gs_fd_separate x v bx bv

/- The s6 product step with the per-cell bystander keep: the wrapper of
   SelectedStepGsProduct194.source with StepGsProductKeepCell194 and the
   two extra conclusions (the bystander keep and the writable transport). -/
theorem product_cell (start : State) (gvs tws : Nat → BitVec 32)
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
      (∀ name : Name, name≠"x".toList → out.arrays name=start.arrays name) ∧
      (∀ r : ArrayPointer, (∀ x : Nat, x<256 → Separate (addr gd 0 x 2) r) →
        ∀ w : BitVec 32, Load32 start.heap r w → Load32 out.heap r w) ∧
      out.heap.writable=start.heap.writable := by
  have allocated : Allocated start.heap (elem t1 0) :=
    SelectedStepGsProduct194.load_allocated (t1Image ⟨0,by decide⟩)
  have put : C99ModularReference.Exec MakeFgGsShape194.productInitGdCode start
      ⟨SelectedStepGsProduct194.mid start,.normal⟩ :=
    SelectedStepGsProduct194.product_init start vCell uCell gdBinding
  have initRun : Exec MakeFgGsShape194.productInitGd start
      ⟨SelectedStepGsProduct194.mid start,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ put)
  have midFixed : FixedGd (SelectedStepGsProduct194.mid start) gd t1 0 2 256 p p0i r2 gvs := by
    refine ⟨by decide,by decide,by decide,by decide,by decide,by decide,?_,?_,?_,?_,?_,?_,?_,
      ?_,?_,?_,?_,?_⟩
    · rw [SelectedStepGsProduct194.mid_heap]
      exact gdWritable
    · rw [SelectedStepGsProduct194.mid_arrays start "gd".toList (by decide)]
      exact gdBinding
    · rw [SelectedStepGsProduct194.mid_arrays start "t1".toList (by decide)]
      exact t1Binding
    · exact (SelectedStepGsProduct194.mid_locals start "hn".toList (by decide)).trans hnCell
    · exact (SelectedStepGsProduct194.mid_locals start "tlen".toList (by decide)).trans tlenCell
    · exact (SelectedStepGsProduct194.mid_locals start "p".toList (by decide)).trans pCell
    · exact (SelectedStepGsProduct194.mid_locals start "p0i".toList (by decide)).trans iCell
    · exact (SelectedStepGsProduct194.mid_locals start "R2".toList (by decide)).trans r2Cell
    · intro i
      rw [SelectedStepGsProduct194.mid_heap]
      exact SelectedStepGsProduct194.gd_allocated start i.val i.isLt allocated
    · exact SelectedStepGsProduct194.dst_src_separate
    · exact SelectedStepGsProduct194.dst_separate
    · intro i
      rw [SelectedStepGsProduct194.mid_heap]
      exact t1Image i
  have midV : Cell (SelectedStepGsProduct194.mid start) "v".toList 0 :=
    FftLocalCells140.cell_at start "v".toList (C99NatWord141.word 0)
  have midX : (SelectedStepGsProduct194.mid start).arrays "x".toList=some (addr gd 0 0 2) := rfl
  have midImage : Image (SelectedStepGsProduct194.mid start) gd 0 2 256 p p0i r2 gvs 0 :=
    StepProductFixed191.empty_image (SelectedStepGsProduct194.mid start) gd 0 2 256 p p0i r2 gvs
  have midReadsGs : Reads (SelectedStepGsProduct194.mid start) gs 512 gvs := by
    intro k bound
    rw [SelectedStepGsProduct194.mid_heap]
    exact gsReads k bound
  have midReadsIgm : Reads (SelectedStepGsProduct194.mid start) igm 512 tws := by
    intro k bound
    rw [SelectedStepGsProduct194.mid_heap]
    exact igmReads k bound
  obtain ⟨out,loopRun,outFixed,outV,outX,outImage,outLocals,outArrays,outReadsGs,outReadsIgm,
      outKeep,outWritable⟩ :=
    StepGsProductKeepCell194.source (SelectedStepGsProduct194.mid start) gd t1 0 2 256 p p0i r2
      gvs midFixed midV midX midImage
      gs 512 gvs midReadsGs (fun i k _ => SelectedStepGsProduct194.gd_gs_separate i k)
      igm 512 tws midReadsIgm (fun i k _ => SelectedStepGsProduct194.gd_igm_separate i k)
  have whole : Exec MakeFgTailShape190.s6 start ⟨out,.normal⟩ := by
    rw [MakeFgGsShape194.s6_shape]
    exact .seqNormal _ _ start (SelectedStepGsProduct194.mid start) ⟨out,.normal⟩ initRun loopRun
  refine ⟨out,whole,outFixed,outV,outX,outImage,outReadsGs,outReadsIgm,?_,?_,?_,?_⟩
  · intro name different
    exact (outLocals name different).trans
      (SelectedStepGsProduct194.mid_locals start name different)
  · intro name different
    exact (outArrays name different).trans
      (SelectedStepGsProduct194.mid_arrays start name different)
  · intro r apart w load
    exact outKeep r apart w (by rw [SelectedStepGsProduct194.mid_heap]; exact load)
  · exact outWritable.trans (by rw [SelectedStepGsProduct194.mid_heap])

/- The s0-s7 chain with the bystander keeps: the fs transformed words and
   the fd written image at the assembled s0-s3 state survive the s4 copy
   writes and the s6 product writes through the per-cell keeps, and the s7
   gs inverse through the SelectedStepInverseKeep194 keep. -/
theorem chain_keep : ∃ (start final : State),
    Exec SelectedStepChain193.tailPrefix base ⟨start,.normal⟩ ∧
    Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ ∧
    LocalsFrame final ∧
    final.locals "out_ntt".toList=some (.int32,some (.int32 1)) ∧
    (∀ i : Fin 512, Load32 final.heap (elem fs i.val)
      (scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    Image final fd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepProduct191.fvs 256 ∧
    final.heap.writable t1.block=true := by
  obtain ⟨_,_,start,_,_,_,_,prefixRun,fsImageStart,fdImageStart,
    gsImageStart,igmReadsStart,vOldStart,localsKeepStart,arraysKeepStart,writableStart⟩ :=
    SelectedStepChainKeep194.source
  obtain ⟨vOld,vDeclared⟩ := vOldStart
  have nCell : Cell start "n".toList 512 :=
    (localsKeepStart "n".toList (by decide)).trans (by exact SelectedGen0Ready189.n_cell)
  have slenCell : Cell start "slen".toList 1 :=
    (localsKeepStart "slen".toList (by decide)).trans (by exact SelectedGen0Ready189.slen_cell)
  have uCell : Cell start "u".toList 0 :=
    (localsKeepStart "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have hnCell : Cell start "hn".toList 256 :=
    (localsKeepStart "hn".toList (by decide)).trans (by exact SelectedGen0Ready189.hn_cell)
  have tlenCell : Cell start "tlen".toList 2 :=
    (localsKeepStart "tlen".toList (by decide)).trans (by exact SelectedGen0Ready189.tlen_cell)
  have lognCell : Slot start "logn" 9 :=
    (localsKeepStart "logn".toList (by decide)).trans (by exact SelectedGen0Ready189.logn_cell)
  have terCell : Slot start "ter" 1 :=
    (localsKeepStart "ter".toList (by decide)).trans (by exact SelectedGen0Ready189.ternary_cell)
  have inNttCell : start.locals "in_ntt".toList=some (.int32,some (.int32 1)) :=
    (localsKeepStart "in_ntt".toList (by decide)).trans
      (by exact SelectedGen0Ready189.in_ntt_cell)
  have pCell : Slot start "p" SelectedTopInit178.p :=
    (localsKeepStart "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have iCell : Slot start "p0i" SelectedTopInit178.p0i :=
    (localsKeepStart "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have r2Cell : Slot start "R2" SelectedTopInit178.r2 :=
    (localsKeepStart "R2".toList (by decide)).trans (by exact SelectedGen0Ready189.r2_cell)
  have gsBinding : start.arrays "gs".toList=some gs :=
    (arraysKeepStart "gs".toList (by decide)).trans (by exact SelectedGen0Ready189.gs_binding)
  have gdBinding : start.arrays "gd".toList=some gd :=
    (arraysKeepStart "gd".toList (by decide)).trans (by exact SelectedGen0Ready189.gd_binding)
  have t1Binding : start.arrays "t1".toList=some t1 :=
    (arraysKeepStart "t1".toList (by decide)).trans (by exact SelectedGen0Ready189.t1_binding)
  have igmBinding : start.arrays "igm".toList=some igm :=
    (arraysKeepStart "igm".toList (by decide)).trans (by exact SelectedGen0Ready189.igm_binding)
  have initRun : Exec MakeFgGsShape194.copyInitGs start
      ⟨SelectedStepGsCopy194.mid start,.normal⟩ :=
    SelectedStepGsChain194.init_gs start vOld vDeclared uCell gsBinding
  obtain ⟨copyOut,loopRun,fixedRun,vRun,xRun,prefixImgRun,localRun,arrayRun,igmRun,copyKeep,
      copyWritable⟩ :=
    StepGsCopyKeepCell194.source (SelectedStepGsCopy194.mid start) gs t1 0 1 512
      (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val)
      (SelectedStepGsCopy194.mid_fixed start (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val)
        gsImageStart nCell slenCell t1Binding gsBinding writableStart)
      (SelectedStepGsCopy194.mid_v start) (SelectedStepGsCopy194.mid_x start)
      (SelectedStepGsCopy194.mid_copied start (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val))
      igm 512 SelectedStepChain193.tws
      (SelectedStepGsCopy194.mid_igm start SelectedStepChain193.tws igmReadsStart)
      (fun i k bound => SelectedStepGsCopy194.t1_igm_separate i.val k bound)
  have s4Run : Exec MakeFgTailShape190.s4 start ⟨copyOut,.normal⟩ := by
    rw [MakeFgGsShape194.s4_shape]
    exact .seqNormal _ _ start (SelectedStepGsCopy194.mid start) ⟨copyOut,.normal⟩ initRun loopRun
  have s5Run : Exec MakeFgTailShape190.s5 copyOut ⟨copyOut,.normal⟩ :=
    SelectedStepGsCopy194.skip_source start copyOut
      (fun name different => (localRun name different).trans
        (SelectedStepGsCopy194.mid_locals start name different)) inNttCell
  have copyLocalsBase : ∀ name : Name, name≠"v".toList →
      copyOut.locals name=SelectedStepProduct191.base.locals name := by
    intro name different
    exact (localRun name different).trans
      ((SelectedStepGsCopy194.mid_locals start name different).trans (localsKeepStart name different))
  have copyArraysBase : ∀ name : Name, name≠"x".toList →
      copyOut.arrays name=SelectedStepProduct191.base.arrays name := by
    intro name different
    exact (arrayRun name different).trans
      ((SelectedStepGsCopy194.mid_arrays start name different).trans (arraysKeepStart name different))
  have copyU : Cell copyOut "u".toList 0 :=
    (copyLocalsBase "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have copyHn : Cell copyOut "hn".toList 256 :=
    (copyLocalsBase "hn".toList (by decide)).trans (by exact SelectedGen0Ready189.hn_cell)
  have copyTlen : Cell copyOut "tlen".toList 2 :=
    (copyLocalsBase "tlen".toList (by decide)).trans (by exact SelectedGen0Ready189.tlen_cell)
  have copyP : Slot copyOut "p" SelectedTopInit178.p :=
    (copyLocalsBase "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have copyI : Slot copyOut "p0i" SelectedTopInit178.p0i :=
    (copyLocalsBase "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have copyR2 : Slot copyOut "R2" SelectedTopInit178.r2 :=
    (copyLocalsBase "R2".toList (by decide)).trans (by exact SelectedGen0Ready189.r2_cell)
  have copyGd : copyOut.arrays "gd".toList=some gd :=
    (copyArraysBase "gd".toList (by decide)).trans (by exact SelectedGen0Ready189.gd_binding)
  have copyT1 : copyOut.arrays "t1".toList=some t1 :=
    (copyArraysBase "t1".toList (by decide)).trans (by exact SelectedGen0Ready189.t1_binding)
  have copyT1Image : ∀ i : Fin 512, Load32 copyOut.heap (elem t1 i.val)
      (SelectedStepChainKeep194.gvs i.val) :=
    fun i => prefixImgRun i i.isLt
  have copyGsReads : ∀ k : Nat, k<512 →
      Load32 copyOut.heap ({gs with index := gs.index+k}) (SelectedStepChainKeep194.gvs k) := by
    intro k bound
    have read := fixedRun.src ⟨k,bound⟩
    rw [SelectedStepGsCopy194.addr_gs k] at read
    exact read
  have copyGdWritable : copyOut.heap.writable gd.block=true := fixedRun.t1Writable
  have copyMidWritable : copyOut.heap.writable=start.heap.writable :=
    copyWritable.trans (by rw [SelectedStepGsCopy194.mid_heap])
  obtain ⟨prodOut,s6Run,outFixed,outV,outX,outImage,outReadsGs,outReadsIgm,prodLocals,
      prodArrays,prodKeep,prodWritable⟩ :=
    product_cell copyOut SelectedStepChainKeep194.gvs SelectedStepChain193.tws
      copyT1Image copyGsReads igmRun vRun copyU copyHn copyTlen copyP copyI copyR2 copyGd copyT1
      copyGdWritable
  have prodLocalsBase : ∀ name : Name, name≠"v".toList →
      prodOut.locals name=SelectedStepProduct191.base.locals name := by
    intro name different
    exact (prodLocals name different).trans (copyLocalsBase name different)
  have prodArraysBase : ∀ name : Name, name≠"x".toList →
      prodOut.arrays name=SelectedStepProduct191.base.arrays name := by
    intro name different
    exact (prodArrays name different).trans (copyArraysBase name different)
  have prodU : Cell prodOut "u".toList 0 :=
    (prodLocalsBase "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have prodSlen : USlot prodOut "slen" 1 :=
    (prodLocalsBase "slen".toList (by decide)).trans (by exact SelectedGen0Ready189.slen_cell)
  have prodLogn : Slot prodOut "logn" 9 :=
    (prodLocalsBase "logn".toList (by decide)).trans (by exact SelectedGen0Ready189.logn_cell)
  have prodTer : Slot prodOut "ter" 1 :=
    (prodLocalsBase "ter".toList (by decide)).trans (by exact SelectedGen0Ready189.ternary_cell)
  have prodInNtt : prodOut.locals "in_ntt".toList=some (.int32,some (.int32 1)) :=
    (prodLocalsBase "in_ntt".toList (by decide)).trans
      (by exact SelectedGen0Ready189.in_ntt_cell)
  have prodP : Slot prodOut "p" SelectedTopInit178.p :=
    (prodLocalsBase "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have prodI : Slot prodOut "p0i" SelectedTopInit178.p0i :=
    (prodLocalsBase "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have prodGs : prodOut.arrays "gs".toList=some gs :=
    (prodArraysBase "gs".toList (by decide)).trans (by exact SelectedGen0Ready189.gs_binding)
  have prodIgm : prodOut.arrays "igm".toList=some igm :=
    (prodArraysBase "igm".toList (by decide)).trans (by exact SelectedGen0Ready189.igm_binding)
  have prodGsWritable : prodOut.heap.writable gs.block=true := outFixed.gdWritable
  have prodGsCapacity : (addr gs 0 0 1).index + 512 ≤ (addr gs 0 0 1).count := by decide
  have prodIgmCapacity : igm.index + 512 ≤ igm.count := by decide
  have prodGsSeparate : ∀ j k : Nat, j<512 → k<512 → j≠k →
      Separate (walk (addr gs 0 0 1) j 1) (walk (addr gs 0 0 1) k 1) := by
    intro j k bj bk different
    rw [SelectedStepGsInverse194.walk_gs j,SelectedStepGsInverse194.walk_gs k]
    exact SelectedStepGsCopy194.gs_elem_separate j k different
  have prodTwSeparate : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (walk (addr gs 0 0 1) j 1) ({igm with index := igm.index+k}) := by
    intro k bk j bj
    rw [SelectedStepGsInverse194.walk_gs j]
    exact SelectedStepGsChain194.gs_igm_separate j k bj bk
  have prodGsImage : ∀ i : Fin 512, Load32 prodOut.heap (elem gs i.val)
      (SelectedStepChainKeep194.gvs i.val) := by
    intro i
    exact outReadsGs i.val i.isLt
  obtain ⟨final,s7Run,finalImage,finalLocals,finalArrays,s7Keep,s7Writable⟩ :=
    SelectedStepInverseKeep194.gs_source prodOut SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedStepChainKeep194.gvs SelectedStepChain193.tws
      prodU prodSlen prodLogn prodTer prodInNtt prodP prodI prodGs prodIgm prodGsWritable
      prodGsCapacity prodIgmCapacity prodGsSeparate prodTwSeparate outReadsIgm prodGsImage
      prodLocalsBase prodArraysBase
  have gsRun : Exec SelectedStepGsChain194.gsPrefix start ⟨final,.normal⟩ :=
    .seqNormal _ _ start copyOut ⟨final,.normal⟩ s4Run
      (.seqNormal _ _ copyOut copyOut ⟨final,.normal⟩ s5Run
        (.seqNormal _ _ copyOut prodOut ⟨final,.normal⟩ s6Run s7Run))
  have wholeRun : Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ :=
    .seqNormal _ _ base start ⟨final,.normal⟩ prefixRun gsRun
  have finalFs : ∀ i : Fin 512, Load32 final.heap (elem fs i.val)
      (scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val) := by
    intro i
    exact s7Keep (elem fs i.val) (fun x bx => gs_walk_fs_separate x i.val bx i.isLt)
      (scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)
      (prodKeep (elem fs i.val) (fun x bx => gd_fs_separate x i.val bx i.isLt)
        (scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
          SelectedTopInit178.p SelectedTopInit178.p0i i.val)
        (copyKeep (elem fs i.val) (fun x bx => t1_fs_separate x i.val bx i.isLt)
          (scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
            SelectedTopInit178.p SelectedTopInit178.p0i i.val)
          (by rw [SelectedStepGsCopy194.mid_heap]; exact fsImageStart i)))
  have finalFd : Image final fd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepProduct191.fvs 256 := by
    intro i bound
    have load := fdImageStart i bound
    have kept : Load32 final.heap (addr fd 0 i.val 2)
        (value (SelectedStepProduct191.fvs (2*i.val))
          (SelectedStepProduct191.fvs (2*i.val+1)) SelectedTopInit178.r2
          SelectedTopInit178.p SelectedTopInit178.p0i) :=
      s7Keep (addr fd 0 i.val 2) (fun x bx => gs_walk_fd_separate x i.val bx bound) _
        (prodKeep (addr fd 0 i.val 2) (fun x bx => gd_fd_separate x i.val bx bound) _
          (copyKeep (addr fd 0 i.val 2) (fun x bx => t1_fd_separate x i.val bx bound) _
            (by rw [SelectedStepGsCopy194.mid_heap]; exact load)))
    exact kept
  have finalWritable : final.heap.writable t1.block=true := by
    rw [s7Writable]
    show prodOut.heap.writable t1.block=true
    rw [prodWritable,copyMidWritable]
    exact writableStart
  refine ⟨start,final,prefixRun,wholeRun,finalLocals,?_,finalFs,finalFd,finalWritable⟩
  exact (finalLocals "out_ntt".toList (by decide)).trans
    (by exact SelectedGen0Ready189.out_ntt_cell)

/- The complete exit-state package: the sealed loop-tail export plus the
   fs/fd bystander images, tied to this window's chain run by execution
   determinism of the part-2 statement. -/
theorem source : ∃ (final next : State),
    Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ ∧
    Exec StepPrimeShape188.loop SelectedStepPrime188.initial ⟨next,.normal⟩ ∧
    Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨next,.normal⟩ ∧
    Cell next "u".toList 1 ∧
    Cell next "n".toList 512 ∧
    Cell next "hn".toList 256 ∧
    Cell next "slen".toList 1 ∧
    Cell next "tlen".toList 2 ∧
    Slot next "logn" 9 ∧
    Slot next "ter" 1 ∧
    next.locals "in_ntt".toList=some (.int32,some (.int32 1)) ∧
    next.locals "out_ntt".toList=some (.int32,some (.int32 1)) ∧
    (∀ name : Name, name≠"u".toList → name≠"v".toList → name≠"p".toList →
      name≠"p0i".toList → name≠"R2".toList → next.locals name=SelectedStepProduct191.base.locals name) ∧
    (∀ name : Name, name≠"x".toList → next.arrays name=SelectedStepProduct191.base.arrays name) ∧
    next.arrays "x".toList=SelectedStepPrime188.initial.arrays "x".toList ∧
    (∀ i : Fin 512, Load32 next.heap (elem fs i.val)
      (scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    Image next fd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepProduct191.fvs 256 ∧
    (∀ i : Fin 512, Load32 next.heap (elem gs i.val)
      (scaledWord SelectedStepChainKeep194.gvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    Image next gd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepChainKeep194.gvs 256 ∧
    next.heap.writable t1.block=true := by
  obtain ⟨_,finalF,_,wholeRunF,finalLocalsF,outNttF,finalFsF,finalFdF,finalWritableF⟩ := chain_keep
  have bodyRunF : Exec StepPrimeShape188.body SelectedStepPrime188.initial
      ⟨SelectedStepLoopTail194.bodyOut finalF,.normal⟩ := by
    rw [StepPrimeShape188.body_shape]
    exact .scope _ _ _ SelectedStepPrime188.initial ⟨finalF,.normal⟩
      (SelectedGen0Call189.continue_inner ⟨finalF,.normal⟩
        (SelectedStepLoopTail194.tail_run finalF wholeRunF
          (SelectedStepOutNtt194.source finalF outNttF)))
  have part2RunF : Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after
      ⟨SelectedStepLoopTail194.exit finalF,.normal⟩ := by
    rw [StepPrimeShape188.loop_shape]
    exact .seqNormal _ _ SelectedStepMove187.after (SelectedStepLoopTail194.exit finalF)
      ⟨SelectedStepLoopTail194.exit finalF,.normal⟩
      (.seqNormal _ _ SelectedStepMove187.after SelectedStepPrime188.initial
        ⟨SelectedStepLoopTail194.exit finalF,.normal⟩
        SelectedStepPrime188.initial_source
        (SelectedStepLoopTail194.loop_run finalF finalLocalsF bodyRunF))
      (SelectedStepLoopTail194.skip_run _)
  obtain ⟨final,next,wholeRun,loopRun,part2Run,uExit,nExit,hnExit,slenExit,tlenExit,lognExit,
      terExit,inExit,outExit,localsExit,arraysExit,xFix,gsExit,gdExit⟩ :=
    SelectedStepLoopTail194.source
  have join : (⟨SelectedStepLoopTail194.exit finalF,.normal⟩ : C99ProcedureReference.Result)
      =⟨next,.normal⟩ :=
    KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step)
      (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after
      ⟨SelectedStepLoopTail194.exit finalF,.normal⟩ ⟨next,.normal⟩
      KeygenMakeFgArity099.step2 part2RunF part2Run
  have same : SelectedStepLoopTail194.exit finalF=next :=
    congrArg (fun r : C99ProcedureReference.Result => r.state) join
  refine ⟨final,next,wholeRun,loopRun,part2Run,uExit,nExit,hnExit,slenExit,tlenExit,lognExit,
    terExit,inExit,outExit,localsExit,arraysExit,xFix,?_,?_,gsExit,gdExit,?_⟩
  · intro i
    rw [← same,SelectedStepLoopTail194.exit_heap]
    exact finalFsF i
  · intro i bound
    rw [← same,SelectedStepLoopTail194.exit_heap]
    exact finalFdF i bound
  · rw [← same,SelectedStepLoopTail194.exit_heap]
    exact finalWritableF

end FT1536.Source3.SelectedStepFsFd194
