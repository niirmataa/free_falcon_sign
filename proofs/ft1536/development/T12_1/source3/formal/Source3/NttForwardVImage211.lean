import Source3.NttForwardImage211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generic bounded-size v/block word-image composition; sealed195 bytes unchanged. -/
namespace FT1536.Source3.NttForwardVImage211
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open NttBinaryBody183 (leftWord rightWord)
open NttForwardImage211 (Image)
open StepNttImage195 (pairAt)
open NttForwardMiddle211

variable {size : Nat}

/-- One executed butterfly on the word image. -/
def pairWords (W : Nat → BitVec 32) (l h v : Nat) (tw pw p0i : BitVec 32) :
    Nat → BitVec 32 :=
  pairAt W (l+v) (l+h+v)
    (leftWord (W (l+v)) (W (l+h+v)) tw pw p0i)
    (rightWord (W (l+v)) (W (l+h+v)) tw pw p0i)

/-- Execute n remaining pairs, beginning at v = i, in source order. -/
def vWords : Nat → Nat → Nat → Nat → (Nat → BitVec 32) →
    BitVec 32 → BitVec 32 → BitVec 32 → Nat → BitVec 32
  | 0, _, _, _, W, _, _, _ => W
  | n+1, i, l, h, W, tw, pw, p0i =>
      vWords n (i+1) l h (pairWords W l h i tw pw p0i) tw pw p0i

/-- The image after every pair of this u1 block. -/
def blockWords (W : Nat → BitVec 32) (l h : Nat) (tw pw p0i : BitVec 32) :
    Nat → BitVec 32 := vWords h 0 l h W tw pw p0i

/-! ## Remaining v-loop: execution and its word image -/

