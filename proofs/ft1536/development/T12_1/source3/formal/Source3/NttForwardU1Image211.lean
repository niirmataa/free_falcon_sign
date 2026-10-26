import Source3.NttForwardVImage211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generic-size exact u1 word-image composition; sealed195 unchanged. -/
namespace FT1536.Source3.NttForwardU1Image211
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot)
open NttForwardImage211 (Image)
open NttForwardVImage211 (blockWords)
open NttForwardMiddle211

variable {size : Nat}

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

theorem u1_loop_image (n j m t h : Nat) (count : j+n=m) (mt : m*t=size) (th : t=2*h)
    (mb : 2*m≤size) (tb : t≤256) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (W : Nat → BitVec 32) (wide : size≤gmn)
    (fixed : MFixed (size:=size) s a gm gvs pw p0i) (image : Image (size:=size) s a W)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (hc : USlot s "ht" h)
    (jc : USlot s "u1" j) (lc : USlot s "v1" (j*t)) :
    ∃ out, Exec u1LoopCode s ⟨out,.normal⟩ ∧ MFixed (size:=size) out a gm gvs pw p0i ∧
      USlot out "u1" m ∧ NttWriteFrame182.Frame a size s.heap out.heap ∧
      Image (size:=size) out a (u1Words gvs n j m t h W pw p0i) := by
  have sizeLimit:=fixed.sizeBound
  induction n generalizing j s W with
  | zero =>
      have equal : j=m := by omega
      subst j
      exact ⟨s,.loopFalse _ _ _ s (C99ScalarReference.boolean (decide (m<m)))
        (C99LoopScalar141.less s (.var "u1".toList) (.var "m".toList) m m (by omega) (by omega)
          (.variable _ _ _ jc) (.variable _ _ _ mc))
        (by simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer]),
        fixed,jc,NttWriteFrame182.refl a size s.heap,image⟩
  | succ n ih =>
      have bound : j<m := by omega
      have product : (j+1)*t≤size := by
        rw [←mt]
        exact Nat.mul_le_mul_right t (by omega)
      have range : j*t+2*h≤size := by
        rw [Nat.add_mul,Nat.one_mul] at product
        omega
      have fit : m+j<gmn := by omega
      have fit2 : m+j<1024 := by omega
      let words := blockWords W (j*t) h (tableWord gvs (m+j)) pw p0i
      obtain ⟨middle,iteration,middleFixed,memory,locals,middleImage⟩ :=
        NttForwardVImage211.u1_body_image s a gm gvs pw p0i m j (j*t) h W
          fixed image range hpos fit fit2 mc jc lc hc
      have wordsImage : Image (size:=size) middle a words := by
        simpa only [words,tableWord_eq gvs (m+j) fit] using middleImage
      have update : Exec KeygenNttForwardPrograms.u1Step middle
          ⟨u1StepAfter middle j (j*t) t,.normal⟩ :=
        u1_step middle j (j*t) t (by omega) (by omega) tb
          ((congrFun locals _).trans jc) ((congrFun locals _).trans lc) ((congrFun locals _).trans tc)
      have nextImage : Image (size:=size) (u1StepAfter middle j (j*t) t) a words :=
        NttForwardImage211.image_keep wordsImage rfl
      have nextPos : USlot (u1StepAfter middle j (j*t) t) "v1" ((j+1)*t) := by
        simpa only [Nat.add_mul,Nat.one_mul] using u1_position middle j (j*t) t (by omega)
      obtain ⟨out,rest,fo,jo,frame,outImage⟩ := ih (j+1) (by omega)
        (u1StepAfter middle j (j*t) t) words
        (u1_step_fixed middle a gm gvs pw p0i j (j*t) t middleFixed) nextImage
        ((congrFun locals _).trans mc) ((congrFun locals _).trans tc) ((congrFun locals _).trans hc)
        (u1_counter middle j (j*t) t (by omega)) nextPos
      refine ⟨out,?_,fo,jo,NttWriteFrame182.trans a size _ _ _ memory frame,outImage⟩
      have nonzero : (C99ScalarReference.boolean (decide (j<m))).integer≠0 := by
        simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      exact .loopNormal _ _ _ s middle (u1StepAfter middle j (j*t) t) ⟨out,.normal⟩ _
        (C99LoopScalar141.less s (.var "u1".toList) (.var "m".toList) j m (by omega) (by omega)
          (.variable _ _ _ jc) (.variable _ _ _ mc)) nonzero iteration update rest

theorem u1_loop_full_image (m t h : Nat) (mt : m*t=size) (th : t=2*h)
    (mb : 2*m≤size) (tb : t≤256) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (W : Nat → BitVec 32) (wide : size≤gmn)
    (fixed : MFixed (size:=size) s a gm gvs pw p0i) (image : Image (size:=size) s a W)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (hc : USlot s "ht" h)
    (oldU oldV : Option Value)
    (du : s.locals "u1".toList=some (.uint64,oldU))
    (dv : s.locals "v1".toList=some (.uint64,oldV)) :
    ∃ out, Exec KeygenNttForwardPrograms.u1Loop s ⟨out,.normal⟩ ∧
      MFixed (size:=size) out a gm gvs pw p0i ∧ USlot out "u1" m ∧
      NttWriteFrame182.Frame a size s.heap out.heap ∧
      Image (size:=size) out a (roundWords gvs W m t h pw p0i) := by
  have sizeLimit:=fixed.sizeBound
  obtain ⟨out,run,fo,jo,frame,words⟩ := u1_loop_image m 0 m t h (Nat.zero_add m) mt th mb tb hpos
    (u1Initial s) a gm gvs pw p0i W wide (u1_initial_fixed s a gm gvs pw p0i fixed)
    (NttForwardImage211.image_keep image rfl) mc tc hc rfl
    (by simp only [Nat.zero_mul]; rfl)
  exact ⟨out,.seqNormal _ _ s (u1Initial s) _ (u1_init s oldU oldV du dv) run,fo,jo,frame,words⟩

end FT1536.Source3.NttForwardU1Image211
