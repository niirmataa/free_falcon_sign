import Source3.MkgmCall200
import Source3.SecondStepPrime200

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepGenerator200
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open SelectedTopInit178 (p p0i)
open SecondStepLayout197 (gm igm)
open KeygenSmallOutput (element)

noncomputable abbrev before (callee : State) := SecondStepPrime200.after callee

theorem g_bytes (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    Load32 (before callee).heap (KeygenLevelCalls.fieldPointer primes .g) KeygenFirstPrime.generator := by
  rw [SecondStepPrime200.heap]
  exact (SecondStepStatic200.prime_object callee run).2.2.2.2.2.2 0
    (KeygenStaticReads.first .ternary) (KeygenStaticReads.first_value .ternary) .g

theorem generator_read (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    KeygenLevelCalls.PrimeRead (before callee) "primes".toList (FirstStepEntry187.var "u") .g
      (.uint32 KeygenFirstPrime.generator) :=
  .read primes KeygenFirstPrime.generator
    (.add _ _ primes primes (.uint64 0) (SecondStepStatic200.prime_binding callee)
      (.variable _ _ _ rfl) (by decide) (.within primes 0 (by change 0≤_; exact Nat.zero_le _)))
    rfl (by decide) (g_bytes callee run)

theorem input (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    MkgmCall200.Input 7 (before callee) gm igm rev KeygenFirstPrime.generator p p0i := by
  refine ⟨SecondStepPrime200.p_cell callee,SecondStepPrime200.i_cell callee,rfl,
    generator_read callee run,rfl,rfl,?_,?_,rfl,rfl,?_,?_,?_,?_⟩
  · exact SecondStepStatic200.rev_binding callee
  · rw [SecondStepPrime200.heap]; exact SecondStepStatic200.rev_source callee run
  · intro j bound
    change C99MemoryReference.Allocated (before callee).heap (⟨31,0,71680,4,2462+j⟩ : C99MemoryReference.ArrayPointer)
    rw [SecondStepPrime200.heap]
    exact SecondStepStatic200.allocated callee run (2462+j) (by change j<256 at bound; omega)
  · intro j bound
    change C99MemoryReference.Allocated (before callee).heap (⟨31,0,71680,4,2718+j⟩ : C99MemoryReference.ArrayPointer)
    rw [SecondStepPrime200.heap]
    exact SecondStepStatic200.allocated callee run (2718+j) (by change j<256 at bound; omega)
  · rw [SecondStepPrime200.heap]; exact SecondStepStatic200.writable callee run
  · rw [SecondStepPrime200.heap]; exact SecondStepStatic200.writable callee run

theorem source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    ∃ (out : State) (gvs ivs : Fin 256 → BitVec 32),
      Exec StepPrimeShape188.generateBranch (before callee) ⟨out,.normal⟩ ∧
      out.locals=(before callee).locals ∧ out.arrays=(before callee).arrays ∧
      (∀ i, Load32 out.heap (element gm i.val) (gvs i)) ∧
      (∀ i, Load32 out.heap (element igm i.val) (ivs i)) := by
  obtain ⟨out,exec,locals,arrays,reads⟩ := MkgmCall200.branch_source 7 (before callee) gm igm rev
    KeygenFirstPrime.generator p p0i (input callee run) rfl
  have gRead (i : Fin 256) : ∃ w, Load32 out.heap (element gm i.val) w := (reads i.val i.isLt).1
  have iRead (i : Fin 256) : ∃ w, Load32 out.heap (element igm i.val) w := (reads i.val i.isLt).2
  exact ⟨out,(fun i => Classical.choose (gRead i)),(fun i => Classical.choose (iRead i)),exec,locals,arrays,
    (fun i => Classical.choose_spec (gRead i)),(fun i => Classical.choose_spec (iRead i))⟩

/-- Continuation in the original first-prime inner body, after its generator branch. -/
theorem continue_inner (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (generated : State) (generator : Exec StepPrimeShape188.generateBranch (before callee) ⟨generated,.normal⟩)
    (out : C99ProcedureReference.Result) (rest : Exec StepPrimeShape188.tail generated out) :
    Exec StepPrimeShape188.inner (SecondStepPrime200.initial callee) out := by
  apply SecondStepPrime200.continue_inner callee run out
  rw [StepPrimeShape188.remaining_shape]
  exact .seqNormal _ _ (before callee) generated out generator rest

end FT1536.Source3.SecondStepGenerator200
