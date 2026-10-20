import Source3.SelectedStepChain193
import Source3.SelectedStepGsCopy194
import Source3.StepCopyKeepTwo194
import Source3.StepProductKeepThree194
import Source3.SelectedStepInverseKeep194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Re-assembly of the make_fg_step first-prime prefix s0-s3 at the actual
   selected seed9 state with the extra keeps the gs path needs: the gs
   source image and the igm twiddle reads survive the copy writes (s0)
   and the product writes (s2) through the two-image keep, the fs reads,
   gs source and igm twiddle reads survive the product writes through the
   three-image keep, and the fd written image, the gs source image and
   the igm twiddle reads survive the s3 inverse call through the
   whole-inverse bystander keep (NttInverseWholeKeep194 via
   SelectedStepInverseKeep194). The export at the assembled state is the
   transformed fs image, the written fd image, the gs source image, the
   igm twiddle reads, the v cell and the caller frames, so the stage
   hypotheses of SelectedStepGsChain194.source become unconditional.
   Values stay executed words: no transform property, table law, root law
   or positivity claim. -/
namespace FT1536.Source3.SelectedStepChainKeep194
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open KeygenSmallOutput (element)
open StepCopyBody190 (addr elem)
open SelectedStepLayout187 (fs t1 fd gs igm)
open StepCopyKeep193 (Reads)
open StepProductFixed191 (Image)
open NttInverseWholeBridges192 (scaledWord)

noncomputable abbrev base : State := SelectedGen0Call189.after

/- The gs source words as the actual executed load words at the selected
   state; no table law is assumed. -/
noncomputable def gvs (k : Nat) : BitVec 32 :=
  if h : k<512 then Classical.choose (SelectedGen0Frame189.g_read k h) else 0

theorem gvs_read (k : Nat) (bound : k<512) :
    Load32 base.heap ({gs with index := gs.index+k}) (gvs k) := by
  have read := Classical.choose_spec (SelectedGen0Frame189.g_read k bound)
  have key : gvs k=Classical.choose (SelectedGen0Frame189.g_read k bound) := by
    unfold gvs
    split_ifs
    rfl
  rw [key]
  exact read

theorem separate_symm {p q : ArrayPointer} (separate : Separate p q) : Separate q p := by
  cases separate with
  | inl different => exact Or.inl (Ne.symm different)
  | inr side =>
    cases side with
    | inl left => exact Or.inr (Or.inr left)
    | inr right => exact Or.inr (Or.inl right)

theorem gs_off (k : Nat) :
    C99MemoryReference.ArrayPointer.offset ({gs with index := gs.index+k})=0+4*(2206+k) :=
  SelectedStepGsCopy194.gs_offset k

theorem t1_gs_separate (i k : Nat) (bound : k<512) :
    Separate (elem t1 i) ({gs with index := gs.index+k}) := by
  unfold Separate
  rw [SelectedStepChain193.t1_offset,gs_off]
  change 31≠31 ∨ (0+4*(3742+i))+4≤0+4*(2206+k) ∨ (0+4*(2206+k))+4≤0+4*(3742+i)
  omega

theorem fd_gs_separate (v k : Nat) (bound : v<256) :
    Separate (addr fd 0 v 2) ({gs with index := gs.index+k}) := by
  unfold Separate
  rw [SelectedStepChain193.fd_offset,gs_off]
  change 31≠31 ∨ (0+4*(670+0+v*2))+4≤0+4*(2206+k) ∨ (0+4*(2206+k))+4≤0+4*(670+0+v*2)
  omega

theorem fs_gs_separate (j k : Nat) (bound : j<512) :
    Separate (elem fs j) ({gs with index := gs.index+k}) := by
  unfold Separate
  rw [SelectedStepChain193.fs_offset,gs_off]
  change 31≠31 ∨ (0+4*(1694+j))+4≤0+4*(2206+k) ∨ (0+4*(2206+k))+4≤0+4*(1694+j)
  omega

theorem fs_gs_walk (x i : Nat) (bound : x<512) :
    Separate (NttInverseCorrectionLoop192.walk (addr fs 0 0 1) x 1) (elem gs i) := by
  rw [SelectedStepInverse192.walk_fs x]
  exact fs_gs_separate x i bound

