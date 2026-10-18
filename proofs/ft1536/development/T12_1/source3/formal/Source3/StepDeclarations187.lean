import Source3.FirstStepEntry187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepDeclarations187
open C99ArrayReference (State Name)
open KeygenMakeFgSource (Exec Stmt)
open C99DeclarationStatements (effect)
open DeepestDeclarations175 (clear clearAll pointerCode pointer_source primePart)
open MakeFgDeclarations176 (arrayCode array_source)

def scalar0 := C99ArrayReference.Stmt.scalar (.declare .u64 ["n".toList,"hn".toList,"u".toList])
def scalar1 := C99ArrayReference.Stmt.scalar (.declare .u64 ["slen".toList,"tlen".toList])
def pointers : List Name := ["fd","gd","fs","gs","gm","igm","t1"].map String.toList
def pointerPart := pointerCode pointers (.base .skip)
def code := KeygenMakeFgSource.chain [arrayCode scalar0,arrayCode scalar1,.level (.modular pointerPart),.zint primePart]

theorem shape : KeygenMakeFgSource.part .step 0=code := by decide

def d0 (s : State) := effect .u64 ["n".toList,"hn".toList,"u".toList] s
def d1 (s : State) := effect .u64 ["slen".toList,"tlen".toList] (d0 s)
def dp (s : State) := clearAll (d1 s) pointers
def after (s : State) := clear (dp s) "primes".toList

theorem source (s : State) : Exec (KeygenMakeFgSource.part .step 0) s ⟨after s,.normal⟩ := by
  rw [shape]
  have first : Exec (arrayCode scalar0) s ⟨d0 s,.normal⟩ :=
    array_source _ _ _ (.scalar _ _ _ (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint64 ["n".toList,"hn".toList,"u".toList] s.locals))
  have second : Exec (arrayCode scalar1) (d0 s) ⟨d1 s,.normal⟩ :=
    array_source _ _ _ (.scalar _ _ _ (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint64 ["slen".toList,"tlen".toList] (d0 s).locals))
  have ptrRun : Exec (.level (.modular pointerPart)) (d1 s) ⟨dp s,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (pointer_source pointers (d1 s) (.base .skip) ⟨dp s,.normal⟩ (.base .skip _ _ (.skip _))))
  have primeRun : KeygenZintCall.Exec primePart (dp s) ⟨after s,.normal⟩ :=
    .seqNormal _ _ (dp s) (after s) ⟨after s,.normal⟩
      (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.declarePtr (dp s) "primes".toList))))
      (.word _ _ _ (.modular _ _ _ (.base .skip _ _ (.skip _))))
  exact .seqNormal _ _ s (d0 s) _ first (.seqNormal _ _ (d0 s) (d1 s) _ second
    (.seqNormal _ _ (d1 s) (dp s) _ ptrRun (.seqNormal _ _ (dp s) (after s) _ (.zint _ _ _ primeRun)
      (array_source .skip (after s) (after s) (.skip (after s))))))

theorem heap (s : State) : (after s).heap=s.heap := rfl

end FT1536.Source3.StepDeclarations187