theorem v_loop_image (n i h l : Nat) (count : i+n=h) (range : l+2*h≤size) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i tw : BitVec 32) (W : Nat → BitVec 32)
    (fixed : MFixed (size:=size) s a gm gvs pw p0i) (image : Image (size:=size) s a W)
    (counter : USlot s "v" i) (limit : USlot s "ht" h)
    (twiddle : Slot s "s" tw) (first : s.arrays "r1".toList=some (element a (l+i)))
    (second : s.arrays "r2".toList=some (element a (l+h+i))) :
    ∃ out, Exec vLoop s ⟨out,.normal⟩ ∧ MFixed (size:=size) out a gm gvs pw p0i ∧
      USlot out "v" h ∧ NttWriteFrame182.Frame a size s.heap out.heap ∧
      Image (size:=size) out a (vWords n i l h W tw pw p0i) := by
  have sizeLimit:=fixed.sizeBound
  induction n generalizing i s W with
  | zero =>
      have equal : i=h := by omega
      subst i
      refine ⟨s,?_,fixed,counter,NttWriteFrame182.refl a size s.heap,image⟩
      exact .loopFalse _ _ _ s (C99ScalarReference.boolean (decide (h<h)))
        (C99LoopScalar141.less s (.var "v".toList) (.var "ht".toList) h h (by omega) (by omega)
          (.variable _ _ _ counter) (.variable _ _ _ limit))
        (by simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer])
  | succ n ih =>
      have bound : i<h := by omega
      have lb : l+i<size := by omega
      have rb : l+h+i<size := by omega
      have ne : l+i≠l+h+i := by omega
      let x := W (l+i)
      let y := W (l+h+i)
      let middle := NttBinaryBody183.after s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i
      let next := vAfter middle a (l+i) (l+h+i) i
      obtain ⟨iteration,middleImage⟩ := NttForwardImage211.binary_step image fixed.width fixed.writable
        (l+i) (l+h+i) lb rb ne tw pw p0i fixed.pSlot fixed.p0iSlot twiddle first second
      have middleFixed : MFixed (size:=size) middle a gm gvs pw p0i :=
        binary_fixed s a gm gvs pw p0i tw (l+i) (l+h+i) lb rb ne fixed x y
          (image _ lb) (image _ rb)
      have locals := NttBinaryFrame183.locals s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i
      have arrays := NttBinaryFrame183.arrays s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i
      have middleCounter : USlot middle "v" i := (congrFun locals _).trans counter
      have middleFirst : middle.arrays "r1".toList=some (element a (l+i)) :=
        (congrFun arrays _).trans first
      have middleSecond : middle.arrays "r2".toList=some (element a (l+h+i)) :=
        (congrFun arrays _).trans second
      have update : Exec (KeygenNttForwardPrograms.step "v") middle ⟨next,.normal⟩ :=
        v_step middle a (l+i) (l+h+i) i (by omega) lb rb middleCounter middleFixed.strideSlot
          middleFixed.capacity middleFirst middleSecond
      have nextFixed : MFixed (size:=size) next a gm gvs pw p0i :=
        v_after_fixed middle a gm gvs pw p0i (l+i) (l+h+i) i middleFixed
      have nextFirst : next.arrays "r1".toList=some (element a (l+(i+1))) := by
        simpa only [next,Nat.add_assoc] using v_first middle a (l+i) (l+h+i) i
      have nextSecond : next.arrays "r2".toList=some (element a (l+h+(i+1))) := by
        simpa only [next,Nat.add_assoc] using v_second middle a (l+i) (l+h+i) i
      have nextImage : Image (size:=size) next a (pairWords W l h i tw pw p0i) :=
        NttForwardImage211.image_keep middleImage rfl
      obtain ⟨out,rest,outFixed,outV,outFrame,outImage⟩ := ih (i+1) (by omega) next
        (pairWords W l h i tw pw p0i) nextFixed nextImage
        (v_counter middle a (l+i) (l+h+i) i (by omega))
        ((congrFun locals _).trans limit) ((congrFun locals _).trans twiddle) nextFirst nextSecond
      have memory : NttWriteFrame182.Frame a size s.heap next.heap :=
        binary_frame s a (l+i) (l+h+i) lb rb fixed.width x y tw pw p0i
      refine ⟨out,?_,outFixed,outV,NttWriteFrame182.trans a size _ _ _ memory outFrame,outImage⟩
      have nonzero : (C99ScalarReference.boolean (decide (i<h))).integer≠0 := by
        simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
        (C99LoopScalar141.less s (.var "v".toList) (.var "ht".toList) i h (by omega) (by omega)
          (.variable _ _ _ counter) (.variable _ _ _ limit)) nonzero iteration update rest

