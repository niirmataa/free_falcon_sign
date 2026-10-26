import Source3.SecondStepStart196

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepLengths197
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (Load64)
open C99CompactState115 (reference)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open KeygenFullData127 (primes)
open FirstStepEntry187 (var num)

noncomputable def caller (callee : State) : State := FirstStepReturn196.advance (FirstStepReturn196.returned callee)
noncomputable def before (callee : State) : State := SecondStepStart196.ready (caller callee)
noncomputable def withS (callee : State) : State := bindValue (before callee) "slen".toList .uint64 (.uint64 2)
noncomputable def withT (callee : State) : State := bindValue (withS callee) "tlen".toList .uint64 (.uint64 3)
noncomputable def after (callee : State) : State := bindPointer (withT callee) "primes".toList primes

theorem before_heap (callee : State) : (before callee).heap=callee.heap := by
  rw [before,SecondStepStart196.heap,caller,FirstStepReturn196.advance,ModularAtoms178.set,
    SelectedStepAddPrime195.bind_heap]
  exact SelectedStepCrtRun194.proj_heap _ _

theorem first_readonly : FirstStepEntry187.entry.heap.writable small3.block=false := by
  rw [(StepStaticInputs187.block small3.block (by decide)).2.1]
  change SelectedPublicSuccess174.after.heap.writable small3.block=false
  rw [SelectedRootStatics175.stable.writable]
  exact SelectedRootStatics175.readonly

theorem old_third : Load64 (reference SelectedRootContext175.old).heap (element small3 3) 3 :=
  C99FiniteRead114.read64_sound SelectedRootContext175.old.heap _ _ (by decide +kernel)

theorem first_third : Load64 FirstStepEntry187.entry.heap (element small3 3) 3 := by
  have deep : Load64 SelectedDeepestEntry175.entry.heap (element small3 3) 3 :=
    KeygenCallerShape123.load64_block _ _ _ _
      ⟨congrFun SelectedRootStatics175.stable.size _,congrFun SelectedRootStatics175.stable.writable _,
        fun offset => SelectedRootStatics175.stable.readonly _ offset SelectedRootStatics175.readonly⟩ old_third
  exact KeygenCallerShape123.load64_block _ _ _ _ (StepStaticInputs187.block small3.block (by decide)) deep

theorem lengths_at (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    Load64 (before callee).heap (element small3 2) 2 ∧
      Load64 (before callee).heap (element small3 3) 3 := by
  have stable := KeygenHelperStability.make _ _ _ run
  have block : KeygenMakeObjects.Block FirstStepEntry187.entry.heap callee.heap small3.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset first_readonly⟩
  rw [before_heap]
  exact ⟨KeygenCallerShape123.load64_block _ _ _ _ block StepStaticInputs187.second,
    KeygenCallerShape123.load64_block _ _ _ _ block first_third⟩

theorem small_binding (callee : State) : (before callee).arrays "MAX_BL_SMALL3".toList=some small3 := by
  change FirstStepEntry187.entry.arrays "MAX_BL_SMALL3".toList=some small3
  exact StepStaticInputs187.small_binding

theorem prime_binding (callee : State) : (before callee).arrays "PRIMES3".toList=some primes := by
  change FirstStepEntry187.entry.arrays "PRIMES3".toList=some primes
  exact StepStaticInputs187.prime_binding

theorem depth_cell (callee : State) : Slot (before callee) "depth" 2 := rfl

theorem s_source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    Exec (StepPrefixProgram187.lengthSet "slen" "MAX_BL_SMALL3" (var "depth"))
      (before callee) ⟨withS callee,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.assign _ _ _ .uint64 none (.uint64 2) rfl
    (.load _ _ (element small3 2) 2
      (.add _ _ small3 _ (.uint32 2) (small_binding callee) (.variable _ _ _ (depth_cell callee))
        (by decide) (.within small3 2 (by decide))) (lengths_at callee run).1))

theorem withS_heap (callee : State) : (withS callee).heap=(before callee).heap :=
  SelectedStepAddPrime195.bind_heap _ _ _ _

theorem t_read (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    Load64 (withS callee).heap (element small3 3) 3 := by
  rw [withS_heap]
  exact (lengths_at callee run).2

theorem small_after_s (callee : State) : (withS callee).arrays "MAX_BL_SMALL3".toList=some small3 :=
  (SelectedStepAddPrime195.bind_arrays _ _ _ _ _).trans (small_binding callee)

theorem depth_after_s (callee : State) : Slot (withS callee) "depth" 2 :=
  (SelectedStepAddPrime195.locals_keep _ "slen".toList .uint64 (.uint64 2) "depth".toList
    (by decide)).trans (depth_cell callee)

theorem t_source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    Exec (StepPrefixProgram187.lengthSet "tlen" "MAX_BL_SMALL3" (.bin .add (var "depth") (num 1)))
      (withS callee) ⟨withT callee,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.assign _ _ _ .uint64 none (.uint64 3) rfl
    (.load _ _ (element small3 3) 3
      (.add _ _ small3 _ (.uint32 3) (small_after_s callee)
        (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ (depth_after_s callee)) (.literal .int32 1)
          (.step .plus (.uint32 2) (.int32 1) .uint32 rfl (.uint32 2) (.uint32 1) rfl rfl
            (by intro impossible; cases impossible)))
        (by decide) (.within small3 3 (by decide))) (t_read callee run)))

theorem p_source (callee : State) :
    Exec (StepPrefixProgram187.primesSet "PRIMES3") (withT callee) ⟨after callee,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.bindPtr _ _ _ _ primes
    (RootBinding175.zero _ "PRIMES3" primes (prime_binding callee) (by decide)))

theorem source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    Exec StepPrefixProgram187.choice (before callee) ⟨after callee,.normal⟩ :=
  .branchTrue _ _ _ _ ⟨after callee,.normal⟩ (.uint32 1) (.variable _ _ _ rfl) (by decide)
    (MakeFgScope187.source _ _ _
      (.seqNormal _ _ (before callee) (withS callee) _ (s_source callee run)
        (.seqNormal _ _ (withS callee) (withT callee) _ (t_source callee run)
          (.seqNormal _ _ (withT callee) (after callee) _ (p_source callee)
            (SelectedStepAddPrime195.skip_run _)))))

theorem slen_cell (callee : State) : C99LoopScalar141.Cell (after callee) "slen".toList 2 := rfl
theorem tlen_cell (callee : State) : C99LoopScalar141.Cell (after callee) "tlen".toList 3 := rfl
theorem heap (callee : State) : (after callee).heap=callee.heap := by
  have pointer_heap (s : State) : (bindPointer s "primes".toList primes).heap=s.heap := rfl
  rw [after,pointer_heap,withT,SelectedStepAddPrime195.bind_heap,withS_heap,before_heap]

end FT1536.Source3.SecondStepLengths197
