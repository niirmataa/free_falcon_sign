import Source3.KeygenAttemptFft

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Pointwise subobject frame: unlike a whole-block frame this also protects
   the KeyGen fields adjacent to the embedded SHAKE context. -/
namespace FT1536.Source3.ShakePointFrame
open C99MemoryReference
open C99ArrayReference (State Name)
open ShakeBlock (Outside)
open ShakeExtractSource (Layout field)

def Pointers (s : State) (block offset : Nat) : Prop := ∀ name p, s.arrays name=some p → Outside p block offset
def Same (a b : Memory) (block offset : Nat) : Prop :=
  b.size=a.size ∧ b.writable=a.writable ∧ b.bytes block offset=a.bytes block offset
theorem trans (a b c : Memory) (block offset : Nat) (first : Same a b block offset) (second : Same b c block offset) :
    Same a c block offset := ⟨second.1.trans first.1,second.2.1.trans first.2.1,second.2.2.trans first.2.2⟩
theorem address (s : State) (name : Name) (index : CLogic.Expr) (p : ArrayPointer) (block offset : Nat)
    (pointers : Pointers s block offset) (source : C99ArrayReference.Pointer s name index p) : Outside p block offset := by
  cases source with
  | add root p i binding value nonnegative within => cases within; exact pointers name root binding
theorem bound (s : State) (name : Name) (p : ArrayPointer) (block offset : Nat)
    (pointers : Pointers s block offset) (outside : Outside p block offset) :
    Pointers (C99ArrayReference.bindPointer s name p) block offset := by
  intro n q h
  by_cases eq : n=name
  · have he : q=p := (Option.some.inj (by simpa only [C99ArrayReference.bindPointer,eq,ite_true] using h)).symm
    subst q; exact outside
  · exact pointers n q (by simpa only [C99ArrayReference.bindPointer,eq,ite_false] using h)
theorem store8 (before after : Memory) (p : ArrayPointer) (v : Byte) (block offset : Nat)
    (source : ShakeEncode.Store8 before p v after) (outside : Outside p block offset) : Same before after block offset := by
  refine ⟨source.2.2.2.1,source.2.2.2.2.1,source.2.2.2.2.2.2 block offset ?_⟩
  have width := source.2.1
  have allocated := source.1.2.2.1
  simp only [Outside,ArrayPointer.offset,width,Nat.one_mul] at outside ⊢
  omega
theorem store64 (before after : Memory) (p : ArrayPointer) (v : BitVec 64) (block offset : Nat)
    (source : Store64 before p v after) (outside : Outside p block offset) : Same before after block offset := by
  refine ⟨source.2.2.2.1,source.2.2.2.2.1,source.2.2.2.2.2.2 block offset ?_⟩
  have width := source.2.1
  have allocated := source.1.2.2.1
  simp only [Outside,ArrayPointer.offset,width] at outside ⊢
  omega
theorem encode (code : List ShakeEncode.Instruction) (before after : State) (p : ArrayPointer)
    (binding : before.arrays "buf".toList=some p) (source : ShakeEncode.Exec code before after)
    (block offset : Nat) (outside : Outside p block offset) : Same before.heap after.heap block offset := by
  induction source with
  | done => exact ⟨rfl,rfl,rfl⟩
  | next i tail before heap after actual v read value write rest ih =>
    cases read with
    | add root actual index bound value nonnegative within =>
      have he : root=p := Option.some.inj (bound.symm.trans binding)
      subst root
      cases within
      exact trans _ _ _ block offset (store8 _ _ _ _ block offset write outside) (ih binding)
theorem invoke (before after : State) (p : ArrayPointer) (v : C99IntegerReference.Value)
    (source : ShakeEncode.Invoke before p v after) (block offset : Nat) (outside : Outside p block offset) :
    Same before.heap after.heap block offset := by
  cases source with
  | run declared ready after declaration assignment body =>
    cases declaration
    cases assignment with
    | bindPtr _ _ _ _ actual assigned =>
      have hp := KeygenSolverNttCalls.pointer_zero _ "out" p actual (by rfl) assigned
      subst actual
      exact encode _ _ _ p (by simp [C99ArrayReference.bindPointer]) body block offset outside
theorem process (before after : State) (p : ArrayPointer) (source : ShakeExtractSource.Process before p after)
    (block offset : Nat) (outside : Outside p block offset) : Same before.heap after.heap block offset := by
  cases source with
  | run table after binding static body =>
    have keep := ShakeBlockProgram.source_frame _ after p (by simp [ShakeExtractSource.blockEntry]) body
    exact ⟨keep.1,keep.2.1,keep.2.2 block offset outside⟩
