import Source3.KeygenCodecControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStateFrame
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecCellFrame (parts)

def preserves (heapMode : Bool) : Stmt → Bool
  | .declare os => heapMode || !hasBuf os
  | .write (.variable n) _ _ => heapMode || n != "buf".toList
  | .write (.index (.variable _) _) .set _ => !heapMode
  | .seq a b => preserves heapMode a && preserves heapMode b
  | .scope a => preserves heapMode a
  | .branch _ a b => preserves heapMode a && preserves heapMode b
  | .switch _ a b c => preserves heapMode a && preserves heapMode b && preserves heapMode c
  | .whileLoop _ a => preserves heapMode a
  | .loop a _ b c => preserves heapMode a && preserves heapMode b && preserves heapMode c
  | .ret (.call _ _) => false
  | _ => true

def Same (heapMode : Bool) (s t : State) : Prop :=
  if heapMode then t.heap=s.heap else t.buf=s.buf

theorem exec_same (heapMode : Bool) (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) (checked : preserves heapMode stmt=true) : Same heapMode s t := by
  induction source with
  | skip => cases heapMode <;> rfl
  | declare args s os locals declarations =>
    cases heapMode
    · have no : hasBuf os=false := by simpa [preserves] using checked
      simp [Same,declared,no]
    · rfl
  | bind =>
    cases heapMode
    · simp [preserves] at checked
    · rfl
  | scalar => cases heapMode <;> rfl
  | store =>
    cases heapMode
    · rfl
    · simp [preserves] at checked
  | increment => cases heapMode <;> rfl
  | evaluate => cases heapMode <;> rfl
  | seq args a b s m t flow first second ih1 ih2 =>
    have one := ih1 (parts checked).1
    have two := ih2 (parts checked).2
    cases heapMode <;> exact two.trans one
  | seqReturn args a b s t ret first ih => exact ih (parts checked).1
  | scope args a s t flow noBufShadow inside ih =>
    have same := ih checked
    cases heapMode
    · change (if _ then s.buf else t.buf)=_
      split
      · rfl
      · exact same
    · exact same
  | branchTrue args test a b s t flow value locals evaluated yes selected ih => exact ih (parts checked).1
  | branchFalse args test a b s t flow value locals evaluated no selected ih => exact ih (parts checked).2
  | whileDone => cases heapMode <;> rfl
  | whileNext args test a s m t flow value locals evaluated yes iteration rest ih1 ih2 =>
    have one := ih1 checked
    have two := ih2 checked
    cases heapMode <;> exact two.trans one
  | whileReturn args test a s t ret value locals evaluated yes iteration ih => exact ih checked
  | forLoop args a test b c s t flow expanded ih =>
    apply ih
    simpa only [desugar,preserves,Bool.and_eq_true,and_assoc,and_left_comm,and_comm] using checked
  | switchNone args test a b c s t flow value locals evaluated zero selected ih => exact ih (parts (parts checked).1).1
  | switchStatic args test a b c s t flow value locals evaluated one selected ih => exact ih (parts (parts checked).1).2
  | switchOther args test a b c s t flow value locals evaluated notZero notOne selected ih => exact ih (parts checked).2
  | ret => cases heapMode <;> rfl
  | call => simp [preserves] at checked

theorem heap_frame (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) (checked : preserves true stmt=true) : t.heap=s.heap :=
  exec_same true args stmt s t flow source checked

theorem buf_frame (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) (checked : preserves false stmt=true) : t.buf=s.buf :=
  exec_same false args stmt s t flow source checked

end FT1536.Source3.KeygenCodecStateFrame
