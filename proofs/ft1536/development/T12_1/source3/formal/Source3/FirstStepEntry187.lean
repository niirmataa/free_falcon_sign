import Source3.SelectedTopContinuation186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FirstStepEntry187
open C99ArrayReference (State bindValue bindPointer)
open KeygenMakeFgSource (Exec Stmt)
open SelectedMakeFgSetup176 (ft)

def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def outExpr : CLogic.Expr := .lor (.cmp .lt (.bin .add (var "d") (num 1)) (var "depth")) (var "out_ntt")
def arguments : List C99ArrayReference.Arg := [.pointer "data".toList C99ProcedureParser.zero,
  .scalar (.bin .sub (var "logn") (var "d")),.scalar (var "d"),.scalar (num 1),.scalar (num 1),.scalar outExpr]
def initial : Stmt := KeygenMakeFgSource.modular (.assign "d".toList (.scalar (num 1)))
def condition : CLogic.Expr := .cmp .lt (var "d") (var "depth")
def increment : Stmt := KeygenMakeFgSource.modular (.base (.scalar (.update "d".toList .add (num 1))))
def body : Stmt := .scope [] [] (.seq (.step arguments) KeygenMakeFgSource.skip)
def loop : Stmt := .loop condition body increment

theorem tail_shape : SelectedMakeFgTopEntry176.tail=.seq (.seq initial loop) KeygenMakeFgSource.skip := by decide

noncomputable abbrev before := SelectedTopCall186.after
noncomputable def caller := bindValue before "d".toList .uint32 (.int32 1)

theorem d_declared : before.locals "d".toList=some (.uint32,none) :=
  (SelectedMakeFgConvert176.frame.locals "d".toList (by decide)).trans rfl

theorem initial_source : Exec initial before ⟨caller,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint32 none (.int32 1) d_declared (.scalar _ _ (.literal .int32 1))))

theorem guard : C99ArrayReference.scalar caller condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ rfl) (.variable _ _ _ SelectedTopContinuation186.depth_cell)
    (.step .lt (.uint32 1) (.uint32 10) .uint32 rfl (.uint32 1) (.uint32 10) rfl rfl)

theorem logn_expr : C99ArrayReference.scalar caller (.bin .sub (var "logn") (var "d")) (.uint32 9) :=
  .arithmetic .minus _ _ _ _ _ (.variable _ _ _ SelectedTopContinuation186.logn_cell) (.variable _ _ _ rfl)
    (.step .minus (.uint32 10) (.uint32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
      (by intro impossible; cases impossible))

theorem out_expr : C99ArrayReference.scalar caller outExpr (.int32 1) :=
  .orTrue _ _ (.int32 1)
    (.compare .lt _ _ _ _ _
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
        (.step .plus (.uint32 1) (.int32 1) .uint32 rfl (.uint32 1) (.uint32 1) rfl rfl
          (by intro impossible; cases impossible)))
      (.variable _ _ _ SelectedTopContinuation186.depth_cell)
      (.step .lt (.uint32 2) (.uint32 10) .uint32 rfl (.uint32 2) (.uint32 10) rfl rfl)) (by decide)

noncomputable def empty : State := ⟨caller.heap,caller.globals,caller.tables,caller.globals,caller.tables⟩
noncomputable def withOut := bindValue empty "out_ntt".toList .int32 (.int32 1)
noncomputable def withIn := bindValue withOut "in_ntt".toList .int32 (.int32 1)
noncomputable def withTer := bindValue withIn "ter".toList .uint32 (.int32 1)
noncomputable def withDepth := bindValue withTer "depth".toList .uint32 (.uint32 1)
noncomputable def withLogn := bindValue withDepth "logn".toList .uint32 (.uint32 9)
noncomputable def entry := bindPointer withLogn "data".toList ft

theorem binding : C99ArrayReference.Bind caller (KeygenMakeFgSource.params .step) arguments entry :=
  .pointer "data".toList "data".toList C99ProcedureParser.zero ft _ _ _
    (RootBinding175.zero caller "data" ft SelectedTopContinuation186.data_binding (by decide))
    (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 9) logn_expr
      (.scalar .uint32 "depth".toList _ _ _ _ (.uint32 1) (.variable _ _ _ rfl)
        (.scalar .uint32 "ter".toList _ _ _ _ (.int32 1) (.literal .int32 1)
          (.scalar .int32 "in_ntt".toList _ _ _ _ (.int32 1) (.literal .int32 1)
            (.scalar .int32 "out_ntt".toList _ [] [] empty (.int32 1) out_expr .nil)))))

theorem source_step (out : C99ProcedureReference.Result)
    (source : Exec (KeygenMakeFgSource.code .step) entry out)
    (returned : C99ProcedureReference.ReturnValue none out.flow none) :
    Exec (.step arguments) caller ⟨{caller with heap:=out.state.heap},.normal⟩ :=
  .step arguments caller entry out binding source returned

theorem entry_heap : entry.heap=before.heap := C99ArrayReference.bind_heap caller _ _ entry binding

theorem continue_tail (out : State) (rest : Exec loop caller ⟨out,.normal⟩) :
    Exec SelectedMakeFgTopEntry176.tail before ⟨out,.normal⟩ := by
  rw [tail_shape]
  exact .seqNormal _ _ before out ⟨out,.normal⟩ (.seqNormal _ _ before caller ⟨out,.normal⟩ initial_source rest)
    (MakeFgDeclarations176.array_source .skip out out (.skip out))

end FT1536.Source3.FirstStepEntry187
