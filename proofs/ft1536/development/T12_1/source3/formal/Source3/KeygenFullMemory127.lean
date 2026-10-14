import Source3.KeygenFullData127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFullMemory127
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99FiniteInit123 (metadata)
open KeygenFullData127

theorem extras_sizes (before : Heap) : (memory (extras before)).size = fun b =>
    if b=2 then 32768 else if b=1 then 16384 else if b=28 then 128 else if b=27 then 88
    else if b=26 then 96 else if b=25 then 80 else if b=24 then 88 else if b=23 then 6264 else (memory before).size b := by
  unfold extras KeygenFftObjects127.heap KeygenFftObjects127.square withVv withLarge3 withSmall3 withLarge2 withSmall2
    withPrimes2 KeygenTableObjects127.table64 KeygenTableObjects127.table32 KeygenPrimeObjects123.heap
  repeat rw [(metadata _ _ _ _ _).1]
  rw [FftTableSources.words_length,FftTableSources.words_length]
  rfl

theorem extras_permissions (before : Heap) : (memory (extras before)).writable = fun b =>
    if b=2 then false else if b=1 then false else if b=28 then false else if b=27 then false
    else if b=26 then false else if b=25 then false else if b=24 then false else if b=23 then false else (memory before).writable b := by
  unfold extras KeygenFftObjects127.heap KeygenFftObjects127.square withVv withLarge3 withSmall3 withLarge2 withSmall2
    withPrimes2 KeygenTableObjects127.table64 KeygenTableObjects127.table32 KeygenPrimeObjects123.heap
  repeat rw [(metadata _ _ _ _ _).2]

theorem extras_frame (before : Heap) (b : Nat) (outside : b∉[2,1,28,27,26,25,24,23]) :
    KeygenMakeObjects.Block (memory before) (memory (extras before)) b := by
  simp at outside
  rcases outside with ⟨h2,h1,h28,h27,h26,h25,h24,h23⟩
  refine ⟨?_,?_,?_⟩
  · rw [extras_sizes]
    simp [h2,h1,h28,h27,h26,h25,h24,h23]
  · rw [extras_permissions]
    simp [h2,h1,h28,h27,h26,h25,h24,h23]
  · intro offset
    unfold extras KeygenFftObjects127.heap KeygenFftObjects127.square withVv withLarge3 withSmall3 withLarge2 withSmall2
      withPrimes2 KeygenTableObjects127.table64 KeygenTableObjects127.table32 KeygenPrimeObjects123.heap C99FiniteInit123.install
    simp only [C99FiniteMemory114.bytes_putBlock,h2,h1,h28,h27,h26,h25,h24,h23,ite_false]

theorem primary_sizes (before : Heap) : (memory (primary before)).size = fun b =>
    if b=22 then 2048 else if b=21 then 13212 else if b=20 then 192 else (memory before).size b := by
  unfold primary KeygenRevObject123.heap withPrimes3 KeygenPrimeObjects123.heap withRC KeygenTableObjects127.table64
  repeat rw [(metadata _ _ _ _ _).1]
  rfl

theorem primary_permissions (before : Heap) : (memory (primary before)).writable = fun b =>
    if b=22 then false else if b=21 then false else if b=20 then false else (memory before).writable b := by
  unfold primary KeygenRevObject123.heap withPrimes3 KeygenPrimeObjects123.heap withRC KeygenTableObjects127.table64
  repeat rw [(metadata _ _ _ _ _).2]

theorem primary_frame (before : Heap) (b : Nat) (outside : b∉[22,21,20]) :
    KeygenMakeObjects.Block (memory before) (memory (primary before)) b := by
  simp at outside
  rcases outside with ⟨h22,h21,h20⟩
  refine ⟨?_,?_,?_⟩
  · rw [primary_sizes]
    simp [h22,h21,h20]
  · rw [primary_permissions]
    simp [h22,h21,h20]
  · intro offset
    unfold primary KeygenRevObject123.heap withPrimes3 KeygenPrimeObjects123.heap withRC KeygenTableObjects127.table64 C99FiniteInit123.install
    simp only [C99FiniteMemory114.bytes_putBlock,h22,h21,h20,ite_false]

theorem external_frame (b : Nat) (outside : b∉[2,1,28,27,26,25,24,23,22,21,20]) :
    KeygenMakeObjects.Block (memory externals) (memory heap) b := by
  have e : b∉[2,1,28,27,26,25,24,23] := by simp_all
  have p : b∉[22,21,20] := by simp_all
  exact KeygenMakeObjects.block_trans _ _ _ b (primary_frame externals b p) (extras_frame (primary externals) b e)

end FT1536.Source3.KeygenFullMemory127
