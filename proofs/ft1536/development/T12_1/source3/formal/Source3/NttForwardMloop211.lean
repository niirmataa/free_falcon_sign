import Source3.NttForwardRound211
import Source3.StepNttMloop195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardMloop211
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open NttForwardMiddle211 (MFixed)
open NttForwardImage211 (Image)
open StepNttMloop195 (mAfter m_step m_counter m_guard)

inductive Plan (size : Nat) : Nat → Nat → Nat → Prop where
  | done : Plan size 0 size 1
  | step (n m t h : Nat) (guard : 1 < t) (product : m*t=size) (half : t=2*h)
      (mBound : 2*m ≤ size) (tBound : t ≤ 256) (hBound : h ≤ 256)
      (rest : Plan size n (2*m) h) : Plan size (n+1) m t

theorem plan (l : MkgmParams198.Level) : Plan (MkgmParams198.count l) l.val 2 (MkgmParams198.half l) := by
  fin_cases l
  · exact .done
  · exact (.step 0 2 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) .done)
  · exact (.step 1 2 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 0 4 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) .done))
  · exact (.step 2 2 8 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 1 4 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 0 8 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) .done)))
  · exact (.step 3 2 16 8 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 2 4 8 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 1 8 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 0 16 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) .done))))
  · exact (.step 4 2 32 16 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 3 4 16 8 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 2 8 8 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 1 16 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 0 32 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) .done)))))
  · exact (.step 5 2 64 32 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 4 4 32 16 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 3 8 16 8 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 2 16 8 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 1 32 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 0 64 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) .done))))))
  · exact (.step 6 2 128 64 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 5 4 64 32 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 4 8 32 16 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 3 16 16 8 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 2 32 8 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 1 64 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 0 128 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) .done)))))))
  · exact (.step 7 2 256 128 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 6 4 128 64 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 5 8 64 32 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 4 16 32 16 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 3 32 16 8 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 2 64 8 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 1 128 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (.step 0 256 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) .done))))))))

variable {size : Nat}

theorem m_after_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (p pi : BitVec 32) (m : Nat) (fixed : MFixed (size:=size) s a gm gvs p pi) :
    MFixed (size:=size) (mAfter s m) a gm gvs p pi :=
  NttForwardMiddle211.fixed_map s a gm gvs p pi fixed (mAfter s m)
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set]) rfl rfl rfl

def walkWords {gmn : Nat} (gvs : Fin gmn → BitVec 32) :
    Nat → Nat → Nat → (Nat → BitVec 32) → BitVec 32 → BitVec 32 → Nat → BitVec 32
  | 0,_,_,W,_,_ => W
  | n+1,m,t,W,p,pi => walkWords gvs n (2*m) (t/2)
      (NttForwardU1Image211.roundWords gvs W m t (t/2) p pi) p pi

theorem source (n m t : Nat) (schedule : Plan size n m t) (s : State) (a gm : ArrayPointer)
    {gmn : Nat} (gvs : Fin gmn → BitVec 32) (p pi : BitVec 32) (W : Nat → BitVec 32) (wide : size ≤ gmn)
    (fixed : MFixed (size:=size) s a gm gvs p pi) (image : Image (size:=size) s a W)
    (mc : USlot s "m" m) (tc : USlot s "t" t) :
    ∃ out, Exec StepNttBody195.mWalk s ⟨out,.normal⟩ ∧ MFixed (size:=size) out a gm gvs p pi ∧
      USlot out "m" size ∧ USlot out "t" 1 ∧ NttWriteFrame182.Frame a size s.heap out.heap ∧
      Image (size:=size) out a (walkWords gvs n m t W p pi) := by
  induction schedule generalizing s W with
  | done =>
    exact ⟨s,.loopFalse _ _ _ s (.int32 0) (m_guard s 1 (by decide) tc fixed.fullSlot) rfl,
      fixed,mc,tc,NttWriteFrame182.refl a size s.heap,image⟩
  | step n m t h guard product half mb tb hb rest ih =>
    have sizeLimit:=fixed.sizeBound
    obtain ⟨middle,run,middleFixed,middleT,frame,middleImage⟩:=
      NttForwardRound211.m_body_image s a gm gvs p pi m t h W fixed image product half mb tb (by omega) wide mc tc
    have middleM : USlot middle "m" m := KeygenNttControl.keep_u64 run (by decide) "m" m (by decide) mc
    have update:=m_step middle m (by omega) middleM
    have nextFixed:=m_after_fixed middle a gm gvs p pi m middleFixed
    have nextM:=m_counter middle m (by omega)
    have nextT : USlot (mAfter middle m) "t" h := KeygenNttControl.keep_u64 update (by decide) "t" h (by decide) middleT
    obtain ⟨out,tail,finalFixed,finalM,finalT,frame2,finalImage⟩:=ih (mAfter middle m)
      (NttForwardU1Image211.roundWords gvs W m t h p pi) nextFixed (NttForwardImage211.image_keep middleImage rfl) nextM nextT
    refine ⟨out,?_,finalFixed,finalM,finalT,NttWriteFrame182.trans a size _ _ _ frame frame2,?_⟩
    · have nonzero : (C99ScalarReference.boolean (decide (1 < t))).integer≠0 := by
        simp [guard,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      exact .loopNormal _ _ _ s middle (mAfter middle m) ⟨out,.normal⟩ _ (m_guard s t (by omega) tc fixed.fullSlot)
        nonzero run update tail
    · simpa only [walkWords,show t/2=h by omega] using finalImage

end FT1536.Source3.NttForwardMloop211
