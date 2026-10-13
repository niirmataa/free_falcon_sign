import Source3.KeygenCodecExecution

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Ordered byte writes of the same actual execution, including partial
   capacity returns. This trace is not an assumed serializer output. -/
namespace FT1536.Source3.KeygenCodecByteHistory
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

abbrev Write := ArrayPointer × BitVec 8

inductive Trace : Memory → Memory → List Write → Prop where
  | nil (heap : Memory) : Trace heap heap []
  | step (a b c : Memory) (p : ArrayPointer) (word : BitVec 8) (rest : List Write)
      (store : StoreByte a p word b) (tail : Trace b c rest) :
      Trace a c ((p,word)::rest)

theorem append (a b c : Memory) (xs ys : List Write)
    (first : Trace a b xs) (second : Trace b c ys) : Trace a c (xs++ys) := by
  induction first with
  | nil => exact second
  | step a b c p word rest store tail ih => exact .step _ _ _ _ _ _ store (ih second)

theorem execution (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) : ∃ writes, Trace s.heap t.heap writes := by
  induction source with
  | skip => exact ⟨[],.nil _⟩
  | declare => exact ⟨[],.nil _⟩
  | bind => exact ⟨[],.nil _⟩
  | scalar => exact ⟨[],.nil _⟩
  | store args s index rhs m t p offset value after buffer indexValue nonnegative rhsValue write =>
    exact ⟨[(byteOff p offset.integer.toNat,BitVec.ofInt 8 value.integer)],.step _ _ _ _ _ _ write (.nil _)⟩
  | increment => exact ⟨[],.nil _⟩
  | evaluate => exact ⟨[],.nil _⟩
  | seq args a b s m t flow first second ih1 ih2 =>
    obtain ⟨xs,one⟩ := ih1
    obtain ⟨ys,two⟩ := ih2
    exact ⟨xs++ys,append _ _ _ _ _ one two⟩
  | seqReturn args a b s t ret first ih => exact ih
  | scope args a s t flow noBufShadow inside ih => exact ih
  | branchTrue args test a b s t flow value locals evaluated yes selected ih => exact ih
  | branchFalse args test a b s t flow value locals evaluated no selected ih => exact ih
  | whileDone => exact ⟨[],.nil _⟩
  | whileNext args test a s m t flow value locals evaluated yes iteration rest ih1 ih2 =>
    obtain ⟨xs,one⟩ := ih1
    obtain ⟨ys,two⟩ := ih2
    exact ⟨xs++ys,append _ _ _ _ _ one two⟩
  | whileReturn args test a s t ret value locals evaluated yes iteration ih => exact ih
  | forLoop args initial test increment body s t flow expanded ih => exact ih
  | switchNone args test a b c s t flow value locals evaluated zero selected ih => exact ih
  | switchStatic args test a b c s t flow value locals evaluated one selected ih => exact ih
  | switchOther args test a b c s t flow value locals evaluated notZero notOne selected ih => exact ih
  | ret => exact ⟨[],.nil _⟩
  | call args called destination s t ret arguments execution ih => exact ih

/-- Source-derived ordered write histories preserve every byte outside
    their actual addresses, even when a capacity return ends the run. -/
theorem outside (a b : Memory) (writes : List Write) (trace : Trace a b writes)
    (block offset : Nat)
    (away : ∀ write ∈ writes, block≠write.1.block ∨ offset≠write.1.offset) :
    b.bytes block offset=a.bytes block offset := by
  induction trace with
  | nil => rfl
  | step a b c p word rest store tail ih =>
    exact (ih (fun write member => away write (List.mem_cons_of_mem _ member))).trans
      (store.2.2.2.2.2.2 block offset (away (p,word) (List.mem_cons_self)))

end FT1536.Source3.KeygenCodecByteHistory
