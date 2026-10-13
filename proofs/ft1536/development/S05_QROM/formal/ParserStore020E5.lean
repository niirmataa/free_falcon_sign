import ParserMachine020E5
import ParserEncoding020E5
import RegionSlot020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.ParserStore020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 ParserMachine020E5

abbrev Width (cap : Nat) := (cap*5+(cap*1+(1+1)))+(1+1)
def shape {cap n : Nat} (q : State cap n) := (q.arena,(q.cursor,q.bad))

theorem shape_injective {cap n : Nat} : Function.Injective (@shape cap n) := by
  intro a b h
  exact congrArg (fun p : ArrayArena020E4.Arena cap × (Fin (n+1) × Bool) => (⟨p.1,p.2.1,p.2.2⟩ : State cap n)) h

def controls (n : Nat) (hn : n<2^511) := pair (finCodec (n+1) (by omega)) boolCodec

def codec (cap n : Nat) (hc : cap<2^511) (hn : n<2^511) : Codec (State cap n) (Width cap) :=
  contramap (pair (ParserEncoding020E5.codec cap hc) (controls n hn)) shape shape_injective

def image {cap n : Nat} (hc : cap<2^511) (hn : n<2^511) (q : State cap n) := pack (codec cap n hc hn) q

def control {cap n : Nat} (hc : cap<2^511) (hn : n<2^511) (q : State cap n) (j : Fin (n+1)) (b : Bool) :
    Program (image hc hn q) (image hc hn {q with cursor:=j,bad:=b}) :=
  PairPatch020E5.second (ParserEncoding020E5.codec cap hc) (controls n hn) q.arena
    (overwrite (pack (controls n hn) (q.cursor,q.bad)) (pack (controls n hn) (j,b)))

def commit {cap n : Nat} (hc : cap<2^511) (hn : n<2^511) (q : State cap n) (d : ParserDecision020E5.Change cap) :
    Program (image hc hn q) (image hc hn {q with arena:=ParserDecision020E5.apply q.arena d}) :=
  PairPatch020E5.first (ParserEncoding020E5.codec cap hc) (controls n hn) (q.cursor,q.bad)
    (ParserEncoding020E5.commit hc q.arena d)

def program {cap n : Nat} (hc : cap<2^511) (hn : n<2^511) (c : SyntaxCells020E.Cell) (q : State cap n) :
    Program (image hc hn q) (image hc hn (step c q)) :=
  match hd : decision c q with
  | none =>
    let p := control hc hn q (cursorNext q.cursor) true
    ⟨p.code,by rw [step,hd];exact p.correct⟩
  | some d =>
    let p := thenDo (commit hc hn q d)
      (control hc hn {q with arena:=ParserDecision020E5.apply q.arena d} (cursorNext q.cursor) false)
    ⟨p.code,by rw [step,hd];exact p.correct⟩

theorem control_length {cap n : Nat} (hc : cap<2^511) (hn : n<2^511) (q : State cap n) (j : Fin (n+1)) (b : Bool) :
    (control hc hn q j b).code.length=2 := by
  simp only [control,PairPatch020E5.second,WordJoin020E5.liftRight,overwrite]
  simp only [List.length_map,List.length_ofFn]

theorem commit_length {cap n : Nat} (hc : cap<2^511) (hn : n<2^511) (q : State cap n) (d : ParserDecision020E5.Change cap) :
    (commit hc hn q d).code.length=8 := by
  simp only [commit,PairPatch020E5.first,WordJoin020E5.liftLeft]
  simp only [List.length_map]
  exact ParserEncoding020E5.commit_length hc q.arena d

theorem length_bound {cap n : Nat} (hc : cap<2^511) (hn : n<2^511) (c : SyntaxCells020E.Cell) (q : State cap n) :
    (program hc hn c q).code.length≤10 := by
  unfold program
  split <;> simp only [thenDo,List.length_append,control_length,commit_length] <;> omega

theorem run_trace {cap n : Nat} (hc : cap<2^511) (hn : n<2^511)
    (cs : List SyntaxCells020E.Cell) (q : State cap n) (context : RegionRam020E5.Heap) (r : Fin context.size) :
    ∃ hist,RegionRam020E5.Steps (RegionSlot020E5.frame context r (image hc hn q)) hist
      (RegionSlot020E5.frame context r (image hc hn (run cs q))) := by
  induction cs generalizing q with
  | nil => exact ⟨[],.nil _⟩
  | cons c cs ih =>
    let p := program hc hn c q
    obtain ⟨front,hf,_⟩ := WordPatch020E5.has_trace p.code (image hc hn q)
    have hf' := RegionSlot020E5.trace context r hf
    rw [p.correct] at hf'
    obtain ⟨tail,ht⟩ := ih (step c q)
    exact ⟨front.map (RegionSlot020E5.frame context r)++tail,RegionTrace020E5.append hf' ht⟩

end FT1536.S05.ParserStore020E5
