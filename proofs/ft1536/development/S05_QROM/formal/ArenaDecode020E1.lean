import ArenaInvariant020E1

namespace FT1536.S05.ArenaDecode020E1
open SyntaxTape020E ArenaTypes020E1 ArenaToken020E1 ArenaStack020E1 ArenaHeap020E1 ArenaInvariant020E1

def gather {A B : Type} (f : A → Option B) : List A → Option (List B)
  | [] => some []
  | x::xs => (f x).bind (fun v => (gather f xs).map (fun vs => v::vs))

theorem gather_map {A B : Type} (f : A → Option B) (g : A → B) (xs : List A)
    (h : ∀ x∈xs,f x=some (g x)) : gather f xs=some (xs.map g) := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    have hx := h x (by simp)
    have ht := ih (fun y hy => h y (by simp [hy]))
    simp only [gather,hx,Option.bind_some,ht,Option.map_some,List.map_cons]

/-- Reads only the finite node bank. Fuel bounds recursion; active child
    pointers in valid arenas are strictly smaller than the parent index. -/
def decode {cap : Nat} : Nat → (Fin cap → Node cap) → Ptr cap → Option Piece
  | 0,_,_ => none
  | fuel+1,bank,p =>
    if hp : p.val<cap then
      let n := bank ⟨p.val,hp⟩
      (SyntaxCells020E.decode n.cell).bind (fun t =>
        (gather (decode fuel bank) (children t n)).bind (assemble t))
    else none

theorem decode_correct {cap : Nat} (fuel : Nat) (s : Arena cap) (mu : Meaning)
    (hh : HeapValid s mu) (p : Ptr cap) (hp : p.val<s.used.val) (hf : p.val<fuel) :
    decode fuel s.bank p=some (mu p.val) := by
  induction fuel generalizing p with
  | zero => omega
  | succ fuel ih =>
    have hcap : p.val<cap := by have := s.used.isLt;omega
    obtain ⟨t,ht,hc,hv⟩ := hh ⟨p.val,hcap⟩ hp
    rw [decode,dite_eq_left hcap]
    simp only [ht,Option.bind_some]
    have hg := gather_map (decode fuel s.bank) (fun q => mu q.val)
      (children t (s.bank ⟨p.val,hcap⟩)) (by
        intro q hq
        have hq' : q.val<p.val := hc q hq
        exact ih q (hq'.trans hp) (by omega))
    rw [hg]
    exact hv

theorem view_singleton {cap : Nat} (s : Arena cap) (hs : s.sp.val=1) : view s=[peek s 0] := by
  apply List.ext_getElem
  · rw [view_length,hs];rfl
  · intro j hj hj'
    have hj0 : j=0 := by rw [view_length,hs] at hj;omega
    subst j
    exact view_get s 0 (by rw [view_length,hs];decide)

def root {cap : Nat} (s : Arena cap) : Option Piece :=
  if s.sp.val=1 then decode s.used.val s.bank (peek s 0) else none

theorem root_correct {cap : Nat} (s : Arena cap) (mu : Meaning) (p : Piece) (hi : Inv s mu [p]) :
    root s=some p := by
  have hs : s.sp.val=1 := (logical_length s mu [p] hi).symm
  have hv := view_singleton s hs
  have hp : (peek s 0).val<s.used.val := hi.2.1 _ (by rw [hv];simp)
  have hm := hi.2.2.2
  rw [hv,List.map_cons,List.map_nil] at hm
  have he : mu (peek s 0).val=p := (List.cons.inj hm).1
  rw [root,ite_eq_left hs,decode_correct s.used.val s mu hi.1 _ hp hp,he]

end FT1536.S05.ArenaDecode020E1
