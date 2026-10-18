import Source3.ModularWordOps182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttFirstBody182
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Exec)
open KeygenNttButterflyPrograms
open KeygenModpR2Exec (Slot)

def twiddled (a1 w p p0i : BitVec 32) := KeygenModpWord.montgomery a1 w p p0i
def leftWord (a0 a1 w p p0i : BitVec 32) := KeygenModpAddSub.result .add a0 (twiddled a1 w p p0i) p
def rightWord (a0 a1 w p p0i : BitVec 32) :=
  KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add a0 a1 p) (twiddled a1 w p p0i) p

def names := ["a0","a1","b"].map String.toList
def declared (s : State) := C99DeclarationStatements.effect .u32 names s
def withA0 (s : State) (a0 : BitVec 32) := ModularAtoms178.set (declared s) "a0" a0
def withA1 (s : State) (a0 a1 : BitVec 32) := ModularAtoms178.set (withA0 s a0) "a1" a1
def withB (s : State) (a0 a1 w p p0i : BitVec 32) := ModularAtoms178.set (withA1 s a0 a1) "b" (twiddled a1 w p p0i)
def first (s : State) (r1 : ArrayPointer) (a0 a1 w p p0i : BitVec 32) : State :=
  {withB s a0 a1 w p p0i with heap:=Word32Memory176.write s.heap r1 (leftWord a0 a1 w p p0i)}
def last (s : State) (r1 r2 : ArrayPointer) (a0 a1 w p p0i : BitVec 32) : State :=
  {first s r1 a0 a1 w p p0i with heap:=Word32Memory176.write (first s r1 a0 a1 w p p0i).heap r2 (rightWord a0 a1 w p p0i)}
def after (s : State) (r1 r2 : ArrayPointer) (a0 a1 w p p0i : BitVec 32) :=
  restoreScope s (last s r1 r2 a0 a1 w p p0i) names []

theorem shape : KeygenNttForwardPrograms.block firstBody=.scope names firstBody := by decide

