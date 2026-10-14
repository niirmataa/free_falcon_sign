import Source3.KeygenPublicSite108

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCanonicalAddresses108
open C99MemoryReference
open KeygenMakeInvocation (Env VirtualLegal)

/-- First occurrence index; absence yields the list length. -/
def locate : List Nat → Nat → Nat
  | [], _ => 0
  | head :: rest, block => if head = block then 0 else locate rest block + 1

theorem locate_lt (xs : List Nat) (block : Nat) (member : block ∈ xs) : locate xs block < xs.length := by
  induction xs with
  | nil => cases member
  | cons head rest ih =>
      by_cases equal : head = block
      · subst block; simp [locate]
      · have tail : block ∈ rest := (List.mem_cons.mp member).resolve_left (Ne.symm equal)
        have bound := ih tail
        simp only [locate, ite_eq_right equal, List.length_cons]
        omega

theorem locate_unique (xs : List Nat) (a b : Nat) (ha : a ∈ xs) (hb : b ∈ xs)
    (same : locate xs a = locate xs b) : a = b := by
  induction xs with
  | nil => cases ha
  | cons head rest ih =>
      by_cases first : head = a
      · by_cases second : head = b
        · exact first.symm.trans second
        · simp only [locate, ite_eq_left first, ite_eq_right second] at same
          omega
      · by_cases second : head = b
        · simp only [locate, ite_eq_right first, ite_eq_left second] at same
          omega
        · have tailA := (List.mem_cons.mp ha).resolve_left (Ne.symm first)
          have tailB := (List.mem_cons.mp hb).resolve_left (Ne.symm second)
          simp only [locate, ite_eq_right first, ite_eq_right second] at same
          exact ih tailA tailB (by omega)

/-- A concrete finite representation: used object bases are positive,
    distinct multiples of 2^32; out-of-scope identifiers use sentinel zero.
    No global injectivity on Nat is asserted or needed. -/
def base (xs : List Nat) (block : Nat) : Nat :=
  if block ∈ xs then 2^32 * (locate xs block + 1) else 0

theorem bounded (xs : List Nat) (short : xs.length ≤ 13) (block : Nat) : base xs block < 2^64 := by
  unfold base
  split_ifs with member
  · have bound := locate_lt xs block member
    have small : locate xs block + 1 ≤ 13 := by omega
    exact (Nat.mul_le_mul_left (2^32) small).trans_lt (by decide)
  · decide

theorem separated (xs : List Nat) (a b : Nat) (member : a ∈ xs) (same : base xs a = base xs b) : a = b := by
  by_cases other : b ∈ xs
  · simp only [base, ite_eq_left member, ite_eq_left other] at same
    exact locate_unique xs a b member other (by omega)
  · simp only [base, ite_eq_left member, ite_eq_right other] at same
    omega

/-- Choose the representation BEFORE supplying a caller heap. This does
    not rebase existing bytes or assert transport of an arbitrary caller. -/
def canonical (env : Env) : Env :=
  {env with vb := base env.live, ctx := {env.ctx with virtualBase := base env.live}}

theorem live (env : Env) : (canonical env).live = env.live := rfl

theorem context_map (env : Env) : (canonical env).vb = (canonical env).ctx.virtualBase := rfl

theorem short (env : Env) : env.live.length ≤ 13 := Nat.le_refl 13

theorem legal (env : Env) : VirtualLegal (canonical env).live (canonical env).vb := by
  refine ⟨?_, ?_⟩
  · intro block member
    exact bounded env.live (short env) block
  · intro a b ha hb same
    exact separated env.live a b ha same

theorem word_separated (env : Env) (a b : Nat) (member : a ∈ (canonical env).live)
    (same : BitVec.ofNat 64 ((canonical env).vb a) = BitVec.ofNat 64 ((canonical env).vb b)) : a = b := by
  have words := congrArg BitVec.toNat same
  change (base env.live a) % 2^64 = (base env.live b) % 2^64 at words
  rw [Nat.mod_eq_of_lt (bounded env.live (short env) a), Nat.mod_eq_of_lt (bounded env.live (short env) b)] at words
  exact separated env.live a b member words

theorem canonical_word (env : Env) (p q : ArrayPointer)
    (first : KeygenMakeInvocation.Canonical p) (second : KeygenMakeInvocation.Canonical q)
    (member : p.block ∈ (canonical env).live)
    (words : KeygenMakeInvocation.wordOf (canonical env).vb p = KeygenMakeInvocation.wordOf (canonical env).vb q) : p = q := by
  have zeroP : p.offset = 0 := by simp [ArrayPointer.offset, first.zeroBase, first.zeroIndex]
  have zeroQ : q.offset = 0 := by simp [ArrayPointer.offset, second.zeroBase, second.zeroIndex]
  have same : BitVec.ofNat 64 ((canonical env).vb p.block) = BitVec.ofNat 64 ((canonical env).vb q.block) := by
    simpa only [KeygenMakeInvocation.wordOf, zeroP, zeroQ, Nat.add_zero] using words
  have blocks := word_separated env p.block q.block member same
  have other : q.block ∈ (canonical env).live := by rw [← blocks]; exact member
  exact KeygenMakeInvocation.canonical_word_eq _ _ (legal env) p q first second member other words

/-- A known live stored pointer word identifies any canonical descriptor
    read from that cell, without assuming the read descriptor is live. -/
theorem read_known (env : Env) (heap : Memory) (cell p known : ArrayPointer)
    (member : known.block ∈ (canonical env).live)
    (source : KeygenMakeInvocation.ReadPointer (canonical env).vb heap cell p)
    (stored : KeygenMakeInvocation.ReadPointer (canonical env).vb heap cell known) : p = known :=
  (canonical_word env known p stored.canonical source.canonical member
    (load64_deterministic heap cell _ _ stored.load source.load)).symm

end FT1536.Source3.KeygenCanonicalAddresses108
