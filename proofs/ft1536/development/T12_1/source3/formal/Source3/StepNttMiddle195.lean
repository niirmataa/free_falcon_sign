import Source3.StepNttFirstLoop195
import Source3.NttBinaryBody183
import Source3.NttBinaryFrame183
import Source3.NttMiddleAddress183
import Source3.NttGlue182
import Source3.KeygenNttControl
import Source3.C99OuterScalar144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The doubling-round engine of the pinned modp_NTT3_ext forward body at
   the selected call words (logn = 9 / full = 0, n = 512, hn = 256,
   stride = 1): one intermediate pass round of KeygenNttForwardPrograms
   mInner — the ht = t >> 1 halving, the u1 loop of blocks (each block
   loads its twiddle s = gm[m+u1], re-derives r2 from r1 through htBind
   and runs the radix-2 v-loop of KeygenNttButterflyPrograms.binaryBody
   butterflies) and the t = ht reassignment. The v-loop and u1-loop
   compositions, the per-step engine and the block scopes are stated at
   the instance words (positions element a (l+i), element a (l+h+i));
   the generic counter/pointer pieces of the 183 lanes are consumed
   (NttMiddleAddress183.product/table, NttFirstControl182.address,
   C99OuterScalar144.half_eval, KeygenNttControl frames), the binary
   butterfly run is consumed from NttBinaryBody183.source. The invariant
   MFixed keeps the executed-word readability of the 512 a cells, the gm
   table loads, the p/p0i/full/hn/stride cells and the write frame.
   DEFECT NOTE (retained, do not re-derive): the job-570
   StepNttFirst195.bodyHeap mis-composition is a defect of that layer's
   record only; this module consumes the binary butterfly of the 183
   lanes and the corrected 571 states (bodyAt/stepAt), not the defective
   stepState. Values stay executed words: no transform property, table
   law, root law or positivity claim is made here. -/
namespace FT1536.Source3.StepNttMiddle195
open C99ArrayReference (State bindPointer bindValue)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Exec)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open NttBinaryBody183 (leftWord rightWord)

/-! ## The middle-pass invariant at the instance words -/

structure MFixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) : Prop where
  pSlot : Slot s "p" pw
  p0iSlot : Slot s "p0i" p0i
  fullSlot : Slot s "full" 0
  hnSlot : USlot s "hn" 256
  strideSlot : USlot s "stride" 1
  aBinding : s.arrays "a".toList=some a
  gmBinding : s.arrays "gm".toList=some gm
  width : a.elementBytes=4
  capacity : a.index+512≤a.count
  writable : s.heap.writable a.block=true
  reads : ∀ j<512, ∃ w, Load32 s.heap (element a j) w
  gmSeparate : ∀ i : Fin gmn, ∀ j<512, Separate (element gm i) (element a j)
  gmLoads : ∀ i : Fin gmn, Load32 s.heap (element gm i) (gvs i)

theorem width_at (a : ArrayPointer) (width : a.elementBytes=4) (j : Nat) :
    (element a j).elementBytes=4 := width

theorem alloc_at {h : C99MemoryReference.Memory} {a : ArrayPointer} {j : Nat} {w : BitVec 32}
    (read : Load32 h (element a j) w) : Allocated h (element a j) :=
  StepNttFirstLoop195.load_allocated read

/- Two writes at distinct instance cells preserve the readability of all
   512 cells (the written pair holds its executed words). -/
theorem reads_two (h : C99MemoryReference.Memory) (a : ArrayPointer) (p1 p2 j : Nat)
    (_b1 : p1<512) (_b2 : p2<512) (ne : p1≠p2) (width : a.elementBytes=4)
    (hp1 : Allocated h (element a p1)) (hp2 : Allocated h (element a p2))
    (hw : h.writable a.block=true) (w1 w2 : BitVec 32) (reads : ∀ k<512, ∃ w, Load32 h (element a k) w)
    (bound : j<512) :
    ∃ w, Load32 (Word32Memory176.write (Word32Memory176.write h (element a p1) w1)
      (element a p2) w2) (element a j) w := by
  obtain ⟨old,read⟩ := reads j bound
  by_cases first : j=p1
  · subst j
    refine ⟨w1,?_⟩
    exact StepNttFirstLoop195.two_write_here_left h (element a p1) (element a p2) w1 w2
      hp1 width hw (StepNttFirst195.elem_separate a width p1 p2 ne)
  · by_cases second : j=p2
    · subst j
      refine ⟨w2,?_⟩
      exact StepNttFirstLoop195.two_write_here_right h (element a p1) (element a p2) w1 w2
        hp2 width hw
    · refine ⟨old,?_⟩
      exact StepNttFirstLoop195.two_write_keep h (element a p1) (element a j) (element a p2) w1 w2
        old (StepNttFirst195.elem_separate a width j p1 (by omega))
        (StepNttFirst195.elem_separate a width j p2 (by omega)) read

