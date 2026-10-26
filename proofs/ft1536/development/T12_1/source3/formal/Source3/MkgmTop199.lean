import Source3.MkgmSquareLoop199
import Source3.GeneratorTablePointer181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmTop199
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec Eval)
open KeygenMkgm3Program
open KeygenSmallOutput (element)
open KeygenModpR2Exec (Slot)
open MkgmSquare199 (Fixed)
open MkgmParams198 (Level half count)
open ModularAtoms178 (cell slot)

def denominator (w p r : BitVec 32) := KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add w w p) r p
def inverseWord (w p p0i r r2 : BitVec 32) := ModpDivTotal178.word r2 (denominator w p r) p p0i r

def gWritten (s : State) (gm : ArrayPointer) (w : BitVec 32) : State :=
  {s with heap:=Word32Memory176.write s.heap (element gm 0) w}
def withW (s : State) (gm : ArrayPointer) (w : BitVec 32) := bindValue (gWritten s gm w) "w".toList .uint32 (.uint32 w)
def after (s : State) (gm igm : ArrayPointer) (w p p0i r r2 : BitVec 32) : State :=
  {withW s gm w with heap:=Word32Memory176.write (withW s gm w).heap (element igm 0) (inverseWord w p p0i r r2)}

def thirdExpr : C99ModularReference.Expr := .call5 "modp_div".toList (KeygenMkgm3Program.cell "R2")
  (.call3 "modp_sub".toList
    (.call3 "modp_add".toList (KeygenMkgm3Program.cell "w") (KeygenMkgm3Program.cell "w") (KeygenMkgm3Program.cell "p"))
    (KeygenMkgm3Program.cell "R") (KeygenMkgm3Program.cell "p"))
  (KeygenMkgm3Program.cell "p") (KeygenMkgm3Program.cell "p0i") (KeygenMkgm3Program.cell "R")

theorem expression (s : State) (w p p0i r r2 : BitVec 32)
    (hw : Slot s "w" w) (hp : Slot s "p" p) (hi : Slot s "p0i" p0i)
    (hr : Slot s "R" r) (hr2 : Slot s "R2" r2) : Eval s thirdExpr (.uint32 (inverseWord w p p0i r r2)) :=
  .call5 _ _ _ _ _ _ _ _ _ _ _ _ (cell s "R2" r2 hr2)
    (.call3 _ _ _ _ _ _ _ _
      (.call3 _ _ _ _ _ _ _ _ (cell s "w" w hw) (cell s "w" w hw) (cell s "p" p hp)
        (.add _ _ (KeygenModpAddSub.source_exists .add w w p)))
      (cell s "R" r hr) (cell s "p" p hp)
      (.sub _ _ (KeygenModpAddSub.source_exists .sub (KeygenModpAddSub.result .add w w p) r p)))
    (cell s "p" p hp) (cell s "p0i" p0i hi) (cell s "R" r hr)
    (.div _ _ (ModpDivTotal178.source_exists s r2 (denominator w p r) p p0i r))

theorem source (l : Level) (s : State) (gm igm : ArrayPointer) (w p p0i r r2 : BitVec 32)
    (fixed : Fixed l s gm igm p p0i) (hr : Slot s "R" r) (hr2 : Slot s "R2" r2)
    (old : Option C99IntegerReference.Value) (declared : s.locals "w".toList=some (.uint32,old))
    (read : Load32 s.heap (element gm 1) w) :
    Exec (C99ModularReference.chainOf topElements) s ⟨after s gm igm w p p0i r r2,.normal⟩ := by
  have first : Exec (.store32 "gm".toList (num 0) (load "gm" (num 1))) s ⟨gWritten s gm w,.normal⟩ :=
    .store32 _ _ _ s (gWritten s gm w).heap (element gm 0) (.uint32 w)
      (GeneratorTablePointer181.literal s "gm" gm 0 (by decide) fixed.gBinding (fixed.gAllocated 0 (by have h:=MkgmParams198.half_range l; unfold count; omega)))
      (.load32 "gm".toList (num 1) (element gm 1) w
        (GeneratorTablePointer181.literal s "gm" gm 1 (by decide) fixed.gBinding (fixed.gAllocated 1 (by have h:=MkgmParams198.half_range l; unfold count; omega))) read)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,gWritten] using
        Word32Memory176.source s.heap (element gm 0) w (fixed.gAllocated 0 (by have h:=MkgmParams198.half_range l; unfold count; omega)) fixed.gWidth fixed.gWritable)
  have preserved : Load32 (gWritten s gm w).heap (element gm 1) w :=
    Word32Memory176.outside s.heap (element gm 0) (element gm 1) w w
      (Word32Memory176.separate gm fixed.gWidth (0 : Fin 1024) (1 : Fin 1024) (by decide)) read
  have second : Exec (.assign "w".toList (load "gm" (num 1))) (gWritten s gm w) ⟨withW s gm w,.normal⟩ :=
    .assign _ _ _ .uint32 old (.uint32 w) declared
      (.load32 "gm".toList (num 1) (element gm 1) w
        (GeneratorTablePointer181.literal (gWritten s gm w) "gm" gm 1 (by decide) fixed.gBinding (fixed.gAllocated 1 (by have h:=MkgmParams198.half_range l; unfold count; omega))) preserved)
  have third : Exec (.store32 "igm".toList (num 0) thirdExpr) (withW s gm w) ⟨after s gm igm w p p0i r r2,.normal⟩ :=
    .store32 _ _ _ (withW s gm w) (after s gm igm w p p0i r r2).heap (element igm 0) (.uint32 (inverseWord w p p0i r r2))
      (GeneratorTablePointer181.literal (withW s gm w) "igm" igm 0 (by decide) fixed.iBinding (fixed.iAllocated 0 (by have h:=MkgmParams198.half_range l; unfold count; omega)))
      (expression (withW s gm w) w p p0i r r2 (slot (gWritten s gm w) "w" w) fixed.pCell fixed.iCell hr hr2)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,after] using
        Word32Memory176.source (withW s gm w).heap (element igm 0) (inverseWord w p p0i r r2) (fixed.iAllocated 0 (by have h:=MkgmParams198.half_range l; unfold count; omega)) fixed.iWidth fixed.iWritable)
  exact .seqNormal _ _ s (gWritten s gm w) _ first (.seqNormal _ _ (gWritten s gm w) (withW s gm w) _ second
    (.seqNormal _ _ (withW s gm w) (after s gm igm w p p0i r r2) _ third (.base .skip _ _ (.skip _))))

end FT1536.Source3.MkgmTop199
