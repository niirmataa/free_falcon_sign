import Source3.SixthStepImage217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SixthStepReturn217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open SixthStepLayout217 (fd gd)
open SixthStepEntry217 (caller fWords gWords)
open SixthStepFull217 (afterF afterG)
open SixthStepImage217 (flat)
open ZintNormWalkFlat208 (Data)

noncomputable def returned (callee second third fourth fifth out : State) : State := {caller callee second third fourth fifth with heap:=out.heap}
def advance (s : State) := ModularAtoms178.set s "d" 7

theorem increment_source (s : State) (dCell : Slot s "d" 6) :
    Exec FirstStepEntry187.increment s ⟨advance s,.normal⟩ := by
  have sum : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (.arithmetic .plus (.variable "d".toList) (.literal .int32 1)) (.uint32 7) :=
    .arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
      (.step .plus (.uint32 6) (.int32 1) .uint32 rfl (.uint32 6) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "d".toList .add (FirstStepEntry187.num 1))) s (advance s) :=
    .scalar s _ _ (.assign s.locals "d".toList _ .uint32 (some (.uint32 6)) (.uint32 7) dCell sum)
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem d_seven (s : State) : Slot (advance s) "d" 7 := ModularAtoms178.slot s "d" 7

theorem next_guard (s : State) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar (advance s) FirstStepEntry187.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (d_seven s))
    (.variable _ _ _ ((ModularAtoms178.outside s "d" "depth" 7 (by decide)).trans depth))
    (.step .lt (.uint32 7) (.uint32 10) .uint32 rfl (.uint32 7) (.uint32 10) rfl rfl)

/- Actual sixth caller return with both 336-word arrays and the next d guard. -/
theorem source : ∃ (callee second third fourth fifth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32)
    (firstTables extraTables : Nat → Fin 16 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (caller callee second third fourth fifth)) ⟨out,.normal⟩ ∧
    Exec (.step FirstStepEntry187.arguments) (caller callee second third fourth fifth) ⟨returned callee second third fourth fifth out,.normal⟩ ∧
    Exec FirstStepEntry187.body (caller callee second third fourth fifth) ⟨returned callee second third fourth fifth out,.normal⟩ ∧
    Exec FirstStepEntry187.increment (returned callee second third fourth fifth out) ⟨advance (returned callee second third fourth fifth out),.normal⟩ ∧
    C99ArrayReference.scalar (advance (returned callee second third fourth fifth out)) FirstStepEntry187.condition (.int32 1) ∧
    Slot (advance (returned callee second third fourth fifth out)) "d" 7 ∧
    Data (advance (returned callee second third fourth fifth out)) fd 336
      (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5) (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables) extraTables) ∧
    Data (advance (returned callee second third fourth fifth out)) gd 336
      (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5) (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables) extraTables) ∧
    (advance (returned callee second third fourth fifth out)).arrays=(caller callee second third fourth fifth).arrays ∧
    (∀ name : String, name.toList≠"d".toList →
      (advance (returned callee second third fourth fifth out)).locals name.toList=(caller callee second third fourth fifth).locals name.toList) := by
  obtain ⟨callee,second,third,fourth,fifth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,
    run1,run2,run3,run4,run5,binding,run6,fdata,gdata⟩:=SixthStepImage217.source
  have call : Exec (.step FirstStepEntry187.arguments) (caller callee second third fourth fifth) ⟨returned callee second third fourth fifth out,.normal⟩ :=
    .step _ _ _ ⟨out,.normal⟩ binding run6 .voidEnd
  have body : Exec FirstStepEntry187.body (caller callee second third fourth fifth) ⟨returned callee second third fourth fifth out,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call (SelectedStepAddPrime195.skip_run _))
  have dCell : Slot (returned callee second third fourth fifth out) "d" 6 := by rfl
  have depth2 : Slot (SecondStepReturn212.returned callee second) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  have depth3 : Slot (ThirdStepReturn216.returned callee second third) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 3 (by decide)).trans depth2
  have depth4 : Slot (FourthStepReturn216.returned callee second third fourth) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 4 (by decide)).trans depth3
  have depth5 : Slot (FifthStepReturn217.returned callee second third fourth fifth) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 5 (by decide)).trans depth4
  have depth6 : Slot (returned callee second third fourth fifth out) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 6 (by decide)).trans depth5
  exact ⟨callee,second,third,fourth,fifth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,call,body,increment_source _ dCell,next_guard _ depth6,d_seven _,fdata,gdata,rfl,
    fun name different => ModularAtoms178.outside _ "d" name 7 different⟩

end FT1536.Source3.SixthStepReturn217
