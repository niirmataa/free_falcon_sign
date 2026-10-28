import Source3.EighthStepImage217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EighthStepReturn217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open EighthStepLayout217 (fd gd)
open EighthStepEntry217 (caller fWords gWords)
open EighthStepFull217 (afterF afterG)
open EighthStepImage217 (flat)
open ZintNormWalkFlat208 (Data)

noncomputable def returned (callee second third fourth fifth sixth seventh out : State) : State := {caller callee second third fourth fifth sixth seventh with heap:=out.heap}
def advance (s : State) := ModularAtoms178.set s "d" 9

theorem increment_source (s : State) (dCell : Slot s "d" 8) :
    Exec FirstStepEntry187.increment s ⟨advance s,.normal⟩ := by
  have sum : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (.arithmetic .plus (.variable "d".toList) (.literal .int32 1)) (.uint32 9) :=
    .arithmetic .plus _ _ _ _ _ (.variable _ _ _ dCell) (.literal .int32 1)
      (.step .plus (.uint32 8) (.int32 1) .uint32 rfl (.uint32 8) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "d".toList .add (FirstStepEntry187.num 1))) s (advance s) :=
    .scalar s _ _ (.assign s.locals "d".toList _ .uint32 (some (.uint32 8)) (.uint32 9) dCell sum)
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem d_nine (s : State) : Slot (advance s) "d" 9 := ModularAtoms178.slot s "d" 9

theorem next_guard (s : State) (depth : Slot s "depth" 10) :
    C99ArrayReference.scalar (advance s) FirstStepEntry187.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (d_nine s))
    (.variable _ _ _ ((ModularAtoms178.outside s "d" "depth" 9 (by decide)).trans depth))
    (.step .lt (.uint32 9) (.uint32 10) .uint32 rfl (.uint32 9) (.uint32 10) rfl rfl)

/- Actual eighth caller return with both 332-word arrays and the next d guard. -/
theorem source : ∃ (callee second third fourth fifth sixth seventh out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32)
    (firstTables extraTables : Nat → Fin 4 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)) ⟨seventh,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (EighthStepEntry217.entry (caller callee second third fourth fifth sixth seventh)) ⟨out,.normal⟩ ∧
    Exec (.step FirstStepEntry187.arguments) (caller callee second third fourth fifth sixth seventh) ⟨returned callee second third fourth fifth sixth seventh out,.normal⟩ ∧
    Exec FirstStepEntry187.body (caller callee second third fourth fifth sixth seventh) ⟨returned callee second third fourth fifth sixth seventh out,.normal⟩ ∧
    Exec FirstStepEntry187.increment (returned callee second third fourth fifth sixth seventh out) ⟨advance (returned callee second third fourth fifth sixth seventh out),.normal⟩ ∧
    C99ArrayReference.scalar (advance (returned callee second third fourth fifth sixth seventh out)) FirstStepEntry187.condition (.int32 1) ∧
    Slot (advance (returned callee second third fourth fifth sixth seventh out)) "d" 9 ∧
    Data (advance (returned callee second third fourth fifth sixth seventh out)) fd 332
      (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7) (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables) extraTables) ∧
    Data (advance (returned callee second third fourth fifth sixth seventh out)) gd 332
      (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7) (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables) extraTables) ∧
    (advance (returned callee second third fourth fifth sixth seventh out)).arrays=(caller callee second third fourth fifth sixth seventh).arrays ∧
    (∀ name : String, name.toList≠"d".toList →
      (advance (returned callee second third fourth fifth sixth seventh out)).locals name.toList=(caller callee second third fourth fifth sixth seventh).locals name.toList) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,binding,run8,fdata,gdata⟩:=EighthStepImage217.source
  have call : Exec (.step FirstStepEntry187.arguments) (caller callee second third fourth fifth sixth seventh) ⟨returned callee second third fourth fifth sixth seventh out,.normal⟩ :=
    .step _ _ _ ⟨out,.normal⟩ binding run8 .voidEnd
  have body : Exec FirstStepEntry187.body (caller callee second third fourth fifth sixth seventh) ⟨returned callee second third fourth fifth sixth seventh out,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call (SelectedStepAddPrime195.skip_run _))
  have dCell : Slot (returned callee second third fourth fifth sixth seventh out) "d" 8 := by rfl
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
  have depth8 : Slot (returned callee second third fourth fifth sixth seventh out) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 8 (by decide)).trans depth7
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,run8,call,body,increment_source _ dCell,next_guard _ depth8,d_nine _,fdata,gdata,rfl,
    fun name different => ModularAtoms178.outside _ "d" name 9 different⟩

end FT1536.Source3.EighthStepReturn217
