import Source3.GsInvNormStates154
import Source3.FftWordStoreStep140
import Source3.C99Chain139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsInvNormBody154
open C99ArrayReference (State Pointer Eval)
open C99MemoryReference (ArrayPointer Load64)
open C99ProcedureReference (Exec)
open FftMulStates140 (Words)
open GsInvNormShape154 (names name buffer index load declarationA declarationB store)
open GsInvNormStates154 (declaredA declared s1 s2 s3 s4 state value)

def preStage (i : Fin 4) : Fin 5 := ⟨i.val,by have bound:=i.isLt; omega⟩
def postStage (i : Fin 4) : Fin 5 := ⟨i.val+1,by have bound:=i.isLt; omega⟩
def output (s : State) (d : ArrayPointer) (x : Words) : State :=
  {s with heap := C99WordStore140.write s.heap d (GsInvNormShape154.value x)}

theorem declared_cell (s : State) (x : Words) (i : Fin 4) :
    (state s x (preStage i)).locals (name i)=some (.uint64,none) := by fin_cases i <;> rfl
theorem stage_output (s : State) (x : Words) (i : Fin 4) :
    FftLocalCells140.put (state s x (preStage i)) (name i) (value x i)=state s x (postStage i) := by fin_cases i <;> rfl
theorem loaded_cell (s : State) (x : Words) (i : Fin 4) :
    (s4 s x).locals (name i)=some (.uint64,some (.uint64 (value x i))) := by fin_cases i <;> rfl

theorem step (s : State) (x : Words) (p : Fin 4 → ArrayPointer)
    (address : ∀ i, Pointer s (buffer i) (index i) (p i))
    (read : ∀ i, Load64 s.heap (p i) (value x i)) (i : Fin 4) :
    Exec KeygenSearchFft.program (load i) (state s x (preStage i)) ⟨state s x (postStage i),.normal⟩ := by
  rw [← stage_output s x i]
  apply Exec.base
  apply FftLocalCells140.assign FftLeafPrograms.program (state s x (preStage i))
    (name i) (.load (buffer i) (index i)) none (value x i) (declared_cell s x i)
  exact .load _ _ (p i) (value x i)
    (GsInvNormStates154.address s x (preStage i) i (p i) (address i))
    (by rw [GsInvNormStates154.heap_same]; exact read i)

theorem loads (s : State) (x : Words) (p : Fin 4 → ArrayPointer)
    (address : ∀ i, Pointer s (buffer i) (index i) (p i))
    (read : ∀ i, Load64 s.heap (p i) (value x i)) :
    Exec KeygenSearchFft.program (C99ProcedureParser.chain [declarationA,declarationB,load 0,load 1,load 2,load 3])
      s ⟨s4 s x,.normal⟩ :=
  .seqNormal _ _ _ _ _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 [name 0,name 1] s))
    (.seqNormal _ _ _ _ _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 [name 2,name 3] (GsInvNormStates154.declaredA s)))
      (.seqNormal _ _ _ _ _ (step s x p address read 0)
        (.seqNormal _ _ _ _ _ (step s x p address read 1)
          (.seqNormal _ _ _ _ _ (step s x p address read 2)
            (.seqNormal _ _ _ _ _ (step s x p address read 3) (.base _ _ _ (.skip _)))))))

theorem expression (s : State) (x : Words) :
    Eval (s4 s x) GsInvNormShape154.expression (.uint64 (GsInvNormShape154.value x)) :=
  GsInvNormShape154.expression_source (s4 s x) x
    (FftLocalCells140.read_var _ _ _ (loaded_cell s x 0))
    (FftLocalCells140.read_var _ _ _ (loaded_cell s x 1))
    (FftLocalCells140.read_var _ _ _ (loaded_cell s x 2))
    (FftLocalCells140.read_var _ _ _ (loaded_cell s x 3))

theorem destination (s : State) (x : Words) (d : ArrayPointer)
    (address : Pointer s "d".toList FftFirstShape149.index0 d) :
    Pointer (s4 s x) "d".toList FftFirstShape149.index0 d := by
  have frame := GsInvNormStates154.frame s x 4
  apply FftPointerTransport140.source s (s4 s x) _ _ d address (congrFun frame.arrays _)
  intro key member
  rw [FftFirstShape149.index0_reads] at member
  have same := List.mem_singleton.mp member
  subst key
  exact (frame.locals _ (by decide)).symm

/-- One original inverse-norm iteration for arbitrary source words and valid pointers. -/
theorem source (s : State) (x : Words) (p : Fin 4 → ArrayPointer) (d : ArrayPointer)
    (address : ∀ i, Pointer s (buffer i) (index i) (p i))
    (read : ∀ i, Load64 s.heap (p i) (value x i))
    (dst : Pointer s "d".toList FftFirstShape149.index0 d)
    (allocated : C99MemoryReference.Allocated s.heap d) (width : d.elementBytes=8)
    (writable : s.heap.writable d.block=true) :
    Exec KeygenSearchFft.program GsInvNormShape154.body s ⟨output s d x,.normal⟩ := by
  have head := loads s x p address read
  have written : Exec KeygenSearchFft.program store (s4 s x) ⟨output (s4 s x) d x,.normal⟩ :=
    .base _ _ _ (FftWordStoreStep140.source _ (s4 s x) _ _ _ d (GsInvNormShape154.value x)
      (destination s x d dst) (expression s x) allocated width writable)
  have tail : Exec KeygenSearchFft.program (C99ProcedureParser.chain [store]) (s4 s x)
      ⟨output (s4 s x) d x,.normal⟩ :=
    .seqNormal _ _ _ _ _ written (.base _ _ _ (.skip _))
  have full := C99Chain139.append KeygenSearchFft.program
    [declarationA,declarationB,load 0,load 1,load 2,load 3] [store]
    s (s4 s x) ⟨output (s4 s x) d x,.normal⟩ head tail
  have frame : C99ScopeFrame147.Frame names s (output (s4 s x) d x) :=
    C99ScopeFrame147.trans names _ _ _ (GsInvNormStates154.frame s x 4)
      (C99ScopeFrame147.heap_only names _ _)
  have restored := C99ScopeFrame147.restored names s _ frame
  change C99ArrayReference.restoreScope s (output (s4 s x) d x) names []=output s d x at restored
  rw [GsInvNormShape154.body,← restored]
  exact .scope _ _ _ _ _ full

end FT1536.Source3.GsInvNormBody154
