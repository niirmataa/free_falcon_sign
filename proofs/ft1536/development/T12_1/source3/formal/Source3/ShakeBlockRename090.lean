import Source3.C99StateRename090
import Source3.C99ScalarTransport090

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeBlockRename090
open C99MemoryReference
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99BlockRename090

theorem read_calls (r : Renaming) (s : State) :
    C99ScalarTransport090.CallsMap (ShakeBlock.ReadCall s) (ShakeBlock.ReadCall (state r s)) := by
  intro name args value source
  cases source with
  | read name index root p w binding nonnegative address read =>
      exact .read name index (ptr r root) (ptr r p) w
        (by simp only [state, binding, Option.map_some]) nonnegative
        (pointer_add r root p index.integer.toNat address) (load64 r s.heap p w read)

theorem expression (r : Renaming) (s : State) (e : CLogic.Expr) (v : Value)
    (source : ShakeBlock.Eval s e v) : ShakeBlock.Eval (state r s) e v :=
  C99ScalarTransport090.expression (ShakeBlock.ReadCall s) (ShakeBlock.ReadCall (state r s))
    (read_calls r s) s.locals (C99Frontend.expression e) v source

theorem execution (r : Renaming) (code : ShakeBlock.Stmt) (before after : State)
    (source : ShakeBlock.Exec code before after) : ShakeBlock.Exec code (state r before) (state r after) := by
  induction source with
  | scalar code before env body =>
      exact .scalar code (state r before) env
        (C99ScalarTransport090.execution _ _ (read_calls r before) before.locals (C99Frontend.scalar code) _ body)
  | store name index value before after p v address evaluated write =>
      exact .store name index value (state r before) (heap r after) (ptr r p) v
        (C99StateRename090.pointer r before name index p address)
        (expression r before value v evaluated) (store64 r before.heap after p _ write)
  | skip s => exact .skip (state r s)
  | seq a b before middle after first second ih1 ih2 =>
      exact .seq a b (state r before) (state r middle) (state r after) ih1 ih2
  | scope locals body before after inner ih =>
      rw [C99StateRename090.restoreScope]
      exact .scope locals body (state r before) (state r after) ih
  | loopFalse condition body increment before v guard zero =>
      exact .loopFalse condition body increment (state r before) v (expression r before condition v guard) zero
  | loopNext condition body increment before middle next after v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact .loopNext condition body increment (state r before) (state r middle) (state r next)
        (state r after) v (expression r before condition v guard) nonzero ih1 ih2 ih3

theorem element (r : Renaming) (p : ArrayPointer) (i : Nat) :
    ptr r (KeygenSmallOutput.element p i) = KeygenSmallOutput.element (ptr r p) i := rfl

theorem static_rc (r : Renaming) (h : Memory) (table : ArrayPointer)
    (source : ShakeExtractSource.StaticRC h table) : ShakeExtractSource.StaticRC (heap r h) (ptr r table) := by
  refine ⟨?_, source.2.1, ?_⟩
  · simpa only [ptr, heap, Equiv.symm_apply_apply] using source.1
  · intro i
    simpa only [element] using load64 r h (KeygenSmallOutput.element table i.val) _ (source.2.2 i)

theorem block_entry (r : Renaming) (s : State) (p table : ArrayPointer) :
    state r (ShakeExtractSource.blockEntry s p table) =
      ShakeExtractSource.blockEntry (state r s) (ptr r p) (ptr r table) := by
  apply C99StateRename090.ext <;> try rfl
  funext name
  by_cases a : name = ['A'] <;> by_cases rc : name = ['R','C'] <;>
    simp [state, ShakeExtractSource.blockEntry, a, rc]

theorem process (r : Renaming) (before after : State) (p : ArrayPointer)
    (source : ShakeExtractSource.Process before p after) :
    ShakeExtractSource.Process (state r before) (ptr r p) (state r after) := by
  cases source with
  | run table after binding static body =>
      have transformed := execution r ShakeBlockProgram.code (ShakeExtractSource.blockEntry before p table) after body
      rw [block_entry] at transformed
      exact .run (ptr r table) (state r after)
        (by simp only [state, binding, Option.map_some]) (static_rc r before.heap table static) transformed

end FT1536.Source3.ShakeBlockRename090