theorem source (s : State) (r1 r2 : ArrayPointer) (a0 a1 w p p0i : BitVec 32)
    (pCell : Slot s "p" p) (iCell : Slot s "p0i" p0i) (wCell : Slot s "w" w)
    (r1Binding : s.arrays "r1".toList=some r1) (r2Binding : s.arrays "r2".toList=some r2)
    (r1Allocated : Allocated s.heap r1) (r2Allocated : Allocated s.heap r2)
    (r1Width : r1.elementBytes=4) (r2Width : r2.elementBytes=4)
    (r1Writable : s.heap.writable r1.block=true) (r2Writable : s.heap.writable r2.block=true)
    (read0 : Load32 s.heap r1 a0) (read1 : Load32 s.heap r2 a1) :
    Exec (KeygenNttForwardPrograms.block firstBody) s ⟨after s r1 r2 a0 a1 w p p0i,.normal⟩ := by
  have d : Exec (declaration ["a0","a1","b"]) s ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 names s)
  have r0 : Exec (assign "a0" (read "r1")) (declared s) ⟨withA0 s a0,.normal⟩ :=
    .assign _ _ _ .uint32 none (.uint32 a0) rfl (.load32 "r1".toList zero r1 a0
      (RootBinding175.zero (declared s) "r1" r1 r1Binding (Nat.le_of_lt r1Allocated.2.2.1)) read0)
  have r1Run : Exec (assign "a1" (read "r2")) (withA0 s a0) ⟨withA1 s a0 a1,.normal⟩ :=
    .assign _ _ _ .uint32 none (.uint32 a1) rfl (.load32 "r2".toList zero r2 a1
      (RootBinding175.zero (withA0 s a0) "r2" r2 r2Binding (Nat.le_of_lt r2Allocated.2.2.1)) read1)
  have b : Exec (assign "b" (mont (scalar "a1") (scalar "w"))) (withA1 s a0 a1) ⟨withB s a0 a1 w p p0i,.normal⟩ :=
    ModularAtoms178.assign _ "b" none _ _ rfl (ModularAtoms178.mont _ _ _ a1 w p p0i
      (ModularAtoms178.cell _ "a1" a1 (ModularAtoms178.slot (withA0 s a0) "a1" a1))
      (ModularAtoms178.cell _ "w" w wCell) pCell iCell)
  have a0Cell : Slot (withB s a0 a1 w p p0i) "a0" a0 :=
    (ModularAtoms178.outside (withA1 s a0 a1) "b" "a0" (twiddled a1 w p p0i) (by decide)).trans
      ((ModularAtoms178.outside (withA0 s a0) "a1" "a0" a1 (by decide)).trans (ModularAtoms178.slot (declared s) "a0" a0))
  have a1Cell : Slot (withB s a0 a1 w p p0i) "a1" a1 :=
    (ModularAtoms178.outside (withA1 s a0 a1) "b" "a1" (twiddled a1 w p p0i) (by decide)).trans
      (ModularAtoms178.slot (withA0 s a0) "a1" a1)
  have bCell : Slot (withB s a0 a1 w p p0i) "b" (twiddled a1 w p p0i) := ModularAtoms178.slot (withA1 s a0 a1) "b" _
  have l : Exec (write "r1" zero (add (scalar "a0") (scalar "b"))) (withB s a0 a1 w p p0i) ⟨first s r1 a0 a1 w p p0i,.normal⟩ :=
    .store32 _ _ _ _ _ r1 (.uint32 (leftWord a0 a1 w p p0i))
      (RootBinding175.zero _ "r1" r1 r1Binding (Nat.le_of_lt r1Allocated.2.2.1))
      (ModularWordOps182.add _ _ _ a0 _ p (ModularAtoms178.cell _ "a0" a0 a0Cell) (ModularAtoms178.cell _ "b" _ bCell) pCell)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,
        first,withB,withA1,withA0,declared,ModularAtoms178.set,C99ArrayReference.bindValue,C99DeclarationStatements.effect] using
        Word32Memory176.source s.heap r1 (leftWord a0 a1 w p p0i) r1Allocated r1Width r1Writable)
  have r : Exec (write "r2" zero (sub (add (scalar "a0") (scalar "a1")) (scalar "b"))) (first s r1 a0 a1 w p p0i)
      ⟨last s r1 r2 a0 a1 w p p0i,.normal⟩ :=
    .store32 _ _ _ _ _ r2 (.uint32 (rightWord a0 a1 w p p0i))
      (RootBinding175.zero _ "r2" r2 r2Binding (Nat.le_of_lt r2Allocated.2.2.1))
      (ModularWordOps182.sub _ _ _ _ _ p
        (ModularWordOps182.add _ _ _ a0 a1 p (ModularAtoms178.cell _ "a0" a0 a0Cell) (ModularAtoms178.cell _ "a1" a1 a1Cell) pCell)
        (ModularAtoms178.cell _ "b" _ bCell) pCell)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,last] using
        Word32Memory176.source (first s r1 a0 a1 w p p0i).heap r2 (rightWord a0 a1 w p p0i) r2Allocated r2Width r2Writable)
  rw [shape]
  exact .scope names firstBody s ⟨last s r1 r2 a0 a1 w p p0i,.normal⟩
    (.seqNormal _ _ s (declared s) _ d (.seqNormal _ _ (declared s) (withA0 s a0) _ r0
      (.seqNormal _ _ (withA0 s a0) (withA1 s a0 a1) _ r1Run
        (.seqNormal _ _ (withA1 s a0 a1) (withB s a0 a1 w p p0i) _ b
          (.seqNormal _ _ (withB s a0 a1 w p p0i) (first s r1 a0 a1 w p p0i) _ l
            (.seqNormal _ _ (first s r1 a0 a1 w p p0i) (last s r1 r2 a0 a1 w p p0i) _ r (.base .skip _ _ (.skip _))))))))

end FT1536.Source3.NttFirstBody182
