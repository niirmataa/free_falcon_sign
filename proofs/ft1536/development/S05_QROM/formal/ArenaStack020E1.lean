import ArenaTypes020E1
import Mathlib.Data.List.OfFn

namespace FT1536.S05.ArenaStack020E1
open ArenaTypes020E1

/-- Read one checked stack address, counting from the top. -/
def peek {cap : Nat} (s : Arena cap) (j : Nat) : Ptr cap :=
  if h : j<s.sp.val then s.stack ⟨s.sp.val-1-j,by have := s.sp.isLt;omega⟩ else 0

def view {cap : Nat} (s : Arena cap) : List (Ptr cap) :=
  List.ofFn (fun j : Fin s.sp.val => s.stack ⟨s.sp.val-1-j.val,by have := s.sp.isLt;have := j.isLt;omega⟩)

/-- Pop n and push p using one fixed-bank write. The room test is explicit. -/
def replace {cap : Nat} (s : Arena cap) (n : Nat) (p : Ptr cap)
    (room : s.sp.val-n<cap) : Arena cap :=
  { s with
    stack := Function.update s.stack ⟨s.sp.val-n,room⟩ p
    sp := ⟨s.sp.val-n+1,by omega⟩ }

theorem view_length {cap : Nat} (s : Arena cap) : (view s).length=s.sp.val := List.length_ofFn

theorem view_get {cap : Nat} (s : Arena cap) (j : Nat) (hj : j<(view s).length) :
    (view s)[j]=peek s j := by
  have h : j<s.sp.val := by simpa only [view_length] using hj
  simp only [view,List.getElem_ofFn,peek,dite_eq_left h]

theorem replace_zero {cap : Nat} (s : Arena cap) (n : Nat) (p : Ptr cap)
    (room : s.sp.val-n<cap) : peek (replace s n p room) 0=p := by
  unfold peek
  rw [dite_eq_left (show 0<(replace s n p room).sp.val by change 0<s.sp.val-n+1;omega)]
  have idx : (⟨(s.sp.val-n+1)-1-0,by omega⟩:Fin cap)=⟨s.sp.val-n,room⟩ := by
    apply Fin.ext;dsimp
  change (Function.update s.stack ⟨s.sp.val-n,room⟩ p) ⟨(s.sp.val-n+1)-1-0,_⟩=p
  rw [idx]
  simp

theorem replace_succ {cap : Nat} (s : Arena cap) (n : Nat) (p : Ptr cap)
    (hn : n≤s.sp.val) (room : s.sp.val-n<cap) (j : Nat) (hj : j<s.sp.val-n) :
    peek (replace s n p room) (j+1)=peek s (n+j) := by
  have hnew : j+1<(replace s n p room).sp.val := by change j+1<s.sp.val-n+1;omega
  have hold : n+j<s.sp.val := by omega
  simp only [peek,dite_eq_left hnew,dite_eq_left hold]
  change (Function.update s.stack ⟨s.sp.val-n,room⟩ p) ⟨s.sp.val-n+1-1-(j+1),_⟩=
    s.stack ⟨s.sp.val-1-(n+j),_⟩
  have ne : (⟨s.sp.val-n+1-1-(j+1),by omega⟩:Fin cap)≠⟨s.sp.val-n,room⟩ := by
    intro h;have he := congrArg Fin.val h;dsimp at he;omega
  rw [Function.update_of_ne ne]
  apply congrArg s.stack
  apply Fin.ext
  dsimp
  omega

theorem view_replace {cap : Nat} (s : Arena cap) (n : Nat) (p : Ptr cap)
    (hn : n≤s.sp.val) (room : s.sp.val-n<cap) :
    view (replace s n p room)=p::(view s).drop n := by
  apply List.ext_getElem
  · simp only [view_length,List.length_cons,List.length_drop]
    rfl
  · intro j hj hj'
    rw [view_get]
    cases j with
    | zero => exact replace_zero s n p room
    | succ j =>
      rw [List.getElem_cons_succ,List.getElem_drop,view_get]
      exact replace_succ s n p hn room j (by simp only [view_length,replace] at hj;omega)

theorem empty_view (cap : Nat) : view (empty cap)=[] := rfl

end FT1536.S05.ArenaStack020E1
