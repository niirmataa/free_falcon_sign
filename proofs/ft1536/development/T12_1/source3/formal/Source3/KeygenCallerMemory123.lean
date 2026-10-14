import Source3.KeygenCallerData123

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCallerMemory123
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99FiniteInit123 (metadata outside words32 words64)
open KeygenCallerData123

theorem sizes : (memory heap).size = fun block =>
    if block=20 then 192 else if block=22 then 2048 else if block=21 then 13212 else (memory externals).size block := by
  unfold heap withRev KeygenRevObject123.heap withPrimes KeygenPrimeObjects123.heap
  rw [(metadata _ _ _ _ _).1,(metadata _ _ _ _ _).1,(metadata _ _ _ _ _).1]
  rfl

theorem permissions : (memory heap).writable = fun block =>
    if block=20 then false else if block=22 then false else if block=21 then false else (memory externals).writable block := by
  unfold heap withRev KeygenRevObject123.heap withPrimes KeygenPrimeObjects123.heap
  rw [(metadata _ _ _ _ _).2,(metadata _ _ _ _ _).2,(metadata _ _ _ _ _).2]

theorem external_block (block : Nat) (noRC : block≠20) (noRev : block≠22) (noPrimes : block≠21) :
    KeygenMakeObjects.Block (memory externals) (memory heap) block := by
  have first := outside externals 21 (4*(3*KeygenStaticTables.rowCount .ternary)) false
    (words32 (KeygenPrimeObjects123.words .ternary)) block noPrimes
  have second := outside withPrimes 22 (2*1024) false
    (C99FiniteWords123.words16 KeygenRevObject123.words) block noRev
  have third := outside withRev 20 (8*24) false (words64 rcWords) block noRC
  exact ⟨third.1.trans (second.1.trans first.1),third.2.1.trans (second.2.1.trans first.2.1),
    fun offset => (third.2.2 offset).trans ((second.2.2 offset).trans (first.2.2 offset))⟩

theorem primes_object : KeygenStaticTables.PrimeObject (memory heap) primes .ternary := by
  have second := outside withPrimes 22 (2*1024) false
    (C99FiniteWords123.words16 KeygenRevObject123.words) 21 (by decide)
  have third := outside withRev 20 (8*24) false (words64 rcWords) 21 (by decide)
  exact KeygenMakeEntry.prime_block _ _ primes third
    (KeygenMakeEntry.prime_block _ _ primes second (KeygenPrimeObjects123.object externals 21 .ternary))

theorem rev_object : KeygenMkgm3RevMemory.SourceTable (memory heap) rev :=
  KeygenMakeEntry.rev_block _ _ rev (outside withRev 20 (8*24) false (words64 rcWords) 22 (by decide))
    (KeygenRevObject123.object withPrimes 22)

theorem rc_object : ShakeExtractSource.StaticRC (memory heap) rcPointer := by
  refine ⟨?_,rfl,?_⟩
  · rw [permissions]
    decide
  · intro i
    have loaded := C99FiniteWords123.load64 withRev 20 24 false rcWords (by decide) i
    refine C99LoadLayout123.load64 _ _ _ _ loaded ?_ rfl rfl ?_
    · change 0<8 ∧ 0%8=0 ∧ 0+i.val<24 ∧ 0+8*24≤(memory heap).size 20 ∧ (memory heap).size 20<2^64
      rw [sizes]
      simp only [ite_true]
      exact ⟨by decide,by decide,by have := i.isLt; omega,by decide,by decide⟩
    · simp [KeygenSmallOutput.element,rcPointer,ArrayPointer.offset]

end FT1536.Source3.KeygenCallerMemory123
