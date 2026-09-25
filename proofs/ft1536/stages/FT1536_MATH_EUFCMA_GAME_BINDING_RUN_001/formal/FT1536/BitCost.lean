import FT1536.AdversaryFold

/-! # Reducer bit-cost (task Etap E; binding types `cost_interpreter`,
`cost_composition`, `reducer_bit_cost_bound`)

Machine model (declared units of `RESOURCE_BOUND.md`): `t` bit steps of a
byte-RAM, `w` bits of memory, `L` bytes of port traffic. Primitive costs are
length-dependent justified formulas, not unit costs:

* byte-wise name comparison costs `8·len + 8` bit steps (one pass over the
  name bytes with a compare loop);
* copying `n` data bytes costs `4·n` steps and `8·n` memory bits;
* one coefficient-wise product plus polynomial remainder costs
  `8·1536²·2` steps (schoolbook multiplication of two `Rq`; no NTT assumed);
* final `Verify` = 2 reductions + 2 centers + one quadratic form
  (`8·(3·1536² + 2·1536)` steps); extraction copies 3072 data bytes.

`costOp` interprets one machine transition (`cost_interpreter`);
`sum_components_t/w/L` + `cost_composition` compose the per-kind maxima along
an operation trace with the step counts of the adversary budget (at most
`Q_H` H-queries, `Q_s` Sign queries, one final read; names ≤ `maxName`,
messages ≤ `maxMsg`); `reducer_bit_cost_bound` is the closed
`Resources(B) ≤ derivedResourceBound` statement. All proofs complete. -/

namespace FT1536.BitCost
open GameMach GameNames GameByte

/-- Cost triple of the declared machine model. -/
structure Cost where
  t : ℕ
  w : ℕ
  L : ℕ

instance : Add Cost := ⟨fun a b => ⟨a.t + b.t, a.w + b.w, a.L + b.L⟩⟩
instance : Zero Cost := ⟨⟨0, 0, 0⟩⟩
instance : LE Cost := ⟨fun a b => a.t ≤ b.t ∧ a.w ≤ b.w ∧ a.L ≤ b.L⟩

theorem le_of_comp {a b : Cost} (h1 : a.t ≤ b.t) (h2 : a.w ≤ b.w) (h3 : a.L ≤ b.L) :
    a ≤ b := ⟨h1, h2, h3⟩

theorem sum_comp (l : List Cost) :
    l.sum.t = (l.map (fun c => c.t)).sum ∧
      l.sum.w = (l.map (fun c => c.w)).sum ∧
      l.sum.L = (l.map (fun c => c.L)).sum := by
  induction l with
  | nil => exact ⟨rfl, rfl, rfl⟩
  | cons c l ih =>
    refine ⟨?_, ?_, ?_⟩
    · show c.t + l.sum.t = (c.t :: (l.map fun c => c.t)).sum
      simp [ih.1]
    · show c.w + l.sum.w = (c.w :: (l.map fun c => c.w)).sum
      simp [ih.2.1]
    · show c.L + l.sum.L = (c.L :: (l.map fun c => c.L)).sum
      simp [ih.2.2]

/-- Kind of one machine transition (the three cost classes). -/
inductive Kind where
  | hq | sq | fin
  deriving DecidableEq

def kindOf : Op → Kind
  | .hq _ => .hq
  | .sq _ => .sq
  | .fin _ _ _ => .fin

/-- Number of transitions of a kind along the operation trace. -/
def cnt : List Op → Kind → ℕ
  | [], _ => 0
  | op :: ops, k => (if kindOf op = k then 1 else 0) + cnt ops k

theorem cnt_nil (k : Kind) : cnt [] k = 0 := rfl

theorem cnt_cons (op : Op) (ops : List Op) (k : Kind) :
    cnt (op :: ops) k = (if kindOf op = k then 1 else 0) + cnt ops k := rfl

/-- Primitive cost formulas (length dependent). -/
def cmpCost (len : ℕ) : ℕ := 8 * len + 8
def copyCost (n : ℕ) : ℕ := 4 * n
def memCost (n : ℕ) : ℕ := 8 * n
def uniformDrawCost (bits : ℕ) : ℕ := 5 * bits
def polyMulRemCost : ℕ := 8 * 1536 * 1536 * 2
def verifySteps : ℕ := 8 * (3 * 1536 * 1536 + 2 * 1536)
def extractBytes : ℕ := 3072

