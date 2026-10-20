import Source3.SelectedStepGsChain194
import Source3.SelectedStepChainKeep194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Unconditional full first-prime assembly s0-s7 of the make_fg_step tail
   at the actual selected seed9 state. The re-assembled s0-s3 state
   (SelectedStepChainKeep194.source) makes every stage hypothesis of the
   sealed SelectedStepGsChain194.source free (gs source image, igm
   twiddle reads, heap writability), so the stage statement instantiates
   unconditionally (`stage_discharge`). The keep-extended assembly
   (`source`) additionally threads the bystander keeps: the gd written
   image of the s6 product survives the s7 gs inverse through the
   whole-inverse keep (NttInverseWholeKeep194 via SelectedStepInverse-
   Keep194.gs_source), so the export holds at the final assembled state.
   Values stay executed words: no transform property, table law, root law
   or positivity claim; the prospective Z>=2^-256 bound is NOT
   established here. -/
namespace FT1536.Source3.SelectedStepFull194
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open SelectedStepLayout187 (fs t1 fd gs gd igm)
open StepProductFixed191 (Image)
open NttInverseWholeBridges192 (scaledWord)

noncomputable abbrev base : State := SelectedGen0Call189.after

theorem gd_offset (v : Nat) :
    C99MemoryReference.ArrayPointer.offset (addr gd 0 v 2)=0+4*(1182+0+v*2) := rfl

theorem gd_gs_walk (x v : Nat) (bound : v<256) :
    Separate (NttInverseCorrectionLoop192.walk (addr gs 0 0 1) x 1) (addr gd 0 v 2) := by
  rw [SelectedStepGsInverse194.walk_gs x]
  unfold Separate
  rw [SelectedStepGsCopy194.gs_offset,gd_offset]
  change 31≠31 ∨ (0+4*(2206+x))+4≤0+4*(1182+0+v*2) ∨ (0+4*(1182+0+v*2))+4≤0+4*(2206+x)
  omega

