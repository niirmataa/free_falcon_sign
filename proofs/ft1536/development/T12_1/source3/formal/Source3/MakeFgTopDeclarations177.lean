import Source3.MakeFgTopShape177

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgTopDeclarations177
open C99ArrayReference (State)
open KeygenLevelExec (Exec)
open LevelSequence177 (Run array_source)
open MakeFgTopShape177
open DeepestDeclarations175 (clearAll pointer_source)

def sized (s : State) := C99DeclarationStatements.effect .u64 scalars64 s
def pointed (s : State) := clearAll (sized s) pointers
def after (s : State) := C99DeclarationStatements.effect .u32 scalars32 (pointed s)

theorem source (s : State) : Run declarationSteps s (after s) :=
  .cons _ _ s (sized s) (after s)
    (array_source _ _ _ (.scalar _ _ _ (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint64 scalars64 s.locals)))
    (.cons _ _ (sized s) (pointed s) (after s)
      (.modular _ _ _ (pointer_source pointers (sized s) (.base .skip) ⟨pointed s,.normal⟩
        (.base _ _ _ (.skip (pointed s)))))
      (.cons _ _ (pointed s) (after s) (after s)
        (array_source _ _ _ (.scalar _ _ _ (C99DeclarationCells.exists_execution FprPrefixCalls.calls .uint32 scalars32 (pointed s).locals)))
        (.nil (after s))))

theorem heap (s : State) : (after s).heap=s.heap := rfl
theorem logn (s : State) : (after s).locals "logn".toList=s.locals "logn".toList := rfl
theorem output (s : State) : (after s).locals "out_ntt".toList=s.locals "out_ntt".toList := rfl
theorem data (s : State) : (after s).arrays "data".toList=s.arrays "data".toList := rfl

end FT1536.Source3.MakeFgTopDeclarations177
