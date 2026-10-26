import Source3.StepNttBody195
import Source3.StepNttMiddle195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/-! # The executed word image of the doubling rounds: foundation

A word-image predicate for the 512 marched `a` cells at the selected call
words (logn = 9 / full = 0, n = 512, stride = 1) and the ATOMIC butterfly
step over it: one butterfly writes its two canonical words at the walked
pair and leaves every other cell word unchanged, so the image transforms
by `pairAt` (the pair update). This module is the FOUNDATION of the
executed-word image of the doubling passes (OPEN (1) of the 572/573
windows). The compositions are the NEXT windows and are NOT claimed
here: the v-loop image over one u1 block (pairs (l+v, l+h+v), twiddle
gvs (m+j)), then the u1-loop / round / m-walk composition, and later the
productFd/productGd bridge through
`StepNttKeep195.tail_keep_words` (see `image_keep`).

Both butterfly shapes are covered at their pinned execution engines:
the degree-1 firstBody step over the job-570 `StepNttBody195.body_state`
(words lowWord/highWord) and the radix-2 binaryBody step of the doubling
rounds over `NttBinaryBody183.after` (words leftWord/rightWord at the
loaded twiddle) — the two canonical writes of the job-570/572 pattern
with the `reads_two`/`load32_unique` discipline pinned to exact words.
The image is carried by the heap alone (the butterfly steps keep
locals/arrays; only the heap words matter here). The DEFECT NOTE of the
layer-195 supplement (owner decision A) stays in force: nothing is
built on the job-570 `StepNttFirst195.stepState`. Values stay executed
words: no transform property, table law, root law or positivity claim
is made here. -/
namespace FT1536.Source3.StepNttImage195
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated Load32 Memory)
open C99ModularReference (Exec)
open C99ProcedureReference (Result)
open KeygenSmallOutput (element)
open KeygenModpR2Exec (Slot)
open NttBinaryBody183 (leftWord rightWord)

/-! ## The image predicate and the pair update -/

/-- The executed word image of the 512 marched cells of `a`: at the
    state `s` the cell `element a j` holds the executed word `W j`. -/
def Image (s : State) (a : ArrayPointer) (W : Nat → BitVec 32) : Prop :=
  ∀ j < 512, Load32 s.heap (element a j) (W j)

/-- The word image of one butterfly at the walked pair `(i,k)`: the
    second canonical write lands at `k`, the first at `i` (the pair is
    distinct), every other word is unchanged. -/
def pairAt (W : Nat → BitVec 32) (i k : Nat) (wi wk : BitVec 32) (j : Nat) : BitVec 32 :=
  if j = k then wk else if j = i then wi else W j

theorem pairAt_k (W : Nat → BitVec 32) (i k : Nat) (wi wk : BitVec 32) :
    pairAt W i k wi wk k = wk := by
  simp [pairAt]

theorem pairAt_i (W : Nat → BitVec 32) (i k : Nat) (wi wk : BitVec 32) (ne : i ≠ k) :
    pairAt W i k wi wk i = wi := by
  simp [pairAt, ne]

theorem pairAt_out (W : Nat → BitVec 32) (i k : Nat) (wi wk : BitVec 32) (j : Nat)
    (notK : j ≠ k) (notI : j ≠ i) : pairAt W i k wi wk j = W j := by
  simp [pairAt, notK, notI]

/-! ## Image bridges -/

/-- The image is carried by the heap alone: any state with the same heap
    has the same image (the `StepNttKeep195.tail_keep_words` transport
    used by the later productFd/productGd bridge). -/
theorem image_keep {s s' : State} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s a W) (heap : s'.heap = s.heap) : Image s' a W := by
  intro j bound
  rw [heap]
  exact image j bound

/-- The image supplies the executed reads (the `MFixed.reads` shape). -/
theorem image_reads {s : State} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s a W) (j : Nat) (bound : j < 512) : ∃ w, Load32 s.heap (element a j) w :=
  ⟨W j, image j bound⟩

/-- Reads are deterministic: any executed word at a marched cell is the
    image word (the `load32_unique` discipline of the job-570 layer). -/
theorem image_word {s : State} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s a W) {j : Nat} {x : BitVec 32} (bound : j < 512)
    (read : Load32 s.heap (element a j) x) : x = W j :=
  StepNttBody195.load32_unique s.heap (element a j) x (W j) read (image j bound)

/-! ## The atomic step: the two canonical writes -/

/-- The atomic word-image step at the heap: the two canonical writes
    (first `element a i`, then `element a k`, the pair distinct) turn
    the image `W` into `pairAt W i k wi wk`. Every marched cell keeps
    its exact word (the job-572 `reads_two` shape pinned to words). -/
