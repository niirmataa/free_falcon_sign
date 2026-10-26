import Source3.SecondStepCrtStatics208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepCrtFull208
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open SecondStepLayout197 (fd gd fs gs)
open SelectedTopInit178 (p p0i r2)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open SecondStepFirstColumn203 (inputWord)
open SecondStepFirstBody203 (gInputWord)
open SecondStepLoop204 (oddF oddG)
open ZintNormWalkFlat208 (Data)

def fragment : KeygenMakeFgSource.Stmt := .seq SecondStepLoop204.fragment MakeFgCrtShape194.part3
 noncomputable def fsWords (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 : Fin 256 → BitVec 32) :=
  CrtBody208.words (SecondStepInterleave204.fsWords oldWords ivs0 ivs1)
 noncomputable def gsWords (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 : Fin 256 → BitVec 32) :=
  CrtBody208.words (SecondStepInterleave204.gsWords oldWords ivs0 ivs1)

/- No successful run, desired transform/CRT output, or caller memory image
   is supplied as a premise. Both step prefixes and all images are built. -/
theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepStatics204.entry callee) ∧
    Exec fragment (SecondStepStatics204.entry callee) ⟨out,.normal⟩ ∧ SecondStepOuter204.Outer out 2 ∧
    StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
    StepProductFixed203.Image out fd 1 3 128 p1 p0i1 r21 (oddF oldWords) 128 ∧
    StepProductFixed203.Image out gd 0 3 128 p p0i r2 (gInputWord oldWords) 128 ∧
    StepProductFixed203.Image out gd 1 3 128 p1 p0i1 r21 (oddG oldWords) 128 ∧
    Data out fs 512 (fsWords oldWords ivs0 ivs1) ∧ Data out gs 512 (gsWords oldWords ivs0 ivs1) := by
  obtain ⟨callee,loopOut,oldWords,ivs0,ivs1,firstRun,binding,loopRun,outer,fd0,fd1,gd0,gd1,fdata,gdata⟩:=SecondStepInterleave204.source
  have object:=SecondStepCrtStatics208.prime_object callee loopOut firstRun loopRun
  obtain ⟨out,crtRun,finalOuter,finalF,finalG,_,_,keep⟩:=SecondStepCrtPair208.source loopOut
    (SecondStepInterleave204.fsWords oldWords ivs0 ivs1) (SecondStepInterleave204.gsWords oldWords ivs0 ivs1) outer object fdata gdata
  refine ⟨callee,out,oldWords,ivs0,ivs1,firstRun,binding,.seqNormal _ _ _ _ _ loopRun crtRun,finalOuter,?_,?_,?_,?_,finalF,finalG⟩
  · exact SecondStepCrtPair208.product loopOut out keep .f 0 (by decide) p p0i r2 (inputWord oldWords) fd0
  · exact SecondStepCrtPair208.product loopOut out keep .f 1 (by decide) p1 p0i1 r21 (oddF oldWords) fd1
  · exact SecondStepCrtPair208.product loopOut out keep .g 0 (by decide) p p0i r2 (gInputWord oldWords) gd0
  · exact SecondStepCrtPair208.product loopOut out keep .g 1 (by decide) p1 p0i1 r21 (oddG oldWords) gd1

end FT1536.Source3.SecondStepCrtFull208
