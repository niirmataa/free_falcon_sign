import Source3.FftLoadShape140
import Source3.FftPairClosed140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoadStates140
open C99ArrayReference (State Name)
open FftMulStates140 (Words)
open FftLoadShape140 (names name index)
open FftLocalCells140 (put)

def declared (before : State) : State := C99DeclarationStatements.effect .u64 names before
def s1 (before : State) (x : Words) : State := put (declared before) "a0r".toList x.ar
def s2 (before : State) (x : Words) : State := put (s1 before x) "a0i".toList x.ai
def s3 (before : State) (x : Words) : State := put (s2 before x) "a1r".toList x.br
def s4 (before : State) (x : Words) : State := put (s3 before x) "a1i".toList x.bi

def state (before : State) (x : Words) : Fin 5 → State
  | ⟨0,_⟩ => declared before | ⟨1,_⟩ => s1 before x | ⟨2,_⟩ => s2 before x
  | ⟨3,_⟩ => s3 before x | ⟨4,_⟩ => s4 before x

def value (x : Words) : Fin 4 → BitVec 64
  | ⟨0,_⟩ => x.ar | ⟨1,_⟩ => x.ai | ⟨2,_⟩ => x.br | ⟨3,_⟩ => x.bi

theorem name_member (i : Fin 4) : name i∈names := by fin_cases i <;> decide

theorem name_different (n : Name) (absent : n∉names) (i : Fin 4) : n≠name i :=
  fun same => absent (same ▸ name_member i)

theorem locals_outside (before : State) (x : Words) (stage : Fin 5) (n : Name) (absent : n∉names) :
    (state before x stage).locals n=before.locals n := by
  have h0 := C99DeclareOutside140.source .uint64 names before.locals n absent
  have h1 := (FftLocalCells140.outside (declared before) "a0r".toList n x.ar (name_different n absent 0)).trans h0
  have h2 := (FftLocalCells140.outside (s1 before x) "a0i".toList n x.ai (name_different n absent 1)).trans h1
  have h3 := (FftLocalCells140.outside (s2 before x) "a1r".toList n x.br (name_different n absent 2)).trans h2
  have h4 := (FftLocalCells140.outside (s3 before x) "a1i".toList n x.bi (name_different n absent 3)).trans h3
  fin_cases stage
  · exact h0
  · exact h1
  · exact h2
  · exact h3
  · exact h4

theorem heap_same (before : State) (x : Words) (stage : Fin 5) :
    (state before x stage).heap=before.heap := by fin_cases stage <;> rfl

theorem arrays_same (before : State) (x : Words) (stage : Fin 5) :
    (state before x stage).arrays=before.arrays := by fin_cases stage <;> rfl

theorem address (before : State) (x : Words) (stage : Fin 5) (slot : Fin 4)
    (pointer : C99MemoryReference.ArrayPointer)
    (source : C99ArrayReference.Pointer before "a".toList (index slot) pointer) :
    C99ArrayReference.Pointer (state before x stage) "a".toList (index slot) pointer := by
  apply FftPointerTransport140.source before (state before x stage) _ _ pointer source
    (congrFun (arrays_same before x stage) "a".toList)
  intro n member
  rw [FftLoadShape140.read_names] at member
  exact (locals_outside before x stage n (FftLoadShape140.index_outside slot n member)).symm

end FT1536.Source3.FftLoadStates140