theorem stage_discharge : ∃ (start copyOut prodOut final : State),
    Exec SelectedStepChain193.tailPrefix base ⟨start,.normal⟩ ∧
    Exec MakeFgTailShape190.s4 start ⟨copyOut,.normal⟩ ∧
    Exec MakeFgTailShape190.s6 copyOut ⟨prodOut,.normal⟩ ∧
    Exec MakeFgTailShape190.s7 prodOut ⟨final,.normal⟩ ∧
    Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ ∧
    (∀ i : Fin 512, Load32 final.heap (elem gs i.val)
      (scaledWord SelectedStepChainKeep194.gvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    Image prodOut gd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepChainKeep194.gvs 256 ∧
    (∀ name : Name, name≠"v".toList →
      final.locals name=SelectedStepProduct191.base.locals name) ∧
    (∀ name : Name, name≠"x".toList →
      final.arrays name=SelectedStepProduct191.base.arrays name) := by
  obtain ⟨_,_,start,_,_,_,_,prefixRun,_,_,gsImageStart,igmReadsStart,vOldStart,localsKeepStart,
    arraysKeepStart,writableStart⟩ :=
    SelectedStepChainKeep194.source
  obtain ⟨vOld,vDeclared⟩ := vOldStart
  obtain ⟨copyOutG,prodOutG,finalG,s4Run,_,s6RunG,s7RunG,gsRunG,wholeRunG,finalImageG,
    gdImageG,finalLocalsG,finalArraysG⟩ :=
    SelectedStepGsChain194.source start SelectedStepChainKeep194.gvs SelectedStepChain193.tws
      vOld prefixRun vDeclared localsKeepStart arraysKeepStart gsImageStart igmReadsStart
      writableStart
  exact ⟨start,copyOutG,prodOutG,finalG,prefixRun,s4Run,s6RunG,s7RunG,wholeRunG,finalImageG,
    gdImageG,finalLocalsG,finalArraysG⟩

theorem source : ∃ (start final : State),
    Exec SelectedStepChain193.tailPrefix base ⟨start,.normal⟩ ∧
    Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ ∧
    (∀ i : Fin 512, Load32 final.heap (elem gs i.val)
      (scaledWord SelectedStepChainKeep194.gvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    Image final gd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepChainKeep194.gvs 256 ∧
    Image start fd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepProduct191.fvs 256 ∧
    (∀ i : Fin 512, Load32 start.heap (elem fs i.val)
      (scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    (∀ name : Name, name≠"v".toList →
      final.locals name=SelectedStepProduct191.base.locals name) ∧
    (∀ name : Name, name≠"x".toList →
      final.arrays name=SelectedStepProduct191.base.arrays name) := by
  obtain ⟨_,_,start,_,_,_,_,prefixRun,fsImageStart,fdImageStart,
    gsImageStart,igmReadsStart,vOldStart,localsKeepStart,arraysKeepStart,writableStart⟩ :=
    SelectedStepChainKeep194.source
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
    (localsKeepStart "in_ntt".toList (by decide)).trans (by exact SelectedGen0Ready189.in_ntt_cell)
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
  obtain ⟨vOld,vDeclared⟩ := vOldStart
  have initRun : Exec MakeFgGsShape194.copyInitGs start
      ⟨SelectedStepGsCopy194.mid start,.normal⟩ :=
    SelectedStepGsChain194.init_gs start vOld vDeclared uCell gsBinding
  obtain ⟨copyOutG,loopRun,fixedRun,vRun,xRun,prefixImgRun,localRun,arrayRun,igmRun⟩ :=
    StepGsCopyKeep194.source (SelectedStepGsCopy194.mid start) gs t1 0 1 512
      (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val)
      (SelectedStepGsCopy194.mid_fixed start (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val)
        gsImageStart nCell slenCell t1Binding gsBinding writableStart)
      (SelectedStepGsCopy194.mid_v start) (SelectedStepGsCopy194.mid_x start)
      (SelectedStepGsCopy194.mid_copied start (fun i : Fin 512 => SelectedStepChainKeep194.gvs i.val))
      igm 512 SelectedStepChain193.tws
      (SelectedStepGsCopy194.mid_igm start SelectedStepChain193.tws igmReadsStart)
      (fun i k bound => SelectedStepGsCopy194.t1_igm_separate i.val k bound)
  have s4Run : Exec MakeFgTailShape190.s4 start ⟨copyOutG,.normal⟩ := by
    rw [MakeFgGsShape194.s4_shape]
    exact .seqNormal _ _ start (SelectedStepGsCopy194.mid start) ⟨copyOutG,.normal⟩ initRun loopRun
  have s5Run : Exec MakeFgTailShape190.s5 copyOutG ⟨copyOutG,.normal⟩ :=
    SelectedStepGsCopy194.skip_source start copyOutG
      (fun name different => (localRun name different).trans
        (SelectedStepGsCopy194.mid_locals start name different)) inNttCell
  have copyLocalsBase : ∀ name : Name, name≠"v".toList →
      copyOutG.locals name=SelectedStepProduct191.base.locals name := by
    intro name different
    exact (localRun name different).trans
      ((SelectedStepGsCopy194.mid_locals start name different).trans (localsKeepStart name different))
  have copyArraysBase : ∀ name : Name, name≠"x".toList →
      copyOutG.arrays name=SelectedStepProduct191.base.arrays name := by
    intro name different
    exact (arrayRun name different).trans
      ((SelectedStepGsCopy194.mid_arrays start name different).trans (arraysKeepStart name different))
  have copyU : Cell copyOutG "u".toList 0 :=
    (copyLocalsBase "u".toList (by decide)).trans (by exact SelectedGen0Ready189.u_cell)
  have copyHn : Cell copyOutG "hn".toList 256 :=
    (copyLocalsBase "hn".toList (by decide)).trans (by exact SelectedGen0Ready189.hn_cell)
  have copyTlen : Cell copyOutG "tlen".toList 2 :=
    (copyLocalsBase "tlen".toList (by decide)).trans (by exact SelectedGen0Ready189.tlen_cell)
  have copyP : Slot copyOutG "p" SelectedTopInit178.p :=
    (copyLocalsBase "p".toList (by decide)).trans (by exact SelectedGen0Ready189.p_cell)
  have copyI : Slot copyOutG "p0i" SelectedTopInit178.p0i :=
    (copyLocalsBase "p0i".toList (by decide)).trans (by exact SelectedGen0Ready189.i_cell)
  have copyR2 : Slot copyOutG "R2" SelectedTopInit178.r2 :=
    (copyLocalsBase "R2".toList (by decide)).trans (by exact SelectedGen0Ready189.r2_cell)
  have copyGd : copyOutG.arrays "gd".toList=some gd :=
    (copyArraysBase "gd".toList (by decide)).trans (by exact SelectedGen0Ready189.gd_binding)
  have copyT1 : copyOutG.arrays "t1".toList=some t1 :=
    (copyArraysBase "t1".toList (by decide)).trans (by exact SelectedGen0Ready189.t1_binding)
  have copyT1Image : ∀ i : Fin 512, Load32 copyOutG.heap (elem t1 i.val)
      (SelectedStepChainKeep194.gvs i.val) :=
    fun i => prefixImgRun i i.isLt
  have copyGsReads : ∀ k : Nat, k<512 →
      Load32 copyOutG.heap ({gs with index := gs.index+k}) (SelectedStepChainKeep194.gvs k) := by
    intro k bound
    have read := fixedRun.src ⟨k,bound⟩
    rw [SelectedStepGsCopy194.addr_gs k] at read
    exact read
  have copyGdWritable : copyOutG.heap.writable gd.block=true := by
    exact fixedRun.t1Writable
  obtain ⟨prodOut,s6Run,outFixed,outV,outX,outImage,outReadsGs,outReadsIgm,prodLocals,
    prodArrays⟩ :=
    SelectedStepGsProduct194.source copyOutG SelectedStepChainKeep194.gvs SelectedStepChain193.tws
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
      Separate (NttInverseCorrectionLoop192.walk (addr gs 0 0 1) j 1)
        (NttInverseCorrectionLoop192.walk (addr gs 0 0 1) k 1) := by
    intro j k bj bk different
    rw [SelectedStepGsInverse194.walk_gs j,SelectedStepGsInverse194.walk_gs k]
    exact SelectedStepGsCopy194.gs_elem_separate j k different
  have prodTwSeparate : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (NttInverseCorrectionLoop192.walk (addr gs 0 0 1) j 1)
        ({igm with index := igm.index+k}) := by
    intro k bk j bj
    rw [SelectedStepGsInverse194.walk_gs j]
    exact SelectedStepGsChain194.gs_igm_separate j k bj bk
  have prodGsImage : ∀ i : Fin 512, Load32 prodOut.heap (elem gs i.val)
      (SelectedStepChainKeep194.gvs i.val) := by
    intro i
    exact outReadsGs i.val i.isLt
  obtain ⟨final,s7Run,finalImage,finalLocals,finalArrays,s7Keep,_⟩ :=
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
  have gdImage : Image final gd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepChainKeep194.gvs 256 := by
    intro i bound
    have load := outImage i bound
    exact s7Keep (addr gd 0 i.val 2) (fun x _ => gd_gs_walk x i.val i.isLt)
      (StepProductBody191.value (SelectedStepChainKeep194.gvs (2*i.val))
        (SelectedStepChainKeep194.gvs (2*i.val+1)) SelectedTopInit178.r2
        SelectedTopInit178.p SelectedTopInit178.p0i) load
  exact ⟨start,final,prefixRun,wholeRun,finalImage,gdImage,fdImageStart,fsImageStart,
    finalLocals,finalArrays⟩

end FT1536.Source3.SelectedStepFull194
