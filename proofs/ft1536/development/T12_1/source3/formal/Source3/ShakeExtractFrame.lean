import Source3.ShakeExtractBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.ShakeExtractFrame
open C99MemoryReference
open C99ArrayReference (State Name)
open ShakeExtractSource

def PointersOutside (s : State) (block : Nat) : Prop :=
  ∀ name p, s.arrays name=some p → p.block≠block
def SameBlock (before after : Memory) (block : Nat) : Prop :=
  after.size=before.size ∧ after.writable=before.writable ∧
    ∀ offset, after.bytes block offset=before.bytes block offset

theorem same_trans (a b c : Memory) (block : Nat) (first : SameBlock a b block) (second : SameBlock b c block) :
    SameBlock a c block := ⟨second.1.trans first.1,second.2.1.trans first.2.1,
      fun offset => (second.2.2 offset).trans (first.2.2 offset)⟩

theorem address_outside (s : State) (block : Nat) (name : Name) (index : CLogic.Expr) (p : ArrayPointer)
    (pointers : PointersOutside s block) (source : C99ArrayReference.Pointer s name index p) : p.block≠block := by
  cases source with
  | add root p i binding value nonnegative address =>
      cases address
      exact pointers name root binding

theorem bind_outside (s : State) (block : Nat) (name : Name) (p : ArrayPointer)
    (pointers : PointersOutside s block) (outside : p.block≠block) :
    PointersOutside (C99ArrayReference.bindPointer s name p) block := by
  intro n q h
  by_cases equal : n=name
  · have he : q=p := Option.some.inj (h.symm.trans (by simp [C99ArrayReference.bindPointer,equal]))
    subst q
    exact outside
  · exact pointers n q (by simpa [C99ArrayReference.bindPointer,equal] using h)

theorem source_frame (ctx : Layout) (statement : Stmt) (before after : State) (block : Nat)
    (contextOutside : ctx.block≠block) (source : Exec ctx statement before after)
    (pointers : PointersOutside before block) :
    PointersOutside after block ∧ SameBlock before.heap after.heap block := by
  induction source with
  | scalar | fieldRead | skip | loopFalse => exact ⟨pointers,rfl,rfl,fun _ => rfl⟩
  | declarePointer name s =>
      refine ⟨?_,rfl,rfl,fun _ => rfl⟩
      intro n p h
      by_cases equal : n=name
      · simp [equal] at h
      · exact pointers n p (by simpa [equal] using h)
  | pointer dst src index s p address =>
      exact ⟨bind_outside s block dst p pointers (address_outside s block src index p pointers address),
        rfl,rfl,fun _ => rfl⟩
  | fieldPointer dst member s =>
      refine ⟨bind_outside s block dst (field ctx member) pointers ?_,rfl,rfl,fun _ => rfl⟩
      cases member <;> exact contextOutside
  | fieldStore member value s heap v evaluated write =>
      refine ⟨pointers,write.2.2.2.1,write.2.2.2.2.1,?_⟩
      intro offset
      apply write.2.2.2.2.2.2 block offset
      exact Or.inl (by cases member <;> exact Ne.symm contextOutside)
  | process src before after p address call =>
      have outside := address_outside before block src zero p pointers address
      have keep := process_frame before after p call
      have hp := process_pointers before after p call
      exact ⟨fun name q binding => pointers name q ((congrFun hp name).symm.trans binding),
        keep.1,keep.2.1,fun offset => keep.2.2 block offset (Ne.symm outside)⟩
  | encode dst index value before after p v address evaluated call =>
      have outside := address_outside before block dst index p pointers address
      have keep := ShakeEncode.invoke_frame before after p v call
      have hp := ShakeEncode.invoke_pointers before after p v call
      exact ⟨fun name q binding => pointers name q ((congrFun hp name).symm.trans binding),
        keep.1,keep.2.1,fun offset => keep.2.2 block offset (Ne.symm outside)⟩
  | copy dst index count s heap p q i n destination offset length source destinationObject sourceObject copy =>
      have outside := address_outside s block dst zero p pointers destination
      exact ⟨pointers,copy.2.2.2.2.2.2.2.1,copy.2.2.2.2.2.2.2.2.1,
        fun offset => copy.2.2.2.2.2.2.2.2.2.2 block offset (Or.inl (Ne.symm outside))⟩
  | seq first second before middle after head tail ih1 ih2 =>
      have one := ih1 pointers
      have two := ih2 one.1
      exact ⟨two.1,same_trans _ _ _ block one.2 two.2⟩
  | scope locals ptrs body before after inner ih =>
      have keep := ih pointers
      refine ⟨?_,keep.2⟩
      intro name p binding
      by_cases saved : ptrs.contains name=true
      · exact pointers name p (by simpa only [C99ArrayReference.restoreScope,saved,ite_true] using binding)
      · exact keep.1 name p (by simpa only [C99ArrayReference.restoreScope,saved,Bool.false_eq_true,ite_false] using binding)
  | branchTrue _ _ _ _ _ _ _ _ _ ih | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih pointers
  | loopNext condition body before middle after v guard nonzero iteration rest ih1 ih2 =>
      have one := ih1 pointers
      have two := ih2 one.1
      exact ⟨two.1,same_trans _ _ _ block one.2 two.2⟩

def entry (before : State) (out : ArrayPointer) (len : C99IntegerReference.Value) : State :=
  { before with
    locals := C99ScalarReference.set (fun _ => none) "len".toList
      (.uint64,some (C99IntegerReference.convert .uint64 len.integer))
    arrays := fun name => if name="out".toList then some out else none }

inductive Call (ctx : Layout) (before : State) (out : ArrayPointer) (len : C99IntegerReference.Value) : State → Prop where
  | run (after : State) (body : Exec ctx code (entry before out len) after) :
      Call ctx before out len {before with heap := after.heap}

theorem call_frame (ctx : Layout) (before after : State) (out : ArrayPointer) (len : C99IntegerReference.Value)
    (block : Nat) (contextOutside : ctx.block≠block) (outputOutside : out.block≠block)
    (source : Call ctx before out len after) : SameBlock before.heap after.heap block := by
  cases source with
  | run after body =>
      have hp : PointersOutside (entry before out len) block := by
        intro name p h
        by_cases equal : name="out".toList
        · have he : p=out := Option.some.inj (h.symm.trans (by simp [entry,equal]))
          subst p
          exact outputOutside
        · simp only [entry,equal,ite_false] at h
          cases h
      exact (source_frame ctx code (entry before out len) after block contextOutside body hp).2

end FT1536.Source3.ShakeExtractFrame
