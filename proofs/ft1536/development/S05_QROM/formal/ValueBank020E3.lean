import ValueSlot020E3

namespace FT1536.S05.ValueBank020E3
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1

abbrev Values (cap : Nat) := Fin cap → Option Word

def lookup {cap : Nat} (a : Arena cap) (v : Values cap) (p : Ptr cap) : Option Word :=
  if h : p.val<a.used.val then v ⟨p.val,by have := a.used.isLt;omega⟩ else none

/-- Forward-only reads, with an explicit check even for arbitrary arenas. -/
def entry {cap : Nat} (a : Arena cap) (s : State) (v : Values cap) (k : Fin cap) : Option Word :=
  if k.val<a.used.val then
    (SyntaxCells020E.decode (a.bank k).cell).bind (fun t =>
      ValueSlot020E3.compute (fun p => if p.val<k.val then lookup a v p else none) s (a.bank k) t)
  else none

def advance {cap : Nat} (a : Arena cap) (s : State) (v : Values cap) (k : Fin cap) : Values cap :=
  Function.update v k (entry a s v k)

/-- Tail recursion represents a counted forward loop; no Expr call stack
    or dynamically growing collection of values is used. -/
def sweep {cap : Nat} (a : Arena cap) (s : State) : Nat → Nat → Values cap → Values cap
  | 0,_,v => v
  | fuel+1,j,v => if h : j<cap then sweep a s fuel (j+1) (advance a s v ⟨j,h⟩) else v

def build {cap : Nat} (a : Arena cap) (s : State) : Values cap := sweep a s cap 0 (fun _ => none)

def Prefix {cap : Nat} (a : Arena cap) (s : State) (mu : Meaning) (n : Nat) (v : Values cap) : Prop :=
  ∀ k : Fin cap,k.val<n → k.val<a.used.val → v k=ValueSlot020E3.value s (mu k.val)

theorem advance_correct {cap : Nat} (a : Arena cap) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (v : Values cap) (k : Fin cap) (hv : Prefix a s mu k.val v) :
    Prefix a s mu (k.val+1) (advance a s v k) := by
  intro j hj hju
  by_cases he : j=k
  · subst j
    obtain ⟨t,ht,hkids,hs⟩ := hh k hju
    simp only [advance,Function.update_self]
    rw [entry,ite_eq_left hju,ht,Option.bind_some]
    apply ValueSlot020E3.correct _ s (a.bank k) t mu (mu k.val) hs
    intro p hp
    have hpk := hkids p hp
    have hpu : p.val<a.used.val := hpk.trans hju
    rw [ite_eq_left hpk,lookup,dite_eq_left hpu]
    exact hv ⟨p.val,by have := a.used.isLt;omega⟩ hpk hpu
  · rw [advance,Function.update_of_ne he]
    apply hv j _ hju
    have hn : j.val≠k.val := fun h => he (Fin.ext h)
    omega

theorem sweep_correct {cap : Nat} (a : Arena cap) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (fuel start : Nat) (v : Values cap)
    (hv : Prefix a s mu start v) (room : start+fuel≤cap) :
    Prefix a s mu (start+fuel) (sweep a s fuel start v) := by
  induction fuel generalizing start v with
  | zero => simpa only [Nat.add_zero,sweep] using hv
  | succ fuel ih =>
    have hs : start<cap := by omega
    rw [sweep,dite_eq_left hs]
    have hp := advance_correct a s mu hh v ⟨start,hs⟩ hv
    have hr := ih (start+1) (advance a s v ⟨start,hs⟩) hp (by omega)
    convert hr using 1;omega

theorem build_correct {cap : Nat} (a : Arena cap) (s : State) (mu : Meaning) (hh : HeapValid a mu) :
    Prefix a s mu cap (build a s) := by
  simpa only [Nat.zero_add,build] using
    sweep_correct a s mu hh cap 0 (fun _ => none) (fun _ hk _ => by omega) (by omega)

theorem lookup_correct {cap : Nat} (a : Arena cap) (s : State) (mu : Meaning) (hh : HeapValid a mu)
    (p : Ptr cap) (hp : p.val<a.used.val) :
    lookup a (build a s) p=ValueSlot020E3.value s (mu p.val) := by
  rw [lookup,dite_eq_left hp]
  have hcap : p.val<cap := by have := a.used.isLt;omega
  exact build_correct a s mu hh ⟨p.val,hcap⟩ hcap hp

theorem unused_reject {cap : Nat} (a : Arena cap) (v : Values cap) (p : Ptr cap)
    (hp : a.used.val≤p.val) : lookup a v p=none := by
  rw [lookup,dite_eq_right (by omega)]

end FT1536.S05.ValueBank020E3
