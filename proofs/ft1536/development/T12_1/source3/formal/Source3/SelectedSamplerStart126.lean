import Source3.SelectedSetup126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSamplerStart126
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open KeygenCallerData123 (env)

theorem context : KeygenSamplerContext.Resolve env.ctx (reference SelectedSetup126.ready) :=
  KeygenSamplerContext121.guard_sound env.ctx SelectedSetup126.ready (by decide +kernel)

def bindingResult := C99CompactBinding115.bind noCalls SelectedSetup126.ready
  KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "f")
theorem binding_defined : bindingResult.isSome=true := by decide +kernel
def bound : State := bindingResult.get binding_defined
theorem binding_computed : C99CompactBinding115.bind noCalls SelectedSetup126.ready
    KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "f")=some bound :=
  SelectedInput124.option_get bindingResult binding_defined
theorem binding : C99ArrayReference.Bind (reference SelectedSetup126.ready)
    KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "f") (reference bound) :=
  C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) SelectedSetup126.ready bound _ _ binding_computed

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

theorem outer_guard_computed : C99CompactScalar115.evaluate noCalls initial.locals C99CountedWords.condition=some (.i32 1) := by decide +kernel
theorem outer_guard : C99ArrayReference.scalar (reference initial) C99CountedWords.condition (.int32 1) :=
  C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
    initial.locals _ (.i32 1) outer_guard_computed

def xResult := KeygenScalarCompute121.run 16 KeygenSamplerSource.declareX initial
theorem x_defined : xResult.isSome=true := by decide +kernel
def firstRead : State := xResult.get x_defined
theorem x_computed : KeygenScalarCompute121.run 16 KeygenSamplerSource.declareX initial=some firstRead :=
  SelectedInput124.option_get xResult x_defined
theorem declaration : C99ModularReference.Exec KeygenSamplerSource.declareX (reference initial) ⟨reference firstRead,.normal⟩ :=
  KeygenScalarCompute121.run_sound 16 _ initial firstRead x_computed

theorem refill_guard_computed : C99CompactScalar115.evaluate noCalls firstRead.locals
    KeygenSamplerSource.refillCondition=some (.i32 1) := by decide +kernel
theorem refill_guard : C99ArrayReference.scalar (reference firstRead) KeygenSamplerSource.refillCondition (.int32 1) :=
  C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
    firstRead.locals _ (.i32 1) refill_guard_computed

end FT1536.Source3.SelectedSamplerStart126
