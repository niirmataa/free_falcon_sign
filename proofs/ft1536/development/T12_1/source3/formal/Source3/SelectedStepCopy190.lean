import Source3.StepCopyLoop190
import Source3.SelectedGen0Ready189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original fs-to-t1 copy loop at the actual selected first-prime state,
   followed by the false !in_ntt branch; every word comes from the executed
   loads of the preserved input image. -/
namespace FT1536.Source3.SelectedStepCopy190
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec skip)
open C99LoopScalar141 (Cell)
open SelectedStepLayout187 (fs t1)
open StepCopyBody190 (addr elem)
open StepCopyFixed190 (Fixed PrefixImage)

noncomputable abbrev base : State := SelectedGen0Call189.after

noncomputable def fv : Fin 512 → BitVec 32 := fun i => Classical.choose (SelectedGen0Frame189.f_read i.val i.isLt)

theorem fv_read (i : Fin 512) : Load32 base.heap (elem fs i.val) (fv i) := by
  exact Classical.choose_spec (SelectedGen0Frame189.f_read i.val i.isLt)

theorem addr_zero_one (p : ArrayPointer) (i : Nat) : addr p 0 i 1=elem p i :=
  congrArg (fun k : Nat => {p with index := k})
    (show p.index+0+i*1=p.index+i by omega)

theorem t1_allocated (j : Nat) (bound : j<512) : Allocated base.heap (elem t1 j) := by
  unfold Allocated
  rw [SelectedGen0Frame189.stable.size]
  have old : Allocated StepGeneratorEntry188.entry.heap (elem t1 j) :=
    StepGeneratorEntry188.allocated (3742+j) (by omega)
  rw [SelectedGen0Frame189.entry_heap] at old
  exact old

theorem t1_offset (i : Nat) : C99MemoryReference.ArrayPointer.offset (elem t1 i)=0+4*(3742+i) := rfl
theorem fs_offset (i : Nat) : C99MemoryReference.ArrayPointer.offset (addr fs 0 i 1)=0+4*(1694+(0+i)) := rfl

theorem t1_separate (v i : Fin 512) : Separate (elem t1 v) (addr fs 0 i.val 1) := by
  unfold Separate
  rw [t1_offset,fs_offset]
  change 31≠31 ∨ (0+4*(3742+v.val))+4≤0+4*(1694+(0+i.val)) ∨
    (0+4*(1694+(0+i.val)))+4≤0+4*(3742+v.val)
  omega

noncomputable def mid : State := bindPointer (FftLocalCells140.put base "v".toList (C99NatWord141.word 0))
  "x".toList (addr fs 0 0 1)

theorem mid_heap : mid.heap=base.heap := rfl

theorem mid_locals (other : Name) (different : other≠"v".toList) : mid.locals other=base.locals other := by
  have first : mid.locals other=
      (FftLocalCells140.put base "v".toList (C99NatWord141.word 0)).locals other := rfl
  rw [first]
  exact (FftLocalCells140.outside base "v".toList other (C99NatWord141.word 0) different).trans rfl

theorem mid_arrays (other : Name) (different : other≠"x".toList) : mid.arrays other=base.arrays other := by
  have first : mid.arrays other=
      (C99ArrayReference.bindPointer (FftLocalCells140.put base "v".toList (C99NatWord141.word 0))
        "x".toList (addr fs 0 0 1)).arrays other := rfl
  rw [first]
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ different]
  rfl

theorem init_source : Exec MakeFgTailShape190.copyInit base ⟨mid,.normal⟩ := by
  have assign : C99ModularReference.Exec (.assign "v".toList (.scalar (MakeFgTailShape190.num 0)))
      base ⟨FftLocalCells140.put base "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 none (.int32 0) SelectedGen0Ready189.v_declared
      (.scalar _ _ (.literal .int32 0))
  have uCell : Cell (FftLocalCells140.put base "v".toList (C99NatWord141.word 0)) "u".toList 0 :=
    (FftLocalCells140.outside base "v".toList "u".toList (C99NatWord141.word 0) (by decide)).trans
      (by exact SelectedGen0Ready189.u_cell)
  have walked : Pointer (FftLocalCells140.put base "v".toList (C99NatWord141.word 0))
      "fs".toList MakeFgTailShape190.varU (addr fs 0 0 1) :=
    .add "fs".toList MakeFgTailShape190.varU fs (addr fs 0 0 1) (.uint64 (C99NatWord141.word 0))
      (by exact SelectedGen0Ready189.fs_binding)
      (C99LoopScalar141.read _ _ _ uCell)
      (by decide)
      (C99MemoryReference.PointerAdd.within fs 0 (by decide))
  have bind : C99ModularReference.Exec
      (.base (.bindPtr "x".toList "fs".toList MakeFgTailShape190.varU))
      (FftLocalCells140.put base "v".toList (C99NatWord141.word 0)) ⟨mid,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ walked)
  have combined : C99ModularReference.Exec MakeFgTailShape190.copyInitCode base ⟨mid,.normal⟩ :=
    .seqNormal _ _ _ _ _ assign bind
  exact .level _ _ _ (.modular _ _ _ combined)

