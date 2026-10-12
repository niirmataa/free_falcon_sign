import Source3.KeygenCodecCellFrame
import Source3.KeygenCodecNoneLength

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecControl
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecCellFrame (parts)

def normalOnly : Stmt → Bool
  | .ret _ => false
  | .seq a b => normalOnly a && normalOnly b
  | .scope a => normalOnly a
  | .branch _ a b => normalOnly a && normalOnly b
  | .switch _ a b c => normalOnly a && normalOnly b && normalOnly c
  | .whileLoop _ a => normalOnly a
  | .loop a _ b c => normalOnly a && normalOnly b && normalOnly c
  | _ => true

theorem normal_flow (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) (checked : normalOnly stmt=true) : flow=.normal := by
  induction source with
  | skip => rfl
  | declare => rfl
  | bind => rfl
  | scalar => rfl
  | store => rfl
  | increment => rfl
  | evaluate => rfl
  | seq args a b s m t flow first second ih1 ih2 => exact ih2 (parts checked).2
  | seqReturn args a b s t ret first ih => exact ih (parts checked).1
  | scope args a s t flow noBufShadow inside ih => exact ih checked
  | branchTrue args test a b s t flow value locals evaluated yes selected ih => exact ih (parts checked).1
  | branchFalse args test a b s t flow value locals evaluated no selected ih => exact ih (parts checked).2
  | whileDone => rfl
  | whileNext args test a s m t flow value locals evaluated yes iteration rest ih1 ih2 => exact ih2 checked
  | whileReturn args test a s t ret value locals evaluated yes iteration ih => exact ih checked
  | forLoop args a test b c s t flow expanded ih =>
    apply ih
    simpa only [desugar,normalOnly,Bool.and_eq_true,and_assoc,and_left_comm,and_comm] using checked
  | switchNone args test a b c s t flow value locals evaluated zero selected ih => exact ih (parts (parts checked).1).1
  | switchStatic args test a b c s t flow value locals evaluated one selected ih => exact ih (parts (parts checked).1).2
  | switchOther args test a b c s t flow value locals evaluated notZero notOne selected ih => exact ih (parts checked).2
  | ret => simp [normalOnly] at checked
  | call => simp [normalOnly] at checked

theorem seq_split (args : Args) (a b : Stmt) (s t : State) (flow : Flow)
    (source : Exec args (.seq a b) s t flow) (checked : normalOnly a=true) :
    ∃ m, Exec args a s m .normal ∧ Exec args b m t flow := by
  cases source with
  | seq args a b s m t flow first second => exact ⟨m,first,second⟩
  | seqReturn args a b s t ret first => cases normal_flow args a s t (.returned ret) first checked

def lengths : Stmt → Bool
  | .ret e => e==.variable "len".toList || e==.number .i32 0
  | .seq a b => lengths a && lengths b
  | .scope a => lengths a
  | .branch _ a b => lengths a && lengths b
  | .switch _ a b c => lengths a && lengths b && lengths c
  | .whileLoop _ a => lengths a
  | .loop a _ b c => lengths a && lengths b && lengths c
  | _ => true

def LengthFlow (flow : Flow) : Prop := flow=.normal ∨ flow=.returned 0 ∨ flow=.returned 3072

theorem return_len (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l t : Locals) (v : C99IntegerReference.Value)
    (cell : l.scalars "len".toList=some (.uint64,some (.uint64 3072)))
    (source : Eval args heap buf (.variable "len".toList) l (.integer v) t) : v=.uint64 3072 := by
  cases source
  simp_all

/-- The full remaining NONE suffix can return only its derived length or
    the source zero rejection. The length cell is transported by execution. -/
