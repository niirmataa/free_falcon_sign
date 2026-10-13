import WordTrace020E5
import ScriptStore020E5

namespace FT1536.S05.ScratchRound020E5
open WordRAM020 ArrayBank020E4 ScriptMachine020E5 WordPatch020E5

def reset {n capacity : Nat} (q : State n capacity) : State n capacity := {q with cursor:=0}

def loadState {n capacity : Nat} (q : State n capacity) (xs : List (Write n)) : State n capacity :=
  let s := FillMachine020E5.run (fun j : Fin capacity => xs[j.val]?) capacity (FillMachine020E5.start q.script)
  ⟨q.target,s.bank,s.cursor⟩

def round {n capacity : Nat} (q : State n capacity) (xs : List (Write n)) : State n capacity :=
  ScriptMachine020E5.run capacity (reset (loadState (reset q) xs))

theorem loadState_eq {n capacity : Nat} (q : State n capacity) (xs : List (Write n)) :
    loadState q xs=⟨q.target,ScriptBuffer020E5.buffer capacity xs,⟨capacity,by omega⟩⟩ := by
  unfold loadState
  dsimp only
  rw [FillMachine020E5.fills]
  have hj := FillMachine020E5.complete (fun j : Fin capacity => xs[j.val]?) capacity (FillMachine020E5.start q.script) (by exact le_rfl)
  have he : (FillMachine020E5.run (fun j : Fin capacity => xs[j.val]?) capacity (FillMachine020E5.start q.script)).cursor=
      (⟨capacity,by omega⟩ : Fin (capacity+1)) := Fin.ext hj
  rw [he]
  rfl

theorem round_target {n capacity : Nat} (q : State n capacity) (xs : List (Write n)) (h : xs.length≤capacity) :
    (round q xs).target=WordPatch020E5.apply xs q.target := by
  unfold round
  rw [loadState_eq]
  exact ScriptMachine020E5.script_executes q.target xs h

theorem script_trace {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (fuel : Nat) (q : State n capacity) :
    ∃ hist,Stores (ScriptStore020E5.image hn hc q) hist (ScriptStore020E5.image hn hc (ScriptMachine020E5.run fuel q)) := by
  induction fuel generalizing q with
  | zero => exact ⟨[],.nil _⟩
  | succ fuel ih =>
    let p := ScriptStore020E5.program hn hc q
    obtain ⟨front,hf,_⟩ := has_trace p.code (ScriptStore020E5.image hn hc q)
    rw [p.correct] at hf
    obtain ⟨tail,ht⟩ := ih (ScriptMachine020E5.step q)
    exact ⟨front++tail,WordTrace020E5.append hf ht⟩

theorem reset_trace {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) :
    ∃ hist,Stores (ScriptStore020E5.image hn hc q) hist (ScriptStore020E5.image hn hc (reset q)) := by
  let p := ScriptStore020E5.cursor hn hc q 0
  obtain ⟨hist,ht,_⟩ := has_trace p.code (ScriptStore020E5.image hn hc q)
  rw [p.correct] at ht
  exact ⟨hist,ht⟩

theorem image_split {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) :
    ScriptStore020E5.image hn hc q=WordJoin020E5.join
      (VerifiedPatch020E5.pack (WordCodec020E5.bank WordCodec020E5.wordCodec n) q.target)
      (FillStore020E5.image (ScriptStore020E5.writeCodec n hn) hc ⟨q.script,q.cursor⟩) := by
  change VerifiedPatch020E5.pack (WordCodec020E5.pair (WordCodec020E5.bank WordCodec020E5.wordCodec n)
    (ScriptStore020E5.controls n capacity hn hc)) (q.target,(q.script,q.cursor))=_
  rw [VerifiedPatch020E5.pack_pair]
  rfl

theorem load_trace {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) (xs : List (Write n)) :
    ∃ hist,Stores (ScriptStore020E5.image hn hc (reset q)) hist (ScriptStore020E5.image hn hc (loadState q xs)) := by
  obtain ⟨hist,ht⟩ := WordTrace020E5.fill (ScriptStore020E5.writeCodec n hn) hc
    (fun j : Fin capacity => xs[j.val]?) capacity (FillMachine020E5.start q.script)
  rw [image_split,image_split]
  have hl := WordTrace020E5.right (VerifiedPatch020E5.pack (WordCodec020E5.bank WordCodec020E5.wordCodec n) q.target) ht
  exact ⟨hist.map (WordJoin020E5.join (VerifiedPatch020E5.pack (WordCodec020E5.bank WordCodec020E5.wordCodec n) q.target)),hl⟩

/-- Full scratch protocol: reset cursor, overwrite all padded script slots,
    reset cursor, read the stored script and perform each target store. -/
theorem round_trace {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) (xs : List (Write n)) :
    ∃ hist,Stores (ScriptStore020E5.image hn hc q) hist (ScriptStore020E5.image hn hc (round q xs)) := by
  obtain ⟨a,ha⟩ := reset_trace hn hc q
  obtain ⟨b,hb⟩ := load_trace hn hc (reset q) xs
  obtain ⟨c,hc'⟩ := reset_trace hn hc (loadState (reset q) xs)
  obtain ⟨d,hd⟩ := script_trace hn hc capacity (reset (loadState (reset q) xs))
  exact ⟨a++b++c++d,WordTrace020E5.append (WordTrace020E5.append (WordTrace020E5.append ha hb) hc') hd⟩

theorem round_heap {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) (xs : List (Write n))
    (context : RegionRam020E5.Heap) (r : Fin context.size) :
    ∃ hist,RegionRam020E5.Steps (RegionSlot020E5.frame context r (ScriptStore020E5.image hn hc q)) hist
      (RegionSlot020E5.frame context r (ScriptStore020E5.image hn hc (round q xs))) := by
  obtain ⟨hist,ht⟩ := round_trace hn hc q xs
  exact ⟨hist.map (RegionSlot020E5.frame context r),RegionSlot020E5.trace context r ht⟩

end FT1536.S05.ScratchRound020E5
