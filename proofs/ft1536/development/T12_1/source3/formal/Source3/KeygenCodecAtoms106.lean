import Source3.KeygenLoopEntry105

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecAtoms106
open C99MemoryReference
open KeygenCodecSyntax
open KeygenCodecValues

/-- Pointer-only identifiers have no scalar shadow in actual activations. -/
def Clean (l : Locals) : Prop :=
  l.scalars "out".toList = none ∧ l.scalars "NULL".toList = none ∧
  l.scalars "x".toList = none ∧ l.scalars "buf".toList = none

theorem initial_clean (args : Args) : Clean (initialLocals args) := by
  simp [Clean, initialLocals]

theorem local_set_clean (l : Locals) (name : Name) (ty : C99IntegerReference.Ty)
    (old value : Option C99IntegerReference.Value) (clean : Clean l)
    (declared : l.scalars name = some (ty,old)) : Clean (localSet l name ty value) := by
  simp only [Clean, localSet, C99ScalarReference.set] at *
  split_ifs <;> grind

theorem load16 (heap : Memory) (p : ArrayPointer) (a b : BitVec 16)
    (first : Load16 heap p a) (second : Load16 heap p b) : a = b := by
  cases first
  cases second
  grind

theorem unary (op : Unary) (x a b : Value)
    (first : UnaryOp op x a) (second : UnaryOp op x b) : a = b := by
  cases first <;> cases second
  all_goals grind only [C99IntegerReference.neg_deterministic, C99ScalarDeterminism089.complement_unique]

theorem binary (op : Op) (x y a b : Value)
    (first : BinaryOp op x y a) (second : BinaryOp op x y b) : a = b := by
  cases first <;> cases second
  all_goals grind only [C99IntegerReference.arithmetic_deterministic, C99IntegerReference.shift_deterministic,
    C99IntegerReference.bitwise_deterministic, C99ScalarDeterminism089.compare_unique]

theorem no_and (x y z : Value) (source : BinaryOp .land x y z) : False := by cases source

theorem no_or (x y z : Value) (source : BinaryOp .lor x y z) : False := by cases source

theorem no_dereference (x y : Value) (source : UnaryOp .dereference x y) : False := by cases source

theorem update_clean (name : Name) (delta : Int) (before after : Locals) (old value : Value)
    (source : Update name delta before old value after) (clean : Clean before) : Clean after := by
  cases source with
  | scalar name delta l ty v z bound operation => exact local_set_clean _ name ty (some v) _ clean bound
  | pointer => exact clean

theorem update (name : Name) (delta : Int) (before a b : Locals) (x y u v : Value)
    (clean : Clean before) (first : Update name delta before x y a) (second : Update name delta before u v b) :
    a = b ∧ x = u ∧ y = v := by
  cases first <;> cases second
  all_goals simp only [Clean] at clean
  all_goals grind only [C99IntegerReference.arithmetic_deterministic, C99HeapDeterminism089.pointer_add]

theorem assigned (op : Assign) (old : Option C99IntegerReference.Value) (rhs a b : C99IntegerReference.Value)
    (first : Assigned op old rhs a) (second : Assigned op old rhs b) : a = b := by
  cases first <;> cases second
  all_goals grind only [binary, KeygenCodecValues.assignOp]

end FT1536.Source3.KeygenCodecAtoms106
