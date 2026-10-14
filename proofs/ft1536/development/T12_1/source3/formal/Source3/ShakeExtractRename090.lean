import Source3.ShakeEncodeRename090

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractRename090
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)
open ShakeExtractSource (Layout Field)
open C99BlockRename090

def layout (r : Renaming) (ctx : Layout) : Layout := ⟨r ctx.block, ctx.base⟩

theorem field (r : Renaming) (ctx : Layout) (member : Field) :
    ptr r (ShakeExtractSource.field ctx member) = ShakeExtractSource.field (layout r ctx) member := by
  cases member <;> rfl

theorem execution (r : Renaming) (ctx : Layout) (code : ShakeExtractSource.Stmt) (before after : State)
    (source : ShakeExtractSource.Exec ctx code before after) :
    ShakeExtractSource.Exec (layout r ctx) code (state r before) (state r after) := by
  induction source with
  | scalar code before env body =>
      exact .scalar code (state r before) env
        (C99ScalarTransport090.execution _ _ (ShakeBlockRename090.read_calls r before)
          before.locals (C99Frontend.scalar code) _ body)
  | declarePointer name s =>
      rw [C99StateRename090.declarePointer]
      exact .declarePointer name (state r s)
  | pointer dst src index s p address =>
      rw [C99StateRename090.bindPointer]
      exact .pointer dst src index (state r s) (ptr r p)
        (C99StateRename090.pointer r s src index p address)
  | fieldPointer dst member s =>
      rw [C99StateRename090.bindPointer, field]
      exact .fieldPointer dst member (state r s)
  | fieldRead dst member s ty old v declared read =>
      rw [C99StateRename090.bindValue]
      exact .fieldRead dst member (state r s) ty old v declared
        (by simpa only [field, state] using load64 r s.heap (ShakeExtractSource.field ctx member) v read)
  | fieldStore member value s written v evaluated write =>
      exact .fieldStore member value (state r s) (heap r written) v
        (ShakeBlockRename090.expression r s value v evaluated)
        (by simpa only [field, state] using store64 r s.heap written (ShakeExtractSource.field ctx member) _ write)
  | process src before after p address call =>
      exact .process src (state r before) (state r after) (ptr r p)
        (C99StateRename090.pointer r before src ShakeExtractSource.zero p address)
        (ShakeBlockRename090.process r before after p call)
  | encode dst index value before after p v address evaluated call =>
      exact .encode dst index value (state r before) (state r after) (ptr r p) v
        (C99StateRename090.pointer r before dst index p address)
        (ShakeBlockRename090.expression r before value v evaluated)
        (ShakeEncodeRename090.invoke r before after p v call)
  | copy dst index count s written p q i n destination offset length source dstObject srcObject copy =>
      exact .copy dst index count (state r s) (heap r written) (ptr r p) (ptr r q) i n
        (C99StateRename090.pointer r s dst ShakeExtractSource.zero p destination)
        (C99StateRename090.scalar r s index (.uint64 i) offset)
        (C99StateRename090.scalar r s count (.uint64 n) length)
        (by simpa only [field] using pointer_add r (ShakeExtractSource.field ctx .dbuf) q i.toNat source)
        dstObject srcObject (memcpy r s.heap written p q n.toNat copy)
  | skip s => exact .skip (state r s)
  | seq a b before middle after first second ih1 ih2 =>
      exact .seq a b (state r before) (state r middle) (state r after) ih1 ih2
  | scope locals pointers code before after inner ih =>
      rw [C99StateRename090.restoreScope]
      exact .scope locals pointers code (state r before) (state r after) ih
  | branchTrue condition yes no before after v guard nonzero body ih =>
      exact .branchTrue condition yes no (state r before) (state r after) v
        (ShakeBlockRename090.expression r before condition v guard) nonzero ih
  | branchFalse condition yes no before after v guard zero body ih =>
      exact .branchFalse condition yes no (state r before) (state r after) v
        (ShakeBlockRename090.expression r before condition v guard) zero ih
  | loopFalse condition body s v guard zero =>
      exact .loopFalse condition body (state r s) v (ShakeBlockRename090.expression r s condition v guard) zero
  | loopNext condition body before middle after v guard nonzero iteration rest ih1 ih2 =>
      exact .loopNext condition body (state r before) (state r middle) (state r after) v
        (ShakeBlockRename090.expression r before condition v guard) nonzero ih1 ih2

theorem entry (r : Renaming) (before : State) (p : ArrayPointer) (length : Value) :
    state r (ShakeExtractFrame.entry before p length) =
      ShakeExtractFrame.entry (state r before) (ptr r p) length := by
  apply C99StateRename090.ext <;> try rfl
  funext name
  by_cases out : name = ['o','u','t'] <;> simp [state, ShakeExtractFrame.entry, out]

theorem call (r : Renaming) (ctx : Layout) (before after : State) (p : ArrayPointer) (length : Value)
    (source : ShakeExtractFrame.Call ctx before p length after) :
    ShakeExtractFrame.Call (layout r ctx) (state r before) (ptr r p) length (state r after) := by
  cases source with
  | run after body =>
      have transformed := execution r ctx ShakeExtractSource.code (ShakeExtractFrame.entry before p length) after body
      rw [entry] at transformed
      exact .run (state r after) transformed

/-- The public extraction entry binds its own locals and output pointer;
    unrelated caller slots do not select an alternative output. -/
theorem entry_rebase (a b : State) (p : ArrayPointer) (length : Value)
    (heapEq : a.heap = b.heap) (globalsEq : a.globals = b.globals) (tablesEq : a.tables = b.tables) :
    ShakeExtractFrame.entry a p length = ShakeExtractFrame.entry b p length :=
  C99StateRename090.ext _ _ heapEq rfl rfl globalsEq tablesEq

theorem call_rebase (ctx : Layout) (before after changed : State) (p : ArrayPointer) (length : Value)
    (heapEq : before.heap = changed.heap) (globalsEq : before.globals = changed.globals)
    (tablesEq : before.tables = changed.tables)
    (source : ShakeExtractFrame.Call ctx before p length after) :
    ShakeExtractFrame.Call ctx changed p length {changed with heap := after.heap} := by
  cases source with
  | run result body =>
      rw [entry_rebase before changed p length heapEq globalsEq tablesEq] at body
      exact .run result body

end FT1536.Source3.ShakeExtractRename090
