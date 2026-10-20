import Source3.SelectedStepFsFd194
import Source3.StepCopyKeepCell194
import Source3.StepProductKeepCell194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Transport of the prime table word primes[0].p (the block-21 ternary
   table word SelectedTopInit178.p) to the make_fg_step loop exit state,
   the entry state of both zint_rebuild_CRT calls of part 3. Block 21 is
   readonly and never written by the step: the mkgm3 call keeps it by the
   SelectedGen0Frame189.stable pattern, the s0 copy loop and the s2
   product loop keep it by the per-cell bystander keeps of
   StepCopyKeepCell194 / StepProductKeepCell194, the s3 inverse call by
   the SelectedStepInverseKeep194.fs_source keep, the s4/s6 loops by the
   per-cell keeps of StepGsCopyKeepCell194 / StepGsProductKeepCell194
   (through SelectedStepFsFd194.product_cell), the s7 inverse by the
   SelectedStepInverseKeep194.gs_source keep, and the s8-true branch, the
   loop tail and the part-2 statement are heap-free. The run is tied to
   the exit state by the KeygenMakeFgDeterminism099 execution determinism
   of part .step 2. Export: the table word as an executed load at the
   loop exit state, and its transport into the zint_rebuild_CRT entry
   heap (the bind chain keeps the heap). Values stay executed words: no
   table law, transform property, root law or positivity claim. -/
namespace FT1536.Source3.SelectedStepCrtWord194
open C99ArrayReference (State Name Pointer bindPointer Arg)
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
open KeygenFullData127 (primes)

noncomputable abbrev base : State := SelectedGen0Call189.after

/- The consumed table word cell: primes[0].p of the block-21 ternary
   table, read by the storePrime of the zint_rebuild_CRT body. -/
def primeCell : ArrayPointer := KeygenLevelCalls.fieldPointer primes .p

theorem prime_cell_block : primeCell.block=21 := rfl

theorem separate_prime (q : ArrayPointer) (block : q.block=31) : Separate q primeCell := by
  unfold Separate
  rw [block,prime_cell_block]
  exact Or.inl (by decide)

theorem elem_block (q : ArrayPointer) (i : Nat) : (elem q i).block=q.block := rfl
theorem addr_block (q : ArrayPointer) (u0 i slen : Nat) : (addr q u0 i slen).block=q.block := rfl
theorem walk_block (q : ArrayPointer) (i stride : Nat) : (walk q i stride).block=q.block := rfl

theorem fd_block : fd.block=31 := rfl
theorem gd_block : gd.block=31 := rfl
theorem fs_block : fs.block=31 := rfl
theorem gs_block : gs.block=31 := rfl
theorem t1_block : t1.block=31 := rfl

theorem t1_prime (i : Nat) : Separate (elem t1 i) primeCell :=
  separate_prime _ ((elem_block t1 i).trans t1_block)
theorem fd_prime (v : Nat) : Separate (addr fd 0 v 2) primeCell :=
  separate_prime _ ((addr_block fd 0 v 2).trans fd_block)
theorem gd_prime (x : Nat) : Separate (addr gd 0 x 2) primeCell :=
  separate_prime _ ((addr_block gd 0 x 2).trans gd_block)
theorem fs_walk_prime (x : Nat) : Separate (walk (addr fs 0 0 1) x 1) primeCell :=
  separate_prime _ (((walk_block (addr fs 0 0 1) x 1).trans (addr_block fs 0 0 1)).trans fs_block)
theorem gs_walk_prime (x : Nat) : Separate (walk (addr gs 0 0 1) x 1) primeCell :=
  separate_prime _ (((walk_block (addr gs 0 0 1) x 1).trans (addr_block gs 0 0 1)).trans gs_block)

/- The word at the body input state (the SelectedStepPrime188.p_bytes
   load) survives the heap-free p/p0i/R2 prefix and the mkgm3 call. -/
