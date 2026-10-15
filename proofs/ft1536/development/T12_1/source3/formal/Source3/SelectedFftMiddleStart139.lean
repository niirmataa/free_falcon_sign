import Source3.FftMiddleShape139
import Source3.C99Chain139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftMiddleStart139
open C99CompactState115 (State reference)
open FftMiddleShape139

def before : State := NormalizedFftFirst138.after
def setupCode := C99ProcedureParser.chain [setT,setMinimum,outerInitial]

def setupResult := C99ProcedureRun138.run FprFastCalls137.calls 32 setupCode before
theorem setup_defined : setupResult.isSome=true := by decide +kernel
def setup : State := setupResult.get setup_defined

theorem setup_source : C99ProcedureReference.Exec KeygenSearchFft.program setupCode
    (reference before) ⟨reference setup,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 32 _ before setup
    (SelectedInput124.option_get setupResult setup_defined)

def outerEntryResult := C99ProcedureRun138.run FprFastCalls137.calls 32 outerPrologue setup
theorem outerEntry_defined : outerEntryResult.isSome=true := by decide +kernel
def outerEntry : State := outerEntryResult.get outerEntry_defined

theorem outerEntry_source : C99ProcedureReference.Exec KeygenSearchFft.program outerPrologue
    (reference setup) ⟨reference outerEntry,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 32 _ setup outerEntry
    (SelectedInput124.option_get outerEntryResult outerEntry_defined)

def groupInitResult := C99ProcedureRun138.run FprFastCalls137.calls 32 groupInitial outerEntry
theorem groupInit_defined : groupInitResult.isSome=true := by decide +kernel
def groupInit : State := groupInitResult.get groupInit_defined

theorem groupInit_source : C99ProcedureReference.Exec KeygenSearchFft.program groupInitial
    (reference outerEntry) ⟨reference groupInit,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 32 _ outerEntry groupInit
    (SelectedInput124.option_get groupInitResult groupInit_defined)

end FT1536.Source3.SelectedFftMiddleStart139