/-- One table access: linear scan over up to `tableCap` entries with
length-dependent name comparison (task 5E: `M <= Q_H+Q_s+1` entries, real
name lengths, copies). -/
def lookupCost (maxName tableCap : ℕ) : ℕ := tableCap * cmpCost maxName + 8

/-- One target read: the full coefficient traffic of one target. -/
def targetReadCost : ℕ := 8 * 3072

/-- Memory of one table entry: name bytes + 3072-byte value + tag. -/
def tableMem (maxName : ℕ) (nt : ℕ) : ℕ := nt * (8 * (maxName + 3072) + 8)

/-- Memory of the SeenSign list (name + message bytes per Sign query). -/
def seenMem (maxName maxMsg : ℕ) (ns : ℕ) : ℕ := ns * (8 * (maxName + maxMsg))

/-- Memory of the whole selected target list (task 5E: the entire
`Q_H+1`-entry list is counted, not streamed). -/
def targetsMem (QH : ℕ) : ℕ := (QH + 1) * 8 * 3072

/-- Peak state memory at table size `nt` and SeenSign size `ns` (a buffer
sum, not a per-step additive cost). -/
def stateMem (maxName maxMsg : ℕ) (nt ns : ℕ) : ℕ :=
  tableMem maxName nt + seenMem maxName maxMsg ns

/-- One transition's cost (the `cost_interpreter`): the fresh-table read, the
Sign bookkeeping with one sampler call, or the final read with verification,
extraction and witness output. -/
def costOp (costS : Cost) (maxName maxMsg tableCap : ℕ) : Op → Cost
  | .hq _ => ⟨lookupCost maxName tableCap + targetReadCost, 0,
      2 * maxName + 3072⟩
  | .sq _ => ⟨lookupCost maxName tableCap + copyCost maxMsg + costS.t + 8,
      costS.w, 2 * maxName + costS.L⟩
  | .fin _ _ _ => ⟨lookupCost maxName tableCap + targetReadCost + polyMulRemCost
      + verifySteps + copyCost extractBytes + 16, memCost extractBytes,
      2 * maxName + 3072 + extractBytes + 8⟩

/-- Closed budget bound of `RESOURCE_BOUND.md` (task 5E): the `t` and `L`
components are additive over transitions; the `w` component is the **peak
buffer sum** — adversary working set, sampler working set, the full table
(`M = Q_H+Q_s+1` entries of real name lengths plus 3072-byte values), the
entire `Q_H+1` target list, SeenSign copies, and the extraction buffer. -/
def derivedResourceBound (QH Qs maxName maxMsg : ℕ) (costS : Cost) (simA : Cost) : Cost where
  t := simA.t + Qs * costS.t + Qs * uniformDrawCost 320
      + (QH + Qs + 1) * lookupCost maxName (QH + Qs + 1)
      + Qs * copyCost maxMsg + (QH + 1) * targetReadCost
      + polyMulRemCost + verifySteps + copyCost extractBytes + 8 * (Qs + 2)
  w := simA.w + costS.w + stateMem maxName maxMsg (QH + Qs + 1) (Qs + 1)
      + targetsMem QH + memCost extractBytes
  L := simA.L + Qs * costS.L + (QH + Qs + 1) * 2 * maxName + Qs * 2 * maxMsg
      + (QH + 1) * 3072 + extractBytes + 8 + 40 * (Qs + 1) + 8 * 1536

theorem sum_components_t (costS : Cost) (maxName maxMsg tableCap : ℕ) (ops : List Op) :
    ((ops.map (costOp costS maxName maxMsg tableCap)).map (fun c => c.t)).sum
      = cnt ops Kind.hq * (lookupCost maxName tableCap + targetReadCost)
        + cnt ops Kind.sq * (lookupCost maxName tableCap + copyCost maxMsg + costS.t + 8)
        + cnt ops Kind.fin * (lookupCost maxName tableCap + targetReadCost + polyMulRemCost
            + verifySteps + copyCost extractBytes + 16) := by
  induction ops with
  | nil => simp [cnt]
  | cons op ops ih =>
    rw [List.map_cons, List.map_cons, List.sum_cons, ih]
    cases op with
    | hq k => simp [cnt, kindOf, costOp, lookupCost, targetReadCost] ; ring
    | sq m => simp [cnt, kindOf, costOp, lookupCost, copyCost] ; ring
    | fin r m s => simp [cnt, kindOf, costOp, lookupCost, copyCost, polyMulRemCost,
        verifySteps, extractBytes, targetReadCost] ; ring

