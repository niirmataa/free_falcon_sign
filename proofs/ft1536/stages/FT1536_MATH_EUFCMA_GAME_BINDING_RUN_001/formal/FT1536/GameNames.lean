import FT1536.GameByte
import FT1536.ROM

/-! # Name bijection and pair-table addressing (task Etap A)

Every literal byte string is exactly one legal name kind (short < 40 bytes or
framed Sign name): `render : NameKind → Name` and `decodeName : Name → NameKind`
are mutually inverse, so the front-end is a bijection onto literal byte
strings. Table addresses are the pair names used by `ROM.State`:

* `NameBody = { b : Name // b.length < 40 } ⊕ Nonce` — short namespace or
  40-byte nonce frame;
* `embedName : NameKind → NameBody × Message` is injective (canonical form);
* `paint` renders a pair address back to literal bytes;
* `tableAddr = embedName ∘ decodeName` satisfies `paint (tableAddr n) = n`,
  so pair-equality of addresses coincides with byte-equality of names.

Short names and Sign names cannot collide (GameByte.short_ne_sign); no name is
ever truncated (GameByte.render_sign_frame). No `sorry` in this module. -/

namespace FT1536.GameNames
open GameByte

/-- Table name body: short namespace or nonce frame. -/
abbrev NameBody := { b : Name // b.length < 40 } ⊕ Nonce

theorem take40_len (n : Name) (h : 40 ≤ n.length) : (n.take 40).length = 40 := by
  simp [List.length_take, Nat.min_eq_left h]

theorem length_take40 (n : Name) : (n.take 40).length ≤ 40 := by
  simp [List.length_take]

/-- Nonce decoded from the first 40 bytes of a name. No proof argument, so all
rewrites involving this function are motive-safe. -/
def nonceOfBytes (l : Name) : Nonce :=
  ⟨bytesVal (l.take 40), by
    have hlt := bytesVal_lt (l.take 40)
    have hle := length_take40 l
    have hmono : (256:ℕ) ^ ((l.take 40).length) ≤ 256 ^ 40 :=
      Nat.pow_le_pow_of_le (by norm_num) hle
    rw [← pow256_40]
    exact hlt.trans_le hmono⟩

theorem bytesLE_bytesVal40 (l : List Byte) (h : l.length = 40) :
    bytesLE (bytesVal l) 40 = l := by
  rw [← h]
  exact bytesLE_bytesVal l

theorem nonceBytes_nonceOfBytes (l : Name) (h : 40 ≤ l.length) :
    nonceBytes (nonceOfBytes l) = l.take 40 := by
  show bytesLE (bytesVal (l.take 40)) 40 = l.take 40
  exact bytesLE_bytesVal40 (l.take 40) (take40_len l h)

theorem nonceOfBytes_nonceBytes (r : Nonce) : nonceOfBytes (nonceBytes r) = r := by
  apply Fin.ext
  show bytesVal ((nonceBytes r).take 40) = r.val
  rw [List.take_of_length_le (le_of_eq (nonceBytes_length r))]
  exact nonceBytes_val r

/-- Decode a literal byte string into its unique name kind. -/
def decodeName (n : Name) : NameKind :=
  if h : n.length < 40 then .short n h
  else .sign (nonceOfBytes n) (n.drop 40)

/-- Decoding short names is the identity on bytes. -/
theorem decodeName_short (n : Name) (h : n.length < 40) :
    decodeName n = .short n h := by
  simp [decodeName, h]

/-- Decoding a framed name splits at exactly 40 bytes. -/
theorem decodeName_sign (n : Name) (h : 40 ≤ n.length) :
    decodeName n = .sign (nonceOfBytes n) (n.drop 40) := by
  simp [decodeName, show ¬ n.length < 40 from by omega]

/-- Decoding then rendering is the identity on every literal byte string:
the front-end never truncates and never aliases two byte strings. -/
theorem render_decodeName (n : Name) : render (decodeName n) = n := by
  by_cases h : n.length < 40
  · rw [decodeName_short n h]
    rfl
  · have h40 : 40 ≤ n.length := by omega
    rw [decodeName_sign n h40]
    show signName (nonceOfBytes n) (n.drop 40) = n
    simp only [signName]
    rw [nonceBytes_nonceOfBytes n h40]
    exact List.take_append_drop 40 n

/-- Rendering then decoding is the identity on name kinds. -/
theorem decodeName_render (k : NameKind) : decodeName (render k) = k :=
  render_injective (render_decodeName (render k))

/-- `NameKind` is in bijection with literal byte strings. -/
theorem nameKind_bijection :
    (∀ n : Name, render (decodeName n) = n) ∧
    (∀ k : NameKind, decodeName (render k) = k) ∧
    Function.Injective (render : NameKind → Name) :=
  ⟨render_decodeName, decodeName_render, render_injective⟩

/-- Canonical embedding of name kinds into `ROM.State` pair names. -/
def embedName : NameKind → NameBody × Message
  | .short b hb => (Sum.inl ⟨b, hb⟩, ([] : Message))
  | .sign r m => (Sum.inr r, m)

/-- Render a pair address back to literal bytes (short: raw bytes; framed:
40-byte nonce frame plus message). -/
def paint : NameBody × Message → Name
  | (Sum.inl b, _) => b.val
  | (Sum.inr r, m) => signName r m

/-- Well-formedness of pair addresses: the short namespace carries the empty
canonical message. All addresses produced by `tableAddr` are well-formed. -/
def WF : NameBody × Message → Prop
  | (Sum.inl _, m) => m = []
  | (Sum.inr _, _) => True

theorem paint_embedName (k : NameKind) : paint (embedName k) = render k := by
  cases k with
  | short b hb => rfl
  | sign r m => rfl

theorem embedName_injective : Function.Injective embedName := by
  intro k k' h
  have := congrArg paint h
  rw [paint_embedName, paint_embedName] at this
  exact render_injective this

theorem embedName_wf (k : NameKind) : WF (embedName k) := by
  cases k with
  | short b hb => rfl
  | sign r m => trivial

/-- Paint is injective on well-formed pair addresses. -/
theorem paint_injective_wf {p q : NameBody × Message} (hp : WF p) (hq : WF q)
    (h : paint p = paint q) : p = q := by
  rcases p with ⟨pb, pm⟩
  rcases q with ⟨qb, qm⟩
  cases pb with
  | inl sb =>
    rcases sb with ⟨b, hb⟩
    cases qb with
    | inl tb =>
      rcases tb with ⟨c, hc⟩
      have hp0 : pm = ([] : Message) := hp
      have hq0 : qm = ([] : Message) := hq
      subst hp0
      subst hq0
      have hbc : b = c := h
      subst hbc
      rfl
    | inr tr =>
      exact (short_ne_sign b hb tr qm h).elim
  | inr sr =>
    cases qb with
    | inl tb =>
      rcases tb with ⟨c, hc⟩
      exact (short_ne_sign c hc sr pm h.symm).elim
    | inr tr =>
      simp only [paint, signName] at h
      have hlen : (nonceBytes sr).length = (nonceBytes tr).length := by
        simp only [nonceBytes_length]
      have ⟨hf, hm⟩ := List.append_inj h hlen
      have hr : sr = tr := nonceBytes_injective hf
      subst hr
      subst hm
      rfl

/-- Pair-table addressing of a literal byte name. -/
def tableAddr (n : Name) : NameBody × Message := embedName (decodeName n)

theorem tableAddr_wf (n : Name) : WF (tableAddr n) := embedName_wf (decodeName n)

/-- Address round trip reproduces the exact literal bytes (compatibility of
pair addressing with literal byte strings). -/
theorem paint_tableAddr (n : Name) : paint (tableAddr n) = n := by
  show paint (embedName (decodeName n)) = n
  rw [paint_embedName, render_decodeName]

/-- Pair-equality of addresses coincides with byte-equality of names. -/
theorem tableAddr_injective : Function.Injective tableAddr := by
  intro n n' h
  have := congrArg paint h
  rw [paint_tableAddr, paint_tableAddr] at this
  exact this

theorem take40_sign (r : GameByte.Nonce) (m : Message) :
    (signName r m).take 40 = nonceBytes r := by
  show (nonceBytes r ++ m).take (nonceBytes r).length = nonceBytes r
  exact List.take_left

theorem drop40_sign (r : GameByte.Nonce) (m : Message) :
    (signName r m).drop 40 = m := by
  show (nonceBytes r ++ m).drop (nonceBytes r).length = m
  exact List.drop_left

theorem nonceOfBytes_sign (r : GameByte.Nonce) (m : Message) :
    nonceOfBytes (signName r m) = r := by
  apply Fin.ext
  show bytesVal ((signName r m).take 40) = r.val
  rw [take40_sign r m]
  exact nonceBytes_val r

/-- A Sign address is exactly the framed pair. -/
theorem tableAddr_sign (r : GameByte.Nonce) (m : Message) :
    tableAddr (signName r m) = (Sum.inr r, m) := by
  have hlen : 40 ≤ (signName r m).length := by
    rw [signName_length]
    omega
  show embedName (decodeName (signName r m)) = _
  rw [decodeName_sign _ hlen, nonceOfBytes_sign r m, drop40_sign r m]
  rfl

/-- Short names address the short namespace with the canonical empty message. -/
theorem tableAddr_short (b : Name) (hb : b.length < 40) :
    tableAddr b = (Sum.inl ⟨b, hb⟩, ([] : Message)) := by
  show embedName (decodeName b) = _
  rw [decodeName_short b hb]
  rfl

/-- Short names never coincide with any Sign address. -/
theorem short_addr_ne_sign (b : Name) (hb : b.length < 40) (r : GameByte.Nonce)
    (m : Message) : tableAddr b ≠ (Sum.inr r, m) := by
  intro h
  have := congrArg paint h
  rw [paint_tableAddr] at this
  exact short_ne_sign b hb r m this

end FT1536.GameNames
