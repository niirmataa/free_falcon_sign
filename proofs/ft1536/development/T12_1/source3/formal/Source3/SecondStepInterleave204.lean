import Source3.SecondStepLoop204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepInterleave204
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (addr elem)
open StepFirstImage196 (interleave)
open SecondStepLayout197 (fd gd fs gs)
open SelectedTopInit178 (p p0i r2)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open SecondStepFirstColumn203 (inputWord tableWord)
open SecondStepFirstBody203 (gInputWord)
open SecondStepLoop204 (oddF oddG)
open NttInverseWholeBridges201 (scaledWord)

theorem columns {s : State} {a : ArrayPointer} {W0 W1 : Nat → BitVec 32}
    (even : ∀ j<256, Load32 s.heap (addr a 0 j 2) (W0 j))
    (odd : ∀ j<256, Load32 s.heap (addr a 1 j 2) (W1 j)) :
    StepNttImage195.Image s a (interleave W0 W1) := by
  intro j bound
  have indexBound : j/2<256 := by omega
  by_cases parity : j%2=0
  · have address : elem a j=addr a 0 (j/2) 2 := by
      change {a with index:=a.index+j}={a with index:=a.index+0+(j/2)*2}
      apply congrArg (fun k : Nat => (⟨a.block,a.base,a.count,a.elementBytes,k⟩ : ArrayPointer))
      omega
    have read:=even (j/2) indexBound
    change Load32 s.heap (elem a j) _
    rw [address]
    simpa only [interleave,parity,ite_true] using read
  · have address : elem a j=addr a 1 (j/2) 2 := by
      change {a with index:=a.index+j}={a with index:=a.index+1+(j/2)*2}
      apply congrArg (fun k : Nat => (⟨a.block,a.base,a.count,a.elementBytes,k⟩ : ArrayPointer))
      omega
    have read:=odd (j/2) indexBound
    change Load32 s.heap (elem a j) _
    rw [address]
    simpa only [interleave,parity,ite_false] using read

noncomputable def fsWords (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 : Fin 256 → BitVec 32) :=
  interleave (scaledWord 7 (inputWord oldWords) (tableWord ivs0) p p0i)
    (scaledWord 7 (oddF oldWords) (tableWord ivs1) p1 p0i1)
noncomputable def gsWords (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 : Fin 256 → BitVec 32) :=
  interleave (scaledWord 7 (gInputWord oldWords) (tableWord ivs0) p p0i)
    (scaledWord 7 (oddG oldWords) (tableWord ivs1) p1 p0i1)

theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepStatics204.entry callee) ∧
    Exec SecondStepLoop204.fragment (SecondStepStatics204.entry callee) ⟨out,.normal⟩ ∧
    SecondStepOuter204.Outer out 2 ∧
    StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
    StepProductFixed203.Image out fd 1 3 128 p1 p0i1 r21 (oddF oldWords) 128 ∧
    StepProductFixed203.Image out gd 0 3 128 p p0i r2 (gInputWord oldWords) 128 ∧
    StepProductFixed203.Image out gd 1 3 128 p1 p0i1 r21 (oddG oldWords) 128 ∧
    StepNttImage195.Image out fs (fsWords oldWords ivs0 ivs1) ∧
    StepNttImage195.Image out gs (gsWords oldWords ivs0 ivs1) := by
  obtain ⟨callee,out,oldWords,ivs0,ivs1,firstRun,binding,run,outer,_,fd0,fd1,gd0,gd1,fs0,fs1,gs0,gs1⟩ := SecondStepLoop204.source
  exact ⟨callee,out,oldWords,ivs0,ivs1,firstRun,binding,run,outer,fd0,fd1,gd0,gd1,columns fs0 fs1,columns gs0 gs1⟩

end FT1536.Source3.SecondStepInterleave204
