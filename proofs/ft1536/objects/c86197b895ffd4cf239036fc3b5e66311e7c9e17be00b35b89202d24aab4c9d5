import Source3.KeygenRngReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Executed tmp32 lifetime and precise context frames. The automatic blocks
   restore their pre-allocation bytes/extent/permissions on every return,
   including entropy failure. No caller-supplied frame is used. -/
namespace FT1536.Source3.KeygenRngFrame
open C99MemoryReference
open C99ArrayReference (State bindPointer)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenRngProgram
open KeygenRngReference
open ShakePointFrame (Same)

def Outside (ctx : Context) (b o : Nat) : Prop :=
  b≠ctx.object.block ∨ o<ctx.object.offset+8 ∨ ctx.object.offset+432≤o
theorem rng_outside (ctx : Context) (b o : Nat) (outside : Outside ctx b o) :
    ∀ f, ShakeBlock.Outside (ShakeExtractSource.field (KeygenSamplerContext.rng ctx) f) b o := by
  intro f
  cases f <;> dsimp [ShakeBlock.Outside,ShakeExtractSource.field,KeygenSamplerContext.rng,Outside] at * <;> omega
theorem flags_outside (ctx : Context) (b o : Nat) (outside : Outside ctx b o) :
    ∀ f, ShakeBlock.Outside (KeygenReadyFast.field ctx f) b o := by
  intro f
  cases f <;> dsimp [ShakeBlock.Outside,KeygenReadyFast.field,KeygenReadyFast.offset,KeygenSearchContext.field,Outside] at * <;> omega
def contextOnly : Stmt → Bool
  | .extractTmp | .branchEntropy _ _ => false
  | .seq a b | .branchScalar _ a b | .branchFlag _ _ a b => contextOnly a && contextOnly b
  | .scope body => contextOnly body
  | .auto32 _ => true
  | _ => true
def TmpOutside (s : State) (b o : Nat) : Prop := ∀ p, s.arrays "tmp".toList=some p → ShakeBlock.Outside p b o
def Safe (s : State) (code : Stmt) (b o : Nat) : Prop := contextOnly code=true ∨ TmpOutside s b o
theorem safe_first (s : State) (a b : Stmt) (block offset : Nat) (safe : Safe s (.seq a b) block offset) : Safe s a block offset := by
  rcases safe with checked | pointers
  · exact Or.inl (Bool.and_eq_true_iff.mp checked).1
  · exact Or.inr pointers
theorem safe_second (ctx : Context) (s middle : State) (a b : Stmt) (block offset : Nat)
    (events : List KeygenEntropySource.Event) (source : Exec ctx a s events ⟨middle,.normal⟩)
    (safe : Safe s (.seq a b) block offset) : Safe middle b block offset := by
  rcases safe with checked | pointers
  · exact Or.inl (Bool.and_eq_true_iff.mp checked).2
  · have arrays : middle.arrays=s.arrays := (slots ctx a s events ⟨middle,.normal⟩ source).2.1
    exact Or.inr (by simpa only [TmpOutside,arrays] using pointers)
theorem safe_branch (s : State) (a b : Stmt) (block offset : Nat)
    (safe : (contextOnly a && contextOnly b)=true ∨ TmpOutside s block offset) :
    Safe s a block offset ∧ Safe s b block offset := by
  rcases safe with checked | pointers
  · have h := Bool.and_eq_true_iff.mp checked; exact ⟨Or.inl h.1,Or.inl h.2⟩
  · exact ⟨Or.inr pointers,Or.inr pointers⟩

