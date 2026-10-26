import Source3.SecondStepReady203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepFirstColumn203
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open SecondStepLayout197 (fd fs gs igm)
open StepCopyBody190 (addr elem)
open SelectedTopInit178 (p p0i r2)
open SecondStepBasic203 (Basic)
open NttInverseWholeBridges201 (scaledWord)

def tableWord (ivs : Fin 256 → BitVec 32) (j : Nat) := ivs ⟨j%256,Nat.mod_lt _ (by decide)⟩
noncomputable def inputWord (oldWords : Fin 512 → BitVec 32) (j : Nat) := StepFirstImage196.fdWords oldWords (j*2)

def fragment : KeygenMakeFgSource.Stmt := .seq SecondStepGeneratorPrefix200.fragment (SecondStepColumn203.code .f)

theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ∧
    Exec fragment (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ⟨out,.normal⟩ ∧
    Basic out 0 p p0i r2 ∧ Cell out "v".toList 128 ∧
    StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
    (∀ j<256, Load32 out.heap (addr fs 0 j 2) (scaledWord 7 (inputWord oldWords) (tableWord ivs) p p0i j)) ∧
    StepNttImage195.Image out gs (StepFirstImage196.gdWords oldWords) ∧
    (∀ k<256, Load32 out.heap (elem igm k) (tableWord ivs k)) := by
  obtain ⟨callee,ready,oldWords,gvs,ivs,firstRun,binding,readyRun,basic,v,gRead,iRead,fImage,gImage⟩ := SecondStepReady203.source
  have twLoads : ∀ k<256, Load32 ready.heap (elem igm k) (tableWord ivs k) := by
    intro k bound
    simpa only [tableWord,Nat.mod_eq_of_lt bound] using iRead ⟨k,bound⟩
  have data : ∀ j<256, Load32 ready.heap (addr fs 0 j 2) (inputWord oldWords j) := by
    intro j bound
    change Load32 ready.heap (elem fs (j*2)) (StepFirstImage196.fdWords oldWords (j*2))
    exact fImage (j*2) (by omega)
  obtain ⟨out,columnRun,outBasic,outV,productImage,image,keeps⟩ :=
    SecondStepColumn203.source .f ready 0 p p0i r2 basic (by decide) (tableWord ivs) (inputWord oldWords) twLoads data none v
  refine ⟨callee,out,oldWords,ivs,firstRun,binding,.seqNormal _ _ _ ready _ readyRun columnRun,
    outBasic,outV,productImage,image,?_,?_⟩
  · intro k bound
    apply keeps (elem gs k) ?_ ?_ ?_ _ (gImage k bound)
    · intro i
      apply StepCopyFixed190.separate_symm
      change Word32Memory176.Separate (SecondStepGeometry203.scratch (1950+k)) (SecondStepGeometry203.scratch (2974+i.val))
      exact SecondStepGeometry203.ordered _ _ (by omega)
    · intro i
      rw [SecondStepGeometry203.product_shape]
      change Word32Memory176.Separate (SecondStepGeometry203.scratch (670+0+i.val*3)) (SecondStepGeometry203.scratch (1950+k))
      exact SecondStepGeometry203.ordered _ _ (by have b:=i.isLt; omega)
    · intro j slot
      rw [SecondStepGeometry203.data_shape]
      change Word32Memory176.Separate (SecondStepGeometry203.scratch (1438+0+j*2)) (SecondStepGeometry203.scratch (1950+k))
      exact SecondStepGeometry203.ordered _ _ (by omega)
  · intro k bound
    exact keeps (elem igm k) (SecondStepGeometry203.copy_twiddle k bound)
      (fun i => SecondStepGeometry203.product_twiddle .f 0 i.val k (by decide) i.isLt)
      (fun j slot => SecondStepInverse203.tw_separate .f 0 j k (by decide) slot) _ (twLoads k bound)

end FT1536.Source3.SecondStepFirstColumn203
