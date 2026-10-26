import Source3.StepNttVImage195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/-! # The executed word image of the full u1 loop

Compose the accepted single-block image in source order. Block j walks
the pairs (j*t+v,j*t+h+v) and loads the actual table word at m+j.
The u1/v1 increment and initialization preserve the heap. The same
existential output witnesses execution, frame and all 512 image words.
Rounds, the m-walk and the product bridge remain separate obligations.
-/
namespace FT1536.Source3.StepNttU1Image195
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot)
open StepNttImage195 (Image)
open StepNttVImage195 (blockWords)
open StepNttMiddle195

/-- Total notation for a table word; every executed index is proved in range. -/
def tableWord {gmn : Nat} (gvs : Fin gmn → BitVec 32) (k : Nat) : BitVec 32 :=
  if bound : k<gmn then gvs ⟨k,bound⟩ else 0

theorem tableWord_eq {gmn : Nat} (gvs : Fin gmn → BitVec 32) (k : Nat) (bound : k<gmn) :
    tableWord gvs k=gvs ⟨k,bound⟩ := by
  simp only [tableWord, dite_eq_left bound]

/-- Execute n remaining u1 blocks, beginning at j, in source order. -/
def u1Words {gmn : Nat} (gvs : Fin gmn → BitVec 32) :
    Nat → Nat → Nat → Nat → Nat → (Nat → BitVec 32) →
    BitVec 32 → BitVec 32 → Nat → BitVec 32
  | 0, _, _, _, _, W, _, _ => W
  | n+1, j, m, t, h, W, pw, p0i =>
      u1Words gvs n (j+1) m t h
        (blockWords W (j*t) h (tableWord gvs (m+j)) pw p0i) pw p0i

/-- All m blocks of this round, with u1 and v1 initially zero. -/
def roundWords {gmn : Nat} (gvs : Fin gmn → BitVec 32) (W : Nat → BitVec 32)
    (m t h : Nat) (pw p0i : BitVec 32) : Nat → BitVec 32 :=
  u1Words gvs m 0 m t h W pw p0i

theorem u1_loop_image (n j m t h : Nat) (count : j+n=m) (mt : m*t=512) (th : t=2*h)
    (mb : m≤256) (tb : t≤256) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (W : Nat → BitVec 32) (wide : 512≤gmn)
    (fixed : MFixed s a gm gvs pw p0i) (image : Image s a W)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (hc : USlot s "ht" h)
    (jc : USlot s "u1" j) (lc : USlot s "v1" (j*t)) :
    ∃ out, Exec u1LoopCode s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧
      USlot out "u1" m ∧ NttWriteFrame182.Frame a 512 s.heap out.heap ∧
      Image out a (u1Words gvs n j m t h W pw p0i) := by
  induction n generalizing j s W with
  | zero =>
      have equal : j=m := by omega
      subst j
      exact ⟨s,.loopFalse _ _ _ s (C99ScalarReference.boolean (decide (m<m)))
        (C99LoopScalar141.less s (.var "u1".toList) (.var "m".toList) m m (by omega) (by omega)
          (.variable _ _ _ jc) (.variable _ _ _ mc))
        (by simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer]),
        fixed,jc,NttWriteFrame182.refl a 512 s.heap,image⟩
  | succ n ih =>
      have bound : j<m := by omega
      have product : (j+1)*t≤512 := by
        rw [←mt]
        exact Nat.mul_le_mul_right t (by omega)
      have range : j*t+2*h≤512 := by
        rw [Nat.add_mul,Nat.one_mul] at product
        omega
      have fit : m+j<gmn := by omega
      have fit2 : m+j<1024 := by omega
      let words := blockWords W (j*t) h (tableWord gvs (m+j)) pw p0i
      obtain ⟨middle,iteration,middleFixed,memory,locals,middleImage⟩ :=
        StepNttVImage195.u1_body_image s a gm gvs pw p0i m j (j*t) h W
          fixed image range hpos fit fit2 mc jc lc hc
      have wordsImage : Image middle a words := by
        simpa only [words,tableWord_eq gvs (m+j) fit] using middleImage
      have update : Exec KeygenNttForwardPrograms.u1Step middle
          ⟨u1StepAfter middle j (j*t) t,.normal⟩ :=
        u1_step middle j (j*t) t (by omega) (by omega) tb
          ((congrFun locals _).trans jc) ((congrFun locals _).trans lc) ((congrFun locals _).trans tc)
      have nextImage : Image (u1StepAfter middle j (j*t) t) a words :=
        StepNttImage195.image_keep wordsImage rfl
      have nextPos : USlot (u1StepAfter middle j (j*t) t) "v1" ((j+1)*t) := by
        simpa only [Nat.add_mul,Nat.one_mul] using u1_position middle j (j*t) t (by omega)
      obtain ⟨out,rest,fo,jo,frame,outImage⟩ := ih (j+1) (by omega)
        (u1StepAfter middle j (j*t) t) words
        (u1_step_fixed middle a gm gvs pw p0i j (j*t) t middleFixed) nextImage
        ((congrFun locals _).trans mc) ((congrFun locals _).trans tc) ((congrFun locals _).trans hc)
        (u1_counter middle j (j*t) t (by omega)) nextPos
      refine ⟨out,?_,fo,jo,NttWriteFrame182.trans a 512 _ _ _ memory frame,outImage⟩
      have nonzero : (C99ScalarReference.boolean (decide (j<m))).integer≠0 := by
        simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      exact .loopNormal _ _ _ s middle (u1StepAfter middle j (j*t) t) ⟨out,.normal⟩ _
        (C99LoopScalar141.less s (.var "u1".toList) (.var "m".toList) j m (by omega) (by omega)
          (.variable _ _ _ jc) (.variable _ _ _ mc)) nonzero iteration update rest

theorem u1_loop_full_image (m t h : Nat) (mt : m*t=512) (th : t=2*h)
    (mb : m≤256) (tb : t≤256) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (W : Nat → BitVec 32) (wide : 512≤gmn)
    (fixed : MFixed s a gm gvs pw p0i) (image : Image s a W)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (hc : USlot s "ht" h)
    (oldU oldV : Option Value)
    (du : s.locals "u1".toList=some (.uint64,oldU))
    (dv : s.locals "v1".toList=some (.uint64,oldV)) :
    ∃ out, Exec KeygenNttForwardPrograms.u1Loop s ⟨out,.normal⟩ ∧
      MFixed out a gm gvs pw p0i ∧ USlot out "u1" m ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap ∧
      Image out a (roundWords gvs W m t h pw p0i) := by
  obtain ⟨out,run,fo,jo,frame,words⟩ := u1_loop_image m 0 m t h (Nat.zero_add m) mt th mb tb hpos
    (u1Initial s) a gm gvs pw p0i W wide (u1_initial_fixed s a gm gvs pw p0i fixed)
    (StepNttImage195.image_keep image rfl) mc tc hc rfl
    (by simp only [Nat.zero_mul]; rfl)
  exact ⟨out,.seqNormal _ _ s (u1Initial s) _ (u1_init s oldU oldV du dv) run,fo,jo,frame,words⟩

end FT1536.Source3.StepNttU1Image195
