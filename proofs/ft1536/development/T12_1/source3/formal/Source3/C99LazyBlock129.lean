import Source3.CompactBlockIdentity129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99LazyBlock129
open C99FiniteMap114 (Tree lookup digits)
open C99FiniteMemory114 (Block Heap memory)
open C99CompactState115 (State reference)

def root : C99FiniteMap114.Tree α → Option α
  | .empty => none | .node value _ _ => value

def left : C99FiniteMap114.Tree α → C99FiniteMap114.Tree α
  | .empty => .empty | .node _ zero _ => zero

def right : C99FiniteMap114.Tree α → C99FiniteMap114.Tree α
  | .empty => .empty | .node _ _ one => one

/-- The updated path is constructed without inspecting untouched branches. -/
def update (tree : C99FiniteMap114.Tree α) : List Bool → α → C99FiniteMap114.Tree α
  | [], value => .node (some value) (left tree) (right tree)
  | bit::rest, value =>
      if bit then .node (root tree) (left tree) (update (right tree) rest value)
      else .node (root tree) (update (left tree) rest value) (right tree)

theorem get_update (tree : C99FiniteMap114.Tree α) (key other : List Bool) (value : α) :
    C99FiniteMap114.get (update tree key value) other=if other=key then some value else C99FiniteMap114.get tree other := by
  induction key generalizing tree other with
  | nil => cases tree <;> cases other <;> simp [update,C99FiniteMap114.get,left,right]
  | cons bit rest ih =>
      cases tree <;> cases other with
      | nil => cases bit <;> simp [update,C99FiniteMap114.get,root,left,right]
      | cons next tail => cases bit <;> cases next <;> simp [update,C99FiniteMap114.get,root,left,right,ih]

def putBlock (heap : Heap) (block : Nat) (data : Block) : Heap :=
  ⟨update heap.blocks (digits block) data⟩

theorem lookup_put (heap : Heap) (block other : Nat) (data : Block) :
    lookup (putBlock heap block data).blocks other=if other=block then some data else lookup heap.blocks other := by
  rw [lookup,putBlock,get_update]
  simp only [C99FiniteMap114.digits_injective.eq_iff]
  rfl

theorem memory_equal (heap : Heap) (block : Nat) (data : Block) :
    memory (putBlock heap block data)=memory (C99FiniteMemory114.putBlock heap block data) := by
  apply C99FiniteAllocation115.memory_ext
  · intro other offset
    simp only [memory,lookup_put,C99FiniteMemory114.putBlock,C99FiniteMap114.lookup_insert]
  · intro other
    simp only [memory,lookup_put,C99FiniteMemory114.putBlock,C99FiniteMap114.lookup_insert]
  · intro other
    simp only [memory,lookup_put,C99FiniteMemory114.putBlock,C99FiniteMap114.lookup_insert]

def normalized (state : State) (block : Nat) (data : Block) : State :=
  {state with heap := putBlock state.heap block data}

theorem reference_same (state : State) (block : Nat) (data : Block)
    (found : lookup state.heap.blocks block=some data) :
    reference (normalized state block data)=reference state := by
  unfold normalized reference
  rw [memory_equal,CompactBlockIdentity129.memory_same state.heap block data found]

def pair (state : State) (first second : Nat) (a b : Block) : State :=
  normalized (normalized state first a) second b

theorem pair_same (state : State) (first second : Nat) (a b : Block)
    (different : first≠second)
    (foundA : lookup state.heap.blocks first=some a)
    (foundB : lookup state.heap.blocks second=some b) :
    reference (pair state first second a b)=reference state := by
  have stillB : lookup (normalized state first a).heap.blocks second=some b := by
    change lookup (putBlock state.heap first a).blocks second=some b
    rw [lookup_put,ite_eq_right (Ne.symm different)]
    exact foundB
  exact (reference_same (normalized state first a) second b stillB).trans (reference_same state first a foundA)

end FT1536.Source3.C99LazyBlock129
