import CoreFieldPatch020E5
import CoreRun020E5

namespace FT1536.S05.CoreStartup020E5
open WordRAM020 ArrayBank020E4 ArenaTypes020E1 NodeFrames020E2 CoreState020E5 CoreEncoding020E5 CoreFieldPatch020E5 VerifiedPatch020E5

/-- The ALLOC_ZERO image before installing the entry frame and fuel. -/
def blank (cap capacity limit : Nat) : Core cap capacity limit :=
  ⟨ArrayState020E4.initial,ArrayFrames020E4.empty capacity (.run (0 : Ptr cap)),zero cap none,.check,0,0,.none⟩

def ready {cap capacity limit : Nat} (h : 0<capacity) (root : Ptr cap) : Core cap capacity limit :=
  let q := blank cap capacity limit
  let q' := setFrames q (write q.frames.bank ⟨0,h⟩ (.run root))
  setMetadata q' (.check,(0,(⟨limit,by omega⟩,(⟨1,by omega⟩,(.none,false)))))

def program {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (h : 0<capacity) (root : Ptr cap) :
    Program (image hc hf hl (blank cap capacity limit)) (image hc hf hl (ready h root)) :=
  let q := blank cap capacity limit
  let q' := setFrames q (write q.frames.bank ⟨0,h⟩ (.run root))
  thenDo (frames hc hf hl q ⟨0,h⟩ (.run root))
    (control hc hf hl q' (.check,(0,(⟨limit,by omega⟩,(⟨1,by omega⟩,(.none,false))))))

theorem length {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (h : 0<capacity) (root : Ptr cap) : (program hc hf hl h root).code.length=19 := by
  unfold payloadWords
  simp only [program,ready,thenDo,CoreFieldPatch020E5.frames,CoreFieldPatch020E5.control,PairPatch020E5.first,PairPatch020E5.second,
    WordJoin020E5.liftLeft,WordJoin020E5.liftRight,cell,overwrite]
  unfold payloadWords
  simp only [List.length_append,List.length_map,List.length_ofFn]

theorem ready_start {cap capacity limit : Nat} (h : 0<capacity) (root : Ptr cap) :
    ready (limit:=limit) h root=start limit ArrayState020E4.initial
      ⟨write (zero capacity (.run (0 : Ptr cap))) ⟨0,h⟩ (.run root),⟨1,by omega⟩⟩ (zero cap none) := rfl

theorem push_ready {cap capacity limit : Nat} (h : 0<capacity) (root : Ptr cap) :
    (ArrayFrames020E4.push (ArrayFrames020E4.empty capacity (.run (0 : Ptr cap))) (.run root)).map
      (fun st => start limit ArrayState020E4.initial st (zero cap none))=some (ready h root) := by
  unfold ArrayFrames020E4.push ArrayFrames020E4.empty
  split
  · rfl
  · rename_i hn
    exact False.elim (hn h)

end FT1536.S05.CoreStartup020E5
