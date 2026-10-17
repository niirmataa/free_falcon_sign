import Source3.KeygenSuccessMass112
import FT1536.Basic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/-! # MODE1 coefficient law derived from the pinned sampler body

The MODE1 secret sampler (`sample_true_ternary_secret` under
`TRUE_TERNARY_SECRET_MODE == 1` of the pinned `Extra/c/falcon-keygen.c`
body embedded in `Source3.KeygenSource`) stores one coefficient per
accepted two-bit chunk of the RNG word stream:

```
if (rbits < 2) { rb = get_rng_u64(&fk->rng); rbits = 64; }
x = (uint32_t)rb & 3U;
rb >>= 2;
rbits -= 2;
if (x < 3U) { v[u] = (int16_t)((int)x - 1); break; }
```

From those source bytes this module derives, without any distribution
assumption:

* the exact chunk map of one RNG word (32 two-bit chunks, low bits first),
* the exact stored-value map `x ↦ x - 1` over the accepted chunks in stream
  order (the rejected chunk `3` is skipped by the inner `for(;;)`),
* the rejection-normalized per-coefficient marginal `valueLaw` under an
  arbitrary per-chunk law `m`, with the unbounded-retry geometric series
  identity `oneDraw_transfer`, the exact uniform case `valueLaw_uniform`
  (mass `1/3` per stored value) and the explicit deviation bound
  `valueLaw_deviation` (`16 δ / (9 - 12 δ)`).

What the sampler bytes do not provide is the law `m` of the SHAKE word
stream itself under the uniform 32-byte seed law of `KeygenInputLaw110`.
No independence, uniformity or replacement of any RNG draw is asserted
here: every marginal statement below is conditioned on the per-chunk law
supplied by the caller, exactly as the sampler sources determine it. -/
namespace FT1536.Source3.KeygenMode1Law134
open Finset

/-- One two-bit chunk of one RNG word: the source read
    `x = (uint32_t)rb & 3U` at the `i`-th consumption step of the word,
    after `i` applications of `rb >>= 2`. -/
def chunkAt (w : BitVec 64) (i : Nat) : Fin 4 :=
  ⟨(w.toNat >>> (2 * i)) % 4, Nat.mod_lt _ (by norm_num)⟩

theorem chunkAt_val (w : BitVec 64) (i : Nat) :
    (chunkAt w i).val = (w.toNat >>> (2 * i)) % 4 := rfl

theorem chunkAt_lt (w : BitVec 64) (i : Nat) : (chunkAt w i).val < 4 := (chunkAt w i).isLt

/-- One 64-bit word supplies exactly 32 chunks before the refill guard
    `rbits < 2` fires again (`rbits` counts down by two from 64). -/
def chunks (w : BitVec 64) : List (Fin 4) := (List.range 32).map (chunkAt w)

theorem chunks_length (w : BitVec 64) : (chunks w).length = 32 := by
  simp [chunks]

/-- The full chunk stream of a word sequence, in consumption order. -/
def chunkStream : List (BitVec 64) → List (Fin 4)
  | [] => []
  | w :: ws => chunks w ++ chunkStream ws

theorem chunkStream_nil : chunkStream [] = [] := rfl

theorem chunkStream_cons (w : BitVec 64) (ws : List (BitVec 64)) :
    chunkStream (w :: ws) = chunks w ++ chunkStream ws := rfl

theorem chunkStream_append (ws vs : List (BitVec 64)) :
    chunkStream (ws ++ vs) = chunkStream ws ++ chunkStream vs := by
  induction ws with
  | nil => rfl
  | cons w ws ih =>
      rw [List.cons_append, chunkStream_cons, chunkStream_cons, ih, List.append_assoc]

theorem chunkStream_length (ws : List (BitVec 64)) :
    (chunkStream ws).length = 32 * ws.length := by
  induction ws with
  | nil => rfl
  | cons w ws ih =>
      rw [chunkStream_cons, List.length_append, List.length_cons, chunks_length, ih]
      omega

/-- The inner `for(;;)` loop: every chunk `x = 3` is rejected and skipped;
    the first following chunk `x < 3` is stored. Hence the stored chunk
    sequence is exactly the accepted chunks in stream order. -/
def accepted (cs : List (Fin 4)) : List (Fin 4) := cs.filter (fun x => x.val ≠ 3)

/-- The stored coefficient of one accepted chunk: `v[u] = (int16_t)((int)x - 1)`. -/
def coeffs (cs : List (Fin 4)) : List Int := (accepted cs).map (fun x => (x.val : Int) - 1)

theorem accepted_append (cs ds : List (Fin 4)) :
    accepted (cs ++ ds) = accepted cs ++ accepted ds := by
  simp [accepted, List.filter_append]

theorem accepted_sublist (cs : List (Fin 4)) : (accepted cs).Sublist cs := by
  show (cs.filter (fun x => x.val ≠ 3)).Sublist cs
  exact List.filter_sublist

