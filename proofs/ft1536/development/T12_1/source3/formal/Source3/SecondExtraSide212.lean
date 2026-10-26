import Source3.SecondExtraGeometry212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraSide212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open SecondStepBasic203 (Basic)
open SecondStepCopy203 (Side)
open SecondStepLayout197 (t1 gm)
open StepCopyBody190 (elem)
open SecondExtraGeometry212 (Outside)
open ZintNormWalkFlat208 (Data)

def code (side : Side) : KeygenMakeFgSource.Stmt :=
  .seq (SecondExtraWalk212.code side) (.seq MakeFgAddPrimeShape194.nttBranch (SecondExtraProduct212.code side))
 def reduced (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32) (i : Fin 256) := SignedWalkFixed212.words W 2 i.val p pi r2 rx
 noncomputable def words (W : Nat → BitVec 32) (gvs : Fin 256 → BitVec 32) (p pi r2 rx : BitVec 32) :=
  NttForwardWhole211.words 7 (reduced W p pi r2 rx) gvs p pi

theorem source (side : Side) (s : State) (p pi r2 rx : BitVec 32) (W : Nat → BitVec 32) (gvs : Fin 256 → BitVec 32)
    (h : Basic s 2 p pi r2) (rxCell : Slot s "Rx" rx) (data : Data s (SecondStepCopy203.root side) 512 W)
    (gloads : ∀ i, Load32 s.heap (elem gm i.val) (gvs i))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (code side) s ⟨out,.normal⟩ ∧ Basic out 2 p pi r2 ∧ Slot out "Rx" rx ∧ Cell out "v".toList 128 ∧
      StepProductFixed203.Image out (SecondExtraProduct212.root side) 2 3 128 p pi r2 (words W gvs p pi r2 rx) 128 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, Outside side q → Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨walk,wrun,wb,wrx,wv,wimage,wls,was,wkeep⟩:=SecondExtraWalk212.source side s p pi r2 rx W h rxCell data old declared
  have wg (i : Fin 256) : Load32 walk.heap (elem gm i.val) (gvs i) :=
    wkeep _ _ (SecondExtraGeometry212.twiddle side i).1 (gloads i)
  obtain ⟨transformed,trun,tb,timage,tls,tas,tkeep⟩:=SecondExtraForward212.source walk p pi r2 (reduced W p pi r2 rx) gvs wb
    (fun i => wimage i.val i.isLt) wg
  have tv : Cell transformed "v".toList 256 := (congrFun tls "v".toList).trans wv
  obtain ⟨out,prun,pb,pv,pimage,pls,pas,pkeep⟩:=SecondExtraProduct212.source side transformed 2 p pi r2 tb (by decide)
    (words W gvs p pi r2 rx) (fun i => timage i.val i.isLt) (some (.uint64 (C99NatWord141.word 256))) tv
  have ls (name : Name) (different : name≠"v".toList) : out.locals name=s.locals name :=
    (pls name different).trans ((congrFun tls name).trans (wls name different))
  have ars (name : Name) (different : name≠"x".toList) : out.arrays name=s.arrays name :=
    (pas name different).trans ((congrFun tas name).trans (was name different))
  refine ⟨out,.seqNormal _ _ _ _ _ wrun (.seqNormal _ _ _ _ _ trun prun),pb,(ls _ (by decide)).trans rxCell,pv,pimage,ls,ars,?_⟩
  intro q old outside loaded
  exact pkeep q outside.2.2 old (tkeep q old outside.2.1 (wkeep q old outside.1 loaded))

end FT1536.Source3.SecondExtraSide212
