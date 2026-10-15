import Source3.NormalizedSmallImages136
import Source3.FftShape138
import Source3.FprFastCalls137
import Source3.C99CompactBinding115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftFStart138
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def before : State := NormalizedSmall136.after
def args := FftShape138.args "rt1"
def bindingResult := C99CompactBinding115.bind noCalls before GeneratedFft138Syntax.function.params args

theorem binding_defined : bindingResult.isSome=true := by decide +kernel
def bound : State := bindingResult.get binding_defined

theorem binding_computed : C99CompactBinding115.bind noCalls before GeneratedFft138Syntax.function.params args=some bound :=
  SelectedInput124.option_get bindingResult binding_defined

theorem binding : C99ArrayReference.Bind (reference before) GeneratedFft138Syntax.function.params args (reference bound) :=
  C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) before bound _ _ binding_computed

def declarationResult := C99ProcedureRun138.run FprFastCalls137.calls 8 FftShape138.declaration bound
theorem declaration_defined : declarationResult.isSome=true := by decide +kernel
def declared : State := declarationResult.get declaration_defined

theorem declaration : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.declaration
    (reference bound) ⟨reference declared,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 8 _ bound declared (SelectedInput124.option_get declarationResult declaration_defined)

def sizeResult := C99ProcedureRun138.run FprFastCalls137.calls 8 FftShape138.size declared
theorem size_defined : sizeResult.isSome=true := by decide +kernel
def sized : State := sizeResult.get size_defined

theorem size : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.size
    (reference declared) ⟨reference sized,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 8 _ declared sized (SelectedInput124.option_get sizeResult size_defined)

def halfResult := C99ProcedureRun138.run FprFastCalls137.calls 8 FftShape138.halfSize sized
theorem half_defined : halfResult.isSome=true := by decide +kernel
def halfSized : State := halfResult.get half_defined

theorem halfSize : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.halfSize
    (reference sized) ⟨reference halfSized,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 8 _ sized halfSized (SelectedInput124.option_get halfResult half_defined)

def initialResult := C99ProcedureRun138.run FprFastCalls137.calls 8 FftShape138.firstInitial halfSized
theorem initial_defined : initialResult.isSome=true := by decide +kernel
def initial : State := initialResult.get initial_defined

theorem initialization : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstInitial
    (reference halfSized) ⟨reference initial,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 8 _ halfSized initial (SelectedInput124.option_get initialResult initial_defined)

theorem dimension : C99NameMap115.lookup initial.locals "n".toList=some (.u64 (some 1536)) := by decide +kernel
theorem half_dimension : C99NameMap115.lookup initial.locals "hn".toList=some (.u64 (some 768)) := by decide +kernel
theorem counter : C99NameMap115.lookup initial.locals "u".toList=some (.u64 (some 0)) := by decide +kernel

end FT1536.Source3.SelectedFftFStart138
