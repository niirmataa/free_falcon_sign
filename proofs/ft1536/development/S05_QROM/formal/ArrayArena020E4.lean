import ArrayBank020E4
import ArenaParse020E1

namespace FT1536.S05.ArrayArena020E4
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArrayBank020E4

structure Arena (cap : Nat) where
  bank : Bank (Node cap) cap
  stack : Bank (Ptr cap) cap
  used : Ptr cap
  sp : Ptr cap

def model {cap : Nat} (a : Arena cap) : ArenaTypes020E1.Arena cap :=
  ⟨read a.bank,read a.stack,a.used,a.sp⟩

def empty (cap : Nat) : Arena cap := ⟨zero cap (emptyNode cap),zero cap 0,0,0⟩

def commit {cap : Nat} (a : Arena cap) (t : Token) (hu : a.used.val<cap)
    (hr : a.sp.val-arity t<cap) : Arena cap :=
  ⟨write a.bank ⟨a.used.val,hu⟩ (ArenaStackRead020E1.freshNode (model a) t),
   write a.stack ⟨a.sp.val-arity t,hr⟩ a.used,
   ⟨a.used.val+1,by omega⟩,⟨a.sp.val-arity t+1,by omega⟩⟩

def step {cap : Nat} (t : Token) (a : Arena cap) : Option (Arena cap) :=
  if hu : a.used.val<cap then
    if arity t≤a.sp.val then
      if hr : a.sp.val-arity t<cap then
        if (children t (ArenaStackRead020E1.freshNode (model a) t)).map (ArenaStep020E1.checkedKind (model a))=(needs t).map some then
          some (commit a t hu hr)
        else none
      else none
    else none
  else none

def stepCell {cap : Nat} (cell : SyntaxCells020E.Cell) (a : Arena cap) : Option (Arena cap) :=
  (SyntaxCells020E.decode cell).bind (fun t => step t a)

def parse {cap : Nat} : List SyntaxCells020E.Cell → Arena cap → Option (Arena cap)
  | [],a => some a
  | c::cs,a => (stepCell c a).bind (parse cs)

theorem empty_eq (cap : Nat) : model (empty cap)=ArenaTypes020E1.empty cap := by
  simp only [model,empty,zero,read_load,ArenaTypes020E1.empty]

theorem commit_eq {cap : Nat} (a : Arena cap) (t : Token) (hu : a.used.val<cap)
    (hr : a.sp.val-arity t<cap) : model (commit a t hu hr)=ArenaStep020E1.commit (model a) t hu hr := by
  simp only [model,commit,read_write,ArenaStep020E1.commit,ArenaHeap020E1.putNode,ArenaStack020E1.replace]

theorem step_eq {cap : Nat} (a : Arena cap) (t : Token) :
    (step t a).map model=ArenaStep020E1.step t (model a) := by
  unfold step ArenaStep020E1.step
  conv_lhs => simp only [apply_dite,apply_ite,Option.map_some,Option.map_none,commit_eq]
  rfl

theorem stepCell_eq {cap : Nat} (a : Arena cap) (cell : SyntaxCells020E.Cell) :
    (stepCell cell a).map model=ArenaStep020E1.stepCell cell (model a) := by
  unfold stepCell ArenaStep020E1.stepCell
  cases hd : SyntaxCells020E.decode cell
  · rfl
  · exact step_eq a _

theorem parse_eq {cap : Nat} (a : Arena cap) (cs : List SyntaxCells020E.Cell) :
    (parse cs a).map model=ArenaParse020E1.runCells cs (model a) := by
  induction cs generalizing a with
  | nil => rfl
  | cons c cs ih =>
    have h := stepCell_eq a c
    cases hr : stepCell c a with
    | none =>
      rw [hr,Option.map_none] at h
      rw [parse,hr,Option.bind_none,Option.map_none,ArenaParse020E1.runCells,←h]
      rfl
    | some q =>
      rw [hr,Option.map_some] at h
      rw [parse,hr,Option.bind_some,ArenaParse020E1.runCells,←h,Option.bind_some]
      exact ih q

end FT1536.S05.ArrayArena020E4