theorem v_loop_full_image (h l : Nat) (range : l+2*h≤size) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i tw : BitVec 32) (W : Nat → BitVec 32)
    (fixed : MFixed (size:=size) s a gm gvs pw p0i) (image : Image (size:=size) s a W)
    (limit : USlot s "ht" h) (twiddle : Slot s "s" tw)
    (first : s.arrays "r1".toList=some (element a l))
    (second : s.arrays "r2".toList=some (element a (l+h)))
    (old : Option Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec KeygenNttForwardPrograms.vLoop s ⟨out,.normal⟩ ∧ MFixed (size:=size) out a gm gvs pw p0i ∧
      USlot out "v" h ∧ NttWriteFrame182.Frame a size s.heap out.heap ∧
      Image (size:=size) out a (blockWords W l h tw pw p0i) := by
  have sizeLimit:=fixed.sizeBound
  obtain ⟨out,run,fo,hv,frame,words⟩ := v_loop_image h 0 h l (Nat.zero_add h) range hpos
    (vPut s 0) a gm gvs pw p0i tw W (vput_fixed s a gm gvs pw p0i 0 fixed)
    (NttForwardImage211.image_keep image rfl) rfl limit twiddle first second
  refine ⟨out,?_,fo,hv,frame,words⟩
  simpa only [KeygenNttForwardPrograms.vLoop] using
    .seqNormal _ _ s (vPut s 0) _ (v_init s old declared) run

/-! ## The u1Inner block, with its actual table word -/

theorem u1_body_image (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (m j l h : Nat) (W : Nat → BitVec 32)
    (fixed : MFixed (size:=size) s a gm gvs pw p0i) (image : Image (size:=size) s a W)
    (range : l+2*h≤size) (hpos : 0<h) (tableBound : m+j<gmn) (h1024 : m+j<1024)
    (mc : USlot s "m" m) (jc : USlot s "u1" j) (lc : USlot s "v1" l) (hc : USlot s "ht" h) :
    ∃ out, Exec u1Block s ⟨out,.normal⟩ ∧ MFixed (size:=size) out a gm gvs pw p0i ∧
      NttWriteFrame182.Frame a size s.heap out.heap ∧ out.locals=s.locals ∧
      Image (size:=size) out a (blockWords W l h (gvs ⟨m+j,tableBound⟩) pw p0i) := by
  have sizeLimit:=fixed.sizeBound
  have setup := u1_setup s a gm gvs pw p0i m j l h fixed range tableBound h1024 mc jc lc hc
  obtain ⟨vo,vRun,vFixed,hv,frame,words⟩ := v_loop_full_image h l range hpos
    (u1After s a l h (gvs ⟨m+j,tableBound⟩)) a gm gvs pw p0i (gvs ⟨m+j,tableBound⟩) W
    (u1_setup_fixed s a gm gvs pw p0i l h (gvs ⟨m+j,tableBound⟩) fixed)
    (NttForwardImage211.image_keep image rfl) hc
    (u1_setup_twiddle s a l h (gvs ⟨m+j,tableBound⟩))
    rfl rfl none (u1_setup_v s a l h (gvs ⟨m+j,tableBound⟩))
  have inner : Exec KeygenNttForwardPrograms.u1Inner s ⟨vo,.normal⟩ :=
    NttGlue182.source u1SetupCode s (u1After s a l h (gvs ⟨m+j,tableBound⟩)) setup
      (.seq KeygenNttForwardPrograms.vLoop (.base .skip)) ⟨vo,.normal⟩
      (.seqNormal _ _ (u1After s a l h (gvs ⟨m+j,tableBound⟩)) vo _ vRun
        (.base .skip vo vo (.skip vo)))
  have run : Exec u1Block s
      ⟨C99ArrayReference.restoreScope s vo ["v".toList,"s".toList] [],.normal⟩ :=
    .scope ["v".toList,"s".toList] _ s ⟨vo,.normal⟩ inner
  have control := KeygenNttControl.frame u1Block s
    ⟨C99ArrayReference.restoreScope s vo ["v".toList,"s".toList] [],.normal⟩ (by decide) run
  have noLocals : KeygenNttControl.localsWritten u1Block=[] := by decide
  have locals : (C99ArrayReference.restoreScope s vo ["v".toList,"s".toList] []).locals=s.locals := by
    funext name
    apply control.2.1 name
    rw [noLocals]
    exact List.not_mem_nil
  refine ⟨C99ArrayReference.restoreScope s vo ["v".toList,"s".toList] [],run,?_,frame,locals,
    NttForwardImage211.image_keep words rfl⟩
  exact fixed_map vo a gm gvs pw p0i vFixed
    (C99ArrayReference.restoreScope s vo ["v".toList,"s".toList] [])
    (by simp [C99ArrayReference.restoreScope,C99ScalarReference.restore])
    (by simp [C99ArrayReference.restoreScope,C99ScalarReference.restore])
    (by simp [C99ArrayReference.restoreScope,C99ScalarReference.restore])
    (by simp [C99ArrayReference.restoreScope,C99ScalarReference.restore])
    (by simp [C99ArrayReference.restoreScope,C99ScalarReference.restore])
    (by simp [C99ArrayReference.restoreScope])
    (by simp [C99ArrayReference.restoreScope])
    rfl

end FT1536.Source3.NttForwardVImage211
