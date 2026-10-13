import Source3.KeygenDecodeCellFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeControl
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCellFrame (parts)

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
  | seq a b s m t flow first second ih1 ih2 => exact ih2 (parts checked).2
  | seqReturn a b s t ret first ih => exact ih (parts checked).1
  | scope a s t flow noBufShadow inside ih => exact ih checked
  | branchTrue test a b s t flow value locals evaluated yes selected ih => exact ih (parts checked).1
  | branchFalse test a b s t flow value locals evaluated no selected ih => exact ih (parts checked).2
  | whileDone => rfl
  | whileNext test a s m t flow value locals evaluated yes iteration rest ih1 ih2 => exact ih2 checked
  | whileReturn test a s t ret value locals evaluated yes iteration ih => exact ih checked
  | forLoop a test b c s t flow expanded ih =>
    apply ih
    simpa only [desugar,normalOnly,Bool.and_eq_true,and_assoc,and_left_comm,and_comm] using checked
  | ret => simp [normalOnly] at checked

theorem seq_split (args : Args) (a b : Stmt) (s t : State) (flow : Flow)
    (source : Exec args (.seq a b) s t flow) (checked : normalOnly a=true) :
    ∃ m, Exec args a s m .normal ∧ Exec args b m t flow := by
  cases source with
  | seq a b s m t flow first second => exact ⟨m,first,second⟩
  | seqReturn a b s t ret first => cases normal_flow args a s t (.returned ret) first checked


/-- Split a sequence when an actual source theorem establishes that its
    first component cannot return. This does not replace a branch proof
    by a syntactic no-return assumption. -/
theorem seq_split_given (args : Args) (a b : Stmt) (s t : State) (flow : Flow)
    (source : Exec args (.seq a b) s t flow)
    (normal : ∀ next result, Exec args a s next result → result=.normal) :
    ∃ middle, Exec args a s middle .normal ∧ Exec args b middle t flow := by
  cases source with
  | seq a b s middle t flow first second => exact ⟨middle,first,second⟩
  | seqReturn a b s t ret first => cases normal t (.returned ret) first

end FT1536.Source3.KeygenDecodeControl
