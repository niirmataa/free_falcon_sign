import Source3.FifthStepMove217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FifthStepPrefix217
open C99ArrayReference (State)
open C99MemoryReference (Load64)
open KeygenMakeFgSource (Exec)
open ZintNormWalkFlat208 (Data)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open FifthStepLayout217 (fd gd fs gs gm igm t1)

theorem fd_bridge : FifthStepLayout217.fd=FourthStepLayout216.fd := rfl
theorem gd_distinct : FifthStepLayout217.gd≠FourthStepLayout216.gd := by decide

/-- The actual d=5 part 1 after its declarations, with the overlapping copy. -/
theorem part1 (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (FifthStepLengths217.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (FifthStepLengths217.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read5 : Load64 (FifthStepLengths217.before s).heap (element small3 5) 12)
    (read6 : Load64 (FifthStepLengths217.before s).heap (element small3 6) 22)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 384 Wf) (gImage : Data s FourthStepLayout216.gd 384 Wg) :
    Exec (KeygenMakeFgSource.part .step 1) (FifthStepStart217.declared s)
      ⟨FifthStepMove217.after s,.normal⟩ := by
  apply FifthStepStart217.part1_continue s
  exact .seqNormal _ _ (FifthStepLengths217.before s) (FifthStepLengths217.after s) _
    (FifthStepLengths217.source s small prime read5 read6)
    (MakeFgSequence187.source StepPrefixProgram187.pointers (FifthStepLayout217.before s)
      (FifthStepLayout217.after s) (FifthStepLayout217.pointers s) _ _
      (.seqNormal _ _ (FifthStepMove217.before s) (FifthStepMove217.after s) _
        (FifthStepMove217.move_source s Wf Wg stable fImage gImage)
        (SelectedStepAddPrime195.skip_run _)))

theorem prefix_run (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (FifthStepLengths217.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (FifthStepLengths217.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read5 : Load64 (FifthStepLengths217.before s).heap (element small3 5) 12)
    (read6 : Load64 (FifthStepLengths217.before s).heap (element small3 6) 22)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 384 Wf) (gImage : Data s FourthStepLayout216.gd 384 Wg) :
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (FifthStepEntry217.entry s) ⟨FifthStepMove217.after s,.normal⟩ :=
  .seqNormal _ _ _ (FifthStepStart217.declared s) _
    (StepDeclarations187.source _) (part1 s Wf Wg small prime read5 read6 stable fImage gImage)

/- Actual fifth entry and original part0/part1 with the prior fd/gd images
   moved into the new fs/gs roots, including the overlap. -/
theorem source : ∃ (callee second third fourth : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (firstTables extraTables : Nat → Fin 64 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    C99ArrayReference.Bind (FifthStepEntry217.caller callee second third fourth)
      (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ∧
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth))
      ⟨FifthStepMove217.after (FifthStepEntry217.caller callee second third fourth),.normal⟩ ∧
    Data (FifthStepMove217.after (FifthStepEntry217.caller callee second third fourth)) fs 384
      (FifthStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables extraTables) ∧
    Data (FifthStepMove217.after (FifthStepEntry217.caller callee second third fourth)) gs 384
      (FifthStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables extraTables) := by
  obtain ⟨callee,second,third,fourth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,
    run1,run2,run3,run4,inc,guard,binding,fImage,gImage⟩ := FifthStepEntry217.source
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
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap
      (FifthStepEntry217.caller callee second third fourth).heap := KeygenMemoryStability.trans _ _ _ stable3 fourthStable
  have small : (FifthStepLengths217.before (FifthStepEntry217.caller callee second third fourth)).arrays "MAX_BL_SMALL3".toList=some small3 := by
    change FirstStepEntry187.entry.arrays "MAX_BL_SMALL3".toList=some small3
    exact StepStaticInputs187.small_binding
  have prime : (FifthStepLengths217.before (FifthStepEntry217.caller callee second third fourth)).arrays "PRIMES3".toList=some KeygenFullData127.primes := by
    change FirstStepEntry187.entry.arrays "PRIMES3".toList=some KeygenFullData127.primes
    exact StepStaticInputs187.prime_binding
  have reads:=FifthStepLengths217.reads _ stable
  have fData : Data (FifthStepEntry217.caller callee second third fourth) fd 384
      (FifthStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables extraTables) := by
    rw [fd_bridge]; exact FifthStepMove217.data_keep fImage rfl
  have gData : Data (FifthStepEntry217.caller callee second third fourth) FourthStepLayout216.gd 384
      (FifthStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables extraTables) :=
    FifthStepMove217.data_keep gImage rfl
  exact ⟨callee,second,third,fourth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,run1,run2,run3,run4,binding,
    prefix_run _ _ _ small prime reads.1 reads.2 stable fData gData,
    FifthStepMove217.f_image _ _ _ stable fData gData,
    FifthStepMove217.g_image _ _ _ stable fData gData⟩

end FT1536.Source3.FifthStepPrefix217
