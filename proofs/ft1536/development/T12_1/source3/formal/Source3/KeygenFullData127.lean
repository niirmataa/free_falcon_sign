import Source3.KeygenFftObjects127
import Source3.KeygenGlobalCells127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFullData127
open C99MemoryReference
open C99FiniteMemory114 (Heap putBlock)
open C99FiniteInit123 (install)
open KeygenTableObjects127 (table32 table64 pointer32 pointer64)

def rawEnv : KeygenMakeInvocation.Env where
  args := ⟨⟨30,0,1,448,0⟩,1,⟨3,0,12289,1,0⟩,⟨4,0,1,8,0⟩,⟨5,0,2881,1,0⟩,⟨6,0,1,8,0⟩⟩
  blocks i := 10+i.val
  ctx := ⟨⟨30,0,1,448,0⟩,⟨31,0,71680,4,0⟩,fun _ => 0⟩
  vb := fun _ => 0
def env := KeygenCanonicalAddresses108.canonical rawEnv

def contextBytes (i : Fin 448) : Byte :=
  if first : i.val<4 then byte32 10 ⟨i.val,first⟩
  else if second : i.val<8 then byte32 1 ⟨i.val-4,by omega⟩
  else if third : 432 ≤ i.val ∧ i.val<440 then byte64 (KeygenSearchContext.pointerWord env.ctx) ⟨i.val-432,by omega⟩
  else if fourth : 440 ≤ i.val then byte64 286720 ⟨i.val-440,by omega⟩
  else 0

def buffers : Heap :=
  putBlock (putBlock (putBlock ⟨.empty⟩ 31 ⟨286720,true,some 0,.empty⟩)
    3 ⟨12289,true,some 0,.empty⟩) 5 ⟨2881,true,some 0,.empty⟩
def externals : Heap :=
  install (install (install buffers 30 448 true contextBytes) 4 8 true (byte64 12289)) 6 8 true (byte64 2881)

def withRC (before : Heap) := table64 before 20 ShakeExtractSource.rc
def withPrimes3 (before : Heap) := KeygenPrimeObjects123.heap (withRC before) 21 .ternary
def primary (before : Heap) := KeygenRevObject123.heap (withPrimes3 before) 22
def withPrimes2 (before : Heap) := KeygenPrimeObjects123.heap before 23 .binary
def withSmall2 (before : Heap) := table64 (withPrimes2 before) 24 (KeygenStaticTables.sizes .small2)
def withLarge2 (before : Heap) := table64 (withSmall2 before) 25 (KeygenStaticTables.sizes .large2)
def withSmall3 (before : Heap) := table64 (withLarge2 before) 26 (KeygenStaticTables.sizes .small3)
def withLarge3 (before : Heap) := table64 (withSmall3 before) 27 (KeygenStaticTables.sizes .large3)
def withVv (before : Heap) := table32 (withLarge3 before) 28 KeygenZintExtract.vv
def extras (before : Heap) := KeygenFftObjects127.heap (withVv before)
def heap := extras (primary externals)

def primes := KeygenPrimeObjects123.pointer 21 .ternary
def rev := KeygenRevObject123.pointer 22
def tables : C99CompactState115.Pointers := [
  ("RC".toList,⟨20,0,24,8,0⟩),
  ("PRIMES3".toList,primes),("REV10".toList,rev),
  ("PRIMES2".toList,KeygenPrimeObjects123.pointer 23 .binary),
  ("MAX_BL_SMALL2".toList,pointer64 24 (KeygenStaticTables.sizes .small2)),
  ("MAX_BL_LARGE2".toList,pointer64 25 (KeygenStaticTables.sizes .large2)),
  ("MAX_BL_SMALL3".toList,pointer64 26 (KeygenStaticTables.sizes .small3)),
  ("MAX_BL_LARGE3".toList,pointer64 27 (KeygenStaticTables.sizes .large3)),
  (KeygenZintCall.vvObject,pointer32 28 KeygenZintExtract.vv),
  ("fpr_gm3_square".toList,FftGlobalMemory.pointer .square),
  ("fpr_gm3_cubic".toList,FftGlobalMemory.pointer .cubic)]
def base : C99CompactState115.State := ⟨heap,[],[],KeygenGlobalCells127.globals,tables⟩

theorem scratch_word : KeygenSearchContext.pointerWord env.ctx=55834574848 := by decide +kernel
theorem canonical_representation : KeygenMakeInvocation.VirtualLegal env.live env.vb :=
  KeygenCanonicalAddresses108.legal rawEnv

end FT1536.Source3.KeygenFullData127
