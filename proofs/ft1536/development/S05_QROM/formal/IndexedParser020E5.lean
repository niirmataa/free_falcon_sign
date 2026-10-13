import ParserStore020E5

namespace FT1536.S05.IndexedParser020E5
open ArrayBank020E4 ParserMachine020E5

/-- The instruction source is a resident fixed bank, addressed by the parser
    cursor. No suffix lists or recursive parser continuations are live data. -/
def step {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) (q : State cap n) : State cap n :=
  if h : q.cursor.val<n then ParserMachine020E5.step (read code ⟨q.cursor.val,h⟩) q else q

def run {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) : Nat → State cap n → State cap n
  | 0,q => q
  | fuel+1,q => run code fuel (step code q)

def meaning {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) (q : State cap n) :=
  ParserMachine020E5.run ((List.ofFn (read code)).drop q.cursor.val) q

theorem step_meaning {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) (q : State cap n) :
    meaning code (step code q)=meaning code q := by
  unfold step
  split
  · rename_i h
    have hl : q.cursor.val<(List.ofFn (read code)).length := by simpa only [List.length_ofFn] using h
    unfold meaning
    rw [ParserMachine020E5.step_cursor]
    simp only [cursorNext,min_eq_right (by omega : q.cursor.val+1≤n)]
    rw [List.drop_eq_getElem_cons hl,List.getElem_ofFn]
    rfl
  · rfl

theorem run_meaning {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) (fuel : Nat) (q : State cap n) :
    meaning code (run code fuel q)=meaning code q := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih => exact (ih (step code q)).trans (step_meaning code q)

theorem step_cursor {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) (q : State cap n) :
    (step code q).cursor.val=min n (q.cursor.val+1) := by
  unfold step
  split
  · rw [ParserMachine020E5.step_cursor];rfl
  · have := q.cursor.isLt;omega

theorem done {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) (fuel : Nat) (q : State cap n) (h : n-q.cursor.val≤fuel) :
    (run code fuel q).cursor.val=n := by
  induction fuel generalizing q with
  | zero => change q.cursor.val=n;have := q.cursor.isLt;omega
  | succ fuel ih => apply ih;rw [step_cursor];omega

theorem terminal_meaning {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) (q : State cap n) (h : q.cursor.val=n) :
    meaning code q=q := by
  have hl : (List.ofFn (read code)).length≤n := by rw [List.length_ofFn]
  rw [meaning,h,List.drop_eq_nil_of_le hl]
  rfl

theorem executes {cap n : Nat} (code : Bank SyntaxCells020E.Cell n) :
    run code n (start cap n)=ParserMachine020E5.run (List.ofFn (read code)) (start cap n) := by
  have hm := run_meaning code n (start cap n)
  rw [terminal_meaning _ _ (done _ _ _ (by exact le_rfl))] at hm
  exact hm

theorem run_trace {cap n : Nat} (hc : cap<2^511) (hn : n<2^511)
    (code : Bank SyntaxCells020E.Cell n) (fuel : Nat) (q : State cap n) (context : RegionRam020E5.Heap) (r : Fin context.size) :
    ∃ hist,RegionRam020E5.Steps (RegionSlot020E5.frame context r (ParserStore020E5.image hc hn q)) hist
      (RegionSlot020E5.frame context r (ParserStore020E5.image hc hn (run code fuel q))) := by
  induction fuel generalizing q with
  | zero => exact ⟨[],.nil _⟩
  | succ fuel ih =>
    change ∃ hist,RegionRam020E5.Steps _ hist (RegionSlot020E5.frame context r (ParserStore020E5.image hc hn (run code fuel (step code q))))
    unfold step
    split
    · rename_i h
      let c := read code ⟨q.cursor.val,h⟩
      obtain ⟨front,hf⟩ := ParserStore020E5.run_trace hc hn [c] q context r
      obtain ⟨tail,ht⟩ := ih (ParserMachine020E5.step c q)
      exact ⟨front++tail,RegionTrace020E5.append hf ht⟩
    · exact ih q

end FT1536.S05.IndexedParser020E5