theorem source (ctx : Layout) (code : ShakeExtractSource.Stmt) (before after : State)
    (execution : ShakeExtractSource.Exec ctx code before after) (block offset : Nat)
    (fields : ∀ member, Outside (field ctx member) block offset) (pointers : Pointers before block offset) :
    Pointers after block offset ∧ Same before.heap after.heap block offset := by
  induction execution with
  | scalar | fieldRead | skip | loopFalse => exact ⟨pointers,rfl,rfl,rfl⟩
  | declarePointer name s =>
    refine ⟨?_,rfl,rfl,rfl⟩
    intro n p h
    by_cases eq : n=name
    · simp [eq] at h
    · exact pointers n p (by simpa [eq] using h)
  | pointer dst src index s p read => exact ⟨bound s dst p block offset pointers (address _ _ _ _ _ _ pointers read),rfl,rfl,rfl⟩
  | fieldPointer dst member s => exact ⟨bound s dst _ block offset pointers (fields member),rfl,rfl,rfl⟩
  | fieldStore member value s heap v evaluated write => exact ⟨pointers,store64 _ _ _ _ block offset write (fields member)⟩
  | process src before after p read call =>
    have keep := process before after p call block offset (address _ _ _ _ _ _ pointers read)
    have hp := ShakeExtractSource.process_pointers before after p call
    exact ⟨fun name q h => pointers name q ((congrFun hp name).symm.trans h),keep⟩
  | encode dst index value before after p v read evaluated call =>
    have keep := invoke before after p v call block offset (address _ _ _ _ _ _ pointers read)
    have hp := ShakeEncode.invoke_pointers before after p v call
    exact ⟨fun name q h => pointers name q ((congrFun hp name).symm.trans h),keep⟩
  | copy dst index count s heap p q i n destination read length source destinationObject sourceObject copy =>
    obtain ⟨_,_,_,_,_,_,_,hs,hw,_,hf⟩ := copy
    have outside := address _ _ _ _ _ _ pointers destination
    refine ⟨pointers,hs,hw,hf block offset ?_⟩
    dsimp [Outside,ArrayPointer.offset] at outside destinationObject ⊢
    omega
  | seq first second before middle after head tail ih1 ih2 =>
    have a := ih1 pointers
    have b := ih2 a.1
    exact ⟨b.1,trans _ _ _ block offset a.2 b.2⟩
  | scope locals ptrs body before after inner ih =>
    have keep := ih pointers
    refine ⟨?_,keep.2⟩
    intro name p h
    by_cases saved : ptrs.contains name=true
    · exact pointers name p (by simpa only [C99ArrayReference.restoreScope,saved,ite_true] using h)
    · exact keep.1 name p (by simpa only [C99ArrayReference.restoreScope,saved,Bool.false_eq_true,ite_false] using h)
  | branchTrue _ _ _ _ _ _ _ _ _ ih | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih pointers
  | loopNext condition body before middle after v guard nonzero iteration rest ih1 ih2 =>
    have a := ih1 pointers
    have b := ih2 a.1
    exact ⟨b.1,trans _ _ _ block offset a.2 b.2⟩
theorem call (ctx : Layout) (before after : State) (p : ArrayPointer) (v : C99IntegerReference.Value)
    (execution : ShakeExtractFrame.Call ctx before p v after) (block offset : Nat)
    (fields : ∀ member, Outside (field ctx member) block offset) (outside : Outside p block offset) :
    Same before.heap after.heap block offset := by
  cases execution with
  | run after body =>
    refine (source ctx _ _ after body block offset fields ?_).2
    intro name q h
    by_cases eq : name="out".toList
    · have he : q=p := (Option.some.inj (by simpa only [ShakeExtractFrame.entry,eq,ite_true] using h)).symm
      subst q; exact outside
    · simp only [ShakeExtractFrame.entry,eq,ite_false] at h; cases h
theorem rng (ctx : Layout) (before after : State) (w : BitVec 64) (execution : KeygenRngSource.Call ctx before after w)
    (block offset : Nat) (live : 0<before.heap.size block)
    (fields : ∀ member, Outside (field ctx member) block offset) : Same before.heap after.heap block offset := by
  cases execution with
  | run localBlock after w fresh extract read =>
    have different : block≠localBlock := by intro h; subst block; rw [fresh.1] at live; omega
    have keep := call ctx _ after (KeygenRngSource.bytes localBlock) (.uint64 8) extract block offset fields (Or.inl different)
    refine ⟨?_,?_,?_⟩
    · funext b
      by_cases equal : b=localBlock
      · simp only [KeygenRngSource.disposed,equal,ite_true]
      · simpa only [KeygenRngSource.disposed,KeygenRngSource.allocated,equal,ite_false] using congrFun keep.1 b
    · funext b
      by_cases equal : b=localBlock
      · simp only [KeygenRngSource.disposed,equal,ite_true]
      · simpa only [KeygenRngSource.disposed,KeygenRngSource.allocated,equal,ite_false] using congrFun keep.2.1 b
    · simpa only [KeygenRngSource.disposed,KeygenRngSource.allocated,different,ite_false] using keep.2.2

end FT1536.Source3.ShakePointFrame
