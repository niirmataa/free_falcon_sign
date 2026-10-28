import Source3.FourthStepMove216

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FourthStepPrefix216
open C99ArrayReference (State)
open C99MemoryReference (Load64)
open KeygenMakeFgSource (Exec)
open ZintNormWalkFlat208 (Data)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open FourthStepLayout216 (fd gd fs gs gm igm t1)

theorem fd_bridge : FourthStepLayout216.fd=ThirdStepLayout215.fd := rfl
theorem gd_bridge : FourthStepLayout216.gd=ThirdStepLayout215.gd := rfl

/-- The actual d=3 part 1 after its declarations, with the overlapping copy. -/
theorem part1 (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (FourthStepLengths216.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (FourthStepLengths216.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read4 : Load64 (FourthStepLengths216.before s).heap (element small3 4) 6)
    (read5 : Load64 (FourthStepLengths216.before s).heap (element small3 5) 12)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 384 Wf) (gImage : Data s gd 384 Wg) :
    Exec (KeygenMakeFgSource.part .step 1) (FourthStepStart216.declared s)
      ⟨FourthStepMove216.after s,.normal⟩ := by
  apply FourthStepStart216.part1_continue s
  exact .seqNormal _ _ (FourthStepLengths216.before s) (FourthStepLengths216.after s) _
    (FourthStepLengths216.source s small prime read4 read5)
    (MakeFgSequence187.source StepPrefixProgram187.pointers (FourthStepLayout216.before s)
      (FourthStepLayout216.after s) (FourthStepLayout216.pointers s) _ _
      (.seqNormal _ _ (FourthStepMove216.before s) (FourthStepMove216.after s) _
        (FourthStepMove216.move_source s Wf Wg stable fImage gImage)
        (SelectedStepAddPrime195.skip_run _)))

theorem prefix_run (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (FourthStepLengths216.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (FourthStepLengths216.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read4 : Load64 (FourthStepLengths216.before s).heap (element small3 4) 6)
    (read5 : Load64 (FourthStepLengths216.before s).heap (element small3 5) 12)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 384 Wf) (gImage : Data s gd 384 Wg) :
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (FourthStepEntry216.entry s) ⟨FourthStepMove216.after s,.normal⟩ :=
  .seqNormal _ _ _ (FourthStepStart216.declared s) _
    (StepDeclarations187.source _) (part1 s Wf Wg small prime read4 read5 stable fImage gImage)

/- Actual fourth entry and original part0/part1, with both moved source arrays. -/
theorem source : ∃ (callee second third : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    C99ArrayReference.Bind (FourthStepEntry216.caller callee second third)
      (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ∧
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third))
      ⟨FourthStepMove216.after (FourthStepEntry216.caller callee second third),.normal⟩ ∧
    Data (FourthStepMove216.after (FourthStepEntry216.caller callee second third)) fs 384
      (FourthStepEntry216.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) ∧
    Data (FourthStepMove216.after (FourthStepEntry216.caller callee second third)) gs 384
      (FourthStepEntry216.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) := by
  obtain ⟨callee,second,third,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,run1,run2,run3,inc,guard,binding,fImage,gImage⟩ :=
    FourthStepEntry216.source
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
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap
      (FourthStepEntry216.caller callee second third).heap := KeygenMemoryStability.trans _ _ _ stable2 last
  have small : (FourthStepLengths216.before (FourthStepEntry216.caller callee second third)).arrays "MAX_BL_SMALL3".toList=some small3 := by
    change FirstStepEntry187.entry.arrays "MAX_BL_SMALL3".toList=some small3
    exact StepStaticInputs187.small_binding
  have prime : (FourthStepLengths216.before (FourthStepEntry216.caller callee second third)).arrays "PRIMES3".toList=some KeygenFullData127.primes := by
    change FirstStepEntry187.entry.arrays "PRIMES3".toList=some KeygenFullData127.primes
    exact StepStaticInputs187.prime_binding
  have reads:=FourthStepLengths216.reads _ stable
  have fWords : Data (FourthStepEntry216.caller callee second third) fd 384
      (FourthStepEntry216.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) := by
    rw [fd_bridge]; exact FourthStepMove216.data_keep fImage rfl
  have gWords : Data (FourthStepEntry216.caller callee second third) gd 384
      (FourthStepEntry216.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) := by
    rw [gd_bridge]; exact FourthStepMove216.data_keep gImage rfl
  exact ⟨callee,second,third,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,run1,run2,run3,binding,
    prefix_run _ _ _ small prime reads.1 reads.2 stable fWords gWords,
    FourthStepMove216.f_image _ _ _ stable fWords gWords,
    FourthStepMove216.g_image _ _ _ stable fWords gWords⟩

end FT1536.Source3.FourthStepPrefix216