theorem sizes (ctx : Context) (code : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx code before events out) : out.state.heap.size=before.heap.size ∧ out.state.heap.writable=before.heap.writable := by
  induction source with
  | skip | ret => exact ⟨rfl,rfl⟩
  | init before after capacity v resolved value source =>
    have keep := ShakeSeedReference.init_frame _ _ _ _ source (ctx.object.block+1) 0
      (rng_outside ctx _ _ (Or.inl (by omega)))
    exact ⟨keep.1,keep.2.1⟩
  | inject before after name length p v resolved data len source =>
    have keep := ShakeSeedReference.inject_frame _ _ _ _ _ source (ctx.object.block+1) 0
      (rng_outside ctx _ _ (Or.inl (by omega)))
    exact ⟨keep.1,keep.2.1⟩
  | extractTmp before after p resolved data source =>
    have keep := ShakePointFrame.call _ _ _ _ _ source (ctx.object.block+p.block+1) 0
      (rng_outside ctx _ _ (Or.inl (by omega))) (Or.inl (by omega))
    exact ⟨keep.1,keep.2.1⟩
  | flip before after resolved source =>
    have keep := ShakeSeedReference.flip_frame _ _ _ source (ctx.object.block+1) 0
      (rng_outside ctx _ _ (Or.inl (by omega)))
    exact ⟨keep.1,keep.2.1⟩
  | storeFlag before flag value v heap binding evaluated write => exact ⟨write.2.2.2.1,write.2.2.2.2.1⟩
  | setSeed before entry name length replace events out binding body conversion ih =>
    have heap := C99ArrayReference.bind_heap before params _ entry binding
    rw [heap] at ih
    exact ih
  | branchScalarTrue _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchScalarFalse _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchFlagTrue _ _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchFlagFalse _ _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchEntropyTrue _ _ before seeded p word entropy events out v data call guard nonzero source ih =>
    have keep := KeygenEntropySource.call_frame _ _ _ _ _ _ call (p.block+1) 0 (Or.inl (by omega))
    exact ⟨ih.1.trans keep.1,ih.2.trans keep.2.1⟩
  | branchEntropyFalse _ _ before seeded p word entropy events out v data call guard zero source ih =>
    have keep := KeygenEntropySource.call_frame _ _ _ _ _ _ call (p.block+1) 0 (Or.inl (by omega))
    exact ⟨ih.1.trans keep.1,ih.2.trans keep.2.1⟩
  | seqNormal _ _ _ _ _ _ _ _ _ ih1 ih2 => exact ⟨ih2.1.trans ih1.1,ih2.2.trans ih1.2⟩
  | seqExit _ _ _ _ _ _ _ ih => exact ih
  | scope _ _ _ _ _ ih => exact ih
  | auto32 code before block events out fresh source ih =>
    constructor
    · funext b
      change (if b=block then before.heap.size b else out.state.heap.size b)=before.heap.size b
      rw [ih.1]
      simp only [entered,C99ArrayReference.bindPointer,KeygenMakeObjects.allocated]
      by_cases h : b=block <;> simp only [h,ite_true,ite_false]
    · funext b
      change (if b=block then before.heap.writable b else out.state.heap.writable b)=before.heap.writable b
      rw [ih.2]
      simp only [entered,C99ArrayReference.bindPointer,KeygenMakeObjects.allocated]
      by_cases h : b=block <;> simp only [h,ite_true,ite_false]

