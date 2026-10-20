import Run2.WordEncoding

/-!
# Static small-vector codec (falcon-enc.c compress_static/uncompress_static)

Bit-stream model of the small-vector coefficient codec used by the FT1536
signature path (pinned profile: q = 18433, `j = 8` low magnitude bits, unary
continuation, 1536 values). Streams are MSB first, exactly as bits leave the
C packer; byte packing lives in `VerifyBind.ByteCodec`.

Per value the C encoder emits (`falcon-enc.c:297-368`): one sign bit
(1 = negative), the `j` low bits of the magnitude (MSB first), then
`(|w| >> j)` zero continuation bits and one terminating 1 bit. The decoder
(`falcon-enc.c:461-545`) reads that code back, rejects more than 255
continuation zeros, and stores `± mag` through an `int16_t` cast. All 16-bit
casts are modeled by `wrap16` (two's complement wrap, machine model A5).

On the reachable range `lo <= 65535` (`ne <= 255` is enforced by the source)
the C value expression `-(int16_t)lo` equals `wrap16 (-lo)`, which is what
`wordValue` below computes.
-/

namespace FT1536.VerifyBind
open FT1536.Run2.BitArithmetic

/-- The int16 representable window `-2^15 <= z < 2^15`. -/
def int16 (z : ℤ) : Prop := -2^15 ≤ z ∧ z < 2^15

/-- Two's complement reduction to 16 bits; models every C `int16_t` cast. -/
def wrap16 (z : ℤ) : ℤ := ((z + 2^15) % 2^16) - 2^15

theorem wrap16_mem (z : ℤ) : int16 (wrap16 z) := by
  have h0 : 0 ≤ (z + 2^15) % 2^16 := Int.emod_nonneg (z + 2^15) (by norm_num)
  have h1 : (z + 2^15) % 2^16 < 2^16 :=
    Int.emod_lt_of_pos (z + 2^15) (by norm_num : (0 : ℤ) < 2^16)
  dsimp only [int16, wrap16]
  omega

theorem wrap16_of_int16 (z : ℤ) (h : int16 z) : wrap16 z = z := by
  have h1 : 0 ≤ z + 2^15 := by dsimp only [int16] at h; omega
  have h2 : z + 2^15 < 2^16 := by dsimp only [int16] at h; omega
  dsimp only [wrap16]
  rw [Int.emod_eq_of_lt h1 h2]
  omega

theorem wrap16_emod (z : ℤ) : wrap16 z = wrap16 (z % 2^16) := by
  dsimp only [wrap16]
  have h1 : ((2^15 : ℤ)) % 2^16 = 2^15 := Int.emod_eq_of_lt (by norm_num) (by norm_num)
  rw [Int.add_emod z (2^15) (2^16), h1]

theorem wrap16_congr (a b : ℤ) (h : a % 2^16 = b % 2^16) : wrap16 a = wrap16 b := by
  rw [wrap16_emod, h, ← wrap16_emod]

theorem cast_natAbs_of_neg {a : ℤ} (h : a < 0) : ((a.natAbs : ℕ) : ℤ) = -a := by
  rw [← Int.natAbs_neg]
  exact Int.natAbs_of_nonneg (by omega)

/-! ### MSB-first bit groups (built from the proved LSB-first primitives) -/

/-- MSB-first `k`-bit pattern of `n` (the low `k` bits of `n`). -/
def beBits (n : ℕ) (k : ℕ) : List Bool := (encodeNat n k).reverse

/-- MSB-first reading of a bit list. -/
def beVal (bs : List Bool) : ℕ := value bs.reverse

theorem beBits_length (n k : ℕ) : (beBits n k).length = k := by
  simp only [beBits, List.length_reverse]
  exact encodeNat_length n k

theorem beVal_beBits (n k : ℕ) (h : n < 2^k) : beVal (beBits n k) = n := by
  simp only [beVal, beBits, List.reverse_reverse]
  exact encodeNat_value n k h

theorem beBits_beVal (bs : List Bool) (k : ℕ) (h : bs.length = k) :
    beBits (beVal bs) k = bs := by
  simp only [beVal, beBits]
  rw [← h, ← List.length_reverse, encodeNat_roundtrip bs.reverse, List.reverse_reverse]

theorem beVal_length8 (bs : List Bool) (h : bs.length = 8) : beVal bs < 256 := by
  have hh := value_lt bs.reverse
  rw [List.length_reverse, h] at hh
  norm_num at hh
  exact hh

/-! ### Per-value code words -/

/-- Magnitude as a sign-magnitude integer (`neg` = negative sign bit). -/
def ofSignMag : Bool → ℕ → ℤ
  | true, mag => -(mag : ℤ)
  | false, mag => (mag : ℤ)

/-- Value realized by one decoded code word: `± mag` through an int16 cast. -/
def wordValue (neg : Bool) (mag : ℕ) : ℤ := wrap16 (ofSignMag neg mag)

theorem ofSignMag_self (w : ℤ) : ofSignMag (decide (w < 0)) w.natAbs = w := by
  by_cases h : w < 0
  · rw [decide_eq_true h]
    simp only [ofSignMag]
    rw [cast_natAbs_of_neg h]
    exact neg_neg w
  · rw [decide_eq_false h]
    simp only [ofSignMag]
    exact Int.natAbs_of_nonneg (by omega)

theorem wordValue_self (w : ℤ) (h : int16 w) : wordValue (decide (w < 0)) w.natAbs = w := by
  simp only [wordValue, ofSignMag_self, wrap16_of_int16 w h]

theorem wordValue_mem (neg : Bool) (mag : ℕ) : int16 (wordValue neg mag) :=
  wrap16_mem (ofSignMag neg mag)

theorem int_eq_of_natAbs_eq_sign (x y : ℤ) (ha : x.natAbs = y.natAbs)
    (hs : (x < 0) ↔ (y < 0)) : x = y := by
  by_cases hx : x < 0
  · have hy : y < 0 := hs.mp hx
    have h1 : ((x.natAbs : ℕ) : ℤ) = -x := cast_natAbs_of_neg hx
    have h2 : ((y.natAbs : ℕ) : ℤ) = -y := cast_natAbs_of_neg hy
    have h3 : (-x : ℤ) = -y := by
      rw [← h1, ← h2]
      exact congrArg (fun n : ℕ => (n : ℤ)) ha
    omega
  · have hy : ¬ y < 0 := fun hh => hx (hs.mpr hh)
    have h1 : ((x.natAbs : ℕ) : ℤ) = x := Int.natAbs_of_nonneg (by omega)
    have h2 : ((y.natAbs : ℕ) : ℤ) = y := Int.natAbs_of_nonneg (by omega)
    rw [← h1, ← h2]
    exact congrArg (fun n : ℕ => (n : ℤ)) ha

/-- Encoder side of one value (`falcon-enc.c:289-380`, `j = 8`). -/
def codeWord (w : ℤ) : List Bool :=
  decide (w < 0) :: (beBits (w.natAbs % 256) 8
    ++ (List.replicate (w.natAbs / 256) false ++ [true]))

/-- Sign-flipped variant of `codeWord` at a given magnitude: a raw string the
decoder accepts, used to exhibit the non-canonical aliases. -/
def aliasWord (mag : ℕ) : List Bool :=
  true :: (beBits (mag % 256) 8 ++ (List.replicate (mag / 256) false ++ [true]))

/-- Encoder concatenation. -/
def encodeStatic (xs : List ℤ) : List Bool := (xs.map codeWord).flatten

theorem encodeStatic_nil : encodeStatic [] = [] := rfl

theorem encodeStatic_cons (x : ℤ) (xs : List ℤ) :
    encodeStatic (x :: xs) = codeWord x ++ encodeStatic xs := by
  simp [encodeStatic]

/-! ### Decoder side -/

/-- Continuation run: `ne` zero bits and one terminating 1 bit
(`falcon-enc.c:506-521`). -/
def parseCont : List Bool → Option (ℕ × List Bool)
  | [] => none
  | true :: bs => some (0, bs)
  | false :: bs =>
    match parseCont bs with
    | some (ne, rest) => some (ne + 1, rest)
    | none => none

theorem parseCont_replicate (ne : ℕ) (rest : List Bool) :
    parseCont (List.replicate ne false ++ true :: rest) = some (ne, rest) := by
  induction ne with
  | zero => rfl
  | succ ne ih =>
    simp only [List.replicate_succ, List.cons_append, parseCont]
    rw [ih]

/-- Take `k` bits as one MSB-first group, returning the group value and the
remaining stream (`falcon-enc.c:492-501`: read of sign + low magnitude bits). -/
def takeBits (k : ℕ) (bs : List Bool) : Option (ℕ × List Bool) :=
  if bs.length < k then none else some (beVal (bs.take k), bs.drop k)

theorem takeBits_eq (k : ℕ) (pre post : List Bool) (h : pre.length = k) :
    takeBits k (pre ++ post) = some (beVal pre, post) := by
  have hn : ¬ (pre ++ post).length < k := by simp only [List.length_append]; omega
  have htake : (pre ++ post).take k = pre := by rw [← h]; exact List.take_append_length
  have hdrop : (pre ++ post).drop k = post := by rw [← h]; exact List.drop_append_length
  simp only [takeBits, hn, ite_false, htake, hdrop]

/-- One value (`falcon-enc.c:483-544`): sign + 8 magnitude bits, continuation
run capped at 255 zeros. The realized coefficient is `wordValue neg mag`. -/
def parseWord : List Bool → Option (Bool × ℕ × List Bool)
  | [] => none
  | neg :: rest =>
    match takeBits 8 rest with
    | none => none
    | some (lo, rest') =>
      match parseCont rest' with
      | none => none
      | some (ne, rest'') =>
        if ne ≤ 255 then some (neg, lo + ne * 256, rest'') else none

/-- Streaming decode of `n` code words. -/
def parseStatic : ℕ → List Bool → Option (List ℤ × List Bool)
  | 0, bs => some ([], bs)
  | n + 1, bs =>
    match parseWord bs with
    | none => none
    | some (neg, mag, rest) =>
      match parseStatic n rest with
      | none => none
      | some (xs, rest') => some (wordValue neg mag :: xs, rest')

/-- Full static decode of one window: `n` values, trailing bits all zero and
shorter than one byte (the source's exact-consumption checks:
`falcon-enc.c:539` zero padding + `falcon-vrfy.c:1505` `!= len`). -/
def decodeStatic (n : ℕ) (bs : List Bool) : Option (List ℤ) :=
  match parseStatic n bs with
  | none => none
  | some (xs, rest) =>
    if (rest.all (· = false) = true) ∧ rest.length < 8 then some xs else none

theorem parseWord_codeWord (w : ℤ) (hw : w.natAbs < 2^16) (rest : List Bool) :
    parseWord (codeWord w ++ rest)
      = some (decide (w < 0), w.natAbs, rest) := by
  have hne : w.natAbs / 256 ≤ 255 := by omega
  have hsum : w.natAbs % 256 + (w.natAbs / 256) * 256 = w.natAbs :=
    Nat.mod_add_div' w.natAbs 256
  have htake : takeBits 8
      (beBits (w.natAbs % 256) 8 ++ (List.replicate (w.natAbs / 256) false ++ true :: rest))
      = some (w.natAbs % 256, List.replicate (w.natAbs / 256) false ++ true :: rest) := by
    rw [takeBits_eq 8 (beBits (w.natAbs % 256) 8)
      (List.replicate (w.natAbs / 256) false ++ true :: rest) (beBits_length _ 8)]
    rw [beVal_beBits (w.natAbs % 256) 8 (Nat.mod_lt _ (by norm_num))]
  have hcont : parseCont (List.replicate (w.natAbs / 256) false ++ true :: rest)
      = some (w.natAbs / 256, rest) :=
    parseCont_replicate (w.natAbs / 256) rest
  simp only [codeWord, List.cons_append, List.nil_append,
    List.append_assoc, parseWord, htake, hcont]
  rw [hsum]
  split_ifs
  rfl

theorem parseStatic_wordValue : ∀ (n : ℕ) (bs : List Bool) (xs : List ℤ) (rest : List Bool),
    parseStatic n bs = some (xs, rest) → ∀ x ∈ xs, ∃ neg mag, x = wordValue neg mag
  | 0, bs, xs, rest, h, x, hx => by
    simp [parseStatic] at h
    obtain ⟨he, ht⟩ := h
    subst he
    simp at hx
  | n + 1, bs, xs, rest, h, x, hx => by
    rcases hw : parseWord bs with - | p
    · simp [parseStatic, hw] at h
    · obtain ⟨neg, mag, rest'⟩ := p
      simp [parseStatic, hw] at h
      rcases hp : parseStatic n rest' with - | q
      · simp [hp] at h
      · obtain ⟨ys, rest''⟩ := q
        simp [hp] at h
        obtain ⟨he, ht⟩ := h
        subst he
        subst ht
        simp only [List.mem_cons] at hx
        rcases hx with hx | hx
        · exact ⟨neg, mag, hx⟩
        · exact parseStatic_wordValue n rest' ys rest'' hp x hx

theorem parseStatic_length : ∀ (n : ℕ) (bs : List Bool) (xs : List ℤ) (rest : List Bool),
    parseStatic n bs = some (xs, rest) → xs.length = n
  | 0, bs, xs, rest, h => by
    simp [parseStatic] at h
    obtain ⟨he, ht⟩ := h
    subst he
    rfl
  | n + 1, bs, xs, rest, h => by
    rcases hw : parseWord bs with - | p
    · simp [parseStatic, hw] at h
    · obtain ⟨neg, mag, rest'⟩ := p
      simp [parseStatic, hw] at h
      rcases hp : parseStatic n rest' with - | q
      · simp [hp] at h
      · obtain ⟨ys, rest''⟩ := q
        simp [hp] at h
        obtain ⟨he, ht⟩ := h
        subst he
        subst ht
        simp only [List.length_cons]
        rw [parseStatic_length n rest' ys rest'' hp]

theorem decodeStatic_eq_some {n : ℕ} {bs : List Bool} {xs : List ℤ} :
    decodeStatic n bs = some xs ↔
      ∃ rest, parseStatic n bs = some (xs, rest)
        ∧ rest.all (· = false) = true ∧ rest.length < 8 := by
  rcases hp : parseStatic n bs with - | p
  · simp [decodeStatic, hp]
  · obtain ⟨ys, rest⟩ := p
    constructor
    · intro h
      simp only [decodeStatic, hp] at h
      split_ifs at h with hc
      · simp at h
        subst h
        exact ⟨rest, rfl, hc.1, hc.2⟩
    · intro h
      obtain ⟨rest', h1, h2, h3⟩ := h
      simp at h1
      obtain ⟨he, ht⟩ := h1
      subst he
      subst ht
      simp only [decodeStatic, hp]
      split_ifs with hc
      · rfl
      · exact absurd ⟨h2, h3⟩ hc

theorem decodeStatic_mem_wordValue {n : ℕ} {bs : List Bool} {xs : List ℤ}
    (h : decodeStatic n bs = some xs) : ∀ x ∈ xs, ∃ neg mag, x = wordValue neg mag := by
  obtain ⟨rest, hp, _, _⟩ := decodeStatic_eq_some.mp h
  exact parseStatic_wordValue n bs xs rest hp

theorem decodeStatic_mem_int16 {n : ℕ} {bs : List Bool} {xs : List ℤ}
    (h : decodeStatic n bs = some xs) : ∀ x ∈ xs, int16 x := by
  intro x hx
  obtain ⟨neg, mag, he⟩ := decodeStatic_mem_wordValue h x hx
  rw [he]
  exact wordValue_mem neg mag

theorem decodeStatic_length {n : ℕ} {bs : List Bool} {xs : List ℤ}
    (h : decodeStatic n bs = some xs) : xs.length = n := by
  obtain ⟨rest, hp, _, _⟩ := decodeStatic_eq_some.mp h
  exact parseStatic_length n bs xs rest hp

theorem parseStatic_encode : ∀ (xs : List ℤ) (_hw : ∀ x ∈ xs, x.natAbs < 2^16) (rest : List Bool),
    parseStatic xs.length (encodeStatic xs ++ rest)
      = some ((xs.map fun w => wordValue (decide (w < 0)) w.natAbs), rest)
  | [], _, _ => by rfl
  | x :: xs, hw, rest => by
    have hx : x.natAbs < 2^16 := hw x (List.mem_cons_self ..)
    have hxs : ∀ y ∈ xs, y.natAbs < 2^16 := fun y hy => hw y (List.mem_cons_of_mem _ hy)
    have ih := parseStatic_encode xs hxs rest
    have hword := parseWord_codeWord x hx (encodeStatic xs ++ rest)
    simp only [List.length_cons, List.map_cons]
    rw [encodeStatic_cons, List.append_assoc]
    simp only [parseStatic, hword, ih]

theorem decodeStatic_encode (xs : List ℤ) (hw : ∀ x ∈ xs, x.natAbs < 2^16) :
    decodeStatic xs.length (encodeStatic xs)
      = some (xs.map fun w => wordValue (decide (w < 0)) w.natAbs) := by
  have hp : parseStatic xs.length (encodeStatic xs)
      = some ((xs.map fun w => wordValue (decide (w < 0)) w.natAbs), []) :=
    by simpa using parseStatic_encode xs hw []
  simp [decodeStatic, hp]

theorem map_wordValue_self (xs : List ℤ) (hw : ∀ x ∈ xs, int16 x) :
    (xs.map fun w => wordValue (decide (w < 0)) w.natAbs) = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    have hx := hw x (List.mem_cons_self ..)
    have hxs : ∀ y ∈ xs, int16 y := fun y hy => hw y (List.mem_cons_of_mem _ hy)
    simp only [List.map_cons, wordValue_self x hx, ih hxs]

/-- Encoder/decoder consistency: the static decode of any int16 vector is the
vector itself (A4, `compress_static` side). -/
theorem static_decode_encode (xs : List ℤ) (hw : ∀ x ∈ xs, int16 x) :
    decodeStatic xs.length (encodeStatic xs) = some xs := by
  have hmag : ∀ x ∈ xs, x.natAbs < 2^16 := by
    intro x hx
    have h := hw x hx
    dsimp only [int16] at h
    omega
  rw [decodeStatic_encode xs hmag]
  exact congrArg some (map_wordValue_self xs hw)

/-- The static encoder is injective on vectors of bounded magnitude; with
`static_decode_encode` this makes the decode injective on the encoder image. -/
theorem encodeStatic_inj : ∀ (xs ys : List ℤ),
    (∀ x ∈ xs, x.natAbs < 2^16) → (∀ y ∈ ys, y.natAbs < 2^16) →
    encodeStatic xs = encodeStatic ys → xs = ys
  | [], ys, _, hys, h => by
    cases ys with
    | nil => rfl
    | cons y ys =>
      exfalso
      have hy : y.natAbs < 2^16 := hys y (List.mem_cons_self ..)
      have hnone : parseWord (encodeStatic ([] : List ℤ)) = none := rfl
      have hsome : parseWord (encodeStatic (y :: ys))
          = some (decide (y < 0), y.natAbs, encodeStatic ys) := by
        rw [encodeStatic_cons]
        exact parseWord_codeWord y hy (encodeStatic ys)
      rw [← h] at hsome
      rw [hnone] at hsome
      cases hsome
  | x :: xs, ys, hxs, hys, h => by
    cases ys with
    | nil =>
      exfalso
      have hx : x.natAbs < 2^16 := hxs x (List.mem_cons_self ..)
      have hnone : parseWord (encodeStatic ([] : List ℤ)) = none := rfl
      have hsome : parseWord (encodeStatic (x :: xs))
          = some (decide (x < 0), x.natAbs, encodeStatic xs) := by
        rw [encodeStatic_cons]
        exact parseWord_codeWord x hx (encodeStatic xs)
      rw [h] at hsome
      rw [hnone] at hsome
      cases hsome
    | cons y ys =>
      have hx : x.natAbs < 2^16 := hxs x (List.mem_cons_self ..)
      have hy : y.natAbs < 2^16 := hys y (List.mem_cons_self ..)
      have hxs' : ∀ z ∈ xs, z.natAbs < 2^16 := fun z hz => hxs z (List.mem_cons_of_mem _ hz)
      have hys' : ∀ z ∈ ys, z.natAbs < 2^16 := fun z hz => hys z (List.mem_cons_of_mem _ hz)
      have px : parseWord (encodeStatic (x :: xs))
          = some (decide (x < 0), x.natAbs, encodeStatic xs) := by
        rw [encodeStatic_cons]
        exact parseWord_codeWord x hx (encodeStatic xs)
      have py : parseWord (encodeStatic (y :: ys))
          = some (decide (y < 0), y.natAbs, encodeStatic ys) := by
        rw [encodeStatic_cons]
        exact parseWord_codeWord y hy (encodeStatic ys)
      rw [h] at px
      rw [py] at px
      injection px with hpair
      obtain ⟨hp, ht⟩ := Prod.mk.inj hpair
      obtain ⟨hm, htl⟩ := Prod.mk.inj ht
      have hsign : (x < 0) ↔ (y < 0) := by
        by_cases bxx : x < 0
        · by_cases byy : y < 0
          · exact ⟨fun _ => byy, fun _ => bxx⟩
          · rw [decide_eq_true bxx, decide_eq_false byy] at hp
            cases hp
        · by_cases byy : y < 0
          · rw [decide_eq_false bxx, decide_eq_true byy] at hp
            cases hp
          · exact ⟨fun hx => absurd hx bxx, fun hy => absurd hy byy⟩
      have hxy : x = y := int_eq_of_natAbs_eq_sign x y hm.symm hsign
      have hex : xs = ys := encodeStatic_inj xs ys hxs' hys' htl.symm
      rw [hxy, hex]

/-- Uncomfortable finding (kept): the raw decoder is not injective — the sign
bit of zero is not canonical, so `aliasWord 0` and `codeWord 0` are distinct
accepted strings with the same decoded value. -/
theorem static_alias_zero :
    aliasWord 0 ≠ codeWord 0 ∧
      decodeStatic 1 (aliasWord 0) = decodeStatic 1 (codeWord 0) ∧
      decodeStatic 1 (codeWord 0) ≠ none := by decide

/-- Uncomfortable finding (kept): at magnitude 32768 the int16 wrap collides,
so `codeWord 32768` and `codeWord (-32768)` decode to the same value. Both
strings lie outside the int16 round-trip domain of `static_decode_encode`. -/
theorem static_alias_wrap :
    codeWord 32768 ≠ codeWord (-32768) ∧
      decodeStatic 1 (codeWord 32768) = decodeStatic 1 (codeWord (-32768)) ∧
      decodeStatic 1 (codeWord 32768) ≠ none := by
  have h1 : decodeStatic 1 (encodeStatic [(32768 : ℤ)]) = some [-32768] := by
    rw [show (1 : ℕ) = [(32768 : ℤ)].length from rfl]
    rw [decodeStatic_encode [(32768 : ℤ)] (by decide)]
    norm_num [wordValue, ofSignMag, wrap16]
  have h2 : decodeStatic 1 (encodeStatic [(-32768 : ℤ)]) = some [-32768] := by
    rw [show (1 : ℕ) = [(-32768 : ℤ)].length from rfl]
    rw [decodeStatic_encode [(-32768 : ℤ)] (by decide)]
    norm_num [wordValue, ofSignMag, wrap16]
  have e1 : codeWord (32768 : ℤ) = encodeStatic [(32768 : ℤ)] := by
    rw [encodeStatic_cons, encodeStatic_nil, List.append_nil]
  have e2 : codeWord (-32768) = encodeStatic [(-32768 : ℤ)] := by
    rw [encodeStatic_cons, encodeStatic_nil, List.append_nil]
  refine ⟨?_, ?_, ?_⟩
  · simp [codeWord]
  · rw [e1, e2, h1, h2]
  · rw [e1, h1]
    simp

/-- Decoder totality at the static codec: every window either decodes or is a
modeled reject — there is no third outcome. -/
theorem decodeStatic_cases (n : ℕ) (bs : List Bool) :
    (∃ xs, decodeStatic n bs = some xs) ∨ decodeStatic n bs = none := by
  rcases h : decodeStatic n bs with - | xs
  · exact Or.inr rfl
  · exact Or.inl ⟨xs, rfl⟩

end FT1536.VerifyBind
