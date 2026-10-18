import Source3.NttU1Loop183
import Source3.C99OuterScalar144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttMBody183
open C99ArrayReference (State bindValue restoreScope)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open NttFirstFixed182 (Fixed)

def names := ["ht","u1","v1"].map String.toList
def declared (s : State) := C99DeclarationStatements.effect .u64 names s
def prepared (s : State) (h : Nat) := bindValue (declared s) "ht".toList .uint64 (u64 h)
def code := KeygenNttForwardPrograms.block KeygenNttForwardPrograms.mInner

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (h : Nat) (f : Fixed s a gm p p0i w) :
    Fixed (prepared s h) a gm p p0i w :=
  ⟨f.pCell,f.iCell,f.wCell,f.nCell,f.hnCell,f.stride,f.aBinding,f.gmBinding,f.width,f.capacity,f.allocated,f.writable,f.initialized⟩

theorem source (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (m t h : Nat)
    (f : Fixed s a gm p p0i w) (mt : m*t=1536) (th : t=2*h) (mb : m≤512) (tb : t≤768) (hb : h≤768)
    (sep : NttMiddleTable183.Separate a gm) (reads : NttMiddleTable183.Reads s.heap gm)
    (mc : USlot s "m" m) (tc : USlot s "t" t) :
    ∃ out, Exec code s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧ USlot out "t" h ∧
      NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  have dc : Exec (KeygenNttForwardPrograms.sizeDeclaration ["ht","u1","v1"]) s ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 names s)
  have half : t/2=h := by omega
  have hc : USlot (prepared s h) "ht" h := KeygenMkgm3RowInit.set64_slot (declared s) "ht" h (by omega)
  have halfRun : Exec KeygenNttForwardPrograms.htAssign (declared s) ⟨prepared s h,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 h) rfl (.scalar _ _
      (by simpa only [half,KeygenNttForwardPrograms.var,KeygenNttForwardPrograms.num,KeygenNttLoopSupport.u64,C99NatWord141.word] using (C99OuterScalar144.half_eval (declared s) "t".toList t (by omega) tc)))
  obtain ⟨vo,vRun,vFixed,vu,frame⟩ := NttU1Loop183.full m t h mt th mb tb hb (prepared s h) a gm p p0i w
    (fixed s a gm p p0i w h f) sep reads mc tc hc none none rfl rfl
  have htOut : USlot vo "ht" h := KeygenNttControl.keep_u64 vRun (by decide) "ht" h (by decide) hc
  have tOut : USlot vo "t" t := KeygenNttControl.keep_u64 vRun (by decide) "t" t (by decide) tc
  let fin := bindValue vo "t".toList .uint64 (u64 h)
  have tRun : Exec KeygenNttForwardPrograms.tFromHalf2 vo ⟨fin,.normal⟩ :=
    .assign _ _ _ .uint64 (some (u64 t)) (u64 h) tOut (.scalar _ _ (.variable _ _ _ htOut))
  have inner : Exec KeygenNttForwardPrograms.mInner s ⟨fin,.normal⟩ :=
    .seqNormal _ _ s (declared s) _ dc (.seqNormal _ _ (declared s) (prepared s h) _ halfRun
      (.seqNormal _ _ (prepared s h) vo _ vRun (.seqNormal _ _ vo fin _ tRun (.base .skip fin fin (.skip fin)))))
  let out := restoreScope s fin names []
  have run : Exec code s ⟨out,.normal⟩ := .scope names _ s ⟨fin,.normal⟩ inner
  have control := KeygenNttControl.frame code s ⟨out,.normal⟩ (by decide) run
  have fo : Fixed out a gm p p0i w :=
    ⟨(control.2.1 "p".toList (by decide)).trans f.pCell,
     (control.2.1 "p0i".toList (by decide)).trans f.iCell,
     (control.2.1 "w".toList (by decide)).trans f.wCell,
     (control.2.1 "n".toList (by decide)).trans f.nCell,
     (control.2.1 "hn".toList (by decide)).trans f.hnCell,
     (control.2.1 "stride".toList (by decide)).trans f.stride,
     (control.2.2 "a".toList (by decide)).trans f.aBinding,
     (control.2.2 "gm".toList (by decide)).trans f.gmBinding,
     f.width,f.capacity,vFixed.allocated,vFixed.writable,vFixed.initialized⟩
  have ht : USlot out "t" h := KeygenMkgm3RowInit.set64_slot vo "t" h (by omega)
  exact ⟨out,run,fo,ht,frame⟩

end FT1536.Source3.NttMBody183