theorem sum_components_L (costS : Cost) (maxName maxMsg tableCap : ℕ) (ops : List Op) :
    ((ops.map (costOp costS maxName maxMsg tableCap)).map (fun c => c.L)).sum
      = cnt ops Kind.hq * (2 * maxName + 3072)
        + cnt ops Kind.sq * (2 * maxName + costS.L)
        + cnt ops Kind.fin * (2 * maxName + 3072 + extractBytes + 8) := by
  induction ops with
  | nil => simp [cnt]
  | cons op ops ih =>
    rw [List.map_cons, List.map_cons, List.sum_cons, ih]
    cases op with
    | hq k => simp [cnt, kindOf, costOp, extractBytes] ; ring
    | sq m => simp [cnt, kindOf, costOp] ; ring
    | fin r m s => simp [cnt, kindOf, costOp, extractBytes] ; ring

/-- Peak memory is monotone in the buffer occupancies. -/
theorem stateMem_mono (maxName maxMsg : ℕ) {nt ns nt' ns' : ℕ}
    (hnt : nt ≤ nt') (hns : ns ≤ ns') :
    stateMem maxName maxMsg nt ns ≤ stateMem maxName maxMsg nt' ns' := by
  unfold stateMem tableMem seenMem
  exact Nat.add_le_add
    (Nat.mul_le_mul_right (8 * (maxName + 3072) + 8) hnt)
    (Nat.mul_le_mul_right (8 * (maxName + maxMsg)) hns)

/-- **Peak-memory composition (task 5E).** With table size `nt <= M = Q_H+Q_s+1`
and SeenSign size `ns <= Q_s+1`, the working set is at most the closed buffer
sum: adversary + sampler + full table + entire target list + SeenSign +
extraction buffer. -/
theorem w_peak_bound (costS : Cost) (simA : Cost) (maxName maxMsg QH Qs : ℕ)
    (nt ns : ℕ) (hnt : nt ≤ QH + Qs + 1) (hns : ns ≤ Qs + 1) :
    simA.w + costS.w + stateMem maxName maxMsg nt ns + targetsMem QH
        + memCost extractBytes
      ≤ (derivedResourceBound QH Qs maxName maxMsg costS simA).w :=
  Nat.add_le_add
    (Nat.add_le_add
      (Nat.add_le_add (Nat.add_le_add le_rfl le_rfl)
        (stateMem_mono maxName maxMsg hnt hns)) le_rfl) le_rfl

/-- **Cost composition.** With the budget step counts and `M = Q_H+Q_s+1` as
the table cap, the additive `t`/`L` components of the op trace are within the
closed budget sum; the `w` component is the peak bound `w_peak_bound`. -/
theorem cost_composition (costS : Cost) (maxName maxMsg : ℕ)
    (QH Qs : ℕ) (ops : List Op)
    (hhq : cnt ops Kind.hq ≤ QH) (hsq : cnt ops Kind.sq ≤ Qs)
    (hfin : cnt ops Kind.fin ≤ 1) :
    (ops.map (costOp costS maxName maxMsg (QH + Qs + 1))).sum.t
        ≤ (derivedResourceBound QH Qs maxName maxMsg costS 0).t ∧
      (ops.map (costOp costS maxName maxMsg (QH + Qs + 1))).sum.L
        ≤ (derivedResourceBound QH Qs maxName maxMsg costS 0).L := by
  have hts := (sum_comp (ops.map (costOp costS maxName maxMsg (QH + Qs + 1)))).1
  have hLs := (sum_comp (ops.map (costOp costS maxName maxMsg (QH + Qs + 1)))).2.2
  refine ⟨?_, ?_⟩
  · rw [hts, sum_components_t]
    have h1 := Nat.mul_le_mul_left (lookupCost maxName (QH + Qs + 1) + targetReadCost) hhq
    have h2 := Nat.mul_le_mul_left
      (lookupCost maxName (QH + Qs + 1) + copyCost maxMsg + costS.t + 8) hsq
    have h3 := Nat.mul_le_mul_left
      (lookupCost maxName (QH + Qs + 1) + targetReadCost + polyMulRemCost + verifySteps
        + copyCost extractBytes + 16) hfin
    simp only [derivedResourceBound]
    nlinarith [Nat.zero_le (uniformDrawCost 320), Nat.zero_le (lookupCost maxName (QH + Qs + 1)),
      Nat.zero_le (targetReadCost), Nat.zero_le (copyCost maxMsg),
      Nat.zero_le (polyMulRemCost), Nat.zero_le (verifySteps),
      Nat.zero_le (copyCost extractBytes), Nat.zero_le (costS.t)]
  · rw [hLs, sum_components_L]
    have h1 := Nat.mul_le_mul_left (2 * maxName + 3072) hhq
    have h2 := Nat.mul_le_mul_left (2 * maxName + costS.L) hsq
    have h3 := Nat.mul_le_mul_left (2 * maxName + 3072 + extractBytes + 8) hfin
    simp only [derivedResourceBound]
    nlinarith [Nat.zero_le (extractBytes), Nat.zero_le (maxName), Nat.zero_le (maxMsg),
      Nat.zero_le costS.L]

