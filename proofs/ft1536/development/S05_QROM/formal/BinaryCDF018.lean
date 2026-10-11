import BinarySearch018
import ActualInterface017
import CDFProbability017

namespace FT1536.S05.BinaryCDF018
open SamplerCode016 BinarySearch018 CDFSelection017

/-- The extension is constant beyond the last entry. Every runtime query in
    the valid initial interval has an in-range index; no extra table is used. -/
def extended (t : Tables) (i : ℕ) : ℕ := t.cdf ⟨min i 30720,by omega⟩

theorem extended_at (t : Tables) (i : CoordIndex) : extended t i.val=t.cdf i := by
  unfold extended
  congr 1
  apply Fin.ext
  change min i.val 30720=i.val
  have hi := i.isLt
  omega

theorem extended_mono (t : Tables) (hc : Monotone t.cdf) : Monotone (extended t) := by
  intro i j hij
  apply hc
  change min i 30720≤min j 30720
  omega

def coordRun (t : Tables) (bits : BitTapes016.Bits 384) : ℕ×ℕ :=
  search (extended t) ((BitTapes016.word 384 bits).val%t.cdf ⟨30720,by decide⟩) 15 0 30721

def coord (t : Tables) (bits : BitTapes016.Bits 384) : CoordIndex :=
  ⟨min (coordRun t bits).1 30720,by omega⟩

theorem coord_probes (t : Tables) (bits : BitTapes016.Bits 384) : (coordRun t bits).2≤15 :=
  probe_bound _ _ _ _ _

theorem coord_index_in_range (t : Tables) (hc : Monotone t.cdf)
    (hS : 0<t.cdf ⟨30720,by decide⟩) (bits : BitTapes016.Bits 384) :
    (coordRun t bits).1<30721 := by
  have hu := Nat.mod_lt (BitTapes016.word 384 bits).val hS
  have hh := search_cut (extended t) (extended_mono t hc)
    ((BitTapes016.word 384 bits).val%t.cdf ⟨30720,by decide⟩) 15 0 30721 (by norm_num)
  change Cut _ _ 0 30721 (coordRun t bits).1 at hh
  by_contra hn
  have hl := hh.2.2.1 30720 (by omega) (by omega)
  have he := extended_at t (⟨30720,by decide⟩ : CoordIndex)
  rw [he] at hl
  omega

theorem coord_eq_linear (t : Tables) (hc : Monotone t.cdf)
    (hS : 0<t.cdf ⟨30720,by decide⟩) (bits : BitTapes016.Bits 384) :
    coord t bits=SamplerCode016.coord t bits := by
  have hi := coord_index_in_range t hc hS bits
  have hval : (coord t bits).val=(coordRun t bits).1 := by
    change min (coordRun t bits).1 30720=(coordRun t bits).1
    omega
  have hh := search_cut (extended t) (extended_mono t hc)
    ((BitTapes016.word 384 bits).val%t.cdf ⟨30720,by decide⟩) 15 0 30721 (by norm_num)
  change Cut _ _ 0 30721 (coordRun t bits).1 at hh
  apply Eq.symm
  apply (actual_coord_interval t hc hS bits (coord t bits)).mpr
  constructor
  · unfold prior
    split
    · exact Nat.zero_le _
    next hn =>
      have hprev := hh.2.2.1 ((coord t bits).val-1) (by omega) (by omega)
      have he := extended_at t (⟨(coord t bits).val-1,by omega⟩ : CoordIndex)
      rw [he] at hprev
      exact hprev
  · have ha := hh.2.2.2 (coord t bits).val (by omega) (by omega)
    rw [extended_at] at ha
    exact ha

theorem actual_coord_eq (bits : BitTapes016.Bits 384) :
    coord ActualTables016.tables bits=SamplerCode016.coord ActualTables016.tables bits :=
  coord_eq_linear _ (CDFProbability017.cdf_monotone ActualInterface017.actual_rows)
    ActualTables016.last_cdf_positive bits

#print axioms extended_at
#print axioms extended_mono
#print axioms coord_probes
#print axioms coord_index_in_range
#print axioms coord_eq_linear
#print axioms actual_coord_eq
end FT1536.S05.BinaryCDF018
