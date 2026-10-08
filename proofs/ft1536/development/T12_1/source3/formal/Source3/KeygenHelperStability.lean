import Source3.KeygenMemoryStability

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenHelperStability
open KeygenMemoryStability
open C99ArrayReference (State)
open C99ProcedureReference (Result)
theorem compose (a b c : C99MemoryReference.Memory) (first : Stable a b) (second : Stable b c) : Stable a c :=
  KeygenMemoryStability.trans a b c first second

theorem level_call (kind : KeygenLevelCalls.Kind) (before after : State) (args : List KeygenLevelCalls.Arg)
    (source : KeygenLevelCalls.Call kind before args after) : Stable before.heap after.heap := by
  cases source with
  | run entry out binding execution returned =>
    have result := modular _ _ _ execution
    rw [KeygenLevelCalls.bind_heap _ _ _ _ binding] at result
    exact result
theorem level (code : KeygenLevelExec.Stmt) (before : State) (out : Result)
    (source : KeygenLevelExec.Exec code before out) : Stable before.heap out.state.heap := by
  induction source
  case modular code before out source => exact modular _ _ _ source
  case call kind args before after source => exact level_call _ _ _ _ source
  case move dst src di si count before after p q word destination source length copy => exact move _ _ _ _ _ copy
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem binary (code : KeygenBinaryNtt.Stmt) (before : State) (out : Result)
    (source : KeygenBinaryNtt.Exec code before out) : Stable before.heap out.state.heap := by
  induction source
  case base code before out source => exact modular _ _ _ source
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem binary_call (kind : KeygenBinaryNtt.Kind) (before after : State) (args : List KeygenLevelCalls.Arg)
    (source : KeygenBinaryNtt.Call kind before args after) : Stable before.heap after.heap := by
  cases source with
  | run entry out binding execution returned =>
    have result := binary _ _ _ execution
    rw [KeygenLevelCalls.bind_heap _ _ _ _ binding] at result
    exact result
theorem make_top (before after : State) (args : List C99ArrayReference.Arg)
    (source : KeygenMakeFgTop.Call before args after) : Stable before.heap after.heap := by
  cases source with
  | run entry out binding execution returned =>
    have result := level _ _ _ execution
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
    exact result
theorem make (code : KeygenMakeFgSource.Stmt) (before : State) (out : Result)
    (source : KeygenMakeFgSource.Exec code before out) : Stable before.heap out.state.heap := by
  induction source
  case level code before out source => exact level _ _ _ source
  case zint code before out source => exact zint _ _ _ source
  case word code before out source => exact word _ _ _ source
  case binary kind args before after source => exact binary_call _ _ _ _ source
  case top args before after source => exact make_top _ _ _ source
  case step args before entry out binding source returned ih =>
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at ih
    exact ih
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem top (code : KeygenZintTop.Stmt) (before : State) (out : Result)
    (source : KeygenZintTop.Exec code before out) : Stable before.heap out.state.heap := by
  induction source
  case core code before out source => exact zint _ _ _ source
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem top_call (before after : State) (args : List C99ArrayReference.Arg) (v : C99IntegerReference.Value)
    (source : KeygenZintTop.Call before args after v) : Stable before.heap after.heap := by
  obtain ⟨entry,out,binding,execution,_,rfl⟩ := source
  have result := top _ _ _ execution
  rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
  exact result
theorem poly (code : KeygenZintPoly.Stmt) (before : State) (out : Result)
    (source : KeygenZintPoly.Exec code before out) : Stable before.heap out.state.heap := by
  induction source
  case base code before out source => exact top _ _ _ source
  case scaledStore array index args exponent before middle after p z e v source scale convert address write =>
    exact trans _ _ _ (top_call _ _ _ _ source) (store64 _ _ _ _ write)
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem scaled_call (kind : KeygenZintScaled.Kind) (before after : State) (args : List KeygenZintScaled.Arg)
    (source : KeygenZintScaled.Call kind before args after) : Stable before.heap after.heap := by
  obtain ⟨entry,out,binding,execution,_,rfl⟩ := source
  have result := zint _ _ _ execution
  rw [KeygenZintScaled.bind_heap _ _ _ _ binding] at result
  exact result
theorem quadratic (code : KeygenPolySubScaled.Stmt) (before after : State)
    (source : KeygenPolySubScaled.Exec code before after) : Stable before.heap after.heap := by
  induction source
  case addScaled args before after source => exact scaled_call _ _ _ _ source
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem sub_ntt (code : KeygenPolySubNtt.Stmt) (before : State) (out : Result)
    (source : KeygenPolySubNtt.Exec code before out) : Stable before.heap out.state.heap := by
  induction source
  case base code before out source => exact make _ _ _ source
  case divide code before out source => exact top _ _ _ source
  case subtract args before entry out binding source returned =>
    have result := zint _ _ _ source
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
    exact result
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]

end FT1536.Source3.KeygenHelperStability