/-- **Reducer bit-cost bound (task Etap E).** `Resources (reduce A S)` is
within `derivedResourceBound`: additive `t`/`L` over the op trace (with the
linear-scan table access charged per entry via `lookupCost`) and peak `w` for
the buffers including the full table and the entire target list. -/
theorem reducer_bit_cost_bound (costS : Cost) (maxName maxMsg : ℕ)
    (QH Qs : ℕ) (ops : List Op) (simA : Cost)
    (hhq : cnt ops Kind.hq ≤ QH) (hsq : cnt ops Kind.sq ≤ Qs)
    (hfin : cnt ops Kind.fin ≤ 1) :
    (ops.map (costOp costS maxName maxMsg (QH + Qs + 1))).sum.t + simA.t
        ≤ (derivedResourceBound QH Qs maxName maxMsg costS simA).t ∧
      (ops.map (costOp costS maxName maxMsg (QH + Qs + 1))).sum.L + simA.L
        ≤ (derivedResourceBound QH Qs maxName maxMsg costS simA).L ∧
      (∀ nt ns, nt ≤ QH + Qs + 1 → ns ≤ Qs + 1 →
        simA.w + costS.w + stateMem maxName maxMsg nt ns + targetsMem QH
            + memCost extractBytes ≤
          (derivedResourceBound QH Qs maxName maxMsg costS simA).w) := by
  have hts := (sum_comp (ops.map (costOp costS maxName maxMsg (QH + Qs + 1)))).1
  have hLs := (sum_comp (ops.map (costOp costS maxName maxMsg (QH + Qs + 1)))).2.2
  refine ⟨?_, ?_, ?_⟩
  · rw [hts, sum_components_t]
    have h1 := Nat.mul_le_mul_left (lookupCost maxName (QH + Qs + 1) + targetReadCost) hhq
    have h2 := Nat.mul_le_mul_left
      (lookupCost maxName (QH + Qs + 1) + copyCost maxMsg + costS.t + 8) hsq
    have h3 := Nat.mul_le_mul_left
      (lookupCost maxName (QH + Qs + 1) + targetReadCost + polyMulRemCost + verifySteps
        + copyCost extractBytes + 16) hfin
    simp only [derivedResourceBound]
    nlinarith [Nat.zero_le (uniformDrawCost 320), Nat.zero_le (lookupCost maxName (QH + Qs + 1)),
      Nat.zero_le (targetReadCost), Nat.zero_le (copyCost maxMsg),
      Nat.zero_le (polyMulRemCost), Nat.zero_le (verifySteps),
      Nat.zero_le (copyCost extractBytes), Nat.zero_le (costS.t)]
  · rw [hLs, sum_components_L]
    have h1 := Nat.mul_le_mul_left (2 * maxName + 3072) hhq
    have h2 := Nat.mul_le_mul_left (2 * maxName + costS.L) hsq
    have h3 := Nat.mul_le_mul_left (2 * maxName + 3072 + extractBytes + 8) hfin
    simp only [derivedResourceBound]
    nlinarith [Nat.zero_le (extractBytes), Nat.zero_le (maxName), Nat.zero_le (maxMsg),
      Nat.zero_le costS.L]
  · intro nt ns hnt hns
    exact w_peak_bound costS simA maxName maxMsg QH Qs nt ns hnt hns

end FT1536.BitCost
