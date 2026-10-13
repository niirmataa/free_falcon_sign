import RegionTrace020E5

namespace FT1536.S05.RegionSlot020E5
open WordRAM020 ArrayBank020E4 RegionRam020E5

/-- A frame template is proof-only. The runtime heap is the single resulting
    Array of regions, with the selected region holding the actual payload. -/
def frame {n : Nat} (context : Heap) (r : Fin context.size) (a : Bank Word n) : Heap :=
  context.set r.val ⟨a.cells⟩

theorem size {n : Nat} (context : Heap) (r : Fin context.size) (a : Bank Word n) :
    (frame context r a).size=context.size := by simp [frame]

def site {n : Nat} (context : Heap) (r : Fin context.size) (a : Bank Word n) : Fin (frame context r a).size :=
  ⟨r.val,by rw [size];exact r.isLt⟩

theorem selected {n : Nat} (context : Heap) (r : Fin context.size) (a : Bank Word n) :
    (frame context r a)[(site context r a).val].cells=a.cells := by simp [frame,site]

def cellIndex {n : Nat} (context : Heap) (r : Fin context.size) (a : Bank Word n) (j : Fin n) :
    Fin ((frame context r a)[(site context r a).val].cells.size) :=
  ⟨j.val,by rw [selected,a.size_eq];exact j.isLt⟩

theorem frame_identity {n : Nat} (h : Heap) (r : Fin h.size) (a : Bank Word n) (ha : h[r.val].cells=a.cells) :
    frame h r a=h := by
  unfold frame
  have he : h[r.val]=({cells:=a.cells}:Region) := by cases hh : h[r.val];simp_all
  rw [←he]
  simp

theorem word_store {n : Nat} (context : Heap) (r : Fin context.size) (a : Bank Word n) (j : Fin n) (v : Word) :
    RegionRam020E5.write (frame context r a) (site context r a) (cellIndex context r a j) v=
      frame context r (ArrayBank020E4.write a j v) := by
  simp only [RegionRam020E5.write,site,cellIndex,frame,Array.getElem_set_self,Array.set_set,ArrayBank020E4.write]

theorem word_step {n : Nat} (context : Heap) (r : Fin context.size) (a : Bank Word n) (j : Fin n) (v : Word) :
    Step (frame context r a) (frame context r (ArrayBank020E4.write a j v)) := by
  rw [←word_store]
  exact .store _ _ _ _

theorem trace {n : Nat} (context : Heap) (r : Fin context.size) {a b : Bank Word n} {hist : List (Bank Word n)}
    (h : WordPatch020E5.Stores a hist b) : Steps (frame context r a) (hist.map (frame context r)) (frame context r b) := by
  induction h with
  | nil a => exact .nil _
  | cons j v tail ih => exact .cons (word_step context r _ j v) ih

theorem run_existing {n : Nat} (h : Heap) (r : Fin h.size) (a : Bank Word n)
    (ha : h[r.val].cells=a.cells) (xs : List (WordPatch020E5.Write n)) :
    ∃ hist,Steps h hist (frame h r (WordPatch020E5.apply xs a)) ∧ ∀ q∈h::hist,live q=live h := by
  obtain ⟨hist,ht,_⟩ := WordPatch020E5.has_trace xs a
  have hh := trace h r ht
  rw [frame_identity h r a ha] at hh
  exact ⟨hist.map (frame h r),hh,RegionTrace020E5.peak hh⟩

end FT1536.S05.RegionSlot020E5