/- The binary butterfly at the walked pair preserves MFixed. -/
theorem binary_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i tw : BitVec 32) (p1 p2 : Nat) (b1 : p1<512) (b2 : p2<512) (ne : p1≠p2)
    (fixed : MFixed s a gm gvs pw p0i) (x y : BitVec 32)
    (read0 : Load32 s.heap (element a p1) x) (read1 : Load32 s.heap (element a p2) y) :
    MFixed (NttBinaryBody183.after s (element a p1) (element a p2) x y tw pw p0i) a gm gvs pw p0i := by
  have heap : (NttBinaryBody183.after s (element a p1) (element a p2) x y tw pw p0i).heap=
      Word32Memory176.write (Word32Memory176.write s.heap (element a p1) (leftWord x y tw pw p0i))
        (element a p2) (rightWord x y tw pw p0i) := rfl
  have locals : (NttBinaryBody183.after s (element a p1) (element a p2) x y tw pw p0i).locals=
      s.locals := NttBinaryFrame183.locals s (element a p1) (element a p2) x y tw pw p0i
  have arrays : (NttBinaryBody183.after s (element a p1) (element a p2) x y tw pw p0i).arrays=
      s.arrays := NttBinaryFrame183.arrays s (element a p1) (element a p2) x y tw pw p0i
  have hp1 : Allocated s.heap (element a p1) := alloc_at read0
  have hp2 : Allocated s.heap (element a p2) := alloc_at read1
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact (congrFun locals _).trans fixed.pSlot
  · exact (congrFun locals _).trans fixed.p0iSlot
  · exact (congrFun locals _).trans fixed.fullSlot
  · exact (congrFun locals _).trans fixed.hnSlot
  · exact (congrFun locals _).trans fixed.strideSlot
  · exact (congrFun arrays _).trans fixed.aBinding
  · exact (congrFun arrays _).trans fixed.gmBinding
  · exact fixed.width
  · exact fixed.capacity
  · rw [heap]
    exact StepNttBody195.write_writable _ _ _ _
      (StepNttBody195.write_writable s.heap (element a p1) (element a p2)
        (leftWord x y tw pw p0i) fixed.writable)
  · intro j bound
    rw [heap]
    exact reads_two s.heap a p1 p2 j b1 b2 ne fixed.width hp1 hp2 fixed.writable
      (leftWord x y tw pw p0i) (rightWord x y tw pw p0i) fixed.reads bound
  · intro i j
    exact fixed.gmSeparate i j
  · intro i
    rw [heap]
    exact StepNttFirstLoop195.two_write_keep s.heap (element a p1) (element gm i) (element a p2)
      (leftWord x y tw pw p0i) (rightWord x y tw pw p0i) (gvs i)
      (fixed.gmSeparate i p1 b1) (fixed.gmSeparate i p2 b2) (fixed.gmLoads i)

theorem binary_frame (s : State) (a : ArrayPointer) (p1 p2 : Nat) (b1 : p1<512) (b2 : p2<512)
    (width : a.elementBytes=4) (x y tw pw p0i : BitVec 32) :
    NttWriteFrame182.Frame a 512 s.heap
      (NttBinaryBody183.after s (element a p1) (element a p2) x y tw pw p0i).heap :=
  NttWriteFrame182.trans a 512 _ _ _
    (NttWriteFrame182.write s.heap a 512 ⟨p1,b1⟩ (leftWord x y tw pw p0i) width)
    (NttWriteFrame182.write _ a 512 ⟨p2,b2⟩ (rightWord x y tw pw p0i) width)

