import FT1536.Geometry
import FT1536.ROM
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Polynomial.Div

namespace FT1536.Relation
open Geometry Finset Polynomial
abbrev Rq := Fin 768 → ZMod 18433 × ZMod 18433

def reduceVec (v : Vec) : Rq := fun i => ((v i).1, (v i).2)
def centerRq (c : Rq) : Vec := fun i =>
  (center (c i).1.val, center (c i).2.val)

theorem reduce_center (c : Rq) : reduceVec (centerRq c) = c := by
  funext i
  apply Prod.ext <;> simp [reduceVec, centerRq, center, ZMod.intCast_mod]

/- Canonical 1536-coefficient representation. Multiplication is specified by
ordinary polynomial remainder modulo X^1536-X^768+1, not by an NTT oracle. -/
def poly (a : Rq) : Polynomial (ZMod 18433) :=
  ∑ i, (Polynomial.C (a i).1 * X^i.val + Polynomial.C (a i).2 * X^(i.val+768))
def modulus : Polynomial (ZMod 18433) := X^1536-X^768+1
noncomputable def mulRq (a b : Rq) : Rq := fun i =>
  let p := (poly a * poly b) %ₘ modulus
  (p.coeff i.val, p.coeff (i.val+768))

noncomputable def A (h : Rq) (z : Vec × Vec) : Rq :=
  reduceVec z.1 + mulRq h (reduceVec z.2)
noncomputable def extract (h c : Rq) (s : Vec) : Vec × Vec :=
  (centerRq (c - mulRq h (reduceVec s)), s)

def signed16 (v : Vec) : Prop := ∀ i,
  -32768 ≤ (v i).1 ∧ (v i).1 ≤ 32767 ∧ -32768 ≤ (v i).2 ∧ (v i).2 ≤ 32767

noncomputable def Verify (h c : Rq) (s : Vec) : Prop :=
  signed16 s ∧ Q (extract h c s) < B

noncomputable def ShortPreimage (h c : Rq) (z : Vec × Vec) : Prop := A h z = c ∧ Q z < B

theorem extraction_equation (h c : Rq) (s : Vec) : A h (extract h c s) = c := by
  simp [A, extract, reduce_center]

theorem accepted_extracts (h c : Rq) (s : Vec) (hv : Verify h c s) :
    ShortPreimage h c (extract h c s) := ⟨extraction_equation h c s, hv.2⟩

end FT1536.Relation

namespace FT1536.Reduction
open ROM Relation
variable {R M : Type} [DecidableEq R] [DecidableEq M]

theorem indexed_extraction (targets : ℕ → Rq) (h : Rq) (s : State R M Rq)
    (x : Name R M) (signature : Geometry.Vec) (QH : ℕ)
    (hg : Good targets s) (hf : x.2 ∉ s.seen) (hu : s.used ≤ QH)
    (hv : Verify h (hash targets x s).1 signature) :
    ∃ j, j < QH+1 ∧ ShortPreimage h (targets j)
      (extract h (hash targets x s).1 signature) := by
  obtain ⟨j, hj, hc⟩ := final_hash_index targets s x hg hf
  refine ⟨j, hj.trans_le (target_count_le_QH_add_one targets s x QH hu), ?_⟩
  rw [← hc]
  exact accepted_extracts h (hash targets x s).1 signature hv

end FT1536.Reduction
