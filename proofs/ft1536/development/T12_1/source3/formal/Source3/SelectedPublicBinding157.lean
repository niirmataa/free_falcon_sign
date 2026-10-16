import Source3.SelectedAttemptPrefix156
import Source3.KeygenMakeAttemptSpine
import Source3.KeygenMakeLocalFrame134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicBinding157
open C99ArrayReference (State Name bindValue bindPointer)
open C99MemoryReference (ArrayPointer)
open KeygenPublicWord (Address Bind)

noncomputable def before := SelectedAttemptPrefix156.publicInput
def f := KeygenMakeEntry.input KeygenFullData127.env.blocks 0
def g := KeygenMakeEntry.input KeygenFullData127.env.blocks 1
def h := KeygenMakeEntry.publicPointer KeygenFullData127.env.blocks

theorem fixed_local (name : Name) (member : name∈KeygenMakeLocalFrame.fixed) :
    before.locals name=SelectedAttemptPrefix156.prepared.locals name :=
  (KeygenMakeAttemptSpine.close_locals SelectedAttemptPrefix156.saved SelectedGsNorm155.after name member).trans
    (KeygenMakeLocalFrame134.ternary KeygenFullData127.env.ctx SelectedAttemptPrefix156.prepared
      ⟨SelectedGsNorm155.after,.normal⟩ SelectedAttemptPrefix156.ternary name member)

theorem logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)) :=
  (fixed_local _ (by decide)).trans (by decide +kernel)
theorem ternary : before.locals "ter".toList=some (.uint32,some (.uint32 1)) :=
  (fixed_local _ (by decide)).trans (by decide +kernel)

theorem array (name : Name) (outside : name∉KeygenCallerInit.rtNames) :
    before.arrays name=SelectedAttemptPrefix156.prepared.arrays name :=
  (KeygenCallerPrefix.close_array SelectedAttemptPrefix156.saved SelectedGsNorm155.after name outside).trans
    (congrFun (KeygenCallerPrefix134.ternary_slots KeygenFullData127.env.ctx SelectedAttemptPrefix156.prepared
      ⟨SelectedGsNorm155.after,.normal⟩ SelectedAttemptPrefix156.ternary).1 name)

theorem f_binding : before.arrays "f".toList=some f := (array _ (by decide)).trans (by decide +kernel)
theorem g_binding : before.arrays "g".toList=some g := (array _ (by decide)).trans (by decide +kernel)
theorem h_binding : before.arrays "h".toList=some h := (array _ (by decide)).trans (by decide +kernel)

theorem zero_address (name : Name) (p : ArrayPointer) (bound : before.arrays name=some p) (within : p.index ≤ p.count) :
    Address before name C99ProcedureParser.zero p :=
  .add name C99ProcedureParser.zero p p (.uint64 0) bound (.literal .uint64 0) (by decide) (.within p 0 (by simpa only [Nat.add_zero] using within))

noncomputable def empty : State := ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩
noncomputable def withTernary := bindValue empty "ternary".toList .int32 (.uint32 1)
noncomputable def dimensions := bindValue withTernary "logn".toList .uint32 (.uint32 10)
noncomputable def withG := bindPointer dimensions "g".toList g
noncomputable def withF := bindPointer withG "f".toList f
noncomputable def bound := bindPointer withF "h".toList h

/-- Actual argument binding after both norm gates, including unsigned caller ter to signed callee ternary. -/
theorem source : Bind before (KeygenPublicSource.params .compute) KeygenPublicSource.arguments bound :=
  .pointer "h".toList "h".toList C99ProcedureParser.zero h _ _ withF (zero_address _ h h_binding (by decide))
    (.pointer "f".toList "f".toList C99ProcedureParser.zero f _ _ withG (zero_address _ f f_binding (by decide))
      (.pointer "g".toList "g".toList C99ProcedureParser.zero g _ _ dimensions (zero_address _ g g_binding (by decide))
        (.scalar .uint32 "logn".toList (.var "logn".toList) _ _ withTernary (.uint32 10)
          (.variable "logn".toList .uint32 (.uint32 10) logn)
          (.scalar .int32 "ternary".toList (.var "ter".toList) [] [] empty (.uint32 1)
            (.variable "ter".toList .uint32 (.uint32 1) ternary) .nil))))

theorem logn_cell : bound.locals "logn".toList=some (.uint32,some (.uint32 10)) := by rfl
theorem ternary_cell : bound.locals "ternary".toList=some (.int32,some (.int32 1)) := by rfl
theorem f_cell : bound.arrays "f".toList=some f := by rfl
theorem g_cell : bound.arrays "g".toList=some g := by rfl
theorem h_cell : bound.arrays "h".toList=some h := by rfl
theorem heap : bound.heap=before.heap := rfl

end FT1536.Source3.SelectedPublicBinding157
