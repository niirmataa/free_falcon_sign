import Source3.NttTripleEntry184
import Source3.NttMiddleTable183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleLoop184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open NttFirstFixed182 (Fixed)

def condition : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "n".toList)
def body := KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody
def loop : C99ModularReference.Stmt := .loop condition body KeygenNttForwardPrograms.tripleStep

theorem source (n j : Nat) (count : j+n=512)
    (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (sep : NttMiddleTable183.Separate a gm) (reads : NttMiddleTable183.Reads s.heap gm)
    (uc : USlot s "u" (3*j)) (rc : USlot s "r" (512+j)) (ptr : s.arrays "r1".toList=some (element a (3*j))) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧ USlot out "u" 1536 ∧
      USlot out "r" 1024 ∧ NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  induction n generalizing j s with
  | zero =>
    have equal : j=512 := by omega
    subst j
    exact ⟨s,.loopFalse _ _ _ s (.int32 0)
      (C99LoopScalar141.less s (.var "u".toList) (.var "n".toList) 1536 1536 (by decide) (by decide)
        (.variable _ _ _ uc) (.variable _ _ _ fixed.nCell)) rfl,
      fixed,uc,rc,NttWriteFrame182.refl a 1536 s.heap⟩
  | succ n ih =>
    have bound : j<512 := by omega
    have addressBound : 3*j+2<1536 := by omega
    obtain ⟨x,readX⟩ := reads (512+j) (by omega)
    obtain ⟨vA,readA⟩ := Word32Initialized180.load s.heap (element a (3*j))
      (fixed.allocated _ (by omega)) fixed.width (fixed.initialized _ (by omega))
    obtain ⟨vB,readB⟩ := Word32Initialized180.load s.heap (element a (3*j+1))
      (fixed.allocated _ (by omega)) fixed.width (fixed.initialized _ (by omega))
    obtain ⟨vC,readC⟩ := Word32Initialized180.load s.heap (element a (3*j+2))
      (fixed.allocated _ (by omega)) fixed.width (fixed.initialized _ (by omega))
    let z : NttTripleStates184.Words := ⟨vA,vB,vC,x,w,p,p0i⟩
    let middle := NttTripleStates184.after s a (3*j) z
    let next := NttTripleControl184.after middle a j
    have iteration := NttTripleBody184.source s a gm (3*j) (512+j) z fixed addressBound (by omega) ptr rc readX readA readB readC
    have middleFixed := NttTripleFrame184.fixed s a gm (3*j) z fixed iteration
    have localFrame := NttTripleFrame184.locals s _ iteration
    have arrayFrame := NttTripleFrame184.arrays s _ iteration
    have update := NttTripleControl184.source middle a j bound ((congrFun localFrame _).trans uc)
      ((congrFun localFrame _).trans rc) middleFixed.stride ((congrFun arrayFrame _).trans ptr) middleFixed.capacity
    have memory := NttTripleFrame184.frame s a (3*j) z addressBound fixed.width
    obtain ⟨out,rest,fo,uo,ro,frame⟩ := ih (j+1) (by omega) next
      (NttTripleControl184.fixed middle a gm p p0i w j middleFixed)
      (NttMiddleTable183.transport s.heap middle.heap a gm sep memory reads)
      (NttTripleControl184.u_cell middle a j bound) (NttTripleControl184.r_cell middle a j bound)
      (NttTripleControl184.pointer middle a j)
    refine ⟨out,?_,fo,uo,ro,NttWriteFrame182.trans a 1536 _ _ _ memory frame⟩
    have nonzero : (C99ScalarReference.boolean (decide (3*j<1536))).integer≠0 := by
      have lt : 3*j<1536 := by omega
      simp [lt,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (C99LoopScalar141.less s (.var "u".toList) (.var "n".toList) (3*j) 1536 (by omega) (by decide)
        (.variable _ _ _ uc) (.variable _ _ _ fixed.nCell)) nonzero iteration update rest

theorem full (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (sep : NttMiddleTable183.Separate a gm) (reads : NttMiddleTable183.Reads s.heap gm) (logn : Slot s "logn" 10)
    (oldU oldR : Option C99IntegerReference.Value)
    (du : s.locals "u".toList=some (.uint64,oldU)) (dr : s.locals "r".toList=some (.uint64,oldR)) :
    ∃ out, Exec KeygenNttForwardPrograms.tripleLoop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧
      USlot out "u" 1536 ∧ USlot out "r" 1024 ∧ NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  obtain ⟨out,run,fo,uo,ro,frame⟩ := source 512 0 rfl (NttTripleEntry184.after s a) a gm p p0i w
    (NttTripleEntry184.fixed s a gm p p0i w fixed) sep reads rfl rfl rfl
  exact ⟨out,.seqNormal _ _ s (NttTripleEntry184.after s a) _ (NttTripleEntry184.source s a gm p p0i w fixed logn oldU oldR du dr) run,
    fo,uo,ro,frame⟩

end FT1536.Source3.NttTripleLoop184
