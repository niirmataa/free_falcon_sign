import Source3.SixthStepMove217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SixthStepPrefix217
open C99ArrayReference (State)
open C99MemoryReference (Load64)
open KeygenMakeFgSource (Exec)
open ZintNormWalkFlat208 (Data)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open SixthStepLayout217 (fd gd fs gs gm igm t1)

theorem fd_bridge : SixthStepLayout217.fd=FifthStepLayout217.fd := rfl
theorem gd_distinct : SixthStepLayout217.gd≠FifthStepLayout217.gd := by decide

/-- The actual d=6 part 1 after its declarations, with the overlapping copy. -/
theorem part1 (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (SixthStepLengths217.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (SixthStepLengths217.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read6 : Load64 (SixthStepLengths217.before s).heap (element small3 6) 22)
    (read7 : Load64 (SixthStepLengths217.before s).heap (element small3 7) 42)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg) :
    Exec (KeygenMakeFgSource.part .step 1) (SixthStepStart217.declared s)
      ⟨SixthStepMove217.after s,.normal⟩ := by
  apply SixthStepStart217.part1_continue s
  exact .seqNormal _ _ (SixthStepLengths217.before s) (SixthStepLengths217.after s) _
    (SixthStepLengths217.source s small prime read6 read7)
    (MakeFgSequence187.source StepPrefixProgram187.pointers (SixthStepLayout217.before s)
      (SixthStepLayout217.after s) (SixthStepLayout217.pointers s) _ _
      (.seqNormal _ _ (SixthStepMove217.before s) (SixthStepMove217.after s) _
        (SixthStepMove217.move_source s Wf Wg stable fImage gImage)
        (SelectedStepAddPrime195.skip_run _)))

theorem prefix_run (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (SixthStepLengths217.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (SixthStepLengths217.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read6 : Load64 (SixthStepLengths217.before s).heap (element small3 6) 22)
    (read7 : Load64 (SixthStepLengths217.before s).heap (element small3 7) 42)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg) :
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (SixthStepEntry217.entry s) ⟨SixthStepMove217.after s,.normal⟩ :=
  .seqNormal _ _ _ (SixthStepStart217.declared s) _
    (StepDeclarations187.source _) (part1 s Wf Wg small prime read6 read7 stable fImage gImage)

/- Actual sixth entry and original part0/part1 with both prior fd/gd images
   moved into the new fs/gs roots, including the overlap. -/
theorem source : ∃ (callee second third fourth fifth : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (firstTables extraTables : Nat → Fin 32 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    C99ArrayReference.Bind (SixthStepEntry217.caller callee second third fourth fifth)
      (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ∧
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth))
      ⟨SixthStepMove217.after (SixthStepEntry217.caller callee second third fourth fifth),.normal⟩ ∧
    Data (SixthStepMove217.after (SixthStepEntry217.caller callee second third fourth fifth)) fs 352
      (SixthStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) ∧
    Data (SixthStepMove217.after (SixthStepEntry217.caller callee second third fourth fifth)) gs 352
      (SixthStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) := by
  obtain ⟨callee,second,third,fourth,fifth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,
    run1,run2,run3,run4,run5,inc,guard,binding,fImage,gImage⟩ := SixthStepEntry217.source
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
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap
      (SixthStepEntry217.caller callee second third fourth fifth).heap := KeygenMemoryStability.trans _ _ _ stable4 fifthStable
  have small : (SixthStepLengths217.before (SixthStepEntry217.caller callee second third fourth fifth)).arrays "MAX_BL_SMALL3".toList=some small3 := by
    change FirstStepEntry187.entry.arrays "MAX_BL_SMALL3".toList=some small3
    exact StepStaticInputs187.small_binding
  have prime : (SixthStepLengths217.before (SixthStepEntry217.caller callee second third fourth fifth)).arrays "PRIMES3".toList=some KeygenFullData127.primes := by
    change FirstStepEntry187.entry.arrays "PRIMES3".toList=some KeygenFullData127.primes
    exact StepStaticInputs187.prime_binding
  have reads:=SixthStepLengths217.reads _ stable
  have fData : Data (SixthStepEntry217.caller callee second third fourth fifth) fd 352
      (SixthStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) := by
    rw [fd_bridge]; exact SixthStepMove217.data_keep fImage rfl
  have gData : Data (SixthStepEntry217.caller callee second third fourth fifth) FifthStepLayout217.gd 352
      (SixthStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) :=
    SixthStepMove217.data_keep gImage rfl
  exact ⟨callee,second,third,fourth,fifth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,
    run1,run2,run3,run4,run5,binding,prefix_run _ _ _ small prime reads.1 reads.2 stable fData gData,
    SixthStepMove217.f_image _ _ _ stable fData gData,SixthStepMove217.g_image _ _ _ stable fData gData⟩

end FT1536.Source3.SixthStepPrefix217
