import Source3.NinthStepMove217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NinthStepPrefix217
open C99ArrayReference (State)
open C99MemoryReference (Load64)
open KeygenMakeFgSource (Exec)
open ZintNormWalkFlat208 (Data)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open NinthStepLayout217 (fd gd fs gs gm igm t1)

theorem fd_bridge : NinthStepLayout217.fd=EighthStepLayout217.fd := rfl
theorem gd_distinct : NinthStepLayout217.gd≠EighthStepLayout217.gd := by decide

/-- The actual d=9 part 1 after its declarations, with the overlapping copy. -/
theorem part1 (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (NinthStepLengths217.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (NinthStepLengths217.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read9 : Load64 (NinthStepLengths217.before s).heap (element small3 9) 166)
    (read10 : Load64 (NinthStepLengths217.before s).heap (element small3 10) 335)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 332 Wf) (gImage : Data s EighthStepLayout217.gd 332 Wg) :
    Exec (KeygenMakeFgSource.part .step 1) (NinthStepStart217.declared s)
      ⟨NinthStepMove217.after s,.normal⟩ := by
  apply NinthStepStart217.part1_continue s
  exact .seqNormal _ _ (NinthStepLengths217.before s) (NinthStepLengths217.after s) _
    (NinthStepLengths217.source s small prime read9 read10)
    (MakeFgSequence187.source StepPrefixProgram187.pointers (NinthStepLayout217.before s)
      (NinthStepLayout217.after s) (NinthStepLayout217.pointers s) _ _
      (.seqNormal _ _ (NinthStepMove217.before s) (NinthStepMove217.after s) _
        (NinthStepMove217.move_source s Wf Wg stable fImage gImage)
        (SelectedStepAddPrime195.skip_run _)))

theorem prefix_run (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (NinthStepLengths217.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (NinthStepLengths217.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read9 : Load64 (NinthStepLengths217.before s).heap (element small3 9) 166)
    (read10 : Load64 (NinthStepLengths217.before s).heap (element small3 10) 335)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 332 Wf) (gImage : Data s EighthStepLayout217.gd 332 Wg) :
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (NinthStepEntry217.entry s) ⟨NinthStepMove217.after s,.normal⟩ :=
  .seqNormal _ _ _ (NinthStepStart217.declared s) _
    (StepDeclarations187.source _) (part1 s Wf Wg small prime read9 read10 stable fImage gImage)

/- Actual ninth entry and original part0/part1 with both prior fd/gd images
   moved into the new fs/gs roots, including the overlap. -/
theorem source : ∃ (callee second third fourth fifth sixth seventh eighth : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32) (firstTables extraTables : Nat → Fin 4 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)) ⟨seventh,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (EighthStepEntry217.entry (EighthStepEntry217.caller callee second third fourth fifth sixth seventh)) ⟨eighth,.normal⟩ ∧
    C99ArrayReference.Bind (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth)
      (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (NinthStepEntry217.entry (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth)) ∧
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (NinthStepEntry217.entry (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth))
      ⟨NinthStepMove217.after (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth),.normal⟩ ∧
    Data (NinthStepMove217.after (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth)) fs 332
      (NinthStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables extraTables) ∧
    Data (NinthStepMove217.after (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth)) gs 332
      (NinthStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables extraTables) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,run8,inc,guard,binding,fImage,gImage⟩ := NinthStepEntry217.source
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
  have stable6:=KeygenMemoryStability.trans _ _ _ stable5 sixthStable
  have seventhStable:=KeygenHelperStability.make _ _ _ run7
  change KeygenMemoryStability.Stable (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)).heap seventh.heap at seventhStable
  rw [SeventhStepEntry217.entry_heap] at seventhStable
  have sixthHeap : (SeventhStepEntry217.caller callee second third fourth fifth sixth).heap=sixth.heap := rfl
  rw [sixthHeap] at seventhStable
  have stable7:=KeygenMemoryStability.trans _ _ _ stable6 seventhStable
  have eighthStable:=KeygenHelperStability.make _ _ _ run8
  change KeygenMemoryStability.Stable (EighthStepEntry217.entry (EighthStepEntry217.caller callee second third fourth fifth sixth seventh)).heap eighth.heap at eighthStable
  rw [EighthStepEntry217.entry_heap] at eighthStable
  have seventhHeap : (EighthStepEntry217.caller callee second third fourth fifth sixth seventh).heap=seventh.heap := rfl
  rw [seventhHeap] at eighthStable
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap
      (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth).heap := KeygenMemoryStability.trans _ _ _ stable7 eighthStable
  have small : (NinthStepLengths217.before (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth)).arrays "MAX_BL_SMALL3".toList=some small3 := by
    change FirstStepEntry187.entry.arrays "MAX_BL_SMALL3".toList=some small3
    exact StepStaticInputs187.small_binding
  have prime : (NinthStepLengths217.before (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth)).arrays "PRIMES3".toList=some KeygenFullData127.primes := by
    change FirstStepEntry187.entry.arrays "PRIMES3".toList=some KeygenFullData127.primes
    exact StepStaticInputs187.prime_binding
  have reads:=NinthStepLengths217.reads _ stable
  have fData : Data (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth) fd 332
      (NinthStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables extraTables) := by
    rw [fd_bridge]; exact NinthStepMove217.data_keep fImage rfl
  have gData : Data (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth) EighthStepLayout217.gd 332
      (NinthStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables extraTables) :=
    NinthStepMove217.data_keep gImage rfl
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,run8,binding,prefix_run _ _ _ small prime reads.1 reads.2 stable fData gData,
    NinthStepMove217.f_image _ _ _ stable fData gData,NinthStepMove217.g_image _ _ _ stable fData gData⟩

end FT1536.Source3.NinthStepPrefix217
