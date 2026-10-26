import Source3.FirstStepReturn196

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepEntry196
open C99ArrayReference (State bindValue bindPointer)
open KeygenModpR2Exec (Slot)
open SelectedMakeFgSetup176 (ft)

def fresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def withOut (s : State) : State := bindValue (fresh s) "out_ntt".toList .int32 (.int32 1)
def withIn (s : State) : State := bindValue (withOut s) "in_ntt".toList .int32 (.int32 1)
def withTer (s : State) : State := bindValue (withIn s) "ter".toList .uint32 (.int32 1)
def withDepth (s : State) : State := bindValue (withTer s) "depth".toList .uint32 (.uint32 2)
def withLogn (s : State) : State := bindValue (withDepth s) "logn".toList .uint32 (.uint32 8)
def entry (s : State) : State := bindPointer (withLogn s) "data".toList ft

theorem logn_expr (s : State) (logn : Slot s "logn" 10) (dCell : Slot s "d" 2) :
    C99ArrayReference.scalar s (.bin .sub (FirstStepEntry187.var "logn") (FirstStepEntry187.var "d"))
      (.uint32 8) :=
  .arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn) (.variable _ _ _ dCell)
    (.step .minus (.uint32 10) (.uint32 2) .uint32 rfl (.uint32 10) (.uint32 2) rfl rfl
      (by intro impossible; cases impossible))

theorem out_expr (s : State) (dCell : Slot s "d" 2) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar s FirstStepEntry187.outExpr (.int32 1) :=
  .orTrue _ _ (.int32 1)
    (.compare .lt _ _ _ _ _
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
        (.step .plus (.uint32 2) (.int32 1) .uint32 rfl (.uint32 2) (.uint32 1) rfl rfl
          (by intro impossible; cases impossible)))
      (.variable _ _ _ depth)
      (.step .lt (.uint32 3) (.uint32 10) .uint32 rfl (.uint32 3) (.uint32 10) rfl rfl)) (by decide)

theorem binding (s : State) (data : s.arrays "data".toList=some ft)
    (logn : Slot s "logn" 10) (dCell : Slot s "d" 2) (depth : Slot s "depth" 10) :
    C99ArrayReference.Bind s (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments (entry s) :=
  .pointer "data".toList "data".toList C99ProcedureParser.zero ft _ _ _
    (RootBinding175.zero s "data" ft data (by decide))
    (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 8) (logn_expr s logn dCell)
      (.scalar .uint32 "depth".toList _ _ _ _ (.uint32 2) (.variable _ _ _ dCell)
        (.scalar .uint32 "ter".toList _ _ _ _ (.int32 1) (.literal .int32 1)
          (.scalar .int32 "in_ntt".toList _ _ _ _ (.int32 1) (.literal .int32 1)
            (.scalar .int32 "out_ntt".toList _ [] [] (fresh s) (.int32 1) (out_expr s dCell depth) .nil)))))

theorem entry_heap (s : State) : (entry s).heap=s.heap := rfl
theorem entry_logn (s : State) : Slot (entry s) "logn" 8 := rfl
theorem entry_depth (s : State) : Slot (entry s) "depth" 2 := rfl
theorem entry_ter (s : State) : Slot (entry s) "ter" 1 := rfl
theorem entry_in (s : State) : (entry s).locals "in_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem entry_out (s : State) : (entry s).locals "out_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem entry_data (s : State) : (entry s).arrays "data".toList=some ft := rfl

/-- Concrete d=2 entry and its complete data arrays, after the executed first step. -/
theorem source : ∃ (callee : State) (gvs : Fin 512 → BitVec 32),
    KeygenMakeFgSource.Exec FirstStepEntry187.body FirstStepEntry187.caller
      ⟨FirstStepReturn196.returned callee,.normal⟩ ∧
    KeygenMakeFgSource.Exec FirstStepEntry187.increment (FirstStepReturn196.returned callee)
      ⟨FirstStepReturn196.advance (FirstStepReturn196.returned callee),.normal⟩ ∧
    C99ArrayReference.scalar (FirstStepReturn196.advance (FirstStepReturn196.returned callee))
      FirstStepEntry187.condition (.int32 1) ∧
    C99ArrayReference.Bind (FirstStepReturn196.advance (FirstStepReturn196.returned callee))
      (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (entry (FirstStepReturn196.advance (FirstStepReturn196.returned callee))) ∧
    StepNttImage195.Image (entry (FirstStepReturn196.advance (FirstStepReturn196.returned callee)))
      SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs) ∧
    StepNttImage195.Image (entry (FirstStepReturn196.advance (FirstStepReturn196.returned callee)))
      SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs) := by
  obtain ⟨callee,gvs,stepRun,call,body,increment,guard,dCell,fdImage,gdImage,arrays,locals⟩ :=
    FirstStepReturn196.source
  have data : (FirstStepReturn196.advance (FirstStepReturn196.returned callee)).arrays "data".toList=some ft := by
    rw [arrays]
    exact SelectedTopContinuation186.data_binding
  have logn : Slot (FirstStepReturn196.advance (FirstStepReturn196.returned callee)) "logn" 10 :=
    (locals "logn" (by decide)).trans SelectedTopContinuation186.logn_cell
  have depth : Slot (FirstStepReturn196.advance (FirstStepReturn196.returned callee)) "depth" 10 :=
    (locals "depth" (by decide)).trans SelectedTopContinuation186.depth_cell
  exact ⟨callee,gvs,body,increment,guard,binding _ data logn dCell depth,fdImage,gdImage⟩

end FT1536.Source3.SecondStepEntry196
