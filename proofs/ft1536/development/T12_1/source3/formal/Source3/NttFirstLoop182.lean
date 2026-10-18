import Source3.NttFirstEntry182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttFirstLoop182
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open NttFirstFixed182 (Fixed)

def condition : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "hn".toList)
def body := KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody
def loop : C99ModularReference.Stmt := .loop condition body (KeygenNttForwardPrograms.step "u")

theorem source (n i : Nat) (count : i+n=768) (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32)
    (fixed : Fixed s a gm p p0i w) (counter : USlot s "u" i)
    (first : s.arrays "r1".toList=some (element a i)) (second : s.arrays "r2".toList=some (element a (768+i))) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧ USlot out "u" 768 ∧
      out.arrays "r1".toList=some (element a 768) ∧ out.arrays "r2".toList=some (element a 1536) ∧
      NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  induction n generalizing i s with
  | zero =>
    have equal : i=768 := by omega
    subst i
    exact ⟨s,.loopFalse _ _ _ s (.int32 0)
      (C99LoopScalar141.less s _ _ 768 768 (by decide) (by decide)
        (.variable _ _ _ counter) (.variable _ _ _ fixed.hnCell)) rfl,
      fixed,counter,first,second,NttWriteFrame182.refl a 1536 s.heap⟩
  | succ n ih =>
    have bound : i<768 := by omega
    obtain ⟨a0,read0⟩ := Word32Initialized180.load s.heap (element a i)
      (fixed.allocated i (by omega)) fixed.width (fixed.initialized i (by omega))
    obtain ⟨a1,read1⟩ := Word32Initialized180.load s.heap (element a (768+i))
      (fixed.allocated (768+i) (by omega)) fixed.width (fixed.initialized (768+i) (by omega))
    let middle := NttFirstBody182.after s (element a i) (element a (768+i)) a0 a1 w p p0i
    let next := NttFirstControl182.after middle a i
    have iteration := NttFirstBody182.source s (element a i) (element a (768+i)) a0 a1 w p p0i
      fixed.pCell fixed.iCell fixed.wCell first second (fixed.allocated i (by omega)) (fixed.allocated (768+i) (by omega))
      fixed.width fixed.width fixed.writable fixed.writable read0 read1
    have middleFixed := NttFirstFixed182.body s a gm (element a i) (element a (768+i)) p p0i w a0 a1 fixed
    have localFrame := NttFirstBodyFrame182.locals s (element a i) (element a (768+i)) a0 a1 w p p0i
    have arrayFrame := NttFirstBodyFrame182.arrays s (element a i) (element a (768+i)) a0 a1 w p p0i
    have middleU : USlot middle "u" i := (congrFun localFrame _).trans counter
    have update := NttFirstControl182.source middle a i bound middleU middleFixed.stride middleFixed.capacity
      ((congrFun arrayFrame _).trans first) ((congrFun arrayFrame _).trans second)
    obtain ⟨out,rest,outFixed,outU,outR1,outR2,outFrame⟩ := ih (i+1) (by omega) next
      (NttFirstControl182.fixed middle a gm p p0i w i middleFixed) (NttFirstControl182.counter middle a i bound)
      (NttFirstControl182.first_pointer middle a i) (NttFirstControl182.second_pointer middle a i)
    have memory : NttWriteFrame182.Frame a 1536 s.heap next.heap :=
      NttWriteFrame182.first_body s a 1536 ⟨i,by omega⟩ ⟨768+i,by omega⟩ a0 a1 w p p0i fixed.width
    refine ⟨out,?_,outFixed,outU,outR1,outR2,NttWriteFrame182.trans a 1536 _ _ _ memory outFrame⟩
    have nonzero : (C99ScalarReference.boolean (decide (i<768))).integer≠0 := by
      simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (C99LoopScalar141.less s _ _ i 768 (by omega) (by decide)
        (.variable _ _ _ counter) (.variable _ _ _ fixed.hnCell)) nonzero iteration update rest

theorem full (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (old : Option C99IntegerReference.Value) (declared : s.locals "u".toList=some (.uint64,old)) :
    ∃ out, Exec KeygenNttForwardPrograms.firstLoop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧
      USlot out "u" 768 ∧ out.arrays "r1".toList=some (element a 768) ∧
      out.arrays "r2".toList=some (element a 1536) ∧ NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  have initial := NttFirstEntry182.source s a gm p p0i w fixed old declared
  obtain ⟨out,run,fo,hu,hr1,hr2,frame⟩ := source 768 0 rfl (NttFirstEntry182.after s a) a gm p p0i w
    (NttFirstEntry182.fixed s a gm p p0i w fixed) (NttFirstEntry182.counter s a)
    (NttFirstEntry182.first_pointer s a) (NttFirstEntry182.second_pointer s a)
  exact ⟨out,.seqNormal _ _ s (NttFirstEntry182.after s a) _ initial run,fo,hu,hr1,hr2,frame⟩

end FT1536.Source3.NttFirstLoop182
