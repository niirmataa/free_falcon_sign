import Source3.GsInvNormShape154
import Source3.C99ScopeFrame147
import Source3.C99DeclareOutside140
import Source3.FftPointerTransport140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsInvNormStates154
open C99ArrayReference (State Name Pointer)
open FftMulStates140 (Words)
open GsInvNormShape154 (names name buffer index)
open FftLocalCells140 (put)

def declaredA (s : State) : State := C99DeclarationStatements.effect .u64 [name 0,name 1] s
def declared (s : State) : State := C99DeclarationStatements.effect .u64 [name 2,name 3] (declaredA s)
def s1 (s : State) (x : Words) : State := put (declared s) (name 0) x.ar
def s2 (s : State) (x : Words) : State := put (s1 s x) (name 1) x.ai
def s3 (s : State) (x : Words) : State := put (s2 s x) (name 2) x.br
def s4 (s : State) (x : Words) : State := put (s3 s x) (name 3) x.bi

def state (s : State) (x : Words) : Fin 5 → State
  | ⟨0,_⟩ => declared s | ⟨1,_⟩ => s1 s x | ⟨2,_⟩ => s2 s x
  | ⟨3,_⟩ => s3 s x | ⟨4,_⟩ => s4 s x

def value (x : Words) : Fin 4 → BitVec 64
  | ⟨0,_⟩ => x.ar | ⟨1,_⟩ => x.ai | ⟨2,_⟩ => x.br | ⟨3,_⟩ => x.bi

theorem name_different (key : Name) (outside : key∉names) (i : Fin 4) : key≠name i :=
  fun same => outside (same ▸ GsInvNormShape154.name_member i)

theorem declared_frame (s : State) : C99ScopeFrame147.Frame names s (declared s) := by
  refine ⟨?_,rfl,rfl,rfl⟩
  intro key outside
  have a : key∉[name 0,name 1] := by
    intro h
    simp only [List.mem_cons,List.not_mem_nil,or_false] at h
    rcases h with h|h
    · exact name_different key outside 0 h
    · exact name_different key outside 1 h
  have b : key∉[name 2,name 3] := by
    intro h
    simp only [List.mem_cons,List.not_mem_nil,or_false] at h
    rcases h with h|h
    · exact name_different key outside 2 h
    · exact name_different key outside 3 h
  exact (C99DeclareOutside140.source .uint64 [name 2,name 3] (declaredA s).locals key b).trans
    (C99DeclareOutside140.source .uint64 [name 0,name 1] s.locals key a)

theorem frame (s : State) (x : Words) (i : Fin 5) : C99ScopeFrame147.Frame names s (state s x i) := by
  have h0 := declared_frame s
  have h1 := C99ScopeFrame147.trans names _ _ _ h0
    (C99ScopeFrame147.put names (declared s) (name 0) x.ar (by decide))
  have h2 := C99ScopeFrame147.trans names _ _ _ h1
    (C99ScopeFrame147.put names (s1 s x) (name 1) x.ai (by decide))
  have h3 := C99ScopeFrame147.trans names _ _ _ h2
    (C99ScopeFrame147.put names (s2 s x) (name 2) x.br (by decide))
  have h4 := C99ScopeFrame147.trans names _ _ _ h3
    (C99ScopeFrame147.put names (s3 s x) (name 3) x.bi (by decide))
  fin_cases i
  · exact h0
  · exact h1
  · exact h2
  · exact h3
  · exact h4

theorem heap_same (s : State) (x : Words) (i : Fin 5) : (state s x i).heap=s.heap := by fin_cases i <;> rfl

theorem address (s : State) (x : Words) (stage : Fin 5) (slot : Fin 4) (p : C99MemoryReference.ArrayPointer)
    (source : Pointer s (buffer slot) (index slot) p) : Pointer (state s x stage) (buffer slot) (index slot) p := by
  apply FftPointerTransport140.source s (state s x stage) _ _ p source (congrFun (frame s x stage).arrays _)
  intro key member
  exact ((frame s x stage).locals key (GsInvNormShape154.index_reads slot key member)).symm

end FT1536.Source3.GsInvNormStates154
