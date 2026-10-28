import Source3.NinthStepReturn217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Compose the selected source iterations into the actual outer d loop. -/
namespace FT1536.Source3.SelectedOuterLoop217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open SelectedMakeFgSetup176 (ft)
open NinthStepLayout217 (fd gd)
open NinthStepEntry217 (caller fWords gWords)
open NinthStepFull217 (afterF afterG)
open NinthStepImage217 (flat)
open NinthStepReturn217 (returned advance)
open ZintNormWalkFlat208 (Data)

theorem source : ∃ (callee second third fourth fifth sixth seventh eighth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32) (first8 extra8 : Nat → Fin 4 → BitVec 32)
    (firstTables extraTables : Nat → Fin 2 → BitVec 32),
    Exec FirstStepEntry187.loop FirstStepEntry187.caller ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ ∧
    Exec SelectedMakeFgTopEntry176.tail FirstStepEntry187.before ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ ∧
    Data (advance (returned callee second third fourth fifth sixth seventh eighth out)) fd 335
      (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables) ∧
    Data (advance (returned callee second third fourth fifth sixth seventh eighth out)) gd 335
      (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,run8,run9,call9,body9,inc9,guard10,d10,fdata,gdata,_,_⟩:=NinthStepReturn217.source
  have body1 : Exec FirstStepEntry187.body FirstStepEntry187.caller ⟨FirstStepReturn196.returned callee,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ (FirstStepEntry187.source_step _ run1 .voidEnd) (SelectedStepAddPrime195.skip_run _))
  have inc1 : Exec FirstStepEntry187.increment (FirstStepReturn196.returned callee) ⟨SecondStepLengths197.caller callee,.normal⟩ :=
    FirstStepReturn196.increment_source _ (by rfl)
  have data2 : (SecondStepLengths197.caller callee).arrays "data".toList=some ft := by
    change FirstStepEntry187.caller.arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn2 : Slot (SecondStepLengths197.caller callee) "logn" 10 := by
    change Slot FirstStepEntry187.caller "logn" 10
    exact SelectedTopContinuation186.logn_cell
  have depth2 : Slot (SecondStepLengths197.caller callee) "depth" 10 := by
    change Slot FirstStepEntry187.caller "depth" 10
    exact SelectedTopContinuation186.depth_cell
  have guard2 : C99ArrayReference.scalar (SecondStepLengths197.caller callee) FirstStepEntry187.condition (.int32 1) :=
    .compare .lt _ _ _ _ _ (.variable _ _ _ (show Slot (SecondStepLengths197.caller callee) "d" 2 from by rfl)) (.variable _ _ _ depth2)
      (.step .lt (.uint32 2) (.uint32 10) .uint32 rfl (.uint32 2) (.uint32 10) rfl rfl)
  have call2 : Exec (.step FirstStepEntry187.arguments) (SecondStepLengths197.caller callee) ⟨SecondStepReturn212.returned callee second,.normal⟩ :=
    .step _ _ _ ⟨second,.normal⟩ (SecondStepEntry196.binding _ data2 logn2 (by rfl) depth2) run2 .voidEnd
  have body2 : Exec FirstStepEntry187.body (SecondStepLengths197.caller callee) ⟨SecondStepReturn212.returned callee second,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call2 (SelectedStepAddPrime195.skip_run _))
  have inc2 : Exec FirstStepEntry187.increment (SecondStepReturn212.returned callee second) ⟨ThirdStepFull216.caller callee second,.normal⟩ :=
    SecondStepReturn212.increment_source _ (by rfl)
  have data3 : (ThirdStepFull216.caller callee second).arrays "data".toList=some ft := by
    change FirstStepEntry187.caller.arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn3 : Slot (ThirdStepFull216.caller callee second) "logn" 10 := by
    change Slot FirstStepEntry187.caller "logn" 10
    exact SelectedTopContinuation186.logn_cell
  have depth3 : Slot (ThirdStepFull216.caller callee second) "depth" 10 := by
    change Slot FirstStepEntry187.caller "depth" 10
    exact SelectedTopContinuation186.depth_cell
  have guard3 : C99ArrayReference.scalar (ThirdStepFull216.caller callee second) FirstStepEntry187.condition (.int32 1) :=
    .compare .lt _ _ _ _ _ (.variable _ _ _ (show Slot (ThirdStepFull216.caller callee second) "d" 3 from by rfl)) (.variable _ _ _ depth3)
      (.step .lt (.uint32 3) (.uint32 10) .uint32 rfl (.uint32 3) (.uint32 10) rfl rfl)
  have call3 : Exec (.step FirstStepEntry187.arguments) (ThirdStepFull216.caller callee second) ⟨ThirdStepReturn216.returned callee second third,.normal⟩ :=
    .step _ _ _ ⟨third,.normal⟩ (ThirdStepEntry215.binding _ data3 logn3 (by rfl) depth3) run3 .voidEnd
  have body3 : Exec FirstStepEntry187.body (ThirdStepFull216.caller callee second) ⟨ThirdStepReturn216.returned callee second third,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call3 (SelectedStepAddPrime195.skip_run _))
  have inc3 : Exec FirstStepEntry187.increment (ThirdStepReturn216.returned callee second third) ⟨FourthStepEntry216.caller callee second third,.normal⟩ :=
    ThirdStepReturn216.increment_source _ (by rfl)
  have data4 : (FourthStepEntry216.caller callee second third).arrays "data".toList=some ft := by
    change FirstStepEntry187.caller.arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn4 : Slot (FourthStepEntry216.caller callee second third) "logn" 10 := by
    change Slot FirstStepEntry187.caller "logn" 10
    exact SelectedTopContinuation186.logn_cell
  have depth4 : Slot (FourthStepEntry216.caller callee second third) "depth" 10 := by
    change Slot FirstStepEntry187.caller "depth" 10
    exact SelectedTopContinuation186.depth_cell
  have guard4 : C99ArrayReference.scalar (FourthStepEntry216.caller callee second third) FirstStepEntry187.condition (.int32 1) :=
    .compare .lt _ _ _ _ _ (.variable _ _ _ (show Slot (FourthStepEntry216.caller callee second third) "d" 4 from by rfl)) (.variable _ _ _ depth4)
      (.step .lt (.uint32 4) (.uint32 10) .uint32 rfl (.uint32 4) (.uint32 10) rfl rfl)
  have call4 : Exec (.step FirstStepEntry187.arguments) (FourthStepEntry216.caller callee second third) ⟨FourthStepReturn216.returned callee second third fourth,.normal⟩ :=
    .step _ _ _ ⟨fourth,.normal⟩ (FourthStepEntry216.binding _ data4 logn4 (by rfl) depth4) run4 .voidEnd
  have body4 : Exec FirstStepEntry187.body (FourthStepEntry216.caller callee second third) ⟨FourthStepReturn216.returned callee second third fourth,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call4 (SelectedStepAddPrime195.skip_run _))
  have inc4 : Exec FirstStepEntry187.increment (FourthStepReturn216.returned callee second third fourth) ⟨FifthStepEntry217.caller callee second third fourth,.normal⟩ :=
    FourthStepReturn216.increment_source _ (by rfl)
  have data5 : (FifthStepEntry217.caller callee second third fourth).arrays "data".toList=some ft := by
    change FirstStepEntry187.caller.arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn5 : Slot (FifthStepEntry217.caller callee second third fourth) "logn" 10 := by
    change Slot FirstStepEntry187.caller "logn" 10
    exact SelectedTopContinuation186.logn_cell
  have depth5 : Slot (FifthStepEntry217.caller callee second third fourth) "depth" 10 := by
    change Slot FirstStepEntry187.caller "depth" 10
    exact SelectedTopContinuation186.depth_cell
  have guard5 : C99ArrayReference.scalar (FifthStepEntry217.caller callee second third fourth) FirstStepEntry187.condition (.int32 1) :=
    .compare .lt _ _ _ _ _ (.variable _ _ _ (show Slot (FifthStepEntry217.caller callee second third fourth) "d" 5 from by rfl)) (.variable _ _ _ depth5)
      (.step .lt (.uint32 5) (.uint32 10) .uint32 rfl (.uint32 5) (.uint32 10) rfl rfl)
  have call5 : Exec (.step FirstStepEntry187.arguments) (FifthStepEntry217.caller callee second third fourth) ⟨FifthStepReturn217.returned callee second third fourth fifth,.normal⟩ :=
    .step _ _ _ ⟨fifth,.normal⟩ (FifthStepEntry217.binding _ data5 logn5 (by rfl) depth5) run5 .voidEnd
  have body5 : Exec FirstStepEntry187.body (FifthStepEntry217.caller callee second third fourth) ⟨FifthStepReturn217.returned callee second third fourth fifth,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call5 (SelectedStepAddPrime195.skip_run _))
  have inc5 : Exec FirstStepEntry187.increment (FifthStepReturn217.returned callee second third fourth fifth) ⟨SixthStepEntry217.caller callee second third fourth fifth,.normal⟩ :=
    FifthStepReturn217.increment_source _ (by rfl)
  have data6 : (SixthStepEntry217.caller callee second third fourth fifth).arrays "data".toList=some ft := by
    change FirstStepEntry187.caller.arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn6 : Slot (SixthStepEntry217.caller callee second third fourth fifth) "logn" 10 := by
    change Slot FirstStepEntry187.caller "logn" 10
    exact SelectedTopContinuation186.logn_cell
  have depth6 : Slot (SixthStepEntry217.caller callee second third fourth fifth) "depth" 10 := by
    change Slot FirstStepEntry187.caller "depth" 10
    exact SelectedTopContinuation186.depth_cell
  have guard6 : C99ArrayReference.scalar (SixthStepEntry217.caller callee second third fourth fifth) FirstStepEntry187.condition (.int32 1) :=
    .compare .lt _ _ _ _ _ (.variable _ _ _ (show Slot (SixthStepEntry217.caller callee second third fourth fifth) "d" 6 from by rfl)) (.variable _ _ _ depth6)
      (.step .lt (.uint32 6) (.uint32 10) .uint32 rfl (.uint32 6) (.uint32 10) rfl rfl)
  have call6 : Exec (.step FirstStepEntry187.arguments) (SixthStepEntry217.caller callee second third fourth fifth) ⟨SixthStepReturn217.returned callee second third fourth fifth sixth,.normal⟩ :=
    .step _ _ _ ⟨sixth,.normal⟩ (SixthStepEntry217.binding _ data6 logn6 (by rfl) depth6) run6 .voidEnd
  have body6 : Exec FirstStepEntry187.body (SixthStepEntry217.caller callee second third fourth fifth) ⟨SixthStepReturn217.returned callee second third fourth fifth sixth,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call6 (SelectedStepAddPrime195.skip_run _))
  have inc6 : Exec FirstStepEntry187.increment (SixthStepReturn217.returned callee second third fourth fifth sixth) ⟨SeventhStepEntry217.caller callee second third fourth fifth sixth,.normal⟩ :=
    SixthStepReturn217.increment_source _ (by rfl)
  have data7 : (SeventhStepEntry217.caller callee second third fourth fifth sixth).arrays "data".toList=some ft := by
    change FirstStepEntry187.caller.arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn7 : Slot (SeventhStepEntry217.caller callee second third fourth fifth sixth) "logn" 10 := by
    change Slot FirstStepEntry187.caller "logn" 10
    exact SelectedTopContinuation186.logn_cell
  have depth7 : Slot (SeventhStepEntry217.caller callee second third fourth fifth sixth) "depth" 10 := by
    change Slot FirstStepEntry187.caller "depth" 10
    exact SelectedTopContinuation186.depth_cell
  have guard7 : C99ArrayReference.scalar (SeventhStepEntry217.caller callee second third fourth fifth sixth) FirstStepEntry187.condition (.int32 1) :=
    .compare .lt _ _ _ _ _ (.variable _ _ _ (show Slot (SeventhStepEntry217.caller callee second third fourth fifth sixth) "d" 7 from by rfl)) (.variable _ _ _ depth7)
      (.step .lt (.uint32 7) (.uint32 10) .uint32 rfl (.uint32 7) (.uint32 10) rfl rfl)
  have call7 : Exec (.step FirstStepEntry187.arguments) (SeventhStepEntry217.caller callee second third fourth fifth sixth) ⟨SeventhStepReturn217.returned callee second third fourth fifth sixth seventh,.normal⟩ :=
    .step _ _ _ ⟨seventh,.normal⟩ (SeventhStepEntry217.binding _ data7 logn7 (by rfl) depth7) run7 .voidEnd
  have body7 : Exec FirstStepEntry187.body (SeventhStepEntry217.caller callee second third fourth fifth sixth) ⟨SeventhStepReturn217.returned callee second third fourth fifth sixth seventh,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call7 (SelectedStepAddPrime195.skip_run _))
  have inc7 : Exec FirstStepEntry187.increment (SeventhStepReturn217.returned callee second third fourth fifth sixth seventh) ⟨EighthStepEntry217.caller callee second third fourth fifth sixth seventh,.normal⟩ :=
    SeventhStepReturn217.increment_source _ (by rfl)
  have data8 : (EighthStepEntry217.caller callee second third fourth fifth sixth seventh).arrays "data".toList=some ft := by
    change FirstStepEntry187.caller.arrays "data".toList=some ft
    exact SelectedTopContinuation186.data_binding
  have logn8 : Slot (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) "logn" 10 := by
    change Slot FirstStepEntry187.caller "logn" 10
    exact SelectedTopContinuation186.logn_cell
  have depth8 : Slot (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) "depth" 10 := by
    change Slot FirstStepEntry187.caller "depth" 10
    exact SelectedTopContinuation186.depth_cell
  have guard8 : C99ArrayReference.scalar (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) FirstStepEntry187.condition (.int32 1) :=
    .compare .lt _ _ _ _ _ (.variable _ _ _ (show Slot (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) "d" 8 from by rfl)) (.variable _ _ _ depth8)
      (.step .lt (.uint32 8) (.uint32 10) .uint32 rfl (.uint32 8) (.uint32 10) rfl rfl)
  have call8 : Exec (.step FirstStepEntry187.arguments) (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) ⟨EighthStepReturn217.returned callee second third fourth fifth sixth seventh eighth,.normal⟩ :=
    .step _ _ _ ⟨eighth,.normal⟩ (EighthStepEntry217.binding _ data8 logn8 (by rfl) depth8) run8 .voidEnd
  have body8 : Exec FirstStepEntry187.body (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) ⟨EighthStepReturn217.returned callee second third fourth fifth sixth seventh eighth,.normal⟩ :=
    MakeFgScope187.source _ _ _ (.seqNormal _ _ _ _ _ call8 (SelectedStepAddPrime195.skip_run _))
  have inc8 : Exec FirstStepEntry187.increment (EighthStepReturn217.returned callee second third fourth fifth sixth seventh eighth) ⟨NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth,.normal⟩ :=
    EighthStepReturn217.increment_source _ (by rfl)
  have depth9 : Slot (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth) "depth" 10 := by
    change Slot FirstStepEntry187.caller "depth" 10
    exact SelectedTopContinuation186.depth_cell
  have guard9 : C99ArrayReference.scalar (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth) FirstStepEntry187.condition (.int32 1) :=
    .compare .lt _ _ _ _ _ (.variable _ _ _ (show Slot (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth) "d" 9 from by rfl)) (.variable _ _ _ depth9)
      (.step .lt (.uint32 9) (.uint32 10) .uint32 rfl (.uint32 9) (.uint32 10) rfl rfl)
  have loop10 : Exec FirstStepEntry187.loop (advance (returned callee second third fourth fifth sixth seventh eighth out)) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopFalse _ _ _ _ (.int32 0) guard10 rfl
  have loop9 : Exec FirstStepEntry187.loop (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth) (NinthStepReturn217.returned callee second third fourth fifth sixth seventh eighth out) (advance (returned callee second third fourth fifth sixth seventh eighth out)) _ (.int32 1) guard9 (by decide) body9 inc9 loop10
  have loop8 : Exec FirstStepEntry187.loop (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) (EighthStepReturn217.returned callee second third fourth fifth sixth seventh eighth) (NinthStepEntry217.caller callee second third fourth fifth sixth seventh eighth) _ (.int32 1) guard8 (by decide) body8 inc8 loop9
  have loop7 : Exec FirstStepEntry187.loop (SeventhStepEntry217.caller callee second third fourth fifth sixth) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (SeventhStepEntry217.caller callee second third fourth fifth sixth) (SeventhStepReturn217.returned callee second third fourth fifth sixth seventh) (EighthStepEntry217.caller callee second third fourth fifth sixth seventh) _ (.int32 1) guard7 (by decide) body7 inc7 loop8
  have loop6 : Exec FirstStepEntry187.loop (SixthStepEntry217.caller callee second third fourth fifth) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (SixthStepEntry217.caller callee second third fourth fifth) (SixthStepReturn217.returned callee second third fourth fifth sixth) (SeventhStepEntry217.caller callee second third fourth fifth sixth) _ (.int32 1) guard6 (by decide) body6 inc6 loop7
  have loop5 : Exec FirstStepEntry187.loop (FifthStepEntry217.caller callee second third fourth) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (FifthStepEntry217.caller callee second third fourth) (FifthStepReturn217.returned callee second third fourth fifth) (SixthStepEntry217.caller callee second third fourth fifth) _ (.int32 1) guard5 (by decide) body5 inc5 loop6
  have loop4 : Exec FirstStepEntry187.loop (FourthStepEntry216.caller callee second third) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (FourthStepEntry216.caller callee second third) (FourthStepReturn216.returned callee second third fourth) (FifthStepEntry217.caller callee second third fourth) _ (.int32 1) guard4 (by decide) body4 inc4 loop5
  have loop3 : Exec FirstStepEntry187.loop (ThirdStepFull216.caller callee second) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (ThirdStepFull216.caller callee second) (ThirdStepReturn216.returned callee second third) (FourthStepEntry216.caller callee second third) _ (.int32 1) guard3 (by decide) body3 inc3 loop4
  have loop2 : Exec FirstStepEntry187.loop (SecondStepLengths197.caller callee) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (SecondStepLengths197.caller callee) (SecondStepReturn212.returned callee second) (ThirdStepFull216.caller callee second) _ (.int32 1) guard2 (by decide) body2 inc2 loop3
  have loop1 : Exec FirstStepEntry187.loop (FirstStepEntry187.caller) ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    .loopNormal _ _ _ (FirstStepEntry187.caller) (FirstStepReturn196.returned callee) (SecondStepLengths197.caller callee) _ (.int32 1) FirstStepEntry187.guard (by decide) body1 inc1 loop2
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,loop1,FirstStepEntry187.continue_tail _ loop1,fdata,gdata⟩

end FT1536.Source3.SelectedOuterLoop217
