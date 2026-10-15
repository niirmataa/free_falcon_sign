import Source3.SelectedFReturn129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGStart129
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def ctx := SelectedFullSampler128.ctx
def caller := SelectedFReturn129.after
def destination := KeygenMakeEntry.input KeygenFullData127.env.blocks 1

theorem context : KeygenSamplerContext.Resolve KeygenFullData127.env.ctx (reference caller) :=
  KeygenSamplerContext121.guard_sound KeygenFullData127.env.ctx caller (by decide +kernel)

def bindingResult := C99CompactBinding115.bind noCalls caller KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "g")
theorem binding_defined : bindingResult.isSome=true := by decide +kernel
def bound : State := bindingResult.get binding_defined
theorem binding_computed : C99CompactBinding115.bind noCalls caller KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "g")=some bound :=
  SelectedInput124.option_get bindingResult binding_defined
theorem binding : C99ArrayReference.Bind (reference caller) KeygenSamplerCalls.params
    (KeygenSamplerCalls.arguments "g") (reference bound) :=
  C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) caller bound _ _ binding_computed

def prologueResult := KeygenScalarCompute121.run 16 KeygenSamplerSource.prologue bound
theorem prologue_defined : prologueResult.isSome=true := by decide +kernel
def declared : State := prologueResult.get prologue_defined
theorem prologue_computed : KeygenScalarCompute121.run 16 KeygenSamplerSource.prologue bound=some declared :=
  SelectedInput124.option_get prologueResult prologue_defined
theorem prologue : C99ModularReference.Exec KeygenSamplerSource.prologue (reference bound) ⟨reference declared,.normal⟩ :=
  KeygenScalarCompute121.run_sound 16 _ bound declared prologue_computed

def initialResult := KeygenScalarCompute121.run 16 KeygenSamplerSource.initial declared
theorem initial_defined : initialResult.isSome=true := by decide +kernel
def initial : State := initialResult.get initial_defined
theorem initial_computed : KeygenScalarCompute121.run 16 KeygenSamplerSource.initial declared=some initial :=
  SelectedInput124.option_get initialResult initial_defined
theorem initialization : C99ModularReference.Exec KeygenSamplerSource.initial (reference declared) ⟨reference initial,.normal⟩ :=
  KeygenScalarCompute121.run_sound 16 _ declared initial initial_computed

/-- Alias for the generated-segment input interface, not a sampler return. -/
def after := initial
theorem pointer_binding : (reference initial).arrays "v".toList=some destination := by decide +kernel
theorem bit_reset : C99NameMap115.lookup initial.locals "rb".toList=some (.u64 (some 0)) ∧
    C99NameMap115.lookup initial.locals "rbits".toList=some (.u32 (some 0)) := by decide +kernel

end FT1536.Source3.SelectedGStart129
