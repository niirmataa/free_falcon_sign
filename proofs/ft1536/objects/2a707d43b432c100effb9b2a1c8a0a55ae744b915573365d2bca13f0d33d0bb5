import Run2.ScalarMachine

/- Allocation accounting for the reference bit procedures. Each recursive
bit frame reserves 32 cells (operand bits, carry/borrow, Boolean gates,
result and control tags). Inputs live in the caller's files. No reclamation
is credited within a call, so this is an upper profile for peak scratch,
not a claim that the bound is attained. Counters are ghost annotations.
The recursive branches below are those of the actual bit procedures. -/
namespace FT1536.Run2.BitAllocation
open BitArithmetic

def scan (xs ys : List Bool) : ℕ := 32*(max xs.length ys.length+1)

theorem add_bound (xs ys : List Bool) (c : Bool) : scan xs ys≤32*(add xs ys c).steps := by
  rw [add_steps]
  unfold scan
  omega

theorem subtract_bound (xs ys : List Bool) (c : Bool) : scan xs ys≤32*(subtract xs ys c).steps := by
  rw [subtract_steps]
  unfold scan
  omega

theorem compare_bound (xs ys : List Bool) : scan xs ys≤32*(compareWords xs ys).2 := by
  rw [compare_steps]
  unfold scan
  omega

def mul (xs : List Bool) : List Bool → ℕ
  | [] => 32
  | b::bs =>
      let r:=multiply xs bs
      if b then mul xs bs+scan xs (false::r.bits)+32
      else mul xs bs+32

theorem mul_bound (xs ys : List Bool) : mul xs ys≤32*(multiply xs ys).steps := by
  induction ys with
  | nil => rfl
  | cons b bs ih =>
    have ha:=add_bound xs (false::(multiply xs bs).bits) false
    cases b <;> simp only [mul,multiply,Bool.false_eq_true,ite_false,ite_true] <;> omega

def rem (xs q : List Bool) : ℕ := match xs with
  | [] => 32
  | b::bs =>
      let v:=b::(remainder bs q).bits
      match (compareWords v q).1 with
      | .lt => rem bs q+scan v q+32
      | _ => rem bs q+scan v q+scan v q+32

theorem rem_bound (xs q : List Bool) : rem xs q≤32*(remainder xs q).steps := by
  induction xs with
  | nil => rfl
  | cons b bs ih =>
    have hc:=compare_bound (b::(remainder bs q).bits) q
    have hs:=subtract_bound (b::(remainder bs q).bits) q false
    cases ho : (compareWords (b::(remainder bs q).bits) q).1 <;>
      simp only [rem,remainder,ho] <;> omega

def canonical (xs q : List Bool) : ℕ := rem xs q+2*q.length+32

theorem canonical_bound (xs q : List Bool) : canonical xs q≤32*(canonicalRemainder xs q).steps := by
  have hh:=rem_bound xs q
  simp only [canonical,canonicalRemainder]
  omega

def fmul (xs ys : List Bool) : ℕ :=
  mul xs ys+canonical (multiply xs ys).bits modulusBits+32
def fadd (xs ys : List Bool) : ℕ :=
  scan xs ys+canonical (add xs ys false).bits modulusBits+32

theorem fmul_bound (xs ys : List Bool) : fmul xs ys≤32*(fieldMultiply xs ys).steps := by
  have hm:=mul_bound xs ys
  have hr:=canonical_bound (multiply xs ys).bits modulusBits
  simp only [fmul,fieldMultiply]
  omega

theorem fadd_bound (xs ys : List Bool) : fadd xs ys≤32*(fieldAdd xs ys).steps := by
  have hm:=add_bound xs ys false
  have hr:=canonical_bound (add xs ys false).bits modulusBits
  simp only [fadd,fieldAdd]
  omega

def sadd (x y : SignedWord) : ℕ :=
  if x.negative=y.negative then scan x.magnitude y.magnitude+32
  else match (compareWords x.magnitude y.magnitude).1 with
    | .lt => scan x.magnitude y.magnitude+scan y.magnitude x.magnitude+32
    | _ => scan x.magnitude y.magnitude+scan x.magnitude y.magnitude+32

theorem sadd_bound (x y : SignedWord) : sadd x y≤32*(signedAdd x y).steps := by
  have ha:=add_bound x.magnitude y.magnitude false
  have hc:=compare_bound x.magnitude y.magnitude
  have hs:=subtract_bound x.magnitude y.magnitude false
  have hr:=subtract_bound y.magnitude x.magnitude false
  by_cases he : x.negative=y.negative
  · simp only [sadd,signedAdd,he,ite_true]; omega
  · cases ho : (compareWords x.magnitude y.magnitude).1 <;>
      simp only [sadd,signedAdd,he,ite_false,ho] <;> omega

def smul (x y : SignedWord) : ℕ := mul x.magnitude y.magnitude+32

theorem smul_bound (x y : SignedWord) : smul x y≤32*(signedMultiply x y).steps := by
  have hh:=mul_bound x.magnitude y.magnitude
  simp only [smul,signedMultiply]
  omega

def sless (x y : SignedWord) : ℕ :=
  sadd x (signedNeg y)+scan (signedAdd x (signedNeg y)).word.magnitude []+32

theorem sless_bound (x y : SignedWord) : sless x y≤32*(signedLess x y).2 := by
  have ha:=sadd_bound x (signedNeg y)
  have hc:=compare_bound (signedAdd x (signedNeg y)).word.magnitude []
  simp only [sless,signedLess]
  omega

def center (xs : List Bool) : ℕ :=
  match (compareWords xs halfModulusBits).1 with
  | .gt => scan xs halfModulusBits+scan modulusBits xs+32
  | _ => scan xs halfModulusBits+32

theorem center_bound (xs : List Bool) : center xs≤32*(centerCode xs).steps := by
  have hc:=compare_bound xs halfModulusBits
  have hs:=subtract_bound modulusBits xs false
  cases ho : (compareWords xs halfModulusBits).1 <;>
    simp only [center,centerCode,ho] <;> omega

def reduceSigned (x : SignedWord) : ℕ :=
  let r:=canonicalRemainder x.magnitude modulusBits
  if x.negative then canonical x.magnitude modulusBits+fmul r.bits negOneBits+32
  else canonical x.magnitude modulusBits+32

theorem reduceSigned_bound (x : SignedWord) : reduceSigned x≤32*(fieldReduceSigned x).steps := by
  have hr:=canonical_bound x.magnitude modulusBits
  have hm:=fmul_bound (canonicalRemainder x.magnitude modulusBits).bits negOneBits
  cases ho : x.negative <;>
    simp only [reduceSigned,fieldReduceSigned,ho,Bool.false_eq_true,ite_false,ite_true] <;> omega

def fsub (xs ys : List Bool) : ℕ := fmul ys negOneBits+fadd xs (fieldMultiply ys negOneBits).bits+32

theorem fsub_bound (xs ys : List Bool) : fsub xs ys≤32*(fieldSubtract xs ys).steps := by
  have hm:=fmul_bound ys negOneBits
  have ha:=fadd_bound xs (fieldMultiply ys negOneBits).bits
  simp only [fsub,fieldSubtract]
  omega

end FT1536.Run2.BitAllocation

#print axioms FT1536.Run2.BitAllocation.mul_bound
#print axioms FT1536.Run2.BitAllocation.rem_bound
#print axioms FT1536.Run2.BitAllocation.reduceSigned_bound
#print axioms FT1536.Run2.BitAllocation.fsub_bound
