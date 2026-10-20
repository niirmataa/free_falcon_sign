import Run2.Games
import VerifyBind.StaticCodec

/-!
# Byte packing and the FT1536 signature codec (falcon-enc.c / falcon-vrfy.c)

Byte layer of the small-vector codec: the C packer layout (each byte holds
eight stream bits, MSB first, the final partial byte right-padded with zeros),
the raw 16-bit big-endian variant (`compress_none` / `uncompress_none`), and
the signature framing of `falcon_vrfy_verify` (`falcon-vrfy.c:1445-1518`):
header byte `t cc 0 dddd`, then `falcon_decode_small` with the source's
exact-consumption check. Producer side: `falcon_sign_generate`
(`falcon-sign.c:3308-3422`) emits `sig[0] = (ternary << 7) | (comp << 5) |
logn` followed by `falcon_encode_small` of the 1536 coefficients of `s2`.
-/

namespace FT1536.VerifyBind
open FT1536.Run2 FT1536.Run2.BitArithmetic

/-! ### Packer layout -/

/-- One byte from an 8-bit MSB-first group (values are taken modulo 256). -/
def packChunk (bs : List Bool) : Byte := ⟨beVal bs % 256, Nat.mod_lt _ (by norm_num)⟩

theorem packChunk_of_length8 (bs : List Bool) (h : bs.length = 8) :
    (packChunk bs).val = beVal bs := by
  simp only [packChunk]
  exact Nat.mod_eq_of_lt (beVal_length8 bs h)

theorem beBits8_packChunk (bs : List Bool) (h : bs.length = 8) :
    beBits (packChunk bs).val 8 = bs := by
  rw [packChunk_of_length8 bs h]
  exact beBits_beVal bs 8 h

/-- Groups of eight bits, left to right (`fuel` bounds the recursion). -/
def chunk8 : ℕ → List Bool → List (List Bool)
  | _, [] => []
  | 0, _ => []
  | fuel + 1, bs => bs.take 8 :: chunk8 fuel (bs.drop 8)

theorem take_drop_take (bs : List Bool) (a b : ℕ) :
    bs.take a ++ (bs.drop a).take b = bs.take (a + b) :=
  (List.take_add (i := a) (j := b)).symm

theorem chunk8_flatten (fuel : ℕ) (bs : List Bool) :
    (chunk8 fuel bs).flatten = bs.take (8 * fuel) := by
  induction fuel generalizing bs with
  | zero =>
    cases bs with
    | nil => rfl
    | cons x xs => rfl
  | succ fuel ih =>
    cases bs with
    | nil => rfl
    | cons x xs =>
      simp only [chunk8, List.flatten_cons]
      have h : 8 * (fuel + 1) = 8 + 8 * fuel := by omega
      rw [h, ih, ← take_drop_take (x :: xs) 8 (8 * fuel)]

theorem chunk8_all_length8 (fuel : ℕ) (bs : List Bool)
    (h8 : bs.length % 8 = 0) (hf : bs.length ≤ 8 * fuel) :
    ∀ c ∈ chunk8 fuel bs, c.length = 8 := by
  induction fuel generalizing bs with
  | zero =>
    intro c hc
    cases hb : bs with
    | nil => simp [chunk8, hb] at hc
    | cons x xs =>
      have hle : (x :: xs).length ≤ 0 := by
        rw [← hb]
        exact hf
      simp only [List.length_cons] at hle
      omega
  | succ fuel ih =>
    intro c hc
    cases hb : bs with
    | nil => simp [chunk8, hb] at hc
    | cons x xs =>
      have hmod : (x :: xs).length % 8 = 0 := by
        rw [← hb]
        exact h8
      have hle2 : (x :: xs).length ≤ 8 * fuel + 8 := by
        have h1 : (x :: xs).length = bs.length := by rw [hb]
        have h2 := hf
        omega
      have hge : 8 ≤ (x :: xs).length := by
        have h1 : (x :: xs).length = bs.length := by rw [hb]
        simp only [List.length_cons] at hmod ⊢
        omega
      have htake : ((x :: xs).take 8).length = 8 := by
        simp only [List.length_take]
        omega
      have hdrop : ((x :: xs).drop 8).length % 8 = 0 := by
        rw [List.length_drop]
        omega
      have hdrop2 : ((x :: xs).drop 8).length ≤ 8 * fuel := by
        rw [List.length_drop]
        omega
      simp only [chunk8, hb, List.mem_cons] at hc
      rcases hc with hc | hc
      · rw [hc]
        exact htake
      · exact ih ((x :: xs).drop 8) hdrop hdrop2 c hc

