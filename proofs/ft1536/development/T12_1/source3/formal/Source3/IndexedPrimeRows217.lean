import Source3.SixthStepPrefix217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- An indexed row of the pinned PRIMES3 source table; the default is used
   only outside the checked source range. -/
namespace FT1536.Source3.IndexedPrimeRows217
open KeygenStaticTables (values rowCount)

def row (k : Nat) : Nat×Nat×Nat := ((values .ternary)[k]?).getD (0,0,0)

theorem present (xs : List (Nat×Nat×Nat)) (k : Nat) (fallback : Nat×Nat×Nat) (bound : k<xs.length) :
    xs[k]?=some (xs[k]?.getD fallback) := by
  simp only [List.getElem?_eq_getElem bound,Option.getD_some]

theorem source (k : Nat) (bound : k < rowCount .ternary) :
    (values .ternary)[k]?=some (row k) :=
  present (values .ternary) k (0,0,0) (by rw [KeygenPrimeTableBinding.source_length]; exact bound)

end FT1536.Source3.IndexedPrimeRows217
