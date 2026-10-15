import Source3.SelectedFftMiddleStart139
import Source3.KeygenMemoryStability

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftPinned139
open C99MemoryReference
open C99CompactState115 (reference)
open C99FiniteMemory114 (memory)

theorem stable (before after : Memory) (kept : KeygenMemoryStability.Stable before after)
    (source : CertificateM0Environment.Pinned FftGlobalMemory.environment before) :
    CertificateM0Environment.Pinned FftGlobalMemory.environment after := by
  refine ⟨rfl,?_⟩
  intro table i bound
  have old := source.2 table i bound
  have same : KeygenMakeObjects.Block before after (FftGlobalMemory.block table) :=
    ⟨congrFun kept.size _,congrFun kept.writable _,fun off => kept.readonly _ off old.2⟩
  exact ⟨KeygenCallerShape123.load64_block _ _ _ _ same old.1,(congrFun kept.writable _).trans old.2⟩

theorem procedure (program : C99ProcedureReference.Program) (code : C99ProcedureReference.Stmt)
    (before : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (execution : C99ProcedureReference.Exec program code before out)
    (source : CertificateM0Environment.Pinned FftGlobalMemory.environment before.heap) :
    CertificateM0Environment.Pinned FftGlobalMemory.environment out.state.heap :=
  stable _ _ (KeygenMemoryStability.procedure _ _ _ _ execution) source

theorem put (before : C99FiniteMemory114.Heap) (block : Nat) (data : C99FiniteMemory114.Block)
    (notSquare : block≠1) (notCubic : block≠2)
    (source : CertificateM0Environment.Pinned FftGlobalMemory.environment (memory before)) :
    CertificateM0Environment.Pinned FftGlobalMemory.environment (memory (C99LazyBlock129.putBlock before block data)) := by
  rw [C99LazyBlock129.memory_equal]
  refine ⟨rfl,?_⟩
  intro table i bound
  have different : FftGlobalMemory.block table≠block := by cases table <;> exact Ne.symm (by assumption)
  have same : KeygenMakeObjects.Block (memory before)
      (memory (C99FiniteMemory114.putBlock before block data)) (FftGlobalMemory.block table) := by
    refine ⟨?_,?_,?_⟩
    · simp only [C99FiniteMemory114.size_putBlock,ite_eq_right different]
    · simp only [C99FiniteMemory114.writable_putBlock,ite_eq_right different]
    · intro offset
      simp only [C99FiniteMemory114.bytes_putBlock,ite_eq_right different]
  have old := source.2 table i bound
  exact ⟨KeygenCallerShape123.load64_block _ _ _ _ same old.1,same.2.1.trans old.2⟩

theorem setup_heap (ctx : KeygenSearchContext.Context) (before after : C99ArrayReference.State)
    (source : KeygenCallerInit.Setup ctx before after) : after.heap=before.heap := by
  cases source
  rfl

theorem prepared : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (reference SelectedFullSampler128.prepared).heap := by
  have counted := procedure _ _ _ _ SelectedFullSampler128.cap_source SelectedFullStatics127.fft_pinned
  have setup := KeygenAttemptSetup126.run_sound KeygenFullData127.env.ctx
    SelectedFullSampler128.counted SelectedFullSampler128.prepared SelectedFullSampler128.setup_computed
  rw [setup_heap _ _ _ setup]
  exact counted

theorem sampler_entry : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (reference SelectedFullSampler128.initial).heap := by
  have bound : CertificateM0Environment.Pinned FftGlobalMemory.environment
      (reference SelectedFullSampler128.bound).heap := by
    rw [C99ArrayReference.bind_heap _ _ _ _ SelectedFullSampler128.binding]
    exact prepared
  exact stable _ _ (KeygenMemoryStability.modular _ _ _ SelectedFullSampler128.initialization)
    (stable _ _ (KeygenMemoryStability.modular _ _ _ SelectedFullSampler128.prologue) bound)

theorem sampled : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (reference NormalizedSamples129.after).heap := by
  apply put _ 11 _ (by decide) (by decide)
  apply put _ 30 _ (by decide) (by decide)
  apply put _ 10 _ (by decide) (by decide)
  apply put _ 30 _ (by decide) (by decide)
  exact sampler_entry

theorem converted : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (reference NormalizedSmall136.after).heap :=
  put _ 31 _ (by decide) (by decide) sampled

theorem fft_entry : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (reference SelectedFftFStart138.initial).heap := by
  have bound : CertificateM0Environment.Pinned FftGlobalMemory.environment
      (reference SelectedFftFStart138.bound).heap := by
    rw [C99ArrayReference.bind_heap _ _ _ _ SelectedFftFStart138.binding]
    exact converted
  exact procedure _ _ _ _ SelectedFftFStart138.initialization
    (procedure _ _ _ _ SelectedFftFStart138.halfSize
      (procedure _ _ _ _ SelectedFftFStart138.size
        (procedure _ _ _ _ SelectedFftFStart138.declaration bound)))

theorem first_pass : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (reference NormalizedFftFirst138.after).heap :=
  procedure _ _ _ _ NormalizedFftFirst138.loop_source fft_entry

theorem middle_entry : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (reference SelectedFftMiddleStart139.groupInit).heap :=
  procedure _ _ _ _ SelectedFftMiddleStart139.groupInit_source
    (procedure _ _ _ _ SelectedFftMiddleStart139.outerEntry_source
      (procedure _ _ _ _ SelectedFftMiddleStart139.setup_source first_pass))

end FT1536.Source3.FftPinned139
