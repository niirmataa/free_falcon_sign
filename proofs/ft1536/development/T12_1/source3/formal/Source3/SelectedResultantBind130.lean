import Source3.NormalizedSamples129
import Source3.KeygenResultantRun130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedResultantBind130
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def before := NormalizedSamples129.after
def args := KeygenResultantGate.arguments "f"
def bindingResult := C99CompactBinding115.bind noCalls before KeygenResultantSource.params args

theorem binding_defined : bindingResult.isSome=true := by decide +kernel
def raw : State := bindingResult.get binding_defined

theorem binding_computed : C99CompactBinding115.bind noCalls before KeygenResultantSource.params args=some raw :=
  SelectedInput124.option_get bindingResult binding_defined

theorem raw_binding : C99ArrayReference.Bind (reference before) KeygenResultantSource.params args (reference raw) :=
  C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) before raw _ _ binding_computed

def localSnapshot := C99NameMap115.put KeygenGlobalCells127.globals "logn".toList (.u32 (some 10))
def arraySnapshot := C99NameMap115.put KeygenFullData127.tables "f".toList (KeygenMakeEntry.input KeygenFullData127.env.blocks 0)

theorem locals_image : raw.locals=localSnapshot := by decide +kernel
theorem arrays_image : raw.arrays=arraySnapshot := by decide +kernel
theorem globals_image : raw.globals=KeygenGlobalCells127.globals := by decide +kernel
theorem tables_image : raw.tables=KeygenFullData127.tables := by decide +kernel

def bound : State := ⟨before.heap,localSnapshot,arraySnapshot,KeygenGlobalCells127.globals,KeygenFullData127.tables⟩

theorem reference_equal : reference raw=reference bound := by
  have heap := C99ArrayReference.bind_heap _ _ _ _ raw_binding
  change C99FiniteMemory114.memory raw.heap=C99FiniteMemory114.memory before.heap at heap
  unfold reference bound
  rw [heap,locals_image,arrays_image,globals_image,tables_image]

theorem binding : C99ArrayReference.Bind (reference before) KeygenResultantSource.params args (reference bound) := by
  rw [← reference_equal]
  exact raw_binding

end FT1536.Source3.SelectedResultantBind130
