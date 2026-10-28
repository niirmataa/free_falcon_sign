import Source3.NinthStepStart217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NinthStepLengths217
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (Load64)
open C99CompactState115 (reference)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open KeygenFullData127 (primes)
open FirstStepEntry187 (var num)

noncomputable abbrev before (s : State) := NinthStepStart217.ready s
noncomputable def withS (s : State) : State := bindValue (before s) "slen".toList .uint64 (.uint64 166)
noncomputable def withT (s : State) : State := bindValue (withS s) "tlen".toList .uint64 (.uint64 335)
noncomputable def after (s : State) : State := bindPointer (withT s) "primes".toList primes

theorem old_tenth : Load64 (reference SelectedRootContext175.old).heap (element small3 10) 335 :=
  C99FiniteRead114.read64_sound SelectedRootContext175.old.heap _ _ (by decide +kernel)

theorem first_tenth : Load64 FirstStepEntry187.entry.heap (element small3 10) 335 := by
  have deep : Load64 SelectedDeepestEntry175.entry.heap (element small3 10) 335 :=
    KeygenCallerShape123.load64_block _ _ _ _
      ⟨congrFun SelectedRootStatics175.stable.size _,congrFun SelectedRootStatics175.stable.writable _,
        fun offset => SelectedRootStatics175.stable.readonly _ offset SelectedRootStatics175.readonly⟩ old_tenth
  exact KeygenCallerShape123.load64_block _ _ _ _ (StepStaticInputs187.block small3.block (by decide)) deep

theorem reads (s : State) (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap) :
    Load64 (before s).heap (element small3 9) 166 ∧ Load64 (before s).heap (element small3 10) 335 := by
  have block : KeygenMakeObjects.Block FirstStepEntry187.entry.heap s.heap small3.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,
      fun offset => stable.readonly _ offset SecondStepLengths197.first_readonly⟩
  rw [NinthStepStart217.heap]
  exact ⟨KeygenCallerShape123.load64_block _ _ _ _ block EighthStepLengths217.first_ninth,
    KeygenCallerShape123.load64_block _ _ _ _ block first_tenth⟩

theorem depth_cell (s : State) : Slot (before s) "depth" 9 := rfl

theorem small_binding (s : State) (small : (before s).arrays "MAX_BL_SMALL3".toList=some small3) :
    (before s).arrays "MAX_BL_SMALL3".toList=some small3 := small

theorem prime_binding (s : State) (prime : (before s).arrays "PRIMES3".toList=some primes) :
    (before s).arrays "PRIMES3".toList=some primes := prime

theorem s_source (s : State) (small : (before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (read9 : Load64 (before s).heap (element small3 9) 166) :
    Exec (StepPrefixProgram187.lengthSet "slen" "MAX_BL_SMALL3" (var "depth"))
      (before s) ⟨withS s,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.assign _ _ _ .uint64 none (.uint64 166) rfl
    (.load _ _ (element small3 9) 166
      (.add _ _ small3 _ (.uint32 9) (small_binding s small) (.variable _ _ _ (depth_cell s))
        (by decide) (.within small3 9 (by decide))) read9))

theorem withS_heap (s : State) : (withS s).heap=(before s).heap :=
  SelectedStepAddPrime195.bind_heap _ _ _ _

theorem t_read (s : State) (read10 : Load64 (before s).heap (element small3 10) 335) :
    Load64 (withS s).heap (element small3 10) 335 := by
  rw [withS_heap]
  exact read10

theorem small_after_s (s : State) (small : (before s).arrays "MAX_BL_SMALL3".toList=some small3) :
    (withS s).arrays "MAX_BL_SMALL3".toList=some small3 :=
  (SelectedStepAddPrime195.bind_arrays _ _ _ _ _).trans (small_binding s small)

theorem depth_after_s (s : State) : Slot (withS s) "depth" 9 :=
  (SelectedStepAddPrime195.locals_keep _ "slen".toList .uint64 (.uint64 166) "depth".toList
    (by decide)).trans (depth_cell s)

theorem t_source (s : State) (small : (before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (read10 : Load64 (before s).heap (element small3 10) 335) :
    Exec (StepPrefixProgram187.lengthSet "tlen" "MAX_BL_SMALL3" (.bin .add (var "depth") (num 1)))
      (withS s) ⟨withT s,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.assign _ _ _ .uint64 none (.uint64 335) rfl
    (.load _ _ (element small3 10) 335
      (.add _ _ small3 _ (.uint32 10) (small_after_s s small)
        (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ (depth_after_s s)) (.literal .int32 1)
          (.step .plus (.uint32 9) (.int32 1) .uint32 rfl (.uint32 9) (.uint32 1) rfl rfl
            (by intro impossible; cases impossible)))
        (by decide) (.within small3 10 (by decide))) (t_read s read10)))

theorem p_source (s : State) (prime : (before s).arrays "PRIMES3".toList=some primes) :
    Exec (StepPrefixProgram187.primesSet "PRIMES3") (withT s) ⟨after s,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.bindPtr _ _ _ _ primes
    (RootBinding175.zero _ "PRIMES3" primes (prime_binding s prime) (by decide)))

theorem source (s : State)
    (small : (before s).arrays "MAX_BL_SMALL3".toList=some small3)
    (prime : (before s).arrays "PRIMES3".toList=some primes)
    (read9 : Load64 (before s).heap (element small3 9) 166)
    (read10 : Load64 (before s).heap (element small3 10) 335) :
    Exec StepPrefixProgram187.choice (before s) ⟨after s,.normal⟩ :=
  .branchTrue _ _ _ _ ⟨after s,.normal⟩ (.uint32 1) (.variable _ _ _ rfl) (by decide)
    (MakeFgScope187.source _ _ _
      (.seqNormal _ _ (before s) (withS s) _ (s_source s small read9)
        (.seqNormal _ _ (withS s) (withT s) _ (t_source s small read10)
          (.seqNormal _ _ (withT s) (after s) _ (p_source s prime)
            (SelectedStepAddPrime195.skip_run _)))))

theorem slen_cell (s : State) : C99LoopScalar141.Cell (after s) "slen".toList 166 := rfl
theorem tlen_cell (s : State) : C99LoopScalar141.Cell (after s) "tlen".toList 335 := rfl

theorem heap (s : State) : (after s).heap=s.heap := by
  have pointer_heap (x : State) : (bindPointer x "primes".toList primes).heap=x.heap := rfl
  rw [after,pointer_heap,withT,SelectedStepAddPrime195.bind_heap,withS_heap,NinthStepStart217.heap]

end FT1536.Source3.NinthStepLengths217
