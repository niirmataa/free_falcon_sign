import ArrayBank020E4
import WordRAM020

namespace FT1536.S05.RegionRam020E5
open WordRAM020 ArrayBank020E4

/-- An actual region owns its cells. A capacity counter with no payload is
    not an allocated region. Registers/payloads are padded Word512 cells. -/
structure Region where
  cells : Array Word

abbrev Heap := Array Region

def words (h : Heap) : Nat := (h.toList.map (fun r => r.cells.size)).sum

def allocate (h : Heap) (payload : Array Word) : Heap × Nat :=
  (h.push ⟨payload⟩,h.size)

def write (h : Heap) (r : Fin h.size) (j : Fin (h[r.val].cells.size)) (v : Word) : Heap :=
  h.set r.val ⟨h[r.val].cells.set j.val v⟩

def live (h : Heap) : Nat := words h + 2*h.size

/-- Append allocation stores the supplied data, not only its length. -/
theorem allocate_read (h : Heap) (a : Array Word) :
    (allocate h a).1[h.size]'(by simp [allocate])=⟨a⟩ := by simp [allocate]

theorem allocate_size (h : Heap) (a : Array Word) : (allocate h a).1.size=h.size+1 := by simp [allocate]

theorem allocate_words (h : Heap) (a : Array Word) : words (allocate h a).1=words h+a.size := by
  simp [words,allocate]

theorem allocate_live (h : Heap) (a : Array Word) : live (allocate h a).1=live h+a.size+2 := by
  simp only [live,allocate_words,allocate_size]
  omega

theorem write_size (h : Heap) (r : Fin h.size) (j : Fin (h[r.val].cells.size)) (v : Word) :
    (write h r j v).size=h.size := by simp [write]

theorem write_words (h : Heap) (r : Fin h.size) (j : Fin (h[r.val].cells.size)) (v : Word) :
    words (write h r j v)=words h := by
  unfold words write
  congr 1
  apply List.ext_getElem
  · simp
  · intro k hk hk'
    simp only [List.getElem_map,Array.getElem_toList]
    by_cases he : k=r.val
    · subst k
      simp
    · simp [Array.getElem_set,Ne.symm he]

theorem write_live (h : Heap) (r : Fin h.size) (j : Fin (h[r.val].cells.size)) (v : Word) :
    live (write h r j v)=live h := by rw [live,write_words,write_size];rfl

/-- Operational allocation discipline. Writes retain the single current
    region; the prior mathematical state is not an extra runtime region. -/
inductive Step : Heap → Heap → Prop where
  | store (h : Heap) (r : Fin h.size) (j : Fin (h[r.val].cells.size)) (v : Word) : Step h (write h r j v)

inductive Steps : Heap → List Heap → Heap → Prop where
  | nil (h : Heap) : Steps h [] h
  | cons {h q z : Heap} {hs : List Heap} : Step h q → Steps q hs z → Steps h (q::hs) z

theorem step_live {h q : Heap} (s : Step h q) : live q=live h := by
  cases s
  exact write_live _ _ _ _

theorem steps_live {h z : Heap} {hs : List Heap} (s : Steps h hs z) :
    live z=live h ∧ ∀ q∈hs,live q=live h := by
  induction s with
  | nil h => exact ⟨rfl,by simp⟩
  | @cons h q z hs hq htail ih =>
    have he := step_live hq
    refine ⟨ih.1.trans he,?_⟩
    intro r hr
    rcases List.mem_cons.mp hr with hr|hr
    · subst r;exact he
    · exact (ih.2 r hr).trans he

end FT1536.S05.RegionRam020E5
