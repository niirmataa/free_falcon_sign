import Source3.SelectedDeepestEntry175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.DeepestDeclarations175
open C99ArrayReference (State Name)
open KeygenSearchContext (Context)
open KeygenDeepestSource (Exec)
open C99DeclarationStatements (effect)

def arrayCode (code : C99ArrayReference.Stmt) : KeygenDeepestSource.Stmt :=
  .base (.level (.modular (.base code)))

theorem array_source (ctx : Context) (code : C99ArrayReference.Stmt) (before after : State)
    (run : C99ArrayReference.Exec FftLeafPrograms.program code before after) :
    Exec ctx (arrayCode code) before ⟨after,.normal⟩ :=
  .base _ _ _ (.level _ _ _ (.modular _ _ _ (.base _ _ _ run)))

def clear (s : State) (name : Name) : State := {s with arrays:=fun n => if n=name then none else s.arrays n}
def clearAll : State → List Name → State
  | s,[] => s
  | s,name::rest => clearAll (clear s name) rest
def pointers : List Name := ["Fp","Gp","fp","gp","t1"].map String.toList
def pointerCode : List Name → C99ModularReference.Stmt → C99ModularReference.Stmt
  | [],tail => tail
  | name::rest,tail => .seq (.base (.declarePtr name)) (pointerCode rest tail)

theorem pointer_source (names : List Name) (s : State) (tail : C99ModularReference.Stmt) (out : C99ProcedureReference.Result)
    (run : C99ModularReference.Exec tail (clearAll s names) out) :
    C99ModularReference.Exec (pointerCode names tail) s out := by
  induction names generalizing s with
  | nil => exact run
  | cons name rest ih =>
    exact .seqNormal _ _ s (clear s name) out (.base _ _ _ (.declarePtr s name)) (ih (clear s name) run)

def scalar0 := C99ArrayReference.Stmt.scalar (.declare .u32 ["logn".toList])
def scalar1 := C99ArrayReference.Stmt.scalar (.declare .u64 ["len".toList])
def scalarQ := C99ArrayReference.Stmt.scalar (.declare .u32 ["q".toList])
def pointerPart := pointerCode pointers (.seq (.base scalarQ) (.base .skip))
def primePart := KeygenZintCall.Stmt.seq (.word (.modular (.base (.declarePtr "primes".toList))))
  (.word (.modular (.base .skip)))
def code := KeygenDeepestSource.chain [arrayCode scalar0,arrayCode scalar1,
  .base (.level (.modular pointerPart)),.base (.zint primePart)]

theorem shape : KeygenDeepestSource.part 0=code := by decide

def d0 (s : State) := effect .u32 ["logn".toList] s
def d1 (s : State) := effect .u64 ["len".toList] (d0 s)
def dp (s : State) := clearAll (d1 s) pointers
def dq (s : State) := effect .u32 ["q".toList] (dp s)
def after (s : State) := clear (dq s) "primes".toList

theorem source (ctx : Context) (s : State) : Exec ctx (KeygenDeepestSource.part 0) s ⟨after s,.normal⟩ := by
  rw [shape]
  have first : Exec ctx (arrayCode scalar0) s ⟨d0 s,.normal⟩ :=
    array_source ctx scalar0 s (d0 s) (.scalar _ _ _
      (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint32 ["logn".toList] s.locals))
  have second : Exec ctx (arrayCode scalar1) (d0 s) ⟨d1 s,.normal⟩ :=
    array_source ctx scalar1 (d0 s) (d1 s) (.scalar _ _ _
      (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint64 ["len".toList] (d0 s).locals))
  have qRun : C99ModularReference.Exec (.seq (.base scalarQ) (.base .skip)) (dp s) ⟨dq s,.normal⟩ :=
    .seqNormal _ _ (dp s) (dq s) ⟨dq s,.normal⟩
      (.base _ _ _ (.scalar _ _ _
        (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint32 ["q".toList] (dp s).locals)))
      (.base _ _ _ (.skip (dq s)))
  have ptrRun : Exec ctx (.base (.level (.modular pointerPart))) (d1 s) ⟨dq s,.normal⟩ :=
    .base _ _ _ (.level _ _ _ (.modular _ _ _ (pointer_source pointers (d1 s) _ _ qRun)))
  have primeRun : Exec ctx (.base (.zint primePart)) (dq s) ⟨after s,.normal⟩ :=
    .base _ _ _ (.zint _ _ _ (.seqNormal _ _ (dq s) (after s) ⟨after s,.normal⟩
      (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.declarePtr (dq s) "primes".toList))))
      (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.skip (after s)))))))
  exact .seqNormal _ _ s (d0 s) ⟨after s,.normal⟩ first
    (.seqNormal _ _ (d0 s) (d1 s) ⟨after s,.normal⟩ second
      (.seqNormal _ _ (d1 s) (dq s) ⟨after s,.normal⟩ ptrRun
        (.seqNormal _ _ (dq s) (after s) ⟨after s,.normal⟩ primeRun
          (array_source ctx .skip (after s) (after s) (.skip (after s))))))

theorem heap (s : State) : (after s).heap=s.heap := rfl
theorem tables (s : State) : (after s).tables=s.tables := rfl
theorem fk (s : State) : (after s).arrays "fk".toList=s.arrays "fk".toList := rfl
theorem logn_cell (s : State) : (after s).locals "logn".toList=some (.uint32,none) := rfl
theorem len_cell (s : State) : (after s).locals "len".toList=some (.uint64,none) := rfl
theorem q_cell (s : State) : (after s).locals "q".toList=some (.uint32,none) := rfl

end FT1536.Source3.DeepestDeclarations175
