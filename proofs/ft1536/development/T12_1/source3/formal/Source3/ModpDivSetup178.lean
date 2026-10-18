import Source3.ModpDivLoop178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModpDivSetup178
open C99ArrayReference (State)
open C99ModularReference
open KeygenModpR2Exec (Slot)
open ModularAtoms178 (set)

def entry (s : State) (a b p p0i r : BitVec 32) := bindParams s divParams [.uint32 a,.uint32 b,.uint32 p,.uint32 p0i,.uint32 r]
def words (s : State) := C99DeclarationStatements.effect .u32 ["z".toList,"e".toList] s
def declared (s : State) := C99DeclarationStatements.effect .i32 ["i".toList] (words s)
def withE (s : State) (p : BitVec 32) := set (declared s) "e" (p-2)
def after (s : State) (p r : BitVec 32) := set (withE s p) "z" r

def steps : List Stmt := [
  .base (.scalar (.declare .u32 ["z".toList,"e".toList])),
  .base (.scalar (.declare .i32 ["i".toList])),
  .assign "e".toList (.scalar (.bin .sub (.var "p".toList) (.literal .i32 2))),
  .assign "z".toList (.scalar (.var "R".toList))]

theorem entry_p (s : State) (a b p p0i r : BitVec 32) : Slot (entry s a b p p0i r) "p" p := by
  simp [Slot,entry,bindParams,divParams,C99ArrayReference.bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem entry_r (s : State) (a b p p0i r : BitVec 32) : Slot (entry s a b p p0i r) "R" r := by
  simp [Slot,entry,bindParams,divParams,C99ArrayReference.bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem subtract_two (p : BitVec 32) : C99IntegerReference.ArithmeticExec .minus (.uint32 p) (.int32 2) (.uint32 (p-2)) :=
  C99IntegerSound.arithmetic_sound .minus (.u32 p) (.i32 2) (.u32 (p-2)) (by rfl)

theorem source (s : State) (p r : BitVec 32) (hp : Slot s "p" p) (hr : Slot s "R" r) :
    ModularSequence178.Run LeafCall steps s (after s p r) :=
  .cons _ _ s (words s) (after s p r)
    (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 ["z".toList,"e".toList] s))
    (.cons _ _ (words s) (declared s) (after s p r)
      (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .i32 ["i".toList] (words s)))
      (.cons _ _ (declared s) (withE s p) (after s p r)
        (.assign _ _ _ .uint32 none (.uint32 (p-2)) rfl
          (.scalar _ _ (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ hp) (.literal .int32 2) (subtract_two p))))
        (.cons _ _ (withE s p) (after s p r) (after s p r)
          (.assign _ _ _ .uint32 none (.uint32 r) rfl (.scalar _ _ (.variable _ _ _ hr)))
          (.nil (after s p r)))))

theorem fixed (s : State) (a b p p0i r : BitVec 32) :
    ModpDivStep178.Fixed (after (entry s a b p p0i r) p r) a b p p0i (p-2) := by
  refine ⟨?_,?_,?_,?_,?_⟩
  · change Slot (entry s a b p p0i r) "a" a
    simp [Slot,entry,bindParams,divParams,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99IntegerReference.convert,C99IntegerReference.Value.integer]
  · change Slot (entry s a b p p0i r) "b" b
    simp [Slot,entry,bindParams,divParams,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99IntegerReference.convert,C99IntegerReference.Value.integer]
  · change Slot (entry s a b p p0i r) "p" p
    simp [Slot,entry,bindParams,divParams,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99IntegerReference.convert,C99IntegerReference.Value.integer]
  · change Slot (entry s a b p p0i r) "p0i" p0i
    simp [Slot,entry,bindParams,divParams,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99IntegerReference.convert,C99IntegerReference.Value.integer]
  · exact ModularAtoms178.slot (declared (entry s a b p p0i r)) "e" (p-2)

theorem z_slot (s : State) (p r : BitVec 32) : Slot (after s p r) "z" r := ModularAtoms178.slot (withE s p) "z" r

theorem i_declared (s : State) (p r : BitVec 32) : (after s p r).locals "i".toList=some (.int32,none) := rfl

end FT1536.Source3.ModpDivSetup178