theorem source_frame (ctx : Context) (code : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx code before events out) (b o : Nat) (outside : Outside ctx b o) (safe : Safe before code b o) :
    Same before.heap out.state.heap b o := by
  induction source with
  | skip | ret => exact ⟨rfl,rfl,rfl⟩
  | init _ _ _ _ _ _ source => exact ShakeSeedReference.init_frame _ _ _ _ source b o (rng_outside ctx b o outside)
  | inject _ _ _ _ _ _ _ _ _ source => exact ShakeSeedReference.inject_frame _ _ _ _ _ source b o (rng_outside ctx b o outside)
  | flip _ _ _ source => exact ShakeSeedReference.flip_frame _ _ _ source b o (rng_outside ctx b o outside)
  | extractTmp before after p resolved data source =>
    have pointers : TmpOutside before b o := by rcases safe with h | h; cases h; exact h
    cases data with
    | add root p i binding value nonnegative address =>
      cases address
      exact ShakePointFrame.call _ _ _ _ _ source b o (rng_outside ctx b o outside) (pointers root binding)
  | storeFlag before flag value v heap binding evaluated write =>
    refine ⟨write.2.2.2.1,write.2.2.2.2.1,write.2.2.2.2.2.2 b o ?_⟩
    have out := flags_outside ctx b o outside flag
    dsimp [ShakeBlock.Outside] at out
    have legal := write.1.2.2.1
    have width := write.2.1
    dsimp [ArrayPointer.offset] at out ⊢
    simp only [width] at out ⊢
    omega
  | setSeed before entry name length replace events out binding body conversion ih =>
    have keep := ih (Or.inl (by decide : contextOnly setSeedCode=true))
    rw [C99ArrayReference.bind_heap before params _ entry binding] at keep
    exact keep
  | branchScalarTrue _ a c before _ _ _ _ _ _ ih => exact ih (safe_branch before a c b o safe).1
  | branchScalarFalse _ a c before _ _ _ _ _ _ ih => exact ih (safe_branch before a c b o safe).2
  | branchFlagTrue _ _ a c before _ _ _ _ _ _ ih => exact ih (safe_branch before a c b o safe).1
  | branchFlagFalse _ _ a c before _ _ _ _ _ _ ih => exact ih (safe_branch before a c b o safe).2
  | branchEntropyTrue a c before seeded p word entropy events out v data call guard nonzero source ih =>
    have pointers : TmpOutside before b o := by rcases safe with h | h; cases h; exact h
    have actual : ShakeBlock.Outside p b o := by
      cases data with | add root p i binding value nonnegative address => cases address; exact pointers root binding
    have keep := KeygenEntropySource.call_frame _ _ _ _ _ _ call b o actual
    have newPointers : TmpOutside seeded b o := by simpa only [TmpOutside,(KeygenEntropySource.call_slots _ _ _ _ _ _ call).2.1] using pointers
    exact ShakePointFrame.trans _ _ _ b o keep (ih (Or.inr newPointers))
  | branchEntropyFalse a c before seeded p word entropy events out v data call guard zero source ih =>
    have pointers : TmpOutside before b o := by rcases safe with h | h; cases h; exact h
    have actual : ShakeBlock.Outside p b o := by
      cases data with | add root p i binding value nonnegative address => cases address; exact pointers root binding
    have keep := KeygenEntropySource.call_frame _ _ _ _ _ _ call b o actual
    have newPointers : TmpOutside seeded b o := by simpa only [TmpOutside,(KeygenEntropySource.call_slots _ _ _ _ _ _ call).2.1] using pointers
    exact ShakePointFrame.trans _ _ _ b o keep (ih (Or.inr newPointers))
  | seqNormal a c before middle events1 events2 out first second ih1 ih2 =>
    exact ShakePointFrame.trans _ _ _ b o (ih1 (safe_first before a c b o safe))
      (ih2 (safe_second ctx before middle a c b o events1 first safe))
  | seqExit a c before events out first exit ih => exact ih (safe_first before a c b o safe)
  | scope code before events out source ih => exact ih safe
  | auto32 code before block events out fresh source ih =>
    have extent := sizes ctx (.auto32 code) before events (closed before out block) (.auto32 code before block events out fresh source)
    refine ⟨extent.1,extent.2,?_⟩
    by_cases equal : b=block
    · simp only [closed,KeygenRngSource.disposed,equal,ite_true]
    · have pointers : TmpOutside (entered before block) b o := by
        intro p h
        have eq : p=⟨block,0,32,1,0⟩ := (Option.some.inj (by simpa [entered,bindPointer] using h)).symm
        subst p; exact Or.inl equal
      have keep := (ih (Or.inr pointers)).2.2
      simpa only [closed,KeygenRngSource.disposed,entered,bindPointer,KeygenMakeObjects.allocated,equal,ite_false] using keep
theorem call_frame (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event) (v : C99IntegerReference.Value)
    (source : Call ctx before events after v) (b o : Nat) (outside : Outside ctx b o) : Same before.heap after.heap b o := by
  cases source with
  | run =>
    rename_i entry result binding body conversion
    have keep := source_frame ctx readyCode entry events result body b o outside (Or.inl (by decide))
    rw [C99ArrayReference.bind_heap before readyParams readyArguments entry binding] at keep
    exact keep

end FT1536.Source3.KeygenRngFrame
