import Source3.FifthStepImage217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FifthStepReturn217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open FifthStepLayout217 (fd gd)
open FifthStepEntry217 (caller fWords gWords)
open FifthStepFull217 (afterF afterG)
open FifthStepImage217 (flat)
open ZintNormWalkFlat208 (Data)

noncomputable def returned (callee second third fourth out : State) : State := {caller callee second third fourth with heap:=out.heap}
 def advance (s : State) := ModularAtoms178.set s "d" 6

theorem increment_source (s : State) (dCell : Slot s "d" 5) :
    Exec FirstStepEntry187.increment s ⟨advance s,.normal⟩ := by
  have sum : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (.arithmetic .plus (.variable "d".toList) (.literal .int32 1)) (.uint32 6) :=
    .arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
      (.step .plus (.uint32 5) (.int32 1) .uint32 rfl (.uint32 5) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "d".toList .add (FirstStepEntry187.num 1))) s (advance s) :=
    .scalar s _ _ (.assign s.locals "d".toList _ .uint32 (some (.uint32 5)) (.uint32 6) dCell sum)
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem d_six (s : State) : Slot (advance s) "d" 6 := ModularAtoms178.slot s "d" 6

theorem next_guard (s : State) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar (advance s) FirstStepEntry187.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (d_six s))
    (.variable _ _ _ ((ModularAtoms178.outside s "d" "depth" 6 (by decide)).trans depth))
    (.step .lt (.uint32 6) (.uint32 10) .uint32 rfl (.uint32 6) (.uint32 10) rfl rfl)

/- Actual fifth caller return with both352-word arrays and the next d guard. -/
theorem source : ∃ (callee second third fourth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (firstTables extraTables : Nat → Fin 32 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (caller callee second third fourth)) ⟨out,.normal⟩ ∧
    Exec (.step FirstStepEntry187.arguments) (caller callee second third fourth) ⟨returned callee second third fourth out,.normal⟩ ∧
    Exec FirstStepEntry187.body (caller callee second third fourth) ⟨returned callee second third fourth out,.normal⟩ ∧
    Exec FirstStepEntry187.increment (returned callee second third fourth out) ⟨advance (returned callee second third fourth out),.normal⟩ ∧
    C99ArrayReference.scalar (advance (returned callee second third fourth out)) FirstStepEntry187.condition (.int32 1) ∧
    Slot (advance (returned callee second third fourth out)) "d" 6 ∧
    Data (advance (returned callee second third fourth out)) fd 352
      (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra) (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables) extraTables) ∧
    Data (advance (returned callee second third fourth out)) gd 352
      (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra) (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables) extraTables) ∧
    (advance (returned callee second third fourth out)).arrays=(caller callee second third fourth).arrays ∧
    (∀ name : String, name.toList≠"d".toList →
      (advance (returned callee second third fourth out)).locals name.toList=(caller callee second third fourth).locals name.toList) := by
  obtain ⟨callee,second,third,fourth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,
    run1,run2,run3,run4,binding,run5,fdata,gdata⟩:=FifthStepImage217.source
  have call : Exec (.step FirstStepEntry187.arguments) (caller callee second third fourth) ⟨returned callee second third fourth out,.normal⟩ :=
    .step _ _ _ ⟨out,.normal⟩ binding run5 .voidEnd
  have body : Exec FirstStepEntry187.body (caller callee second third fourth) ⟨returned callee second third fourth out,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call (SelectedStepAddPrime195.skip_run _))
  have dCell : Slot (returned callee second third fourth out) "d" 5 := by rfl
  have depth2 : Slot (SecondStepReturn212.returned callee second) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  have depth3 : Slot (ThirdStepReturn216.returned callee second third) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 3 (by decide)).trans depth2
  have depth4 : Slot (FourthStepReturn216.returned callee second third fourth) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 4 (by decide)).trans depth3
  have depth5 : Slot (returned callee second third fourth out) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 5 (by decide)).trans depth4
  exact ⟨callee,second,third,fourth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,
    run1,run2,run3,run4,run5,call,body,increment_source _ dCell,next_guard _ depth5,d_six _,fdata,gdata,rfl,
    fun name different => ModularAtoms178.outside _ "d" name 6 different⟩

end FT1536.Source3.FifthStepReturn217
