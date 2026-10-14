import Source3.KeygenFullFacts127
import Source3.KeygenCallerBuffers123

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFullDomain127
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99CompactState115 (reference)
open KeygenFullData127
open KeygenFullMemory127
open KeygenFullFacts127

theorem primes_object : KeygenStaticTables.PrimeObject (memory heap) primes .ternary := by
  have revFrame := C99FiniteInit123.outside (withPrimes3 externals) 22 (2*1024) false
    (C99FiniteWords123.words16 KeygenRevObject123.words) 21 (by decide)
  exact KeygenMakeEntry.prime_block _ _ primes (extras_frame (primary externals) 21 (by decide))
    (KeygenMakeEntry.prime_block _ _ primes revFrame (KeygenPrimeObjects123.object (withRC externals) 21 .ternary))

theorem rev_object : KeygenMkgm3RevMemory.SourceTable (memory heap) rev :=
  KeygenMakeEntry.rev_block _ _ rev (extras_frame (primary externals) 22 (by decide))
    (KeygenRevObject123.object (withPrimes3 externals) 22)

theorem profile : KeygenSearchContext.M0 (reference base).heap env.ctx := by
  have same := external_frame 30 (by decide)
  exact ⟨KeygenMakeEntry.load32_block _ _ _ _ same
      (C99FiniteRead114.read32_sound externals (KeygenSearchContext.field env.ctx 0 4) 10 (by decide +kernel)),
    KeygenMakeEntry.load32_block _ _ _ _ same
      (C99FiniteRead114.read32_sound externals (KeygenSearchContext.field env.ctx 4 4) 1 (by decide +kernel))⟩

theorem object_legal : KeygenSearchContext.ObjectLegal (reference base).heap env.ctx := by
  change 0%8=0 ∧ 0+448≤(memory heap).size 30 ∧ (memory heap).size 30<2^64
  rw [sizes,external_sizes]
  decide

theorem scratch_legal : KeygenMkgm3Layout.Legal (reference base).heap env.ctx.scratch := by
  change 4=4 ∧ 0%4=0 ∧ 0+7168≤71680 ∧ 0+4*71680≤(memory heap).size 31 ∧
    (memory heap).size 31<2^64 ∧ (memory heap).writable 31=true
  rw [sizes,permissions,external_sizes,external_permissions]
  decide

theorem original : KeygenMakeEntry.Original env.ctx (KeygenMakeArguments.entry (reference base) env.args) primes rev := by
  refine ⟨rfl,object_legal,profile,rfl,primes_object,rfl,rev_object,scratch_legal,by decide,?_,?_⟩
  · intro name p binding
    exact (tables_separate name p binding).1
  · exact tables_live

theorem root_legal : KeygenMakeAssembly080.LegalEntry env (reference base) primes rev := by
  refine ⟨original,by decide,by decide,?_⟩
  change C99Automatic32.align4 ((memory heap).size 31)+4<2^64
  rw [sizes,external_sizes]
  decide

theorem buffers_legal : KeygenOutputMemory081.Legal env (reference base) := by
  refine ⟨?_,?_,?_,?_,by decide,by decide,by decide,by decide,by decide,by decide⟩
  · change 0<(memory heap).size 3
    rw [sizes,external_sizes]
    decide
  · change 0<(memory heap).size 4
    rw [sizes,external_sizes]
    decide
  · change 0<(memory heap).size 5
    rw [sizes,external_sizes]
    decide
  · change 0<(memory heap).size 6
    rw [sizes,external_sizes]
    decide

theorem public_capacity : Load64 (reference base).heap env.args.pubkeyLen 2881 :=
  KeygenCallerShape123.load64_block _ _ _ _ (external_frame 6 (by decide))
    (C99FiniteRead114.read64_sound externals env.args.pubkeyLen 2881 (by decide +kernel))

theorem public_writable : KeygenPublicEncodeReady077.WritableBytes (reference base).heap env.args.pubkey 2881 := by
  apply KeygenCallerBuffers123.writable_span
  · change (memory heap).size 5=2881
    rw [sizes,external_sizes]
    decide
  · change (memory heap).writable 5=true
    rw [permissions,external_permissions]
    decide
  · decide

theorem public_tail_writable : KeygenPublicEncodeReady077.WritableBytes (reference base).heap
    (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880 := by
  refine ⟨public_writable.1,?_⟩
  intro i bound
  have h := public_writable.2 (1+i) (by omega)
  simpa [KeygenPublicEncodeExecution077.byteOff,KeygenCodecExecution.byteOff,ArrayPointer.offset,
    env,rawEnv,KeygenCanonicalAddresses108.canonical] using h

theorem public_legal : KeygenPublicEntry082.Legal env (reference base) 2881 := by
  refine ⟨public_capacity,by decide,public_tail_writable,by decide,by decide,?_⟩
  intro name p binding
  exact (tables_separate name p binding).2

def domain : KeygenWholeBytes088.Domain env (reference base) :=
  ⟨primes,rev,root_legal,buffers_legal,rfl,2881,public_legal⟩

theorem seed_fresh : (reference base).heap.size 0=0 := by
  change (memory heap).size 0=0
  rw [sizes,external_sizes]
  decide

def input : KeygenWholeStages109.Input rawEnv := ⟨reference base,domain,0,seed_fresh⟩

end FT1536.Source3.KeygenFullDomain127
