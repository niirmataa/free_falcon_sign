import GaussianPolynomial017
import GaussianBounds017
import ActualTables016

set_option maxRecDepth 8192

set_option exponentiation.threshold 100000

namespace FT1536.S05.GaussianCheck017
open GaussianData017 GaussianPolynomial017

def previous (i : ℕ) : ℕ := if i=0 then 0 else TableData016.cdf (i-1)
def weight (i : ℕ) : ℕ := TableData016.cdf i-previous i

def recurrenceCheck (k : ℕ) : Bool := decide (
  lower (k+1)*(numerator (2*k+1)*2^400+denominator)≤lower k*denominator*2^400 ∧
  upper k*denominator≤upper (k+1)*numerator (2*k+1))

def cdfCheck (i : ℕ) : Bool :=
  let k := ((i : ℤ)-15360).natAbs
  decide (previous i<TableData016.cdf i ∧
    weight i*2^236≤(2^108+1)*lower k ∧ (2^108-1)*upper k≤weight i*2^236)

def thresholdCheck (i : ℕ) : Bool :=
  let k := ((i : ℤ)-30720).natAbs
  decide (TableData016.threshold i*2^128≤lower k ∧
    (k≤15360 → (2^108-1)*upper k≤TableData016.threshold i*2^236))

def row (i : ℕ) : Bool :=
  (if i<30720 then recurrenceCheck i else true) &&
  (if i<30721 then cdfCheck i else true) && thresholdCheck i

def block (j : ℕ) : Bool := (List.range 128).all (fun off =>
  if 128*j+off<61441 then row (128*j+off) else true)

theorem initial_lower : lower 0=2^384 := by decide

theorem initial_upper : upper 0=2^384 := by decide

theorem total_cdf_cap : TableData016.cdf 30720≤2723*2^256 := by decide

#print axioms initial_lower
#print axioms initial_upper
#print axioms total_cdf_cap
end FT1536.S05.GaussianCheck017
