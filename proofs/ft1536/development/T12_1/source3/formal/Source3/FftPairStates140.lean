import Source3.FftPairShape140
import Source3.C99DeclareOutside140
import Source3.FftWordStoreStep140
import Source3.FftPointerTransport140
import Source3.FftMulStates140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftPairStates140
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open FftPairShape140 (Kind word temporaries)
open FftMulStates140 (Words)
open FftLocalCells140 (put)

def real (kind : Kind) (x : Words) := word kind x.ar x.br
def imag (kind : Kind) (x : Words) := word kind x.ai x.bi

structure Entry (before : State) (x : Words) : Prop where
  ar : before.locals "a0r".toList=some (.uint64,some (.uint64 x.ar))
  ai : before.locals "a0i".toList=some (.uint64,some (.uint64 x.ai))
  br : before.locals "a1r".toList=some (.uint64,some (.uint64 x.br))
  bi : before.locals "a1i".toList=some (.uint64,some (.uint64 x.bi))

def declared (before : State) : State := C99DeclarationStatements.effect .u64 temporaries before
def realState (kind : Kind) (before : State) (x : Words) : State := put (declared before) "fpct_re".toList (real kind x)
def imagState (kind : Kind) (before : State) (x : Words) : State := put (realState kind before x) "fpct_im".toList (imag kind x)

def firstHeap (kind : Kind) (before : State) (x : Words) (p : ArrayPointer) :=
  C99WordStore140.write before.heap p (real kind x)
def finalHeap (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer) :=
  C99WordStore140.write (firstHeap kind before x p) q (imag kind x)
def firstWrite (kind : Kind) (before : State) (x : Words) (p : ArrayPointer) : State :=
  {imagState kind before x with heap := firstHeap kind before x p}
def finalWrite (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer) : State :=
  {imagState kind before x with heap := finalHeap kind before x p q}
def output (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer) : State :=
  {before with heap := finalHeap kind before x p q}

theorem other_local (kind : Kind) (before : State) (x : Words) (name : Name) (absent : name∉temporaries) :
    (imagState kind before x).locals name=before.locals name := by
  have notReal : name≠"fpct_re".toList := fun same => absent (same ▸ List.mem_cons_self)
  have notImag : name≠"fpct_im".toList := fun same => absent (same ▸ List.mem_cons_of_mem _ List.mem_cons_self)
  exact (FftLocalCells140.outside (realState kind before x) "fpct_im".toList name (imag kind x) notImag).trans
    ((FftLocalCells140.outside (declared before) "fpct_re".toList name (real kind x) notReal).trans
      (C99DeclareOutside140.source .uint64 temporaries before.locals name absent))

theorem real_index_outside (kind : Kind) (name : Name)
    (member : name∈C99ExpressionEnvironment.readNames (C99Frontend.expression (FftPairShape140.realIndex kind))) :
    name∉temporaries := by
  cases kind
  · simp only [FftPairShape140.real_read_names,List.mem_singleton] at member
    subst name
    decide
  · simp only [FftPairShape140.real_read_names,List.mem_cons,List.not_mem_nil,or_false] at member
    rcases member with rfl|rfl <;> decide

theorem imag_index_outside (kind : Kind) (name : Name)
    (member : name∈C99ExpressionEnvironment.readNames (C99Frontend.expression (FftPairShape140.imagIndex kind))) :
    name∉temporaries := by
  cases kind
  · simp only [FftPairShape140.imag_read_names,List.mem_cons,List.not_mem_nil,or_false] at member
    rcases member with rfl|rfl <;> decide
  · simp only [FftPairShape140.imag_read_names,List.mem_cons,List.not_mem_nil,or_false] at member
    rcases member with rfl|rfl|rfl <;> decide

theorem real_address (kind : Kind) (before : State) (x : Words) (pointer : ArrayPointer)
    (address : C99ArrayReference.Pointer before "a".toList (FftPairShape140.realIndex kind) pointer) :
    C99ArrayReference.Pointer (imagState kind before x) "a".toList (FftPairShape140.realIndex kind) pointer := by
  apply FftPointerTransport140.source before (imagState kind before x) _ _ pointer address rfl
  intro name member
  exact (other_local kind before x name (real_index_outside kind name member)).symm

theorem imag_address (kind : Kind) (before : State) (x : Words) (first pointer : ArrayPointer)
    (address : C99ArrayReference.Pointer before "a".toList (FftPairShape140.imagIndex kind) pointer) :
    C99ArrayReference.Pointer (firstWrite kind before x first) "a".toList (FftPairShape140.imagIndex kind) pointer := by
  apply FftPointerTransport140.source before (firstWrite kind before x first) _ _ pointer address rfl
  intro name member
  exact (other_local kind before x name (imag_index_outside kind name member)).symm

end FT1536.Source3.FftPairStates140
