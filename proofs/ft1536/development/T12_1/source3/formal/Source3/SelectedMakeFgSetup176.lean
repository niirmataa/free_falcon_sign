import Source3.MakeFgConversionShape176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMakeFgSetup176
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (ArrayPointer)
open KeygenMakeFgSource (Exec)
open MakeFgConversionShape176
open MakeFgDeclarations176 (array_source)
open KeygenFullData127 (primes)

def ft := SelectedDeepestWorkspace175.pointer 2
def gt := KeygenSmallOutput.element ft 1536
noncomputable def before := MakeFgDeclarations176.after SelectedMakeFgEntry175.entry
noncomputable def sized := bindValue before "n".toList .uint64 (.uint64 1536)
noncomputable def withFt := bindPointer sized "ft".toList ft
noncomputable def withGt := bindPointer withFt "gt".toList gt
noncomputable def withPrimes := bindPointer withGt "primes".toList primes
noncomputable def after := bindValue withPrimes "p0".toList .uint32 (.uint32 KeygenNinv31.prime)

theorem size_source : Exec nSet before ⟨sized,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 none (.uint64 1536) (by rfl)
    (.scalar _ _ (RootSizeSource175.source before rfl rfl))))
theorem ft_source : Exec ftSet sized ⟨withFt,.normal⟩ :=
  array_source _ _ _ (.bindPtr _ _ _ _ ft (RootBinding175.zero sized "data" ft rfl (by decide)))
theorem gt_source : Exec gtSet withFt ⟨withGt,.normal⟩ :=
  array_source _ _ _ (.bindPtr _ _ _ _ gt
    (.add _ _ ft gt (.uint64 1536) rfl (.variable _ _ _ (by rfl)) (by decide) (.within ft 1536 (by decide))))
theorem primes_binding : withGt.arrays "PRIMES3".toList=some primes := SelectedRootEntry175.source.table
theorem prime_select : Exec primeSelect withGt ⟨withPrimes,.normal⟩ :=
  .branchTrue _ _ _ _ _ (.uint32 1) (.variable _ _ _ (by rfl)) (by decide)
    (array_source _ _ _ (.bindPtr _ _ _ _ primes
      (RootBinding175.zero withGt "PRIMES3" primes primes_binding (by change 0≤_; exact Nat.zero_le _))))

theorem prime_bytes : C99MemoryReference.Load32 withPrimes.heap
    (KeygenLevelCalls.fieldPointer primes .p) KeygenNinv31.prime := by
  have bytes := SelectedRootEntry175.source.primeObject.2.2.2.2.2.2 0
    (KeygenStaticReads.first .ternary) (KeygenStaticReads.first_value .ternary) .p
  exact bytes

theorem prime_read : KeygenLevelCalls.PrimeRead withPrimes "primes".toList (.literal .i32 0) .p (.uint32 KeygenNinv31.prime) :=
  .read primes KeygenNinv31.prime
    (.add _ _ primes primes (.int32 0) rfl (.literal .int32 0) (by decide)
      (.within primes 0 (by change 0≤_; exact Nat.zero_le _)))
    rfl (by decide) prime_bytes

theorem p_source : Exec pSet withPrimes ⟨after,.normal⟩ :=
  .level _ _ _ (.prime _ _ _ _ _ .uint32 none (.uint32 KeygenNinv31.prime) (by rfl) prime_read)

theorem source : Exec setup before ⟨after,.normal⟩ :=
  .seqNormal _ _ before sized ⟨after,.normal⟩ size_source
    (.seqNormal _ _ sized withFt ⟨after,.normal⟩ ft_source
      (.seqNormal _ _ withFt withGt ⟨after,.normal⟩ gt_source
        (.seqNormal _ _ withGt withPrimes ⟨after,.normal⟩ prime_select
          (.seqNormal _ _ withPrimes after ⟨after,.normal⟩ p_source
            (array_source .skip after after (.skip after))))))

theorem continue_part (last : State) (run : Exec conversion after ⟨last,.normal⟩) :
    Exec (KeygenMakeFgSource.part .make 1) before ⟨last,.normal⟩ := by
  rw [shape]
  exact .seqNormal _ _ before sized ⟨last,.normal⟩ size_source
    (.seqNormal _ _ sized withFt ⟨last,.normal⟩ ft_source
      (.seqNormal _ _ withFt withGt ⟨last,.normal⟩ gt_source
        (.seqNormal _ _ withGt withPrimes ⟨last,.normal⟩ prime_select
          (.seqNormal _ _ withPrimes after ⟨last,.normal⟩ p_source
            (.seqNormal _ _ after last ⟨last,.normal⟩ run (array_source .skip last last (.skip last)))))))

end FT1536.Source3.SelectedMakeFgSetup176
