import CoordinateCorrect020A
import InputLayout020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ActualCoordinate020A
open WordRAM020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A
open FT1536.Relation JointInterface019
attribute [local irreducible] StandaloneRuntime019.search loopState TableData016.cdf

abbrev cdf : Nat → Nat := StandaloneRuntime019.extended StandaloneRuntime019.tables

theorem cdf_at (k : Fin 30721) : cdf k.val=StandaloneRuntime019.tables.cdf k := by
  unfold cdf StandaloneRuntime019.extended
  congr 1
  apply Fin.ext
  have := k.isLt
  change min k.val 30720=k.val
  omega

/-- Instantiation of the table-image premise, for the real pinned tables
    and exactly the supplied public h. No arbitrary CDF oracle remains. -/
theorem actual_image (h : Rq) (tape : Bits tapeSize) : Image (InputLayout020.encode h tape) cdf := by
  intro k
  change InputLayout020.image h _=nw (cdf k.val)
  rw [cdf_at]
  unfold InputLayout020.image
  rw [dite_eq_left k.isLt]

theorem actual_width (k : Nat) (hk : k<30721) : cdf k<2^400 := by
  have he := cdf_at (⟨k,hk⟩ : Fin 30721)
  rw [he]
  have old := WordBounds018.cdf_width (⟨k,hk⟩ : SamplerCode016.CoordIndex)
  exact lt_trans old (by norm_num)

theorem result_eq_coord (i : Input) (b : Nat) : CoordinateCorrect020A.result i cdf b =
    (StandaloneRuntime019.coord StandaloneRuntime019.tables (fun j => tapeBits i (b+j.val))).val := by
  change min (StandaloneRuntime019.search cdf (value (tapeBits i) 384 b % cdf 30720) 15 0 30721).1 30720 =
    min (StandaloneRuntime019.search cdf
      (StandaloneRuntime019.value 384 (fun j => tapeBits i (b+j.val)) % StandaloneRuntime019.tables.cdf ⟨30720,by decide⟩)
      15 0 30721).1 30720
  rw [reference_value,cdf_at (⟨30720,by decide⟩ : Fin 30721)]

/-- Whole machine coordinate equals the actual019 coordinate on EVERY tape
    at EVERY valid segment; frame/footprint are retained for cap composition. -/
theorem actual_coordinate (h : Rq) (tape : Bits tapeSize) (s : State) (dst : Reg) (base : Expr) (b : Nat)
    (ha : b+384≤tapeSize) (hb : eval s base=nw b)
    (hb4 : (4 : Reg) ∉ reads base) (hb5 : (5 : Reg) ∉ reads base) (hb6 : (6 : Reg) ∉ reads base) :
    let i := InputLayout020.encode h tape
    let t := exec i (coordinate dst base) s
    t.reg dst=nw (StandaloneRuntime019.coord StandaloneRuntime019.tables (fun j => tapeBits i (b+j.val))).val ∧
      Frame s t ∧ ∀ k : Reg, (k.val<4 ∨ 12<k.val) → k≠30 → k≠dst → t.reg k=s.reg k := by
  have hc := CoordinateCorrect020A.coordinate_correct (InputLayout020.encode h tape) cdf s dst base b
    (actual_image h tape) actual_width ha hb hb4 hb5 hb6
  rw [result_eq_coord] at hc
  exact hc

end FT1536.S05.ActualCoordinate020A
