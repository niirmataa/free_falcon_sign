import Source3.C99ArrayReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- A syntax-checked write footprint for array bodies. Pointer rebinding,
   memcpy and statement calls require separate contracts and are rejected by
   this checker. Pure FPEMU expression calls execute their fixed source closure. -/
namespace FT1536.Source3.C99ArrayFrame
open C99ArrayReference C99MemoryReference

def only (names : List Name) : Stmt → Bool
  | .skip | .scalar _ | .assign _ _ => true
  | .store64 name _ _ | .store32 name _ _ => names.contains name
  | .seq a b | .branch _ a b => only names a && only names b
  | .scope _ _ b | .while _ b => only names b
  | .bindPtr _ _ _ | .copy _ _ _ _ _ | .call _ _ => false

def Outside (s : State) (names : List Name) (block offset : Nat) : Prop :=
  ∀ name∈names, ∀ p, s.arrays name=some p →
    block≠p.block ∨ offset<p.offset ∨ p.base+p.elementBytes*p.count≤offset

theorem pointer_store_frame (s : State) (names : List Name) (name : Name)
    (index : CLogic.Expr) (p : ArrayPointer) (width : Nat)
    (address : Pointer s name index p) (member : name∈names)
    (allocated : Allocated s.heap p) (size : p.elementBytes=width)
    (block offset : Nat) (outside : Outside s names block offset) :
    block≠p.block ∨ offset<p.offset ∨ p.offset+width≤offset := by
  cases address with
  | add root _ value binding evaluated nonnegative within =>
    cases within
    have ho := outside name member root binding
    have hi := allocated.2.2.1
    change root.index+value.integer.toNat < root.count at hi
    have hlo : root.elementBytes*root.index≤root.elementBytes*(root.index+value.integer.toNat) :=
      Nat.mul_le_mul_left root.elementBytes (by omega)
    have hhi : root.elementBytes*(root.index+value.integer.toNat+1)≤root.elementBytes*root.count :=
      Nat.mul_le_mul_left root.elementBytes (by omega)
    dsimp [ArrayPointer.offset] at *
    rw [Nat.mul_add,Nat.mul_one] at hhi
    omega

theorem body_frame (program : Program) (code : Stmt) (before after : State)
    (h : Exec program code before after) (names : List Name) (checked : only names code=true) :
    after.arrays=before.arrays ∧
    ∀ block offset, Outside before names block offset →
      after.heap.bytes block offset=before.heap.bytes block offset := by
  induction h with
  | skip | scalar | assign | whileFalse => exact ⟨rfl,fun _ _ _ => rfl⟩
  | bindPtr => simp [only] at checked
  | call => simp [only] at checked
  | copy => simp [only] at checked
  | store64 before after array index e p v address value write =>
    have member : array∈names := List.contains_iff_mem.mp checked
    refine ⟨rfl,fun block offset outside => ?_⟩
    exact write.2.2.2.2.2.2 block offset
      (pointer_store_frame before names array index p 8 address member write.1 write.2.1 block offset outside)
  | store32 before after array index e p v address value write =>
    have member : array∈names := List.contains_iff_mem.mp checked
    refine ⟨rfl,fun block offset outside => ?_⟩
    exact write.2.2.2.2.2.2 block offset
      (pointer_store_frame before names array index p 4 address member write.1 write.2.1 block offset outside)
  | seq a b before middle after first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨aa,fa⟩ := ih1 ha
    obtain ⟨ab,fb⟩ := ih2 hb
    refine ⟨ab.trans aa,fun block offset outside => ?_⟩
    have hm : Outside middle names block offset := by simpa only [Outside,aa] using outside
    exact (fb block offset hm).trans (fa block offset outside)
  | scope locals pointers body before after inner ih =>
    obtain ⟨ha,hf⟩ := ih checked
    refine ⟨?_,hf⟩
    funext n
    simp [restoreScope,ha]
  | branchTrue condition yes no before after v guard nonzero body ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse condition yes no before after v guard zero body ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).2
  | whileTrue condition body before middle after v guard nonzero step rest ih1 ih2 =>
    obtain ⟨aa,fa⟩ := ih1 checked
    obtain ⟨ab,fb⟩ := ih2 checked
    refine ⟨ab.trans aa,fun block offset outside => ?_⟩
    have hm : Outside middle names block offset := by simpa only [Outside,aa] using outside
    exact (fb block offset hm).trans (fa block offset outside)

end FT1536.Source3.C99ArrayFrame