/-- Right zero padding to a whole number of bytes (`falcon-enc.c:370-378`
flushes the final partial byte left justified). -/
def padTail (bs : List Bool) : List Bool :=
  bs ++ List.replicate ((8 - bs.length % 8) % 8) false

theorem padTail_length (bs : List Bool) : (padTail bs).length % 8 = 0 := by
  simp only [padTail, List.length_append, List.length_replicate]
  omega

theorem padTail_expand (bs : List Bool) :
    (padTail bs).length = bs.length + (8 - bs.length % 8) % 8 := by
  simp only [padTail, List.length_append, List.length_replicate]

theorem padTail_le (bs : List Bool) : bs.length ≤ 8 * (bs.length + 1) := by
  omega

theorem padTail_self (bs : List Bool) : bs.length ≤ (padTail bs).length := by
  simp only [padTail, List.length_append, List.length_replicate]
  omega

/-- The C packer: chunks of eight bits, final partial byte zero padded. -/
def pack (bs : List Bool) : Bytes :=
  (chunk8 (bs.length + 1) (padTail bs)).map packChunk

/-- Stream bits of a byte string, MSB first. -/
def unpack (bs : Bytes) : List Bool := bs.flatMap fun b => beBits b.val 8

theorem flatMap_packChunk8 (l : List (List Bool)) (h : ∀ c ∈ l, c.length = 8) :
    (l.flatMap fun c => beBits (packChunk c).val 8) = l.flatten := by
  induction l with
  | nil => rfl
  | cons c cs ih =>
    have hc : c.length = 8 := h c (List.mem_cons_self ..)
    have hcs : ∀ z ∈ cs, z.length = 8 := fun z hz => h z (List.mem_cons_of_mem _ hz)
    simp only [List.flatMap_cons, List.flatten_cons]
    rw [beBits8_packChunk c hc, ih hcs]

/-- Pack/unpack consistency: the stream recovered from `pack bs` is `bs`
completed to whole bytes with zero bits. -/
theorem unpack_pack (bs : List Bool) : unpack (pack bs) = padTail bs := by
  have hall : ∀ c ∈ chunk8 (bs.length + 1) (padTail bs), c.length = 8 :=
    chunk8_all_length8 (bs.length + 1) (padTail bs) (padTail_length bs) (by
      have h1 := padTail_le bs
      have h2 := padTail_expand bs
      omega)
  have hflat : (chunk8 (bs.length + 1) (padTail bs)).flatten = padTail bs := by
    rw [chunk8_flatten]
    exact List.take_of_length_le (by
      have h1 := padTail_le bs
      have h2 := padTail_expand bs
      omega)
  simp only [unpack, pack, List.flatMap_map]
  rw [flatMap_packChunk8 _ hall, hflat]






/-! ### Raw 16-bit variant (compress_none / uncompress_none) -/

