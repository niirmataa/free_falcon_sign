import Source3.FftLoadStates140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoadExec140
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load64 Allocated)
open C99ProcedureReference (Exec)
open FftMulStates140 (Words)
open FftLoadStates140

def preStage (i : Fin 4) : Fin 5 := ⟨i.val,by have bound := i.isLt; omega⟩
def postStage (i : Fin 4) : Fin 5 := ⟨i.val+1,by have bound := i.isLt; omega⟩

structure Entry (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) : Prop where
  address : ∀ i, C99ArrayReference.Pointer before "a".toList (FftLoadShape140.index i) (p i)
  read : ∀ i, Load64 before.heap (p i) (value x i)
  writable : ∀ i, before.heap.writable (p i).block=true
  sr : before.locals "sr".toList=some (.uint64,some (.uint64 sr))
  si : before.locals "si".toList=some (.uint64,some (.uint64 si))

theorem allocated_of_load (heap : C99MemoryReference.Memory) (p : ArrayPointer) (word : BitVec 64)
    (read : Load64 heap p word) : Allocated heap p := by
  cases read with
  | load bytes allocated width initialized => exact allocated

theorem width_of_load (heap : C99MemoryReference.Memory) (p : ArrayPointer) (word : BitVec 64)
    (read : Load64 heap p word) : p.elementBytes=8 := by
  cases read with
  | load bytes allocated width initialized => exact width

theorem declared_cell (before : State) (x : Words) (i : Fin 4) :
    (state before x (preStage i)).locals (FftLoadShape140.name i)=some (.uint64,none) := by
  fin_cases i <;> rfl

theorem stage_output (before : State) (x : Words) (i : Fin 4) :
    FftLocalCells140.put (state before x (preStage i)) (FftLoadShape140.name i) (value x i)=
      state before x (postStage i) := by fin_cases i <;> rfl

theorem loaded_cell (before : State) (x : Words) (i : Fin 4) :
    (s4 before x).locals (FftLoadShape140.name i)=some (.uint64,some (.uint64 (value x i))) := by
  fin_cases i <;> rfl

theorem step (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : Entry before x p sr si) (i : Fin 4) :
    Exec KeygenSearchFft.program (FftLoadShape140.load i)
      (state before x (preStage i)) ⟨state before x (postStage i),.normal⟩ := by
  rw [← stage_output before x i]
  apply Exec.base
  apply FftLocalCells140.assign FftLeafPrograms.program (state before x (preStage i))
    (FftLoadShape140.name i) (.load "a".toList (FftLoadShape140.index i)) none (value x i) (declared_cell before x i)
  exact .load "a".toList (FftLoadShape140.index i) (p i) (value x i)
    (address before x (preStage i) i (p i) (entry.address i))
    (by rw [heap_same]; exact entry.read i)

theorem source (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : Entry before x p sr si) :
    Exec KeygenSearchFft.program (C99ProcedureParser.chain [FftLoadShape140.declaration,
      FftLoadShape140.load 0,FftLoadShape140.load 1,FftLoadShape140.load 2,FftLoadShape140.load 3])
      before ⟨s4 before x,.normal⟩ :=
  .seqNormal _ _ _ _ _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 FftLoadShape140.names before))
    (.seqNormal _ _ _ _ _ (step before x p sr si entry 0)
      (.seqNormal _ _ _ _ _ (step before x p sr si entry 1)
        (.seqNormal _ _ _ _ _ (step before x p sr si entry 2)
          (.seqNormal _ _ _ _ _ (step before x p sr si entry 3) (.base _ _ _ (.skip _))))))

end FT1536.Source3.FftLoadExec140
