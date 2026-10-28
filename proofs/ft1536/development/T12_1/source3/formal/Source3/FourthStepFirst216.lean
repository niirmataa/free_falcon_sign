import Source3.FourthStepContext216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FourthStepFirst216
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (rev)
open FourthStepLayout216 (fs gs)
open FourthStepEntry216 (caller fWords gWords)
open FourthStepLoop216 (rowWords)
open FourthStepInvariant216 (Active)
open ZintNormWalkFlat208 (Data)

def fragment : KeygenMakeFgSource.Stmt :=
  .seq (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1)) (KeygenMakeFgSource.part .step 2)

/- The first six d4 prime iterations are built from the actual source
   caller and prefix; all tables and the previously written rows share
   the final output witness. -/
theorem source : ∃ (callee second third out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (tables : Nat → Fin 64 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (FourthStepEntry216.entry (caller callee second third)) ∧
    Exec fragment (FourthStepEntry216.entry (caller callee second third)) ⟨out,.normal⟩ ∧
    Active out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) tables 6 ∧
    Data out fs 384 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) tables) ∧
    Data out gs 384 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) tables) := by
  obtain ⟨callee,second,third,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,run1,run2,run3,binding,prefixRun,fdata,gdata⟩:=FourthStepPrefix216.source
  have first:=KeygenHelperStability.make _ _ _ run1
  have later:=KeygenHelperStability.make _ _ _ run2
  change KeygenMemoryStability.Stable (SecondStepStatics204.entry callee).heap second.heap at later
  rw [SecondStepStatics204.entry_heap] at later
  have stable2:=KeygenMemoryStability.trans _ _ _ first later
  have last:=KeygenHelperStability.make _ _ _ run3
  change KeygenMemoryStability.Stable (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)).heap third.heap at last
  rw [ThirdStepEntry215.entry_heap] at last
  have previousHeap : (ThirdStepFull216.caller callee second).heap=second.heap := rfl
  rw [previousHeap] at last
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap (caller callee second third).heap :=
    KeygenMemoryStability.trans _ _ _ stable2 last
  have stable4:=FourthStepContext216.stable_entry (caller callee second third) stable prefixRun
  have revInitial : (caller callee second third).tables "REV10".toList=some rev := by
    change FirstStepEntry187.entry.arrays "REV10".toList=some rev
    exact StepStaticInputs187.rev_binding
  obtain ⟨out,tables,loopRun,active,fsImage,gsImage⟩:=
    FourthStepLoop216.source (FourthStepContext216.before (caller callee second third))
      (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
      (FourthStepContext216.u_declared _) (FourthStepContext216.outer _ stable)
      (FourthStepContext216.object _ stable4) (FourthStepContext216.rev_binding _ revInitial prefixRun)
      (FourthStepContext216.rev_source _ stable4) fdata gdata
  exact ⟨callee,second,third,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,tables,run1,run2,run3,binding,
    .seqNormal _ _ _ _ _ prefixRun loopRun,active,fsImage,gsImage⟩

end FT1536.Source3.FourthStepFirst216
