import ScriptMachine020E5
import PairPatch020E5
import RegionSlot020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.ScriptStore020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 ScriptMachine020E5

def optionShape {A : Type} : Option A → Unit ⊕ A | none => .inl () | some x => .inr x

theorem option_injective {A : Type} : Function.Injective (@optionShape A) := by
  intro a b h
  cases a <;> cases b <;> simp_all [optionShape]

def writeCodec (n : Nat) (hn : n≤2^511) : Codec (Option (WordPatch020E5.Write n)) 3 :=
  contramap (sum unit (pair (finCodec n hn) wordCodec)) optionShape option_injective

def controls (n capacity : Nat) (hn : n≤2^511) (hc : capacity<2^511) :=
  pair (bank (writeCodec n hn) capacity) (finCodec (capacity+1) (by omega))

def shape {n capacity : Nat} (q : State n capacity) := (q.target,(q.script,q.cursor))

theorem shape_injective {n capacity : Nat} : Function.Injective (@shape n capacity) := by
  intro a b h
  exact congrArg (fun p : Bank Word n × (ScriptBuffer020E5.Buffer n capacity × Fin (capacity+1)) =>
    (⟨p.1,p.2.1,p.2.2⟩ : State n capacity)) h

def codec (n capacity : Nat) (hn : n≤2^511) (hc : capacity<2^511) : Codec (State n capacity) (n*1+(capacity*3+1)) :=
  contramap (pair (bank wordCodec n) (controls n capacity hn hc)) shape shape_injective

def image {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) := pack (codec n capacity hn hc) q

def put {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) (j : Fin n) (v : Word) :
    Program (image hn hc q) (image hn hc {q with target:=write q.target j v}) :=
  PairPatch020E5.first (bank wordCodec n) (controls n capacity hn hc) (q.script,q.cursor)
    (cell wordCodec q.target j v)

def cursor {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) (j : Fin (capacity+1)) :
    Program (image hn hc q) (image hn hc {q with cursor:=j}) :=
  PairPatch020E5.second (bank wordCodec n) (controls n capacity hn hc) q.target
    (PairPatch020E5.second (bank (writeCodec n hn) capacity) (finCodec (capacity+1) (by omega)) q.script
      (overwrite (pack (finCodec (capacity+1) (by omega)) q.cursor) (pack (finCodec (capacity+1) (by omega)) j)))

def program {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) :
    Program (image hn hc q) (image hn hc (step q)) :=
  if h : q.cursor.val<capacity then
    let next : Fin (capacity+1) := ⟨q.cursor.val+1,by omega⟩
    match he : read q.script ⟨q.cursor.val,h⟩ with
    | none =>
      let p := cursor hn hc q next
      ⟨p.code,by rw [step,dite_eq_left h,he];exact p.correct⟩
    | some w =>
      let p := thenDo (put hn hc q w.1 w.2) (cursor hn hc {q with target:=write q.target w.1 w.2} next)
      ⟨p.code,by rw [step,dite_eq_left h,he];exact p.correct⟩
  else ⟨[],by rw [step,dite_eq_right h];rfl⟩

theorem put_length {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) (j : Fin n) (v : Word) :
    (put hn hc q j v).code.length=1 := by
  simp only [put,PairPatch020E5.first,WordJoin020E5.liftLeft,cell,List.length_map,List.length_ofFn]

theorem cursor_length {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) (j : Fin (capacity+1)) :
    (cursor hn hc q j).code.length=1 := by
  simp only [cursor,PairPatch020E5.second,WordJoin020E5.liftRight,overwrite]
  simp only [List.length_map,List.length_ofFn]

theorem length_bound {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511) (q : State n capacity) :
    (program hn hc q).code.length≤2 := by
  unfold program
  split
  · dsimp only
    split <;> simp only [thenDo,List.length_append,put_length,cursor_length] <;> omega
  · simp only [List.length_nil];omega

theorem run_trace {n capacity : Nat} (hn : n≤2^511) (hc : capacity<2^511)
    (fuel : Nat) (q : State n capacity) (context : RegionRam020E5.Heap) (r : Fin context.size) :
    ∃ hist,RegionRam020E5.Steps (RegionSlot020E5.frame context r (image hn hc q)) hist
      (RegionSlot020E5.frame context r (image hn hc (run fuel q))) := by
  induction fuel generalizing q with
  | zero => exact ⟨[],.nil _⟩
  | succ fuel ih =>
    let p := program hn hc q
    obtain ⟨front,hf,_⟩ := WordPatch020E5.has_trace p.code (image hn hc q)
    have hf' := RegionSlot020E5.trace context r hf
    rw [p.correct] at hf'
    obtain ⟨tail,ht⟩ := ih (step q)
    exact ⟨front.map (RegionSlot020E5.frame context r)++tail,RegionTrace020E5.append hf' ht⟩

end FT1536.S05.ScriptStore020E5
