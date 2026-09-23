import B20.Foundation.CertificateInput

/-!
# Transport of indices / sizes / certificate numerals

Sage emits certificate fields as decimal digit arrays; the Lean checker
consumes `Int`/`Nat` literals. This module defines the transport map
(decimal digit list ↔ `Nat`) and proves its soundness: decoding an encoded
value returns the value (`decodeNat_encodeNat`) for any numeral within the
declared digit budget.

The concrete digit arrays of the four `CertificateInput` fields are bound to
the checker input literals by `decide`-checked equations, so the numbers
consumed by `checkSqrt2` are exactly the transported Sage outputs.
-/

namespace B20.Foundation.Transport

/-- Big-endian decimal digit list → value. -/
def decodeNat (ds : List Nat) : Nat :=
  ds.foldl (fun acc d => acc * 10 + d) 0

/-- Value → big-endian decimal digit list, with an explicit fuel budget
(need `n < fuel`; `n + 1` always suffices). -/
def encodeNatAux : Nat -> Nat -> List Nat
  | 0, _ => []
  | fuel + 1, n => if n < 10 then [n] else encodeNatAux fuel (n / 10) ++ [n % 10]

def encodeNat (n : Nat) : List Nat := encodeNatAux (n + 1) n

theorem decodeNat_append_digit (l : List Nat) (d : Nat) :
    decodeNat (l ++ [d]) = decodeNat l * 10 + d := by
  simp [decodeNat, List.foldl_append]

theorem decodeNat_singleton (d : Nat) : decodeNat [d] = d := by
  simp [decodeNat]

/-- Soundness of the numeral transport within any sufficient fuel budget. -/
theorem decodeNat_encodeNatAux : ∀ (fuel n : Nat), n < fuel →
    decodeNat (encodeNatAux fuel n) = n := by
  intro fuel
  induction fuel with
  | zero => intro n h; omega
  | succ fuel ih =>
    intro n h
    by_cases hn : n < 10
    · simp [encodeNatAux, hn, decodeNat]
    · have h10 : 10 ≤ n := by omega
      have hdiv : n / 10 < fuel := by
        calc n / 10 < n := Nat.div_lt_self (by omega) (by decide)
          _ ≤ fuel := Nat.le_of_lt_succ h
      rw [show encodeNatAux (fuel + 1) n = encodeNatAux fuel (n / 10) ++ [n % 10] by
        simp [encodeNatAux, hn], decodeNat_append_digit, ih (n / 10) hdiv]
      omega

/-- Soundness of the numeral transport: decode is a left inverse of encode
for every `Nat` (indices, sizes, numerators, denominators). -/
theorem decodeNat_encodeNat (n : Nat) : decodeNat (encodeNat n) = n :=
  decodeNat_encodeNatAux (n + 1) n (Nat.lt_succ_self n)

/-- Sign-magnitude transport for `Int` certificate fields. -/
def decodeInt (sign : Bool) (ds : List Nat) : Int :=
  if sign then -(decodeNat ds : Int) else (decodeNat ds : Int)

theorem decodeInt_unsigned_encodeNat (n : Nat) :
    decodeInt false (encodeNat n) = n := by
  simp [decodeInt, decodeNat_encodeNat]

/-! ## Concrete transport of the pinned certificate fields

Digit arrays as serialized by the Sage producer
(`run/certificates/gen_sqrt2_certificate.sage`, output
`CERTIFICATES/sqrt2_interval.json`); equations below bind them to the
literal checker inputs in `CertificateInput.lean`. -/

def lowerNumDigits : List Nat := [1, 4, 1, 4, 2, 1, 3, 5, 6, 2, 3, 7, 3, 0, 9, 5]
def lowerDenDigits : List Nat := [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
def upperNumDigits : List Nat := [1, 4, 1, 4, 2, 1, 3, 5, 6, 2, 3, 7, 3, 0, 9, 6]
def upperDenDigits : List Nat := [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

theorem lowerNum_transport :
    (decodeNat lowerNumDigits : Int) = CertificateInput.lowerNum := by decide
theorem lowerDen_transport :
    (decodeNat lowerDenDigits : Int) = CertificateInput.lowerDen := by decide
theorem upperNum_transport :
    (decodeNat upperNumDigits : Int) = CertificateInput.upperNum := by decide
theorem upperDen_transport :
    (decodeNat upperDenDigits : Int) = CertificateInput.upperDen := by decide

end B20.Foundation.Transport