theorem fixed_map (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (fixed : MFixed s a gm gvs pw p0i) (s' : State)
    (pCell : s'.locals "p".toList=s.locals "p".toList)
    (p0iCell : s'.locals "p0i".toList=s.locals "p0i".toList)
    (fullCell : s'.locals "full".toList=s.locals "full".toList)
    (hnCell' : s'.locals "hn".toList=s.locals "hn".toList)
    (strideCell' : s'.locals "stride".toList=s.locals "stride".toList)
    (aCell : s'.arrays "a".toList=s.arrays "a".toList)
    (gmCell : s'.arrays "gm".toList=s.arrays "gm".toList)
    (heap : s'.heap=s.heap) : MFixed s' a gm gvs pw p0i :=
  ⟨pCell.trans fixed.pSlot,p0iCell.trans fixed.p0iSlot,fullCell.trans fixed.fullSlot,
    hnCell'.trans fixed.hnSlot,strideCell'.trans fixed.strideSlot,
    aCell.trans fixed.aBinding,gmCell.trans fixed.gmBinding,
    fixed.width,fixed.capacity,
    by rw [heap]; exact fixed.writable,
    by intro j bound; rw [heap]; exact fixed.reads j bound,
    fixed.gmSeparate,
    by intro i; rw [heap]; exact fixed.gmLoads i⟩

/-! ## The v-loop step engine (instance words) -/

def vPut (s : State) (i : Nat) := bindValue s "v".toList .uint64 (u64 i)
def vFirst (s : State) (a : ArrayPointer) (l i : Nat) :=
  bindPointer (vPut s (i+1)) "r1".toList (element a (l+1))
def vAfter (s : State) (a : ArrayPointer) (l r i : Nat) :=
  bindPointer (vFirst s a l i) "r2".toList (element a (r+1))

theorem v_step (s : State) (a : ArrayPointer) (l r i : Nat) (ib : i<512) (lb : l<512) (rb : r<512)
    (counter : USlot s "v" i) (stride : USlot s "stride" 1) (capacity : a.index+512≤a.count)
    (first : s.arrays "r1".toList=some (element a l)) (second : s.arrays "r2".toList=some (element a r)) :
    Exec (KeygenNttForwardPrograms.step "v") s ⟨vAfter s a l r i,.normal⟩ := by
  have base := C99LoopScalar141.increment (fun _ => none) s "v".toList i (by omega) counter
  rw [FftLocalCells140.put_bind] at base
  have inc : Exec (KeygenNttForwardPrograms.update "v" .add (KeygenNttForwardPrograms.num 1)) s
      ⟨vPut s (i+1),.normal⟩ := by
    cases base with
    | base _ _ _ run => exact .base _ _ _ run
  have r1 : Exec (KeygenNttForwardPrograms.bind "r1" "r1" (.var "stride".toList)) (vPut s (i+1))
      ⟨vFirst s a l i,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _
      (NttFirstControl182.address (vPut s (i+1)) "r1" a l first stride (by omega)))
  have r2 : Exec (KeygenNttForwardPrograms.bind "r2" "r2" (.var "stride".toList)) (vFirst s a l i)
      ⟨vAfter s a l r i,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _
      (NttFirstControl182.address (vFirst s a l i) "r2" a r second stride (by omega)))
  exact .seqNormal _ _ s (vPut s (i+1)) _ inc
    (.seqNormal _ _ (vPut s (i+1)) (vFirst s a l i) _ r1 r2)

theorem v_counter (s : State) (a : ArrayPointer) (l r i : Nat) (bound : i<512) :
    USlot (vAfter s a l r i) "v" (i+1) :=
  KeygenMkgm3RowInit.set64_slot s "v" (i+1) (by omega)

theorem v_first (s : State) (a : ArrayPointer) (l r i : Nat) :
    (vAfter s a l r i).arrays "r1".toList=some (element a (l+1)) := rfl

theorem v_second (s : State) (a : ArrayPointer) (l r i : Nat) :
    (vAfter s a l r i).arrays "r2".toList=some (element a (r+1)) := rfl

theorem v_init (s : State) (old : Option Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    Exec KeygenNttForwardPrograms.vInit s ⟨vPut s 0,.normal⟩ :=
  .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))

theorem vput_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (i : Nat) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (vPut s i) a gm gvs pw p0i :=
  fixed_map s a gm gvs pw p0i fixed (vPut s i)
    (by simp [vPut,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [vPut,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [vPut,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [vPut,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [vPut,C99ArrayReference.bindValue,C99ScalarReference.set])
    rfl rfl rfl

theorem v_after_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (l r i : Nat) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (vAfter s a l r i) a gm gvs pw p0i :=
  fixed_map s a gm gvs pw p0i fixed (vAfter s a l r i)
    (by simp [vAfter,vFirst,vPut,C99ArrayReference.bindPointer,C99ArrayReference.bindValue,
      C99ScalarReference.set])
    (by simp [vAfter,vFirst,vPut,C99ArrayReference.bindPointer,C99ArrayReference.bindValue,
      C99ScalarReference.set])
    (by simp [vAfter,vFirst,vPut,C99ArrayReference.bindPointer,C99ArrayReference.bindValue,
      C99ScalarReference.set])
    (by simp [vAfter,vFirst,vPut,C99ArrayReference.bindPointer,C99ArrayReference.bindValue,
      C99ScalarReference.set])
    (by simp [vAfter,vFirst,vPut,C99ArrayReference.bindPointer,C99ArrayReference.bindValue,
      C99ScalarReference.set])
    (by simp [vAfter,vFirst,vPut,C99ArrayReference.bindPointer,C99ArrayReference.bindValue])
    (by simp [vAfter,vFirst,vPut,C99ArrayReference.bindPointer,C99ArrayReference.bindValue])
    rfl

/-! ## The v-loop composition -/

def vLoop : C99ModularReference.Stmt :=
  .loop (.cmp .lt (KeygenNttForwardPrograms.var "v") (KeygenNttForwardPrograms.var "ht"))
    (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody)
    (KeygenNttForwardPrograms.step "v")

theorem v_loop (n i h l : Nat) (count : i+n=h) (range : l+2*h≤512) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32) (pw p0i tw : BitVec 32)
    (fixed : MFixed s a gm gvs pw p0i) (counter : USlot s "v" i) (limit : USlot s "ht" h)
    (twiddle : Slot s "s" tw) (first : s.arrays "r1".toList=some (element a (l+i)))
    (second : s.arrays "r2".toList=some (element a (l+h+i))) :
    ∃ out, Exec vLoop s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧ USlot out "v" h ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap := by
  induction n generalizing i s with
  | zero =>
      have equal : i=h := by omega
      subst i
      exact ⟨s,.loopFalse _ _ _ s (C99ScalarReference.boolean (decide (h<h)))
        (C99LoopScalar141.less s (.var "v".toList) (.var "ht".toList) h h (by omega) (by omega)
          (.variable _ _ _ counter) (.variable _ _ _ limit))
        (by simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer]),
        fixed,counter,NttWriteFrame182.refl a 512 s.heap⟩
  | succ n ih =>
      have bound : i<h := by omega
      have lb : l+i<512 := by omega
      have rb : l+h+i<512 := by omega
      have ne : l+i≠l+h+i := by omega
      obtain ⟨x,read0⟩ := fixed.reads (l+i) lb
      obtain ⟨y,read1⟩ := fixed.reads (l+h+i) rb
      let middle := NttBinaryBody183.after s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i
      let next := vAfter middle a (l+i) (l+h+i) i
      have iteration : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody)
          s ⟨middle,.normal⟩ :=
        NttBinaryBody183.source s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i
          fixed.pSlot fixed.p0iSlot twiddle first second (alloc_at read0) (alloc_at read1)
          fixed.width fixed.width fixed.writable fixed.writable read0 read1
      have middleFixed : MFixed middle a gm gvs pw p0i :=
        binary_fixed s a gm gvs pw p0i tw (l+i) (l+h+i) (by omega) (by omega) ne fixed x y read0 read1
      have middleCounter : USlot middle "v" i := (congrFun
        (NttBinaryFrame183.locals s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i) _).trans counter
      have middleLimit : USlot middle "ht" h := (congrFun
        (NttBinaryFrame183.locals s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i) _).trans limit
      have middleStride : USlot middle "stride" 1 := middleFixed.strideSlot
      have middleR1 : middle.arrays "r1".toList=some (element a (l+i)) :=
        (congrFun (NttBinaryFrame183.arrays s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i)
          _).trans first
      have middleR2 : middle.arrays "r2".toList=some (element a (l+h+i)) :=
        (congrFun (NttBinaryFrame183.arrays s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i)
          _).trans second
      have update : Exec (KeygenNttForwardPrograms.step "v") middle ⟨next,.normal⟩ :=
        v_step middle a (l+i) (l+h+i) i (by omega) (by omega) (by omega) middleCounter middleStride
          middleFixed.capacity middleR1 middleR2
      have nextFixed : MFixed next a gm gvs pw p0i :=
        v_after_fixed middle a gm gvs pw p0i (l+i) (l+h+i) i middleFixed
      have nextCounter : USlot next "v" (i+1) := v_counter middle a (l+i) (l+h+i) i (by omega)
      have nextFirst : next.arrays "r1".toList=some (element a (l+(i+1))) := by
        simpa only [next,Nat.add_assoc] using v_first middle a (l+i) (l+h+i) i
      have nextSecond : next.arrays "r2".toList=some (element a (l+h+(i+1))) := by
        simpa only [next,Nat.add_assoc] using v_second middle a (l+i) (l+h+i) i
      obtain ⟨out,rest,outFixed,outV,outFrame⟩ := ih (i+1) (by omega) next nextFixed nextCounter
        ((congrFun (NttBinaryFrame183.locals s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i)
          _).trans limit)
        ((congrFun (NttBinaryFrame183.locals s (element a (l+i)) (element a (l+h+i)) x y tw pw p0i)
          _).trans twiddle) nextFirst nextSecond
      have memory : NttWriteFrame182.Frame a 512 s.heap next.heap :=
        binary_frame s a (l+i) (l+h+i) (by omega) (by omega) fixed.width x y tw pw p0i
      refine ⟨out,?_,outFixed,outV,NttWriteFrame182.trans a 512 _ _ _ memory outFrame⟩
      have nonzero : (C99ScalarReference.boolean (decide (i<h))).integer≠0 := by
        simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
        (C99LoopScalar141.less s (.var "v".toList) (.var "ht".toList) i h (by omega) (by omega)
          (.variable _ _ _ counter) (.variable _ _ _ limit)) nonzero iteration update rest

theorem v_loop_full (h l : Nat) (range : l+2*h≤512) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32) (pw p0i tw : BitVec 32)
    (fixed : MFixed s a gm gvs pw p0i) (limit : USlot s "ht" h) (twiddle : Slot s "s" tw)
    (first : s.arrays "r1".toList=some (element a l)) (second : s.arrays "r2".toList=some (element a (l+h)))
    (old : Option Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec KeygenNttForwardPrograms.vLoop s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧
      USlot out "v" h ∧ NttWriteFrame182.Frame a 512 s.heap out.heap := by
  obtain ⟨out,run,fo,hv,frame⟩ := v_loop h 0 h l (Nat.zero_add h) range hpos
    (vPut s 0) a gm gvs pw p0i tw (vput_fixed s a gm gvs pw p0i 0 fixed) rfl limit twiddle
    first second
  refine ⟨out,?_,fo,hv,frame⟩
  simpa only [KeygenNttForwardPrograms.vLoop] using
    .seqNormal _ _ s (vPut s 0) _ (v_init s old declared) run

/-! ## The u1Inner block: the twiddle load and the pointer binds -/

def dV (s : State) := C99DeclarationStatements.effect .u64 ["v".toList] s
def dS (s : State) := C99DeclarationStatements.effect .u32 ["s".toList] (dV s)
def withS (s : State) (tw : BitVec 32) := ModularAtoms178.set (dS s) "s" tw
def withR1 (s : State) (a : ArrayPointer) (l : Nat) (tw : BitVec 32) :=
  bindPointer (withS s tw) "r1".toList (element a l)
def u1After (s : State) (a : ArrayPointer) (l h : Nat) (tw : BitVec 32) :=
  bindPointer (withR1 s a l tw) "r2".toList (element a (l+h))

def u1SetupCode : C99ModularReference.Stmt :=
  KeygenNttButterflyPrograms.chain [KeygenNttForwardPrograms.sizeDeclaration ["v"],
    KeygenNttForwardPrograms.wordDeclaration ["s"],KeygenNttForwardPrograms.sAssign,
    KeygenNttForwardPrograms.v1Bind,KeygenNttForwardPrograms.htBind]

theorem u1_setup (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (m j l h : Nat) (fixed : MFixed s a gm gvs pw p0i)
    (range : l+2*h≤512) (tableBound : m+j<gmn) (h1024 : m+j<1024)
    (mc : USlot s "m" m) (jc : USlot s "u1" j) (lc : USlot s "v1" l) (hc : USlot s "ht" h) :
    Exec u1SetupCode s ⟨u1After s a l h (gvs ⟨m+j,tableBound⟩),.normal⟩ := by
  set tw := gvs ⟨m+j,tableBound⟩
  have v : Exec (KeygenNttForwardPrograms.sizeDeclaration ["v"]) s ⟨dV s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 ["v".toList] s)
  have d : Exec (KeygenNttForwardPrograms.wordDeclaration ["s"]) (dV s) ⟨dS s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 ["s".toList] (dV s))
  have set : Exec KeygenNttForwardPrograms.sAssign (dS s) ⟨withS s tw,.normal⟩ :=
    ModularAtoms178.assign _ "s" none _ _ rfl
      (.load32 _ _ (element gm (m+j)) tw
        (NttMiddleAddress183.table (dS s) gm m j h1024 tw fixed.gmBinding mc jc
          (fixed.gmLoads ⟨m+j,tableBound⟩)) (fixed.gmLoads ⟨m+j,tableBound⟩))
  have r1 : Exec KeygenNttForwardPrograms.v1Bind (withS s tw) ⟨withR1 s a l tw,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ (element a l)
      (by simpa only [Nat.zero_add,KeygenNttForwardPrograms.var] using
        (NttMiddleAddress183.product (withS s tw) "a" "v1" a 0 l (by omega) fixed.aBinding lc
          fixed.strideSlot (by have := fixed.capacity; omega))))
  have r2 : Exec KeygenNttForwardPrograms.htBind (withR1 s a l tw) ⟨u1After s a l h tw,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ (element a (l+h))
      (NttMiddleAddress183.product (withR1 s a l tw) "r1" "ht" a l h (by omega) rfl hc fixed.strideSlot
        (by have := fixed.capacity; omega)))
  exact .seqNormal _ _ s (dV s) _ v (.seqNormal _ _ (dV s) (dS s) _ d
    (.seqNormal _ _ (dS s) (withS s tw) _ set (.seqNormal _ _ (withS s tw) (withR1 s a l tw) _ r1
      (.seqNormal _ _ (withR1 s a l tw) (u1After s a l h tw) _ r2 (.base .skip _ _ (.skip _))))))

theorem u1_setup_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (l h : Nat) (tw : BitVec 32) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (u1After s a l h tw) a gm gvs pw p0i :=
  fixed_map s a gm gvs pw p0i fixed (u1After s a l h tw)
    (by simp [u1After,withR1,withS,dS,dV,ModularAtoms178.set,C99ArrayReference.bindPointer,
      C99ArrayReference.bindValue,C99ScalarReference.set,C99DeclarationStatements.effect,
      C99DeclarationCells.declareCells])
    (by simp [u1After,withR1,withS,dS,dV,ModularAtoms178.set,C99ArrayReference.bindPointer,
      C99ArrayReference.bindValue,C99ScalarReference.set,C99DeclarationStatements.effect,
      C99DeclarationCells.declareCells])
    (by simp [u1After,withR1,withS,dS,dV,ModularAtoms178.set,C99ArrayReference.bindPointer,
      C99ArrayReference.bindValue,C99ScalarReference.set,C99DeclarationStatements.effect,
      C99DeclarationCells.declareCells])
    (by simp [u1After,withR1,withS,dS,dV,ModularAtoms178.set,C99ArrayReference.bindPointer,
      C99ArrayReference.bindValue,C99ScalarReference.set,C99DeclarationStatements.effect,
      C99DeclarationCells.declareCells])
    (by simp [u1After,withR1,withS,dS,dV,ModularAtoms178.set,C99ArrayReference.bindPointer,
      C99ArrayReference.bindValue,C99ScalarReference.set,C99DeclarationStatements.effect,
      C99DeclarationCells.declareCells])
    (by simp [u1After,withR1,withS,dS,dV,ModularAtoms178.set,C99ArrayReference.bindPointer,
      C99ArrayReference.bindValue,C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    (by simp [u1After,withR1,withS,dS,dV,ModularAtoms178.set,C99ArrayReference.bindPointer,
      C99ArrayReference.bindValue,C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    rfl

theorem u1_setup_twiddle (s : State) (a : ArrayPointer) (l h : Nat) (tw : BitVec 32) :
    KeygenModpR2Exec.Slot (u1After s a l h tw) "s" tw :=
  ModularAtoms178.slot (dS s) "s" tw

theorem u1_setup_v (s : State) (a : ArrayPointer) (l h : Nat) (tw : BitVec 32) :
    (u1After s a l h tw).locals "v".toList=some (.uint64,none) := by
  simp [u1After,withR1,withS,dS,dV,ModularAtoms178.set,C99ArrayReference.bindPointer,
    C99ArrayReference.bindValue,C99ScalarReference.set,C99DeclarationStatements.effect,
    C99DeclarationCells.declareCells,C99ValueBridge.type]


/-! ## The u1Inner run and the u1-loop -/

def u1Block : C99ModularReference.Stmt := KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner

theorem u1_body (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (m j l h : Nat) (fixed : MFixed s a gm gvs pw p0i)
    (range : l+2*h≤512) (hpos : 0<h) (tableBound : m+j<gmn) (h1024 : m+j<1024)
    (mc : USlot s "m" m) (jc : USlot s "u1" j) (lc : USlot s "v1" l) (hc : USlot s "ht" h) :
    ∃ out, Exec u1Block s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap ∧ out.locals=s.locals := by
  have setup : Exec u1SetupCode s ⟨u1After s a l h (gvs ⟨m+j,tableBound⟩),.normal⟩ :=
    u1_setup s a gm gvs pw p0i m j l h fixed range tableBound h1024 mc jc lc hc
  obtain ⟨vo,vRun,vFixed,hv,frame⟩ := v_loop_full h l range hpos
    (u1After s a l h (gvs ⟨m+j,tableBound⟩)) a gm gvs pw p0i (gvs ⟨m+j,tableBound⟩)
    (u1_setup_fixed s a gm gvs pw p0i l h (gvs ⟨m+j,tableBound⟩) fixed) hc
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
  refine ⟨C99ArrayReference.restoreScope s vo ["v".toList,"s".toList] [],run,?_,frame,locals⟩
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

/-! ## The u1 step and initialiser -/

def u1WithU (s : State) (j : Nat) := bindValue s "u1".toList .uint64 (u64 (j+1))
def u1StepAfter (s : State) (j l t : Nat) := bindValue (u1WithU s j) "v1".toList .uint64 (u64 (l+t))

theorem u1_step (s : State) (j l t : Nat) (jb : j<512) (lb : l≤512) (tb : t≤256)
    (jc : USlot s "u1" j) (lc : USlot s "v1" l) (tc : USlot s "t" t) :
    Exec KeygenNttForwardPrograms.u1Step s ⟨u1StepAfter s j l t,.normal⟩ := by
  have base := C99LoopScalar141.increment (fun _ => none) s "u1".toList j (by omega) jc
  rw [FftLocalCells140.put_bind] at base
  have inc : Exec (KeygenNttForwardPrograms.update "u1" .add (KeygenNttForwardPrograms.num 1)) s
      ⟨u1WithU s j,.normal⟩ := by
    cases base with
    | base _ _ _ run => exact .base _ _ _ run
  have advance : Exec (KeygenNttForwardPrograms.update "v1" .add (KeygenNttForwardPrograms.var "t"))
      (u1WithU s j) ⟨u1StepAfter s j l t,.normal⟩ :=
    .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 l)) (u64 (l+t)) lc
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ lc) (.variable _ _ _ tc)
        (C99NatWord141.add l t (by omega) (by omega)))))
  exact .seqNormal _ _ s (u1WithU s j) _ inc advance

theorem u1_step_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (j l t : Nat) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (u1StepAfter s j l t) a gm gvs pw p0i :=
  fixed_map s a gm gvs pw p0i fixed (u1StepAfter s j l t)
    (by simp [u1StepAfter,u1WithU,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [u1StepAfter,u1WithU,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [u1StepAfter,u1WithU,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [u1StepAfter,u1WithU,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [u1StepAfter,u1WithU,C99ArrayReference.bindValue,C99ScalarReference.set])
    rfl rfl rfl

theorem u1_counter (s : State) (j l t : Nat) (jb : j<512) : USlot (u1StepAfter s j l t) "u1" (j+1) :=
  KeygenMkgm3RowInit.set64_slot s "u1" (j+1) (by omega)

theorem u1_position (s : State) (j l t : Nat) (bound : l+t<2^64) :
    USlot (u1StepAfter s j l t) "v1" (l+t) :=
  KeygenMkgm3RowInit.set64_slot (u1WithU s j) "v1" (l+t) bound

def u1Initial (s : State) :=
  bindValue (bindValue s "u1".toList .uint64 (u64 0)) "v1".toList .uint64 (u64 0)

theorem u1_init (s : State) (oldU oldV : Option Value)
    (du : s.locals "u1".toList=some (.uint64,oldU)) (dv : s.locals "v1".toList=some (.uint64,oldV)) :
    Exec KeygenNttForwardPrograms.u1Init s ⟨u1Initial s,.normal⟩ :=
  .seqNormal _ _ s (bindValue s "u1".toList .uint64 (u64 0)) _
    (.assign _ _ _ .uint64 oldU (.int32 0) du (.scalar _ _ (.literal .int32 0)))
    (.assign _ _ _ .uint64 oldV (.int32 0) dv (.scalar _ _ (.literal .int32 0)))

theorem u1_initial_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (u1Initial s) a gm gvs pw p0i :=
  fixed_map s a gm gvs pw p0i fixed (u1Initial s)
    (by simp [u1Initial,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [u1Initial,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [u1Initial,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [u1Initial,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [u1Initial,C99ArrayReference.bindValue,C99ScalarReference.set])
    rfl rfl rfl

/-! ## The u1-loop over the blocks of one round -/

def u1LoopCode : C99ModularReference.Stmt :=
  .loop (.cmp .lt (KeygenNttForwardPrograms.var "u1") (KeygenNttForwardPrograms.var "m"))
    u1Block KeygenNttForwardPrograms.u1Step

theorem u1_loop (n j m t h : Nat) (count : j+n=m) (mt : m*t=512) (th : t=2*h)
    (mb : m≤256) (tb : t≤256) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32) (pw p0i : BitVec 32)
    (wide : 512≤gmn)
    (fixed : MFixed s a gm gvs pw p0i)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (hc : USlot s "ht" h)
    (jc : USlot s "u1" j) (lc : USlot s "v1" (j*t)) :
    ∃ out, Exec u1LoopCode s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧ USlot out "u1" m ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap := by
  induction n generalizing j s with
  | zero =>
      have equal : j=m := by omega
      subst j
      exact ⟨s,.loopFalse _ _ _ s (C99ScalarReference.boolean (decide (m<m)))
        (C99LoopScalar141.less s (.var "u1".toList) (.var "m".toList) m m (by omega) (by omega)
          (.variable _ _ _ jc) (.variable _ _ _ mc))
        (by simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer]),
        fixed,jc,NttWriteFrame182.refl a 512 s.heap⟩
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
      obtain ⟨middle,iteration,middleFixed,memory,locals⟩ :=
        u1_body s a gm gvs pw p0i m j (j*t) h fixed range hpos fit fit2 mc jc lc hc
      have update : Exec KeygenNttForwardPrograms.u1Step middle ⟨u1StepAfter middle j (j*t) t,.normal⟩ :=
        u1_step middle j (j*t) t (by omega) (by omega) tb
          ((congrFun locals _).trans jc) ((congrFun locals _).trans lc) ((congrFun locals _).trans tc)
      have nextPos : USlot (u1StepAfter middle j (j*t) t) "v1" ((j+1)*t) := by
        simpa only [Nat.add_mul,Nat.one_mul] using u1_position middle j (j*t) t (by omega)
      obtain ⟨out,rest,fo,jo,frame⟩ := ih (j+1) (by omega) (u1StepAfter middle j (j*t) t)
        (u1_step_fixed middle a gm gvs pw p0i j (j*t) t middleFixed)
        ((congrFun locals _).trans mc) ((congrFun locals _).trans tc) ((congrFun locals _).trans hc)
        (u1_counter middle j (j*t) t (by omega)) nextPos
      refine ⟨out,?_,fo,jo,NttWriteFrame182.trans a 512 _ _ _ memory frame⟩
      have nonzero : (C99ScalarReference.boolean (decide (j<m))).integer≠0 := by
        simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      exact .loopNormal _ _ _ s middle (u1StepAfter middle j (j*t) t) ⟨out,.normal⟩ _
        (C99LoopScalar141.less s (.var "u1".toList) (.var "m".toList) j m (by omega) (by omega)
          (.variable _ _ _ jc) (.variable _ _ _ mc)) nonzero iteration update rest

theorem u1_loop_full (m t h : Nat) (mt : m*t=512) (th : t=2*h)
    (mb : m≤256) (tb : t≤256) (hpos : 0<h)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32) (pw p0i : BitVec 32)
    (wide : 512≤gmn)
    (fixed : MFixed s a gm gvs pw p0i)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (hc : USlot s "ht" h)
    (oldU oldV : Option Value)
    (du : s.locals "u1".toList=some (.uint64,oldU)) (dv : s.locals "v1".toList=some (.uint64,oldV)) :
    ∃ out, Exec KeygenNttForwardPrograms.u1Loop s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧
      USlot out "u1" m ∧ NttWriteFrame182.Frame a 512 s.heap out.heap := by
  obtain ⟨out,run,fo,jo,frame⟩ := u1_loop m 0 m t h (Nat.zero_add m) mt th mb tb hpos
    (u1Initial s) a gm gvs pw p0i wide (u1_initial_fixed s a gm gvs pw p0i fixed) mc tc hc rfl
    (by simp only [Nat.zero_mul]; rfl)
  exact ⟨out,.seqNormal _ _ s (u1Initial s) _ (u1_init s oldU oldV du dv) run,fo,jo,frame⟩


/-! ## One doubling round: the mInner block -/

def mNames := ["ht","u1","v1"].map String.toList
def mDeclared (s : State) := C99DeclarationStatements.effect .u64 mNames s
def mPrepared (s : State) (h : Nat) := bindValue (mDeclared s) "ht".toList .uint64 (u64 h)
def mBlock : C99ModularReference.Stmt := KeygenNttForwardPrograms.block KeygenNttForwardPrograms.mInner

theorem m_prepared_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (h : Nat) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (mPrepared s h) a gm gvs pw p0i :=
  fixed_map s a gm gvs pw p0i fixed (mPrepared s h)
    (by simp [mPrepared,mDeclared,mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    (by simp [mPrepared,mDeclared,mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    (by simp [mPrepared,mDeclared,mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    (by simp [mPrepared,mDeclared,mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    (by simp [mPrepared,mDeclared,mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
      C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    (by simp [mPrepared,mDeclared,mNames,C99ArrayReference.bindValue,
      C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    (by simp [mPrepared,mDeclared,mNames,C99ArrayReference.bindValue,
      C99DeclarationStatements.effect,C99DeclarationCells.declareCells])
    rfl

theorem m_body (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (m t h : Nat) (fixed : MFixed s a gm gvs pw p0i)
    (mt : m*t=512) (th : t=2*h) (mb : m≤256) (tb : t≤256) (hpos : 0<h) (wide : 512≤gmn)
    (mc : USlot s "m" m) (tc : USlot s "t" t) :
    ∃ out, Exec mBlock s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧ USlot out "t" h ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap := by
  have dc : Exec (KeygenNttForwardPrograms.sizeDeclaration ["ht","u1","v1"]) s
      ⟨mDeclared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 mNames s)
  have half : t/2=h := by omega
  have hc : USlot (mPrepared s h) "ht" h :=
    KeygenMkgm3RowInit.set64_slot (mDeclared s) "ht" h (by omega)
  have halfRun : Exec KeygenNttForwardPrograms.htAssign (mDeclared s) ⟨mPrepared s h,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 h) rfl (.scalar _ _
      (by simpa only [half,KeygenNttForwardPrograms.var,KeygenNttForwardPrograms.num,
        KeygenNttLoopSupport.u64,C99NatWord141.word] using
        (C99OuterScalar144.half_eval (mDeclared s) "t".toList t (by omega) tc)))
  obtain ⟨vo,vRun,vFixed,vu,frame⟩ := u1_loop_full m t h mt th mb tb hpos
    (mPrepared s h) a gm gvs pw p0i wide (m_prepared_fixed s a gm gvs pw p0i h fixed)
    mc tc hc none none rfl rfl
  have htOut : USlot vo "ht" h := KeygenNttControl.keep_u64 vRun (by decide) "ht" h (by decide) hc
  have tOut : USlot vo "t" t := KeygenNttControl.keep_u64 vRun (by decide) "t" t (by decide) tc
  have tRun : Exec KeygenNttForwardPrograms.tFromHalf2 vo
      ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ :=
    .assign _ _ _ .uint64 (some (u64 t)) (u64 h) tOut (.scalar _ _ (.variable _ _ _ htOut))
  have inner : Exec KeygenNttForwardPrograms.mInner s
      ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ :=
    .seqNormal _ _ s (mDeclared s) _ dc
      (.seqNormal _ _ (mDeclared s) (mPrepared s h) _ halfRun
      (.seqNormal _ _ (mPrepared s h) vo _ vRun
      (.seqNormal _ _ vo (bindValue vo "t".toList .uint64 (u64 h)) _ tRun
        (.base .skip _ _ (.skip _)))))
  have run : Exec mBlock s
      ⟨C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [],.normal⟩ :=
    .scope mNames _ s ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ inner
  refine ⟨C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [],
    run,?_,?_,?_⟩
  · exact fixed_map vo a gm gvs pw p0i vFixed
      (C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ArrayReference.restoreScope])
      (by simp [mNames,C99ArrayReference.bindValue,C99ArrayReference.restoreScope])
      rfl
  · exact KeygenMkgm3RowInit.set64_slot vo "t" h (by omega)
  · exact frame

end FT1536.Source3.StepNttMiddle195
