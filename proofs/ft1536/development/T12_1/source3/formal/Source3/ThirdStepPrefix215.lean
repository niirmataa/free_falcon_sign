import Source3.ThirdStepMove215

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepPrefix215
open C99ArrayReference (State)
open C99MemoryReference (Load64)
open KeygenMakeFgSource (Exec)
open ZintNormWalkFlat208 (Data)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open ThirdStepLayout215 (fd gd fs gs gm igm t1)

theorem fd_bridge : ThirdStepLayout215.fd=SecondStepLayout197.fd := rfl
theorem gd_bridge : ThirdStepLayout215.gd=SecondStepLayout197.gd := rfl

/-- The actual d=3 part 1 after its declarations, with the overlapping copy. -/
theorem part1 (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (ThirdStepLengths215.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (ThirdStepLengths215.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read3 : Load64 (ThirdStepLengths215.before s).heap (element small3 3) 3)
    (read4 : Load64 (ThirdStepLengths215.before s).heap (element small3 4) 6)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 384 Wf) (gImage : Data s gd 384 Wg) :
    Exec (KeygenMakeFgSource.part .step 1) (ThirdStepStart215.declared s)
      ⟨ThirdStepMove215.after s,.normal⟩ := by
  apply ThirdStepStart215.part1_continue s
  exact .seqNormal _ _ (ThirdStepLengths215.before s) (ThirdStepLengths215.after s) _
    (ThirdStepLengths215.source s small prime read3 read4)
    (MakeFgSequence187.source StepPrefixProgram187.pointers (ThirdStepLayout215.before s)
      (ThirdStepLayout215.after s) (ThirdStepLayout215.pointers s) _ _
      (.seqNormal _ _ (ThirdStepMove215.before s) (ThirdStepMove215.after s) _
        (ThirdStepMove215.move_source s Wf Wg stable fImage gImage)
        (SelectedStepAddPrime195.skip_run _)))

theorem prefix_run (s : State) (Wf Wg : Nat → BitVec 32)
    (small : (ThirdStepLengths215.before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (ThirdStepLengths215.before s).arrays "PRIMES3".toList=some KeygenFullData127.primes)
    (read3 : Load64 (ThirdStepLengths215.before s).heap (element small3 3) 3)
    (read4 : Load64 (ThirdStepLengths215.before s).heap (element small3 4) 6)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 384 Wf) (gImage : Data s gd 384 Wg) :
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (ThirdStepEntry215.entry s) ⟨ThirdStepMove215.after s,.normal⟩ :=
  .seqNormal _ _ _ (ThirdStepStart215.declared s) _
    (StepDeclarations187.source _) (part1 s Wf Wg small prime read3 read4 stable fImage gImage)

/-- Concrete second execution and its actual next call's complete layout/move prefix. -/
theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨out,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepReturn212.advance (SecondStepReturn212.returned callee out))
      (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (ThirdStepEntry215.entry (SecondStepReturn212.advance (SecondStepReturn212.returned callee out))) ∧
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (ThirdStepEntry215.entry (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)))
      ⟨ThirdStepMove215.after (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)),.normal⟩ ∧
    Data (ThirdStepMove215.after (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)))
      fs 384 (SecondStepImage212.fWords oldWords ivs0 ivs1 gvs2) ∧
    Data (ThirdStepMove215.after (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)))
      gs 384 (SecondStepImage212.gWords oldWords ivs0 ivs1 gvs2) := by
  obtain ⟨callee,out,oldWords,ivs0,ivs1,gvs2,run1,run2,incRun,guard,binding,fImage,gImage⟩ :=
    ThirdStepEntry215.source
  have first := KeygenHelperStability.make _ _ _ run1
  have later := KeygenHelperStability.make _ _ _ run2
  change KeygenMemoryStability.Stable (SecondStepStatics204.entry callee).heap out.heap at later
  rw [SecondStepStatics204.entry_heap] at later
  have stableAll := KeygenMemoryStability.trans _ _ _ first later
  have stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap
      (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)).heap := stableAll
  have small : (ThirdStepLengths215.before (SecondStepReturn212.advance
      (SecondStepReturn212.returned callee out))).arrays "MAX_BL_SMALL3".toList=some small3 := by
    change FirstStepEntry187.entry.arrays "MAX_BL_SMALL3".toList=some small3
    exact StepStaticInputs187.small_binding
  have prime : (ThirdStepLengths215.before (SecondStepReturn212.advance
      (SecondStepReturn212.returned callee out))).arrays "PRIMES3".toList=some KeygenFullData127.primes := by
    change FirstStepEntry187.entry.arrays "PRIMES3".toList=some KeygenFullData127.primes
    exact StepStaticInputs187.prime_binding
  have reads := ThirdStepLengths215.reads _ stable
  have fWords : Data (SecondStepReturn212.advance (SecondStepReturn212.returned callee out))
      fd 384 (SecondStepImage212.fWords oldWords ivs0 ivs1 gvs2) := by
    rw [fd_bridge]
    exact ThirdStepMove215.data_keep fImage rfl
  have gWords : Data (SecondStepReturn212.advance (SecondStepReturn212.returned callee out))
      gd 384 (SecondStepImage212.gWords oldWords ivs0 ivs1 gvs2) := by
    rw [gd_bridge]
    exact ThirdStepMove215.data_keep gImage rfl
  exact ⟨callee,out,oldWords,ivs0,ivs1,gvs2,run1,run2,binding,
    prefix_run _ _ _ small prime reads.1 reads.2 stable fWords gWords,
    ThirdStepMove215.f_image _ _ _ stable fWords gWords,
    ThirdStepMove215.g_image _ _ _ stable fWords gWords⟩

end FT1536.Source3.ThirdStepPrefix215
