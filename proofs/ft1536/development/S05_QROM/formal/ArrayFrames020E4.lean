import ArrayBank020E4

namespace FT1536.S05.ArrayFrames020E4
open ArrayBank020E4

structure Stack (A : Type) (cap : Nat) where
  bank : Bank A cap
  sp : Fin (cap+1)

def model {A : Type} {cap : Nat} (s : Stack A cap) : BoundedStack020E3.Stack A cap := ⟨read s.bank,s.sp⟩
def empty {A : Type} (cap : Nat) (d : A) : Stack A cap := ⟨zero cap d,0⟩
def top {A : Type} {cap : Nat} (s : Stack A cap) : Option A :=
  if h : 0<s.sp.val then some (read s.bank ⟨s.sp.val-1,by have := s.sp.isLt;omega⟩) else none

def drop {A : Type} {cap : Nat} (s : Stack A cap) (n : Nat) : Stack A cap :=
  {s with sp := ⟨s.sp.val-n,by have := s.sp.isLt;omega⟩}

def put {A : Type} {cap : Nat} (s : Stack A cap) (x : A) (room : s.sp.val<cap) : Stack A cap :=
  ⟨write s.bank ⟨s.sp.val,room⟩ x,⟨s.sp.val+1,by omega⟩⟩

def push {A : Type} {cap : Nat} (s : Stack A cap) (x : A) : Option (Stack A cap) :=
  if room : s.sp.val<cap then some (put s x room) else none

def pushMany {A : Type} {cap : Nat} (s : Stack A cap) : List A → Option (Stack A cap)
  | [] => some s
  | x::xs => (pushMany s xs).bind (fun t => push t x)

theorem empty_eq {A : Type} (cap : Nat) (d : A) : model (empty cap d)=BoundedStack020E3.empty cap d := by
  simp only [model,empty,zero,read_load,BoundedStack020E3.empty]

theorem top_eq {A : Type} {cap : Nat} (s : Stack A cap) : top s=BoundedStack020E3.top (model s) := rfl

theorem drop_eq {A : Type} {cap : Nat} (s : Stack A cap) (n : Nat) :
    model (drop s n)=BoundedStack020E3.drop (model s) n := rfl

theorem put_eq {A : Type} {cap : Nat} (s : Stack A cap) (x : A) (room : s.sp.val<cap) :
    model (put s x room)=BoundedStack020E3.put (model s) x room := by
  simp only [model,put,read_write,BoundedStack020E3.put]

theorem push_eq {A : Type} {cap : Nat} (s : Stack A cap) (x : A) :
    (push s x).map model=BoundedStack020E3.push (model s) x := by
  unfold push BoundedStack020E3.push
  change (if room : s.sp.val<cap then some (put s x room) else none).map model=
    if room : s.sp.val<cap then some (BoundedStack020E3.put (model s) x room) else none
  split <;> simp only [Option.map_some,Option.map_none,put_eq]

theorem pushMany_eq {A : Type} {cap : Nat} (s : Stack A cap) (xs : List A) :
    (pushMany s xs).map model=BoundedStack020E3.pushMany (model s) xs := by
  induction xs generalizing s with
  | nil => rfl
  | cons x xs ih =>
    have h := ih s
    cases hr : pushMany s xs with
    | none =>
      rw [hr,Option.map_none] at h
      rw [pushMany,hr,Option.bind_none,Option.map_none,BoundedStack020E3.pushMany,←h]
      rfl
    | some t =>
      rw [hr,Option.map_some] at h
      rw [pushMany,hr,Option.bind_some,BoundedStack020E3.pushMany,←h,Option.bind_some,push_eq]

end FT1536.S05.ArrayFrames020E4
