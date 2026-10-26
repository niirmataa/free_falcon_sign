import Source3.SecondStepImage212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepReturn212
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open SecondStepLayout197 (fd gd)
open ZintNormWalkFlat208 (Data)

noncomputable def returned (callee out : State) : State := {SecondStepLengths197.caller callee with heap:=out.heap}
 def advance (s : State) := ModularAtoms178.set s "d" 3

theorem increment_source (s : State) (dCell : Slot s "d" 2) :
    Exec FirstStepEntry187.increment s ⟨advance s,.normal⟩ := by
  have sum : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (.arithmetic .plus (.variable "d".toList) (.literal .int32 1)) (.uint32 3) :=
    .arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
      (.step .plus (.uint32 2) (.int32 1) .uint32 rfl (.uint32 2) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "d".toList .add (FirstStepEntry187.num 1))) s (advance s) :=
    .scalar s _ _ (.assign s.locals "d".toList _ .uint32 (some (.uint32 2)) (.uint32 3) dCell sum)
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem d_three (s : State) : Slot (advance s) "d" 3 := ModularAtoms178.slot s "d" 3

theorem next_guard (s : State) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar (advance s) FirstStepEntry187.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (d_three s))
    (.variable _ _ _ ((ModularAtoms178.outside s "d" "depth" 3 (by decide)).trans depth))
    (.step .lt (.uint32 3) (.uint32 10) .uint32 rfl (.uint32 3) (.uint32 10) rfl rfl)

/- The actual second call returns both complete arrays to its caller,
   then the enclosing d loop advances to its next true guard at d=3. -/
theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨out,.normal⟩ ∧
    Exec (.step FirstStepEntry187.arguments) (SecondStepLengths197.caller callee) ⟨returned callee out,.normal⟩ ∧
    Exec FirstStepEntry187.body (SecondStepLengths197.caller callee) ⟨returned callee out,.normal⟩ ∧
    Exec FirstStepEntry187.increment (returned callee out) ⟨advance (returned callee out),.normal⟩ ∧
    C99ArrayReference.scalar (advance (returned callee out)) FirstStepEntry187.condition (.int32 1) ∧
    Slot (advance (returned callee out)) "d" 3 ∧
    Data (advance (returned callee out)) fd 384 (SecondStepImage212.fWords oldWords ivs0 ivs1 gvs2) ∧
    Data (advance (returned callee out)) gd 384 (SecondStepImage212.gWords oldWords ivs0 ivs1 gvs2) ∧
    (advance (returned callee out)).arrays=(SecondStepLengths197.caller callee).arrays ∧
    (∀ name : String, name.toList≠"d".toList →
      (advance (returned callee out)).locals name.toList=(SecondStepLengths197.caller callee).locals name.toList) := by
  obtain ⟨callee,out,oldWords,ivs0,ivs1,gvs2,firstRun,binding,run,_,fdata,gdata⟩:=SecondStepImage212.source
  have call : Exec (.step FirstStepEntry187.arguments) (SecondStepLengths197.caller callee) ⟨returned callee out,.normal⟩ :=
    .step _ _ _ ⟨out,.normal⟩ binding run .voidEnd
  have body : Exec FirstStepEntry187.body (SecondStepLengths197.caller callee) ⟨returned callee out,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call (SelectedStepAddPrime195.skip_run _))
  have dCell : Slot (returned callee out) "d" 2 := by rfl
  have depth : Slot (returned callee out) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  exact ⟨callee,out,oldWords,ivs0,ivs1,gvs2,firstRun,run,call,body,increment_source _ dCell,next_guard _ depth,d_three _,
    fdata,gdata,rfl,fun name different => ModularAtoms178.outside _ "d" name 3 different⟩

end FT1536.Source3.SecondStepReturn212
