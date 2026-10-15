import ProducerWholeStep020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CommandDecode020E11
open WordRAM020 WordPatch020E5

/-- Outer none is malformed encoding; some none is a genuine empty slot.
    Padding is checked, and active addresses use the signed Word512 check. -/
def decode (n : Nat) (v : Fin 3 → Word) : Option (Option (Write n)) :=
  if v 0=0 then if v 1=0 ∧ v 2=0 then some none else none
  else if v 0=1 then (address n (v 1)).map (fun j => some (j,v 2)) else none

theorem roundtrip {n : Nat} (hn : n≤2^511) (x : Option (Write n)) :
    decode n ((ScriptStore020E5.writeCodec n hn).encode x)=some x := by
  cases x with
  | none => rfl
  | some w =>
    rcases w with ⟨j,v⟩
    change (if (1 : Word)=0 then _ else if (1 : Word)=1 then (address n (word j.val)).map (fun k => some (k,v)) else none)=some (some (j,v))
    rw [ProducerWordLaws020E6.address_nat hn j]
    rfl

theorem sound {n : Nat} (hn : n≤2^511) (v : Fin 3 → Word) (x : Option (Write n))
    (h : decode n v=some x) : (ScriptStore020E5.writeCodec n hn).encode x=v := by
  unfold decode at h
  split at h
  · rename_i ht
    split at h
    · rename_i hp
      cases Option.some.inj h
      funext j
      fin_cases j
      · exact ht.symm
      · exact hp.1.symm
      · exact hp.2.symm
    · cases h
  · split at h
    · rename_i ht
      cases ha : address n (v 1) with
      | none => rw [ha] at h;cases h
      | some a =>
        rw [ha] at h
        cases Option.some.inj h
        funext j
        fin_cases j
        · exact ht.symm
        · exact (ProducerAddress020E7.some_word (v 1) a ha).symm
        · rfl
    · cases h

theorem malformed_tag (n : Nat) (v : Fin 3 → Word) (h0 : v 0≠0) (h1 : v 0≠1) : decode n v=none := by
  simp only [decode,h0,h1,ite_false]

theorem malformed_padding (n : Nat) (v : Fin 3 → Word) (h0 : v 0=0) (hp : ¬(v 1=0 ∧ v 2=0)) : decode n v=none := by
  simp only [decode,h0,hp,ite_true,ite_false]

theorem malformed_address (n : Nat) (v : Fin 3 → Word) (h1 : v 0=1) (ha : address n (v 1)=none) : decode n v=none := by
  simp only [decode,h1,ha]
  rfl

theorem accepts_iff {n : Nat} (hn : n≤2^511) (v : Fin 3 → Word) :
    (∃ x,decode n v=some x) ↔ ∃ x,(ScriptStore020E5.writeCodec n hn).encode x=v := by
  constructor
  · rintro ⟨x,h⟩;exact ⟨x,sound hn v x h⟩
  · rintro ⟨x,h⟩;rw [←h];exact ⟨x,roundtrip hn x⟩

end FT1536.S05.CommandDecode020E11
