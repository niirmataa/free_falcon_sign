import Source3.KeygenFullMemory127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFullFacts127
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99FiniteInit123 (metadata)
open C99CompactState115 (reference)
open KeygenFullData127
open KeygenFullMemory127

theorem sizes : (memory heap).size = fun b =>
    if b=2 then 32768 else if b=1 then 16384 else if b=28 then 128 else if b=27 then 88
    else if b=26 then 96 else if b=25 then 80 else if b=24 then 88 else if b=23 then 6264
    else if b=22 then 2048 else if b=21 then 13212 else if b=20 then 192 else (memory externals).size b := by
  unfold heap
  rw [extras_sizes,primary_sizes]

theorem permissions : (memory heap).writable = fun b =>
    if b=2 then false else if b=1 then false else if b=28 then false else if b=27 then false
    else if b=26 then false else if b=25 then false else if b=24 then false else if b=23 then false
    else if b=22 then false else if b=21 then false else if b=20 then false else (memory externals).writable b := by
  unfold heap
  rw [extras_permissions,primary_permissions]

theorem external_sizes : (memory externals).size = fun b =>
    if b=6 then 8 else if b=4 then 8 else if b=30 then 448
    else if b=5 then 2881 else if b=3 then 12289 else if b=31 then 286720 else 0 := by
  unfold externals
  rw [(metadata _ _ _ _ _).1,(metadata _ _ _ _ _).1,(metadata _ _ _ _ _).1]
  funext b
  simp only [buffers,C99FiniteMemory114.size_putBlock]
  simp [memory,C99FiniteAllocation115.lookup_empty]

theorem external_permissions : (memory externals).writable = fun b =>
    if b=6 then true else if b=4 then true else if b=30 then true
    else if b=5 then true else if b=3 then true else if b=31 then true else false := by
  unfold externals
  rw [(metadata _ _ _ _ _).2,(metadata _ _ _ _ _).2,(metadata _ _ _ _ _).2]
  funext b
  simp only [buffers,C99FiniteMemory114.writable_putBlock]
  simp [memory,C99FiniteAllocation115.lookup_empty]

theorem lookup_mem (items : C99NameMap115.Table α) (name : C99ArrayReference.Name) (value : α)
    (binding : C99NameMap115.lookup items name=some value) : (name,value)∈items := by
  induction items with
  | nil => cases binding
  | cons head tail ih =>
      rcases head with ⟨key,entry⟩
      unfold C99NameMap115.lookup at binding
      split at binding
      next same =>
        subst name
        have equal := Option.some.inj binding
        subst value
        exact List.mem_cons_self
      next different => exact List.mem_cons_of_mem _ (ih binding)

theorem table_blocks (name : C99ArrayReference.Name) (p : ArrayPointer)
    (binding : (reference base).tables name=some p) : p.block∈[20,21,22,23,24,25,26,27,28,1,2] := by
  have member := lookup_mem tables name p binding
  have mapped : p.block∈tables.map (fun item => item.2.block) := List.mem_map.mpr ⟨(name,p),member,rfl⟩
  simpa only [tables,List.map_cons,List.map_nil,primes,rev,KeygenPrimeObjects123.pointer,KeygenRevObject123.pointer,
    KeygenTableObjects127.pointer32,KeygenTableObjects127.pointer64,FftGlobalMemory.pointer,FftGlobalMemory.block] using mapped

theorem tables_separate (name : C99ArrayReference.Name) (p : ArrayPointer)
    (binding : (reference base).tables name=some p) : p.block≠30 ∧ p.block≠6 := by
  have member := table_blocks name p binding
  simp at member
  omega

theorem tables_live (name : C99ArrayReference.Name) (p : ArrayPointer)
    (binding : (reference base).tables name=some p) : 0<(reference base).heap.size p.block := by
  have member := table_blocks name p binding
  simp at member
  change 0<(memory heap).size p.block
  rw [sizes]
  rcases member with h | h | h | h | h | h | h | h | h | h | h
  all_goals simp [h]

theorem fft_pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment (memory heap) :=
  KeygenFftObjects127.pinned (withVv (primary externals))

theorem certificate_pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (KeygenMakeWorkspaceRelocation.swap env.ctx.scratch.block (memory heap)) :=
  KeygenFftObjects127.pinned_swap (memory heap) 31 (by decide) (by decide) fft_pinned

theorem globals_source : (reference base).globals=FftGlobalScalars.environment := KeygenGlobalCells127.source

end FT1536.Source3.KeygenFullFacts127
