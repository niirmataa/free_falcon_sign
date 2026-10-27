import Source3.SecondStepReturn212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepEntry215
open C99ArrayReference (State bindValue bindPointer)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open ZintNormWalkFlat208 (Data)
open SelectedMakeFgSetup176 (ft)

def fresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def withOut (s : State) : State := bindValue (fresh s) "out_ntt".toList .int32 (.int32 1)
def withIn (s : State) : State := bindValue (withOut s) "in_ntt".toList .int32 (.int32 1)
def withTer (s : State) : State := bindValue (withIn s) "ter".toList .uint32 (.int32 1)
def withDepth (s : State) : State := bindValue (withTer s) "depth".toList .uint32 (.uint32 3)
def withLogn (s : State) : State := bindValue (withDepth s) "logn".toList .uint32 (.uint32 7)
def entry (s : State) : State := bindPointer (withLogn s) "data".toList ft

theorem logn_expr (s : State) (logn : Slot s "logn" 10) (dCell : Slot s "d" 3) :
    C99ArrayReference.scalar s (.bin .sub (FirstStepEntry187.var "logn") (FirstStepEntry187.var "d"))
      (.uint32 7) :=
  .arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn) (.variable _ _ _ dCell)
    (.step .minus (.uint32 10) (.uint32 3) .uint32 rfl (.uint32 10) (.uint32 3) rfl rfl
      (by intro impossible; cases impossible))

theorem out_expr (s : State) (dCell : Slot s "d" 3) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar s FirstStepEntry187.outExpr (.int32 1) :=
  .orTrue _ _ (.int32 1)
    (.compare .lt _ _ _ _ _
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
        (.step .plus (.uint32 3) (.int32 1) .uint32 rfl (.uint32 3) (.uint32 1) rfl rfl
          (by intro impossible; cases impossible)))
      (.variable _ _ _ depth)
      (.step .lt (.uint32 4) (.uint32 10) .uint32 rfl (.uint32 4) (.uint32 10) rfl rfl)) (by decide)

theorem binding (s : State) (data : s.arrays "data".toList=some ft)
    (logn : Slot s "logn" 10) (dCell : Slot s "d" 3) (depth : Slot s "depth" 10) :
    C99ArrayReference.Bind s (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments (entry s) :=
  .pointer "data".toList "data".toList C99ProcedureParser.zero ft _ _ _
    (RootBinding175.zero s "data" ft data (by decide))
    (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 7) (logn_expr s logn dCell)
      (.scalar .uint32 "depth".toList _ _ _ _ (.uint32 3) (.variable _ _ _ dCell)
        (.scalar .uint32 "ter".toList _ _ _ _ (.int32 1) (.literal .int32 1)
          (.scalar .int32 "in_ntt".toList _ _ _ _ (.int32 1) (.literal .int32 1)
            (.scalar .int32 "out_ntt".toList _ [] [] (fresh s) (.int32 1) (out_expr s dCell depth) .nil)))))

theorem entry_heap (s : State) : (entry s).heap=s.heap := rfl
theorem entry_logn (s : State) : Slot (entry s) "logn" 7 := rfl
theorem entry_depth (s : State) : Slot (entry s) "depth" 3 := rfl
theorem entry_ter (s : State) : Slot (entry s) "ter" 1 := rfl
theorem entry_in (s : State) : (entry s).locals "in_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem entry_out (s : State) : (entry s).locals "out_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem entry_data (s : State) : (entry s).arrays "data".toList=some ft := rfl

/-- Concrete d=3 entry and its complete data arrays, after the executed second
    step, the d=2→3 increment and the taken d<depth guard. -/
theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨out,.normal⟩ ∧
    Exec FirstStepEntry187.increment (SecondStepReturn212.returned callee out)
      ⟨SecondStepReturn212.advance (SecondStepReturn212.returned callee out),.normal⟩ ∧
    C99ArrayReference.scalar (SecondStepReturn212.advance (SecondStepReturn212.returned callee out))
      FirstStepEntry187.condition (.int32 1) ∧
    C99ArrayReference.Bind (SecondStepReturn212.advance (SecondStepReturn212.returned callee out))
      (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (entry (SecondStepReturn212.advance (SecondStepReturn212.returned callee out))) ∧
    Data (entry (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)))
      SecondStepLayout197.fd 384 (SecondStepImage212.fWords oldWords ivs0 ivs1 gvs2) ∧
    Data (entry (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)))
      SecondStepLayout197.gd 384 (SecondStepImage212.gWords oldWords ivs0 ivs1 gvs2) := by
  obtain ⟨callee,out,oldWords,ivs0,ivs1,gvs2,run1,run2,callRun,bodyRun,incRun,guard,dCell,fImage,gImage,
    arraysKeep,localsKeep⟩ := SecondStepReturn212.source
  have data :
      (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)).arrays "data".toList=some ft := by
    change (SecondStepLengths197.caller callee).arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn : Slot (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)) "logn" 10 :=
    (ModularAtoms178.outside (SecondStepReturn212.returned callee out) "d" "logn" 3 (by decide)).trans
      SelectedTopContinuation186.logn_cell
  have depth : Slot (SecondStepReturn212.advance (SecondStepReturn212.returned callee out)) "depth" 10 :=
    (ModularAtoms178.outside (SecondStepReturn212.returned callee out) "d" "depth" 3 (by decide)).trans
      SelectedTopContinuation186.depth_cell
  exact ⟨callee,out,oldWords,ivs0,ivs1,gvs2,run1,run2,incRun,guard,
    binding _ data logn dCell depth,fImage,gImage⟩

end FT1536.Source3.ThirdStepEntry215
