import Source3.RootEntryTransport175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedRootEntry175
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenFullData127 (env primes rev)
open SelectedAttemptPrefix156 (saved prepared)

def inputs : Fin 4 → ArrayPointer := KeygenMakeEntry.input env.blocks
def h : ArrayPointer := SelectedPublicBinding157.h

theorem initial : KeygenCallerEntry.Initial env.ctx saved inputs h primes rev :=
  SelectedFullStart127.entry_facts.2.1

theorem size : C99CountedWords.Limit saved := by
  unfold C99CountedWords.Limit
  decide +kernel

theorem prepared_eq : prepared=KeygenMakeSampling.prepared env.ctx (KeygenCapWords.advanced saved 0) := by
  have cases := KeygenMakeSampling.cap_before_setup env.ctx saved 0 ⟨prepared,.normal⟩
    (by decide) SelectedFullStart127.entry_facts.1 size SelectedFullSampler128.capped
  rcases cases with exhausted | running
  · have positive : 0<KeygenAttemptCap.limit := by decide
    have bad := exhausted.1
    omega
  · exact congrArg C99ProcedureReference.Result.state running.2.1

theorem prepared_initial : KeygenCallerEntry.Initial env.ctx prepared inputs h primes rev := by
  rw [prepared_eq]
  exact KeygenMakeSampling.prepared_initial env.ctx saved 0 inputs h primes rev initial

theorem material_entry : KeygenAttemptMaterial.Entry env.ctx prepared (inputs 0) (inputs 1) := by
  rw [prepared_eq]
  exact KeygenMakeSampling.entry_from_prepared env.ctx saved 0 inputs h primes rev initial size

theorem prepared_legal : KeygenRootCaller.Legal env.ctx prepared inputs primes rev :=
  RootEntryTransport175.legal env.ctx prepared inputs h primes rev prepared_initial

theorem context_protected : KeygenAttemptNorm.Protected env.ctx prepared env.ctx.object.block := by
  rw [prepared_eq]
  exact RootEntryTransport175.context_prepared env.ctx saved 0 inputs h primes rev initial

theorem norm_legal : KeygenRootCaller.Legal env.ctx SelectedGsNorm155.after inputs primes rev :=
  KeygenCallerPrefix134.ternary_root env.ctx prepared ⟨SelectedGsNorm155.after,.normal⟩ inputs primes rev
    material_entry prepared_legal (prepared_initial.staticLive _ primes prepared_initial.table)
    (prepared_initial.staticLive _ rev prepared_initial.revBinding) context_protected SelectedAttemptPrefix156.ternary

theorem before_public : KeygenRootCaller.Legal env.ctx SelectedPublicBinding157.before inputs primes rev :=
  KeygenCallerPrefix.close_root env.ctx saved SelectedGsNorm155.after inputs primes rev norm_legal

theorem public_outside : KeygenPublicFrame.Outside SelectedPublicBinding157.before ["h".toList] env.ctx.object.block := by
  intro name member p binding
  have equal := List.mem_singleton.mp member
  subst name
  have pointer := Option.some.inj (binding.symm.trans SelectedPublicBinding157.h_binding)
  subst p
  decide

theorem source : KeygenRootCaller.Legal env.ctx SelectedPublicSuccess174.after inputs primes rev :=
  KeygenCallerTransport.public_root env.ctx SelectedPublicBinding157.before SelectedPublicSuccess174.after
    (.int32 1) inputs primes rev before_public public_outside SelectedPublicSuccess174.source

end FT1536.Source3.SelectedRootEntry175
