import Source3.SelectedMakeFgEntry175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgDeclarations176
open C99ArrayReference (State Name)
open KeygenMakeFgSource (Exec Stmt)
open C99DeclarationStatements (effect)
open DeepestDeclarations175 (clear clearAll pointerCode pointer_source primePart)

def arrayCode (code : C99ArrayReference.Stmt) : Stmt := .level (.modular (.base code))
theorem array_source (code : C99ArrayReference.Stmt) (before after : State)
    (source : C99ArrayReference.Exec FftLeafPrograms.program code before after) :
    Exec (arrayCode code) before ⟨after,.normal⟩ := .level _ _ _ (.modular _ _ _ (.base _ _ _ source))

def scalar0 := C99ArrayReference.Stmt.scalar (.declare .u64 ["n".toList,"u".toList])
def scalarP := C99ArrayReference.Stmt.scalar (.declare .u32 ["p0".toList])
def scalarD := C99ArrayReference.Stmt.scalar (.declare .u32 ["d".toList])
def pointers : List Name := ["ft".toList,"gt".toList]
def pointerPart := pointerCode pointers (.seq (.base scalarP) (.base .skip))
def code := KeygenMakeFgSource.chain [arrayCode scalar0,.level (.modular pointerPart),arrayCode scalarD,.zint primePart]

theorem shape : KeygenMakeFgSource.part .make 0=code := by decide

def d0 (s : State) := effect .u64 ["n".toList,"u".toList] s
def dp (s : State) := clearAll (d0 s) pointers
def d1 (s : State) := effect .u32 ["p0".toList] (dp s)
def d2 (s : State) := effect .u32 ["d".toList] (d1 s)
def after (s : State) := clear (d2 s) "primes".toList

theorem source (s : State) : Exec (KeygenMakeFgSource.part .make 0) s ⟨after s,.normal⟩ := by
  rw [shape]
  have first : Exec (arrayCode scalar0) s ⟨d0 s,.normal⟩ :=
    array_source _ _ _ (.scalar _ _ _
      (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint64 ["n".toList,"u".toList] s.locals))
  have primeDecl : C99ModularReference.Exec (.seq (.base scalarP) (.base .skip)) (dp s) ⟨d1 s,.normal⟩ :=
    .seqNormal _ _ (dp s) (d1 s) ⟨d1 s,.normal⟩
      (.base _ _ _ (.scalar _ _ _
        (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint32 ["p0".toList] (dp s).locals)))
      (.base _ _ _ (.skip (d1 s)))
  have ptrRun : Exec (.level (.modular pointerPart)) (d0 s) ⟨d1 s,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (pointer_source pointers (d0 s) _ _ primeDecl))
  have dRun : Exec (arrayCode scalarD) (d1 s) ⟨d2 s,.normal⟩ :=
    array_source _ _ _ (.scalar _ _ _
      (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint32 ["d".toList] (d1 s).locals))
  have primeRun : KeygenZintCall.Exec primePart (d2 s) ⟨after s,.normal⟩ :=
    .seqNormal _ _ (d2 s) (after s) ⟨after s,.normal⟩
      (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.declarePtr (d2 s) "primes".toList))))
      (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.skip (after s)))))
  exact .seqNormal _ _ s (d0 s) ⟨after s,.normal⟩ first
    (.seqNormal _ _ (d0 s) (d1 s) ⟨after s,.normal⟩ ptrRun
      (.seqNormal _ _ (d1 s) (d2 s) ⟨after s,.normal⟩ dRun
        (.seqNormal _ _ (d2 s) (after s) ⟨after s,.normal⟩ (.zint _ _ _ primeRun)
          (array_source .skip (after s) (after s) (.skip (after s))))))

theorem heap (s : State) : (after s).heap=s.heap := rfl
theorem n_cell (s : State) : (after s).locals "n".toList=some (.uint64,none) := rfl
theorem u_cell (s : State) : (after s).locals "u".toList=some (.uint64,none) := rfl
theorem p_cell (s : State) : (after s).locals "p0".toList=some (.uint32,none) := rfl

end FT1536.Source3.MakeFgDeclarations176
