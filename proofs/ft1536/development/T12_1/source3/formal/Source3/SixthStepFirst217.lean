import Source3.SixthStepContext217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SixthStepFirst217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (rev)
open SixthStepLayout217 (fs gs)
open SixthStepEntry217 (caller fWords gWords)
open SixthStepLoop217 (rowWords)
open SixthStepInvariant217 (Active)
open ZintNormWalkFlat208 (Data)

def fragment : KeygenMakeFgSource.Stmt :=
  .seq (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1)) (KeygenMakeFgSource.part .step 2)

/- All22 first-prime iterations are built from the actual sixth caller;
   each indexed source row, table and output image shares one witness. -/
theorem source : ∃ (callee second third fourth fifth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (firstTables extraTables : Nat → Fin 32 → BitVec 32)
    (tables : Nat → Fin 16 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SixthStepEntry217.entry (caller callee second third fourth fifth)) ∧
    Exec fragment (SixthStepEntry217.entry (caller callee second third fourth fifth)) ⟨out,.normal⟩ ∧
    Active out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) tables 22 ∧
    Data out fs 352 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) tables) ∧
    Data out gs 352 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) tables) := by
  obtain ⟨callee,second,third,fourth,fifth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,
    run1,run2,run3,run4,run5,binding,prefixRun,fdata,gdata⟩:=SixthStepPrefix217.source
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
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap (caller callee second third fourth fifth).heap :=
    KeygenMemoryStability.trans _ _ _ stable4 fifthStable
  have stable6:=SixthStepContext217.stable_entry (caller callee second third fourth fifth) stable prefixRun
  have revInitial : (caller callee second third fourth fifth).tables "REV10".toList=some rev := by
    change FirstStepEntry187.entry.arrays "REV10".toList=some rev
    exact StepStaticInputs187.rev_binding
  obtain ⟨out,tables,loopRun,active,fsImage,gsImage⟩:=
    SixthStepLoop217.source (SixthStepContext217.before (caller callee second third fourth fifth))
      (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables)
      (SixthStepContext217.u_declared _) (SixthStepContext217.outer _ stable)
      (SixthStepContext217.object _ stable6) (SixthStepContext217.rev_binding _ revInitial prefixRun)
      (SixthStepContext217.rev_source _ stable6) fdata gdata
  exact ⟨callee,second,third,fourth,fifth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,tables,
    run1,run2,run3,run4,run5,binding,.seqNormal _ _ _ _ _ prefixRun loopRun,active,fsImage,gsImage⟩

end FT1536.Source3.SixthStepFirst217
