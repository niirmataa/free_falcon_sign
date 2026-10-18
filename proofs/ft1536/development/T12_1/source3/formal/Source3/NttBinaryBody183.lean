import Source3.ModularWordOps182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttBinaryBody183
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Exec)
open KeygenNttButterflyPrograms
open KeygenModpR2Exec (Slot)

def twiddled (y w p p0i : BitVec 32) := KeygenModpWord.montgomery y w p p0i
def leftWord (x y w p p0i : BitVec 32) := KeygenModpAddSub.result .add x (twiddled y w p p0i) p
def rightWord (x y w p p0i : BitVec 32) :=
  KeygenModpAddSub.result .sub x (twiddled y w p p0i) p

def names := ["x","y"].map String.toList
def declared (s : State) := C99DeclarationStatements.effect .u32 names s
def withX (s : State) (x : BitVec 32) := ModularAtoms178.set (declared s) "x" x
def withY (s : State) (x y : BitVec 32) := ModularAtoms178.set (withX s x) "y" y
def withTwiddle (s : State) (x y w p p0i : BitVec 32) := ModularAtoms178.set (withY s x y) "y" (twiddled y w p p0i)
def first (s : State) (r1 : ArrayPointer) (x y w p p0i : BitVec 32) : State :=
  {withTwiddle s x y w p p0i with heap:=Word32Memory176.write s.heap r1 (leftWord x y w p p0i)}
def last (s : State) (r1 r2 : ArrayPointer) (x y w p p0i : BitVec 32) : State :=
  {first s r1 x y w p p0i with heap:=Word32Memory176.write (first s r1 x y w p p0i).heap r2 (rightWord x y w p p0i)}
def after (s : State) (r1 r2 : ArrayPointer) (x y w p p0i : BitVec 32) :=
  restoreScope s (last s r1 r2 x y w p p0i) names []

theorem shape : KeygenNttForwardPrograms.block binaryBody=.scope names binaryBody := by decide

theorem source (s : State) (r1 r2 : ArrayPointer) (x y w p p0i : BitVec 32)
    (pCell : Slot s "p" p) (iCell : Slot s "p0i" p0i) (twiddleCell : Slot s "s" w)
    (r1Binding : s.arrays "r1".toList=some r1) (r2Binding : s.arrays "r2".toList=some r2)
    (r1Allocated : Allocated s.heap r1) (r2Allocated : Allocated s.heap r2)
    (r1Width : r1.elementBytes=4) (r2Width : r2.elementBytes=4)
    (r1Writable : s.heap.writable r1.block=true) (r2Writable : s.heap.writable r2.block=true)
    (read0 : Load32 s.heap r1 x) (read1 : Load32 s.heap r2 y) :
    Exec (KeygenNttForwardPrograms.block binaryBody) s ⟨after s r1 r2 x y w p p0i,.normal⟩ := by
  have d : Exec (declaration ["x","y"]) s ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 names s)
  have r0 : Exec (assign "x" (read "r1")) (declared s) ⟨withX s x,.normal⟩ :=
    .assign _ _ _ .uint32 none (.uint32 x) rfl (.load32 "r1".toList zero r1 x
      (RootBinding175.zero (declared s) "r1" r1 r1Binding (Nat.le_of_lt r1Allocated.2.2.1)) read0)
  have r1Run : Exec (assign "y" (read "r2")) (withX s x) ⟨withY s x y,.normal⟩ :=
    .assign _ _ _ .uint32 none (.uint32 y) rfl (.load32 "r2".toList zero r2 y
      (RootBinding175.zero (withX s x) "r2" r2 r2Binding (Nat.le_of_lt r2Allocated.2.2.1)) read1)
  have b : Exec (assign "y" (mont (scalar "y") (scalar "s"))) (withY s x y) ⟨withTwiddle s x y w p p0i,.normal⟩ :=
    ModularAtoms178.assign _ "y" (some (.uint32 y)) _ _ (ModularAtoms178.slot (withX s x) "y" y) (ModularAtoms178.mont _ _ _ y w p p0i
      (ModularAtoms178.cell _ "y" y (ModularAtoms178.slot (withX s x) "y" y))
      (ModularAtoms178.cell _ "s" w twiddleCell) pCell iCell)
  have xCell : Slot (withTwiddle s x y w p p0i) "x" x :=
    (ModularAtoms178.outside (withY s x y) "y" "x" (twiddled y w p p0i) (by decide)).trans
      ((ModularAtoms178.outside (withX s x) "y" "x" y (by decide)).trans (ModularAtoms178.slot (declared s) "x" x))
  have bCell : Slot (withTwiddle s x y w p p0i) "y" (twiddled y w p p0i) := ModularAtoms178.slot (withY s x y) "y" _
  have l : Exec (write "r1" zero (add (scalar "x") (scalar "y"))) (withTwiddle s x y w p p0i) ⟨first s r1 x y w p p0i,.normal⟩ :=
    .store32 _ _ _ _ _ r1 (.uint32 (leftWord x y w p p0i))
      (RootBinding175.zero _ "r1" r1 r1Binding (Nat.le_of_lt r1Allocated.2.2.1))
      (ModularWordOps182.add _ _ _ x _ p (ModularAtoms178.cell _ "x" x xCell) (ModularAtoms178.cell _ "y" _ bCell) pCell)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,
        first,withTwiddle,withY,withX,declared,ModularAtoms178.set,C99ArrayReference.bindValue,C99DeclarationStatements.effect] using
        Word32Memory176.source s.heap r1 (leftWord x y w p p0i) r1Allocated r1Width r1Writable)
  have r : Exec (write "r2" zero (sub (scalar "x") (scalar "y"))) (first s r1 x y w p p0i)
      ⟨last s r1 r2 x y w p p0i,.normal⟩ :=
    .store32 _ _ _ _ _ r2 (.uint32 (rightWord x y w p p0i))
      (RootBinding175.zero _ "r2" r2 r2Binding (Nat.le_of_lt r2Allocated.2.2.1))
      (ModularWordOps182.sub _ _ _ _ _ p
        (ModularAtoms178.cell _ "x" x xCell)
        (ModularAtoms178.cell _ "y" _ bCell) pCell)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,last] using
        Word32Memory176.source (first s r1 x y w p p0i).heap r2 (rightWord x y w p p0i) r2Allocated r2Width r2Writable)
  rw [shape]
  exact .scope names binaryBody s ⟨last s r1 r2 x y w p p0i,.normal⟩
    (.seqNormal _ _ s (declared s) _ d (.seqNormal _ _ (declared s) (withX s x) _ r0
      (.seqNormal _ _ (withX s x) (withY s x y) _ r1Run
        (.seqNormal _ _ (withY s x y) (withTwiddle s x y w p p0i) _ b
          (.seqNormal _ _ (withTwiddle s x y w p p0i) (first s r1 x y w p p0i) _ l
            (.seqNormal _ _ (first s r1 x y w p p0i) (last s r1 r2 x y w p p0i) _ r (.base .skip _ _ (.skip _))))))))

end FT1536.Source3.NttBinaryBody183