theorem two_write_words {h : Memory} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : ∀ j < 512, Load32 h (element a j) (W j))
    (width : a.elementBytes = 4) (writable : h.writable a.block = true)
    (i k : Nat) (hi : i < 512) (hk : k < 512) (ne : i ≠ k) (wi wk : BitVec 32) :
    ∀ j < 512, Load32 (Word32Memory176.write (Word32Memory176.write h (element a i) wi)
      (element a k) wk) (element a j) (pairAt W i k wi wk j) := by
  intro j bound
  have read := image j bound
  have allocI : Allocated h (element a i) := StepNttFirstLoop195.load_allocated (image i hi)
  have allocK : Allocated h (element a k) := StepNttFirstLoop195.load_allocated (image k hk)
  have widthI : (element a i).elementBytes = 4 := StepNttMiddle195.width_at a width i
  have widthK : (element a k).elementBytes = 4 := StepNttMiddle195.width_at a width k
  by_cases atK : j = k
  · subst j
    rw [pairAt_k]
    exact StepNttFirstLoop195.two_write_here_right h (element a i) (element a k) wi wk allocK
      widthK writable
  · by_cases atI : j = i
    · subst j
      rw [pairAt_i W i k wi wk ne]
      exact StepNttFirstLoop195.two_write_here_left h (element a i) (element a k) wi wk allocI
        widthI writable (StepNttFirst195.elem_separate a width i k ne)
    · rw [pairAt_out W i k wi wk j atK atI]
      exact StepNttFirstLoop195.two_write_keep h (element a i) (element a j) (element a k) wi wk
        (W j) (StepNttFirst195.elem_separate a width j i (by omega))
        (StepNttFirst195.elem_separate a width j k (by omega)) read

/-- The two canonical writes over the heap of `s` (precomputed record
    value — trap (1): no parenthesized arguments inside `{... with}`
    literals). -/
def twoHeap (s : State) (a : ArrayPointer) (i k : Nat) (wi wk : BitVec 32) : Memory :=
  Word32Memory176.write (Word32Memory176.write s.heap (element a i) wi) (element a k) wk

/-- The atomic step at the state level: the two canonical writes over the
    heap of `s` (the `StepNttBody195.body_state` write pattern). -/
theorem image_two_write {s : State} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s a W) (width : a.elementBytes = 4) (writable : s.heap.writable a.block = true)
    (i k : Nat) (hi : i < 512) (hk : k < 512) (ne : i ≠ k) (wi wk : BitVec 32) :
    Image {s with heap := twoHeap s a i k wi wk} a (pairAt W i k wi wk) :=
  two_write_words image width writable i k hi hk ne wi wk

/-! ## The atomic butterfly step over `StepNttBody195.body_state` -/

theorem highHeap_words (s : State) (p1 p2 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32) :
    StepNttBody195.highHeap s p1 p2 a0 a1 w pw p0i =
      Word32Memory176.write (Word32Memory176.write s.heap p1
        (StepNttBody195.lowWord a0 a1 w pw p0i)) p2 (StepNttBody195.highWord a0 a1 w pw p0i) :=
  rfl

/-- The image at the degree-1 butterfly output over `body_state`: the
    two canonical words lowWord/highWord at the walked pair `(i,k)`. -/
theorem body_image {s : State} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s a W) (width : a.elementBytes = 4) (writable : s.heap.writable a.block = true)
    (i k : Nat) (hi : i < 512) (hk : k < 512) (ne : i ≠ k) (w pw p0i : BitVec 32)
    (wSlot : Slot s "w" w) (pSlot : Slot s "p" pw) (p0iSlot : Slot s "p0i" p0i)
    (r1Binding : s.arrays "r1".toList = some (element a i))
    (r2Binding : s.arrays "r2".toList = some (element a k)) :
    Image (StepNttBody195.bodyOut s (element a i) (element a k) (W i) (W k) w pw p0i) a
      (pairAt W i k (StepNttBody195.lowWord (W i) (W k) w pw p0i)
        (StepNttBody195.highWord (W i) (W k) w pw p0i)) := by
  have state := StepNttBody195.body_state s (element a i) (element a k) (W i) (W k) w pw p0i
      wSlot pSlot p0iSlot r1Binding r2Binding (image i hi) (image k hk)
      (StepNttFirstLoop195.load_allocated (image i hi)) (StepNttMiddle195.width_at a width i)
      writable (StepNttFirstLoop195.load_allocated (image k hk))
      (StepNttMiddle195.width_at a width k) writable
  rw [state, highHeap_words]
  exact two_write_words image width writable i k hi hk ne
    (StepNttBody195.lowWord (W i) (W k) w pw p0i) (StepNttBody195.highWord (W i) (W k) w pw p0i)

/-- The atomic degree-1 butterfly step over `StepNttBody195.body_state`:
    the block run at the walked pair `(i,k)` (the image supplies the two
    reads) and the image of its two canonical words. -/
