import CDF
namespace ScalarIID
def descendingFrom : Nat → List Nat → Prop
  | _,[] => True
  | p,t::ts => t≤p ∧ descendingFrom t ts
def massSum : Nat → List Nat → Nat
  | p,[] => p
  | p,t::ts => (p-t)+massSum t ts
theorem mass_telescopes (p : Nat) (ts : List Nat) (h : descendingFrom p ts) : massSum p ts=p := by
  induction ts generalizing p with
  | nil => rfl
  | cons t ts ih =>
    obtain ⟨ht,hs⟩:=h
    simp only [massSum,ih t hs];omega
def countAbove (u : Nat) : List Nat → Nat
  | []=>0
  | t::ts=>(if u<t then 1 else 0)+countAbove u ts
theorem count_append (u : Nat) (a b : List Nat) : countAbove u (a++b)=countAbove u a+countAbove u b := by
  induction a with
  | nil => simp [countAbove]
  | cons x xs ih => simp only [List.cons_append,countAbove,ih,Nat.add_assoc]
theorem count_all (u : Nat) (ts : List Nat) (h : ∀t∈ts,u<t) : countAbove u ts=ts.length := by
  induction ts with
  | nil => rfl
  | cons t ts ih =>
    have ht:=h t (by simp)
    have hs : ∀x∈ts,u<x := by intro x hx;exact h x (by simp [hx])
    simp only [countAbove,ite_eq_left ht,ih hs,List.length_cons];omega
theorem count_none (u : Nat) (ts : List Nat) (h : ∀t∈ts,t≤u) : countAbove u ts=0 := by
  induction ts with
  | nil => rfl
  | cons t ts ih =>
    have ht:=h t (by simp)
    have hs : ∀x∈ts,x≤u := by intro x hx;exact h x (by simp [hx])
    simp only [countAbove,ite_eq_right (show ¬u<t by omega),ih hs,Nat.add_zero]
theorem atom_partition (u : Nat) (a b : List Nat)
    (ha : ∀t∈a,u<t) (hb : ∀t∈b,t≤u) : countAbove u (a++b)=a.length := by
  rw [count_append,count_all u a ha,count_none u b hb,Nat.add_zero]
theorem threshold_strict (t : Nat) : ¬t<t := by omega
theorem sign_outputs_disjoint (s : Int) (k l : Nat) : s-(k:Int)≠s+1+(l:Int) := by omega
theorem small_atom_mass : (9658096583921298676775519021886532885:Nat)>2^122 := by decide
end ScalarIID
