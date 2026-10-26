import Source3.SecondExtraLoop212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepFull212
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open SecondStepLayout197 (fd gd)
open SelectedTopInit178 (p p0i r2)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open SecondExtraPrime212 (p2 i2 r22 rx2)
open SecondStepFirstColumn203 (inputWord)
open SecondStepFirstBody203 (gInputWord)
open SecondStepLoop204 (oddF oddG)

noncomputable def extraF (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32) :=
  SecondExtraSide212.words (SecondStepCrtFull208.fsWords oldWords ivs0 ivs1) gvs2 p2 i2 r22 rx2
 noncomputable def extraG (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32) :=
  SecondExtraSide212.words (SecondStepCrtFull208.gsWords oldWords ivs0 ivs1) gvs2 p2 i2 r22 rx2

theorem complete (s mid out : State) (prefixRun : Exec SecondStepCrtFull208.fragment s ⟨mid,.normal⟩)
    (lastRun : Exec MakeFgAddPrimeShape194.part4 mid ⟨out,.normal⟩) :
    Exec (KeygenMakeFgSource.code .step) s ⟨out,.normal⟩ := by
  obtain ⟨beforeCrt,early,crt⟩:=SecondExtraPair212.normal_seq _ _ s mid prefixRun
  obtain ⟨beforeLoop,firstTwo,loop⟩:=SecondExtraPair212.normal_seq _ _ s beforeCrt early
  obtain ⟨afterDecl,decl,start⟩:=SecondExtraPair212.normal_seq _ _ s beforeLoop firstTwo
  exact .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ start (.seqNormal _ _ _ _ _ loop
    (.seqNormal _ _ _ _ _ crt (.seqNormal _ _ _ _ _ lastRun (SelectedStepAddPrime195.skip_run out)))))

/- Every source run and all six product columns are constructed. -/
theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepStatics204.entry callee) ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨out,.normal⟩ ∧ SecondStepOuter204.Outer out 3 ∧
    StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
    StepProductFixed203.Image out fd 1 3 128 p1 p0i1 r21 (oddF oldWords) 128 ∧
    StepProductFixed203.Image out fd 2 3 128 p2 i2 r22 (extraF oldWords ivs0 ivs1 gvs2) 128 ∧
    StepProductFixed203.Image out gd 0 3 128 p p0i r2 (gInputWord oldWords) 128 ∧
    StepProductFixed203.Image out gd 1 3 128 p1 p0i1 r21 (oddG oldWords) 128 ∧
    StepProductFixed203.Image out gd 2 3 128 p2 i2 r22 (extraG oldWords ivs0 ivs1 gvs2) 128 := by
  obtain ⟨callee,crtOut,oldWords,ivs0,ivs1,firstRun,binding,crtRun,outer,fd0,fd1,gd0,gd1,fdata,gdata⟩:=SecondStepCrtFull208.source
  obtain ⟨out,gvs2,lastRun,finalOuter,fd2,gd2,_,_,keep⟩:=SecondExtraLoop212.source crtOut _ _ outer
    (SecondExtraStatics212.prime_object callee crtOut firstRun crtRun)
    (SecondExtraStatics212.rev_binding callee crtOut crtRun)
    (SecondExtraStatics212.rev_source callee crtOut firstRun crtRun) fdata gdata
  refine ⟨callee,out,oldWords,ivs0,ivs1,gvs2,firstRun,binding,complete _ _ _ crtRun lastRun,finalOuter,?_,?_,fd2,?_,?_,gd2⟩
  · exact SecondExtraLoop212.earlier_product _ _ keep .f 0 (by decide) p p0i r2 _ fd0
  · exact SecondExtraLoop212.earlier_product _ _ keep .f 1 (by decide) p1 p0i1 r21 _ fd1
  · exact SecondExtraLoop212.earlier_product _ _ keep .g 0 (by decide) p p0i r2 _ gd0
  · exact SecondExtraLoop212.earlier_product _ _ keep .g 1 (by decide) p1 p0i1 r21 _ gd1

end FT1536.Source3.SecondStepFull212
