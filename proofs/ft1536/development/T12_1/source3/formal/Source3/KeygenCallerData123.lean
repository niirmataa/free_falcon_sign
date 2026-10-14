import Source3.KeygenPrimeObjects123
import Source3.KeygenRevObject123
import Source3.KeygenWholeStages109
import Source3.C99CompactState115
import Source3.ShakeProcessCompute116

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCallerData123
open C99MemoryReference
open C99FiniteMemory114 (Heap putBlock)
open C99FiniteInit123 (install words64)

def rawEnv : KeygenMakeInvocation.Env where
  args := ⟨⟨1,0,1,448,0⟩,1,⟨3,0,12289,1,0⟩,⟨4,0,1,8,0⟩,⟨5,0,2881,1,0⟩,⟨6,0,1,8,0⟩⟩
  blocks i := 10+i.val
  ctx := ⟨⟨1,0,1,448,0⟩,⟨2,0,71680,4,0⟩,fun _ => 0⟩
  vb := fun _ => 0

/-- Representation is chosen before constructing any stored pointer word. -/
def env := KeygenCanonicalAddresses108.canonical rawEnv

def contextBytes (i : Fin 448) : Byte :=
  if first : i.val<4 then byte32 10 ⟨i.val,first⟩
  else if second : i.val<8 then byte32 1 ⟨i.val-4,by omega⟩
  else if third : 432 ≤ i.val ∧ i.val<440 then byte64 (KeygenSearchContext.pointerWord env.ctx) ⟨i.val-432,by omega⟩
  else if fourth : 440 ≤ i.val then byte64 286720 ⟨i.val-440,by omega⟩
  else 0

def buffers : Heap :=
  putBlock (putBlock (putBlock ⟨.empty⟩ 2 ⟨286720,true,some 0,.empty⟩)
    3 ⟨12289,true,some 0,.empty⟩) 5 ⟨2881,true,some 0,.empty⟩

def externals : Heap :=
  install (install (install buffers 1 448 true contextBytes) 4 8 true (byte64 12289)) 6 8 true (byte64 2881)

def withPrimes := KeygenPrimeObjects123.heap externals 21 .ternary
def withRev := KeygenRevObject123.heap withPrimes 22
def rcWords (i : Fin 24) : BitVec 64 := ShakeExtractSource.rc[i.val]!
def heap := install withRev 20 (8*24) false (words64 rcWords)
def primes := KeygenPrimeObjects123.pointer 21 .ternary
def rev := KeygenRevObject123.pointer 22
def rcPointer : ArrayPointer := ⟨20,0,24,8,0⟩
def tables : C99CompactState115.Pointers :=
  [("RC".toList,rcPointer),("PRIMES3".toList,primes),("REV10".toList,rev)]
def base : C99CompactState115.State := ⟨heap,[],[],[],tables⟩

theorem scratch_word : KeygenSearchContext.pointerWord env.ctx=55834574848 := by decide +kernel

theorem tables_cases (name : C99ArrayReference.Name) (p : ArrayPointer)
    (binding : C99NameMap115.lookup tables name=some p) : p=rcPointer ∨ p=primes ∨ p=rev := by
  simp only [tables,C99NameMap115.lookup] at binding
  split at binding
  · exact Or.inl (Option.some.inj binding).symm
  · split at binding
    · exact Or.inr (Or.inl (Option.some.inj binding).symm)
    · split at binding
      · exact Or.inr (Or.inr (Option.some.inj binding).symm)
      · cases binding

end FT1536.Source3.KeygenCallerData123
