import Source3.FifthStepEntry217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FifthStepStart217
open C99ArrayReference (State bindValue)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)

def declared (s : State) : State := StepDeclarations187.after (FifthStepEntry217.entry s)
def withN (s : State) : State := bindValue (declared s) "n".toList .uint64 (.uint64 32)
def ready (s : State) : State := bindValue (withN s) "hn".toList .uint64 (.uint64 16)
def startCode : KeygenMakeFgSource.Stmt :=
  .seq (KeygenMakeFgSource.part .step 0) (.seq StepPrefixProgram187.nSet StepPrefixProgram187.hnSet)
def remainder : KeygenMakeFgSource.Stmt :=
  KeygenMakeFgSource.chain ([StepPrefixProgram187.choice]++StepPrefixProgram187.pointers++[StepPrefixProgram187.move])

theorem declared_logn (s : State) : Slot (declared s) "logn" 5 := rfl

theorem n_source (s : State) : Exec StepPrefixProgram187.nSet (declared s) ⟨withN s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 none (.uint64 32) rfl
    (.scalar _ _ (.shift .left _ _ _ _ _ (.cast .uint64 _ _ (.literal .int32 1))
      (.variable _ _ _ (declared_logn s))
      (.unsignedLeft (.uint64 1) (.uint32 5) 5 rfl rfl (by decide))))))

theorem hn_source (s : State) : Exec StepPrefixProgram187.hnSet (withN s) ⟨ready s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 none (.uint64 16) rfl
    (.scalar _ _ (.shift .right _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
      (.right (.uint64 32) (.int32 1) 1 rfl (by decide))))))

theorem source_at (s : State) : Exec startCode (FifthStepEntry217.entry s) ⟨ready s,.normal⟩ :=
  .seqNormal _ _ _ (declared s) _ (StepDeclarations187.source _)
    (.seqNormal _ _ (declared s) (withN s) _ (n_source s) (hn_source s))

theorem n_cell (s : State) : Cell (ready s) "n".toList 32 := rfl
theorem hn_cell (s : State) : Cell (ready s) "hn".toList 16 := rfl

theorem heap (s : State) : (ready s).heap=s.heap := by
  rw [ready,SelectedStepAddPrime195.bind_heap,withN,SelectedStepAddPrime195.bind_heap]
  exact (StepDeclarations187.heap _).trans (FifthStepEntry217.entry_heap s)

theorem part1_continue (s : State) (out : C99ProcedureReference.Result)
    (rest : Exec remainder (ready s) out) :
    Exec (KeygenMakeFgSource.part .step 1) (declared s) out := by
  rw [StepPrefixProgram187.shape]
  exact .seqNormal _ _ (declared s) (withN s) _ (n_source s)
    (.seqNormal _ _ (withN s) (ready s) out (hn_source s) rest)

end FT1536.Source3.FifthStepStart217
