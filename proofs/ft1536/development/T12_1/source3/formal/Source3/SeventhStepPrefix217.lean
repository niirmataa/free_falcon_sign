import Source3.SeventhStepMove217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SeventhStepPrefix217
open C99ArrayReference (State)
open C99MemoryReference (Load64)
open KeygenMakeFgSource (Exec)
open ZintNormWalkFlat208 (Data)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open SeventhStepLayout217 (fd gd fs gs gm igm t1)

theorem fd_bridge : SeventhStepLayout217.fd=SixthStepLayout217.fd := rfl
theorem gd_distinct : SeventhStepLayout217.gd≠SixthStepLayout217.gd := by decide

/-- The actual d=7 part 1 after its declarations, with the overlapping copy. -/
theorem part1 (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (SeventhStepLengths217.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (SeventhStepLengths217.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read7 : Load64 (SeventhStepLengths217.before s).heap (element small3 7) 42)
    (read8 : Load64 (SeventhStepLengths217.before s).heap (element small3 8) 82)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 336 Wf) (gImage : Data s SixthStepLayout217.gd 336 Wg) :
    Exec (KeygenMakeFgSource.part .step 1) (SeventhStepStart217.declared s)
      ⟨SeventhStepMove217.after s,.normal⟩ := by
  apply SeventhStepStart217.part1_continue s
  exact .seqNormal _ _ (SeventhStepLengths217.before s) (SeventhStepLengths217.after s) _
    (SeventhStepLengths217.source s small prime read7 read8)
    (MakeFgSequence187.source StepPrefixProgram187.pointers (SeventhStepLayout217.before s)
      (SeventhStepLayout217.after s) (SeventhStepLayout217.pointers s) _ _
      (.seqNormal _ _ (SeventhStepMove217.before s) (SeventhStepMove217.after s) _
        (SeventhStepMove217.move_source s Wf Wg stable fImage gImage)
        (SelectedStepAddPrime195.skip_run _)))

theorem prefix_run (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (SeventhStepLengths217.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (SeventhStepLengths217.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read7 : Load64 (SeventhStepLengths217.before s).heap (element small3 7) 42)
    (read8 : Load64 (SeventhStepLengths217.before s).heap (element small3 8) 82)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 336 Wf) (gImage : Data s SixthStepLayout217.gd 336 Wg) :
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (SeventhStepEntry217.entry s) ⟨SeventhStepMove217.after s,.normal⟩ :=
  .seqNormal _ _ _ (SeventhStepStart217.declared s) _
    (StepDeclarations187.source _) (part1 s Wf Wg small prime read7 read8 stable fImage gImage)

/- Actual seventh entry and original part0/part1 with both prior fd/gd images
   moved into the new fs/gs roots, including the overlap. -/
theorem source : ∃ (callee second third fourth fifth sixth : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (firstTables extraTables : Nat → Fin 16 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    C99ArrayReference.Bind (SeventhStepEntry217.caller callee second third fourth fifth sixth)
      (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)) ∧
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth))
      ⟨SeventhStepMove217.after (SeventhStepEntry217.caller callee second third fourth fifth sixth),.normal⟩ ∧
    Data (SeventhStepMove217.after (SeventhStepEntry217.caller callee second third fourth fifth sixth)) fs 336
      (SeventhStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) ∧
    Data (SeventhStepMove217.after (SeventhStepEntry217.caller callee second third fourth fifth sixth)) gs 336
      (SeventhStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,inc,guard,binding,fImage,gImage⟩ := SeventhStepEntry217.source
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
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap
      (SeventhStepEntry217.caller callee second third fourth fifth sixth).heap := KeygenMemoryStability.trans _ _ _ stable5 sixthStable
  have small : (SeventhStepLengths217.before (SeventhStepEntry217.caller callee second third fourth fifth sixth)).arrays "MAX_BL_SMALL3".toList=some small3 := by
    change FirstStepEntry187.entry.arrays "MAX_BL_SMALL3".toList=some small3
    exact StepStaticInputs187.small_binding
  have prime : (SeventhStepLengths217.before (SeventhStepEntry217.caller callee second third fourth fifth sixth)).arrays "PRIMES3".toList=some KeygenFullData127.primes := by
    change FirstStepEntry187.entry.arrays "PRIMES3".toList=some KeygenFullData127.primes
    exact StepStaticInputs187.prime_binding
  have reads:=SeventhStepLengths217.reads _ stable
  have fData : Data (SeventhStepEntry217.caller callee second third fourth fifth sixth) fd 336
      (SeventhStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) := by
    rw [fd_bridge]; exact SeventhStepMove217.data_keep fImage rfl
  have gData : Data (SeventhStepEntry217.caller callee second third fourth fifth sixth) SixthStepLayout217.gd 336
      (SeventhStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) :=
    SeventhStepMove217.data_keep gImage rfl
  exact ⟨callee,second,third,fourth,fifth,sixth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,binding,prefix_run _ _ _ small prime reads.1 reads.2 stable fData gData,
    SeventhStepMove217.f_image _ _ _ stable fData gData,SeventhStepMove217.g_image _ _ _ stable fData gData⟩

end FT1536.Source3.SeventhStepPrefix217
