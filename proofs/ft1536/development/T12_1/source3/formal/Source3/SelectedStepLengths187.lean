import Source3.SelectedStepSizes187
import Source3.MakeFgScope187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStepLengths187
open C99ArrayReference (State bindValue bindPointer)
open KeygenMakeFgSource (Exec)
open SelectedRootStatics175 (small3)
open KeygenFullData127 (primes)
open KeygenSmallOutput (element)
open FirstStepEntry187 (var num)

noncomputable abbrev before := SelectedStepSizes187.after
noncomputable def withS := bindValue before "slen".toList .uint64 (.uint64 1)
noncomputable def withT := bindValue withS "tlen".toList .uint64 (.uint64 2)
noncomputable def after := bindPointer withT "primes".toList primes

theorem small_binding : before.arrays "MAX_BL_SMALL3".toList=some small3 := StepStaticInputs187.small_binding
theorem primes_binding : before.arrays "PRIMES3".toList=some primes := StepStaticInputs187.prime_binding

theorem s_source : Exec (StepPrefixProgram187.lengthSet "slen" "MAX_BL_SMALL3" (var "depth")) before ⟨withS,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.assign _ _ _ .uint64 none (.uint64 1) rfl
    (.load _ _ (element small3 1) 1
      (.add _ _ small3 _ (.uint32 1) small_binding (.variable _ _ _ rfl) (by decide) (.within small3 1 (by decide)))
      StepStaticInputs187.first))

theorem t_source : Exec (StepPrefixProgram187.lengthSet "tlen" "MAX_BL_SMALL3" (.bin .add (var "depth") (num 1))) withS ⟨withT,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.assign _ _ _ .uint64 none (.uint64 2) rfl
    (.load _ _ (element small3 2) 2
      (.add _ _ small3 _ (.uint32 2) small_binding
        (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
          (.step .plus (.uint32 1) (.int32 1) .uint32 rfl (.uint32 1) (.uint32 1) rfl rfl
            (by intro impossible; cases impossible)))
        (by decide) (.within small3 2 (by decide))) StepStaticInputs187.second))

theorem p_source : Exec (StepPrefixProgram187.primesSet "PRIMES3") withT ⟨after,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _ (.bindPtr _ _ _ _ primes
    (RootBinding175.zero withT "PRIMES3" primes primes_binding (by change 0≤_; exact Nat.zero_le _)))

theorem source : Exec StepPrefixProgram187.choice before ⟨after,.normal⟩ :=
  .branchTrue _ _ _ before ⟨after,.normal⟩ (.uint32 1) (.variable _ _ _ rfl) (by decide)
    (MakeFgScope187.source _ before after
      (.seqNormal _ _ before withS _ s_source (.seqNormal _ _ withS withT _ t_source
        (.seqNormal _ _ withT after _ p_source (MakeFgDeclarations176.array_source .skip after after (.skip after))))))

theorem slen_cell : KeygenNttLoopSupport.USlot after "slen" 1 := rfl
theorem tlen_cell : KeygenNttLoopSupport.USlot after "tlen" 2 := rfl
theorem heap : after.heap=FirstStepEntry187.entry.heap := by
  dsimp only [after,withT,withS,bindPointer,bindValue]
  exact SelectedStepSizes187.heap

end FT1536.Source3.SelectedStepLengths187
