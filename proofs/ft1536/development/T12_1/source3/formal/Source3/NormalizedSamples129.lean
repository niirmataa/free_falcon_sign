import Source3.SelectedSamples129
import Source3.KeygenLazySampler129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NormalizedSamples129
open C99CompactState115 (State reference)
open C99FiniteMemory114 (Heap memory)
open SelectedFullSampler128 (ctx prepared)

theorem lazy_put_congr (a b : Heap) (same : memory a=memory b)
    (block : Nat) (data : C99FiniteMemory114.Block) :
    memory (C99LazyBlock129.putBlock a block data)=memory (C99LazyBlock129.putBlock b block data) :=
  (C99LazyBlock129.memory_equal a block data).trans
    ((KeygenLazySampler129.put_congr a b same block data).trans (C99LazyBlock129.memory_equal b block data).symm)

theorem double_congr (a b : Heap) (same : memory a=memory b) (first second : Nat)
    (x y : C99FiniteMemory114.Block) :
    memory (C99LazyBlock129.putBlock (C99LazyBlock129.putBlock a first x) second y)=
      memory (C99LazyBlock129.putBlock (C99LazyBlock129.putBlock b first x) second y) :=
  lazy_put_congr _ _ (lazy_put_congr a b same first x) second y

theorem return_congr (caller : State) (a b : Heap) (same : memory a=memory b) :
    reference {caller with heap := a}=reference {caller with heap := b} := by
  unfold reference
  rw [same]

def fInternal : State := KeygenLazySampler129.normalize ctx SelectedFullSampler128.destination
  SelectedFullSampler128.initial GeneratedSampler129F24.contextBlock
  GeneratedSampler129F24.coefficientBlock GeneratedSampler129F24.localSnapshot

theorem f_context : C99FiniteMap114.lookup GeneratedSampler129F24.after.heap.blocks ctx.block=
    some GeneratedSampler129F24.contextBlock := by decide +kernel

theorem f_coefficients : C99FiniteMap114.lookup GeneratedSampler129F24.after.heap.blocks SelectedFullSampler128.destination.block=
    some GeneratedSampler129F24.coefficientBlock := by decide +kernel

theorem f_same : reference GeneratedSampler129F24.after=reference fInternal :=
  (KeygenSamplerNormalize128.reference_equal ctx SelectedFullSampler128.destination 1536
    SelectedFullSampler128.initial GeneratedSampler129F24.after _ _ _ SamplerFPrefix129.through24
    SelectedFullSampler128.pointer_binding f_context f_coefficients rfl).trans
    (KeygenLazySampler129.reference_equal ctx SelectedFullSampler128.destination SelectedFullSampler128.initial _ _ _).symm

def middle : State := {prepared with heap := fInternal.heap}

theorem middle_same : reference SelectedFReturn129.after=reference middle :=
  return_congr prepared _ _ (congrArg C99ArrayReference.State.heap f_same)

def gInternal : State := KeygenLazySampler129.normalize ctx SelectedGStart129.destination
  SelectedGStart129.initial GeneratedSampler129G24.contextBlock
  GeneratedSampler129G24.coefficientBlock GeneratedSampler129G24.localSnapshot

theorem g_context : C99FiniteMap114.lookup GeneratedSampler129G24.after.heap.blocks ctx.block=
    some GeneratedSampler129G24.contextBlock := by decide +kernel

theorem g_coefficients : C99FiniteMap114.lookup GeneratedSampler129G24.after.heap.blocks SelectedGStart129.destination.block=
    some GeneratedSampler129G24.coefficientBlock := by decide +kernel

theorem g_same : reference GeneratedSampler129G24.after=reference gInternal :=
  (KeygenSamplerNormalize128.reference_equal ctx SelectedGStart129.destination 1536
    SelectedGStart129.initial GeneratedSampler129G24.after _ _ _ SamplerGPrefix129.through24
    SelectedGStart129.pointer_binding g_context g_coefficients rfl).trans
    (KeygenLazySampler129.reference_equal ctx SelectedGStart129.destination SelectedGStart129.initial _ _ _).symm

theorem g_entry_heap : (reference SelectedGStart129.initial).heap=(reference SelectedFReturn129.after).heap := by
  have binding := C99ArrayReference.bind_heap _ _ _ _ SelectedGStart129.binding
  have setup := C99ModularFrame.source_frame KeygenSamplerSource.prologue
    (reference SelectedGStart129.bound) ⟨reference SelectedGStart129.declared,.normal⟩
    SelectedGStart129.prologue (by decide +kernel)
  have initialized := C99ModularFrame.source_frame KeygenSamplerSource.initial
    (reference SelectedGStart129.declared) ⟨reference SelectedGStart129.initial,.normal⟩
    SelectedGStart129.initialization (by decide +kernel)
  exact initialized.1.trans (setup.1.trans binding)

/-- Four literal block updates over the original sampler entry, replacing
    the long history only after proving complete reference-state equality. -/
def after : State := {prepared with
  heap := C99LazyBlock129.putBlock
    (C99LazyBlock129.putBlock middle.heap ctx.block GeneratedSampler129G24.contextBlock)
    SelectedGStart129.destination.block GeneratedSampler129G24.coefficientBlock}

theorem final_heap : memory GeneratedSampler129G24.after.heap=memory after.heap := by
  have start : memory SelectedGStart129.initial.heap=memory middle.heap :=
    g_entry_heap.trans (congrArg C99ArrayReference.State.heap middle_same)
  exact (congrArg C99ArrayReference.State.heap g_same).trans
    (double_congr _ _ start ctx.block SelectedGStart129.destination.block
      GeneratedSampler129G24.contextBlock GeneratedSampler129G24.coefficientBlock)

theorem after_same : reference SamplerGComplete129.after=reference after :=
  return_congr prepared _ _ final_heap

theorem first : KeygenSamplerContext.Call KeygenFullData127.env.ctx
    (reference prepared) "f" (reference middle) := by
  rw [← middle_same]
  exact SelectedSamples129.first

theorem second : KeygenSamplerContext.Call KeygenFullData127.env.ctx
    (reference middle) "g" (reference after) := by
  have source := SelectedSamples129.second
  rw [middle_same,after_same] at source
  exact source

end FT1536.Source3.NormalizedSamples129
