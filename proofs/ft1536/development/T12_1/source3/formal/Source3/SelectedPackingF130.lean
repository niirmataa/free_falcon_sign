import Source3.PackingShape130
import Source3.KeygenResultantRunSound130
import Source3.NormalizedSamples129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPackingF130
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def before := NormalizedSamples129.after
def args := KeygenResultantGate.arguments "f"
def block : Nat := 7

def bindingResult := C99CompactBinding115.bind noCalls before KeygenResultantSource.params args
theorem binding_defined : bindingResult.isSome=true := by decide +kernel
def bound : State := bindingResult.get binding_defined
theorem binding_computed : C99CompactBinding115.bind noCalls before KeygenResultantSource.params args=some bound :=
  SelectedInput124.option_get bindingResult binding_defined

theorem binding : C99ArrayReference.Bind (reference before) KeygenResultantSource.params args (reference bound) :=
  C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) before bound _ _ binding_computed

theorem fresh : KeygenRngSource.Fresh (reference bound).heap block :=
  (C99FiniteAllocation115.fresh_iff bound.heap block).mp (by decide +kernel)

def entered := KeygenResultantInit130.entry bound block
def setupResult := C99ScalarSteps130.run 16 GeneratedResultantSyntax130.setup entered
theorem setup_defined : setupResult.isSome=true := by decide +kernel
def ready : State := setupResult.get setup_defined
theorem setup_computed : C99ScalarSteps130.run 16 KeygenResultantSource.setup entered=some ready := by
  rw [GeneratedResultantSyntax130.setup_eq]
  exact SelectedInput124.option_get setupResult setup_defined

theorem setup_source : C99ModularReference.Exec KeygenResultantSource.setup
    (KeygenResultantSource.entry (reference bound) block) ⟨reference ready,.normal⟩ := by
  have source := C99ScalarSteps130.run_sound 16 KeygenResultantSource.setup entered ready setup_computed
  change C99ModularReference.Exec KeygenResultantSource.setup (reference (KeygenResultantInit130.entry bound block)) _ at source
  rw [KeygenResultantInit130.entry_source] at source
  exact source

theorem zero_guard : KeygenResultantInit130.ZeroGuard ready block := by
  unfold KeygenResultantInit130.ZeroGuard
  decide +kernel

def zeroed := KeygenResultantInit130.zeroed ready block

def initialResult := KeygenWordEndpoints130.normal 32 PackingShape130.initial zeroed
theorem initial_defined : initialResult.isSome=true := by decide +kernel
def initial : State := initialResult.get initial_defined
theorem initial_computed : KeygenWordEndpoints130.normal 32 PackingShape130.initial zeroed=some initial :=
  SelectedInput124.option_get initialResult initial_defined

theorem initial_source : KeygenWordExec.Exec PackingShape130.initial (reference zeroed) ⟨reference initial,.normal⟩ :=
  KeygenWordEndpoints130.normal_sound 32 PackingShape130.initial zeroed initial initial_computed

theorem pointer_binding : (reference initial).arrays "b".toList=some (KeygenResultantSource.object block) := by decide +kernel
theorem dimension : C99NameMap115.lookup initial.locals "n".toList=some (.u64 (some 1536)) := by decide +kernel

end FT1536.Source3.SelectedPackingF130
