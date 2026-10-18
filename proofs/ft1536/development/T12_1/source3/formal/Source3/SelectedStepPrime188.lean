import Source3.StepPrimeDeclarations188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStepPrime188
open C99ArrayReference (State bindValue)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes)
open SelectedTopInit178 (p p0i r2)

noncomputable abbrev before := SelectedStepMove187.after
noncomputable def initial := bindValue before "u".toList .uint64 (.uint64 0)
noncomputable def declared := StepPrimeDeclarations188.after initial
noncomputable def withP := bindValue declared "p".toList .uint32 (.uint32 p)
noncomputable def withI := bindValue withP "p0i".toList .uint32 (.uint32 p0i)
noncomputable def after := bindValue withI "R2".toList .uint32 (.uint32 r2)

theorem initial_source : Exec StepPrimeShape188.initial before ⟨initial,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 none (.int32 0) SelectedStepReady187.u_declared
    (.scalar _ _ (.literal .int32 0))))

theorem guard : C99ArrayReference.scalar initial StepPrimeShape188.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ rfl) (.variable _ _ _ rfl)
    (.step .lt (.uint64 0) (.uint64 1) .uint64 rfl (.uint64 0) (.uint64 1) rfl rfl)

theorem p_bytes : C99MemoryReference.Load32 declared.heap (KeygenLevelCalls.fieldPointer primes .p) p :=
  SelectedStepReady187.prime_object.2.2.2.2.2.2 0 (KeygenStaticReads.first .ternary) (KeygenStaticReads.first_value .ternary) .p

theorem p_read : KeygenLevelCalls.PrimeRead declared "primes".toList (FirstStepEntry187.var "u") .p (.uint32 p) :=
  .read primes p (.add _ _ primes primes (.uint64 0) SelectedStepReady187.prime_binding
    (.variable _ _ _ rfl) (by decide) (.within primes 0 (by change 0≤_; exact Nat.zero_le _))) rfl (by decide) p_bytes

theorem p_source : Exec StepPrimeShape188.pSet declared ⟨withP,.normal⟩ :=
  .level _ _ _ (.prime _ _ _ _ _ .uint32 none (.uint32 p) rfl p_read)

theorem i_source : Exec StepPrimeShape188.iSet withP ⟨withI,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint32 none (.uint32 p0i) rfl
    (.call1 _ _ _ _ (.scalar _ _ (.variable _ _ _ rfl)) (.inverse _ _ (KeygenNinv31.source_exists p)))))

theorem r_source : Exec StepPrimeShape188.rSet withI ⟨after,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint32 none (.uint32 r2) rfl
    (.call2 _ _ _ _ _ _ (.scalar _ _ (.variable _ _ _ rfl)) (.scalar _ _ (.variable _ _ _ rfl))
      (.r2 _ _ (KeygenModpR2Exec.source_exists withI p p0i)))))

theorem append_source (tail : KeygenMakeFgSource.Stmt) (out : C99ProcedureReference.Result)
    (rest : Exec tail after out) : Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps tail) initial out :=
  MakeFgSequence187.source StepPrimeShape188.declarations initial declared (StepPrimeDeclarations188.source initial)
    (.seq StepPrimeShape188.pSet (.seq StepPrimeShape188.iSet (.seq StepPrimeShape188.rSet tail))) out
    (.seqNormal _ _ declared withP out p_source (.seqNormal _ _ withP withI out i_source
      (.seqNormal _ _ withI after out r_source rest)))

theorem prefix_source : Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps KeygenMakeFgSource.skip) initial ⟨after,.normal⟩ :=
  append_source _ _ (MakeFgDeclarations176.array_source .skip after after (.skip after))

theorem continue_inner (out : C99ProcedureReference.Result) (rest : Exec StepPrimeShape188.remaining after out) :
    Exec StepPrimeShape188.inner initial out := by
  rw [StepPrimeShape188.prefix_shape]
  exact append_source _ out rest

theorem heap : after.heap=SelectedStepMove187.after.heap := by
  dsimp only [after,withI,withP,declared,StepPrimeDeclarations188.after,StepPrimeDeclarations188.withV,
    StepPrimeDeclarations188.withWords,DeepestDeclarations175.clear,C99DeclarationStatements.effect,initial,bindValue]

theorem p_cell : KeygenModpR2Exec.Slot after "p" p := rfl
theorem i_cell : KeygenModpR2Exec.Slot after "p0i" p0i := rfl
theorem r2_cell : KeygenModpR2Exec.Slot after "R2" r2 := rfl

end FT1536.Source3.SelectedStepPrime188