theorem prime_at_base : Load32 base.heap primeCell SelectedTopInit178.p := by
  have read : Load32 SelectedStepPrime188.declared.heap primeCell SelectedTopInit178.p := by
    change Load32 SelectedStepPrime188.declared.heap
      (KeygenLevelCalls.fieldPointer primes .p) SelectedTopInit178.p
    exact SelectedStepPrime188.p_bytes
  have prefixHeap : SelectedStepPrime188.declared.heap=SelectedGen0Call189.before.heap := by
    rfl
  have before : Load32 SelectedGen0Call189.before.heap primeCell SelectedTopInit178.p := by
    rw [← prefixHeap]
    exact read
  refine Gate00Memory.load32_transport SelectedGen0Call189.before.heap
    SelectedGen0Call189.after.heap primeCell SelectedTopInit178.p before
    SelectedGen0Frame189.stable.size ?_
  intro i
  have keep := SelectedGen0Frame189.bytes 21 (primeCell.offset+i.val) (Or.inl (by decide))
  exact keep

/- The s0-s7 chain with the prime word threaded through every keep. -/
theorem chain_prime : ∃ (start final : State),
    Exec SelectedStepChain193.tailPrefix base ⟨start,.normal⟩ ∧
    Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ ∧
    LocalsFrame final ∧
    final.locals "out_ntt".toList=some (.int32,some (.int32 1)) ∧
    Load32 final.heap primeCell SelectedTopInit178.p := by
  -- s0: the fs-to-t1 copy loop with the per-cell bystander keep
  have vacuousReads (s : State) : Reads s primeCell 0 (fun _ => SelectedTopInit178.p) :=
    fun k bound => absurd bound (by omega)
  have vacuousSeparateCopy : ∀ i : Fin 512, ∀ k : Nat, k<0 →
      Separate (elem t1 i.val) ({primeCell with index := primeCell.index+k}) :=
    fun _ k bound => absurd bound (by omega)
  obtain ⟨copyOut,copyLoopRun,copyFixed,copyV,copyX,copyPrefix,copyLocals,copyArrays,
    copyVacuous,copyKeep,copyWritable⟩ :=
    StepCopyKeepCell194.source SelectedStepCopy190.mid fs t1 0 1 512 SelectedStepCopy190.fv
      SelectedStepCopy190.mid_fixed SelectedStepCopy190.mid_v SelectedStepCopy190.mid_x
      SelectedStepCopy190.mid_copied primeCell 0 (fun _ => SelectedTopInit178.p)
      (vacuousReads SelectedStepCopy190.mid) vacuousSeparateCopy
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
  have copyPrime : Load32 copyOut.heap primeCell SelectedTopInit178.p :=
    copyKeep primeCell (fun x _ => t1_prime x) SelectedTopInit178.p
      (by rw [SelectedStepCopy190.mid_heap]; exact prime_at_base)
  have copyGs : ∀ k : Nat, k<512 →
      Load32 copyOut.heap ({gs with index := gs.index+k}) (SelectedStepChainKeep194.gvs k) := by
    intro k bound
    exact copyKeep ({gs with index := gs.index+k})
      (fun x _ => SelectedStepChainKeep194.t1_gs_separate x k bound)
      (SelectedStepChainKeep194.gvs k)
      (by rw [SelectedStepCopy190.mid_heap]; exact SelectedStepChainKeep194.gvs_read k bound)
  have copyIgm : ∀ k : Nat, k<512 →
      Load32 copyOut.heap ({igm with index := igm.index+k}) (SelectedStepChain193.tws k) := by
    intro k bound
    exact copyKeep ({igm with index := igm.index+k})
      (fun x _ => SelectedStepChain193.t1_igm_separate x k bound)
      (SelectedStepChain193.tws k)
      (by rw [SelectedStepCopy190.mid_heap]; exact SelectedStepChain193.tws_read k bound)
  have copyAllocated : Allocated copyOut.heap (elem t1 0) := copyFixed.t1Allocated ⟨0,by decide⟩
  have uCell : Cell copyOut "u".toList 0 :=
    (copyLocalsBase "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have fdBinding : copyOut.arrays "fd".toList=some fd :=
    (copyArraysBase "fd".toList (by decide)).trans (by exact SelectedGen0Ready189.fd_binding)
  have t1Binding : copyOut.arrays "t1".toList=some t1 :=
    (copyArraysBase "t1".toList (by decide)).trans (by exact SelectedGen0Ready189.t1_binding)
  have gsBinding : copyOut.arrays "gs".toList=some gs :=
    (copyArraysBase "gs".toList (by decide)).trans (by exact SelectedGen0Ready189.gs_binding)
  have igmBinding : copyOut.arrays "igm".toList=some igm :=
    (copyArraysBase "igm".toList (by decide)).trans (by exact SelectedGen0Ready189.igm_binding)
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
  -- s2: the fd pair-product loop with the per-cell bystander keep
  have initRun : C99ModularReference.Exec MakeFgProductShape191.productInitCode copyOut
      ⟨bindPointer (FftLocalCells140.put copyOut "v".toList (C99NatWord141.word 0))
        "x".toList (addr fd 0 0 2),.normal⟩ :=
    SelectedStepChain193.product_init copyOut copyV uCell fdBinding
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
  have vacuousSeparateProduct : ∀ i : Fin 256, ∀ k : Nat, k<0 →
      Separate (addr fd 0 i.val 2) ({primeCell with index := primeCell.index+k}) :=
    fun _ k bound => absurd bound (by omega)
  obtain ⟨out,loopRun,outFixed,outV,outX,outImage,outLocals,outArrays,outVacuousA,outVacuousB,
    outKeep,outWritable⟩ :=
    StepProductKeepCell194.source mid2 fd t1 0 2 256
      SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2 SelectedStepProduct191.fvs
      midFixed midV midX midImage
      primeCell 0 (fun _ => SelectedTopInit178.p) (vacuousReads mid2) vacuousSeparateProduct
      primeCell 0 (fun _ => SelectedTopInit178.p) (vacuousReads mid2) vacuousSeparateProduct
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
  have outPrime : Load32 out.heap primeCell SelectedTopInit178.p :=
    outKeep primeCell (fun x _ => fd_prime x) SelectedTopInit178.p
      (by rw [midEq]; exact copyPrime)
  have outGs : ∀ k : Nat, k<512 →
      Load32 out.heap ({gs with index := gs.index+k}) (SelectedStepChainKeep194.gvs k) := by
    intro k bound
    exact outKeep ({gs with index := gs.index+k})
      (fun x hx => SelectedStepChainKeep194.fd_gs_separate x k hx)
      (SelectedStepChainKeep194.gvs k)
      (by rw [midEq]; exact copyGs k bound)
  have outIgm : ∀ k : Nat, k<512 →
      Load32 out.heap ({igm with index := igm.index+k}) (SelectedStepChain193.tws k) := by
    intro k bound
    exact outKeep ({igm with index := igm.index+k})
      (fun x hx => SelectedStepChain193.fd_igm_separate x k hx)
      (SelectedStepChain193.tws k)
      (by rw [midEq]; exact copyIgm k bound)
  have outFs : ∀ i : Fin 512,
      Load32 out.heap (elem fs i.val) (SelectedStepProduct191.fvs i.val) := by
    intro i
    have read : Load32 mid2.heap ({fs with index := fs.index+i.val})
        (SelectedStepProduct191.fvs i.val) := by
      rw [midEq]
      have source := copyFixed.src ⟨i.val,i.isLt⟩
      rw [SelectedStepCopy190.addr_zero_one fs i.val] at source
      rw [← SelectedStepProduct191.fvs_read i.val i.isLt] at source
      exact source
    exact outKeep ({fs with index := fs.index+i.val})
      (fun x hx => SelectedStepChain193.fd_fs_separate x i.val hx)
      (SelectedStepProduct191.fvs i.val) read
  -- s3: the fs inverse call with the whole-inverse bystander keep
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
    exact SelectedStepChain193.fs_fs_separate j k different
  have twSeparateOut : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (NttInverseCorrectionLoop192.walk (addr fs 0 0 1) j 1)
        ({igm with index := igm.index+k}) := by
    intro k bk j bj
    rw [SelectedStepInverse192.walk_fs j]
    exact SelectedStepChain193.fs_igm_separate j k bj
  have twLoadsOut : ∀ k : Nat, k<512 →
      Load32 out.heap ({igm with index := igm.index+k}) (SelectedStepChain193.tws k) := outIgm
  have fsImageOut : ∀ i : Fin 512, Load32 out.heap (elem fs i.val)
      (SelectedStepProduct191.fvs i.val) := outFs
  have localsKeepOut : ∀ name : Name, name≠"v".toList →
      out.locals name=SelectedStepProduct191.base.locals name := outLocalsBase
  have arraysKeepOut : ∀ name : Name, name≠"x".toList →
      out.arrays name=SelectedStepProduct191.base.arrays name := outArraysBase
  obtain ⟨start,s3Run,s3Image,s3Locals,s3Arrays,s3Keep,s3Writable⟩ :=
    SelectedStepInverseKeep194.fs_source out SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedStepChain193.tws uCellOut slenCellOut lognCellOut terCellOut inNttCellOut pcOut
      icOut fsBindingOut igmBindingOut fsWritableOut fsCapacityOut igmCapacityOut fsSeparateOut
      twSeparateOut twLoadsOut fsImageOut localsKeepOut arraysKeepOut
  have prefixRun : Exec SelectedStepChain193.tailPrefix base ⟨start,.normal⟩ :=
    .seqNormal _ _ base copyOut ⟨start,.normal⟩ s0Run
      (.seqNormal _ _ copyOut copyOut ⟨start,.normal⟩ skipRun
        (.seqNormal _ _ copyOut out ⟨start,.normal⟩ productRun s3Run))
  have startPrime : Load32 start.heap primeCell SelectedTopInit178.p :=
    s3Keep primeCell (fun x _ => fs_walk_prime x) SelectedTopInit178.p outPrime
  have startGs : ∀ i : Fin 512,
      Load32 start.heap (elem gs i.val) (SelectedStepChainKeep194.gvs i.val) := by
    intro i
    exact s3Keep (elem gs i.val)
      (fun x bound2 => SelectedStepChainKeep194.fs_gs_walk x i.val bound2)
      (SelectedStepChainKeep194.gvs i.val) (outGs i.val i.isLt)
  have startIgm : ∀ k : Nat, k<512 →
      Load32 start.heap ({igm with index := igm.index+k}) (SelectedStepChain193.tws k) := by
    intro k bound
    exact s3Keep ({igm with index := igm.index+k})
      (fun x bound2 => SelectedStepChainKeep194.fs_igm_walk x k bound2)
      (SelectedStepChain193.tws k) (outIgm k bound)
  -- s4: the gs-to-t1 copy loop with the per-cell bystander keep
  have startLocalsBase : ∀ name : Name, name≠"v".toList →
      start.locals name=SelectedStepProduct191.base.locals name := s3Locals
  have startArraysBase : ∀ name : Name, name≠"x".toList →
      start.arrays name=SelectedStepProduct191.base.arrays name := s3Arrays
  have nCell : Cell start "n".toList 512 :=
    (startLocalsBase "n".toList (by decide)).trans (by exact SelectedGen0Ready189.n_cell)
  have slenCell : Cell start "slen".toList 1 :=
    (startLocalsBase "slen".toList (by decide)).trans (by exact SelectedGen0Ready189.slen_cell)
  have vOld : ∃ vOld : Option C99IntegerReference.Value,
      start.locals "v".toList=some (.uint64,vOld) := by
    refine ⟨some (.uint64 (C99NatWord141.word 256)),?_⟩
    have first : start.locals "v".toList=out.locals "v".toList :=
      congrFun (SelectedStepChainKeep194.localSafe_result MakeFgTailShape190.s3 out
        ⟨start,.normal⟩ (by decide) s3Run) "v".toList
    have last : out.locals "v".toList=some (.uint64,some (.uint64 (C99NatWord141.word 256))) := outV
    exact first.trans last
  have vDeclared : start.locals "v".toList=some (.uint64,vOld.choose) := vOld.choose_spec
  have uCellStart : Cell start "u".toList 0 :=
    (startLocalsBase "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have gsBindingStart : start.arrays "gs".toList=some gs :=
    (startArraysBase "gs".toList (by decide)).trans (by exact SelectedGen0Ready189.gs_binding)
  have t1BindingStart : start.arrays "t1".toList=some t1 :=
    (startArraysBase "t1".toList (by decide)).trans (by exact SelectedGen0Ready189.t1_binding)
  have writableStart : start.heap.writable t1.block=true := by
    rw [s3Writable]
    exact outFixed.fdWritable
  have initGs : Exec MakeFgGsShape194.copyInitGs start
      ⟨SelectedStepGsCopy194.mid start,.normal⟩ :=
    SelectedStepGsChain194.init_gs start vOld.choose vDeclared uCellStart gsBindingStart
  obtain ⟨copyOutG,loopRunG,fixedRun,vRun,xRun,prefixImgRun,localRun,arrayRun,vacuousG,
      copyKeepG,copyWritableG⟩ :=
    StepGsCopyKeepCell194.source (SelectedStepGsCopy194.mid start) gs t1 0 1 512
      (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val)
      (SelectedStepGsCopy194.mid_fixed start (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val)
        startGs nCell slenCell t1BindingStart gsBindingStart writableStart)
      (SelectedStepGsCopy194.mid_v start) (SelectedStepGsCopy194.mid_x start)
      (SelectedStepGsCopy194.mid_copied start (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val))
      primeCell 0 (fun _ => SelectedTopInit178.p) (vacuousReads (SelectedStepGsCopy194.mid start))
      (fun (i : Fin 512) (k : Nat) (bound : k<0) => absurd bound (by omega))
  have s4Run : Exec MakeFgTailShape190.s4 start ⟨copyOutG,.normal⟩ := by
    rw [MakeFgGsShape194.s4_shape]
    exact .seqNormal _ _ start (SelectedStepGsCopy194.mid start) ⟨copyOutG,.normal⟩ initGs loopRunG
  have s5Run : Exec MakeFgTailShape190.s5 copyOutG ⟨copyOutG,.normal⟩ :=
    SelectedStepGsCopy194.skip_source start copyOutG
      (fun name different => (localRun name different).trans
        (SelectedStepGsCopy194.mid_locals start name different))
      ((startLocalsBase "in_ntt".toList (by decide)).trans
        (by exact SelectedGen0Ready189.in_ntt_cell))
  have copyPrimeG : Load32 copyOutG.heap primeCell SelectedTopInit178.p :=
    copyKeepG primeCell (fun x _ => t1_prime x) SelectedTopInit178.p
      (by rw [SelectedStepGsCopy194.mid_heap]; exact startPrime)
  have copyGsReads : ∀ k : Nat, k<512 →
      Load32 copyOutG.heap ({gs with index := gs.index+k}) (SelectedStepChainKeep194.gvs k) := by
    intro k bound
    have read := fixedRun.src ⟨k,bound⟩
    rw [SelectedStepGsCopy194.addr_gs k] at read
    exact read
  have copyIgmRun : ∀ k : Nat, k<512 →
      Load32 copyOutG.heap ({igm with index := igm.index+k}) (SelectedStepChain193.tws k) := by
    intro k bound
    exact copyKeepG ({igm with index := igm.index+k})
      (fun x _ => SelectedStepChain193.t1_igm_separate x k bound)
      (SelectedStepChain193.tws k)
      (by rw [SelectedStepGsCopy194.mid_heap]; exact startIgm k bound)
  have copyGdWritable : copyOutG.heap.writable gd.block=true := fixedRun.t1Writable
  have copyMidWritable : copyOutG.heap.writable=start.heap.writable :=
    copyWritableG.trans (by rw [SelectedStepGsCopy194.mid_heap])
  -- s6: the gd pair-product loop through the SelectedStepFsFd194 cell keep
  have copyT1Image : ∀ i : Fin 512, Load32 copyOutG.heap (elem t1 i.val)
      (SelectedStepChainKeep194.gvs i.val) :=
    fun i => prefixImgRun i i.isLt
  obtain ⟨prodOut,s6Run,outFixedG,outV,outX,outImageG,outReadsGs,outReadsIgm,prodLocals,
      prodArrays,prodKeep,prodWritable⟩ :=
    SelectedStepFsFd194.product_cell copyOutG SelectedStepChainKeep194.gvs SelectedStepChain193.tws
      copyT1Image copyGsReads copyIgmRun vRun
      ((localRun "u".toList (by decide)).trans
        ((SelectedStepGsCopy194.mid_locals start "u".toList (by decide)).trans uCellStart))
      ((localRun "hn".toList (by decide)).trans
        ((SelectedStepGsCopy194.mid_locals start "hn".toList (by decide)).trans
          ((startLocalsBase "hn".toList (by decide)).trans
            (by exact SelectedGen0Ready189.hn_cell))))
      ((localRun "tlen".toList (by decide)).trans
        ((SelectedStepGsCopy194.mid_locals start "tlen".toList (by decide)).trans
          ((startLocalsBase "tlen".toList (by decide)).trans
            (by exact SelectedGen0Ready189.tlen_cell))))
      ((localRun "p".toList (by decide)).trans
        ((SelectedStepGsCopy194.mid_locals start "p".toList (by decide)).trans
          ((startLocalsBase "p".toList (by decide)).trans
            (by exact SelectedGen0Ready189.p_cell))))
      ((localRun "p0i".toList (by decide)).trans
        ((SelectedStepGsCopy194.mid_locals start "p0i".toList (by decide)).trans
          ((startLocalsBase "p0i".toList (by decide)).trans
            (by exact SelectedGen0Ready189.i_cell))))
      ((localRun "R2".toList (by decide)).trans
        ((SelectedStepGsCopy194.mid_locals start "R2".toList (by decide)).trans
          ((startLocalsBase "R2".toList (by decide)).trans
            (by exact SelectedGen0Ready189.r2_cell))))
      ((arrayRun "gd".toList (by decide)).trans
        ((SelectedStepGsCopy194.mid_arrays start "gd".toList (by decide)).trans
          ((startArraysBase "gd".toList (by decide)).trans
            (by exact SelectedGen0Ready189.gd_binding))))
      ((arrayRun "t1".toList (by decide)).trans
        ((SelectedStepGsCopy194.mid_arrays start "t1".toList (by decide)).trans t1BindingStart))
      copyGdWritable
  have prodPrime : Load32 prodOut.heap primeCell SelectedTopInit178.p :=
    prodKeep primeCell (fun x _ => gd_prime x) SelectedTopInit178.p copyPrimeG
  -- s7: the gs inverse call with the whole-inverse bystander keep
  have prodLocalsBase : ∀ name : Name, name≠"v".toList →
      prodOut.locals name=SelectedStepProduct191.base.locals name := by
    intro name different
    exact (prodLocals name different).trans
      ((localRun name different).trans
        ((SelectedStepGsCopy194.mid_locals start name different).trans
          (startLocalsBase name different)))
  have prodArraysBase : ∀ name : Name, name≠"x".toList →
      prodOut.arrays name=SelectedStepProduct191.base.arrays name := by
    intro name different
    exact (prodArrays name different).trans
      ((arrayRun name different).trans
        ((SelectedStepGsCopy194.mid_arrays start name different).trans
          (startArraysBase name different)))
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
  have prodGsWritable : prodOut.heap.writable gs.block=true := outFixedG.gdWritable
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
    .seqNormal _ _ start copyOutG ⟨final,.normal⟩ s4Run
      (.seqNormal _ _ copyOutG copyOutG ⟨final,.normal⟩ s5Run
        (.seqNormal _ _ copyOutG prodOut ⟨final,.normal⟩ s6Run s7Run))
  have wholeRun : Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ :=
    .seqNormal _ _ base start ⟨final,.normal⟩ prefixRun gsRun
  have finalPrime : Load32 final.heap primeCell SelectedTopInit178.p :=
    s7Keep primeCell (fun x _ => gs_walk_prime x) SelectedTopInit178.p prodPrime
  have finalLocalsFrame : LocalsFrame final := by
    intro name different
    exact finalLocals name different
  have finalOutNtt : final.locals "out_ntt".toList=some (.int32,some (.int32 1)) :=
    (finalLocalsFrame "out_ntt".toList (by decide)).trans
      (by exact SelectedGen0Ready189.out_ntt_cell)
  exact ⟨start,final,prefixRun,wholeRun,finalLocalsFrame,finalOutNtt,finalPrime⟩

/- The complete prime-word export at the loop exit state, tied to the
   sealed exit package by execution determinism of part .step 2. -/
theorem source : ∃ (final next : State),
    Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ ∧
    Exec StepPrimeShape188.loop SelectedStepPrime188.initial ⟨next,.normal⟩ ∧
    Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨next,.normal⟩ ∧
    Cell next "u".toList 1 ∧
    Load32 next.heap (KeygenLevelCalls.fieldPointer primes .p) SelectedTopInit178.p := by
  obtain ⟨start,final,_,wholeRun,finalLocalsF,outNttF,finalPrimeF⟩ := chain_prime
  have bodyRunF : Exec StepPrimeShape188.body SelectedStepPrime188.initial
      ⟨SelectedStepLoopTail194.bodyOut final,.normal⟩ := by
    rw [StepPrimeShape188.body_shape]
    exact .scope _ _ _ SelectedStepPrime188.initial ⟨final,.normal⟩
      (SelectedGen0Call189.continue_inner ⟨final,.normal⟩
        (SelectedStepLoopTail194.tail_run final wholeRun
          (SelectedStepOutNtt194.source final outNttF)))
  have part2RunF : Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after
      ⟨SelectedStepLoopTail194.exit final,.normal⟩ := by
    rw [StepPrimeShape188.loop_shape]
    exact .seqNormal _ _ SelectedStepMove187.after (SelectedStepLoopTail194.exit final)
      ⟨SelectedStepLoopTail194.exit final,.normal⟩
      (.seqNormal _ _ SelectedStepMove187.after SelectedStepPrime188.initial
        ⟨SelectedStepLoopTail194.exit final,.normal⟩
        SelectedStepPrime188.initial_source
        (SelectedStepLoopTail194.loop_run final finalLocalsF bodyRunF))
      (SelectedStepLoopTail194.skip_run _)
  obtain ⟨_,next,_,loopRun,part2Run,uExit,_,_,_,_,_,_,_,_,_,_,_,_,_⟩ :=
    SelectedStepFsFd194.source
  have join : (⟨SelectedStepLoopTail194.exit final,.normal⟩ : C99ProcedureReference.Result)
      =⟨next,.normal⟩ :=
    KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step)
      (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after
      ⟨SelectedStepLoopTail194.exit final,.normal⟩ ⟨next,.normal⟩
      KeygenMakeFgArity099.step2 part2RunF part2Run
  have same : SelectedStepLoopTail194.exit final=next :=
    congrArg (fun r : C99ProcedureReference.Result => r.state) join
  have exitPrime : Load32 (SelectedStepLoopTail194.exit final).heap
      (KeygenLevelCalls.fieldPointer primes .p) SelectedTopInit178.p := by
    rw [SelectedStepLoopTail194.exit_heap]
    show Load32 final.heap primeCell SelectedTopInit178.p
    exact finalPrimeF
  refine ⟨final,next,wholeRun,loopRun,part2Run,uExit,?_⟩
  rw [← same]
  exact exitPrime

/- Keep form: any part-2 execution of the step carries the table word to
   its exit state, by execution determinism. -/
theorem keep (next : State)
    (run : Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨next,.normal⟩) :
    Load32 next.heap (KeygenLevelCalls.fieldPointer primes .p) SelectedTopInit178.p := by
  obtain ⟨_,nextF,_,_,part2RunF,_,loadF⟩ := source
  have join : (⟨nextF,.normal⟩ : C99ProcedureReference.Result)=⟨next,.normal⟩ :=
    KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step)
      (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after
      ⟨nextF,.normal⟩ ⟨next,.normal⟩ KeygenMakeFgArity099.step2 part2RunF run
  have same : nextF=next :=
    congrArg (fun r : C99ProcedureReference.Result => r.state) join
  rw [← same]
  exact loadF

/- The bind chain of a zint_rebuild_CRT call keeps the heap, so the table
   word is present at the callee entry state (the storePrime consumer). -/
theorem entry_keep (next : State) (args : List Arg) (entry : State)
    (run : Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨next,.normal⟩)
    (binding : C99ArrayReference.Bind next (KeygenZintCall.params .rebuildCrt) args entry) :
    Load32 entry.heap (KeygenLevelCalls.fieldPointer primes .p) SelectedTopInit178.p := by
  rw [C99ArrayReference.bind_heap next (KeygenZintCall.params .rebuildCrt) args entry binding]
  exact keep next run

end FT1536.Source3.SelectedStepCrtWord194
