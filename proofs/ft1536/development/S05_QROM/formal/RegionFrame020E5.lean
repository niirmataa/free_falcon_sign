import RegionRam020E5
import WordPatch020E5

namespace FT1536.S05.RegionFrame020E5
open WordRAM020 ArrayBank020E4 RegionRam020E5

def heap {n : Nat} (context : Heap) (a : Bank Word n) : Heap := #[⟨a.cells⟩] ++ context

def slot {n : Nat} (context : Heap) (a : Bank Word n) : Fin (heap context a).size := ⟨0,by simp [heap]⟩

theorem first_size {n : Nat} (context : Heap) (a : Bank Word n) :
    (heap context a)[(slot context a).val].cells.size=n := by simp [heap,slot,a.size_eq]

def index {n : Nat} (context : Heap) (a : Bank Word n) (j : Fin n) :
    Fin ((heap context a)[(slot context a).val].cells.size) :=
  ⟨j.val,by rw [first_size];exact j.isLt⟩

theorem word_store {n : Nat} (context : Heap) (a : Bank Word n) (j : Fin n) (v : Word) :
    RegionRam020E5.write (heap context a) (slot context a) (index context a j) v=
      heap context (ArrayBank020E4.write a j v) := by
  apply Array.ext
  · simp [RegionRam020E5.write,heap]
  · intro k hk hk'
    by_cases h : k=0
    · subst k
      simp [RegionRam020E5.write,heap,slot,index,ArrayBank020E4.write]
    · have hn : ¬k<1 := by omega
      simp [RegionRam020E5.write,heap,slot,ArrayBank020E4.write,Array.getElem_append,hn]

theorem word_step {n : Nat} (context : Heap) (a : Bank Word n) (j : Fin n) (v : Word) :
    RegionRam020E5.Step (heap context a) (heap context (ArrayBank020E4.write a j v)) := by
  rw [←word_store]
  exact .store _ _ _ _

theorem word_trace {n : Nat} (context : Heap) {a b : Bank Word n} {hist : List (Bank Word n)}
    (h : WordPatch020E5.Stores a hist b) :
    RegionRam020E5.Steps (heap context a) (hist.map (heap context)) (heap context b) := by
  induction h with
  | nil a => exact .nil _
  | cons j v tail ih => exact .cons (word_step context _ j v) ih

theorem words_exact {n : Nat} (context : Heap) (a : Bank Word n) :
    words (heap context a)=n+words context := by
  simp [heap,words,a.size_eq]

theorem live_exact {n : Nat} (context : Heap) (a : Bank Word n) :
    live (heap context a)=n+2+live context := by
  unfold live
  rw [words_exact]
  simp only [heap,Array.size_append,Array.size_singleton]
  omega

theorem complete_store_peak {n : Nat} (context : Heap) (a : Bank Word n) (xs : List (WordPatch020E5.Write n)) :
    ∃ hist,RegionRam020E5.Steps (heap context a) hist (heap context (WordPatch020E5.apply xs a)) ∧
      ∀ h∈(heap context a)::hist,live h=n+2+live context := by
  obtain ⟨hist,ht,_⟩ := WordPatch020E5.has_trace xs a
  have hh := word_trace context ht
  refine ⟨hist.map (heap context),hh,?_⟩
  intro h hm
  rcases List.mem_cons.mp hm with he|hm
  · subst h;exact live_exact context a
  · exact ((steps_live hh).2 h hm).trans (live_exact context a)

end FT1536.S05.RegionFrame020E5
