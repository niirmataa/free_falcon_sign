import FT1536.Basic
import FT1536.ROM

/-! # Byte front-end for one lazy name table (task Etap A)

Names of the single ROM table are literal byte strings. A Sign name is the
bijection of a 320-bit nonce onto exactly 40 bytes followed by the message
bytes. Short names are byte strings of length < 40. Rendering `NameKind` into
literal byte strings is injective: short names never collide with Sign names
(length argument), distinct Sign names never collide (injective 40-byte frame
plus fixed-length framing, no truncation anywhere), and short names never
collide with each other (exact list equality). All proofs are complete; the
module contains no `sorry`, `admit`, `native_decide` or extra axioms. -/

namespace FT1536.GameByte

abbrev Byte := Fin 256
abbrev Name := List Byte
abbrev Message := List Byte

/-- Little-endian base-256 digits of `r`, exactly `n` bytes. -/
def bytesLE (r : ℕ) : ℕ → List Byte
  | 0 => []
  | n + 1 => ⟨r % 256, Nat.mod_lt _ (by norm_num)⟩ :: bytesLE (r / 256) n

/-- Value of a little-endian byte list. -/
def bytesVal : List Byte → ℕ
  | [] => 0
  | b :: rest => b.val + 256 * bytesVal rest

theorem length_bytesLE (r n : ℕ) : (bytesLE r n).length = n := by
  induction n generalizing r with
  | zero => rfl
  | succ n ih => simp [bytesLE, ih]

