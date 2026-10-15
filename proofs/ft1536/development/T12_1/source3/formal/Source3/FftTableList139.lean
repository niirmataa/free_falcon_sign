import Source3.ParsedChunks

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTableList139

theorem mapM_index {α β : Type} (f : α → Option β) (xs : List α) (ys : List β)
    (run : xs.mapM f=some ys) (i : Nat) : (xs[i]?).bind f=ys[i]? := by
  induction xs generalizing ys i with
  | nil =>
    have same : ys=[] := (Option.some.inj run).symm
    subst ys
    simp
  | cons x xs ih =>
    rw [List.mapM_cons] at run
    obtain ⟨y,head,rest⟩ := Option.bind_eq_some_iff.mp run
    obtain ⟨tail,runTail,result⟩ := Option.bind_eq_some_iff.mp rest
    have same : y::tail=ys := Option.some.inj result
    subst ys
    cases i with
    | zero => exact head
    | succ i => exact ih tail runTail i

theorem flatten_even (xs : List (α × α)) (i : Nat) :
    (xs.flatMap (fun p => [p.1,p.2]))[2*i]?=(xs[i]?).map Prod.fst := by
  induction xs generalizing i with
  | nil => simp
  | cons x xs ih =>
    cases i with
    | zero => rfl
    | succ i => simpa only [Nat.mul_succ,List.flatMap_cons,List.cons_append,List.nil_append,
        List.getElem?_cons_succ] using ih i

theorem flatten_odd (xs : List (α × α)) (i : Nat) :
    (xs.flatMap (fun p => [p.1,p.2]))[2*i+1]?=(xs[i]?).map Prod.snd := by
  induction xs generalizing i with
  | nil => simp
  | cons x xs ih =>
    cases i with
    | zero => rfl
    | succ i => simpa only [Nat.mul_succ,Nat.add_assoc,List.flatMap_cons,List.cons_append,List.nil_append,
        List.getElem?_cons_succ] using ih i

end FT1536.Source3.FftTableList139