theorem length_flow (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow)
    (frame : KeygenCodecCellFrame.statement "len".toList stmt=true)
    (checked : lengths stmt=true)
    (cell : s.locals.scalars "len".toList=some (.uint64,some (.uint64 3072))) : LengthFlow flow := by
  induction source with
  | skip => exact Or.inl rfl
  | declare => exact Or.inl rfl
  | bind => exact Or.inl rfl
  | scalar => exact Or.inl rfl
  | store => exact Or.inl rfl
  | increment => exact Or.inl rfl
  | evaluate => exact Or.inl rfl
  | seq args a b s m t flow first second ih1 ih2 =>
    exact ih2 (parts frame).2 (parts checked).2
      ((KeygenCodecCellFrame.exec_frame "len".toList args a s m .normal first (parts frame).1).trans cell)
  | seqReturn args a b s t ret first ih => exact ih (parts frame).1 (parts checked).1 cell
  | scope args a s t flow noBufShadow inside ih => exact ih frame checked cell
  | branchTrue args test a b s t flow value locals evaluated yes selected ih =>
    exact ih (parts (parts frame).1).2 (parts checked).1
      ((KeygenCodecCellFrame.eval_frame "len".toList args s.heap s.buf test s.locals locals value evaluated (parts (parts frame).1).1).trans cell)
  | branchFalse args test a b s t flow value locals evaluated no selected ih =>
    exact ih (parts frame).2 (parts checked).2
      ((KeygenCodecCellFrame.eval_frame "len".toList args s.heap s.buf test s.locals locals value evaluated (parts (parts frame).1).1).trans cell)
  | whileDone => exact Or.inl rfl
  | whileNext args test a s m t flow value locals evaluated yes iteration rest ih1 ih2 =>
    have start := (KeygenCodecCellFrame.eval_frame "len".toList args s.heap s.buf test s.locals locals value evaluated (parts frame).1).trans cell
    exact ih2 frame checked
      ((KeygenCodecCellFrame.exec_frame "len".toList args a (withLocals s locals) m .normal iteration (parts frame).2).trans start)
  | whileReturn args test a s t ret value locals evaluated yes iteration ih =>
    exact ih (parts frame).2 checked
      ((KeygenCodecCellFrame.eval_frame "len".toList args s.heap s.buf test s.locals locals value evaluated (parts frame).1).trans cell)
  | forLoop args a test b c s t flow expanded ih =>
    apply ih
    · simpa only [desugar,KeygenCodecCellFrame.statement,Bool.and_eq_true,and_assoc,and_left_comm,and_comm] using frame
    · simpa only [desugar,lengths,Bool.and_eq_true,and_assoc,and_left_comm,and_comm] using checked
    · exact cell
  | switchNone args test a b c s t flow value locals evaluated zero selected ih =>
    exact ih (parts (parts (parts frame).1).1).2 (parts (parts checked).1).1
      ((KeygenCodecCellFrame.eval_frame "len".toList args s.heap s.buf test s.locals locals (.integer value) evaluated (parts (parts (parts frame).1).1).1).trans cell)
  | switchStatic args test a b c s t flow value locals evaluated one selected ih =>
    exact ih (parts (parts frame).1).2 (parts (parts checked).1).2
      ((KeygenCodecCellFrame.eval_frame "len".toList args s.heap s.buf test s.locals locals (.integer value) evaluated (parts (parts (parts frame).1).1).1).trans cell)
  | switchOther args test a b c s t flow value locals evaluated notZero notOne selected ih =>
    exact ih (parts frame).2 (parts checked).2
      ((KeygenCodecCellFrame.eval_frame "len".toList args s.heap s.buf test s.locals locals (.integer value) evaluated (parts (parts (parts frame).1).1).1).trans cell)
  | ret args s e value locals evaluated =>
    have choice : e=.variable "len".toList ∨ e=.number .i32 0 := by simpa [lengths,Bool.or_eq_true] using checked
    rcases choice with same | same
    · subst e
      have equal := return_len args s.heap s.buf s.locals locals value cell evaluated
      subst value
      exact Or.inr (Or.inr rfl)
    · subst e
      obtain ⟨equal,_⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 0 (.int32 0) s.locals locals (.integer value) (by decide +kernel) evaluated
      have integer : value=.int32 0 := Value.integer.inj equal
      subst value
      exact Or.inr (Or.inl rfl)
  | call => simp [lengths] at checked

end FT1536.Source3.KeygenCodecControl
