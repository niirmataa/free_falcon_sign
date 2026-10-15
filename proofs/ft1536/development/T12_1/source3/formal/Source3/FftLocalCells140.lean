import Source3.FftWordExpressions140
import Source3.C99DeclarationStatements

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLocalCells140
open C99ArrayReference (State Name Expr Eval Exec Program)

def put (before : State) (name : Name) (word : BitVec 64) : State :=
  {before with locals := C99ScalarReference.set before.locals name (.uint64,some (.uint64 word))}

theorem put_bind (before : State) (name : Name) (word : BitVec 64) :
    put before name word=C99ArrayReference.bindValue before name .uint64 (.uint64 word) := by
  unfold put C99ArrayReference.bindValue
  have same := C99CountedWords.convert_self (C99IntegerReference.Value.uint64 word)
  change C99IntegerReference.convert .uint64 (C99IntegerReference.Value.uint64 word).integer=.uint64 word at same
  rw [same]

theorem read_var (state : State) (name : Name) (word : BitVec 64)
    (bound : state.locals name=some (.uint64,some (.uint64 word))) :
    Eval state (.scalar (.var name)) (.uint64 word) :=
  .scalar _ _ (.variable name .uint64 (.uint64 word) bound)

theorem assign (program : Program) (before : State) (name : Name) (expr : Expr)
    (old : Option C99IntegerReference.Value) (word : BitVec 64)
    (declared : before.locals name=some (.uint64,old))
    (evaluated : Eval before expr (.uint64 word)) :
    Exec program (.assign name expr) before (put before name word) := by
  rw [put_bind]
  exact .assign _ _ _ .uint64 old (.uint64 word) declared evaluated

theorem cell_at (before : State) (name : Name) (word : BitVec 64) :
    (put before name word).locals name=some (.uint64,some (.uint64 word)) := by simp [put,C99ScalarReference.set]

theorem outside (before : State) (name other : Name) (word : BitVec 64) (different : other≠name) :
    (put before name word).locals other=before.locals other := by simp [put,C99ScalarReference.set,different]

end FT1536.Source3.FftLocalCells140
