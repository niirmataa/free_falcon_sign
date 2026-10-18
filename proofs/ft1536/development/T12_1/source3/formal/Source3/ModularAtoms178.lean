import Source3.ModularSequence178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModularAtoms178
open C99ModularReference (Expr Stmt Exec Eval ModCall)
open C99ArrayReference (State bindValue)
open KeygenModpR2Exec (Slot)

def set (s : State) (name : String) (w : BitVec 32) := bindValue s name.toList .uint32 (.uint32 w)

theorem slot (s : State) (name : String) (w : BitVec 32) : Slot (set s name w) name w := by
  simp [Slot,set,bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem outside (s : State) (name other : String) (w : BitVec 32) (different : other.toList≠name.toList) :
    (set s name w).locals other.toList=s.locals other.toList := by
  simp only [set,bindValue,C99ScalarReference.set,different,ite_false]

theorem assign (s : State) (name : String) (old : Option C99IntegerReference.Value) (e : Expr) (w : BitVec 32)
    (declared : s.locals name.toList=some (.uint32,old)) (value : Eval s e (.uint32 w)) :
    Exec (.assign name.toList e) s ⟨set s name w,.normal⟩ :=
  .assign _ _ _ .uint32 old (.uint32 w) declared value

theorem cell (s : State) (name : String) (w : BitVec 32) (binding : Slot s name w) :
    Eval s (KeygenMkgm3Program.cell name) (.uint32 w) := .scalar _ _ (.variable _ _ _ binding)

theorem mont (s : State) (left right : Expr) (a b p p0i : BitVec 32)
    (first : Eval s left (.uint32 a)) (second : Eval s right (.uint32 b))
    (hp : Slot s "p" p) (hi : Slot s "p0i" p0i) :
    Eval s (KeygenMkgm3Program.mont left right) (.uint32 (KeygenModpWord.montgomery a b p p0i)) :=
  .call4 _ _ _ _ _ _ _ _ _ _ first second (cell s "p" p hp) (cell s "p0i" p0i hi)
    (.montgomery _ _ (KeygenModpWord.source_exists a b p p0i))

end FT1536.Source3.ModularAtoms178
