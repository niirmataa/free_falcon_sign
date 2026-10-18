import Source3.SelectedForwardFrame184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSecondEntry185
open C99ArrayReference (State bindValue bindPointer)
open SelectedTopLayout177 (gs gm)
open SelectedTopInit178 (p p0i)

noncomputable def before := SelectedForwardCall184.after
noncomputable def empty : State := ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩
noncomputable def withI := bindValue empty "p0i".toList .uint32 (.uint32 p0i)
noncomputable def withP := bindValue withI "p".toList .uint32 (.uint32 p)
noncomputable def withFull := bindValue withP "full".toList .uint32 (.int32 1)
noncomputable def withLogn := bindValue withFull "logn".toList .uint32 (.uint32 10)
noncomputable def withGm := bindPointer withLogn "gm".toList gm
noncomputable def withStride := bindValue withGm "stride".toList .uint64 (.int32 1)
noncomputable def entry := bindPointer withStride "a".toList gs

theorem binding : KeygenLevelCalls.Bind before (KeygenLevelCalls.params .forward) (TopForwardShape182.args "gs") entry :=
  .pointer "a".toList "gs".toList C99ProcedureParser.zero gs _ _ _
    (RootBinding175.zero before "gs" gs rfl (by decide))
    (.scalar .uint64 "stride".toList _ _ _ _ (.int32 1) (.modular _ _ (.scalar _ _ (.literal .int32 1)))
      (.pointer "gm".toList "gm".toList C99ProcedureParser.zero gm _ _ _
        (RootBinding175.zero before "gm" gm rfl (by decide))
        (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 10)
          (.modular _ _ (.scalar _ _ (.variable _ _ _ SelectedTopPrefix177.logn_cell)))
          (.scalar .uint32 "full".toList _ _ _ _ (.int32 1) (.modular _ _ (.scalar _ _ (.literal .int32 1)))
            (.scalar .uint32 "p".toList _ _ _ _ (.uint32 p)
              (.modular _ _ (.scalar _ _ (.variable _ _ _ SelectedTopInit178.p_cell)))
              (.scalar .uint32 "p0i".toList _ [] [] empty (.uint32 p0i)
                (.modular _ _ (.scalar _ _ (.variable _ _ _ SelectedTopInit178.i_cell))) .nil))))))

theorem source_call (out : C99ProcedureReference.Result)
    (source : C99ModularReference.Exec KeygenNttForwardPrograms.forwardBody entry out)
    (returned : C99ProcedureReference.ReturnValue none out.flow none) :
    KeygenLevelCalls.Call .forward before (TopForwardShape182.args "gs") {before with heap:=out.state.heap} :=
  .run entry out binding source returned

end FT1536.Source3.SelectedSecondEntry185
