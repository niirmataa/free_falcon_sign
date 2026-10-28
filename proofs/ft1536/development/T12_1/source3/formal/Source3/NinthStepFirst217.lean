import Source3.NinthStepContext217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NinthStepFirst217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (rev)
open NinthStepLayout217 (fs gs)
open NinthStepEntry217 (caller fWords gWords)
open NinthStepLoop217 (rowWords)
open NinthStepInvariant217 (Active)
open ZintNormWalkFlat208 (Data)

def fragment : KeygenMakeFgSource.Stmt :=
  .seq (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1)) (KeygenMakeFgSource.part .step 2)

/- All166 first-prime iterations are built from the actual ninth caller;
   each indexed source row, table and output image shares one witness. -/
theorem source : ∃ (callee second third fourth fifth sixth seventh eighth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32) (first8 extra8 : Nat → Fin 4 → BitVec 32)
    (tables : Nat → Fin 2 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)) ⟨seventh,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (EighthStepEntry217.entry (EighthStepEntry217.caller callee second third fourth fifth sixth seventh)) ⟨eighth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth sixth seventh eighth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (NinthStepEntry217.entry (caller callee second third fourth fifth sixth seventh eighth)) ∧
    Exec fragment (NinthStepEntry217.entry (caller callee second third fourth fifth sixth seventh eighth)) ⟨out,.normal⟩ ∧
    Active out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) tables 166 ∧
    Data out fs 332 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) tables) ∧
    Data out gs 332 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) tables) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,
    run1,run2,run3,run4,run5,run6,run7,run8,binding,prefixRun,fdata,gdata⟩:=NinthStepPrefix217.source
  have first:=KeygenHelperStability.make _ _ _ run1
  have later:=KeygenHelperStability.make _ _ _ run2
  change KeygenMemoryStability.Stable (SecondStepStatics204.entry callee).heap second.heap at later
  rw [SecondStepStatics204.entry_heap] at later
  have stable2:=KeygenMemoryStability.trans _ _ _ first later
  have thirdStable:=KeygenHelperStability.make _ _ _ run3
  change KeygenMemoryStability.Stable (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)).heap third.heap at thirdStable
  rw [ThirdStepEntry215.entry_heap] at thirdStable
  have secondHeap : (ThirdStepFull216.caller callee second).heap=second.heap := rfl
  rw [secondHeap] at thirdStable
  have stable3:=KeygenMemoryStability.trans _ _ _ stable2 thirdStable
  have fourthStable:=KeygenHelperStability.make _ _ _ run4
  change KeygenMemoryStability.Stable (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)).heap fourth.heap at fourthStable
  rw [FourthStepEntry216.entry_heap] at fourthStable
  have thirdHeap : (FourthStepEntry216.caller callee second third).heap=third.heap := rfl
  rw [thirdHeap] at fourthStable
  have stable4:=KeygenMemoryStability.trans _ _ _ stable3 fourthStable
  have fifthStable:=KeygenHelperStability.make _ _ _ run5
  change KeygenMemoryStability.Stable (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)).heap fifth.heap at fifthStable
  rw [FifthStepEntry217.entry_heap] at fifthStable
  have fourthHeap : (FifthStepEntry217.caller callee second third fourth).heap=fourth.heap := rfl
  rw [fourthHeap] at fifthStable
  have stable5:=KeygenMemoryStability.trans _ _ _ stable4 fifthStable
  have sixthStable:=KeygenHelperStability.make _ _ _ run6
  change KeygenMemoryStability.Stable (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)).heap sixth.heap at sixthStable
  rw [SixthStepEntry217.entry_heap] at sixthStable
  have fifthHeap : (SixthStepEntry217.caller callee second third fourth fifth).heap=fifth.heap := rfl
  rw [fifthHeap] at sixthStable
  have stablePre:=KeygenMemoryStability.trans _ _ _ stable5 sixthStable
  have seventhStable:=KeygenHelperStability.make _ _ _ run7
  change KeygenMemoryStability.Stable (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)).heap seventh.heap at seventhStable
  rw [SeventhStepEntry217.entry_heap] at seventhStable
  have sixthHeap : (SeventhStepEntry217.caller callee second third fourth fifth sixth).heap=sixth.heap := rfl
  rw [sixthHeap] at seventhStable
  have stablePre7:=KeygenMemoryStability.trans _ _ _ stablePre seventhStable
  have eighthStable:=KeygenHelperStability.make _ _ _ run8
  change KeygenMemoryStability.Stable (EighthStepEntry217.entry (EighthStepEntry217.caller callee second third fourth fifth sixth seventh)).heap eighth.heap at eighthStable
  rw [EighthStepEntry217.entry_heap] at eighthStable
  have seventhHeap : (EighthStepEntry217.caller callee second third fourth fifth sixth seventh).heap=seventh.heap := rfl
  rw [seventhHeap] at eighthStable
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap (caller callee second third fourth fifth sixth seventh eighth).heap :=
    KeygenMemoryStability.trans _ _ _ stablePre7 eighthStable
  have stable6:=NinthStepContext217.stable_entry (caller callee second third fourth fifth sixth seventh eighth) stable prefixRun
  have revInitial : (caller callee second third fourth fifth sixth seventh eighth).tables "REV10".toList=some rev := by
    change FirstStepEntry187.entry.arrays "REV10".toList=some rev
    exact StepStaticInputs187.rev_binding
  obtain ⟨out,tables,loopRun,active,fsImage,gsImage⟩:=
    NinthStepLoop217.source (NinthStepContext217.before (caller callee second third fourth fifth sixth seventh eighth))
      (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8)
      (NinthStepContext217.u_declared _) (NinthStepContext217.outer _ stable)
      (NinthStepContext217.object _ stable6) (NinthStepContext217.rev_binding _ revInitial prefixRun)
      (NinthStepContext217.rev_source _ stable6) fdata gdata
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,tables,
    run1,run2,run3,run4,run5,run6,run7,run8,binding,.seqNormal _ _ _ _ _ prefixRun loopRun,active,fsImage,gsImage⟩

end FT1536.Source3.NinthStepFirst217
