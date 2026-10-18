import Source3.GeneratorCubeIndex180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorCubeBody180
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenMkgm3Program
open KeygenSmallOutput (element)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open GeneratorCubeFixed180 (Fixed)
open ModularAtoms178 (set cell assign mont slot)

def cube (word p p0i : BitVec 32) := KeygenModpWord.montgomery word (KeygenModpWord.montgomery word word p p0i) p p0i
structure States where
  declared : State
  y0 : State
  z0 : State
  y3 : State
  z3 : State
  storedG : State
  storedI : State

def states (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat) : States :=
  let declared := C99DeclarationStatements.effect .u32 ["y".toList,"z".toList] s
  let y0 := set declared "y" y
  let z0 := set y0 "z" z
  let y3 := set z0 "y" (cube y p p0i)
  let z3 := set y3 "z" (cube z p p0i)
  let storedG := {z3 with heap:=Word32Memory176.write z3.heap (element gm u) (cube y p p0i)}
  let storedI := {storedG with heap:=Word32Memory176.write storedG.heap (element igm u) (cube z p p0i)}
  ⟨declared,y0,z0,y3,z3,storedG,storedI⟩

def after (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat) :=
  restoreScope s (states s gm igm p p0i y z u).storedI ["y".toList,"z".toList] []

theorem source (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat)
    (lo : 256 ≤ u) (hi : u < 512) (fixed : Fixed s gm igm p p0i) (counter : USlot s "u" u)
    (gRead : Load32 s.heap (element gm (2*u)) y) (iRead : Load32 s.heap (element igm (2*u)) z) :
    Exec cubeBody s ⟨after s gm igm p p0i y z u,.normal⟩ := by
  let st := states s gm igm p p0i y z u
  have d : Exec (wordDecl ["y","z"]) s ⟨st.declared,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 ["y".toList,"z".toList] s)
  have yRun : Exec (.assign "y".toList (load "gm" GeneratorCubeIndex180.twice)) st.declared ⟨st.y0,.normal⟩ :=
    assign _ "y" none _ y rfl (.load32 "gm".toList _ (element gm (2*u)) y
      (GeneratorCubeIndex180.address st.declared "gm" gm (2*u) (by omega) _ fixed.gBinding
        (GeneratorCubeIndex180.doubled st.declared u hi counter) (fixed.gAllocated _ (by omega))) gRead)
  have zRun : Exec (.assign "z".toList (load "igm" GeneratorCubeIndex180.twice)) st.y0 ⟨st.z0,.normal⟩ :=
    assign _ "z" none _ z rfl (.load32 "igm".toList _ (element igm (2*u)) z
      (GeneratorCubeIndex180.address st.y0 "igm" igm (2*u) (by omega) _ fixed.iBinding
        (GeneratorCubeIndex180.doubled st.y0 u hi counter) (fixed.iAllocated _ (by omega))) iRead)
  have yCell : Slot st.z0 "y" y :=
    (ModularAtoms178.outside st.y0 "z" "y" z (by decide)).trans (slot st.declared "y" y)
  have zCell : Slot st.z0 "z" z := slot st.y0 "z" z
  have cy : Exec (.assign "y".toList (KeygenMkgm3Program.mont (KeygenMkgm3Program.cell "y") montYY)) st.z0 ⟨st.y3,.normal⟩ :=
    assign _ "y" (some (.uint32 y)) _ (cube y p p0i) yCell
      (mont st.z0 _ _ y _ p p0i (cell st.z0 "y" y yCell)
        (mont st.z0 _ _ y y p p0i (cell st.z0 "y" y yCell) (cell st.z0 "y" y yCell) fixed.pCell fixed.iCell)
        fixed.pCell fixed.iCell)
  have zCellY : Slot st.y3 "z" z :=
    (ModularAtoms178.outside st.z0 "y" "z" (cube y p p0i) (by decide)).trans zCell
  have cz : Exec (.assign "z".toList (KeygenMkgm3Program.mont (KeygenMkgm3Program.cell "z") montZZ)) st.y3 ⟨st.z3,.normal⟩ :=
    assign _ "z" (some (.uint32 z)) _ (cube z p p0i) zCellY
      (mont st.y3 _ _ z _ p p0i (cell st.y3 "z" z zCellY)
        (mont st.y3 _ _ z z p p0i (cell st.y3 "z" z zCellY) (cell st.y3 "z" z zCellY) fixed.pCell fixed.iCell)
        fixed.pCell fixed.iCell)
  have cubedY : Slot st.z3 "y" (cube y p p0i) :=
    (ModularAtoms178.outside st.y3 "z" "y" (cube z p p0i) (by decide)).trans (slot st.z0 "y" _)
  have cubedZ : Slot st.z3 "z" (cube z p p0i) := slot st.y3 "z" _
  have storeG : Exec (.store32 "gm".toList (var "u") (KeygenMkgm3Program.cell "y")) st.z3 ⟨st.storedG,.normal⟩ :=
    .store32 _ _ _ st.z3 st.storedG.heap (element gm u) (.uint32 (cube y p p0i))
      (GeneratorCubeIndex180.address st.z3 "gm" gm u (by omega) _ fixed.gBinding (.variable _ _ _ counter) (fixed.gAllocated u (by omega)))
      (cell st.z3 "y" _ cubedY)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,st,states] using
        Word32Memory176.source st.z3.heap (element gm u) (cube y p p0i) (fixed.gAllocated u (by omega)) fixed.gWidth fixed.gWritable)
  have storeI : Exec (.store32 "igm".toList (var "u") (KeygenMkgm3Program.cell "z")) st.storedG ⟨st.storedI,.normal⟩ :=
    .store32 _ _ _ st.storedG st.storedI.heap (element igm u) (.uint32 (cube z p p0i))
      (GeneratorCubeIndex180.address st.storedG "igm" igm u (by omega) _ fixed.iBinding (.variable _ _ _ counter) (fixed.iAllocated u (by omega)))
      (cell st.storedG "z" _ cubedZ)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,st,states] using
        Word32Memory176.source st.storedG.heap (element igm u) (cube z p p0i) (fixed.iAllocated u (by omega)) fixed.iWidth fixed.iWritable)
  exact .scope ["y".toList,"z".toList] _ s ⟨st.storedI,.normal⟩
    (.seqNormal _ _ s st.declared _ d (.seqNormal _ _ st.declared st.y0 _ yRun
      (.seqNormal _ _ st.y0 st.z0 _ zRun (.seqNormal _ _ st.z0 st.y3 _ cy
        (.seqNormal _ _ st.y3 st.z3 _ cz (.seqNormal _ _ st.z3 st.storedG _ storeG
          (.seqNormal _ _ st.storedG st.storedI _ storeI (.base .skip _ _ (.skip _)))))))))

end FT1536.Source3.GeneratorCubeBody180
