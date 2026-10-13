import Source3.KeygenCodecStaticReadJoint

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Physical input words and preservation derived from the actual byte
   trace. Separation is a memory-entry domain, not an assumed codec frame. -/
namespace FT1536.Source3.KeygenCodecStaticMaterial
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticHistory

inductive Words (heap : Memory) : ArrayPointer → List (BitVec 16) → Prop where
  | nil (ptr : ArrayPointer) : Words heap ptr []
  | cons (ptr next : ArrayPointer) (input : BitVec 16) (rest : List (BitVec 16))
      (load : Load16 heap ptr input) (advance : PointerAdd ptr 1 next)
      (tail : Words heap next rest) : Words heap ptr (input::rest)

def Separated (out : Option ArrayPointer) (block : Nat) : Prop :=
  ∀ dst, out=some dst → block≠dst.block

structure Preserved (block : Nat) (before after : Memory) : Prop where
  sizes : after.size=before.size
  bytes : ∀ offset, after.bytes block offset=before.bytes block offset

theorem load_unique (heap : Memory) (ptr : ArrayPointer) (a b : BitVec 16)
    (first : Load16 heap ptr a) (second : Load16 heap ptr b) : a=b := by
  cases first with
  | load lo hi allocated width low high =>
    cases second with
    | load lo' hi' allocated' width' low' high' =>
      have sameLo := Option.some.inj (low.symm.trans low')
      have sameHi := Option.some.inj (high.symm.trans high')
      subst lo'; subst hi'; rfl

theorem add_unique (ptr a b : ArrayPointer) (first : PointerAdd ptr 1 a)
    (second : PointerAdd ptr 1 b) : a=b := by cases first; cases second; rfl

theorem trace_sizes (a b : Memory) (writes : List KeygenCodecByteHistory.Write)
    (source : KeygenCodecByteHistory.Trace a b writes) : b.size=a.size := by
  induction source with
  | nil => rfl
  | step a b c p word rest store tail ih => exact ih.trans store.2.2.2.1

theorem positions_away (out : Option ArrayPointer) (block n : Nat) (bs : List (BitVec 8))
    (separate : Separated out block) :
    ∀ write ∈ positions out n bs, block≠write.1.block := by
  induction bs generalizing n with
  | nil => intro write member; cases member
  | cons b bs ih =>
    intro write member
    rcases List.mem_append.mp member with first | tail
    · cases out with
      | none => cases first
      | some dst =>
        have same : write=(byteOff dst n,b) := by simpa [single] using first
        subst write
        exact separate dst rfl
    · exact ih (n+1) write tail

theorem progress_preserved (args : Args) (s t : State) (n : Nat) (bs : List (BitVec 8)) (flow : Flow)
    (history : Progress args s t n bs flow) (block : Nat) (separate : Separated args.out block) :
    Preserved block s.heap t.heap := by
  obtain ⟨k,_,_,_,trace,_⟩ := history
  exact ⟨trace_sizes _ _ _ trace,fun offset => KeygenCodecByteHistory.outside _ _ _ trace block offset
    (fun write member => Or.inl (positions_away args.out block n (bs.take k) separate write member))⟩

theorem load_preserved (block : Nat) (a b : Memory) (frame : Preserved block a b)
    (ptr : ArrayPointer) (same : ptr.block=block) (input : BitVec 16) (load : Load16 a ptr input) :
    Load16 b ptr input := by
  cases load with
  | load lo hi allocated width low high =>
    exact .load b ptr lo hi (by simpa only [Allocated,frame.sizes] using allocated) width
      (by rw [same,frame.bytes]; simpa only [same] using low)
      (by rw [same,frame.bytes]; simpa only [same] using high)

theorem words_preserved (block : Nat) (a b : Memory) (frame : Preserved block a b)
    (ptr : ArrayPointer) (same : ptr.block=block) (inputs : List (BitVec 16))
    (words : Words a ptr inputs) : Words b ptr inputs := by
  induction words with
  | nil ptr => exact .nil ptr
  | cons ptr next input rest load advance tail ih =>
    have nextBlock : next.block=block := by cases advance; exact same
    exact .cons ptr next input rest (load_preserved block a b frame ptr same input load) advance (ih nextBlock)

end FT1536.Source3.KeygenCodecStaticMaterial
