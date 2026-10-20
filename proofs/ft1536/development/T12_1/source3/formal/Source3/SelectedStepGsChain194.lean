import Source3.SelectedStepGsCopy194
import Source3.SelectedStepGsProduct194
import Source3.SelectedStepGsInverse194
import Source3.SelectedStepChain193

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Composed gs-path stage statement s4-s7 of the make_fg_step first-prime
   tail, starting from the assembled `after` state shape of
   SelectedStepChain193.source (the s0-s3 prefix execution and the caller
   frames outside v/x), with the stage hypotheses stated explicitly: the
   gs source image and the igm twiddle reads at the start state and the
   heap writability (the sealed 193 export keeps only the transformed fs
   image and the caller frames, so these three are hypotheses here, to be
   discharged at the full first-prime assembly). The export records the
   transformed gs words (scaledWord gvs tws p p0i), the written gd image
   `value (gvs (2v)) (gvs (2v+1)) R2 p p0i` at the s6 output, the composed
   s0-s7 execution and the caller frames. Values stay executed words: no
   transform property, table law, root law or positivity claim. -/
namespace FT1536.Source3.SelectedStepGsChain194
open C99ArrayReference (State Name Pointer)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (addr elem)
open StepProductFixed191 (Image)
open StepCopyKeep193 (Reads)
open SelectedStepLayout187 (gs gd t1 igm)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges192 (scaledWord)

noncomputable abbrev base : State := SelectedGen0Call189.after

def gsPrefix : KeygenMakeFgSource.Stmt :=
  .seq MakeFgTailShape190.s4 (.seq MakeFgTailShape190.s5
    (.seq MakeFgTailShape190.s6 MakeFgTailShape190.s7))

def fullPrefix : KeygenMakeFgSource.Stmt :=
  .seq SelectedStepChain193.tailPrefix gsPrefix

theorem gs_igm_separate (j k : Nat) (bj : j<512) (bk : k<512) :
    Separate (elem gs j) ({igm with index := igm.index+k}) := by
  unfold Separate
  rw [SelectedStepGsCopy194.gs_offset j,SelectedStepGsCopy194.igm_offset]
  change 31≠31 ∨ (0+4*(2206+j))+4≤0+4*(3230+k) ∨ (0+4*(3230+k))+4≤0+4*(2206+j)
  omega

