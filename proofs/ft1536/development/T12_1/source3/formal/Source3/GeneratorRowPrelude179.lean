import Source3.SelectedGeneratorInverseFacts178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorRowPrelude179
open C99ArrayReference (State bindValue)
open C99ModularReference (Exec ModCall)
open KeygenMkgm3Program
open KeygenMkgm3RowInit (rowWords rowPrelude)
open KeygenModpR2Exec (Slot)
open ModularAtoms178 (set cell assign mont)

structure Input (s : State) (g ig p p0i : BitVec 32) : Prop where
  gCell : Slot s "g" g
  igCell : Slot s "ig" ig
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  logn : Slot s "logn" 10
  kType : ∃ old, s.locals "k".toList=some (.uint32,old)

def square (x p p0i : BitVec 32) := KeygenModpWord.montgomery x x p p0i
def fourth (x p p0i : BitVec 32) := square (square x p p0i) p p0i
def declaredWords (s : State) := C99DeclarationStatements.effect .u32 (rowWords.map String.toList) s
def declared (s : State) := C99DeclarationStatements.effect .u64 ["b".toList] (declaredWords s)
def withX (s : State) (g : BitVec 32) := set (declared s) "x" g
def withIX (s : State) (g ig : BitVec 32) := set (withX s g) "ix" ig
def withG2 (s : State) (g ig p p0i : BitVec 32) := set (withIX s g ig) "g2" (square g p p0i)
def withG4 (s : State) (g ig p p0i : BitVec 32) := set (withG2 s g ig p p0i) "g4" (fourth g p p0i)
def withIG2 (s : State) (g ig p p0i : BitVec 32) := set (withG4 s g ig p p0i) "ig2" (square ig p p0i)
def withIG4 (s : State) (g ig p p0i : BitVec 32) := set (withIG2 s g ig p p0i) "ig4" (fourth ig p p0i)
def withK (s : State) (g ig p p0i : BitVec 32) := set (withIG4 s g ig p p0i) "k" 1
def after (s : State) (g ig p p0i : BitVec 32) := bindValue (withK s g ig p p0i) "b".toList .uint64 (.uint64 512)

theorem source (s : State) (g ig p p0i : BitVec 32) (h : Input s g ig p p0i) :
    ModularSequence178.Run ModCall rowPrelude s (after s g ig p p0i) := by
  obtain ⟨old,hk⟩ := h.kType
  have d : Exec (wordDecl rowWords) s ⟨declaredWords s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 (rowWords.map String.toList) s)
  have b : Exec (indexDecl ["b"]) (declaredWords s) ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 ["b".toList] (declaredWords s))
  have x : Exec (.assign "x".toList (KeygenMkgm3Program.cell "g")) (declared s) ⟨withX s g,.normal⟩ :=
    assign _ "x" none _ g rfl (cell _ "g" g h.gCell)
  have ix : Exec (.assign "ix".toList (KeygenMkgm3Program.cell "ig")) (withX s g) ⟨withIX s g ig,.normal⟩ :=
    assign _ "ix" none _ ig rfl (cell _ "ig" ig h.igCell)
  have g2 : Exec (.assign "g2".toList montGG) (withIX s g ig) ⟨withG2 s g ig p p0i,.normal⟩ :=
    assign _ "g2" none _ (square g p p0i) rfl
      (mont _ _ _ g g p p0i (cell _ "g" g h.gCell) (cell _ "g" g h.gCell) h.pCell h.iCell)
  have g4 : Exec (.assign "g4".toList (KeygenMkgm3Program.mont (KeygenMkgm3Program.cell "g2") (KeygenMkgm3Program.cell "g2")))
      (withG2 s g ig p p0i) ⟨withG4 s g ig p p0i,.normal⟩ :=
    assign _ "g4" none _ (fourth g p p0i) rfl
      (mont _ _ _ _ _ p p0i (cell _ "g2" _ (ModularAtoms178.slot _ "g2" _))
        (cell _ "g2" _ (ModularAtoms178.slot _ "g2" _)) h.pCell h.iCell)
  have ig2 : Exec (.assign "ig2".toList (KeygenMkgm3Program.mont (KeygenMkgm3Program.cell "ig") (KeygenMkgm3Program.cell "ig")))
      (withG4 s g ig p p0i) ⟨withIG2 s g ig p p0i,.normal⟩ :=
    assign _ "ig2" none _ (square ig p p0i) rfl
      (mont _ _ _ ig ig p p0i (cell _ "ig" ig h.igCell) (cell _ "ig" ig h.igCell) h.pCell h.iCell)
  have ig4 : Exec (.assign "ig4".toList (KeygenMkgm3Program.mont (KeygenMkgm3Program.cell "ig2") (KeygenMkgm3Program.cell "ig2")))
      (withIG2 s g ig p p0i) ⟨withIG4 s g ig p p0i,.normal⟩ :=
    assign _ "ig4" none _ (fourth ig p p0i) rfl
      (mont _ _ _ _ _ p p0i (cell _ "ig2" _ (ModularAtoms178.slot _ "ig2" _))
        (cell _ "ig2" _ (ModularAtoms178.slot _ "ig2" _)) h.pCell h.iCell)
  have k : Exec (.assign "k".toList (.scalar (.bin .sub (num 11) (var "logn"))))
      (withIG4 s g ig p p0i) ⟨withK s g ig p p0i,.normal⟩ :=
    assign _ "k" old _ 1 hk (.scalar _ _ (.arithmetic .minus _ _ _ _ _ (.literal .int32 11)
      (.variable _ _ _ h.logn) (.step .minus (.int32 11) (.uint32 10) .uint32 rfl (.uint32 11) (.uint32 10) rfl rfl
        (by intro impossible; cases impossible))))
  have base : Exec (.assign "b".toList (.scalar (.bin .shl (.cast .u64 (num 1)) (.bin .sub (var "logn") (num 1)))))
      (withK s g ig p p0i) ⟨after s g ig p p0i,.normal⟩ :=
    .assign _ _ _ .uint64 none (.uint64 512) rfl (.scalar _ _
      (.shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 1) (.literal .int32 1))
        (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ h.logn) (.literal .int32 1)
          (.step .minus (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
            (by intro impossible; cases impossible)))
        (.unsignedLeft (.uint64 1) (.uint32 9) 9 rfl rfl (by decide))))
  exact .cons _ _ _ _ _ d (.cons _ _ _ _ _ b (.cons _ _ _ _ _ x (.cons _ _ _ _ _ ix
    (.cons _ _ _ _ _ g2 (.cons _ _ _ _ _ g4 (.cons _ _ _ _ _ ig2 (.cons _ _ _ _ _ ig4
      (.cons _ _ _ _ _ k (.cons _ _ _ _ _ base (.nil _))))))))))

end FT1536.Source3.GeneratorRowPrelude179
