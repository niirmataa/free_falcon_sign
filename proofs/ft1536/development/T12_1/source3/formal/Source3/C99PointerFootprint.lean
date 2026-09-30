import Source3.C99ArrayFrame

/- Write capabilities follow source pointer assignments and memcpy extents.
   The checker rejects statement calls; the procedure layer handles them by
   induction on executed callee bodies. No numerical FFT property is used. -/
namespace FT1536.Source3.C99PointerFootprint
open C99ArrayReference C99MemoryReference C99ArrayFrame

def only (names : List Name) : Stmt → Bool
  | .skip | .scalar _ | .assign _ _ | .declarePtr _ => true
  | .bindPtr _ source _ => names.contains source
  | .store64 name _ _ | .store32 name _ _ | .copy name _ _ _ _ => names.contains name
  | .seq a b | .branch _ a b => only names a && only names b
  | .scope _ _ b | .while _ b => only names b
  | .call _ _ => false

def PointOutside (p : ArrayPointer) (block offset : Nat) : Prop :=
  block≠p.block ∨ offset<p.offset ∨ p.base+p.elementBytes*p.count≤offset

def TablesOutside (s : State) (block offset : Nat) : Prop :=
  ∀ name p, s.tables name=some p → PointOutside p block offset

theorem pointer_outside (s : State) (names : List Name) (name : Name)
    (index : CLogic.Expr) (p : ArrayPointer) (address : Pointer s name index p)
    (member : name∈names) (block offset : Nat) (outside : Outside s names block offset) :
    PointOutside p block offset := by
  cases address with
  | add root _ value binding evaluated nonnegative within =>
      cases within
      have ho := outside name member root binding
      have hlo := Nat.mul_le_mul_left root.elementBytes (Nat.le_add_right root.index value.integer.toNat)
      dsimp [PointOutside,ArrayPointer.offset] at *
      omega

theorem copy_frame (s : State) (names : List Name) (name : Name)
    (index : CLogic.Expr) (p : ArrayPointer) (count : Nat)
    (address : Pointer s name index p) (member : name∈names)
    (extent : p.offset+count≤p.base+p.elementBytes*p.count)
    (block offset : Nat) (outside : Outside s names block offset) :
    block≠p.block ∨ offset<p.offset ∨ p.offset+count≤offset := by
  have ho := pointer_outside s names name index p address member block offset outside
  dsimp [PointOutside] at ho
  omega

theorem restore_outside (before after : State) (locals pointers names : List Name)
    (block offset : Nat) (hb : Outside before names block offset) (ha : Outside after names block offset) :
    Outside (restoreScope before after locals pointers) names block offset := by
  intro name hn p hp
  dsimp [restoreScope] at hp
  split at hp
  · exact hb name hn p hp
  · exact ha name hn p hp

theorem body_frame (program : Program) (code : Stmt) (before after : State)
    (h : Exec program code before after) (names : List Name) (checked : only names code=true)
    (block offset : Nat) (outside : Outside before names block offset) :
    Outside after names block offset ∧ after.tables=before.tables ∧
      after.heap.bytes block offset=before.heap.bytes block offset := by
  induction h with
  | skip | scalar | assign | whileFalse => exact ⟨outside,rfl,rfl⟩
  | declarePtr before name =>
      refine ⟨?_,rfl,rfl⟩
      intro n hn p hp
      by_cases he : n=name
      · simp [he] at hp
      · exact outside n hn p (by simpa [he] using hp)
  | bindPtr before name source index p address =>
      have ho := pointer_outside before names source index p address
        (List.contains_iff_mem.mp checked) block offset outside
      refine ⟨?_,rfl,rfl⟩
      intro n hn q hq
      by_cases he : n=name
      · have hqp : p=q := Option.some.inj (by simpa [bindPointer,he] using hq)
        simpa only [PointOutside,← hqp] using ho
      · exact outside n hn q (by simpa [bindPointer,he] using hq)
  | store64 before after array index e p v address value write =>
      exact ⟨outside,rfl,write.2.2.2.2.2.2 block offset
        (pointer_store_frame before names array index p 8 address
          (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)⟩
  | store32 before after array index e p v address value write =>
      exact ⟨outside,rfl,write.2.2.2.2.2.2 block offset
        (pointer_store_frame before names array index p 4 address
          (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)⟩
  | copy before after dst src di si count p q n destination source length destinationObject sourceObject copy =>
      obtain ⟨_,_,_,_,_,_,_,_,_,_,hf⟩ := copy
      exact ⟨outside,rfl,hf block offset (copy_frame before names dst di p n.toNat destination
        (List.contains_iff_mem.mp checked) destinationObject block offset outside)⟩
  | seq a b before middle after first second ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
      obtain ⟨oa,ta,fa⟩ := ih1 ha outside
      obtain ⟨ob,tb,fb⟩ := ih2 hb oa
      exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | scope locals pointers body before after inner ih =>
      obtain ⟨ho,ht,hf⟩ := ih checked outside
      exact ⟨restore_outside before after locals pointers names block offset outside ho,ht,hf⟩
  | branchTrue condition yes no before after v guard nonzero body ih =>
      exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | branchFalse condition yes no before after v guard zero body ih =>
      exact ih (Bool.and_eq_true_iff.mp checked).2 outside
  | whileTrue condition body before middle after v guard nonzero step rest ih1 ih2 =>
      obtain ⟨oa,ta,fa⟩ := ih1 checked outside
      obtain ⟨ob,tb,fb⟩ := ih2 checked oa
      exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | call => simp [only] at checked

def arguments (caller callee : List Name) : List Param → List Arg → Bool
  | [],[] => true
  | .scalar _ _::ps,.scalar _::args => arguments caller callee ps args
  | .pointer name::ps,.pointer source _::args =>
      (!(callee.contains name) || caller.contains source) && arguments caller callee ps args
  | _,_ => false

theorem bind_outside (caller : State) (ps : List Param) (args : List Arg) (entry : State)
    (h : Bind caller ps args entry) (callerNames calleeNames : List Name)
    (checked : arguments callerNames calleeNames ps args=true) (block offset : Nat)
    (outside : Outside caller callerNames block offset) (tables : TablesOutside caller block offset) :
    Outside entry calleeNames block offset ∧ entry.tables=caller.tables := by
  induction h with
  | nil => exact ⟨fun n _ p hp => tables n p hp,rfl⟩
  | scalar ty name e ps args out v value rest ih => exact ih checked
  | pointer name source index p ps args out value rest ih =>
      obtain ⟨hc,hr⟩ := Bool.and_eq_true_iff.mp checked
      obtain ⟨ho,ht⟩ := ih hr
      refine ⟨?_,ht⟩
      intro n hn q hq
      by_cases he : n=name
      · subst n
        have hm : calleeNames.contains name=true := List.contains_iff_mem.mpr hn
        have hs : source∈callerNames := List.contains_iff_mem.mp (by rw [hm] at hc; exact hc)
        have hqp : p=q := Option.some.inj (by simpa [bindPointer] using hq)
        subst q
        exact pointer_outside caller callerNames source index p value hs block offset outside
      · exact ho n hn q (by simpa [bindPointer,he] using hq)

end FT1536.Source3.C99PointerFootprint
