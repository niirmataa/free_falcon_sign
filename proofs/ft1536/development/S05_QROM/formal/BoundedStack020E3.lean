import ArenaStack020E1

namespace FT1536.S05.BoundedStack020E3

structure Stack (A : Type) (capacity : Nat) where
  bank : Fin capacity → A
  sp : Fin (capacity+1)

def empty {A : Type} (capacity : Nat) (d : A) : Stack A capacity := ⟨fun _ => d,0⟩

def view {A : Type} {cap : Nat} (s : Stack A cap) : List A :=
  List.ofFn (fun j : Fin s.sp.val => s.bank ⟨s.sp.val-1-j.val,by have := s.sp.isLt;have := j.isLt;omega⟩)

def top {A : Type} {cap : Nat} (s : Stack A cap) : Option A :=
  if h : 0<s.sp.val then some (s.bank ⟨s.sp.val-1,by have := s.sp.isLt;omega⟩) else none

/-- Dead slots retain arbitrary data; only sp is changed by pop. -/
def drop {A : Type} {cap : Nat} (s : Stack A cap) (n : Nat) : Stack A cap :=
  {s with sp := ⟨s.sp.val-n,by have := s.sp.isLt;omega⟩}

def put {A : Type} {cap : Nat} (s : Stack A cap) (x : A) (room : s.sp.val<cap) : Stack A cap :=
  ⟨Function.update s.bank ⟨s.sp.val,room⟩ x,⟨s.sp.val+1,by omega⟩⟩

def push {A : Type} {cap : Nat} (s : Stack A cap) (x : A) : Option (Stack A cap) :=
  if room : s.sp.val<cap then some (put s x room) else none

/-- A short top-first prefix is pushed from its end. No live continuation
    is copied or converted to a list by this operation. -/
def pushMany {A : Type} {cap : Nat} (s : Stack A cap) : List A → Option (Stack A cap)
  | [] => some s
  | x::xs => (pushMany s xs).bind (fun t => push t x)

theorem view_length {A : Type} {cap : Nat} (s : Stack A cap) : (view s).length=s.sp.val := List.length_ofFn

theorem view_get {A : Type} {cap : Nat} (s : Stack A cap) (j : Nat) (hj : j<(view s).length) :
    (view s)[j]=s.bank ⟨s.sp.val-1-j,by have := s.sp.isLt;rw [view_length] at hj;omega⟩ := by
  simp only [view,List.getElem_ofFn]

theorem empty_view {A : Type} (cap : Nat) (d : A) : view (empty cap d)=[] := rfl

theorem top_cons {A : Type} {cap : Nat} (s : Stack A cap) (x : A) (xs : List A)
    (h : view s=x::xs) : top s=some x := by
  have hp : 0<s.sp.val := by have hl := view_length s;rw [h] at hl;simp only [List.length_cons] at hl;omega
  rw [top,dite_eq_left hp]
  apply congrArg some
  have hg := view_get s 0 (by rw [view_length];exact hp)
  simpa only [Nat.sub_zero,h,List.getElem_cons_zero] using hg.symm

theorem view_drop {A : Type} {cap : Nat} (s : Stack A cap) (n : Nat) :
    view (drop s n)=(view s).drop n := by
  apply List.ext_getElem
  · simp only [view_length,List.length_drop];rfl
  · intro j hj hj'
    simp only [view,List.getElem_ofFn,List.getElem_drop]
    apply congrArg s.bank
    apply Fin.ext
    have hsp := s.sp.isLt
    simp only [view_length,drop] at hj
    dsimp only [drop]
    omega

theorem view_put {A : Type} {cap : Nat} (s : Stack A cap) (x : A) (room : s.sp.val<cap) :
    view (put s x room)=x::view s := by
  apply List.ext_getElem
  · simp only [view_length,List.length_cons];rfl
  · intro j hj hj'
    cases j with
    | zero =>
      rw [view_get]
      change (Function.update s.bank ⟨s.sp.val,room⟩ x) ⟨s.sp.val+1-1-0,_⟩=x
      have hi : (⟨s.sp.val+1-1-0,by omega⟩ : Fin cap)=⟨s.sp.val,room⟩ := by apply Fin.ext;dsimp
      rw [hi];simp
    | succ j =>
      rw [view_get,List.getElem_cons_succ,view_get]
      change (Function.update s.bank ⟨s.sp.val,room⟩ x) ⟨s.sp.val+1-1-(j+1),_⟩=
        s.bank ⟨s.sp.val-1-j,_⟩
      have hj0 : j<s.sp.val := by simp only [view_length,put] at hj;omega
      have hi : (⟨s.sp.val+1-1-(j+1),by omega⟩ : Fin cap)≠⟨s.sp.val,room⟩ := by
        intro he;have hv := congrArg Fin.val he;dsimp at hv;omega
      rw [Function.update_of_ne hi]
      apply congrArg s.bank
      apply Fin.ext
      dsimp
      omega

theorem push_correct {A : Type} {cap : Nat} (s : Stack A cap) (x : A) (h : s.sp.val<cap) :
    push s x=some (put s x h) ∧ view (put s x h)=x::view s := by
  exact ⟨by rw [push,dite_eq_left h],view_put s x h⟩

theorem pushMany_correct {A : Type} {cap : Nat} (s : Stack A cap) (xs : List A)
    (room : xs.length+s.sp.val≤cap) :
    ∃ t,pushMany s xs=some t ∧ view t=xs++view s := by
  induction xs with
  | nil => exact ⟨s,rfl,rfl⟩
  | cons x xs ih =>
    obtain ⟨t,ht,hv⟩ := ih (by simp only [List.length_cons] at room;omega)
    have hlen : t.sp.val=xs.length+s.sp.val := by
      have he := congrArg List.length hv
      simpa only [view_length,List.length_append] using he
    have hp : t.sp.val<cap := by simp only [List.length_cons] at room;omega
    refine ⟨put t x hp,?_,?_⟩
    · rw [pushMany,ht,Option.bind_some,(push_correct t x hp).1]
    · rw [view_put,hv];rfl

theorem capacity {A : Type} {cap : Nat} (s : Stack A cap) : (view s).length≤cap := by
  rw [view_length];have := s.sp.isLt;omega

theorem full_reject {A : Type} {cap : Nat} (s : Stack A cap) (x : A) (h : s.sp.val=cap) : push s x=none := by
  rw [push,dite_eq_right (by omega)]

end FT1536.S05.BoundedStack020E3
