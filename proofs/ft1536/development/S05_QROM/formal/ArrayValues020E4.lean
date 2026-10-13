import ArrayState020E4
import ArrayArena020E4
import ValueBank020E3

namespace FT1536.S05.ArrayValues020E4
open WordRAM020 ArenaTypes020E1 ArrayBank020E4

abbrev Values (cap : Nat) := Bank (Option Word) cap

def lookup {cap : Nat} (a : ArrayArena020E4.Arena cap) (v : Values cap) (p : Ptr cap) : Option Word :=
  if h : p.val<a.used.val then read v ⟨p.val,by have := a.used.isLt;omega⟩ else none

def entry {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : Values cap) (k : Fin cap) : Option Word :=
  if k.val<a.used.val then
    (SyntaxCells020E.decode (read a.bank k).cell).bind (fun t =>
      ValueSlot020E3.compute (fun p => if p.val<k.val then lookup a v p else none)
        (ArrayState020E4.model s) (read a.bank k) t)
  else none

def advance {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : Values cap) (k : Fin cap) : Values cap := write v k (entry a s v k)

def sweep {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State) :
    Nat → Nat → Values cap → Values cap
  | 0,_,v => v
  | fuel+1,j,v => if h : j<cap then sweep a s fuel (j+1) (advance a s v ⟨j,h⟩) else v

def build {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State) : Values cap :=
  sweep a s cap 0 (zero cap none)

theorem lookup_eq {cap : Nat} (a : ArrayArena020E4.Arena cap) (v : Values cap) (p : Ptr cap) :
    lookup a v p=ValueBank020E3.lookup (ArrayArena020E4.model a) (read v) p := rfl

theorem entry_eq {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : Values cap) (k : Fin cap) :
    entry a s v k=ValueBank020E3.entry (ArrayArena020E4.model a) (ArrayState020E4.model s) (read v) k := rfl

theorem advance_eq {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : Values cap) (k : Fin cap) :
    read (advance a s v k)=ValueBank020E3.advance (ArrayArena020E4.model a) (ArrayState020E4.model s) (read v) k := by
  rw [advance,read_write,entry_eq];rfl

theorem sweep_eq {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (fuel start : Nat) (v : Values cap) :
    read (sweep a s fuel start v)=ValueBank020E3.sweep (ArrayArena020E4.model a) (ArrayState020E4.model s) fuel start (read v) := by
  induction fuel generalizing start v with
  | zero => rfl
  | succ fuel ih =>
    simp only [sweep,ValueBank020E3.sweep]
    split
    · rw [ih,advance_eq]
    · rfl

theorem build_eq {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State) :
    read (build a s)=ValueBank020E3.build (ArrayArena020E4.model a) (ArrayState020E4.model s) := by
  rw [build,sweep_eq,zero,read_load]
  rfl

end FT1536.S05.ArrayValues020E4
