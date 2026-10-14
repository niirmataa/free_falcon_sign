import Source3.KeygenFullDomain127
import Source3.KeygenSizeObjects127
import Source3.KeygenStaticFrames127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFullStatics127
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99CompactState115 (reference)
open KeygenFullData127
open KeygenTableObjects127 (pointer32 pointer64)

theorem size_block (before after : Memory) (p : ArrayPointer) (table : KeygenStaticTables.SizeTable)
    (same : KeygenMakeObjects.Block before after p.block) (source : KeygenStaticTables.SizeObject before p table) :
    KeygenStaticTables.SizeObject after p table := by
  rcases source with ⟨width,index,count,readonly,extent,fits,reads⟩
  refine ⟨width,index,count,?_,?_,?_,?_⟩
  · rw [same.2.1]
    exact readonly
  · rw [same.1]
    exact extent
  · rw [same.1]
    exact fits
  · intro i value member
    exact KeygenCallerShape123.load64_block _ _ _ _ same (reads i value member)

theorem static32_block (before after : Memory) (p : ArrayPointer) (values : List (BitVec 32))
    (same : KeygenMakeObjects.Block before after p.block) (source : KeygenZintCall.Static32 before p values) :
    KeygenZintCall.Static32 after p values := by
  rcases source with ⟨readonly,zeroBase,zeroIndex,width,count,size,reads⟩
  refine ⟨?_,zeroBase,zeroIndex,width,count,?_,?_⟩
  · rw [same.2.1]
    exact readonly
  · rw [same.1]
    exact size
  · intro i
    exact KeygenMakeEntry.load32_block _ _ _ _ same (reads i)

theorem prime_block (before after : Memory) (p : ArrayPointer) (table : KeygenStaticTables.PrimeTable)
    (same : KeygenMakeObjects.Block before after p.block) (source : KeygenStaticTables.PrimeObject before p table) :
    KeygenStaticTables.PrimeObject after p table := by
  rcases source with ⟨width,index,count,readonly,extent,fits,reads⟩
  refine ⟨width,index,count,?_,?_,?_,?_⟩
  · rw [same.2.1]
    exact readonly
  · rw [same.1]
    exact extent
  · rw [same.1]
    exact fits
  · intro i value member field
    exact KeygenMakeEntry.load32_block _ _ _ _ same (reads i value member field)

theorem primes2_object : KeygenStaticTables.PrimeObject (memory heap) (KeygenPrimeObjects123.pointer 23 .binary) .binary :=
  prime_block _ _ (KeygenPrimeObjects123.pointer 23 .binary) .binary KeygenStaticFrames127.primes2
    (KeygenPrimeObjects123.object (primary externals) 23 .binary)

def sizeBlock : KeygenStaticTables.SizeTable → Nat
  | .small2 => 24 | .large2 => 25 | .small3 => 26 | .large3 => 27

theorem size_object (table : KeygenStaticTables.SizeTable) :
    KeygenStaticTables.SizeObject (memory heap) (pointer64 (sizeBlock table) (KeygenStaticTables.sizes table)) table := by
  cases table with
  | small2 =>
      exact size_block _ _ (pointer64 24 (KeygenStaticTables.sizes .small2)) .small2 KeygenStaticFrames127.small2
        (KeygenSizeObjects127.object (withPrimes2 (primary externals)) 24 .small2)
  | large2 =>
      exact size_block _ _ (pointer64 25 (KeygenStaticTables.sizes .large2)) .large2 KeygenStaticFrames127.large2
        (KeygenSizeObjects127.object (withSmall2 (primary externals)) 25 .large2)
  | small3 =>
      exact size_block _ _ (pointer64 26 (KeygenStaticTables.sizes .small3)) .small3 KeygenStaticFrames127.small3
        (KeygenSizeObjects127.object (withLarge2 (primary externals)) 26 .small3)
  | large3 =>
      exact size_block _ _ (pointer64 27 (KeygenStaticTables.sizes .large3)) .large3 KeygenStaticFrames127.large3
        (KeygenSizeObjects127.object (withSmall3 (primary externals)) 27 .large3)

theorem vv_object : KeygenZintCall.Static32 (memory heap) (pointer32 28 KeygenZintExtract.vv) KeygenZintExtract.vv :=
  static32_block _ _ (pointer32 28 KeygenZintExtract.vv) KeygenZintExtract.vv KeygenStaticFrames127.vv
    (KeygenTableObjects127.static32 (withLarge3 (primary externals)) 28 KeygenZintExtract.vv (by decide +kernel))

theorem environment : KeygenStaticTables.Environment (reference base) := by
  refine ⟨?_,?_,?_⟩
  · intro table
    cases table with
    | binary => exact ⟨KeygenPrimeObjects123.pointer 23 .binary,rfl,primes2_object⟩
    | ternary => exact ⟨primes,rfl,KeygenFullDomain127.primes_object⟩
  · intro table
    refine ⟨pointer64 (sizeBlock table) (KeygenStaticTables.sizes table),?_,size_object table⟩
    cases table <;> rfl
  · exact ⟨pointer32 28 KeygenZintExtract.vv,rfl,vv_object⟩

end FT1536.Source3.KeygenFullStatics127
