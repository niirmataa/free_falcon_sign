import Source3.MkgmRowStore198

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmRowBody198
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenMkgm3Program
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open MkgmRowFixed198 (Fixed)
open MkgmParams198 (Level half)
open ModularAtoms178 (set cell assign mont slot)

def mul (a b p p0i : BitVec 32) := KeygenModpWord.montgomery a b p p0i
def nextX (x g2 g4 p p0i : BitVec 32) := mul (mul x g4 p p0i) g2 p p0i
def nextIX (ix ig2 ig4 p p0i : BitVec 32) := mul (mul ix ig4 p p0i) ig2 p p0i
structure States where
  a : State
  b : State
  c : State
  d : State
  e : State
  f : State
  g : State
  h : State

def states (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) : States :=
  let a := MkgmRowStore198.after l s gm u x
  let b := MkgmRowStore198.after l a igm u ix
  let c := set b "x" (mul x g4 p p0i)
  let d := set c "ix" (mul ix ig4 p p0i)
  let e := MkgmRowStore198.after l d gm (u+1) (mul x g4 p p0i)
  let f := MkgmRowStore198.after l e igm (u+1) (mul ix ig4 p p0i)
  let g := set f "x" (nextX x g2 g4 p p0i)
  let h := set g "ix" (nextIX ix ig2 ig4 p p0i)
  ⟨a,b,c,d,e,f,g,h⟩

def after (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) :=
  (states l s gm igm p p0i g2 g4 ig2 ig4 x ix u).h

