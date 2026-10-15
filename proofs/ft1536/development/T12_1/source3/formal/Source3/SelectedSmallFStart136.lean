import Source3.SelectedBound135
import Source3.KeygenSmallShape136
import Source3.C99ProcedureRun136
import Source3.FprTernary136
import Source3.C99CompactBinding115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSmallFStart136
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def before : State := SelectedBound135.after
def args := KeygenSmallShape136.args "rt1" "f"
def bindingResult := C99CompactBinding115.bind noCalls before KeygenSearchLeaves.smallParams args

theorem binding_defined : bindingResult.isSome=true := by decide +kernel
def bound : State := bindingResult.get binding_defined

theorem binding_computed : C99CompactBinding115.bind noCalls before KeygenSearchLeaves.smallParams args=some bound :=
  SelectedInput124.option_get bindingResult binding_defined

theorem binding : C99ArrayReference.Bind (reference before) KeygenSearchLeaves.smallParams args (reference bound) :=
  C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) before bound _ _ binding_computed

def declarationResult := C99ProcedureRun136.run FprTernary136.calls 4 KeygenSmallShape136.declaration bound
theorem declaration_defined : declarationResult.isSome=true := by decide +kernel
def declared : State := declarationResult.get declaration_defined

theorem declaration : C99ProcedureReference.Exec KeygenSearchFft.program KeygenSmallShape136.declaration
    (reference bound) ⟨reference declared,.normal⟩ :=
  C99ProcedureRun136.sound _ _ FprTernary136.sound 4 _ bound declared (SelectedInput124.option_get declarationResult declaration_defined)

def sizeResult := C99ProcedureRun136.run FprTernary136.calls 4 KeygenSmallShape136.size declared
theorem size_defined : sizeResult.isSome=true := by decide +kernel
def sized : State := sizeResult.get size_defined

theorem size : C99ProcedureReference.Exec KeygenSearchFft.program KeygenSmallShape136.size
    (reference declared) ⟨reference sized,.normal⟩ :=
  C99ProcedureRun136.sound _ _ FprTernary136.sound 4 _ declared sized (SelectedInput124.option_get sizeResult size_defined)

def initialResult := C99ProcedureRun136.run FprTernary136.calls 4 KeygenSmallShape136.initial sized
theorem initial_defined : initialResult.isSome=true := by decide +kernel
def initial : State := initialResult.get initial_defined

theorem initialization : C99ProcedureReference.Exec KeygenSearchFft.program KeygenSmallShape136.initial
    (reference sized) ⟨reference initial,.normal⟩ :=
  C99ProcedureRun136.sound _ _ FprTernary136.sound 4 _ sized initial (SelectedInput124.option_get initialResult initial_defined)

theorem dimension : C99NameMap115.lookup initial.locals "n".toList=some (.u64 (some 1536)) := by decide +kernel
theorem counter : C99NameMap115.lookup initial.locals "u".toList=some (.u64 (some 0)) := by decide +kernel

end FT1536.Source3.SelectedSmallFStart136
