-- FT1536_PRNG_LAYOUT_COUNTER_RUN_002: kernel counter/layout/resource lemmas.
-- Core Lean 4.34 only (no imports, no Mathlib/Std). The modulus is written as
-- a literal so `omega` sees a constant. ChaCha Word32 rounds stay in the Sage
-- exact model + original-C binding (explicit boundary, not kernelized here).
-- Closed by `omega`/`rfl`/`simp` with clean logs and minimal standard axioms
-- (see the `#print axioms` lines below).

namespace Ft1536.PrngLayout

-- Block-k counter of one fixed context: (cc0 + k) mod 2^64 (frng.c:214-215).
def blockCounter (cc0 k : Nat) : Nat := (cc0 + k) % 18446744073709551616

theorem blockCounter_zero (cc0 : Nat) :
    blockCounter cc0 0 = cc0 % 18446744073709551616 := by
  unfold blockCounter
  simp [Nat.add_zero]

theorem blockCounter_step (cc0 k : Nat) :
    blockCounter cc0 (k + 1)
      = (blockCounter cc0 k + 1) % 18446744073709551616 := by
  unfold blockCounter
  omega

-- Chained refills compose: post counter of a second range over the live value.
theorem blockCounter_add (cc0 a b : Nat) :
    blockCounter (blockCounter cc0 a) b = blockCounter cc0 (a + b) := by
  unfold blockCounter
  omega

-- One refill = 64 blocks; post counter is definitionally (cc0 + 64) % 2^64.
theorem refill_post (cc0 : Nat) :
    blockCounter cc0 64 = (cc0 + 64) % 18446744073709551616 :=
  rfl

-- No repeats within one context for N <= 2^64 consecutive blocks, even
-- across the wrap (0 < j - i < 2^64 cannot be a multiple of 2^64).
theorem counters_distinct (cc0 N i j : Nat)
    (hN : N ≤ 18446744073709551616) (hi : i < N) (hj : j < N)
    (hij : i ≠ j) : blockCounter cc0 i ≠ blockCounter cc0 j := by
  unfold blockCounter
  intro h
  by_cases hle : i < j
  · omega
  · have hlt : j < i := by omega
    omega

-- In-stage wrap flag: the stage starting at (cc0 + 64s) mod 2^64 wraps iff
-- start + 63 reaches 2^64, equivalently the last counter is below the first.
def WrapsInStage (cc0 s : Nat) : Prop :=
  (cc0 + 64 * s) % 18446744073709551616 + 63 ≥ 18446744073709551616

theorem wrap_of_last_lt_first (cc0 s : Nat)
    (h : (cc0 + 64 * s + 63) % 18446744073709551616
      < (cc0 + 64 * s) % 18446744073709551616) :
    WrapsInStage cc0 s := by
  unfold WrapsInStage
  omega

theorem last_lt_first_of_wrap (cc0 s : Nat) (h : WrapsInStage cc0 s) :
    (cc0 + 64 * s + 63) % 18446744073709551616
      < (cc0 + 64 * s) % 18446744073709551616 := by
  unfold WrapsInStage at h
  omega

-- Fixture instances (F4: cc0 = 2^64-1 wraps in the first refill, post = 63;
-- F5: cc0 = 2^64-64 ends exactly at 2^64-1, post = 0, no in-stage wrap).
theorem wrap_F4 : WrapsInStage (18446744073709551616 - 1) 0 := by
  unfold WrapsInStage
  omega

theorem post_F4 : blockCounter (18446744073709551616 - 1) 64 = 63 := by
  unfold blockCounter
  omega

theorem nowrap_F5 : ¬WrapsInStage (18446744073709551616 - 64) 0 := by
  unfold WrapsInStage
  omega

theorem post_F5 : blockCounter (18446744073709551616 - 64) 64 = 0 := by
  unfold blockCounter
  omega

-- Type dispatch (frng.c:283-319): 0 -> 1, 1 -> 1, every other int -> 0.
def typeOut (t : Int) : Nat := if t = 0 then 1 else if t = 1 then 1 else 0

theorem typeOut_zero : typeOut 0 = 1 := by simp [typeOut]

theorem typeOut_one : typeOut 1 = 1 := by simp [typeOut]

theorem typeOut_other (t : Int) (h0 : t ≠ 0) (h1 : t ≠ 1) :
    typeOut t = 0 := by
  simp [typeOut, h0, h1]

-- Layout offsets (little-endian 56-byte map, frng.c:290-316).
theorem layout_key_end : 4 * 8 = 32 := by omega

theorem layout_iv_cover : 32 + 4 * 4 = 48 := by omega

theorem layout_counter_cover : 48 + 8 = 56 := by omega

-- Counter XOR lanes are stream words 10/11 = offsets 40..47.
theorem layout_xor_lane_lo : 4 * 10 = 40 := by omega

theorem layout_xor_lane_hi : 4 * 11 + 4 = 48 := by omega

-- Frame: init writes state[0..55]; refill writes buf + state[48..55];
-- state[56..255] is never written (256-byte state).
theorem frame_tail_nonempty : 56 < 256 := by omega

theorem refill_blocks_per_buffer : 4096 / 64 = 64 := by omega

-- Resource consumer (exact Nat, from the received T01 event H).
theorem rmax_value : (33 * 49152 - 8) / 4087 = 396 := by omega

theorem blocks_per_context (r : Nat) (hr : r ≤ 396) :
    64 * (1 + r) ≤ 25408 := by
  omega

theorem additional_limit : 16 * 396 = 6336 := by omega

theorem region_blocks : 64 * 6352 = 406528 := by omega

theorem shake56_bytes : 56 * 16 = 896 := by omega

theorem shake56_with_nonce : 56 * 16 + 40 = 936 := by omega

-- q-refill corollary: refills = q / 4096, ptr = q % 4096.
theorem qrefill (q : Nat) : q / 4096 * 4096 + q % 4096 = q := by omega

end Ft1536.PrngLayout

#print axioms Ft1536.PrngLayout.counters_distinct
#print axioms Ft1536.PrngLayout.blockCounter_add
#print axioms Ft1536.PrngLayout.wrap_of_last_lt_first
#print axioms Ft1536.PrngLayout.last_lt_first_of_wrap
#print axioms Ft1536.PrngLayout.typeOut_other
#print axioms Ft1536.PrngLayout.qrefill
