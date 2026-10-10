import Source3.KeygenCallerEntry
import Source3.KeygenPublicExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Automatic objects of the enclosing make invocation. Freshness is checked
   at EACH allocation, not replaced by assumed pairwise separation. No
   coefficient or pointer-array contents are initialized by a declaration. -/
namespace FT1536.Source3.KeygenMakeObjects
open C99ArrayReference (State Name bindPointer)
open C99MemoryReference

def name : Fin 6 → Name
  | 0 => "f".toList | 1 => "g".toList | 2 => "F".toList
  | 3 => "G".toList | 4 => "h".toList | 5 => "ske".toList
def count (slot : Fin 6) : Nat := if slot.val=5 then 4 else 3072
def width (slot : Fin 6) : Nat := if slot.val=5 then 8 else 2
def extent (slot : Fin 6) : Nat := width slot*count slot
def pointer (blocks : Fin 6 → Nat) (slot : Fin 6) : ArrayPointer :=
  ⟨blocks slot,0,count slot,width slot,0⟩
def allocated (heap : Memory) (block bytes : Nat) : Memory :=
  {bytes := fun b o => if b=block then none else heap.bytes b o
   size := fun b => if b=block then bytes else heap.size b
   writable := fun b => if b=block then true else heap.writable b}
def enter (s : State) (blocks : Fin 6 → Nat) (slot : Fin 6) : State :=
  bindPointer {s with heap := allocated s.heap (blocks slot) (extent slot)}
    (name slot) (pointer blocks slot)
def Block (before after : Memory) (block : Nat) : Prop :=
  after.size block=before.size block ∧ after.writable block=before.writable block ∧
    ∀ offset, after.bytes block offset=before.bytes block offset

theorem declarations_source : (Pinned.keygenLines.drop 7806).take 7 = [
    "\tint16_t f[3072], g[3072], F[3072], G[3072];\n",
    "\tuint16_t h[3072];\n", "\tsize_t klen, skoff;\n",
    "\tunsigned char *skbuf;\n", "\tint16_t *ske[4];\n",
    "\tint i;\n", "\tuint64_t local_attempts;\n"] := by decide
theorem name_injective : Function.Injective name := by
  intro a b h
  fin_cases a <;> fin_cases b <;> first | rfl | cases h
theorem sizes (slot : Fin 6) : 0<width slot ∧ 0<count slot ∧ 0<extent slot ∧ extent slot<2^64 := by
  fin_cases slot <;> decide

inductive Exec : Nat → State → (Fin 6 → Nat) → State → Prop where
  | done (s : State) (blocks : Fin 6 → Nat) : Exec 6 s blocks s
  | next (i : Nat) (hi : i<6) (s after : State) (blocks : Fin 6 → Nat)
      (fresh : KeygenRngSource.Fresh s.heap (blocks ⟨i,hi⟩))
      (rest : Exec (i+1) (enter s blocks ⟨i,hi⟩) blocks after) : Exec i s blocks after

theorem block_trans (a b c : Memory) (block : Nat) (first : Block a b block) (second : Block b c block) :
    Block a c block := ⟨second.1.trans first.1,second.2.1.trans first.2.1,
      fun offset => (second.2.2 offset).trans (first.2.2 offset)⟩
theorem enter_other (s : State) (blocks : Fin 6 → Nat) (slot : Fin 6) (block : Nat)
    (outside : block≠blocks slot) : Block s.heap (enter s blocks slot).heap block := by
  exact ⟨by simp [enter,allocated,bindPointer,outside],
    by simp [enter,allocated,bindPointer,outside],
    fun _ => by simp [enter,allocated,bindPointer,outside]⟩
theorem live_frame (i : Nat) (before after : State) (blocks : Fin 6 → Nat)
    (source : Exec i before blocks after) (block : Nat) (live : 0<before.heap.size block) :
    Block before.heap after.heap block := by
  induction source with
  | done => exact ⟨rfl,rfl,fun _ => rfl⟩
  | next i hi s after blocks fresh rest ih =>
    have outside : block≠blocks ⟨i,hi⟩ := by intro equal; rw [equal,fresh.1] at live; omega
    have one := enter_other s blocks ⟨i,hi⟩ block outside
    exact block_trans _ _ _ block one (ih (by rw [one.1]; exact live))
theorem slots (i : Nat) (before after : State) (blocks : Fin 6 → Nat)
    (source : Exec i before blocks after) : after.locals=before.locals ∧ after.tables=before.tables := by
  induction source with
  | done => exact ⟨rfl,rfl⟩
  | next i hi s after blocks fresh rest ih => exact ih
theorem outside_name (i : Nat) (before after : State) (blocks : Fin 6 → Nat)
    (source : Exec i before blocks after) (n : Name)
    (outside : ∀ slot : Fin 6, i≤slot.val → n≠name slot) : after.arrays n=before.arrays n := by
  induction source with
  | done => rfl
  | next i hi s after blocks fresh rest ih =>
    rw [ih (fun slot bound => outside slot (by omega))]
    have different := outside ⟨i,hi⟩ (Nat.le_refl i)
    simp only [enter,bindPointer,different,ite_false]