theorem accepted_mem (cs : List (Fin 4)) {x : Fin 4} (h : x ∈ accepted cs) :
    x ∈ cs ∧ x.val ≠ 3 := by
  simpa [accepted] using List.mem_filter.mp h

theorem accepted_length_le (cs : List (Fin 4)) : (accepted cs).length ≤ cs.length := by
  show (cs.filter (fun x => decide (x.val ≠ 3))).length ≤ cs.length
  exact List.length_filter_le _ cs

theorem coeffs_length (cs : List (Fin 4)) : (coeffs cs).length = (accepted cs).length := by
  simp [coeffs]

theorem coeffs_append (cs ds : List (Fin 4)) :
    coeffs (cs ++ ds) = coeffs cs ++ coeffs ds := by
  simp [coeffs, accepted_append, List.map_append]

/-- Every stored MODE1 coefficient lies in `{-1, 0, 1}`: the acceptance
    condition `x < 3` and the store `x - 1` leave exactly these values.
    This is the value-level form of the executed sampler's `Bound 1`. -/
theorem coeffs_mem (cs : List (Fin 4)) {c : Int} (h : c ∈ coeffs cs) :
    c = -1 ∨ c = 0 ∨ c = 1 := by
  obtain ⟨x, hx, rfl⟩ := List.mem_map.mp h
  have ne : x.val ≠ 3 := (accepted_mem cs hx).2
  have bound : x.val < 4 := x.isLt
  have hv : x.val = 0 ∨ x.val = 1 ∨ x.val = 2 := by omega
  rcases hv with hval | hval | hval <;> rw [hval] <;> norm_num

/-- The output side of one stored coefficient: the accepted chunk value. -/
def chunkOf : Fin 3 → Fin 4 := fun x => ⟨x.val, Nat.lt_trans x.isLt (by norm_num)⟩

theorem chunkOf_val (x : Fin 3) : (chunkOf x).val = x.val := rfl

theorem chunkOf_inj {x y : Fin 3} (h : chunkOf x = chunkOf y) : x = y := by
  apply Fin.ext
  have := congrArg Fin.val h
  simpa [chunkOf_val] using this

theorem chunkOf_zero : chunkOf (0 : Fin 3) = (0 : Fin 4) := rfl

theorem chunkOf_one : chunkOf (1 : Fin 3) = (1 : Fin 4) := rfl

theorem chunkOf_two : chunkOf (2 : Fin 3) = (2 : Fin 4) := rfl

/-- The rejection-normalized per-coefficient marginal of the MODE1 store
    under a per-chunk law `m`: the first accepted chunk has law `m`
    conditioned on `x.val ≠ 3`, i.e. `m(c) / (1 - m(3))` on the three
    stored values. The retry loop `for(;;)` can run arbitrarily long, so
    this is also the exact infinite-retry marginal; see `oneDraw_transfer`. -/
noncomputable def valueLaw (m : Law (Fin 4)) (h : m.mass 3 < 1) : Law (Fin 3) where
  mass x := m.mass (chunkOf x) / (1 - m.mass 3)
  nonneg x := div_nonneg (m.nonneg _) (by linarith)
  total := by
    have total4 : m.mass 0 + m.mass 1 + m.mass 2 + m.mass 3 = 1 := by
      rw [← m.total, Fin.sum_univ_four]
    have sumEq : (∑ x : Fin 3, m.mass (chunkOf x)) = m.mass 0 + m.mass 1 + m.mass 2 := by
      rw [Fin.sum_univ_three, chunkOf_zero, chunkOf_one, chunkOf_two]
    have sumMass : (∑ x : Fin 3, m.mass (chunkOf x)) * (1 - m.mass 3)⁻¹ = 1 := by
      rw [sumEq]
      have normal : (1 : ℝ) - m.mass 3 = m.mass 0 + m.mass 1 + m.mass 2 := by linarith
      rw [← normal, ← div_eq_mul_inv]
      exact div_self (by linarith : (1:ℝ) - m.mass 3 ≠ 0)
    calc
      ∑ x : Fin 3, m.mass (chunkOf x) / (1 - m.mass 3)
          = (∑ x : Fin 3, m.mass (chunkOf x)) * (1 - m.mass 3)⁻¹ := by
        simp_rw [div_eq_mul_inv]
        exact (Finset.sum_mul univ (fun x => m.mass (chunkOf x)) (1 - m.mass 3)⁻¹).symm
      _ = 1 := sumMass

theorem valueLaw_mass (m : Law (Fin 4)) (h : m.mass 3 < 1) (x : Fin 3) :
    (valueLaw m h).mass x = m.mass (chunkOf x) / (1 - m.mass 3) := rfl

/-- The unbounded retry loop: summing over the number `j` of rejected
    chunks before the first accepted one gives the geometric series whose
    sum is exactly the rejection-normalized marginal. -/
