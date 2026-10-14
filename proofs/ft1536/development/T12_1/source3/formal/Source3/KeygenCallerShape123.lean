import Source3.KeygenCallerMemory123

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCallerShape123
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99FiniteInit123 (metadata)
open KeygenCallerData123
open KeygenCallerMemory123
open C99CompactState115 (reference)

theorem external_sizes : (memory externals).size = fun block =>
    if block=6 then 8 else if block=4 then 8 else if block=1 then 448
    else if block=5 then 2881 else if block=3 then 12289 else if block=2 then 286720 else 0 := by
  unfold externals
  rw [(metadata _ _ _ _ _).1,(metadata _ _ _ _ _).1,(metadata _ _ _ _ _).1]
  funext block
  simp only [buffers,C99FiniteMemory114.size_putBlock]
  simp [memory,C99FiniteAllocation115.lookup_empty]

theorem external_permissions : (memory externals).writable = fun block =>
    if block=6 then true else if block=4 then true else if block=1 then true
    else if block=5 then true else if block=3 then true else if block=2 then true else false := by
  unfold externals
  rw [(metadata _ _ _ _ _).2,(metadata _ _ _ _ _).2,(metadata _ _ _ _ _).2]
  funext block
  simp only [buffers,C99FiniteMemory114.writable_putBlock]
  simp [memory,C99FiniteAllocation115.lookup_empty]

theorem profile : KeygenSearchContext.M0 (reference base).heap env.ctx := by
  have same := external_block 1 (by decide) (by decide) (by decide)
  constructor
  · exact KeygenMakeEntry.load32_block _ _ _ _ same
      (C99FiniteRead114.read32_sound externals (KeygenSearchContext.field env.ctx 0 4) 10 (by decide +kernel))
  · exact KeygenMakeEntry.load32_block _ _ _ _ same
      (C99FiniteRead114.read32_sound externals (KeygenSearchContext.field env.ctx 4 4) 1 (by decide +kernel))

theorem object_legal : KeygenSearchContext.ObjectLegal (reference base).heap env.ctx := by
  change 0%8=0 ∧ 0+448≤(memory heap).size 1 ∧ (memory heap).size 1<2^64
  rw [sizes,external_sizes]
  decide

theorem scratch_legal : KeygenMkgm3Layout.Legal (reference base).heap env.ctx.scratch := by
  change 4=4 ∧ 0%4=0 ∧ 0+7168≤71680 ∧ 0+4*71680≤(memory heap).size 2 ∧
    (memory heap).size 2<2^64 ∧ (memory heap).writable 2=true
  rw [sizes,permissions,external_sizes,external_permissions]
  decide

theorem load64_block (before after : Memory) (pointer : ArrayPointer) (word : BitVec 64)
    (same : KeygenMakeObjects.Block before after pointer.block) (source : Load64 before pointer word) :
    Load64 after pointer word := by
  cases source with
  | load bytes allocated width initialized =>
      exact .load _ _ bytes (KeygenMakeEntry.allocated_block _ _ _ same allocated) width
        (fun i => (same.2.2 _).trans (initialized i))

theorem public_capacity : Load64 (reference base).heap env.args.pubkeyLen 2881 :=
  load64_block _ _ env.args.pubkeyLen 2881 (external_block 6 (by decide) (by decide) (by decide))
    (C99FiniteRead114.read64_sound externals env.args.pubkeyLen 2881 (by decide +kernel))

theorem public_writable : KeygenPublicEncodeReady077.WritableBytes (reference base).heap
    (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880 := by
  constructor
  · change (memory heap).writable 5=true
    rw [permissions,external_permissions]
    decide
  · intro i bound
    change 0<1 ∧ 0%1=0 ∧ 0+1+i<2881 ∧ 0+1*2881≤(memory heap).size 5 ∧ (memory heap).size 5<2^64
    rw [sizes,external_sizes]
    simp only [show (5:Nat)≠20 from by decide,show (5:Nat)≠22 from by decide,
      show (5:Nat)≠21 from by decide,show (5:Nat)≠6 from by decide,show (5:Nat)≠4 from by decide,
      show (5:Nat)≠1 from by decide,ite_false,ite_true]
    exact ⟨by decide,by decide,by omega,by decide,by decide⟩

theorem seed_fresh : (reference base).heap.size 0=0 := by
  change (memory heap).size 0=0
  rw [sizes,external_sizes]
  decide

end FT1536.Source3.KeygenCallerShape123
