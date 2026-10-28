import Source3.FourthStepReturn216

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FifthStepEntry217
open C99ArrayReference (State bindValue bindPointer)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open ZintNormWalkFlat208 (Data)
open SelectedMakeFgSetup176 (ft)

def fresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def withOut (s : State) : State := bindValue (fresh s) "out_ntt".toList .int32 (.int32 1)
def withIn (s : State) : State := bindValue (withOut s) "in_ntt".toList .int32 (.int32 1)
def withTer (s : State) : State := bindValue (withIn s) "ter".toList .uint32 (.int32 1)
def withDepth (s : State) : State := bindValue (withTer s) "depth".toList .uint32 (.uint32 5)
def withLogn (s : State) : State := bindValue (withDepth s) "logn".toList .uint32 (.uint32 5)
def entry (s : State) : State := bindPointer (withLogn s) "data".toList ft

theorem logn_expr (s : State) (logn : Slot s "logn" 10) (dCell : Slot s "d" 5) :
    C99ArrayReference.scalar s (.bin .sub (FirstStepEntry187.var "logn") (FirstStepEntry187.var "d"))
      (.uint32 5) :=
  .arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn) (.variable _ _ _ dCell)
    (.step .minus (.uint32 10) (.uint32 5) .uint32 rfl (.uint32 10) (.uint32 5) rfl rfl
      (by intro impossible; cases impossible))

theorem out_expr (s : State) (dCell : Slot s "d" 5) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar s FirstStepEntry187.outExpr (.int32 1) :=
  .orTrue _ _ (.int32 1)
    (.compare .lt _ _ _ _ _
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
        (.step .plus (.uint32 5) (.int32 1) .uint32 rfl (.uint32 5) (.uint32 1) rfl rfl
          (by intro impossible; cases impossible)))
      (.variable _ _ _ depth)
      (.step .lt (.uint32 6) (.uint32 10) .uint32 rfl (.uint32 6) (.uint32 10) rfl rfl)) (by decide)

theorem binding (s : State) (data : s.arrays "data".toList=some ft)
    (logn : Slot s "logn" 10) (dCell : Slot s "d" 5) (depth : Slot s "depth" 10) :
    C99ArrayReference.Bind s (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments (entry s) :=
  .pointer "data".toList "data".toList C99ProcedureParser.zero ft _ _ _
    (RootBinding175.zero s "data" ft data (by decide))
    (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 5) (logn_expr s logn dCell)
      (.scalar .uint32 "depth".toList _ _ _ _ (.uint32 5) (.variable _ _ _ dCell)
        (.scalar .uint32 "ter".toList _ _ _ _ (.int32 1) (.literal .int32 1)
          (.scalar .int32 "in_ntt".toList _ _ _ _ (.int32 1) (.literal .int32 1)
            (.scalar .int32 "out_ntt".toList _ [] [] (fresh s) (.int32 1) (out_expr s dCell depth) .nil)))))

theorem entry_heap (s : State) : (entry s).heap=s.heap := rfl
theorem entry_logn (s : State) : Slot (entry s) "logn" 5 := rfl
theorem entry_depth (s : State) : Slot (entry s) "depth" 5 := rfl
theorem entry_ter (s : State) : Slot (entry s) "ter" 1 := rfl
theorem entry_in (s : State) : (entry s).locals "in_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem entry_out (s : State) : (entry s).locals "out_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem entry_data (s : State) : (entry s).arrays "data".toList=some ft := rfl



noncomputable def caller (callee second third fourth : State) := FourthStepReturn216.advance (FourthStepReturn216.returned callee second third fourth)
 noncomputable def fWords (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (firstTables extraTables : Nat → Fin 64 → BitVec 32) :=
  FourthStepImage216.flat (FourthStepEntry216.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
    (FourthStepFull216.afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables) extraTables
 noncomputable def gWords (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (firstTables extraTables : Nat → Fin 64 → BitVec 32) :=
  FourthStepImage216.flat (FourthStepEntry216.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
    (FourthStepFull216.afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables) extraTables

/- The actual fifth call entry after the completed fourth source call and guard. -/
theorem source : ∃ (callee second third fourth : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (firstTables extraTables : Nat → Fin 64 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec FirstStepEntry187.increment (FourthStepReturn216.returned callee second third fourth) ⟨caller callee second third fourth,.normal⟩ ∧
    C99ArrayReference.scalar (caller callee second third fourth) FirstStepEntry187.condition (.int32 1) ∧
    C99ArrayReference.Bind (caller callee second third fourth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (entry (caller callee second third fourth)) ∧
    Data (entry (caller callee second third fourth)) FourthStepLayout216.fd 384 (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables extraTables) ∧
    Data (entry (caller callee second third fourth)) FourthStepLayout216.gd 384 (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables extraTables) := by
  obtain ⟨callee,second,third,fourth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,
    run1,run2,run3,run4,_,_,inc,guard,dCell,fImage,gImage,_,_⟩:=FourthStepReturn216.source
  have data : (caller callee second third fourth).arrays "data".toList=some ft := by
    change (SecondStepLengths197.caller callee).arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn2 : Slot (SecondStepReturn212.returned callee second) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 2 (by decide)).trans SelectedTopContinuation186.logn_cell
  have logn3 : Slot (ThirdStepReturn216.returned callee second third) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 3 (by decide)).trans logn2
  have logn4 : Slot (FourthStepReturn216.returned callee second third fourth) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 4 (by decide)).trans logn3
  have logn5 : Slot (caller callee second third fourth) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 5 (by decide)).trans logn4
  have depth2 : Slot (SecondStepReturn212.returned callee second) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  have depth3 : Slot (ThirdStepReturn216.returned callee second third) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 3 (by decide)).trans depth2
  have depth4 : Slot (FourthStepReturn216.returned callee second third fourth) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 4 (by decide)).trans depth3
  have depth5 : Slot (caller callee second third fourth) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 5 (by decide)).trans depth4
  exact ⟨callee,second,third,fourth,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,run1,run2,run3,run4,inc,guard,
    binding _ data logn5 dCell depth5,fImage,gImage⟩

end FT1536.Source3.FifthStepEntry217
