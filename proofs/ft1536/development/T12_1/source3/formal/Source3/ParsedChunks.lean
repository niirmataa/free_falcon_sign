import Mathlib.Data.List.Basic

namespace FT1536.Source3.ParsedChunks

theorem take_chunks {α : Type} (xs : List α) (width count : Nat) :
    xs.take (count*width)=(List.range count).flatMap (fun i => (xs.drop (i*width)).take width) := by
  induction count with
  | zero => simp
  | succ count ih =>
      rw [Nat.succ_mul,List.take_add,ih,List.range_succ,List.flatMap_append]
      simp

theorem mapM_defined {α β : Type} (f : α → Option β) (xs : List α) :
    (∃ values, xs.mapM f=some values) ↔ ∀ x∈xs, ∃ y, f x=some y := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
      constructor
      · rintro ⟨values,run⟩
        rw [List.mapM_cons] at run
        obtain ⟨y,head,rest⟩ := Option.bind_eq_some_iff.mp run
        obtain ⟨ys,tail,_⟩ := Option.bind_eq_some_iff.mp rest
        intro z hz
        rcases List.mem_cons.mp hz with rfl | hz
        · exact ⟨y,head⟩
        · exact ih.mp ⟨ys,tail⟩ z hz
      · intro defined
        obtain ⟨y,head⟩ := defined x (by simp)
        obtain ⟨ys,tail⟩ := ih.mpr (fun z hz => defined z (by simp [hz]))
        refine ⟨y::ys,?_⟩
        rw [List.mapM_cons,head,tail]
        rfl

theorem mapM_length {α β : Type} (f : α → Option β) (xs : List α) (ys : List β)
    (run : xs.mapM f=some ys) : ys.length=xs.length := by
  induction xs generalizing ys with
  | nil => have he : ys=[] := (Option.some.inj run).symm; subst ys; rfl
  | cons x xs ih =>
      rw [List.mapM_cons] at run
      obtain ⟨y,head,rest⟩ := Option.bind_eq_some_iff.mp run
      obtain ⟨tail,runTail,result⟩ := Option.bind_eq_some_iff.mp rest
      have he : y::tail=ys := Option.some.inj result
      subst ys
      simp only [List.length_cons,ih tail runTail]

end FT1536.Source3.ParsedChunks
