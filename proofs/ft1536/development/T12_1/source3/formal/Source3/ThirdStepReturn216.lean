import Source3.ThirdStepImage216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepReturn216
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open ThirdStepLayout215 (fd gd)
open ThirdStepFull216 (caller fInput gInput)
open ThirdStepBody216 (merged)
open ThirdStepCrtExtra216 (Words)
open ThirdStepImage216 (flat)
open ZintNormWalkFlat208 (Data)

noncomputable def returned (callee second out : State) : State := {caller callee second with heap:=out.heap}
 def advance (s : State) := ModularAtoms178.set s "d" 4

theorem increment_source (s : State) (dCell : Slot s "d" 3) :
    Exec FirstStepEntry187.increment s ⟨advance s,.normal⟩ := by
  have sum : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (.arithmetic .plus (.variable "d".toList) (.literal .int32 1)) (.uint32 4) :=
    .arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
      (.step .plus (.uint32 3) (.int32 1) .uint32 rfl (.uint32 3) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "d".toList .add (FirstStepEntry187.num 1))) s (advance s) :=
    .scalar s _ _ (.assign s.locals "d".toList _ .uint32 (some (.uint32 3)) (.uint32 4) dCell sum)
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem d_four (s : State) : Slot (advance s) "d" 4 := ModularAtoms178.slot s "d" 4

theorem next_guard (s : State) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar (advance s) FirstStepEntry187.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (d_four s))
    (.variable _ _ _ ((ModularAtoms178.outside s "d" "depth" 4 (by decide)).trans depth))
    (.step .lt (.uint32 4) (.uint32 10) .uint32 rfl (.uint32 4) (.uint32 10) rfl rfl)

/- Both384-word arrays are returned from the real third call, and the
   enclosing source d loop advances from3 to4 with its actual next guard. -/
theorem source : ∃ (callee second out : State) (oldWords : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (caller callee second)) ⟨out,.normal⟩ ∧
    Exec (.step FirstStepEntry187.arguments) (caller callee second) ⟨returned callee second out,.normal⟩ ∧
    Exec FirstStepEntry187.body (caller callee second) ⟨returned callee second out,.normal⟩ ∧
    Exec FirstStepEntry187.increment (returned callee second out) ⟨advance (returned callee second out),.normal⟩ ∧
    C99ArrayReference.scalar (advance (returned callee second out)) FirstStepEntry187.condition (.int32 1) ∧
    Slot (advance (returned callee second out)) "d" 4 ∧
    Data (advance (returned callee second out)) fd 384 (flat (fInput oldWords iv0 iv1 gv2) (Words (merged (fInput oldWords iv0 iv1 gv2) i0 i1 i2)) g3 g4 g5) ∧
    Data (advance (returned callee second out)) gd 384 (flat (gInput oldWords iv0 iv1 gv2) (Words (merged (gInput oldWords iv0 iv1 gv2) i0 i1 i2)) g3 g4 g5) ∧
    (advance (returned callee second out)).arrays=(caller callee second).arrays ∧
    (∀ name : String, name.toList≠"d".toList →
      (advance (returned callee second out)).locals name.toList=(caller callee second).locals name.toList) := by
  obtain ⟨callee,second,out,oldWords,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,run1,run2,binding,run3,fdata,gdata⟩:=ThirdStepImage216.source
  have call : Exec (.step FirstStepEntry187.arguments) (caller callee second) ⟨returned callee second out,.normal⟩ :=
    .step _ _ _ ⟨out,.normal⟩ binding run3 .voidEnd
  have body : Exec FirstStepEntry187.body (caller callee second) ⟨returned callee second out,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call (SelectedStepAddPrime195.skip_run _))
  have dCell : Slot (returned callee second out) "d" 3 := by rfl
  have depth2 : Slot (SecondStepReturn212.returned callee second) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  have depth3 : Slot (returned callee second out) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 3 (by decide)).trans depth2
  exact ⟨callee,second,out,oldWords,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,run1,run2,run3,call,body,
    increment_source _ dCell,next_guard _ depth3,d_four _,fdata,gdata,rfl,
    fun name different => ModularAtoms178.outside _ "d" name 4 different⟩

end FT1536.Source3.ThirdStepReturn216
