import Source3.StepGsCopyKeep194
import Source3.MakeFgGsShape194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The gs path copy step (statement s4) and the skipped !in_ntt branch
   (statement s5) of the make_fg_step first-prime tail, executed at an
   arbitrary input state: the original gs-to-t1 copy init (x = gs + u),
   all 512 copy iterations with the exact walked x pointer, the gs source
   image kept as executed load words (StepGsCopyKeep194.FixedGs), the igm
   twiddle reads kept through every copy write for the later gs inverse
   call, and the false !in_ntt guard. The gs source image and the igm
   reads are hypotheses of this stage statement (the assembled s0-s3
   export of SelectedStepChain193 keeps only the fs image and the
   caller frames); values stay executed words and no table or transform
   property is claimed. -/
namespace FT1536.Source3.SelectedStepGsCopy194
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec skip)
open C99LoopScalar141 (Cell)
open SelectedStepLayout187 (gs t1 igm)
open StepCopyBody190 (addr elem)
open StepCopyFixed190 (PrefixImage)
open StepCopyKeep193 (Reads)
open StepGsCopyKeep194 (FixedGs)

theorem gs_offset (i : Nat) : C99MemoryReference.ArrayPointer.offset (elem gs i)=0+4*(2206+i) := rfl
theorem gs_offset_raw (i : Nat) :
    C99MemoryReference.ArrayPointer.offset ({gs with index := gs.index+i})=0+4*(2206+i) := rfl
theorem t1_offset (i : Nat) : C99MemoryReference.ArrayPointer.offset (elem t1 i)=0+4*(3742+i) := rfl
theorem igm_offset (k : Nat) :
    C99MemoryReference.ArrayPointer.offset ({igm with index := igm.index+k})=0+4*(3230+k) := rfl

theorem t1_gs_separate (v i : Fin 512) : Separate (elem t1 v) (addr gs 0 i.val 1) := by
  unfold Separate
  rw [t1_offset v.val]
  change 31≠31 ∨ (0+4*(3742+v.val))+4≤0+4*(2206+(0+i.val)) ∨
    (0+4*(2206+(0+i.val)))+4≤0+4*(3742+v.val)
  omega

theorem t1_igm_separate (i k : Nat) (bound : k<512) :
    Separate (elem t1 i) ({igm with index := igm.index+k}) := by
  unfold Separate
  rw [t1_offset i,igm_offset]
  change 31≠31 ∨ (0+4*(3742+i))+4≤0+4*(3230+k) ∨ (0+4*(3230+k))+4≤0+4*(3742+i)
  omega

theorem gs_elem_separate (j k : Nat) (different : j≠k) : Separate (elem gs j) (elem gs k) := by
  unfold Separate
  rw [gs_offset j,gs_offset k]
  change 31≠31 ∨ (0+4*(2206+j))+4≤0+4*(2206+k) ∨ (0+4*(2206+k))+4≤0+4*(2206+j)
  omega

theorem addr_gs (i : Nat) : addr gs 0 i 1=elem gs i :=
  congrArg (fun k : Nat => {gs with index := k}) (show gs.index+0+i*1=gs.index+i by omega)

theorem load_allocated {h : C99MemoryReference.Memory} {p : ArrayPointer} {w : BitVec 32}
    (read : Load32 h p w) : Allocated h p := by
  cases read with
  | load b allocated width init => exact allocated

theorem allocated_from (s : State) (j : Nat) (bound : j<512) (source : Allocated s.heap (elem gs 0)) :
    Allocated s.heap (elem t1 j) := by
  have sizeLower : 0+4*71680≤s.heap.size 31 := source.2.2.2.1
  have sizeUpper : s.heap.size 31<2^64 := source.2.2.2.2
  refine ⟨?_,?_,?_,sizeLower,sizeUpper⟩
  · change 0<4
    decide
  · change 0%4=0
    decide
  · change 3742+j<71680
    omega