theorem mid_fixed : Fixed mid fs t1 0 1 512 fv := by
  refine ⟨by decide,by decide,by decide,rfl,rfl,by decide,by decide,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact SelectedGen0Ready189.writable
  · rw [mid_arrays "fs".toList (by decide)]
    exact SelectedGen0Ready189.fs_binding
  · rw [mid_arrays "t1".toList (by decide)]
    exact SelectedGen0Ready189.t1_binding
  · exact (mid_locals "n".toList (by decide)).trans (by exact SelectedGen0Ready189.n_cell)
  · exact (mid_locals "slen".toList (by decide)).trans (by exact SelectedGen0Ready189.slen_cell)
  · intro i
    exact t1_allocated i.val i.isLt
  · exact t1_separate
  · intro i j different
    exact StepCopyFixed190.elem_separate t1 rfl i.val j.val (fun equal => different (Fin.ext equal))
  · intro i
    rw [addr_zero_one fs i.val]
    exact fv_read i

theorem mid_v : Cell mid "v".toList 0 := by
  exact FftLocalCells140.cell_at base "v".toList (C99NatWord141.word 0)

theorem mid_x : mid.arrays "x".toList=some (addr fs 0 0 1) := rfl

theorem mid_copied : PrefixImage mid t1 fv 0 := fun i bound => absurd bound (by omega)

theorem skip_source (out : State)
    (locals : ∀ name : Name, name≠"v".toList → out.locals name=base.locals name) :
    Exec MakeFgTailShape190.s1 out ⟨out,.normal⟩ := by
  have cell : out.locals "in_ntt".toList=some (.int32,some (.int32 1)) :=
    (locals "in_ntt".toList (by decide)).trans SelectedGen0Ready189.in_ntt_cell
  have guard : C99ArrayReference.scalar out (CLogic.Expr.lnot MakeFgTailShape190.inNtt) (.int32 0) :=
    by exact .logicalNot _ (.int32 1) (.variable _ _ _ cell)
  have skipped : Exec skip out ⟨out,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip out)))
  rw [MakeFgTailShape190.s1_shape]
  exact .branchFalse _ _ _ out ⟨out,.normal⟩ (.int32 0) guard rfl skipped

theorem source : ∃ out, Exec MakeFgTailShape190.copyF base ⟨out,.normal⟩ ∧
    Fixed out fs t1 0 1 512 fv ∧ Cell out "v".toList 512 ∧
    out.arrays "x".toList=some (addr fs 0 512 1) ∧ PrefixImage out t1 fv 512 ∧
    (∀ name : Name, name≠"v".toList → out.locals name=base.locals name) ∧
    (∀ name : Name, name≠"x".toList → out.arrays name=base.arrays name) ∧
    Exec MakeFgTailShape190.s1 out ⟨out,.normal⟩ := by
  obtain ⟨out,loopRun,fixRun,vRun,xRun,copyRun,localRun,arrayRun⟩ :=
    StepCopyLoop190.source mid fs t1 0 1 512 fv mid_fixed mid_v mid_x mid_copied
  refine ⟨out,?_,fixRun,vRun,xRun,copyRun,?_,?_,skip_source out ?_⟩
  · exact .seqNormal _ _ base mid ⟨out,.normal⟩ init_source loopRun
  · intro name different
    exact (localRun name different).trans (mid_locals name different)
  · intro name different
    exact (arrayRun name different).trans (mid_arrays name different)
  · intro name different
    exact (localRun name different).trans (mid_locals name different)

end FT1536.Source3.SelectedStepCopy190
