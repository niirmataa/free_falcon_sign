import CostBounds020E4
import CostBank020E4
import ArrayState020E4
import InputLayout020

set_option exponentiation.threshold 512
namespace FT1536.S05.CostInput020E4
open WordRAM020 CostRun020E4 CostFlow020E4 FT1536.Relation

/-- Operational public input: a dense array of the same 768 coefficient pairs. -/
abbrev Key := ArrayBank020E4.Bank (ZMod 18433 × ZMod 18433) 768
def key (k : Key) : Rq := ArrayBank020E4.read k

/-- Checked raw Array read. Width is supplied by its concrete caller. -/
def rawRead {A : Type} (w : Nat) (a : Array A) (i : Nat) (fallback : A) : Run A :=
  charge (w+2) (w+2) (a.getD i fallback)

/-- Two-level access into pinned public literal tables; no CDF generation. -/
def tableRead (chunks : Array (Array Nat)) (i : Nat) : Run Word := overhead 4
  (CostRun020E4.bind (rawRead 1 chunks (i/256) #[]) (fun row =>
    CostRun020E4.bind (rawRead 1 row (i%256) 0) (fun n => charge 1 1 (word n))))

def romCell (k : Key) (a : Fin romSize) : Run Word := overhead 8
  (if hc : a.val<30721 then tableRead TableData016.cdfChunks a.val else
   if ht : a.val<92162 then tableRead TableData016.thresholdChunks (a.val-30721) else
   if hk : a.val-92162<768 then
     CostRun020E4.bind (CostBank020E4.read 2 k ⟨a.val-92162,hk⟩) (fun pair => charge 2 2 (word pair.1.val))
   else CostRun020E4.bind (CostBank020E4.read 2 k ⟨a.val-92930,by have := a.isLt;simp only [romSize] at this;omega⟩)
     (fun pair => charge 2 2 (word pair.2.val)))

/-- MODEL: one ideal bit draw, coupled to its unique coordinate in the full
    coin assignment. No hash/PRG or arbitrary key-function evaluation here. -/
def draw (coins : Fin tapeSize → Bool) (j : Fin tapeSize) : Run Bool := charge 1 1 (coins j)

def inputs (k : Key) (coins : Fin tapeSize → Bool) : Run ArrayState020E4.Input := overhead 4
  (CostRun020E4.bind (CostBank020E4.tabulate 1 (draw coins)) (fun tape =>
    CostRun020E4.map (fun rom => ⟨tape,rom⟩) (CostBank020E4.tabulate 1 (romCell k))))

def price : Nat := 4+((4+tapeSize*5+tapeSize*1)+(4+romSize*5+romSize*20))

theorem table_value (chunks : Array (Array Nat)) (i : Nat) :
    (tableRead chunks i).value=word ((chunks.getD (i/256) #[]).getD (i%256) 0) := rfl

theorem table_budget (chunks : Array (Array Nat)) (i : Nat) :
    (tableRead chunks i).ticks=11 ∧ (tableRead chunks i).allocated=11 := ⟨rfl,rfl⟩

theorem rom_value (k : Key) (a : Fin romSize) : (romCell k a).value=InputLayout020.image (key k) a := by
  unfold romCell InputLayout020.image
  split
  · simp only [overhead_value,table_value,StandaloneRuntime019.tables,TableData016.cdf]
  · split
    · simp only [overhead_value,table_value,StandaloneRuntime019.tables,TableData016.threshold]
    · split <;> rfl

theorem rom_bound (k : Key) (a : Fin romSize) : Bounded (romCell k a) 20 20 := by
  unfold romCell
  split
  · exact ⟨by change 19≤20;omega,by change 19≤20;omega⟩
  · split
    · exact ⟨by change 19≤20;omega,by change 19≤20;omega⟩
    · split <;> exact ⟨by change 14≤20;omega,by change 14≤20;omega⟩

theorem value (k : Key) (coins : Fin tapeSize → Bool) :
    (inputs k coins).value=ArrayState020E4.loadInput (InputLayout020.encode (key k) coins) := by
  simp only [inputs,overhead_value,CostRun020E4.bind_value,CostRun020E4.map,CostBank020E4.tabulate,draw,charge,rom_value]
  rfl

theorem bound (k : Key) (coins : Fin tapeSize → Bool) : Bounded (inputs k coins) price price := by
  apply overhead_bound 4 _ _
  apply bind_bound _ _ (4+tapeSize*5+tapeSize*1) (4+tapeSize*5+tapeSize*1)
      (4+romSize*5+romSize*20) (4+romSize*5+romSize*20)
  · exact CostBank020E4.tabulate_bound 1 1 1 (draw coins) (fun _ => ⟨le_rfl,le_rfl⟩)
  · intro tape
    exact CostBank020E4.tabulate_bound 1 20 20 (romCell k) (rom_bound k)

theorem same_key (h : Rq) : key (ArrayBank020E4.load h)=h := ArrayBank020E4.read_load h

end FT1536.S05.CostInput020E4
