import Source3.SeventhStepReturn217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EighthStepEntry217
open C99ArrayReference (State bindValue bindPointer)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open ZintNormWalkFlat208 (Data)
open SelectedMakeFgSetup176 (ft)

def fresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def withOut (s : State) : State := bindValue (fresh s) "out_ntt".toList .int32 (.int32 1)
def withIn (s : State) : State := bindValue (withOut s) "in_ntt".toList .int32 (.int32 1)
def withTer (s : State) : State := bindValue (withIn s) "ter".toList .uint32 (.int32 1)
def withDepth (s : State) : State := bindValue (withTer s) "depth".toList .uint32 (.uint32 8)
def withLogn (s : State) : State := bindValue (withDepth s) "logn".toList .uint32 (.uint32 2)
def entry (s : State) : State := bindPointer (withLogn s) "data".toList ft

theorem logn_expr (s : State) (logn : Slot s "logn" 10) (dCell : Slot s "d" 8) :
    C99ArrayReference.scalar s (.bin .sub (FirstStepEntry187.var "logn") (FirstStepEntry187.var "d"))
      (.uint32 2) :=
  .arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn) (.variable _ _ _ dCell)
    (.step .minus (.uint32 10) (.uint32 8) .uint32 rfl (.uint32 10) (.uint32 8) rfl rfl
      (by intro impossible; cases impossible))

theorem out_expr (s : State) (dCell : Slot s "d" 8) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar s FirstStepEntry187.outExpr (.int32 1) :=
  .orTrue _ _ (.int32 1)
    (.compare .lt _ _ _ _ _
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
        (.step .plus (.uint32 8) (.int32 1) .uint32 rfl (.uint32 8) (.uint32 1) rfl rfl
          (by intro impossible; cases impossible)))
      (.variable _ _ _ depth)
      (.step .lt (.uint32 9) (.uint32 10) .uint32 rfl (.uint32 9) (.uint32 10) rfl rfl)) (by decide)

theorem binding (s : State) (data : s.arrays "data".toList=some ft)
    (logn : Slot s "logn" 10) (dCell : Slot s "d" 8) (depth : Slot s "depth" 10) :
    C99ArrayReference.Bind s (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments (entry s) :=
  .pointer "data".toList "data".toList C99ProcedureParser.zero ft _ _ _
    (RootBinding175.zero s "data" ft data (by decide))
    (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 2) (logn_expr s logn dCell)
      (.scalar .uint32 "depth".toList _ _ _ _ (.uint32 8) (.variable _ _ _ dCell)
        (.scalar .uint32 "ter".toList _ _ _ _ (.int32 1) (.literal .int32 1)
          (.scalar .int32 "in_ntt".toList _ _ _ _ (.int32 1) (.literal .int32 1)
            (.scalar .int32 "out_ntt".toList _ [] [] (fresh s) (.int32 1) (out_expr s dCell depth) .nil)))))

theorem entry_heap (s : State) : (entry s).heap=s.heap := rfl
theorem entry_logn (s : State) : Slot (entry s) "logn" 2 := rfl
theorem entry_depth (s : State) : Slot (entry s) "depth" 8 := rfl
theorem entry_ter (s : State) : Slot (entry s) "ter" 1 := rfl
theorem entry_in (s : State) : (entry s).locals "in_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem entry_out (s : State) : (entry s).locals "out_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem entry_data (s : State) : (entry s).arrays "data".toList=some ft := rfl




noncomputable def caller (callee second third fourth fifth sixth seventh : State) := SeventhStepReturn217.advance (SeventhStepReturn217.returned callee second third fourth fifth sixth seventh)
noncomputable def fWords (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (priorFirst priorExtra : Nat → Fin 64 → BitVec 32)
    (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (firstTables extraTables : Nat → Fin 8 → BitVec 32) :=
  SeventhStepImage217.flat (SeventhStepEntry217.fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6)
    (SeventhStepFull217.afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 firstTables) extraTables
noncomputable def gWords (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (priorFirst priorExtra : Nat → Fin 64 → BitVec 32)
    (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (firstTables extraTables : Nat → Fin 8 → BitVec 32) :=
  SeventhStepImage217.flat (SeventhStepEntry217.gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6)
    (SeventhStepFull217.afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 firstTables) extraTables

/- Actual eighth entry after the completed seventh source call and guard. -/
theorem source : ∃ (callee second third fourth fifth sixth seventh : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32)
    (firstTables extraTables : Nat → Fin 8 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)) ⟨seventh,.normal⟩ ∧
    Exec FirstStepEntry187.increment (SeventhStepReturn217.returned callee second third fourth fifth sixth seventh) ⟨caller callee second third fourth fifth sixth seventh,.normal⟩ ∧
    C99ArrayReference.scalar (caller callee second third fourth fifth sixth seventh) FirstStepEntry187.condition (.int32 1) ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth sixth seventh) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (entry (caller callee second third fourth fifth sixth seventh)) ∧
    Data (entry (caller callee second third fourth fifth sixth seventh)) SeventhStepLayout217.fd 328 (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 firstTables extraTables) ∧
    Data (entry (caller callee second third fourth fifth sixth seventh)) SeventhStepLayout217.gd 328 (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 firstTables extraTables) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,_,_,inc,guard,dCell,fImage,gImage,_,_⟩:=SeventhStepReturn217.source
  have data : (caller callee second third fourth fifth sixth seventh).arrays "data".toList=some ft := by
    change (SecondStepLengths197.caller callee).arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn2 : Slot (SecondStepReturn212.returned callee second) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 2 (by decide)).trans SelectedTopContinuation186.logn_cell
  have logn3 : Slot (ThirdStepReturn216.returned callee second third) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 3 (by decide)).trans logn2
  have logn4 : Slot (FourthStepReturn216.returned callee second third fourth) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 4 (by decide)).trans logn3
  have logn5 : Slot (FifthStepReturn217.returned callee second third fourth fifth) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 5 (by decide)).trans logn4
  have logn6 : Slot (SixthStepReturn217.returned callee second third fourth fifth sixth) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 6 (by decide)).trans logn5
  have logn7 : Slot (SeventhStepReturn217.returned callee second third fourth fifth sixth seventh) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 7 (by decide)).trans logn6
  have logn8 : Slot (caller callee second third fourth fifth sixth seventh) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 8 (by decide)).trans logn7
  have depth2 : Slot (SecondStepReturn212.returned callee second) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  have depth3 : Slot (ThirdStepReturn216.returned callee second third) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 3 (by decide)).trans depth2
  have depth4 : Slot (FourthStepReturn216.returned callee second third fourth) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 4 (by decide)).trans depth3
  have depth5 : Slot (FifthStepReturn217.returned callee second third fourth fifth) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 5 (by decide)).trans depth4
  have depth6 : Slot (SixthStepReturn217.returned callee second third fourth fifth sixth) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 6 (by decide)).trans depth5
  have depth7 : Slot (SeventhStepReturn217.returned callee second third fourth fifth sixth seventh) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 7 (by decide)).trans depth6
  have depth8 : Slot (caller callee second third fourth fifth sixth seventh) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 8 (by decide)).trans depth7
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,inc,guard,binding _ data logn8 dCell depth8,fImage,gImage⟩

end FT1536.Source3.EighthStepEntry217