/-- Unsigned 16-bit pattern of an integer (two's complement bits). -/
def u16 (x : ℤ) : ℕ := (x % 2^16).natAbs

theorem u16_val (x : ℤ) : ((u16 x : ℕ) : ℤ) = x % 2^16 :=
  Int.natAbs_of_nonneg (Int.emod_nonneg x (by norm_num))

theorem u16_lt (x : ℤ) : u16 x < 2^16 := by
  have h := u16_val x
  have hh := Int.emod_lt_of_pos x (by norm_num : (0 : ℤ) < 2^16)
  omega

/-- High byte of the big-endian word (`falcon-enc.c:279`). -/
def hiByte (x : ℤ) : Byte := ⟨u16 x / 256, by have := u16_lt x; omega⟩

/-- Low byte of the big-endian word (`falcon-enc.c:280`). -/
def loByte (x : ℤ) : Byte := ⟨u16 x % 256, by have := u16_lt x; omega⟩

theorem hiByte_val (x : ℤ) : (hiByte x).val = u16 x / 256 := rfl

theorem loByte_val (x : ℤ) : (loByte x).val = u16 x % 256 := rfl

/-- One coefficient as a big-endian two's complement word. -/
def wordBytes (x : ℤ) : Bytes := [hiByte x, loByte x]

/-- Sign-extended value of two bytes (`falcon-enc.c:434-436`). -/
def s16be (hi lo : Byte) : ℤ := wrap16 ((hi.val : ℤ) * 256 + lo.val)

theorem s16be_wordBytes (x : ℤ) : s16be (hiByte x) (loByte x) = wrap16 x := by
  simp only [s16be, hiByte_val, loByte_val]
  have hcast : (((u16 x / 256 : ℕ) : ℤ) * 256 + ((u16 x % 256 : ℕ) : ℤ)) = (u16 x : ℕ) := by
    have h := Nat.mod_add_div' (u16 x) 256
    omega
  rw [hcast, u16_val]
  exact (wrap16_emod x).symm

theorem s16be_mem (hi lo : Byte) : int16 (s16be hi lo) :=
  wrap16_mem ((hi.val : ℤ) * 256 + lo.val)

/-- Uncompressed decode (`falcon-enc.c:400-456`): pairs of bytes must
represent values in `[-9216, 9216]` (`hq < w + q < tq`). -/
def decodeNoneAux : Bytes → Option (List ℤ)
  | [] => some []
  | [_] => none
  | hi :: lo :: bs =>
    let v := s16be hi lo
    if -9216 ≤ v ∧ v ≤ 9216 then (decodeNoneAux bs).map fun vs => v :: vs else none

/-- Uncompressed decode of one payload: exactly `2 * 1536` bytes
(the source's `!= len` check, `falcon-vrfy.c:1505`). -/
def decodeNone (b : Bytes) : Option (List ℤ) :=
  if b.length = 3072 then decodeNoneAux b else none

/-- Uncompressed encoding (`falcon-enc.c:256-283`). -/
def encodeNone (xs : List ℤ) : Bytes := xs.flatMap wordBytes

theorem encodeNone_length (xs : List ℤ) : (encodeNone xs).length = 2 * xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    have h2 : (wordBytes x).length = 2 := rfl
    show (wordBytes x ++ encodeNone xs).length = 2 * (xs.length + 1)
    simp only [List.length_append]
    omega

theorem decodeNoneAux_wordBytes (x : ℤ) (bs : Bytes) (hx : -9216 ≤ x ∧ x ≤ 9216) :
    decodeNoneAux (wordBytes x ++ bs) = (decodeNoneAux bs).map fun vs => x :: vs := by
  have hval := s16be_wordBytes x
  have hxw : wrap16 x = x := wrap16_of_int16 x (by dsimp only [int16]; omega)
  show decodeNoneAux (hiByte x :: loByte x :: bs)
    = (decodeNoneAux bs).map fun vs => x :: vs
  simp only [decodeNoneAux]
  rw [hval, hxw]
  simp [hx]

theorem noneAux_decode_encode (xs : List ℤ) (hw : ∀ x ∈ xs, -9216 ≤ x ∧ x ≤ 9216) :
    decodeNoneAux (encodeNone xs) = some xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    have hx := hw x (List.mem_cons_self ..)
    have hxs : ∀ y ∈ xs, -9216 ≤ y ∧ y ≤ 9216 :=
      fun y hy => hw y (List.mem_cons_of_mem _ hy)
    show decodeNoneAux (wordBytes x ++ encodeNone xs) = some (x :: xs)
    rw [decodeNoneAux_wordBytes x (encodeNone xs) hx, ih hxs]
    rfl

/-- Encoder/decoder consistency of the raw variant (A4, `compress_none`
side); the domain is the source's own acceptance range. -/
theorem none_decode_encode (xs : List ℤ) (hlen : xs.length = 1536)
    (hw : ∀ x ∈ xs, -9216 ≤ x ∧ x ≤ 9216) :
    decodeNone (encodeNone xs) = some xs := by
  have hp := noneAux_decode_encode xs hw
  have hlen2 : (encodeNone xs).length = 3072 := by
    rw [encodeNone_length, hlen]
  simp only [decodeNone]
  rw [hlen2]
  simp only [ite_true]
  exact hp

/-- The raw encoder is injective on its acceptance domain. -/
theorem encodeNone_inj (xs ys : List ℤ) (hx : ∀ x ∈ xs, -9216 ≤ x ∧ x ≤ 9216)
    (hy : ∀ y ∈ ys, -9216 ≤ y ∧ y ≤ 9216) (h : encodeNone xs = encodeNone ys) :
    xs = ys := by
  have h1 := noneAux_decode_encode xs hx
  have h2 := noneAux_decode_encode ys hy
  rw [h] at h1
  rw [h2] at h1
  exact (Option.some_inj.mp h1).symm

theorem decodeNoneAux_length (b : Bytes) (xs : List ℤ) (h : decodeNoneAux b = some xs) :
    2 * xs.length = b.length := by
  have key : ∀ k (b : Bytes) (xs : List ℤ), b.length = k →
      decodeNoneAux b = some xs → 2 * xs.length = b.length := by
    intro k
    refine Nat.strongRecOn k (fun k ih => ?_)
    intro b xs hlen hd
    cases hb : b with
    | nil =>
      simp only [decodeNoneAux, hb] at hd
      injection hd with he
      subst he
      rfl
    | cons hi rest =>
      cases hr : rest with
      | nil => simp [decodeNoneAux, hb, hr] at hd
      | cons lo tail =>
        simp only [decodeNoneAux, hb, hr] at hd
        by_cases hc : -9216 ≤ s16be hi lo ∧ s16be hi lo ≤ 9216
        · simp [hc] at hd
          rcases hrec : decodeNoneAux tail with - | ys
          · simp [hrec] at hd
          · simp [hrec] at hd
            subst hd
            have hlen2 : tail.length + 2 = k := by
              simp only [hb, hr, List.length_cons] at hlen
              omega
            have hkey := ih tail.length (by omega) tail ys rfl hrec
            simp only [List.length_cons] at hkey ⊢
            omega
        · simp [hc] at hd
  exact key b.length b xs rfl h

theorem decodeNoneAux_mem_int16 (b : Bytes) (xs : List ℤ) (h : decodeNoneAux b = some xs) :
    ∀ x ∈ xs, int16 x := by
  have key : ∀ k (b : Bytes) (xs : List ℤ), b.length = k →
      decodeNoneAux b = some xs → ∀ x ∈ xs, int16 x := by
    intro k
    refine Nat.strongRecOn k (fun k ih => ?_)
    intro b xs hlen hd x hx
    cases hb : b with
    | nil =>
      simp only [decodeNoneAux, hb] at hd
      injection hd with he
      subst he
      simp at hx
    | cons hi rest =>
      cases hr : rest with
      | nil => simp [decodeNoneAux, hb, hr] at hd
      | cons lo tail =>
        simp only [decodeNoneAux, hb, hr] at hd
        by_cases hc : -9216 ≤ s16be hi lo ∧ s16be hi lo ≤ 9216
        · simp [hc] at hd
          rcases hrec : decodeNoneAux tail with - | ys
          · simp [hrec] at hd
          · simp [hrec] at hd
            subst hd
            simp only [List.mem_cons] at hx
            rcases hx with hx | hx
            · rw [hx]
              exact s16be_mem hi lo
            · have hlen2 : tail.length + 2 = k := by
                simp only [hb, hr, List.length_cons] at hlen
                omega
              exact ih tail.length (by omega) tail ys rfl hrec x hx
        · simp [hc] at hd
  exact key b.length b xs rfl h

theorem decodeNone_mem_int16 {b : Bytes} {xs : List ℤ} (h : decodeNone b = some xs) :
    ∀ x ∈ xs, int16 x := by
  simp only [decodeNone] at h
  by_cases hc : b.length = 3072
  · simp [hc] at h
    exact decodeNoneAux_mem_int16 b xs h
  · simp [hc] at h

theorem decodeNone_length {b : Bytes} {xs : List ℤ} (h : decodeNone b = some xs) :
    xs.length = 1536 := by
  simp only [decodeNone] at h
  by_cases hc : b.length = 3072
  · simp [hc] at h
    have hlen := decodeNoneAux_length b xs h
    omega
  · simp [hc] at h

/-! ### Signature framing (`falcon-vrfy.c:1445-1518`, `falcon-sign.c:3408-3418`) -/

/-- Signature compression selector (`falcon.h:51-54`). -/
inductive Comp where
  | none
  | static

/-- Header byte `(ternary << 7) | (comp << 5) | logn` at the FT1536 profile
(ternary = 1, logn = 10). -/
def sigHeader (c : Comp) : Byte :=
  match c with
  | .none => ⟨138, by decide⟩
  | .static => ⟨170, by decide⟩

def encodeSmall (c : Comp) (xs : List ℤ) : Bytes :=
  match c with
  | .none => encodeNone xs
  | .static => pack (encodeStatic xs)

def decodeSmall (c : Comp) (b : Bytes) : Option (List ℤ) :=
  match c with
  | .none => decodeNone b
  | .static => decodeStatic 1536 (unpack b)

/-- Compression field of a header byte (`falcon-vrfy.c:1505`); values 2 and 3
are reserved and modeled as reject. -/
def compOf (fb : Byte) : Option Comp :=
  match (fb.val / 32) % 4 with
  | 0 => some .none
  | 1 => some .static
  | _ => none

/-- Signature decoding (FT1536 profile): `len <= 2`, reserved bit, degree log
and ternary bit checks, then `falcon_decode_small` with exact consumption. -/
def decodeSig : Bytes → Option (List ℤ)
  | [] => none
  | fb :: rest =>
    if rest.length < 2 then none
    else if (fb.val / 16) % 2 = 1 then none
    else if fb.val % 16 ≠ 10 then none
    else if fb.val / 128 ≠ 1 then none
    else match compOf fb with
      | some c => decodeSmall c rest
      | none => none

theorem decodeSig_cons (fb : Byte) (rest : Bytes) :
    decodeSig (fb :: rest) =
      (if rest.length < 2 then none
      else if (fb.val / 16) % 2 = 1 then none
      else if fb.val % 16 ≠ 10 then none
      else if fb.val / 128 ≠ 1 then none
      else match compOf fb with
        | some c => decodeSmall c rest
        | none => none) := rfl

/-- Signature encoding (`falcon-sign.c:3412-3418`): one header byte, then
`falcon_encode_small` of the 1536 coefficients. -/
def encodeSig (c : Comp) (xs : List ℤ) : Bytes := sigHeader c :: encodeSmall c xs

theorem decodeSig_header_static (rest : Bytes) :
    decodeSig (sigHeader .static :: rest) =
      (if rest.length < 2 then none else decodeSmall .static rest) := by
  simp only [decodeSig_cons, sigHeader, compOf]
  norm_num

theorem decodeSig_header_none (rest : Bytes) :
    decodeSig (sigHeader .none :: rest) =
      (if rest.length < 2 then none else decodeSmall .none rest) := by
  simp only [decodeSig_cons, sigHeader, compOf]
  norm_num

theorem codeWord_length (w : ℤ) : (codeWord w).length = 10 + w.natAbs / 256 := by
  simp only [codeWord, List.length_cons, List.length_append, beBits_length,
    List.length_replicate, List.length_nil]
  omega

theorem encodeStatic_length_lower (xs : List ℤ) : 10 * xs.length ≤ (encodeStatic xs).length := by
  induction xs with
  | nil => simp [encodeStatic]
  | cons x xs ih =>
    have ih2 : 10 * xs.length ≤ (List.map codeWord xs).flatten.length := ih
    simp only [encodeStatic, List.map_cons, List.flatten_cons, List.length_append,
      List.length_cons]
    rw [codeWord_length]
    omega

theorem chunk8_ne_nil (fuel : ℕ) (bs : List Bool) (hf : 0 < fuel) (hb : bs ≠ []) :
    chunk8 fuel bs ≠ [] := by
  rcases hf0 : fuel with - | f
  · omega
  · cases hb0 : bs with
    | nil => exact absurd hb0 hb
    | cons x xs =>
      simp only [chunk8]
      intro hh
      simp at hh

theorem pack_length_ge2 (bs : List Bool) (h : 17 ≤ bs.length) : 2 ≤ (pack bs).length := by
  have hne : padTail bs ≠ [] := by
    intro hh
    have := congrArg List.length hh
    simp only [padTail, List.length_append, List.length_replicate, List.length_nil] at this
    omega
  have hdrop : (padTail bs).drop 8 ≠ [] := by
    intro hh
    have := congrArg List.length hh
    simp only [List.length_drop, List.length_nil] at this
    have := padTail_self bs
    omega
  have hself := padTail_self bs
  simp only [pack, List.length_map]
  cases hpb : padTail bs with
  | nil => exact absurd hpb hne
  | cons x xs =>
    simp only [chunk8, List.length_cons]
    have hf : 0 < List.length bs := by omega
    have htail : chunk8 (List.length bs) ((x :: xs).drop 8) ≠ [] :=
      chunk8_ne_nil _ _ hf (by rw [hpb] at hdrop; exact hdrop)
    have hpos : 0 < (chunk8 (List.length bs) ((x :: xs).drop 8)).length := by
      refine Nat.pos_iff_ne_zero.mpr ?_
      intro hh
      exact htail (List.eq_nil_of_length_eq_zero hh)
    omega

theorem decodeStatic_zeroPad (xs : List ℤ) (hw : ∀ x ∈ xs, x.natAbs < 2^16) (k : ℕ) (hk : k < 8) :
    decodeStatic xs.length (encodeStatic xs ++ List.replicate k false)
      = some (xs.map fun w => wordValue (decide (w < 0)) w.natAbs) := by
  have hp := parseStatic_encode xs hw (List.replicate k false)
  simp [decodeStatic, hp, hk]

theorem decodeSmall_encodeSmall_static (xs : List ℤ) (hlen : xs.length = 1536)
    (hw : ∀ x ∈ xs, int16 x) :
    decodeSmall .static (encodeSmall .static xs) = some xs := by
  have hmag : ∀ x ∈ xs, x.natAbs < 2^16 := fun x hx => by
    have h := hw x hx
    dsimp only [int16] at h
    omega
  have hpad : padTail (encodeStatic xs)
      = encodeStatic xs ++ List.replicate ((8 - (encodeStatic xs).length % 8) % 8) false := rfl
  have hk : (8 - (encodeStatic xs).length % 8) % 8 < 8 := Nat.mod_lt _ (by norm_num)
  simp only [encodeSmall, decodeSmall]
  rw [unpack_pack, hpad, ← hlen]
  rw [decodeStatic_zeroPad xs hmag _ hk]
  exact congrArg some (map_wordValue_self xs hw)

theorem decodeSmall_encodeSmall_none (xs : List ℤ) (hlen : xs.length = 1536)
    (hw : ∀ x ∈ xs, -9216 ≤ x ∧ x ≤ 9216) :
    decodeSmall .none (encodeSmall .none xs) = some xs := by
  simp only [encodeSmall, decodeSmall]
  exact none_decode_encode xs hlen hw

theorem encodeSig_consumed_static (xs : List ℤ) (hlen : xs.length = 1536)
    (hw : ∀ x ∈ xs, int16 x) : decodeSig (encodeSig .static xs) = some xs := by
  have hmag : ∀ x ∈ xs, x.natAbs < 2^16 := by
    intro x hx
    have h := hw x hx
    dsimp only [int16] at h
    omega
  have hlen2 : 2 ≤ (encodeSmall .static xs).length := by
    simp only [encodeSmall]
    exact pack_length_ge2 (encodeStatic xs) (by
      have h := encodeStatic_length_lower xs
      omega)
  have hsmall := decodeSmall_encodeSmall_static xs hlen hw
  simp only [encodeSig]
  rw [decodeSig_header_static]
  have hif : (if (encodeSmall .static xs).length < 2 then (none : Option (List ℤ))
      else decodeSmall .static (encodeSmall .static xs))
      = decodeSmall .static (encodeSmall .static xs) := by
    split_ifs with hc
    · exact absurd hc (by omega)
    · rfl
  rw [hif]
  exact hsmall

theorem encodeSig_consumed_none (xs : List ℤ) (hlen : xs.length = 1536)
    (hw : ∀ x ∈ xs, -9216 ≤ x ∧ x ≤ 9216) : decodeSig (encodeSig .none xs) = some xs := by
  have hlen2 : 2 ≤ (encodeSmall .none xs).length := by
    simp only [encodeSmall, encodeNone_length, hlen]
    norm_num
  have hsmall := decodeSmall_encodeSmall_none xs hlen hw
  simp only [encodeSig]
  rw [decodeSig_header_none]
  have hif : (if (encodeSmall .none xs).length < 2 then (none : Option (List ℤ))
      else decodeSmall .none (encodeSmall .none xs))
      = decodeSmall .none (encodeSmall .none xs) := by
    split_ifs with hc
    · exact absurd hc (by omega)
    · rfl
  rw [hif]
  exact hsmall

/-- Producer/consumer consistency (A4): the encoding produced by
`falcon_sign_generate` is accepted by `decodeSig`; with
the `encodeSig_consumed_*`/`encodeSig_inj_*` lemmas above this makes the
codec injective. -/
theorem encodeSig_inj_static (xs ys : List ℤ) (hlenx : xs.length = 1536)
    (hleny : ys.length = 1536) (hx : ∀ x ∈ xs, int16 x) (hy : ∀ y ∈ ys, int16 y)
    (h : encodeSig .static xs = encodeSig .static ys) : xs = ys := by
  have h1 := encodeSig_consumed_static xs hlenx hx
  have h2 := encodeSig_consumed_static ys hleny hy
  rw [h] at h1
  rw [h2] at h1
  exact (Option.some_inj.mp h1).symm

theorem encodeSig_inj_none (xs ys : List ℤ) (hlenx : xs.length = 1536)
    (hleny : ys.length = 1536) (hx : ∀ x ∈ xs, -9216 ≤ x ∧ x ≤ 9216)
    (hy : ∀ y ∈ ys, -9216 ≤ y ∧ y ≤ 9216)
    (h : encodeSig .none xs = encodeSig .none ys) : xs = ys := by
  have h1 := encodeSig_consumed_none xs hlenx hx
  have h2 := encodeSig_consumed_none ys hleny hy
  rw [h] at h1
  rw [h2] at h1
  exact (Option.some_inj.mp h1).symm

theorem decodeStatic_length' {n : ℕ} {bs : List Bool} {xs : List ℤ}
    (h : decodeStatic n bs = some xs) : xs.length = n :=
  decodeStatic_length h

theorem decodeSmall_mem_int16 {c : Comp} {rest : Bytes} {xs : List ℤ}
    (h : decodeSmall c rest = some xs) : ∀ x ∈ xs, int16 x := by
  cases c with
  | none => exact decodeNone_mem_int16 h
  | static => exact fun x hx => decodeStatic_mem_int16 h x hx

theorem decodeSmall_length {c : Comp} {rest : Bytes} {xs : List ℤ}
    (h : decodeSmall c rest = some xs) : xs.length = 1536 := by
  cases c with
  | none => exact decodeNone_length h
  | static =>
    have := decodeStatic_length h
    omega

theorem decodeSig_mem_int16 {b : Bytes} {xs : List ℤ} (h : decodeSig b = some xs) :
    ∀ x ∈ xs, int16 x := by
  cases hb : b with
  | nil => simp [decodeSig, hb] at h
  | cons fb rest =>
    rw [hb, decodeSig_cons] at h
    split_ifs at h; first
    | cases h
    | (rcases hc2 : compOf fb with - | c
       · simp [hc2] at h
       · have h5 : (match compOf fb with
             | some c => decodeSmall c rest
             | none => none) = decodeSmall c rest := by rw [hc2]
         rw [h5] at h
         exact decodeSmall_mem_int16 h)

theorem decodeSig_length {b : Bytes} {xs : List ℤ} (h : decodeSig b = some xs) :
    xs.length = 1536 := by
  cases hb : b with
  | nil => simp [decodeSig, hb] at h
  | cons fb rest =>
    rw [hb, decodeSig_cons] at h
    split_ifs at h; first
    | cases h
    | (rcases hc2 : compOf fb with - | c
       · simp [hc2] at h
       · have h5 : (match compOf fb with
             | some c => decodeSmall c rest
             | none => none) = decodeSmall c rest := by rw [hc2]
         rw [h5] at h
         exact decodeSmall_length h)

/-- Decoder totality of the signature codec: every byte string is either a
decoded object or a modeled reject — no third outcome. -/
theorem decodeSig_cases (b : Bytes) :
    (∃ xs, decodeSig b = some xs) ∨ decodeSig b = none := by
  rcases h : decodeSig b with - | xs
  · exact Or.inr rfl
  · exact Or.inl ⟨xs, rfl⟩

/-! ### Decoded signature object -/

/-- The 1536 decoded coefficients in the `(i, i + 768)` pairing of
`Geometry.Vec` (the `Relation.poly` layout). -/
def toVec (xs : List ℤ) : Geometry.Vec := fun i =>
  ((xs[i.val]?.getD 0), ((xs[i.val + 768]?).getD 0))

/-- Decoded signature object (A4's decoded side). -/
def sigVector (b : Bytes) : Option Geometry.Vec := (decodeSig b).map toVec

theorem sigVector_eq (b : Bytes) :
    sigVector b = (decodeSig b).map toVec := rfl

end FT1536.VerifyBind
