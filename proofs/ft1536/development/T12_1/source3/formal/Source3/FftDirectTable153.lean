import Source3.FftCubicWord147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftDirectTable153

theorem mapM_lookup {α β : Type} (f : α → Option β) (xs : List α) (ys : List β)
    (source : xs.mapM f=some ys) (i : Nat) : (xs[i]?).bind f=ys[i]? := by
  induction xs generalizing ys i with
  | nil =>
    have same : ys=[] := (Option.some.inj source).symm
    subst ys
    simp
  | cons x xs ih =>
    rw [List.mapM_cons] at source
    obtain ⟨y,head,rest⟩ := Option.bind_eq_some_iff.mp source
    obtain ⟨tail,runTail,result⟩ := Option.bind_eq_some_iff.mp rest
    have same : y::tail=ys := Option.some.inj result
    subst ys
    cases i with
    | zero => exact head
    | succ i => exact ih tail runTail i

/-- Parse only the requested pinned row; total fallback agrees with the source table. -/
def pair (table : FftTableParser.Table) (i : Nat) : BitVec 64 × BitVec 64 :=
  (((FftTableParser.rows table)[i]?).bind FftTableParser.pair).getD (0,0)

theorem source (table : FftTableParser.Table) (i : Nat) :
    pair table i=((FftTableSources.pairs table)[i]?).getD (0,0) := by
  unfold pair
  rw [mapM_lookup FftTableParser.pair (FftTableParser.rows table) (FftTableSources.pairs table) (FftTableSources.pairs_bound table) i]

theorem square (i : Nat) : pair .square i=FftGroupTwiddle143.pair i := source .square i
theorem cubic (i : Nat) : pair .cubic i=FftCubicWord147.pair i := source .cubic i

end FT1536.Source3.FftDirectTable153
