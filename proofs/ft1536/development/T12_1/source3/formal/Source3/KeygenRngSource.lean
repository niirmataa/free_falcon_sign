import Source3.ShakeExtractFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- M0's little-endian get_rng_u64 path. The automatic uint64 object has
   an explicit lifetime; shake_extract writes its bytes and the return reads
   those same bytes. Every refill executes fixed SHAKE source bodies.
   The outer caller still has to locate this Layout at its actual fk->rng. -/
namespace FT1536.Source3.KeygenRngSource
open C99ArrayReference (State)
open C99MemoryReference
open ShakeExtractSource (Layout)

theorem signature_source : (Pinned.keygenLines.drop 4705).take 3 =
    ["static inline uint64_t\n","get_rng_u64(shake_context *rng)\n","{\n"] := by decide
theorem little_endian_source : (Pinned.keygenLines.drop 4716).take 6 =
    ["#if FALCON_LE_U\n","\tuint64_t r;\n","\n","\tshake_extract(rng, &r, sizeof r);\n",
     "\treturn r;\n","#else\n"] ∧
    (Pinned.keygenLines.drop 4733).take 2=["#endif\n","}\n"] := by decide

def Fresh (heap : Memory) (block : Nat) : Prop :=
  heap.size block=0 ∧ heap.writable block=false ∧ ∀ offset, heap.bytes block offset=none
def allocated (heap : Memory) (block : Nat) : Memory :=
  { bytes := fun b offset => if b=block then none else heap.bytes b offset
    size := fun b => if b=block then 8 else heap.size b
    writable := fun b => if b=block then true else heap.writable b }
def disposed (before after : Memory) (block : Nat) : Memory :=
  { bytes := fun b offset => if b=block then before.bytes b offset else after.bytes b offset
    size := fun b => if b=block then before.size b else after.size b
    writable := fun b => if b=block then before.writable b else after.writable b }
def object (block : Nat) : ArrayPointer := ⟨block,0,1,8,0⟩
def bytes (block : Nat) : ArrayPointer := ⟨block,0,8,1,0⟩

inductive Call (ctx : Layout) (before : State) : State → BitVec 64 → Prop where
  | run (block : Nat) (after : State) (w : BitVec 64)
      (fresh : Fresh before.heap block)
      (extract : ShakeExtractFrame.Call ctx {before with heap := allocated before.heap block}
        (bytes block) (.uint64 8) after)
      (read : Load64 after.heap (object block) w) :
      Call ctx before {before with heap := disposed before.heap after.heap block} w

theorem slots (ctx : Layout) (before after : State) (w : BitVec 64) (source : Call ctx before after w) :
    after.locals=before.locals ∧ after.arrays=before.arrays := by cases source; exact ⟨rfl,rfl⟩

theorem source_frame (ctx : Layout) (before after : State) (w : BitVec 64) (block : Nat)
    (contextOutside : ctx.block≠block) (live : 0<before.heap.size block) (source : Call ctx before after w) :
    ShakeExtractFrame.SameBlock before.heap after.heap block := by
  cases source with
  | run localBlock after w fresh extract read =>
      have different : block≠localBlock := by intro h; subst block; rw [fresh.1] at live; omega
      have localOutside : (bytes localBlock).block≠block := Ne.symm different
      have keep := ShakeExtractFrame.call_frame ctx _ after (bytes localBlock) (.uint64 8)
        block contextOutside localOutside extract
      refine ⟨?_,?_,?_⟩
      · funext b
        by_cases equal : b=localBlock
        · simp only [disposed,equal,ite_true]
        · simpa only [disposed,allocated,equal,ite_false] using congrFun keep.1 b
      · funext b
        by_cases equal : b=localBlock
        · simp only [disposed,equal,ite_true]
        · simpa only [disposed,allocated,equal,ite_false] using congrFun keep.2.1 b
      · intro offset
        simpa only [disposed,allocated,different,ite_false] using keep.2.2 offset

end FT1536.Source3.KeygenRngSource
