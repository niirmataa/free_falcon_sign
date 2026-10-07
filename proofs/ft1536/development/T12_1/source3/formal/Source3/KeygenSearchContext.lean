import Source3.KeygenOutputGateSource
import Source3.KeygenRngSource
import Source3.Gate00Memory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Typed LP64 object layout for the actual falcon_keygen fields. Pointer
   representation belongs to the legal allocation environment; a member read
   must also read its stored bytes. These are input-memory facts, not output
   bounds or search correctness. The physical compiler layout is checked by
   the pinned C controls, separately from these reference object rules. -/
namespace FT1536.Source3.KeygenSearchContext
open C99MemoryReference
open C99ArrayReference (State)

structure Context where
  object : ArrayPointer
  scratch : ArrayPointer
  virtualBase : Nat → Nat

def field (ctx : Context) (offset width : Nat) : ArrayPointer :=
  ⟨ctx.object.block,ctx.object.offset+offset,1,width,0⟩
def pointerWord (ctx : Context) : BitVec 64 :=
  BitVec.ofNat 64 (ctx.virtualBase ctx.scratch.block+ctx.scratch.offset)
def PointerLegal (ctx : Context) : Prop :=
  0<ctx.scratch.elementBytes ∧ ctx.scratch.index≤ctx.scratch.count ∧
  ctx.virtualBase ctx.scratch.block+ctx.scratch.base+ctx.scratch.elementBytes*ctx.scratch.count<2^64
def ObjectLegal (heap : Memory) (ctx : Context) : Prop :=
  ctx.object.offset%8=0 ∧ ctx.object.offset+448≤heap.size ctx.object.block ∧
  heap.size ctx.object.block<2^64
def Bound (s : State) (ctx : Context) : Prop := s.arrays "fk".toList=some ctx.object

inductive ReadLogn (ctx : Context) (s : State) : BitVec 32 → Prop where
  | read (word : BitVec 32) (binding : Bound s ctx) (legal : ObjectLegal s.heap ctx)
      (bytes : Load32 s.heap (field ctx 0 4) word) : ReadLogn ctx s word
inductive ReadTernary (ctx : Context) (s : State) : BitVec 32 → Prop where
  | read (word : BitVec 32) (binding : Bound s ctx) (legal : ObjectLegal s.heap ctx)
      (bytes : Load32 s.heap (field ctx 4 4) word) : ReadTernary ctx s word
inductive ReadTmp (ctx : Context) (s : State) : ArrayPointer → Prop where
  | read (binding : Bound s ctx) (legal : ObjectLegal s.heap ctx) (pointer : PointerLegal ctx)
      (bytes : Load64 s.heap (field ctx 432 8) (pointerWord ctx)) : ReadTmp ctx s ctx.scratch

def outputView (ctx : Context) (ternary : BitVec 32) : KeygenOutputGateSource.Context :=
  ⟨ternary,ctx.scratch⟩
def M0 (heap : Memory) (ctx : Context) : Prop :=
  Load32 heap (field ctx 0 4) 10 ∧ Load32 heap (field ctx 4 4) 1

theorem logn_m0 (ctx : Context) (s : State) (word : BitVec 32)
    (m0 : M0 s.heap ctx) (source : ReadLogn ctx s word) : word=10 := by
  cases source with
  | read binding legal bytes => exact Gate00Memory.load32_deterministic _ _ _ _ bytes m0.1

theorem ternary_m0 (ctx : Context) (s : State) (word : BitVec 32)
    (m0 : M0 s.heap ctx) (source : ReadTernary ctx s word) : word=1 := by
  cases source with
  | read binding legal bytes => exact Gate00Memory.load32_deterministic _ _ _ _ bytes m0.2

theorem tmp_value (ctx : Context) (s : State) (p : ArrayPointer) (source : ReadTmp ctx s p) :
    p=ctx.scratch := by cases source; rfl

theorem fields_source : (Pinned.keygenLines.drop 4678).take 20 = [
  "struct falcon_keygen_ {\n","\n","\t/* Base-2 logarithm of the degree. */\n","\tunsigned logn;\n","\n",
  "\t/* 1 for a ternary modulus, 0 for binary. */\n","\tunsigned ternary;\n","\n",
  "\t/* RNG:\n","\t   seeded    non-zero when a 'replace' seed or system RNG was pushed\n",
  "\t   flipped   non-zero when flipped */\n","\tshake_context rng;\n","\tint seeded;\n","\tint flipped;\n","\n",
  "\t/* Temporary storage for key generation. 'tmp_len' is expressed\n","\t   in 32-bit words. */\n",
  "\tuint32_t *tmp;\n","\tsize_t tmp_len;\n","};\n"] := by decide

end FT1536.Source3.KeygenSearchContext