theorem source (l : Level) (s : State) (gm igm rev : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32)
    (u : Nat) (bound : u+1<half l) (fixed : Fixed l s gm igm rev p p0i g2 g4 ig2 ig4)
    (hx : Slot s "x" x) (hi : Slot s "ix" ix) (counter : USlot s "u" u) :
    Exec lastRowBody s ⟨after l s gm igm p p0i g2 g4 ig2 ig4 x ix u,.normal⟩ := by
  let st := states l s gm igm p p0i g2 g4 ig2 ig4 x ix u
  have aRun : Exec (storeRev "gm" revIndex (KeygenMkgm3Program.cell "x")) s ⟨st.a,.normal⟩ :=
    MkgmRowStore198.source l s "gm" gm rev revIndex _ u x (by omega) fixed.gBinding fixed.table fixed.bCell
      (MkgmRowIndex198.first l s u (by omega) counter fixed.kCell) (cell s "x" x hx)
      (fixed.gAllocated _ (MkgmParams198.last_range l u (by omega)).2) fixed.gWidth fixed.gWritable
  have fa := MkgmRowFixed198.transported l _ s ⟨st.a,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4 fixed (by decide) (by decide) aRun
  have bRun : Exec (storeRev "igm" revIndex (KeygenMkgm3Program.cell "ix")) st.a ⟨st.b,.normal⟩ :=
    MkgmRowStore198.source l st.a "igm" igm rev revIndex _ u ix (by omega) fa.iBinding fa.table fa.bCell
      (MkgmRowIndex198.first l st.a u (by omega) counter fa.kCell) (cell st.a "ix" ix hi)
      (fa.iAllocated _ (MkgmParams198.last_range l u (by omega)).2) fa.iWidth fa.iWritable
  have fb := MkgmRowFixed198.transported l _ st.a ⟨st.b,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4 fa (by decide) (by decide) bRun
  have cRun : Exec (.assign "x".toList montXG4) st.b ⟨st.c,.normal⟩ :=
    assign st.b "x" (some (.uint32 x)) _ (mul x g4 p p0i) hx
      (mont st.b _ _ x g4 p p0i (cell st.b "x" x hx) (cell st.b "g4" g4 fb.g4Cell) fb.pCell fb.iCell)
  have fc := MkgmRowFixed198.transported l _ st.b ⟨st.c,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4 fb (by decide) (by decide) cRun
  have dRun : Exec (.assign "ix".toList montIXIG4) st.c ⟨st.d,.normal⟩ :=
    assign st.c "ix" (some (.uint32 ix)) _ (mul ix ig4 p p0i) hi
      (mont st.c _ _ ix ig4 p p0i (cell st.c "ix" ix hi) (cell st.c "ig4" ig4 fc.ig4Cell) fc.pCell fc.iCell)
  have fd := MkgmRowFixed198.transported l _ st.c ⟨st.d,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4 fc (by decide) (by decide) dRun
  have x4 : Slot st.d "x" (mul x g4 p p0i) :=
    (ModularAtoms178.outside st.c "ix" "x" (mul ix ig4 p p0i) (by decide)).trans (slot st.b "x" _)
  have ix4 : Slot st.d "ix" (mul ix ig4 p p0i) := slot st.c "ix" _
  have eRun : Exec (storeRev "gm" revIndexNext (KeygenMkgm3Program.cell "x")) st.d ⟨st.e,.normal⟩ :=
    MkgmRowStore198.source l st.d "gm" gm rev revIndexNext _ (u+1) (mul x g4 p p0i) bound fd.gBinding fd.table fd.bCell
      (MkgmRowIndex198.next l st.d u bound counter fd.kCell) (cell st.d "x" _ x4)
      (fd.gAllocated _ (MkgmParams198.last_range l (u+1) bound).2) fd.gWidth fd.gWritable
  have fe := MkgmRowFixed198.transported l _ st.d ⟨st.e,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4 fd (by decide) (by decide) eRun
  have fRun : Exec (storeRev "igm" revIndexNext (KeygenMkgm3Program.cell "ix")) st.e ⟨st.f,.normal⟩ :=
    MkgmRowStore198.source l st.e "igm" igm rev revIndexNext _ (u+1) (mul ix ig4 p p0i) bound fe.iBinding fe.table fe.bCell
      (MkgmRowIndex198.next l st.e u bound counter fe.kCell) (cell st.e "ix" _ ix4)
      (fe.iAllocated _ (MkgmParams198.last_range l (u+1) bound).2) fe.iWidth fe.iWritable
  have ff := MkgmRowFixed198.transported l _ st.e ⟨st.f,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4 fe (by decide) (by decide) fRun
  have gRun : Exec (.assign "x".toList montXG2) st.f ⟨st.g,.normal⟩ :=
    assign st.f "x" (some (.uint32 (mul x g4 p p0i))) _ (nextX x g2 g4 p p0i) x4
      (mont st.f _ _ _ g2 p p0i (cell st.f "x" _ x4) (cell st.f "g2" g2 ff.g2Cell) ff.pCell ff.iCell)
  have fg := MkgmRowFixed198.transported l _ st.f ⟨st.g,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4 ff (by decide) (by decide) gRun
  have hRun : Exec (.assign "ix".toList montIXIG2) st.g ⟨st.h,.normal⟩ :=
    assign st.g "ix" (some (.uint32 (mul ix ig4 p p0i))) _ (nextIX ix ig2 ig4 p p0i) ix4
      (mont st.g _ _ _ ig2 p p0i (cell st.g "ix" _ ix4) (cell st.g "ig2" ig2 fg.ig2Cell) fg.pCell fg.iCell)
  exact .seqNormal _ _ s st.a _ aRun (.seqNormal _ _ st.a st.b _ bRun
    (.seqNormal _ _ st.b st.c _ cRun (.seqNormal _ _ st.c st.d _ dRun
      (.seqNormal _ _ st.d st.e _ eRun (.seqNormal _ _ st.e st.f _ fRun
        (.seqNormal _ _ st.f st.g _ gRun (.seqNormal _ _ st.g st.h _ hRun
          (.base .skip st.h st.h (.skip st.h)))))))))

theorem x_after (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) :
    Slot (after l s gm igm p p0i g2 g4 ig2 ig4 x ix u) "x" (nextX x g2 g4 p p0i) :=
  (ModularAtoms178.outside _ "ix" "x" (nextIX ix ig2 ig4 p p0i) (by decide)).trans (slot _ "x" _)

theorem ix_after (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) :
    Slot (after l s gm igm p p0i g2 g4 ig2 ig4 x ix u) "ix" (nextIX ix ig2 ig4 p p0i) := slot _ "ix" _

theorem u_after (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) :
    (after l s gm igm p p0i g2 g4 ig2 ig4 x ix u).locals "u".toList=s.locals "u".toList := rfl

end FT1536.Source3.MkgmRowBody198
