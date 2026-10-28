import Source3.SeventhStepContext217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SeventhStepFirst217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (rev)
open SeventhStepLayout217 (fs gs)
open SeventhStepEntry217 (caller fWords gWords)
open SeventhStepLoop217 (rowWords)
open SeventhStepInvariant217 (Active)
open ZintNormWalkFlat208 (Data)

def fragment : KeygenMakeFgSource.Stmt :=
  .seq (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1)) (KeygenMakeFgSource.part .step 2)

/- All42 first-prime iterations are built from the actual seventh caller;
   each indexed source row, table and output image shares one witness. -/
theorem source : ∃ (callee second third fourth fifth sixth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (firstTables extraTables : Nat → Fin 16 → BitVec 32)
    (tables : Nat → Fin 8 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth sixth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SeventhStepEntry217.entry (caller callee second third fourth fifth sixth)) ∧
    Exec fragment (SeventhStepEntry217.entry (caller callee second third fourth fifth sixth)) ⟨out,.normal⟩ ∧
    Active out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) tables 42 ∧
    Data out fs 336 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) tables) ∧
    Data out gs 336 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) tables) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,binding,prefixRun,fdata,gdata⟩:=SeventhStepPrefix217.source
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
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap (caller callee second third fourth fifth sixth).heap :=
    KeygenMemoryStability.trans _ _ _ stable5 sixthStable
  have stable6:=SeventhStepContext217.stable_entry (caller callee second third fourth fifth sixth) stable prefixRun
  have revInitial : (caller callee second third fourth fifth sixth).tables "REV10".toList=some rev := by
    change FirstStepEntry187.entry.arrays "REV10".toList=some rev
    exact StepStaticInputs187.rev_binding
  obtain ⟨out,tables,loopRun,active,fsImage,gsImage⟩:=
    SeventhStepLoop217.source (SeventhStepContext217.before (caller callee second third fourth fifth sixth))
      (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables)
      (SeventhStepContext217.u_declared _) (SeventhStepContext217.outer _ stable)
      (SeventhStepContext217.object _ stable6) (SeventhStepContext217.rev_binding _ revInitial prefixRun)
      (SeventhStepContext217.rev_source _ stable6) fdata gdata
  exact ⟨callee,second,third,fourth,fifth,sixth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,tables,
    run1,run2,run3,run4,run5,run6,binding,.seqNormal _ _ _ _ _ prefixRun loopRun,active,fsImage,gsImage⟩

end FT1536.Source3.SeventhStepFirst217
