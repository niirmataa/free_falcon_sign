import Source3.BezoutLengthCells217
import Source3.KeygenSearchStability

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Selected good branch executes the original first two initialization copies. -/
namespace FT1536.Source3.SelectedBezoutInitCopies217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)

noncomputable def finish (rebuilt : State) (F G : Nat → BitVec 32) :=
  BezoutInitCopies217.after (state rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335)
def code : KeygenZintCall.Stmt := .seq (KeygenZintCall.bezoutPart 3) (.seq BezoutInitCopies217.first BezoutInitCopies217.second)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false →
      KeygenZintCall.Exec code (state rebuilt F G) ⟨finish rebuilt F G,.normal⟩ ∧
      Data (finish rebuilt F G) fd 335 (X F G) ∧ Data (finish rebuilt F G) gd 335 (Y F G) ∧
      Data (finish rebuilt F G) a (highest (X F G) 335) (X F G) ∧
      Data (finish rebuilt F G) b (highest (Y F G) 335) (Y F G)) := by
  obtain ⟨made,rebuilt,F,G,part2,_,_,crt,_,_,_,guard,xf,yf⟩:=SelectedBezoutGuard217.selected
  have initialExtent : 4*71680≤SelectedDeepestConfig175.after.heap.size 31 := by
    change 4*71680≤SelectedMakeFgSetup176.after.heap.size 31
    exact SelectedMakeFgDomains176.extent
  have initialSize : SelectedDeepestConfig175.after.heap.size 31<2^64 := by
    change SelectedMakeFgSetup176.after.heap.size 31<2^64
    exact SelectedMakeFgDomains176.size_bound
  have initialWritable : SelectedDeepestConfig175.after.heap.writable 31=true := by
    change SelectedMakeFgSetup176.after.heap.writable 31=true
    exact SelectedMakeFgDomains176.writable
  have firstStable := KeygenSearchStability.deepest env.ctx _ _ _ part2
  have crtStable := KeygenSearchStability.deepest env.ctx _ _ _ crt
  have stable := KeygenMemoryStability.trans _ _ _ firstStable crtStable
  have sameHeap : (state rebuilt F G).heap=rebuilt.heap :=
    (BezoutLengthCells217.heap _ _ _).trans (BezoutPointerSetup217.heap rebuilt)
  have extent : 4*71680≤(state rebuilt F G).heap.size 31 := by rw [sameHeap,stable.size]; exact initialExtent
  have size : (state rebuilt F G).heap.size 31<2^64 := by rw [sameHeap,stable.size]; exact initialSize
  have writable : (state rebuilt F G).heap.writable 31=true := by rw [sameHeap,stable.writable]; exact initialWritable
  have ab : (state rebuilt F G).arrays "a".toList=some a := by rfl
  have bb : (state rebuilt F G).arrays "b".toList=some b := by rfl
  have xb : (state rebuilt F G).arrays "x".toList=some fd := BezoutPointerSetup217.x_binding rebuilt
  have yb : (state rebuilt F G).arrays "y".toList=some gd := BezoutPointerSetup217.y_binding rebuilt
  have input : BezoutInitCopies217.Input (state rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335) (X F G) (Y F G) :=
    ⟨ExactLengthProgram217.highest_le _ _,ExactLengthProgram217.highest_le _ _,
      BezoutLengthCells217.xcell _ _ _,BezoutLengthCells217.ycell _ _ _,ab,bb,xb,yb,xf,yf,extent,size,writable⟩
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  have guardRun : KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G) ⟨state rebuilt F G,.normal⟩ := by
    simpa only [good,Bool.false_eq_true,ite_false] using guard
  obtain ⟨first,second,xafter,yafter,aafter,bafter⟩:=BezoutInitCopies217.source _ _ _ _ _ input
  exact ⟨.seqNormal _ _ _ _ _ guardRun (.seqNormal _ _ _ _ _ first second),xafter,yafter,aafter,bafter⟩

end FT1536.Source3.SelectedBezoutInitCopies217
