import Source3.FourthStepImage216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FourthStepReturn216
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open FourthStepLayout216 (fd gd)
open FourthStepEntry216 (caller fWords gWords)
open FourthStepFull216 (afterF afterG)
open FourthStepImage216 (flat)
open ZintNormWalkFlat208 (Data)

noncomputable def returned (callee second third out : State) : State := {caller callee second third with heap:=out.heap}
 def advance (s : State) := ModularAtoms178.set s "d" 5

theorem increment_source (s : State) (dCell : Slot s "d" 4) :
    Exec FirstStepEntry187.increment s ⟨advance s,.normal⟩ := by
  have sum : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (.arithmetic .plus (.variable "d".toList) (.literal .int32 1)) (.uint32 5) :=
    .arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
      (.step .plus (.uint32 4) (.int32 1) .uint32 rfl (.uint32 4) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "d".toList .add (FirstStepEntry187.num 1))) s (advance s) :=
    .scalar s _ _ (.assign s.locals "d".toList _ .uint32 (some (.uint32 4)) (.uint32 5) dCell sum)
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem d_five (s : State) : Slot (advance s) "d" 5 := ModularAtoms178.slot s "d" 5

theorem next_guard (s : State) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar (advance s) FirstStepEntry187.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (d_five s))
    (.variable _ _ _ ((ModularAtoms178.outside s "d" "depth" 5 (by decide)).trans depth))
    (.step .lt (.uint32 5) (.uint32 10) .uint32 rfl (.uint32 5) (.uint32 10) rfl rfl)

/- Both384-word arrays are returned from the actual fourth call, and
   the source d loop advances from4 to5 with its actual next guard. -/
theorem source : ∃ (callee second third out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (firstTables extraTables : Nat → Fin 64 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (caller callee second third)) ⟨out,.normal⟩ ∧
    Exec (.step FirstStepEntry187.arguments) (caller callee second third) ⟨returned callee second third out,.normal⟩ ∧
    Exec FirstStepEntry187.body (caller callee second third) ⟨returned callee second third out,.normal⟩ ∧
    Exec FirstStepEntry187.increment (returned callee second third out) ⟨advance (returned callee second third out),.normal⟩ ∧
    C99ArrayReference.scalar (advance (returned callee second third out)) FirstStepEntry187.condition (.int32 1) ∧
    Slot (advance (returned callee second third out)) "d" 5 ∧
    Data (advance (returned callee second third out)) fd 384 (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
      (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables) extraTables) ∧
    Data (advance (returned callee second third out)) gd 384 (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
      (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables) extraTables) ∧
    (advance (returned callee second third out)).arrays=(caller callee second third).arrays ∧
    (∀ name : String, name.toList≠"d".toList →
      (advance (returned callee second third out)).locals name.toList=(caller callee second third).locals name.toList) := by
  obtain ⟨callee,second,third,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,
    run1,run2,run3,binding,run4,fdata,gdata⟩:=FourthStepImage216.source
  have call : Exec (.step FirstStepEntry187.arguments) (caller callee second third) ⟨returned callee second third out,.normal⟩ :=
    .step _ _ _ ⟨out,.normal⟩ binding run4 .voidEnd
  have body : Exec FirstStepEntry187.body (caller callee second third) ⟨returned callee second third out,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call (SelectedStepAddPrime195.skip_run _))
  have dCell : Slot (returned callee second third out) "d" 4 := by rfl
  have depth2 : Slot (SecondStepReturn212.returned callee second) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  have depth3 : Slot (ThirdStepReturn216.returned callee second third) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 3 (by decide)).trans depth2
  have depth4 : Slot (returned callee second third out) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 4 (by decide)).trans depth3
  exact ⟨callee,second,third,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,
    run1,run2,run3,run4,call,body,increment_source _ dCell,next_guard _ depth4,d_five _,fdata,gdata,rfl,
    fun name different => ModularAtoms178.outside _ "d" name 5 different⟩

end FT1536.Source3.FourthStepReturn216
