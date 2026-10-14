import Source3.SelectedFullStatics127
import Source3.KeygenSamplerNormalize128
import Source3.KeygenAttemptSetup126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFullSampler128
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open KeygenFullData127 (env)

def ctx := KeygenSamplerContext.rng env.ctx
def capResult := KeygenCapCompute126.run SelectedFullStart127.ready
theorem cap_defined : capResult.isSome=true := by decide +kernel
def counted : State := capResult.get cap_defined
theorem cap_computed : KeygenCapCompute126.run SelectedFullStart127.ready=some counted :=
  SelectedInput124.option_get capResult cap_defined
theorem cap_source : C99ProcedureReference.Exec KeygenSearchFft.program KeygenAttemptCap.code
    (reference SelectedFullStart127.ready) ⟨reference counted,.normal⟩ :=
  KeygenCapCompute126.run_sound _ SelectedFullStart127.ready counted cap_computed

def setupResult := KeygenAttemptSetup126.run env.ctx counted
theorem setup_defined : setupResult.isSome=true := by decide +kernel
def prepared : State := setupResult.get setup_defined
theorem setup_computed : KeygenAttemptSetup126.run env.ctx counted=some prepared :=
  SelectedInput124.option_get setupResult setup_defined
theorem capped : KeygenMakeSampling.CappedSetup env.ctx (reference SelectedFullStart127.ready) ⟨reference prepared,.normal⟩ :=
  .run (reference counted) (reference prepared) cap_source (KeygenAttemptSetup126.run_sound env.ctx counted prepared setup_computed)

theorem context : KeygenSamplerContext.Resolve env.ctx (reference prepared) :=
  KeygenSamplerContext121.guard_sound env.ctx prepared (by decide +kernel)

def bindingResult := C99CompactBinding115.bind noCalls prepared KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "f")
theorem binding_defined : bindingResult.isSome=true := by decide +kernel
def bound : State := bindingResult.get binding_defined
theorem binding_computed : C99CompactBinding115.bind noCalls prepared KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "f")=some bound :=
  SelectedInput124.option_get bindingResult binding_defined
theorem binding : C99ArrayReference.Bind (reference prepared) KeygenSamplerCalls.params
    (KeygenSamplerCalls.arguments "f") (reference bound) :=
  C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) prepared bound _ _ binding_computed

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

def destination := KeygenMakeEntry.input env.blocks 0
theorem pointer_binding : (reference initial).arrays "v".toList=some destination := by decide +kernel
theorem dimension : (reference initial).locals "n".toList=some (.uint64,some (.uint64 1536)) := by decide +kernel

end FT1536.Source3.SelectedFullSampler128
