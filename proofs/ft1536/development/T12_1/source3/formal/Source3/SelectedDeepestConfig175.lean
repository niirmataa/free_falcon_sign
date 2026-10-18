import Source3.SelectedRootStatics175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedDeepestConfig175
open C99ArrayReference (State bindValue bindPointer)
open KeygenFullData127 (env primes)
open KeygenDeepestSource (Exec Stmt)
open SelectedRootStatics175 (small3)

def branchBody (small prime : String) : KeygenMakeFgSource.Stmt := KeygenMakeFgSource.chain [
  .level (.modular (.base (.assign "len".toList (.load small.toList (.var "logn".toList))))),
  .level (.modular (.base (.bindPtr "primes".toList prime.toList C99ProcedureParser.zero)))]
def branch (small prime : String) : Stmt := .base (.scope [] [] (branchBody small prime))
def code : Stmt := KeygenDeepestSource.chain [.logn "logn".toList,
  .ternary (branch "MAX_BL_SMALL3" "PRIMES3") (branch "MAX_BL_SMALL2" "PRIMES2")]

theorem shape : KeygenDeepestSource.part 1=code := by decide

noncomputable def before := DeepestDeclarations175.after SelectedDeepestEntry175.entry
noncomputable def logged := bindValue before "logn".toList .uint32 (.uint32 10)
noncomputable def sized := bindValue logged "len".toList .uint64 (.uint64 335)
noncomputable def after := bindPointer sized "primes".toList primes

theorem logn_read : KeygenSearchContext.ReadLogn env.ctx before 10 :=
  .read 10 rfl SelectedDeepestEntry175.object SelectedDeepestEntry175.profile.1
theorem ternary_read : KeygenSearchContext.ReadTernary env.ctx logged 1 :=
  .read 1 rfl SelectedDeepestEntry175.object SelectedDeepestEntry175.profile.2

theorem length_pointer : C99ArrayReference.Pointer logged "MAX_BL_SMALL3".toList (.var "logn".toList)
    (KeygenSmallOutput.element small3 10) :=
  .add _ _ small3 _ (.uint32 10) SelectedRootStatics175.small_binding (.variable _ _ _ (by rfl))
    (by decide) (.within small3 10 (by decide))

theorem length_source : C99ArrayReference.Exec FftLeafPrograms.program
    (.assign "len".toList (.load "MAX_BL_SMALL3".toList (.var "logn".toList))) logged sized :=
  .assign _ _ _ .uint64 none (.uint64 335) (by rfl)
    (.load _ _ _ 335 length_pointer SelectedRootStatics175.length)

theorem prime_source : C99ArrayReference.Exec FftLeafPrograms.program
    (.bindPtr "primes".toList "PRIMES3".toList C99ProcedureParser.zero) sized after :=
  .bindPtr _ _ _ _ primes (RootBinding175.zero sized "PRIMES3" primes SelectedRootStatics175.primes_binding (by change 0≤_; exact Nat.zero_le _))

theorem inner_source : KeygenMakeFgSource.Exec (branchBody "MAX_BL_SMALL3" "PRIMES3") logged ⟨after,.normal⟩ :=
  .seqNormal _ _ logged sized ⟨after,.normal⟩
    (.level _ _ _ (.modular _ _ _ (.base _ _ _ length_source)))
    (.seqNormal _ _ sized after ⟨after,.normal⟩
      (.level _ _ _ (.modular _ _ _ (.base _ _ _ prime_source)))
      (.level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip after)))))

theorem branch_source : Exec env.ctx (branch "MAX_BL_SMALL3" "PRIMES3") logged ⟨after,.normal⟩ := by
  have scopeRun := KeygenMakeFgSource.Exec.scope [] [] (branchBody "MAX_BL_SMALL3" "PRIMES3")
    logged ⟨after,.normal⟩ inner_source
  apply KeygenDeepestSource.Exec.base
  simpa only [KeygenPublicForwardCall.restore_empty] using scopeRun

theorem source : Exec env.ctx (KeygenDeepestSource.part 1) before ⟨after,.normal⟩ := by
  rw [shape]
  exact .seqNormal _ _ before logged ⟨after,.normal⟩
    (.logn _ _ .uint32 none 10 (by rfl) logn_read)
    (.seqNormal _ _ logged after ⟨after,.normal⟩
      (.ternaryTrue _ _ _ _ 1 ternary_read (by decide) branch_source)
      (DeepestDeclarations175.array_source env.ctx .skip after after (.skip after)))

theorem length_cell : after.locals "len".toList=some (.uint64,some (.uint64 335)) := rfl
theorem logn_cell : after.locals "logn".toList=some (.uint32,some (.uint32 10)) := rfl
theorem primes_cell : after.arrays "primes".toList=some primes := rfl

end FT1536.Source3.SelectedDeepestConfig175
