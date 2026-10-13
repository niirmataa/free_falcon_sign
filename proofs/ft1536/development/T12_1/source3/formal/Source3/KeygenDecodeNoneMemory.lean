import Source3.KeygenDecodeNoneCoefficientExists

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Real ordered int16 writes and decoded-array readback, independent of
   initial destination contents. Input-byte preservation uses block separation. -/
namespace FT1536.Source3.KeygenDecodeNoneMemory
open KeygenDecodeValues KeygenDecodeExecution C99MemoryReference KeygenDecodeNoneScalar

def element (ptr : ArrayPointer) (i : Nat) : ArrayPointer := {ptr with index := ptr.index+i}

def WritableArray (heap : Memory) (ptr : ArrayPointer) (count : Nat) : Prop :=
  ptr.elementBytes=2 ∧ heap.writable ptr.block=true ∧ ∀ i<count, Allocated heap (element ptr i)

def Images (heap : Memory) (src : ArrayPointer) (inputs : List (BitVec 16)) : Prop :=
  ∀ i : Fin inputs.length, ∃ hiPtr loPtr,
    PointerAdd src (2*i.val) hiPtr ∧ PointerAdd src (2*i.val+1) loPtr ∧
    LoadByte heap hiPtr (high inputs[i]) ∧ LoadByte heap loPtr (low inputs[i])

inductive Trace (dst : ArrayPointer) : Memory → Memory → Nat → List (BitVec 16) → Prop where
  | nil (heap : Memory) (n : Nat) : Trace dst heap heap n []
  | cons (a b c : Memory) (n : Nat) (input : BitVec 16) (rest : List (BitVec 16))
      (store : Store16 a (element dst n) input b) (tail : Trace dst b c (n+1) rest) :
      Trace dst a c n (input::rest)

theorem advance (heap : Memory) (ptr : ArrayPointer) (count i : Nat)
    (legal : WritableArray heap ptr count) (bound : i<count) : PointerAdd ptr i (element ptr i) := by
  have inside : ptr.index+i<ptr.count := (legal.2.2 i bound).2.2.1
  exact .within ptr i (by omega)

theorem legal_preserved (a b : Memory) (ptr atWord : ArrayPointer) (count : Nat) (input : BitVec 16)
    (legal : WritableArray a ptr count) (store : Store16 a atWord input b) : WritableArray b ptr count :=
  ⟨legal.1,by rw [store.2.2.2.2.1]; exact legal.2.1,
    fun i bound => by simpa only [Allocated,store.2.2.2.1] using legal.2.2 i bound⟩

theorem images_preserved (a b : Memory) (src atWord : ArrayPointer) (input : BitVec 16)
    (inputs : List (BitVec 16)) (images : Images a src inputs)
    (store : Store16 a atWord input b) (separate : src.block≠atWord.block) : Images b src inputs := by
  intro i
  obtain ⟨hiPtr,loPtr,hiStep,loStep,hiLoad,loLoad⟩ := images i
  have hiBlock : hiPtr.block=src.block := by cases hiStep; rfl
  have loBlock : loPtr.block=src.block := by cases loStep; rfl
  exact ⟨hiPtr,loPtr,hiStep,loStep,
    KeygenDecodeWrite16.byte_preserved a b atWord hiPtr input _ store (by rw [hiBlock]; exact separate) hiLoad,
    KeygenDecodeWrite16.byte_preserved a b atWord loPtr input _ store (by rw [loBlock]; exact separate) loLoad⟩

theorem trace_sizes (dst : ArrayPointer) (a b : Memory) (n : Nat) (inputs : List (BitVec 16))
    (trace : Trace dst a b n inputs) : b.size=a.size := by
  induction trace with
  | nil => rfl
  | cons a b c n input rest store tail ih => exact ih.trans store.2.2.2.1

theorem load_later_store (dst : ArrayPointer) (a b : Memory) (m n : Nat)
    (earlier : m<n) (width : dst.elementBytes=2) (input original : BitVec 16)
    (store : Store16 a (element dst n) input b) (load : Load16 a (element dst m) original) :
    Load16 b (element dst m) original := by
  cases load with
  | load lo hi allocated typeWidth low high =>
    have left : (element dst m).offset<(element dst n).offset := by
      simp only [element,ArrayPointer.offset,width]; omega
    have right : (element dst m).offset+1<(element dst n).offset := by
      simp only [element,ArrayPointer.offset,width]; omega
    exact .load b (element dst m) lo hi
      (by simpa only [Allocated,store.2.2.2.1] using allocated) typeWidth
      ((store.2.2.2.2.2.2.2 _ _ (Or.inr (Or.inl left))).trans low)
      ((store.2.2.2.2.2.2.2 _ _ (Or.inr (Or.inl right))).trans high)

theorem load_later_trace (dst : ArrayPointer) (a b : Memory) (m n : Nat) (inputs : List (BitVec 16))
    (earlier : m<n) (width : dst.elementBytes=2) (original : BitVec 16)
    (trace : Trace dst a b n inputs) (load : Load16 a (element dst m) original) :
    Load16 b (element dst m) original := by
  induction trace with
  | nil => exact load
  | cons a b c n input rest store tail ih =>
    exact ih (by omega) (load_later_store dst a b m n earlier width input original store load)

/-- All decoded words are readable in the final physical array, even after
    all later stores. No initial output-word agreement is required. -/
theorem trace_readback (dst : ArrayPointer) (a b : Memory) (n : Nat) (inputs : List (BitVec 16))
    (width : dst.elementBytes=2) (trace : Trace dst a b n inputs) :
    ∀ i : Fin inputs.length, Load16 b (element dst (n+i.val)) inputs[i] := by
  induction trace with
  | nil heap n => intro i; exact Fin.elim0 i
  | cons a middle b n input rest store tail ih =>
    intro i
    refine Fin.cases ?_ (fun j => ?_) i
    · change Load16 b (element dst n) input
      exact load_later_trace dst middle b n (n+1) rest (by omega) width input tail
        (KeygenDecodeMemory.store_readback _ input a middle store)
    · change Load16 b (element dst (n+(j.val+1))) rest[j]
      simpa only [show n+1+j.val=n+(j.val+1) by omega] using ih j

end FT1536.Source3.KeygenDecodeNoneMemory
