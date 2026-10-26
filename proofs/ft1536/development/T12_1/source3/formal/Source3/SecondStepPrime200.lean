import Source3.SecondStepStatic200
import Source3.StepPrimeDeclarations188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepPrime200
open C99ArrayReference (State bindValue)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes)
open SelectedTopInit178 (p p0i r2)

noncomputable abbrev before (callee : State) := SecondStepMove197.after callee
noncomputable def initial (callee : State) := bindValue (before callee) "u".toList .uint64 (.uint64 0)
noncomputable def declared (callee : State) := StepPrimeDeclarations188.after (initial callee)
noncomputable def withP (callee : State) := bindValue (declared callee) "p".toList .uint32 (.uint32 p)
noncomputable def withI (callee : State) := bindValue (withP callee) "p0i".toList .uint32 (.uint32 p0i)
noncomputable def after (callee : State) := bindValue (withI callee) "R2".toList .uint32 (.uint32 r2)

theorem initial_source (callee : State) : Exec StepPrimeShape188.initial (before callee) ⟨(initial callee),.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 none (.int32 0) rfl
    (.scalar _ _ (.literal .int32 0))))

theorem guard (callee : State) : C99ArrayReference.scalar (initial callee) StepPrimeShape188.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ rfl) (.variable _ _ _ rfl)
    (.step .lt (.uint64 0) (.uint64 2) .uint64 rfl (.uint64 0) (.uint64 2) rfl rfl)

theorem p_bytes (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) : C99MemoryReference.Load32 (declared callee).heap (KeygenLevelCalls.fieldPointer primes .p) p :=
  (SecondStepStatic200.prime_object callee run).2.2.2.2.2.2 0 (KeygenStaticReads.first .ternary) (KeygenStaticReads.first_value .ternary) .p

theorem p_read (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) : KeygenLevelCalls.PrimeRead (declared callee) "primes".toList (FirstStepEntry187.var "u") .p (.uint32 p) :=
  .read primes p (.add _ _ primes primes (.uint64 0) (SecondStepStatic200.prime_binding callee)
    (.variable _ _ _ rfl) (by decide) (.within primes 0 (by change 0≤_; exact Nat.zero_le _))) rfl (by decide) (p_bytes callee run)

theorem p_source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) : Exec StepPrimeShape188.pSet (declared callee) ⟨(withP callee),.normal⟩ :=
  .level _ _ _ (.prime _ _ _ _ _ .uint32 none (.uint32 p) rfl (p_read callee run))

theorem i_source (callee : State) : Exec StepPrimeShape188.iSet (withP callee) ⟨(withI callee),.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint32 none (.uint32 p0i) rfl
    (.call1 _ _ _ _ (.scalar _ _ (.variable _ _ _ rfl)) (.inverse _ _ (KeygenNinv31.source_exists p)))))

theorem r_source (callee : State) : Exec StepPrimeShape188.rSet (withI callee) ⟨(after callee),.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint32 none (.uint32 r2) rfl
    (.call2 _ _ _ _ _ _ (.scalar _ _ (.variable _ _ _ rfl)) (.scalar _ _ (.variable _ _ _ rfl))
      (.r2 _ _ (KeygenModpR2Exec.source_exists (withI callee) p p0i)))))

theorem append_source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) (tail : KeygenMakeFgSource.Stmt) (out : C99ProcedureReference.Result)
    (rest : Exec tail (after callee) out) : Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps tail) (initial callee) out :=
  MakeFgSequence187.source StepPrimeShape188.declarations (initial callee) (declared callee) (StepPrimeDeclarations188.source (initial callee))
    (.seq StepPrimeShape188.pSet (.seq StepPrimeShape188.iSet (.seq StepPrimeShape188.rSet tail))) out
    (.seqNormal _ _ (declared callee) (withP callee) out (p_source callee run) (.seqNormal _ _ (withP callee) (withI callee) out (i_source callee)
      (.seqNormal _ _ (withI callee) (after callee) out (r_source callee) rest)))

theorem prefix_source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) : Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps KeygenMakeFgSource.skip) (initial callee) ⟨(after callee),.normal⟩ :=
  (append_source callee run) _ _ (MakeFgDeclarations176.array_source .skip (after callee) (after callee) (.skip (after callee)))

theorem continue_inner (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) (out : C99ProcedureReference.Result) (rest : Exec StepPrimeShape188.remaining (after callee) out) :
    Exec StepPrimeShape188.inner (initial callee) out := by
  rw [StepPrimeShape188.prefix_shape]
  exact (append_source callee run) _ out rest

theorem heap (callee : State) : (after callee).heap=(SecondStepMove197.after callee).heap := by
  dsimp only [after,withI,withP,declared,StepPrimeDeclarations188.after,StepPrimeDeclarations188.withV,
    StepPrimeDeclarations188.withWords,DeepestDeclarations175.clear,C99DeclarationStatements.effect,initial,bindValue]


theorem p_cell (callee : State) : KeygenModpR2Exec.Slot (after callee) "p" p := rfl
theorem i_cell (callee : State) : KeygenModpR2Exec.Slot (after callee) "p0i" p0i := rfl
theorem r2_cell (callee : State) : KeygenModpR2Exec.Slot (after callee) "R2" r2 := rfl

end FT1536.Source3.SecondStepPrime200