theorem oneDraw_transfer (m : Law (Fin 4)) (h : m.mass 3 < 1) (x : Fin 3) :
    (∑' j : ℕ, m.mass 3 ^ j * m.mass (chunkOf x)) = (valueLaw m h).mass x := by
  have nonneg3 : 0 ≤ m.mass 3 := m.nonneg 3
  have split : (∑' j : ℕ, m.mass 3 ^ j * m.mass (chunkOf x)) =
      (∑' j : ℕ, m.mass 3 ^ j) * m.mass (chunkOf x) :=
    tsum_mul_right
  rw [split, tsum_geometric_of_lt_one nonneg3 h, valueLaw_mass]
  simp_rw [div_eq_mul_inv]
  ring

/-- Exact uniform case: with per-chunk mass `1/4` on all four chunks the
    rejection-normalized marginal is exactly `1/3` on each stored value.
    The sampler body itself introduces no deviation in this case. -/
theorem valueLaw_uniform (m : Law (Fin 4)) (h : m.mass 3 < 1)
    (uniform : ∀ x : Fin 4, m.mass x = 1 / 4) (x : Fin 3) :
    (valueLaw m h).mass x = 1 / 3 := by
  rw [valueLaw_mass, uniform (chunkOf x), uniform 3]
  norm_num

/-- Explicit deviation transfer: if every chunk mass deviates from the
    uniform mass `1/4` by at most `δ < 3/4`, then every stored-value mass
    deviates from `1/3` by at most `16 δ / (9 - 12 δ)`. The deviation of
    the real sampler from the assumed uniform ternary law is therefore
    bounded by the deviation of its chunk law; nothing is skipped. -/
theorem valueLaw_deviation (m : Law (Fin 4)) (h : m.mass 3 < 1) (δ : ℝ)
    (δnonneg : 0 ≤ δ) (δsmall : δ < 3 / 4)
    (dev : ∀ x : Fin 4, |m.mass x - 1 / 4| ≤ δ) (x : Fin 3) :
    |(valueLaw m h).mass x - 1 / 3| ≤ 16 * δ / (9 - 12 * δ) := by
  have dc : |m.mass (chunkOf x) - 1 / 4| ≤ δ := dev (chunkOf x)
  have db : |m.mass 3 - 1 / 4| ≤ δ := dev (3 : Fin 4)
  have dbu : m.mass 3 ≤ 1 / 4 + δ := by
    have := (abs_le.mp db).2
    linarith
  have denPos : 0 < 1 - m.mass 3 := by linarith
  have den3 : 0 < 3 * (1 - m.mass 3) := by positivity
  have denLower : (9 - 12 * δ) / 4 ≤ 3 * (1 - m.mass 3) := by
    have : (0:ℝ) ≤ 3 := by norm_num
    have := mul_le_mul_of_nonneg_left (by linarith : (3 / 4 : ℝ) - δ ≤ 1 - m.mass 3) this
    linarith
  have num : |3 * m.mass (chunkOf x) - (1 - m.mass 3)| ≤ 4 * δ := by
    have key : 3 * m.mass (chunkOf x) - (1 - m.mass 3) =
        3 * (m.mass (chunkOf x) - 1 / 4) + (m.mass 3 - 1 / 4) := by ring
    have triangle : |3 * (m.mass (chunkOf x) - 1 / 4) + (m.mass 3 - 1 / 4)| ≤
        |3 * (m.mass (chunkOf x) - 1 / 4)| + |m.mass 3 - 1 / 4| := abs_add_le _ _
    have scale : |3 * (m.mass (chunkOf x) - 1 / 4)| = 3 * |m.mass (chunkOf x) - 1 / 4| := by
      rw [abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 3)]
    have first : |3 * (m.mass (chunkOf x) - 1 / 4) + (m.mass 3 - 1 / 4)| ≤
        3 * |m.mass (chunkOf x) - 1 / 4| + |m.mass 3 - 1 / 4| :=
      triangle.trans (le_of_eq (by rw [scale]))
    have second : 3 * |m.mass (chunkOf x) - 1 / 4| + |m.mass 3 - 1 / 4| ≤ 3 * δ + δ := by
      have : 3 * |m.mass (chunkOf x) - 1 / 4| ≤ 3 * δ :=
        mul_le_mul_of_nonneg_left dc (by norm_num)
      linarith
    rw [key]
    linarith
  have eq : (valueLaw m h).mass x - 1 / 3 =
      (3 * m.mass (chunkOf x) - (1 - m.mass 3)) / (3 * (1 - m.mass 3)) := by
    rw [valueLaw_mass]
    field_simp
  rw [eq, abs_div, abs_of_nonneg (le_of_lt den3)]
  have bound : |3 * m.mass (chunkOf x) - (1 - m.mass 3)| / (3 * (1 - m.mass 3)) ≤
      (4 * δ) / (3 * (1 - m.mass 3)) :=
    div_le_div_of_nonneg_right num (by positivity)
  have step : (4 * δ) / (3 * (1 - m.mass 3)) ≤ 16 * δ / (9 - 12 * δ) := by
    have denpos2 : 0 < 9 - 12 * δ := by linarith
    rw [div_le_div_iff₀ den3 denpos2]
    nlinarith [dbu, δnonneg]
  exact bound.trans step

end FT1536.Source3.KeygenMode1Law134