theorem init_gs (start : State) (vOld : Option C99IntegerReference.Value)
    (vDeclared : start.locals "v".toList=some (.uint64,vOld))
    (uCell : Cell start "u".toList 0) (gsBinding : start.arrays "gs".toList=some gs) :
    Exec MakeFgGsShape194.copyInitGs start ⟨SelectedStepGsCopy194.mid start,.normal⟩ := by
  have assign : C99ModularReference.Exec
      (.assign "v".toList (.scalar (MakeFgGsShape194.num 0)))
      start ⟨FftLocalCells140.put start "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 vOld (.int32 0) vDeclared (.scalar _ _ (.literal .int32 0))
  have uAfter : Cell (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
      "u".toList 0 :=
    (FftLocalCells140.outside start "v".toList "u".toList (C99NatWord141.word 0) (by decide)).trans
      uCell
  have gsAfter : (FftLocalCells140.put start "v".toList (C99NatWord141.word 0)).arrays
      "gs".toList=some gs := gsBinding
  have walked : Pointer (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
      "gs".toList MakeFgGsShape194.varU (addr gs 0 0 1) :=
    .add "gs".toList MakeFgGsShape194.varU gs (addr gs 0 0 1)
      (.uint64 (C99NatWord141.word 0)) gsAfter
      (C99LoopScalar141.read _ _ _ uAfter) (by decide)
      (C99MemoryReference.PointerAdd.within gs 0 (by decide))
  have bind : C99ModularReference.Exec
      (.base (.bindPtr "x".toList "gs".toList MakeFgGsShape194.varU))
      (FftLocalCells140.put start "v".toList (C99NatWord141.word 0))
      ⟨C99ArrayReference.bindPointer (FftLocalCells140.put start "v".toList
        (C99NatWord141.word 0)) "x".toList (addr gs 0 0 1),.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ walked)
  exact .level _ _ _ (.modular _ _ _ (.seqNormal _ _ _ _ _ assign bind))

theorem source (start : State) (gvs tws : Nat → BitVec 32) (vOld : Option C99IntegerReference.Value)
    (prefixRun : Exec SelectedStepChain193.tailPrefix base ⟨start,.normal⟩)
    (vDeclared : start.locals "v".toList=some (.uint64,vOld))
    (localsKeep : ∀ name : Name, name≠"v".toList →
      start.locals name=SelectedStepProduct191.base.locals name)
    (arraysKeep : ∀ name : Name, name≠"x".toList →
      start.arrays name=SelectedStepProduct191.base.arrays name)
    (gsImage : ∀ i : Fin 512, Load32 start.heap (elem gs i.val) (gvs i.val))
    (igmReads : ∀ k : Nat, k<512 → Load32 start.heap ({igm with index := igm.index+k}) (tws k))
    (writable : start.heap.writable t1.block=true) :
    ∃ copyOut prodOut final,
      Exec MakeFgTailShape190.s4 start ⟨copyOut,.normal⟩ ∧
      Exec MakeFgTailShape190.s5 copyOut ⟨copyOut,.normal⟩ ∧
      Exec MakeFgTailShape190.s6 copyOut ⟨prodOut,.normal⟩ ∧
      Exec MakeFgTailShape190.s7 prodOut ⟨final,.normal⟩ ∧
      Exec gsPrefix start ⟨final,.normal⟩ ∧
      Exec fullPrefix base ⟨final,.normal⟩ ∧
      (∀ i : Fin 512, Load32 final.heap (elem gs i.val)
        (scaledWord gvs tws SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
      Image prodOut gd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
        SelectedTopInit178.r2 gvs 256 ∧
      (∀ name : Name, name≠"v".toList →
        final.locals name=SelectedStepProduct191.base.locals name) ∧
      (∀ name : Name, name≠"x".toList →
        final.arrays name=SelectedStepProduct191.base.arrays name) := by
  have nCell : Cell start "n".toList 512 :=
    (localsKeep "n".toList (by decide)).trans (by exact SelectedGen0Ready189.n_cell)
  have slenCell : Cell start "slen".toList 1 :=
    (localsKeep "slen".toList (by decide)).trans (by exact SelectedGen0Ready189.slen_cell)
  have uCell : Cell start "u".toList 0 :=
    (localsKeep "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have hnCell : Cell start "hn".toList 256 :=
    (localsKeep "hn".toList (by decide)).trans (by exact SelectedGen0Ready189.hn_cell)
  have tlenCell : Cell start "tlen".toList 2 :=
    (localsKeep "tlen".toList (by decide)).trans (by exact SelectedGen0Ready189.tlen_cell)
  have lognCell : Slot start "logn" 9 :=
    (localsKeep "logn".toList (by decide)).trans (by exact SelectedGen0Ready189.logn_cell)
  have terCell : Slot start "ter" 1 :=
    (localsKeep "ter".toList (by decide)).trans (by exact SelectedGen0Ready189.ternary_cell)
  have inNttCell : start.locals "in_ntt".toList=some (.int32,some (.int32 1)) :=
    (localsKeep "in_ntt".toList (by decide)).trans (by exact SelectedGen0Ready189.in_ntt_cell)
  have pCell : Slot start "p" SelectedTopInit178.p :=
    (localsKeep "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have iCell : Slot start "p0i" SelectedTopInit178.p0i :=
    (localsKeep "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have r2Cell : Slot start "R2" SelectedTopInit178.r2 :=
    (localsKeep "R2".toList (by decide)).trans (by exact SelectedGen0Ready189.r2_cell)
  have gsBinding : start.arrays "gs".toList=some gs :=
    (arraysKeep "gs".toList (by decide)).trans (by exact SelectedGen0Ready189.gs_binding)
  have gdBinding : start.arrays "gd".toList=some gd :=
    (arraysKeep "gd".toList (by decide)).trans (by exact SelectedGen0Ready189.gd_binding)
  have t1Binding : start.arrays "t1".toList=some t1 :=
    (arraysKeep "t1".toList (by decide)).trans (by exact SelectedGen0Ready189.t1_binding)
  have igmBinding : start.arrays "igm".toList=some igm :=
    (arraysKeep "igm".toList (by decide)).trans (by exact SelectedGen0Ready189.igm_binding)
  have initRun : Exec MakeFgGsShape194.copyInitGs start
      ⟨SelectedStepGsCopy194.mid start,.normal⟩ :=
    init_gs start vOld vDeclared uCell gsBinding
  obtain ⟨copyOut,loopRun,fixedRun,vRun,xRun,prefixImgRun,localRun,arrayRun,igmRun⟩ :=
    StepGsCopyKeep194.source (SelectedStepGsCopy194.mid start) gs t1 0 1 512
      (fun i : Fin 512 => gvs i.val)
      (SelectedStepGsCopy194.mid_fixed start (fun i : Fin 512 => gvs i.val) gsImage nCell slenCell
        t1Binding gsBinding writable)
      (SelectedStepGsCopy194.mid_v start) (SelectedStepGsCopy194.mid_x start)
      (SelectedStepGsCopy194.mid_copied start (fun i : Fin 512 => gvs i.val)) igm 512 tws
      (SelectedStepGsCopy194.mid_igm start tws igmReads)
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
      ((SelectedStepGsCopy194.mid_locals start name different).trans (localsKeep name different))
  have copyArraysBase : ∀ name : Name, name≠"x".toList →
      copyOut.arrays name=SelectedStepProduct191.base.arrays name := by
    intro name different
    exact (arrayRun name different).trans
      ((SelectedStepGsCopy194.mid_arrays start name different).trans (arraysKeep name different))
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
  have copyT1Image : ∀ i : Fin 512, Load32 copyOut.heap (elem t1 i.val) (gvs i.val) :=
    fun i => prefixImgRun i i.isLt
  have copyGsReads : ∀ k : Nat, k<512 →
      Load32 copyOut.heap ({gs with index := gs.index+k}) (gvs k) := by
    intro k bound
    have read := fixedRun.src ⟨k,bound⟩
    rw [SelectedStepGsCopy194.addr_gs k] at read
    exact read
  have copyGdWritable : copyOut.heap.writable gd.block=true := by
    exact fixedRun.t1Writable
  obtain ⟨prodOut,s6Run,outFixed,outV,outX,outImage,outReadsGs,outReadsIgm,prodLocals,
      prodArrays⟩ :=
    SelectedStepGsProduct194.source copyOut gvs tws copyT1Image copyGsReads igmRun vRun copyU
      copyHn copyTlen copyP copyI copyR2 copyGd copyT1 copyGdWritable
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
  have prodSlen : KeygenNttLoopSupport.USlot prodOut "slen" 1 :=
    (prodLocalsBase "slen".toList (by decide)).trans (by exact SelectedGen0Ready189.slen_cell)
  have prodLogn : Slot prodOut "logn" 9 :=
    (prodLocalsBase "logn".toList (by decide)).trans (by exact SelectedGen0Ready189.logn_cell)
  have prodTer : Slot prodOut "ter" 1 :=
    (prodLocalsBase "ter".toList (by decide)).trans (by exact SelectedGen0Ready189.ternary_cell)
  have prodInNtt : prodOut.locals "in_ntt".toList=some (.int32,some (.int32 1)) :=
    (prodLocalsBase "in_ntt".toList (by decide)).trans (by exact SelectedGen0Ready189.in_ntt_cell)
  have prodP : Slot prodOut "p" SelectedTopInit178.p :=
    (prodLocalsBase "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have prodI : Slot prodOut "p0i" SelectedTopInit178.p0i :=
    (prodLocalsBase "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have prodGs : prodOut.arrays "gs".toList=some gs :=
    (prodArraysBase "gs".toList (by decide)).trans (by exact SelectedGen0Ready189.gs_binding)
  have prodIgm : prodOut.arrays "igm".toList=some igm :=
    (prodArraysBase "igm".toList (by decide)).trans (by exact SelectedGen0Ready189.igm_binding)
  have prodGsWritable : prodOut.heap.writable gs.block=true := by
    exact outFixed.gdWritable
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
    exact gs_igm_separate j k bj bk
  have prodGsImage : ∀ i : Fin 512, Load32 prodOut.heap (elem gs i.val) (gvs i.val) := by
    intro i
    exact outReadsGs i.val i.isLt
  obtain ⟨final,s7Run,finalImage,finalLocals,finalArrays⟩ :=
    SelectedStepGsInverse194.source prodOut SelectedTopInit178.p SelectedTopInit178.p0i gvs tws
      prodU prodSlen prodLogn prodTer prodInNtt prodP prodI prodGs prodIgm prodGsWritable
      prodGsCapacity prodIgmCapacity prodGsSeparate prodTwSeparate outReadsIgm prodGsImage
      prodLocalsBase prodArraysBase
  have gsRun : Exec gsPrefix start ⟨final,.normal⟩ :=
    .seqNormal _ _ start copyOut ⟨final,.normal⟩ s4Run
      (.seqNormal _ _ copyOut copyOut ⟨final,.normal⟩ s5Run
        (.seqNormal _ _ copyOut prodOut ⟨final,.normal⟩ s6Run s7Run))
  have wholeRun : Exec fullPrefix base ⟨final,.normal⟩ :=
    .seqNormal _ _ base start ⟨final,.normal⟩ prefixRun gsRun
  exact ⟨copyOut,prodOut,final,s4Run,s5Run,s6Run,s7Run,gsRun,wholeRun,finalImage,outImage,
    finalLocals,finalArrays⟩

end FT1536.Source3.SelectedStepGsChain194
