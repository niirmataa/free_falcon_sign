import FillMachine020E5
import PairPatch020E5
import RegionSlot020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.FillStore020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 FillMachine020E5

def shape {A : Type} {n : Nat} (q : FillMachine020E5.State A n) := (q.bank,q.cursor)

theorem shape_injective {A : Type} {n : Nat} : Function.Injective (@shape A n) := by
  intro a b h
  have ha : (⟨(shape a).1,(shape a).2⟩ : FillMachine020E5.State A n)=a := rfl
  have hb : (⟨(shape b).1,(shape b).2⟩ : FillMachine020E5.State A n)=b := rfl
  exact ha.symm.trans ((congrArg (fun p : Bank A n × Fin (n+1) => (⟨p.1,p.2⟩ : FillMachine020E5.State A n)) h).trans hb)

def codec {A : Type} {n w : Nat} (c : Codec A w) (hn : n<2^511) : Codec (FillMachine020E5.State A n) (n*w+1) :=
  contramap (pair (bank c n) (finCodec (n+1) (by omega))) shape shape_injective

def image {A : Type} {n w : Nat} (c : Codec A w) (hn : n<2^511) (q : FillMachine020E5.State A n) := pack (codec c hn) q

def code {A : Type} {n w : Nat} (c : Codec A w) (f : Fin n → A) (q : FillMachine020E5.State A n) :
    List (WordPatch020E5.Write (n*w+1)) :=
  if h : q.cursor.val<n then
    (List.ofFn (fun j : Fin w => (Fin.castAdd 1 (finProdFinEquiv ((⟨q.cursor.val,h⟩ : Fin n),j)),c.encode (f ⟨q.cursor.val,h⟩) j))) ++
      [(Fin.natAdd (n*w) (0 : Fin 1),word (q.cursor.val+1))]
  else []

theorem realizes {A : Type} {n w : Nat} (c : Codec A w) (hn : n<2^511) (f : Fin n → A) (q : FillMachine020E5.State A n) :
    WordPatch020E5.apply (code c f q) (image c hn q)=image c hn (FillMachine020E5.step f q) := by
  unfold code FillMachine020E5.step
  split
  · rename_i h
    let j : Fin n := ⟨q.cursor.val,h⟩
    let nextCursor : Fin (n+1) := ⟨q.cursor.val+1,by omega⟩
    let fc := finCodec (n+1) (show n+1≤2^511 by omega)
    let p := PairPatch020E5.first (bank c n) fc q.cursor (cell c q.bank j (f j))
    let r := PairPatch020E5.second (bank c n) fc (write q.bank j (f j))
      (overwrite (pack fc q.cursor) (pack fc nextCursor))
    have hc := (thenDo p r).correct
    have hp : p.code=List.ofFn (fun k : Fin w => (Fin.castAdd 1 (finProdFinEquiv (j,k)),c.encode (f j) k)) := by
      simp only [p,PairPatch020E5.first,WordJoin020E5.liftLeft,cell,List.map_ofFn,Function.comp_def]
    have hr : r.code=[(Fin.natAdd (n*w) (0 : Fin 1),word (q.cursor.val+1))] := by
      simp only [r,PairPatch020E5.second,WordJoin020E5.liftRight,overwrite,pack,read_load,fc,finCodec,nextCursor]
      rfl
    simp only [thenDo,hp,hr] at hc
    exact hc
  · rfl

theorem length_bound {A : Type} {n w : Nat} (c : Codec A w) (f : Fin n → A) (q : FillMachine020E5.State A n) :
    (code c f q).length≤w+1 := by
  unfold code
  split <;> simp only [List.length_append,List.length_ofFn,List.length_cons,List.length_nil] <;> omega

theorem fill_trace {A : Type} {n w : Nat} (c : Codec A w) (hn : n<2^511) (f : Fin n → A)
    (fuel : Nat) (q : FillMachine020E5.State A n) (context : RegionRam020E5.Heap) (r : Fin context.size) :
    ∃ hist,RegionRam020E5.Steps (RegionSlot020E5.frame context r (image c hn q)) hist
      (RegionSlot020E5.frame context r (image c hn (FillMachine020E5.run f fuel q))) := by
  induction fuel generalizing q with
  | zero => exact ⟨[],.nil _⟩
  | succ fuel ih =>
    obtain ⟨front,hf,_⟩ := WordPatch020E5.has_trace (code c f q) (image c hn q)
    have hf' := RegionSlot020E5.trace context r hf
    rw [realizes] at hf'
    obtain ⟨tail,ht⟩ := ih (FillMachine020E5.step f q)
    exact ⟨front.map (RegionSlot020E5.frame context r)++tail,RegionTrace020E5.append hf' ht⟩

end FT1536.S05.FillStore020E5
