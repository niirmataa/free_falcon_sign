import Source3.ThirdStepBody216
import Source3.ThirdStepContext216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepFull216
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (rev)
open ThirdStepLayout215 (fs gs)
open ThirdStepBody216 (FirstImages ExtraImages merged)
open ThirdStepCrtExtra216 (Words)
open ZintNormWalkFlat208 (Data)

noncomputable def caller (callee second : State) := SecondStepReturn212.advance (SecondStepReturn212.returned callee second)
 noncomputable def fInput (oldWords : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32) :=
  SecondStepImage212.fWords oldWords iv0 iv1 gv2
 noncomputable def gInput (oldWords : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32) :=
  SecondStepImage212.gWords oldWords iv0 iv1 gv2

theorem complete (s middle out : State)
    (prefixRun0 : Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1)) s ⟨middle,.normal⟩)
    (body : Exec (.seq (KeygenMakeFgSource.part .step 2) (.seq MakeFgCrtShape194.part3 MakeFgAddPrimeShape194.part4)) middle ⟨out,.normal⟩) :
    Exec (KeygenMakeFgSource.code .step) s ⟨out,.normal⟩ := by
  obtain ⟨afterDecl,decl,start⟩:=SecondExtraPair212.normal_seq _ _ s middle prefixRun0
  obtain ⟨afterLoop,loop,rest⟩:=SecondExtraPair212.normal_seq _ _ middle out body
  obtain ⟨afterCrt,crt,extra⟩:=SecondExtraPair212.normal_seq _ _ afterLoop out rest
  exact .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ start (.seqNormal _ _ _ _ _ loop
    (.seqNormal _ _ _ _ _ crt (.seqNormal _ _ _ _ _ extra (SelectedStepAddPrime195.skip_run out)))))

/- The caller, entry, both earlier steps and this complete source execution
   are constructed together. No desired output or source run is a premise. -/
theorem source : ∃ (callee second out : State) (oldWords : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (ThirdStepEntry215.entry (caller callee second)) ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (caller callee second)) ⟨out,.normal⟩ ∧
    ThirdStepGenerator215.Outer out 6 ∧
    FirstImages out (fInput oldWords iv0 iv1 gv2) (gInput oldWords iv0 iv1 gv2) ∧
    ExtraImages out (Words (merged (fInput oldWords iv0 iv1 gv2) i0 i1 i2))
      (Words (merged (gInput oldWords iv0 iv1 gv2) i0 i1 i2)) g3 g4 g5 ∧
    Data out fs 384 (Words (merged (fInput oldWords iv0 iv1 gv2) i0 i1 i2)) ∧
    Data out gs 384 (Words (merged (gInput oldWords iv0 iv1 gv2) i0 i1 i2)) := by
  obtain ⟨callee,second,oldWords,iv0,iv1,gv2,firstRun,secondRun,binding,prefixRun,fdata,gdata⟩:=ThirdStepPrefix215.source
  have first:=KeygenHelperStability.make _ _ _ firstRun
  have secondStable:=KeygenHelperStability.make _ _ _ secondRun
  change KeygenMemoryStability.Stable (SecondStepStatics204.entry callee).heap second.heap at secondStable
  rw [SecondStepStatics204.entry_heap] at secondStable
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap (caller callee second).heap :=
    KeygenMemoryStability.trans _ _ _ first secondStable
  have stable3:=ThirdStepContext216.stable_entry (caller callee second) stable prefixRun
  have revInitial : (caller callee second).tables "REV10".toList=some rev := by
    change FirstStepEntry187.entry.arrays "REV10".toList=some rev
    exact StepStaticInputs187.rev_binding
  obtain ⟨out,i0,i1,i2,g3,g4,g5,body,outer,firstImages,extraImages,fsImage,gsImage⟩:=
    ThirdStepBody216.source (ThirdStepContext216.before (caller callee second))
      (fInput oldWords iv0 iv1 gv2) (gInput oldWords iv0 iv1 gv2)
      (ThirdStepContext216.u_declared _) (ThirdStepContext216.outer _ stable)
      (ThirdStepContext216.object _ stable3) (ThirdStepContext216.rev_binding _ revInitial prefixRun)
      (ThirdStepContext216.rev_source _ stable3) fdata gdata
  exact ⟨callee,second,out,oldWords,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstRun,secondRun,binding,
    complete _ _ _ prefixRun body,outer,firstImages,extraImages,fsImage,gsImage⟩

end FT1536.Source3.ThirdStepFull216
