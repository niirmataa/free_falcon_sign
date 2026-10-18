import Source3.GeneratorSquareDomains181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorSquareBody181
open C99ArrayReference (State bindValue restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenMkgm3Program
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open GeneratorCubeFixed180 (Fixed)
open ModularAtoms178 (mont)

def square (word p p0i : BitVec 32) := KeygenModpWord.montgomery word word p p0i
def declared (s : State) := C99DeclarationStatements.effect .u64 ["v".toList] s
def indexed (s : State) (u : Nat) := bindValue (declared s) "v".toList .uint64 (u64 (2*u))
def gWritten (s : State) (gm : ArrayPointer) (p p0i y : BitVec 32) (u : Nat) : State :=
  {indexed s u with heap:=Word32Memory176.write s.heap (element gm u) (square y p p0i)}
def bothWritten (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat) : State :=
  {gWritten s gm p p0i y u with heap:=Word32Memory176.write (gWritten s gm p p0i y u).heap (element igm u) (square z p p0i)}
def after (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat) :=
  restoreScope s (bothWritten s gm igm p p0i y z u) ["v".toList] []

theorem v_cell (s : State) (u : Nat) (bound : u < 256) : USlot (indexed s u) "v" (2*u) :=
  KeygenMkgm3RowInit.set64_slot (declared s) "v" (2*u) (by omega)

theorem source (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat)
    (lo : 1 ≤ u) (hi : u < 256) (fixed : Fixed s gm igm p p0i) (counter : USlot s "u" u)
    (gRead : Load32 s.heap (element gm (2*u)) y)
    (iRead : Load32 (gWritten s gm p p0i y u).heap (element igm (2*u)) z) :
    Exec squareBody s ⟨after s gm igm p p0i y z u,.normal⟩ := by
  have d : Exec (indexDecl ["v"]) s ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 ["v".toList] s)
  have v : Exec (.assign "v".toList (.scalar (.bin .shl (var "u") (num 1)))) (declared s) ⟨indexed s u,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 (2*u)) rfl (.scalar _ _
      (GeneratorCubeIndex180.doubled (declared s) u (by omega) counter))
  have gv : C99ModularReference.Eval (indexed s u) (load "gm" (var "v")) (.uint32 y) :=
    .load32 "gm".toList (var "v") (element gm (2*u)) y
      (GeneratorCubeIndex180.address (indexed s u) "gm" gm (2*u) (by omega) _ fixed.gBinding
        (.variable _ _ _ (v_cell s u hi)) (fixed.gAllocated (2*u) (by omega))) gRead
  have gStore : Exec (.store32 "gm".toList (var "u") (KeygenMkgm3Program.mont (load "gm" (var "v")) (load "gm" (var "v"))))
      (indexed s u) ⟨gWritten s gm p p0i y u,.normal⟩ :=
    .store32 _ _ _ (indexed s u) (gWritten s gm p p0i y u).heap (element gm u) (.uint32 (square y p p0i))
      (GeneratorCubeIndex180.address (indexed s u) "gm" gm u (by omega) _ fixed.gBinding
        (.variable _ _ _ counter) (fixed.gAllocated u (by omega)))
      (mont (indexed s u) _ _ y y p p0i gv gv fixed.pCell fixed.iCell)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,gWritten,indexed,declared,C99ArrayReference.bindValue,C99DeclarationStatements.effect] using
        Word32Memory176.source s.heap (element gm u) (square y p p0i) (fixed.gAllocated u (by omega)) fixed.gWidth fixed.gWritable)
  have iv : C99ModularReference.Eval (gWritten s gm p p0i y u) (load "igm" (var "v")) (.uint32 z) :=
    .load32 "igm".toList (var "v") (element igm (2*u)) z
      (GeneratorCubeIndex180.address (gWritten s gm p p0i y u) "igm" igm (2*u) (by omega) _ fixed.iBinding
        (.variable _ _ _ (v_cell s u hi)) (fixed.iAllocated (2*u) (by omega))) iRead
  have iStore : Exec (.store32 "igm".toList (var "u") (KeygenMkgm3Program.mont (load "igm" (var "v")) (load "igm" (var "v"))))
      (gWritten s gm p p0i y u) ⟨bothWritten s gm igm p p0i y z u,.normal⟩ :=
    .store32 _ _ _ (gWritten s gm p p0i y u) (bothWritten s gm igm p p0i y z u).heap (element igm u) (.uint32 (square z p p0i))
      (GeneratorCubeIndex180.address (gWritten s gm p p0i y u) "igm" igm u (by omega) _ fixed.iBinding
        (.variable _ _ _ counter) (fixed.iAllocated u (by omega)))
      (mont (gWritten s gm p p0i y u) _ _ z z p p0i iv iv fixed.pCell fixed.iCell)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,bothWritten] using
        Word32Memory176.source (gWritten s gm p p0i y u).heap (element igm u) (square z p p0i) (fixed.iAllocated u (by omega)) fixed.iWidth fixed.iWritable)
  exact .scope ["v".toList] _ s ⟨bothWritten s gm igm p p0i y z u,.normal⟩
    (.seqNormal _ _ s (declared s) _ d (.seqNormal _ _ (declared s) (indexed s u) _ v
      (.seqNormal _ _ (indexed s u) (gWritten s gm p p0i y u) _ gStore
        (.seqNormal _ _ (gWritten s gm p p0i y u) (bothWritten s gm igm p p0i y z u) _ iStore
          (.base .skip _ _ (.skip _))))))

end FT1536.Source3.GeneratorSquareBody181
