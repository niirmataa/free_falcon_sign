import Source3.ShakeExtractRename090
import Source3.ShakeExtractDeterminism090

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RngTemporarySwap090
open C99MemoryReference
open C99ArrayReference (State)
open C99BlockRename090
open KeygenRngSource (Fresh allocated disposed)

theorem memory_ext (a b : Memory) (bytesEq : a.bytes = b.bytes) (sizeEq : a.size = b.size)
    (writableEq : a.writable = b.writable) : a = b := by cases a; cases b; simp_all

theorem swap_invariant {A : Type} (f : Nat → A) (a b : Nat) (equal : f a = f b) :
    (fun c => f ((Equiv.swap a b).symm c)) = f := by
  funext c
  by_cases ca : c = a
  · subst c
    simpa only [Equiv.symm_swap, Equiv.swap_apply_left] using equal.symm
  · by_cases cb : c = b
    · subst c
      simpa only [Equiv.symm_swap, Equiv.swap_apply_right] using equal
    · simp only [Equiv.symm_swap, Equiv.swap_apply_of_ne_of_ne ca cb]

theorem fresh_heap_swap (before : Memory) (a b : Nat) (fa : Fresh before a) (fb : Fresh before b) :
    heap (Equiv.swap a b) before = before := by
  apply memory_ext
  · exact swap_invariant before.bytes a b (funext fun o => (fa.2.2 o).trans (fb.2.2 o).symm)
  · exact swap_invariant before.size a b (fa.1.trans fb.1.symm)
  · exact swap_invariant before.writable a b (fa.2.1.trans fb.2.1.symm)

theorem preimage_eq (r : Renaming) (a b : Nat) : r.symm b = a ↔ b = r a := by
  constructor
  · intro equal
    simpa using congrArg r equal
  · intro equal
    rw [equal]
    simp

theorem allocation_rename (r : Renaming) (before : Memory) (a : Nat) :
    heap r (allocated before a) = allocated (heap r before) (r a) := by
  apply memory_ext
  · funext b o
    simp only [heap, KeygenRngSource.allocated, preimage_eq]
  · funext b
    simp only [heap, KeygenRngSource.allocated, preimage_eq]
  · funext b
    simp only [heap, KeygenRngSource.allocated, preimage_eq]

theorem allocation_swap (before : Memory) (a b : Nat) (fa : Fresh before a) (fb : Fresh before b) :
    heap (Equiv.swap a b) (allocated before a) = allocated before b := by
  rw [allocation_rename, fresh_heap_swap before a b fa fb, Equiv.swap_apply_left]

theorem disposal_rename (r : Renaming) (before after : Memory) (a : Nat) :
    heap r (disposed before after a) = disposed (heap r before) (heap r after) (r a) := by
  apply memory_ext
  · funext b o
    simp only [heap, disposed, preimage_eq]
  · funext b
    simp only [heap, disposed, preimage_eq]
  · funext b
    simp only [heap, disposed, preimage_eq]

theorem disposed_fresh (before after : Memory) (a : Nat) (fresh : Fresh before a) :
    Fresh (disposed before after a) a := by
  simpa only [Fresh, disposed, ite_true] using fresh

theorem other_fresh (before after : Memory) (a b : Nat) (different : b ≠ a) (fresh : Fresh after b) :
    Fresh (disposed before after a) b := by
  simpa only [Fresh, disposed, different, ite_false] using fresh

theorem disposal_swap (before after : Memory) (a b : Nat) (fa : Fresh before a) (fb : Fresh before b)
    (different : b ≠ a) (kept : Fresh after b) :
    disposed before (heap (Equiv.swap a b) after) b = disposed before after a := by
  have moved := disposal_rename (Equiv.swap a b) before after a
  rw [fresh_heap_swap before a b fa fb, Equiv.swap_apply_left] at moved
  rw [← moved]
  exact fresh_heap_swap (disposed before after a) a b
    (disposed_fresh before after a fa) (other_fresh before after a b different kept)

def TablesLive (s : State) : Prop := ∀ name p, s.tables name = some p → 0 < s.heap.size p.block

theorem live_fixed (before : Memory) (a b block : Nat) (fa : Fresh before a) (fb : Fresh before b)
    (live : 0 < before.size block) : Equiv.swap a b block = block := by
  apply Equiv.swap_apply_of_ne_of_ne
  · intro equal
    rw [equal, fa.1] at live
    omega
  · intro equal
    rw [equal, fb.1] at live
    omega

theorem pointer_fixed (r : Renaming) (p : ArrayPointer) (fixed : r p.block = p.block) : ptr r p = p := by
  simp only [ptr, fixed]

theorem tables_fixed (before : State) (a b : Nat) (fa : Fresh before.heap a) (fb : Fresh before.heap b)
    (live : TablesLive before) : (state (Equiv.swap a b) before).tables = before.tables := by
  funext name
  cases binding : before.tables name with
  | none => simp only [state, binding, Option.map_none]
  | some p =>
      have fixed := pointer_fixed (Equiv.swap a b) p (live_fixed before.heap a b p.block fa fb (live name p binding))
      simp only [state, binding, Option.map_some, fixed]

theorem context_fixed (ctx : ShakeExtractSource.Layout) (before : State) (a b : Nat)
    (fa : Fresh before.heap a) (fb : Fresh before.heap b) (live : 0 < before.heap.size ctx.block) :
    ShakeExtractRename090.layout (Equiv.swap a b) ctx = ctx := by
  have fixed := live_fixed before.heap a b ctx.block fa fb live
  cases ctx
  simp_all only [ShakeExtractRename090.layout]

theorem object_swap (a b : Nat) : ptr (Equiv.swap a b) (KeygenRngSource.object a) = KeygenRngSource.object b := by
  simp only [ptr, KeygenRngSource.object, Equiv.swap_apply_left]

theorem bytes_swap (a b : Nat) : ptr (Equiv.swap a b) (KeygenRngSource.bytes a) = KeygenRngSource.bytes b := by
  simp only [ptr, KeygenRngSource.bytes, Equiv.swap_apply_left]

end FT1536.Source3.RngTemporarySwap090