theorem object (i : Nat) (before after : State) (blocks : Fin 6 → Nat)
    (source : Exec i before blocks after) (slot : Fin 6) (bound : i≤slot.val) :
    after.arrays (name slot)=some (pointer blocks slot) ∧
    after.heap.size (blocks slot)=extent slot ∧ after.heap.writable (blocks slot)=true ∧
    ∀ offset, after.heap.bytes (blocks slot) offset=none := by
  induction source with
  | done s blocks => have := slot.isLt; omega
  | next i hi s after blocks fresh rest ih =>
    by_cases equal : slot.val=i
    · have same : slot=⟨i,hi⟩ := Fin.ext equal
      subst slot
      have keep := live_frame (i+1) (enter s blocks ⟨i,hi⟩) after blocks rest (blocks ⟨i,hi⟩)
        (by simpa [enter,allocated,bindPointer] using (sizes ⟨i,hi⟩).2.2.1)
      have ptr := outside_name (i+1) (enter s blocks ⟨i,hi⟩) after blocks rest (name ⟨i,hi⟩)
        (fun other later h => by have he := name_injective h; have := congrArg Fin.val he; omega)
      refine ⟨?_,?_,?_,?_⟩
      · simpa [enter,bindPointer] using ptr
      · simpa [enter,allocated,bindPointer] using keep.1
      · simpa [enter,allocated,bindPointer] using keep.2.1
      · intro offset; simpa [enter,allocated,bindPointer] using keep.2.2 offset
    · exact ih (by omega)
theorem allocated_object (before after : State) (blocks : Fin 6 → Nat)
    (source : Exec 0 before blocks after) (slot : Fin 6) : Allocated after.heap (pointer blocks slot) := by
  have h := (object 0 before after blocks source slot (by omega)).2.1
  simp only [Allocated,pointer,h]
  exact ⟨(sizes slot).1,by simp,(sizes slot).2.1,by simp [extent],(sizes slot).2.2.2⟩
theorem fresh_separate (i : Nat) (before after : State) (blocks : Fin 6 → Nat)
    (source : Exec i before blocks after) (slot : Fin 6) (bound : i≤slot.val)
    (block : Nat) (live : 0<before.heap.size block) : block≠blocks slot := by
  induction source with
  | done => have := slot.isLt; omega
  | next i hi s after blocks fresh rest ih =>
    have different : block≠blocks ⟨i,hi⟩ := by intro equal; rw [equal,fresh.1] at live; omega
    by_cases equal : slot.val=i
    · have same : slot=⟨i,hi⟩ := Fin.ext equal; rw [same]; exact different
    · exact ih (by omega) (by rw [(enter_other s blocks ⟨i,hi⟩ block different).1]; exact live)
theorem distinct (i : Nat) (before after : State) (blocks : Fin 6 → Nat)
    (source : Exec i before blocks after) : ∀ a b : Fin 6, i≤a.val → i≤b.val → a≠b → blocks a≠blocks b := by
  induction source with
  | done => intro a b ha; have := a.isLt; omega
  | next i hi s after blocks fresh rest ih =>
    intro a b ha hb different
    by_cases ea : a.val=i
    · have same : a=⟨i,hi⟩ := Fin.ext ea
      have later : i+1≤b.val := by have ne : b.val≠a.val := fun h => different (Fin.ext h.symm); omega
      rw [same]
      exact fresh_separate (i+1) _ after blocks rest b later (blocks ⟨i,hi⟩)
        (by simpa [enter,allocated,bindPointer] using (sizes ⟨i,hi⟩).2.2.1)
    · by_cases eb : b.val=i
      · have same : b=⟨i,hi⟩ := Fin.ext eb
        rw [same]
        exact Ne.symm (fresh_separate (i+1) _ after blocks rest a (by omega) (blocks ⟨i,hi⟩)
          (by simpa [enter,allocated,bindPointer] using (sizes ⟨i,hi⟩).2.2.1))
      · exact ih a b (by omega) (by omega) different

def dispose (before after : Memory) (blocks : Fin 6 → Nat) : Memory :=
  {bytes := fun b o => if ∃ slot, blocks slot=b then before.bytes b o else after.bytes b o
   size := fun b => if ∃ slot, blocks slot=b then before.size b else after.size b
   writable := fun b => if ∃ slot, blocks slot=b then before.writable b else after.writable b}
theorem dispose_object (before after : Memory) (blocks : Fin 6 → Nat) (slot : Fin 6) :
    Block before (dispose before after blocks) (blocks slot) := by
  have member : ∃ other, blocks other=blocks slot := ⟨slot,rfl⟩
  exact ⟨by simp [dispose,member],by simp [dispose,member],fun _ => by simp [dispose,member]⟩
theorem dispose_other (before after : Memory) (blocks : Fin 6 → Nat) (block : Nat)
    (outside : ∀ slot, blocks slot≠block) : Block after (dispose before after blocks) block := by
  have absent : ¬∃ slot, blocks slot=block := by rintro ⟨slot,equal⟩; exact outside slot equal
  exact ⟨by simp [dispose,absent],by simp [dispose,absent],fun _ => by simp [dispose,absent]⟩

end FT1536.Source3.KeygenMakeObjects