theorem fs_fd_walk (x v : Nat) (bound : v<256) :
    Separate (NttInverseCorrectionLoop192.walk (addr fs 0 0 1) x 1) (addr fd 0 v 2) := by
  rw [SelectedStepInverse192.walk_fs x]
  exact separate_symm (SelectedStepChain193.fd_fs_separate v x bound)

theorem fs_igm_walk (x k : Nat) (bound : x<512) :
    Separate (NttInverseCorrectionLoop192.walk (addr fs 0 0 1) x 1)
      ({igm with index := igm.index+k}) := by
  rw [SelectedStepInverse192.walk_fs x]
  exact SelectedStepChain193.fs_igm_separate x k bound

/- Caller-local preservation of the s3/s7 wrapper statements: every leaf
   is either the heap-only skip or a modular call whose result is the
   caller state with the body heap, so the assembled state carries the v
   cell of the product output. -/
def arraySafe : C99ArrayReference.Stmt → Bool
  | .skip => true
  | .call _ _ => true
  | _ => false

def modularSafe : C99ModularReference.Stmt → Bool
  | .base code => arraySafe code
  | _ => false

def levelSafe : KeygenLevelExec.Stmt → Bool
  | .modular code => modularSafe code
  | .call _ _ => true
  | _ => false

def localSafe : KeygenMakeFgSource.Stmt → Bool
  | .level body => levelSafe body
  | .binary _ _ => true
  | .seq a b => localSafe a && localSafe b
  | .branch _ a b => localSafe a && localSafe b
  | .scope _ _ a => localSafe a
  | _ => false

theorem array_result (program : C99ArrayReference.Program) (code : C99ArrayReference.Stmt)
    (s after : State) (checked : arraySafe code=true)
    (run : C99ArrayReference.Exec program code s after) :
    after.locals=s.locals := by
  induction run
  all_goals (first | rfl | cases checked)

theorem modular_result (code : C99ModularReference.Stmt) (s : State)
    (out : C99ProcedureReference.Result) (checked : modularSafe code=true)
    (run : C99ModularReference.Exec code s out) :
    out.state.locals=s.locals := by
  induction run
  case base code before after body =>
    exact array_result _ code before after (by simpa [modularSafe] using checked) body
  all_goals (first | rfl | cases checked)

theorem level_result (code : KeygenLevelExec.Stmt) (s : State)
    (out : C99ProcedureReference.Result) (checked : levelSafe code=true)
    (run : KeygenLevelExec.Exec code s out) :
    out.state.locals=s.locals := by
  induction run
  case modular code before out source =>
    exact modular_result code before out (by simpa [levelSafe] using checked) source
  case call kind args before after source =>
    cases source
    rfl
  all_goals (first | rfl | cases checked)

theorem localSafe_result (code : KeygenMakeFgSource.Stmt) (s : State)
    (out : C99ProcedureReference.Result) (checked : localSafe code=true)
    (run : KeygenMakeFgSource.Exec code s out) :
    out.state.locals=s.locals := by
  induction run
  case level code before out source =>
    exact level_result code before out (by simpa [localSafe] using checked) source
  case binary kind args before after source =>
    cases source
    rfl
  case seqNormal a b before middle out head tail ih1 ih2 =>
    have parts : (localSafe a && localSafe b) = true := by
      show localSafe (KeygenMakeFgSource.Stmt.seq a b) = true
      exact checked
    have both : localSafe a = true ∧ localSafe b = true := Bool.and_eq_true_iff.mp parts
    exact (ih2 both.2).trans (ih1 both.1)
  case seqExit a b before out head exit ih =>
    have parts : (localSafe a && localSafe b) = true := by
      show localSafe (KeygenMakeFgSource.Stmt.seq a b) = true
      exact checked
    have both : localSafe a = true ∧ localSafe b = true := Bool.and_eq_true_iff.mp parts
    exact ih both.1
  case scope locals pointers body before out source ih =>
    have keep := ih (by simpa [localSafe] using checked)
    funext n
    change (if locals.contains n then before.locals n else out.state.locals n)=before.locals n
    split_ifs
    · rfl
    · rw [keep]
  case branchTrue condition yes no before out v guard nonzero body ih =>
    have parts : (localSafe yes && localSafe no) = true := by
      show localSafe (KeygenMakeFgSource.Stmt.branch condition yes no) = true
      exact checked
    have both : localSafe yes = true ∧ localSafe no = true := Bool.and_eq_true_iff.mp parts
    exact ih both.1
  case branchFalse condition yes no before out v guard zero body ih =>
    have parts : (localSafe yes && localSafe no) = true := by
      show localSafe (KeygenMakeFgSource.Stmt.branch condition yes no) = true
      exact checked
    have both : localSafe yes = true ∧ localSafe no = true := Bool.and_eq_true_iff.mp parts
    exact ih both.2
  all_goals (first | rfl | cases checked)

