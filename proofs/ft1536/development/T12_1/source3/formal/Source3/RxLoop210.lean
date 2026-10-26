import Source3.RxBody210

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RxLoop210
open C99ArrayReference (State Name)
open C99ModularReference (GenExec LeafCall)
open KeygenModpR2Exec (Slot)
open RxControl210 (ISlot setI bit)
open RxModel210 (loopWord mont chosen)
open RxBody210 (Run after)

theorem source (fuel i : Nat) (finish : i+fuel=10) (s : State) (x z r p pi : BitVec 32)
    (xb : x.toNat < 1024) (ic : ISlot s i) (xc : Slot s "x" x) (zc : Slot s "z" z) (rc : Slot s "r" r)
    (pc : Slot s "p" p) (pic : Slot s "p0i" pi) :
    ∃ out, Run KeygenModpRxExec.loopRun s ⟨out,.normal⟩ ∧ Slot out "z" (loopWord fuel i x z r p pi) ∧
      out.heap=s.heap ∧ out.arrays=s.arrays ∧
      (∀ name : Name, name≠"i".toList → name≠"r".toList → name≠"z".toList → out.locals name=s.locals name) := by
  induction fuel generalizing i s z r with
  | zero =>
    have same : i=10 := by omega
    subst i
    have no : ¬(bit 10).toNat ≤ x.toNat := by change ¬1024 ≤ x.toNat; omega
    have test : C99ArrayReference.scalar s C99ModularReference.rxLoopGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean,no] using RxControl210.guard s 10 x (by decide) ic xc
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) test (by decide),zc,rfl,rfl,fun _ _ _ _ => rfl⟩
  | succ fuel ih =>
    have bound : i < 10 := by omega
    have test:=RxControl210.guard s i x (by omega) ic xc
    by_cases active : (bit i).toNat ≤ x.toNat
    · have trueTest : C99ArrayReference.scalar s C99ModularReference.rxLoopGuard (.int32 1) := by
        simpa [C99ScalarReference.boolean,active] using test
      have body:=RxBody210.source s x i z r p pi bound ic xc zc rc pc pic
      have hl:=RxBody210.locals s x i z r p pi
      have bodyI : ISlot (after s x i z r p pi) i := (hl "i".toList (by decide) (by decide)).trans ic
      have update:=RxControl210.increment (after s x i z r p pi) i bound bodyI
      have bodyX : Slot (after s x i z r p pi) "x" x := (hl "x".toList (by decide) (by decide)).trans xc
      have bodyP : Slot (after s x i z r p pi) "p" p := (hl "p".toList (by decide) (by decide)).trans pc
      have bodyPi : Slot (after s x i z r p pi) "p0i" pi := (hl "p0i".toList (by decide) (by decide)).trans pic
      have nextX : Slot (setI (after s x i z r p pi) (i+1)) "x" x :=
        (RxControl210.i_outside (after s x i z r p pi) (i+1) "x".toList (by decide)).trans bodyX
      have nextP : Slot (setI (after s x i z r p pi) (i+1)) "p" p :=
        (RxControl210.i_outside (after s x i z r p pi) (i+1) "p".toList (by decide)).trans bodyP
      have nextPi : Slot (setI (after s x i z r p pi) (i+1)) "p0i" pi :=
        (RxControl210.i_outside (after s x i z r p pi) (i+1) "p0i".toList (by decide)).trans bodyPi
      have nextZ : Slot (setI (after s x i z r p pi) (i+1)) "z" (chosen x i z r p pi) :=
        (RxControl210.i_outside (after s x i z r p pi) (i+1) "z".toList (by decide)).trans (RxBody210.zCell s x i z r p pi zc)
      have nextR : Slot (setI (after s x i z r p pi) (i+1)) "r" (mont r r p pi) :=
        (RxControl210.i_outside (after s x i z r p pi) (i+1) "r".toList (by decide)).trans (RxBody210.rCell s x i z r p pi)
      obtain ⟨out,rest,finalZ,heap,arrays,locals⟩:=ih (i+1) (by omega) (setI (after s x i z r p pi) (i+1))
        (chosen x i z r p pi) (mont r r p pi) (RxControl210.i_cell _ _) nextX nextZ nextR nextP nextPi
      refine ⟨out,.loopNormal _ _ _ s (after s x i z r p pi) (setI (after s x i z r p pi) (i+1))
        ⟨out,.normal⟩ (.int32 1) trueTest (by decide) body update rest,?_,
        heap.trans (RxBody210.heap s x i z r p pi),arrays.trans (RxBody210.arrays s x i z r p pi),?_⟩
      · simpa only [loopWord,ite_eq_left active] using finalZ
      · intro name ni nr nz
        exact (locals name ni nr nz).trans ((RxControl210.i_outside (after s x i z r p pi) (i+1) name ni).trans (hl name nz nr))
    · have falseTest : C99ArrayReference.scalar s C99ModularReference.rxLoopGuard (.int32 0) := by
        simpa [C99ScalarReference.boolean,active] using test
      refine ⟨s,.loopFalse _ _ _ _ (.int32 0) falseTest (by decide),?_,rfl,rfl,fun _ _ _ _ => rfl⟩
      simpa only [loopWord,ite_eq_right active] using zc

end FT1536.Source3.RxLoop210
