import Source3.NttVControl183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttVLoop183
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open NttFirstFixed182 (Fixed)

def condition : CLogic.Expr := .cmp .lt (.var "v".toList) (.var "ht".toList)
def body := KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody
def loop : C99ModularReference.Stmt := .loop condition body (KeygenNttForwardPrograms.step "v")

theorem source (n i h l : Nat) (count : i+n=h) (range : l+2*h≤1536) (hb : h≤768)
    (s : State) (a gm : ArrayPointer) (p p0i w tw : BitVec 32)
    (fixed : Fixed s a gm p p0i w) (counter : USlot s "v" i) (limit : USlot s "ht" h) (twiddle : Slot s "s" tw)
    (first : s.arrays "r1".toList=some (element a (l+i))) (second : s.arrays "r2".toList=some (element a (l+h+i))) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧ USlot out "v" h ∧
      NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  induction n generalizing i s with
  | zero =>
    have equal : i=h := by omega
    subst i
    exact ⟨s,.loopFalse _ _ _ s (C99ScalarReference.boolean (decide (h<h)))
      (C99LoopScalar141.less s (.var "v".toList) (.var "ht".toList) h h (by omega) (by omega)
        (.variable _ _ _ counter) (.variable _ _ _ limit))
      (by simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer]),
      fixed,counter,NttWriteFrame182.refl a 1536 s.heap⟩
  | succ n ih =>
    have bound : i<h := by omega
    have lb : l+i<1536 := by omega
    have rb : l+h+i<1536 := by omega
    obtain ⟨x,read0⟩ := Word32Initialized180.load s.heap (element a (l+i))
      (fixed.allocated _ lb) fixed.width (fixed.initialized _ lb)
    obtain ⟨y,read1⟩ := Word32Initialized180.load s.heap (element a (l+h+i))
      (fixed.allocated _ rb) fixed.width (fixed.initialized _ rb)
    let middle := NttBinaryBody183.after s (element a (l+i)) (element a (l+h+i)) x y tw p p0i
    let next := NttVControl183.after middle a (l+i) (l+h+i) i
    have iteration := NttBinaryBody183.source s (element a (l+i)) (element a (l+h+i)) x y tw p p0i
      fixed.pCell fixed.iCell twiddle first second (fixed.allocated _ lb) (fixed.allocated _ rb)
      fixed.width fixed.width fixed.writable fixed.writable read0 read1
    have middleFixed := NttBinaryFrame183.fixed s a gm (element a (l+i)) (element a (l+h+i)) p p0i w x y tw fixed
    have localFrame := NttBinaryFrame183.locals s (element a (l+i)) (element a (l+h+i)) x y tw p p0i
    have arrayFrame := NttBinaryFrame183.arrays s (element a (l+i)) (element a (l+h+i)) x y tw p p0i
    have update := NttVControl183.source middle a (l+i) (l+h+i) i (by omega) lb rb
      ((congrFun localFrame _).trans counter) middleFixed.stride middleFixed.capacity
      ((congrFun arrayFrame _).trans first) ((congrFun arrayFrame _).trans second)
    have nextFirst : next.arrays "r1".toList=some (element a (l+(i+1))) := by
      simpa only [next,Nat.add_assoc] using NttVControl183.first_pointer middle a (l+i) (l+h+i) i
    have nextSecond : next.arrays "r2".toList=some (element a (l+h+(i+1))) := by
      simpa only [next,Nat.add_assoc] using NttVControl183.second_pointer middle a (l+i) (l+h+i) i
    obtain ⟨out,rest,outFixed,outV,outFrame⟩ := ih (i+1) (by omega) next
      (NttVControl183.fixed middle a gm p p0i w (l+i) (l+h+i) i middleFixed)
      (NttVControl183.counter middle a (l+i) (l+h+i) i (by omega))
      ((congrFun localFrame _).trans limit) ((congrFun localFrame _).trans twiddle) nextFirst nextSecond
    have memory : NttWriteFrame182.Frame a 1536 s.heap next.heap :=
      NttBinaryFrame183.frame s a ⟨l+i,lb⟩ ⟨l+h+i,rb⟩ x y tw p p0i fixed.width
    refine ⟨out,?_,outFixed,outV,NttWriteFrame182.trans a 1536 _ _ _ memory outFrame⟩
    have nonzero : (C99ScalarReference.boolean (decide (i<h))).integer≠0 := by
      simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (C99LoopScalar141.less s (.var "v".toList) (.var "ht".toList) i h (by omega) (by omega)
        (.variable _ _ _ counter) (.variable _ _ _ limit)) nonzero iteration update rest

theorem full (h l : Nat) (range : l+2*h≤1536) (hb : h≤768)
    (s : State) (a gm : ArrayPointer) (p p0i w tw : BitVec 32)
    (fixed : Fixed s a gm p p0i w) (limit : USlot s "ht" h) (twiddle : Slot s "s" tw)
    (first : s.arrays "r1".toList=some (element a l)) (second : s.arrays "r2".toList=some (element a (l+h)))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec KeygenNttForwardPrograms.vLoop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧
      USlot out "v" h ∧ NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  obtain ⟨out,run,fo,hv,frame⟩ := source h 0 h l (Nat.zero_add h) range hb (NttVControl183.put s 0) a gm p p0i w tw
    (NttVControl183.initial_fixed s a gm p p0i w fixed) rfl limit twiddle first second
  exact ⟨out,.seqNormal _ _ s (NttVControl183.put s 0) _ (NttVControl183.initial s old declared) run,fo,hv,frame⟩

end FT1536.Source3.NttVLoop183
