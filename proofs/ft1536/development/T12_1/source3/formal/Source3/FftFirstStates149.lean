import Source3.FftFirstShape149
import Source3.C99DeclareOutside140
import Source3.C99ScopeFrame147
import Source3.FftHeapTransport140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstStates149
open C99ArrayReference (State Name Pointer)
open C99MemoryReference (ArrayPointer)
open FftFirstShape149
open FftLocalCells140 (put)

def declared (s : State) : State := C99DeclarationStatements.effect .u64 names s
def first (s : State) (x : BitVec 64) : State := put (declared s) "a0".toList x
def loaded (s : State) (x y : BitVec 64) : State := put (first s x) "a1".toList y

theorem declared_frame (s : State) : C99ScopeFrame147.Frame names s (declared s) :=
  ⟨fun key absent => C99DeclareOutside140.source .uint64 names s.locals key absent,rfl,rfl,rfl⟩

theorem first_frame (s : State) (x : BitVec 64) : C99ScopeFrame147.Frame names s (first s x) :=
  C99ScopeFrame147.trans names s (declared s) (first s x) (declared_frame s)
    (C99ScopeFrame147.put names (declared s) "a0".toList x (by decide))

theorem loaded_frame (s : State) (x y : BitVec 64) : C99ScopeFrame147.Frame names s (loaded s x y) :=
  C99ScopeFrame147.trans names s (first s x) (loaded s x y) (first_frame s x)
    (C99ScopeFrame147.put names (first s x) "a1".toList y (by decide))

theorem pointer0 (s t : State) (p : ArrayPointer) (frame : C99ScopeFrame147.Frame names s t)
    (address : Pointer s "a".toList index0 p) : Pointer t "a".toList index0 p := by
  apply FftPointerTransport140.source s t _ _ p address (congrFun frame.arrays "a".toList)
  intro key member
  rw [index0_reads] at member
  have same : key="u".toList := List.mem_singleton.mp member
  subst key
  exact (frame.locals _ (by decide)).symm

theorem pointer1 (s t : State) (p : ArrayPointer) (frame : C99ScopeFrame147.Frame names s t)
    (address : Pointer s "a".toList index1 p) : Pointer t "a".toList index1 p := by
  apply FftPointerTransport140.source s t _ _ p address (congrFun frame.arrays "a".toList)
  intro key member
  rw [index1_reads] at member
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl|rfl <;> exact (frame.locals _ (by decide)).symm

theorem x_cell (s : State) (x y : BitVec 64) :
    (loaded s x y).locals "a0".toList=some (.uint64,some (.uint64 x)) :=
  (FftLocalCells140.outside (first s x) "a1".toList "a0".toList y (by decide)).trans
    (FftLocalCells140.cell_at (declared s) "a0".toList x)

theorem y_cell (s : State) (x y : BitVec 64) :
    (loaded s x y).locals "a1".toList=some (.uint64,some (.uint64 y)) :=
  FftLocalCells140.cell_at (first s x) "a1".toList y

end FT1536.Source3.FftFirstStates149
