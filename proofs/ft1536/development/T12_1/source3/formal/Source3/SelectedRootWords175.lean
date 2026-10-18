import Source3.SelectedRootStart175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedRootWords175
open C99CompactState115 (reference)
open KeygenFullData127 (env)
open SelectedRootEntry175 (inputs)
open SelectedRootContext175 (old)
open SelectedPublicSuccess174 (after)

theorem norm_protected (slot : Fin 4) :
    KeygenAttemptNorm133.Protected env.ctx (reference old) (inputs slot).block := by
  apply NormProtected158.source env.ctx old (inputs slot).block
  · fin_cases slot <;> decide
  · fin_cases slot <;> decide +kernel
  · fin_cases slot <;> decide +kernel

theorem table_frame : SelectedPublicBinding157.before.tables=SelectedAttemptPrefix156.prepared.tables :=
  (KeygenCallerPrefix134.ternary_slots env.ctx SelectedAttemptPrefix156.prepared
    ⟨SelectedGsNorm155.after,.normal⟩ SelectedAttemptPrefix156.ternary).2

theorem tables (slot : Fin 4) : KeygenPublicFrame.Tables SelectedPublicBinding157.before (inputs slot).block := by
  intro name p binding
  rw [table_frame] at binding
  exact SelectedRootEntry175.prepared_initial.inputTables slot name p binding

theorem outside (slot : Fin 4) :
    KeygenPublicFrame.Outside SelectedPublicBinding157.before ["h".toList] (inputs slot).block := by
  intro name member p binding
  have equal := List.mem_singleton.mp member
  subst name
  have pointer := Option.some.inj (binding.symm.trans SelectedPublicBinding157.h_binding)
  subst p
  fin_cases slot <;> decide

theorem live (slot : Fin 4) : 0<SelectedPublicBinding157.before.heap.size (inputs slot).block := by
  rw [SelectedPublicMemory157.stable.size]
  fin_cases slot <;> decide +kernel

theorem public_block (slot : Fin 4) :
    ShakeExtractFrame.SameBlock SelectedPublicBinding157.before.heap after.heap (inputs slot).block :=
  KeygenPublicSource.frame _ _ (.int32 1) SelectedPublicSuccess174.source (inputs slot).block
    (outside slot) (tables slot) (live slot)

theorem block (slot : Fin 4) : KeygenMakeObjects.Block (reference old).heap after.heap (inputs slot).block := by
  refine ⟨(congrFun (public_block slot).1 _).trans (congrFun SelectedPublicMemory157.stable.size _),
    (congrFun (public_block slot).2.1 _).trans (congrFun SelectedPublicMemory157.stable.writable _),?_⟩
  intro offset
  exact ((public_block slot).2.2 offset).trans
    (KeygenAttemptNorm133.bytes env.ctx (reference old) ⟨SelectedGsNorm155.after,.normal⟩
      SelectedGsGate156.norm_prefix (inputs slot).block (norm_protected slot) offset)

theorem f_words : Word16Memory158.Represents after.heap (inputs 0) SelectedSamplerWords158.fValues := by
  intro i
  exact KeygenMakeEntry.load16_block _ _ _ _ (block 0) (SelectedSamplerWords158.f_image i)

theorem g_words : Word16Memory158.Represents after.heap (inputs 1) SelectedSamplerWords158.gValues := by
  intro i
  exact KeygenMakeEntry.load16_block _ _ _ _ (block 1) (SelectedSamplerWords158.g_image i)

end FT1536.Source3.SelectedRootWords175