noncomputable def mid (start : State) : State :=
  bindPointer (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
    "x".toList (addr gs 0 0 1)

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
        (C99NatWord141.word 0)) "x".toList (addr gs 0 0 1)).arrays other := rfl
  rw [first]
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ different]
  rfl

theorem mid_heap (start : State) : (mid start).heap=start.heap := rfl

theorem init_source (start : State) (vDeclared : start.locals "v".toList=some (.uint64,none))
    (uCell : Cell start "u".toList 0) (gsBinding : start.arrays "gs".toList=some gs) :
    Exec MakeFgGsShape194.copyInitGs start ⟨mid start,.normal⟩ := by
  have assign : C99ModularReference.Exec
      (.assign "v".toList (.scalar (MakeFgGsShape194.num 0)))
      start ⟨FftLocalCells140.put start "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 none (.int32 0) vDeclared
      (.scalar _ _ (.literal .int32 0))
  have uAfter : Cell (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
      "u".toList 0 :=
    (FftLocalCells140.outside start "v".toList "u".toList (C99NatWord141.word 0) (by decide)).trans
      uCell
  have walked : Pointer (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
      "gs".toList MakeFgGsShape194.varU (addr gs 0 0 1) :=
    .add "gs".toList MakeFgGsShape194.varU gs (addr gs 0 0 1)
      (.uint64 (C99NatWord141.word 0)) gsBinding
      (C99LoopScalar141.read _ _ _ uAfter) (by decide)
      (C99MemoryReference.PointerAdd.within gs 0 (by decide))
  have bind : C99ModularReference.Exec
      (.base (.bindPtr "x".toList "gs".toList MakeFgGsShape194.varU))
      (FftLocalCells140.put start "v".toList (C99NatWord141.word 0)) ⟨mid start,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ walked)
  exact .level _ _ _ (.modular _ _ _ (.seqNormal _ _ _ _ _ assign bind))

theorem mid_fixed (start : State) (gv : Fin 512 → BitVec 32)
    (gsImage : ∀ i : Fin 512, Load32 start.heap (elem gs i.val) (gv i))
    (nCell : Cell start "n".toList 512) (slenCell : Cell start "slen".toList 1)
    (t1Binding : start.arrays "t1".toList=some t1)
    (gsBinding : start.arrays "gs".toList=some gs)
    (t1Writable : start.heap.writable t1.block=true) :
    FixedGs (mid start) gs t1 0 1 512 gv := by
  have allocated : Allocated start.heap (elem gs 0) :=
    load_allocated (gsImage ⟨0,by decide⟩)
  refine ⟨by decide,by decide,by decide,by decide,by decide,by decide,by decide,?_,?_,?_,?_,?_,
    ?_,?_,?_,?_⟩
  · rw [mid_heap]
    exact t1Writable
  · rw [mid_arrays start "gs".toList (by decide)]
    exact gsBinding
  · rw [mid_arrays start "t1".toList (by decide)]
    exact t1Binding
  · exact (mid_locals start "n".toList (by decide)).trans nCell
  · exact (mid_locals start "slen".toList (by decide)).trans slenCell
  · intro i
    rw [mid_heap]
    exact allocated_from start i.val i.isLt allocated
  · intro v i
    exact t1_gs_separate v i
  · intro i j different
    exact StepCopyFixed190.elem_separate t1 rfl i.val j.val (fun equal => different (Fin.ext equal))
  · intro i
    rw [mid_heap,addr_gs i.val]
    exact gsImage i

theorem mid_v (start : State) : Cell (mid start) "v".toList 0 :=
  FftLocalCells140.cell_at start "v".toList (C99NatWord141.word 0)

theorem mid_x (start : State) : (mid start).arrays "x".toList=some (addr gs 0 0 1) := rfl

theorem mid_copied (start : State) (gv : Fin 512 → BitVec 32) :
    PrefixImage (mid start) t1 gv 0 := fun i bound => absurd bound (by omega)

theorem mid_igm (start : State) (tws : Nat → BitVec 32)
    (igmReads : ∀ k : Nat, k<512 → Load32 start.heap ({igm with index := igm.index+k}) (tws k)) :
    Reads (mid start) igm 512 tws := by
  intro k bound
  rw [mid_heap]
  exact igmReads k bound

theorem skip_source (start : State)
    (out : State) (locals : ∀ name : Name, name≠"v".toList → out.locals name=start.locals name)
    (inNttCell : start.locals "in_ntt".toList=some (.int32,some (.int32 1))) :
    Exec MakeFgTailShape190.s5 out ⟨out,.normal⟩ := by
  have cell : out.locals "in_ntt".toList=some (.int32,some (.int32 1)) :=
    (locals "in_ntt".toList (by decide)).trans inNttCell
  have guard : C99ArrayReference.scalar out (CLogic.Expr.lnot MakeFgGsShape194.inNtt) (.int32 0) :=
    by exact .logicalNot _ (.int32 1) (.variable _ _ _ cell)
  have skipped : Exec skip out ⟨out,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip out)))
  rw [MakeFgGsShape194.s5_shape]
  exact .branchFalse _ _ _ out ⟨out,.normal⟩ (.int32 0) guard rfl skipped

