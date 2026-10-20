import Run2.KeygenLeafGate
import Run2.StableLeafSchedule
import GramLDL

/-! # SourceLeafBridge — most hipotez-kontraktu Warstwy 2 → StableLeafSchedule

Łańcuch (bez zmian logiki warstw; sygnatury uzgodnione z
`C_TASK_2_FPERROR/CONTRACTS.md`):

`source value ≥ 1024` (bramka `KeygenLeafGate.scan`) → `leaf_exact > 991`
(kontrakt `leaf_error_bound : |leaf_computed − leaf_exact| ≤ E_leaf` +
budżet `E_leaf < 33 = 1024 − 991`) → `lower ≥ 991` (`StableLeafSchedule`) →
`upper ≤ 18433^2/991` (ich `full_lower_gives_upper`; q²/991 dla q = 18433).

Most jest HIPOTEZĄ-kontraktem: `LeafErrorContract` odtwarza dokładnie ich
sygnaturę `leaf_error_bound`; wiązanie bramki z wartością wyliczaną
(`source_binding`) i wartość liczbowa budżetu są jawne w signature tez
(dostarcza je Warstwa 2 w `LeafError.lean`; tu nie są zakładane bez nazwy). -/

namespace FT1536.SourceLeafBridge

open FT1536.Run2.StableLeafSchedule FT1536.Run2.KeygenLeafGate

/-! ## A. Kontrakt Warstwy 2 (instancja per-liść; logika bez zmian). -/

/-- Kontrakt błędu liścia — dokładnie sygnatura `C_TASK_2_FPERROR/CONTRACTS.md`:
    `leaf_error_bound : ∀ input, |leaf_computed − leaf_exact| ≤ E_leaf`
    (nazwy uzgodnione obustronnie w CONTRACTS; tu instancja dla jednego liścia). -/
structure LeafErrorContract (leaf_computed leaf_exact E_leaf : ℝ) : Prop where
  leaf_error_bound : |leaf_computed - leaf_exact| ≤ E_leaf

/-! ## B. Most źródło → liść: `1024 → > 991`. -/

/-- **Most kontraktu** (ich `LeafError.lean`, druga część poz. 3):
    `source value ≥ 1024 → leaf_exact > 991`. Przesłanki jawne: kontrakt błędu,
    wiązanie `sourceValue ≤ leaf_computed` (bramka → wartość wyliczana)
    i budżet `E_leaf < 33` (=`1024 − 991`). -/
theorem source_to_leaf_exact
    {sourceValue leaf_computed leaf_exact E_leaf : ℝ}
    (hsrc : (1024 : ℝ) ≤ sourceValue)
    (ctr : LeafErrorContract leaf_computed leaf_exact E_leaf)
    (hlink : sourceValue ≤ leaf_computed)
    (hE : E_leaf < 33) :
    (991 : ℝ) < leaf_exact := by
  have h1 : leaf_computed - E_leaf ≤ leaf_exact := by
    have h := ctr.leaf_error_bound
    obtain ⟨_, hge⟩ := abs_le.mp h
    linarith
  linarith

/-- Słabsza postać pod warunek dolny StableLeafSchedule (`991 ≤ leaf`). -/
theorem source_to_leaf_ge_991
    {sourceValue leaf_computed leaf_exact E_leaf : ℝ}
    (hsrc : (1024 : ℝ) ≤ sourceValue)
    (ctr : LeafErrorContract leaf_computed leaf_exact E_leaf)
    (hlink : sourceValue ≤ leaf_computed)
    (hE : E_leaf < 33) :
    (991 : ℝ) ≤ leaf_exact :=
  (source_to_leaf_exact hsrc ctr hlink hE).le

/-! ## C. Podłączenie do bramki liści (Warstwa 1 / model Astry). -/

/-- Wartość źródłowa ≥ 1024 dla każdego słowa udanego skanu bramki
    (ich `KeygenLeafGate.successful_scan_all_leaf_values`). -/
theorem source_value_ge_1024 (ws : List Word) (bad : Flag) (w : Word)
    (h : (scan ws bad).2 = 0#32) (hw : w ∈ ws) :
    (1024 : ℝ) ≤ positiveNormalValue w :=
  (successful_scan_all_leaf_values ws bad h w hw).2

/-- Most od skanu bramki do liścia: akceptacja `scan` ⇒ `leaf_exact > 991`. -/
theorem scan_to_leaf_exact (ws : List Word) (bad : Flag) (w : Word)
    (h : (scan ws bad).2 = 0#32) (hw : w ∈ ws)
    {leaf_computed leaf_exact E_leaf : ℝ}
    (ctr : LeafErrorContract leaf_computed leaf_exact E_leaf)
    (hlink : positiveNormalValue w ≤ leaf_computed)
    (hE : E_leaf < 33) :
    (991 : ℝ) < leaf_exact :=
  source_to_leaf_exact (source_value_ge_1024 ws bad w h hw) ctr hlink hE

/-! ## D. Warunek dolny 991 → górny q²/991 dla całej listy liści. -/

/-- Dane kontraktu per-liść dla całej listy `full (18433^2) 8 roots`. -/
def LeafGateData (roots : List ℝ) : Prop :=
  ∀ x ∈ full (18433^2) 8 roots,
    ∃ sourceValue leaf_computed E_leaf : ℝ,
      (1024 : ℝ) ≤ sourceValue ∧
      LeafErrorContract leaf_computed x E_leaf ∧
      sourceValue ≤ leaf_computed ∧
      E_leaf < 33

/-- **Teza mostu**: dane bramki + kontrakt ⇒ `lower ≥ 991` dla całej listy. -/
theorem schedule_lower_ge_991 (roots : List ℝ) (hd : LeafGateData roots) :
    ∀ x ∈ full (18433^2) 8 roots, (991 : ℝ) ≤ x := by
  intro x hx
  obtain ⟨src, cm, E, hsrc, ctr, hlink, hE⟩ := hd x hx
  exact source_to_leaf_ge_991 hsrc ctr hlink hE

/-- **Most → górny**: `lower ≥ 991 ⇒ upper ≤ q²/991` (ich
    `full_lower_gives_upper`; `q = 18433^2`, czyli q²/991 dla q = 18433 —
    spójne z `T5ScalarMass.maxCoefficient`). -/
theorem schedule_upper_le_q2_div_991 (roots : List ℝ) (hd : LeafGateData roots) :
    ∀ x ∈ full (18433^2) 8 roots, x ≤ (18433^2 : ℝ)/991 :=
  full_lower_gives_upper (18433^2) (by norm_num) 8 roots
    (schedule_lower_ge_991 roots hd)

/-- Oba brzegi naraz (dane wejściowe dla `T5ScalarMass.CoefficientRange`
    w PerKeyTransport: `a = pivot/(2π·768²)`, `pivot ∈ {leaf, 3*leaf/4}`). -/
theorem schedule_leaf_bounds (roots : List ℝ) (hd : LeafGateData roots) :
    (∀ x ∈ full (18433^2) 8 roots, (991 : ℝ) ≤ x) ∧
      (∀ x ∈ full (18433^2) 8 roots, x ≤ (18433^2 : ℝ)/991) :=
  ⟨schedule_lower_ge_991 roots hd, schedule_upper_le_q2_div_991 roots hd⟩

end FT1536.SourceLeafBridge