theorem bytesVal_lt (l : List Byte) : bytesVal l < 256 ^ l.length := by
  induction l with
  | nil => simp [bytesVal]
  | cons b rest ih =>
    simp only [List.length_cons, bytesVal, pow_succ']
    have h1 : b.val + 1 ≤ 256 := Nat.succ_le_of_lt b.isLt
    have h2 : bytesVal rest + 1 ≤ 256 ^ rest.length := Nat.succ_le_of_lt ih
    have key : b.val + 256 * bytesVal rest + 1 ≤ 256 * 256 ^ rest.length := by nlinarith
    exact Nat.lt_of_succ_le key

/-- Digit decomposition: `r % (a*b) = r % a + a * ((r/a) % b)` for natural
number division (holds for all `a`, `b` under the standard convention). -/
theorem mod_mul_digits (r a b : ℕ) :
    r % (a * b) = r % a + a * ((r / a) % b) := by
  have h1 : a * b * (r / (a * b)) + r % (a * b) = r := Nat.div_add_mod r (a * b)
  have h2 : a * (r / a) + r % a = r := Nat.div_add_mod r a
  have h3 : b * (r / a / b) + r / a % b = r / a := Nat.div_add_mod (r / a) b
  have hassoc : r / (a * b) = r / a / b := (Nat.div_div_eq_div_mul r a b).symm
  have deco : a * b * (r / (a * b)) + (r % a + a * ((r / a) % b)) = r := by
    calc a * b * (r / (a * b)) + (r % a + a * ((r / a) % b))
        = b * (r / a / b) * a + (r % a + a * ((r / a) % b)) := by rw [hassoc]; ring
      _ = (b * (r / a / b) + r / a % b) * a + r % a := by ring
      _ = (r / a) * a + r % a := by rw [h3]
      _ = r := by rw [Nat.mul_comm (r / a) a]; exact h2
  exact Nat.add_left_cancel (h1.trans deco.symm)

theorem bytesVal_bytesLE (r n : ℕ) : bytesVal (bytesLE r n) = r % 256 ^ n := by
  induction n generalizing r with
  | zero => simp [bytesLE, bytesVal, Nat.mod_one]
  | succ n ih =>
    show (r % 256) + 256 * bytesVal (bytesLE (r / 256) n) = r % 256 ^ (n + 1)
    rw [ih, pow_succ', mod_mul_digits r 256 (256 ^ n)]

theorem bytesLE_bytesVal (l : List Byte) : bytesLE (bytesVal l) l.length = l := by
  induction l with
  | nil => rfl
  | cons b rest ih =>
    show (⟨(b.val + 256 * bytesVal rest) % 256, Nat.mod_lt _ (by norm_num)⟩ : Byte) ::
        bytesLE ((b.val + 256 * bytesVal rest) / 256) (List.length rest) = b :: rest
    have hmod : (b.val + 256 * bytesVal rest) % 256 = b.val := by
      rw [Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt b.isLt]
    have hdiv : (b.val + 256 * bytesVal rest) / 256 = bytesVal rest := by
      rw [Nat.add_mul_div_left _ _ (by norm_num : (0:ℕ) < 256),
        Nat.div_eq_of_lt b.isLt, Nat.zero_add]
    have hfin : (⟨(b.val + 256 * bytesVal rest) % 256, Nat.mod_lt _ (by norm_num)⟩ : Byte) = b :=
      Fin.ext hmod
    rw [hfin, hdiv, ih]

/-- The nonce space of the model: 320-bit salts. -/
abbrev Nonce := Fin (2^320)

theorem pow256_40 : (256:ℕ) ^ 40 = 2 ^ 320 := by
  have h : (256:ℕ) = 2 ^ 8 := by norm_num
  rw [h, ← pow_mul, show (8*40:ℕ) = 320 by norm_num]

/-- The nonce-to-bytes encoding: exactly 40 bytes. -/
def nonceBytes (r : Nonce) : List Byte := bytesLE r.val 40

theorem nonceBytes_length (r : Nonce) : (nonceBytes r).length = 40 := length_bytesLE _ _

theorem nonceBytes_val (r : Nonce) : bytesVal (nonceBytes r) = r.val := by
  show bytesVal (bytesLE r.val 40) = r.val
  rw [bytesVal_bytesLE, pow256_40, Nat.mod_eq_of_lt r.isLt]

def nonceOf (l : List Byte) (h : l.length = 40) : Nonce :=
  ⟨bytesVal l, by
    have hl := bytesVal_lt l
    rw [h, pow256_40] at hl
    exact hl⟩

/-- Round trip bytes -> nonce -> bytes on exactly-40-byte strings. -/
theorem nonceBytes_nonceOf (l : List Byte) (h : l.length = 40) :
    nonceBytes (nonceOf l h) = l := by
  show bytesLE (bytesVal l) 40 = l
  rw [← h]
  exact bytesLE_bytesVal l

/-- Round trip nonce -> bytes -> nonce: bijection with 40-byte strings. -/
theorem nonceOf_nonceBytes (r : Nonce) :
    nonceOf (nonceBytes r) (nonceBytes_length r) = r :=
  Fin.ext (nonceBytes_val r)

theorem nonceBytes_injective : Function.Injective (nonceBytes : Nonce → Name) := by
  intro r s h
  have := congrArg bytesVal h
  rw [nonceBytes_val, nonceBytes_val] at this
  exact Fin.ext this

/-- Kinds of table names: short (< 40 bytes) and framed Sign names. -/
inductive NameKind where
  | short : (b : Name) → b.length < 40 → NameKind
  | sign : Nonce → Message → NameKind

/-- A Sign name is exactly the 40-byte nonce frame followed by the message. -/
def signName (r : Nonce) (m : Message) : Name := nonceBytes r ++ m

def render : NameKind → Name
  | .short b _ => b
  | .sign r m => signName r m

theorem signName_length (r : Nonce) (m : Message) :
    (signName r m).length = 40 + m.length := by
  simp [signName, nonceBytes_length]

/-- No truncation: the rendered Sign name keeps every message byte. -/
theorem render_sign_frame (r : Nonce) (m : Message) :
    render (.sign r m) = nonceBytes r ++ m ∧ (render (.sign r m)).length = 40 + m.length :=
  ⟨rfl, signName_length r m⟩

/-- Compatibility with the pair names used by `ROM.State`: a 40-byte frame
decomposes uniquely (equal frame lengths, then frame injectivity). -/
theorem pair_framing (r s : Nonce) (m m' : Message)
    (h : signName r m = signName s m') : r = s ∧ m = m' := by
  simp only [signName] at h
  have hlen : (nonceBytes r).length = (nonceBytes s).length := by
    simp only [nonceBytes_length]
  have ⟨hf, hm⟩ := List.append_inj h hlen
  exact ⟨nonceBytes_injective hf, hm⟩

theorem signName_injective : Function.Injective (fun p : Nonce × Message =>
    signName p.1 p.2) := by
  intro p q h
  have ⟨hp, hmp⟩ := pair_framing p.1 q.1 p.2 q.2 h
  exact Prod.ext hp hmp

/-- Short names never collide with Sign names: lengths differ (< 40 vs >= 40). -/
theorem short_ne_sign (b : Name) (hb : b.length < 40) (r : Nonce) (m : Message) :
    b ≠ signName r m := by
  intro h
  have := congrArg List.length h
  rw [signName_length] at this
  omega

/-- Rendering is injective on name kinds: no two distinct kinds truncate or
collide onto one literal byte string. -/
theorem render_injective : Function.Injective render := by
  intro k k' h
  cases k with
  | short b hb =>
    cases k' with
    | short b' hb' =>
      simp only [render] at h
      subst h
      rfl
    | sign s m' =>
      simp only [render] at h
      exact (short_ne_sign b hb s m' h).elim
  | sign r m =>
    cases k' with
    | short b' hb' =>
      simp only [render] at h
      exact (short_ne_sign b' hb' r m h.symm).elim
    | sign s m' =>
      simp only [render] at h
      have ⟨hr, hm⟩ := pair_framing r s m m' h
      subst hr
      subst hm
      rfl

/-- Long names keep their length: different message lengths give different
literal names (witness of the no-truncation requirement). -/
theorem long_names_distinct (r s : Nonce) (m m' : Message)
    (h : m.length ≠ m'.length) : signName r m ≠ signName s m' := by
  intro heq
  have := congrArg List.length heq
  rw [signName_length, signName_length] at this
  exact h (by omega)

end FT1536.GameByte