theorem source : ∃ copyOut out start,
    Exec MakeFgTailShape190.copyF base ⟨copyOut,.normal⟩ ∧
    Exec MakeFgTailShape190.s1 copyOut ⟨copyOut,.normal⟩ ∧
    Exec MakeFgTailShape190.s2 copyOut ⟨out,.normal⟩ ∧
    Exec MakeFgTailShape190.s3 out ⟨start,.normal⟩ ∧
    Exec SelectedStepChain193.tailPrefix base ⟨start,.normal⟩ ∧
    (∀ i : Fin 512, Load32 start.heap (elem fs i.val)
      (scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    Image start fd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepProduct191.fvs 256 ∧
    (∀ i : Fin 512, Load32 start.heap (elem gs i.val) (gvs i.val)) ∧
    (∀ k : Nat, k<512 →
      Load32 start.heap ({igm with index := igm.index+k}) (SelectedStepChain193.tws k)) ∧
    (∃ vOld : Option C99IntegerReference.Value, start.locals "v".toList=some (.uint64,vOld)) ∧
    (∀ name : Name, name≠"v".toList → start.locals name=SelectedStepProduct191.base.locals name) ∧
    (∀ name : Name, name≠"x".toList → start.arrays name=SelectedStepProduct191.base.arrays name) ∧
    start.heap.writable t1.block=true := by
  have midIgm : Reads SelectedStepCopy190.mid igm 512 SelectedStepChain193.tws := by
    intro k bound
    rw [SelectedStepCopy190.mid_heap]
    exact SelectedStepChain193.tws_read k bound
  have midGs : Reads SelectedStepCopy190.mid gs 512 gvs := by
    intro k bound
    rw [SelectedStepCopy190.mid_heap]
    exact gvs_read k bound
  have copySeparateIgm : ∀ i : Fin 512, ∀ k : Nat, k<512 →
      Separate (elem t1 i.val) ({igm with index := igm.index+k}) :=
    fun i k bound => SelectedStepChain193.t1_igm_separate i.val k bound
  have copySeparateGs : ∀ i : Fin 512, ∀ k : Nat, k<512 →
      Separate (elem t1 i.val) ({gs with index := gs.index+k}) :=
    fun i k bound => t1_gs_separate i.val k bound
  obtain ⟨copyOut,copyLoopRun,copyFixed,copyV,copyX,copyPrefix,copyLocals,copyArrays,
    copyIgm,copyGs⟩ :=
    StepCopyKeepTwo194.source SelectedStepCopy190.mid fs t1 0 1 512 SelectedStepCopy190.fv
      SelectedStepCopy190.mid_fixed SelectedStepCopy190.mid_v SelectedStepCopy190.mid_x
      SelectedStepCopy190.mid_copied igm 512 SelectedStepChain193.tws midIgm copySeparateIgm
      gs 512 gvs midGs copySeparateGs
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
  have midReadsFs : Reads mid2 fs 512 SelectedStepProduct191.fvs := by
    intro k bound
    have read := copyFixed.src ⟨k,bound⟩
    rw [SelectedStepCopy190.addr_zero_one fs k] at read
    rw [← SelectedStepProduct191.fvs_read k bound] at read
    rw [midEq]
    exact read
  have midReadsIgm : Reads mid2 igm 512 SelectedStepChain193.tws := by
    intro k bound
    rw [midEq]
    exact copyIgm k bound
  have midReadsGs : Reads mid2 gs 512 gvs := by
    intro k bound
    rw [midEq]
    exact copyGs k bound
  have productSeparateFs : ∀ i : Fin 256, ∀ k : Nat, k<512 →
      Separate (addr fd 0 i.val 2) ({fs with index := fs.index+k}) :=
    fun i k _ => SelectedStepChain193.fd_fs_separate i.val k i.isLt
  have productSeparateIgm : ∀ i : Fin 256, ∀ k : Nat, k<512 →
      Separate (addr fd 0 i.val 2) ({igm with index := igm.index+k}) :=
    fun i k _ => SelectedStepChain193.fd_igm_separate i.val k i.isLt
  have productSeparateGs : ∀ i : Fin 256, ∀ k : Nat, k<512 →
      Separate (addr fd 0 i.val 2) ({gs with index := gs.index+k}) :=
    fun i k _ => fd_gs_separate i.val k i.isLt
  obtain ⟨out,loopRun,outFixed,outV,outX,outImage,outLocals,outArrays,outReadsFs,outReadsIgm,
    outReadsGs⟩ :=
    StepProductKeepThree194.source mid2 fd t1 0 2 256
      SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2 SelectedStepProduct191.fvs
      midFixed midV midX midImage
      fs 512 SelectedStepProduct191.fvs midReadsFs productSeparateFs
      igm 512 SelectedStepChain193.tws midReadsIgm productSeparateIgm
      gs 512 gvs midReadsGs productSeparateGs
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
    exact SelectedStepChain193.fs_fs_separate j k different
  have twSeparateOut : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (NttInverseCorrectionLoop192.walk (addr fs 0 0 1) j 1)
        ({igm with index := igm.index+k}) := by
    intro k bk j bj
    rw [SelectedStepInverse192.walk_fs j]
    exact SelectedStepChain193.fs_igm_separate j k bj
  have twLoadsOut : ∀ k : Nat, k<512 →
      Load32 out.heap ({igm with index := igm.index+k}) (SelectedStepChain193.tws k) :=
    outReadsIgm
  have fsImageOut : ∀ i : Fin 512, Load32 out.heap (elem fs i.val)
      (SelectedStepProduct191.fvs i.val) := fun i => outReadsFs i.val i.isLt
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
  have fdImage : Image start fd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepProduct191.fvs 256 := by
    intro i bound
    have load := outImage i bound
    exact s3Keep (addr fd 0 i.val 2) (fun x _ => fs_fd_walk x i.val i.isLt)
      (StepProductBody191.value (SelectedStepProduct191.fvs (2*i.val))
        (SelectedStepProduct191.fvs (2*i.val+1)) SelectedTopInit178.r2
        SelectedTopInit178.p SelectedTopInit178.p0i) load
  have gsImage : ∀ i : Fin 512, Load32 start.heap (elem gs i.val) (gvs i.val) := by
    intro i
    have load : Load32 out.heap (elem gs i.val) (gvs i.val) := outReadsGs i.val i.isLt
    exact s3Keep (elem gs i.val) (fun x bound2 => fs_gs_walk x i.val bound2) (gvs i.val) load
  have igmReads : ∀ k : Nat, k<512 →
      Load32 start.heap ({igm with index := igm.index+k}) (SelectedStepChain193.tws k) := by
    intro k bound
    exact s3Keep ({igm with index := igm.index+k}) (fun x bound2 => fs_igm_walk x k bound2)
      (SelectedStepChain193.tws k) (outReadsIgm k bound)
  have vStart : start.locals "v".toList=out.locals "v".toList :=
    congrFun (localSafe_result MakeFgTailShape190.s3 out ⟨start,.normal⟩ (by decide) s3Run)
      "v".toList
  have vOut : out.locals "v".toList=some (.uint64,some (.uint64 (C99NatWord141.word 256))) := outV
  have vOld : ∃ vOld : Option C99IntegerReference.Value,
      start.locals "v".toList=some (.uint64,vOld) :=
    ⟨some (.uint64 (C99NatWord141.word 256)),vStart.trans vOut⟩
  have writableStart : start.heap.writable t1.block=true := by
    rw [s3Writable]
    exact outFixed.fdWritable
  exact ⟨copyOut,out,start,copyFRun,skipRun,productRun,s3Run,prefixRun,s3Image,fdImage,gsImage,
    igmReads,vOld,s3Locals,s3Arrays,writableStart⟩

end FT1536.Source3.SelectedStepChainKeep194