theorem source (start : State) (gv : Fin 512 → BitVec 32) (tws : Nat → BitVec 32)
    (gsImage : ∀ i : Fin 512, Load32 start.heap (elem gs i.val) (gv i))
    (igmReads : ∀ k : Nat, k<512 → Load32 start.heap ({igm with index := igm.index+k}) (tws k))
    (vDeclared : start.locals "v".toList=some (.uint64,none))
    (uCell : Cell start "u".toList 0) (nCell : Cell start "n".toList 512)
    (slenCell : Cell start "slen".toList 1)
    (inNttCell : start.locals "in_ntt".toList=some (.int32,some (.int32 1)))
    (gsBinding : start.arrays "gs".toList=some gs)
    (t1Binding : start.arrays "t1".toList=some t1)
    (t1Writable : start.heap.writable t1.block=true) :
    ∃ copyOut, Exec MakeFgGsShape194.copyFGs start ⟨copyOut,.normal⟩ ∧
      Exec MakeFgTailShape190.s5 copyOut ⟨copyOut,.normal⟩ ∧
      FixedGs copyOut gs t1 0 1 512 gv ∧ Cell copyOut "v".toList 512 ∧
      copyOut.arrays "x".toList=some (addr gs 0 512 1) ∧
      PrefixImage copyOut t1 gv 512 ∧ Reads copyOut igm 512 tws ∧
      (∀ name : Name, name≠"v".toList → copyOut.locals name=start.locals name) ∧
      (∀ name : Name, name≠"x".toList → copyOut.arrays name=start.arrays name) := by
  have separation : ∀ i : Fin 512, ∀ k : Nat, k<512 →
      Separate (elem t1 i.val) ({igm with index := igm.index+k}) :=
    fun i k bound => t1_igm_separate i.val k bound
  obtain ⟨copyOut,loopRun,fixedRun,vRun,xRun,prefixRun,localRun,arrayRun,igmRun⟩ :=
    StepGsCopyKeep194.source (mid start) gs t1 0 1 512 gv
      (mid_fixed start gv gsImage nCell slenCell t1Binding gsBinding t1Writable)
      (mid_v start) (mid_x start) (mid_copied start gv) igm 512 tws
      (mid_igm start tws igmReads) separation
  refine ⟨copyOut,?_,?_,fixedRun,vRun,xRun,prefixRun,igmRun,?_,?_⟩
  · exact .seqNormal _ _ start (mid start) ⟨copyOut,.normal⟩
      (init_source start vDeclared uCell gsBinding) loopRun
  · exact skip_source start copyOut
      (fun name different => (localRun name different).trans (mid_locals start name different))
      inNttCell
  · intro name different
    exact (localRun name different).trans (mid_locals start name different)
  · intro name different
    exact (arrayRun name different).trans (mid_arrays start name different)

end FT1536.Source3.SelectedStepGsCopy194
