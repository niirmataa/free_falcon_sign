import RegionSlot020E5

namespace FT1536.S05.ZeroAllocate020E5
open WordRAM020 RegionRam020E5

/-- ALLOC_ZERO is the RAM primitive that reserves n cells and fills them
    with the scalar zero; it receives no uncharged precomputed array. -/
def allocate (h : Heap) (n : Nat) : Heap := h.push ⟨Array.replicate n (0 : Word)⟩

theorem size (h : Heap) (n : Nat) : (allocate h n).size=h.size+1 := by simp [allocate]

theorem words (h : Heap) (n : Nat) : RegionRam020E5.words (allocate h n)=RegionRam020E5.words h+n := by
  simp [allocate,RegionRam020E5.words]

theorem initialized (h : Heap) (n : Nat) :
    (allocate h n)[h.size]'(by simp [allocate])=⟨Array.replicate n (0 : Word)⟩ := by simp [allocate]

def run : List Nat → Heap → Heap
  | [],h => h
  | n::ns,h => run ns (allocate h n)

inductive Trace : Heap → List Heap → Heap → Prop where
  | nil (h : Heap) : Trace h [] h
  | cons {h z : Heap} {hs : List Heap} (n : Nat) : Trace (allocate h n) hs z → Trace h (allocate h n::hs) z

theorem size_run (ns : List Nat) (h : Heap) : (run ns h).size=h.size+ns.length := by
  induction ns generalizing h with
  | nil => simp [run]
  | cons n ns ih => simp only [run,ih,size,List.length_cons];omega

theorem words_run (ns : List Nat) (h : Heap) : RegionRam020E5.words (run ns h)=RegionRam020E5.words h+ns.sum := by
  induction ns generalizing h with
  | nil => simp [run]
  | cons n ns ih => simp only [run,ih,words,List.sum_cons];omega

theorem trace (ns : List Nat) (h : Heap) : ∃ hist,Trace h hist (run ns h) := by
  induction ns generalizing h with
  | nil => exact ⟨[],.nil h⟩
  | cons n ns ih => obtain ⟨hist,ht⟩ := ih (allocate h n);exact ⟨allocate h n::hist,.cons n ht⟩

theorem monotone {a b : Heap} {hist : List Heap} (h : Trace a hist b) :
    RegionRam020E5.words a≤RegionRam020E5.words b ∧ a.size≤b.size ∧
      ∀ q∈hist,RegionRam020E5.words q≤RegionRam020E5.words b ∧ q.size≤b.size := by
  induction h with
  | nil a => exact ⟨le_rfl,le_rfl,by simp⟩
  | @cons a b hist n tail ih =>
    have hw := words a n
    have hs := size a n
    refine ⟨by omega,by omega,?_⟩
    intro q hq
    rcases List.mem_cons.mp hq with he|he
    · subst q;exact ⟨ih.1,ih.2.1⟩
    · exact ih.2.2 q he

/-- Reserve the complete directory from the start, including unused entries.
    Every prefix of startup fits the same final payload+directory budget. -/
theorem startup_peak (ns : List Nat) (h : Heap) :
    ∃ hist,Trace h hist (run ns h) ∧ ∀ q∈h::hist,
      q.size≤h.size+ns.length ∧ RegionRam020E5.words q+2*(h.size+ns.length)≤
        RegionRam020E5.words h+ns.sum+2*(h.size+ns.length) := by
  obtain ⟨hist,ht⟩ := trace ns h
  have hm := monotone ht
  rw [size_run,words_run] at hm
  refine ⟨hist,ht,?_⟩
  intro q hq
  rcases List.mem_cons.mp hq with he|he
  · subst q;constructor <;> omega
  · exact ⟨(hm.2.2 q he).2,Nat.add_le_add_right (hm.2.2 q he).1 _⟩

end FT1536.S05.ZeroAllocate020E5
