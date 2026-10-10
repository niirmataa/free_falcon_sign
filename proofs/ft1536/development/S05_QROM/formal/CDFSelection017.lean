import SamplerCode016
import Mathlib.Data.List.OfFn

set_option maxRecDepth 8192
namespace FT1536.S05.CDFSelection017
open SamplerCode016

def prior {n : ℕ} (cdf : Fin (n+1) → ℕ) (i : Fin (n+1)) : ℕ :=
  if h : i.val=0 then 0 else cdf ⟨i.val-1,by have := i.isLt; omega⟩
def select {n : ℕ} (cdf : Fin (n+1) → ℕ) (u : ℕ) : Fin (n+1) :=
  ((List.finRange (n+1)).find? (fun i => u<cdf i)).getD (Fin.last n)

theorem find_characterization {n : ℕ} (cdf : Fin (n+1) → ℕ) (u : ℕ) (i : Fin (n+1)) :
    (List.finRange (n+1)).find? (fun j => u<cdf j)=some i ↔
      u<cdf i ∧ ∀ j, j < i → cdf j ≤ u := by
  change (List.ofFn (fun j : Fin (n+1) => j)).find? (fun j => decide (u<cdf j))=some i ↔ _
  rw [List.find?_ofFn_eq_some_of_injective (fun _ _ h => h)]
  simp only [decide_eq_true_eq,not_lt]

theorem find_exists {n : ℕ} (cdf : Fin (n+1) → ℕ) (u : ℕ) (hu : u<cdf (Fin.last n)) :
    (List.finRange (n+1)).find? (fun j => u<cdf j)≠none := by
  intro hn
  have hh := List.find?_eq_none.mp hn (Fin.last n) (List.mem_finRange _)
  simp only [decide_eq_true_eq] at hh
  exact hh hu

theorem prior_iff {n : ℕ} (cdf : Fin (n+1) → ℕ) (hc : Monotone cdf) (u : ℕ)
    (i : Fin (n+1)) : (∀ j, j < i → cdf j ≤ u) ↔ prior cdf i≤u := by
  unfold prior
  split
  next hi =>
    constructor
    · intro _; exact Nat.zero_le _
    · intro _ j hj
      have h : j.val< i.val := hj
      omega
  next hi =>
    constructor
    · intro hh
      apply hh
      change i.val-1< i.val
      omega
    · intro hh j hj
      have hji : j≤(⟨i.val-1,by have := i.isLt; omega⟩ : Fin (n+1)) := by
        change j.val≤ i.val-1
        have h : j.val< i.val := hj
        omega
      exact (hc hji).trans hh

theorem select_interval {n : ℕ} (cdf : Fin (n+1) → ℕ) (hc : Monotone cdf) (u : ℕ)
    (hu : u<cdf (Fin.last n)) (i : Fin (n+1)) :
    select cdf u=i ↔ prior cdf i≤u ∧ u<cdf i := by
  have hn := find_exists cdf u hu
  unfold select
  cases he : (List.finRange (n+1)).find? (fun j => u<cdf j) with
  | none => exact False.elim (hn he)
  | some j =>
    simp only [Option.getD_some]
    constructor
    · rintro rfl
      have hh := (find_characterization cdf u j).mp he
      exact ⟨(prior_iff cdf hc u j).mp hh.2,hh.1⟩
    · intro hi
      have hh := (find_characterization cdf u i).mpr ⟨hi.2,(prior_iff cdf hc u i).mpr hi.1⟩
      rw [he] at hh
      exact Option.some.inj hh

theorem actual_coord_interval (t : Tables) (hc : Monotone t.cdf)
    (hS : 0<t.cdf ⟨30720,by decide⟩) (bits : BitTapes016.Bits 384) (i : CoordIndex) :
    coord t bits=i ↔ prior t.cdf i≤(BitTapes016.word 384 bits).val%t.cdf ⟨30720,by decide⟩ ∧
      (BitTapes016.word 384 bits).val%t.cdf ⟨30720,by decide⟩<t.cdf i :=
  select_interval t.cdf hc _ (Nat.mod_lt _ hS) i

#print axioms find_characterization
#print axioms find_exists
#print axioms prior_iff
#print axioms select_interval
#print axioms actual_coord_interval
end FT1536.S05.CDFSelection017
