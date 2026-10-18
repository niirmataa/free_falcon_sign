import Source3.SelectedMakeFgDispatch176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMakeFgTopEntry176
open C99ArrayReference (State bindValue bindPointer)
open KeygenMakeFgSource (Exec Stmt)
open SelectedMakeFgConvert176 (after frame)
open SelectedMakeFgSetup176 (ft gt)

def outExpr : CLogic.Expr := .lor (.cmp .gt (.var "depth".toList) (.literal .i32 1)) (.var "out_ntt".toList)
def arguments : List C99ArrayReference.Arg := [.pointer "data".toList C99ProcedureParser.zero,
  .scalar (.var "logn".toList),.scalar outExpr]
def tail : Stmt := match KeygenMakeFgSource.part .make 3 with
  | .seq (.branch _ (.scope _ _ (.seq _ rest)) _) _ => rest
  | _ => KeygenMakeFgSource.skip
def binaryBody : Stmt := match KeygenMakeFgSource.part .make 3 with
  | .seq (.branch _ _ body) _ => body
  | _ => KeygenMakeFgSource.skip

theorem shape : KeygenMakeFgSource.part .make 3=
    .seq (.branch (.var "ter".toList) (.scope [] [] (.seq (.top arguments) tail)) binaryBody) KeygenMakeFgSource.skip := by decide

noncomputable def empty : State := ⟨after.heap,after.globals,after.tables,after.globals,after.tables⟩
noncomputable def withOutput := bindValue empty "out_ntt".toList .int32 (.int32 1)
noncomputable def withLogn := bindValue withOutput "logn".toList .uint32 (.uint32 10)
noncomputable def entry := bindPointer withLogn "data".toList ft

theorem output_expr : C99ArrayReference.scalar after outExpr (.int32 1) :=
  .orTrue _ _ (.int32 1)
    (.compare .gt _ _ _ _ _ (.variable _ _ _ SelectedMakeFgDispatch176.depth_cell) (.literal .int32 1)
      (.step .gt (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl)) (by decide)

theorem data_binding : after.arrays "data".toList=some ft := by
  rw [frame.arrays]
  rfl

theorem binding : C99ArrayReference.Bind after KeygenMakeFgTop.params arguments entry :=
  .pointer "data".toList "data".toList C99ProcedureParser.zero ft _ _ _
    (RootBinding175.zero after "data" ft data_binding (by decide))
    (.scalar .uint32 "logn".toList (.var "logn".toList) _ _ _ (.uint32 10)
      (.variable _ _ _ SelectedMakeFgDispatch176.logn_cell)
      (.scalar .int32 "out_ntt".toList outExpr [] [] empty (.int32 1) output_expr .nil))

theorem source_call (out : C99ProcedureReference.Result)
    (source : KeygenLevelExec.Exec KeygenMakeFgTop.code entry out)
    (returned : C99ProcedureReference.ReturnValue none out.flow none) :
    KeygenMakeFgTop.Call after arguments {after with heap:=out.state.heap} :=
  .run entry out binding source returned

theorem initialized (j : Nat) (inside : j<3072) :
    ∃ w : BitVec 32, C99MemoryReference.Load32 entry.heap (KeygenSmallOutput.element ft j) w := by
  by_cases low : j<1536
  · exact ⟨_,SelectedMakeFgConvert176.f_image ⟨j,low⟩⟩
  · have high : j-1536<1536 := by omega
    have read := SelectedMakeFgConvert176.g_image ⟨j-1536,high⟩
    have equal : Word32Memory176.element gt ⟨j-1536,high⟩=KeygenSmallOutput.element ft j := by
      unfold Word32Memory176.element SelectedMakeFgSetup176.gt KeygenSmallOutput.element
      congr 1
      change ft.index+1536+(j-1536)=ft.index+j
      omega
    rw [equal] at read
    exact ⟨_,read⟩

theorem writable : entry.heap.writable ft.block=true := SelectedMakeFgConvert176.output_fixed.tWritable

end FT1536.Source3.SelectedMakeFgTopEntry176
