import Source3.C99NameMap115
import Source3.C99ExpressionSound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99CompactCells115
open B20.C (Ty Val)
open C99ArrayReference (Name)

/-- A finite local cell retains its declared type and initialization state.
    The value type is correct by construction, not by an input premise. -/
inductive Cell where
  | u64 (value : Option (BitVec 64))
  | i64 (value : Option (BitVec 64))
  | u32 (value : Option (BitVec 32))
  | i32 (value : Option (BitVec 32))
  deriving Repr, DecidableEq

def Cell.ty : Cell → Ty
  | .u64 _ => .u64 | .i64 _ => .i64 | .u32 _ => .u32 | .i32 _ => .i32

def Cell.value : Cell → Option Val
  | .u64 word => word.map Val.u64 | .i64 word => word.map Val.i64
  | .u32 word => word.map Val.u32 | .i32 word => word.map Val.i32

def Cell.reference (cell : Cell) : C99IntegerReference.Ty × Option C99IntegerReference.Value :=
  (C99ValueBridge.type cell.ty,cell.value.map C99ValueBridge.value)

def Cell.uninitialized : Ty → Cell
  | .u64 => .u64 none | .i64 => .i64 none | .u32 => .u32 none | .i32 => .i32 none

def Cell.converted (ty : Ty) (value : Val) : Cell :=
  match ty with
  | .u64 => .u64 (some (BitVec.ofInt 64 value.integer))
  | .i64 => .i64 (some (BitVec.ofInt 64 value.integer))
  | .u32 => .u32 (some (BitVec.ofInt 32 value.integer))
  | .i32 => .i32 (some (BitVec.ofInt 32 value.integer))

theorem Cell.value_type (cell : Cell) (value : Val) (stored : cell.value=some value) : value.ty=cell.ty := by
  cases cell with
  | u64 word | i64 word | u32 word | i32 word =>
      obtain ⟨bits, _, same⟩ := Option.map_eq_some_iff.mp stored
      subst value
      rfl

theorem Cell.converted_type (ty : Ty) (value : Val) : (Cell.converted ty value).ty=ty := by cases ty <;> rfl

theorem Cell.converted_value (ty : Ty) (value : Val) :
    (Cell.converted ty value).value=some (B20.C.cast ty value) := by
  have casted : B20.C.cast ty value = C99ValueBridge.encode
      (C99IntegerReference.convert (C99ValueBridge.type ty) value.integer) := by
    simpa only [C99ValueBridge.encode_value,C99ValueBridge.integer_matches] using
      congrArg C99ValueBridge.encode (C99ValueBridge.cast_matches ty value)
  rw [casted]
  cases ty <;> rfl

theorem Cell.uninitialized_reference (ty : Ty) :
    (Cell.uninitialized ty).reference = (C99ValueBridge.type ty,none) := by cases ty <;> rfl

theorem Cell.converted_reference (ty : Ty) (value : Val) :
    (Cell.converted ty value).reference =
      (C99ValueBridge.type ty,some (C99IntegerReference.convert (C99ValueBridge.type ty) (C99ValueBridge.value value).integer)) := by
  simp [Cell.reference,Cell.converted_type,Cell.converted_value,C99ValueBridge.cast_matches]

abbrev Locals := C99NameMap115.Table Cell

def model (locals : Locals) : B20.C.Scalar.State where
  types name := (C99NameMap115.lookup locals name).map Cell.ty
  values name := (C99NameMap115.lookup locals name).bind Cell.value

def environment (locals : Locals) : C99ScalarReference.Env :=
  fun name => (C99NameMap115.lookup locals name).map Cell.reference

theorem model_typed (locals : Locals) : C99Typing.WellTyped (model locals) := by
  intro name value stored
  obtain ⟨cell, found, typed⟩ := Option.bind_eq_some_iff.mp stored
  change (C99NameMap115.lookup locals name).map Cell.ty=some value.ty
  rw [found, Option.map_some, Cell.value_type cell value typed]

theorem environment_model (locals : Locals) : environment locals = C99Typing.environment (model locals) := by
  funext name
  cases found : C99NameMap115.lookup locals name <;>
    simp [environment,model,C99Typing.environment,found,Cell.reference]

theorem environment_put (locals : Locals) (name : Name) (cell : Cell) :
    environment (C99NameMap115.put locals name cell) =
      C99ScalarReference.set (environment locals) name cell.reference := by
  funext other
  by_cases same : other=name
  all_goals simp [environment,C99NameMap115.lookup_put,C99ScalarReference.set,same]

theorem environment_restore (before after : Locals) (names : List Name) :
    environment (C99NameMap115.restore before after names) =
      C99ScalarReference.restore (environment before) (environment after) names := by
  funext other
  by_cases inside : other∈names
  all_goals simp [environment,C99NameMap115.lookup_restore,C99ScalarReference.restore,inside]

end FT1536.Source3.C99CompactCells115