theorem body_step {s : State} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s a W) (width : a.elementBytes = 4) (writable : s.heap.writable a.block = true)
    (i k : Nat) (hi : i < 512) (hk : k < 512) (ne : i ≠ k) (w pw p0i : BitVec 32)
    (wSlot : Slot s "w" w) (pSlot : Slot s "p" pw) (p0iSlot : Slot s "p0i" p0i)
    (r1Binding : s.arrays "r1".toList = some (element a i))
    (r2Binding : s.arrays "r2".toList = some (element a k)) :
    Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) s
      ⟨StepNttBody195.bodyOut s (element a i) (element a k) (W i) (W k) w pw p0i,.normal⟩ ∧
    Image (StepNttBody195.bodyOut s (element a i) (element a k) (W i) (W k) w pw p0i) a
      (pairAt W i k (StepNttBody195.lowWord (W i) (W k) w pw p0i)
        (StepNttBody195.highWord (W i) (W k) w pw p0i)) :=
  ⟨StepNttBody195.block_run s (element a i) (element a k) (W i) (W k) w pw p0i
      wSlot pSlot p0iSlot r1Binding r2Binding (image i hi) (image k hk)
      (StepNttFirstLoop195.load_allocated (image i hi)) (StepNttMiddle195.width_at a width i)
      writable (StepNttFirstLoop195.load_allocated (image k hk))
      (StepNttMiddle195.width_at a width k) writable,
    body_image image width writable i k hi hk ne w pw p0i wSlot pSlot p0iSlot r1Binding r2Binding⟩

/-! ## The atomic butterfly step of the doubling rounds -/

theorem binary_heap (s : State) (r1 r2 : ArrayPointer) (x y w p p0i : BitVec 32) :
    (NttBinaryBody183.after s r1 r2 x y w p p0i).heap =
      Word32Memory176.write (Word32Memory176.write s.heap r1 (leftWord x y w p p0i))
        r2 (rightWord x y w p p0i) :=
  rfl

/-- The image at the radix-2 butterfly output of the doubling rounds:
    the two canonical words leftWord/rightWord at the walked pair
    `(i,k)` with the loaded twiddle word `tw`. -/
theorem binary_image {s : State} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s a W) (width : a.elementBytes = 4) (writable : s.heap.writable a.block = true)
    (i k : Nat) (hi : i < 512) (hk : k < 512) (ne : i ≠ k) (tw pw p0i : BitVec 32) :
    Image (NttBinaryBody183.after s (element a i) (element a k) (W i) (W k) tw pw p0i) a
      (pairAt W i k (leftWord (W i) (W k) tw pw p0i) (rightWord (W i) (W k) tw pw p0i)) := by
  show ∀ j < 512, Load32
    (NttBinaryBody183.after s (element a i) (element a k) (W i) (W k) tw pw p0i).heap
    (element a j) (pairAt W i k (leftWord (W i) (W k) tw pw p0i)
      (rightWord (W i) (W k) tw pw p0i) j)
  rw [binary_heap]
  exact two_write_words image width writable i k hi hk ne
    (leftWord (W i) (W k) tw pw p0i) (rightWord (W i) (W k) tw pw p0i)

/-- The atomic radix-2 butterfly step of the doubling rounds (the v-loop
    iteration shape): the block run at the walked pair `(i,k)` with the
    loaded twiddle word `tw`, and the image of its two canonical words. -/
theorem binary_step {s : State} {a : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s a W) (width : a.elementBytes = 4) (writable : s.heap.writable a.block = true)
    (i k : Nat) (hi : i < 512) (hk : k < 512) (ne : i ≠ k) (tw pw p0i : BitVec 32)
    (pSlot : Slot s "p" pw) (p0iSlot : Slot s "p0i" p0i) (sSlot : Slot s "s" tw)
    (r1Binding : s.arrays "r1".toList = some (element a i))
    (r2Binding : s.arrays "r2".toList = some (element a k)) :
    Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody) s
      ⟨NttBinaryBody183.after s (element a i) (element a k) (W i) (W k) tw pw p0i,.normal⟩ ∧
    Image (NttBinaryBody183.after s (element a i) (element a k) (W i) (W k) tw pw p0i) a
      (pairAt W i k (leftWord (W i) (W k) tw pw p0i) (rightWord (W i) (W k) tw pw p0i)) :=
  ⟨NttBinaryBody183.source s (element a i) (element a k) (W i) (W k) tw pw p0i
      pSlot p0iSlot sSlot r1Binding r2Binding
      (StepNttFirstLoop195.load_allocated (image i hi))
      (StepNttFirstLoop195.load_allocated (image k hk))
      (StepNttMiddle195.width_at a width i) (StepNttMiddle195.width_at a width k)
      writable writable (image i hi) (image k hk),
    binary_image image width writable i k hi hk ne tw pw p0i⟩

end FT1536.Source3.StepNttImage195
