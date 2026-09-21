import Deps.Tables
import Deps.Words
set_option maxRecDepth 8192
set_option maxHeartbeats 20000000
namespace FT1536Global
open FT1536Tables
def unitRows : List (List Int) := units_0 ++ units_1 ++ units_2 ++ units_3 ++ units_4 ++ units_5 ++ units_6 ++ units_7 ++ units_8 ++ units_9 ++ units_10 ++ units_11 ++ units_12 ++ units_13 ++ units_14 ++ units_15 ++ units_16 ++ units_17 ++ units_18 ++ units_19 ++ units_20 ++ units_21 ++ units_22 ++ units_23 ++ units_24 ++ units_25 ++ units_26 ++ units_27 ++ units_28 ++ units_29 ++ units_30 ++ units_31

theorem unitRows_length : unitRows.length=1024 := by decide
theorem unitRows_checked : unitRows.all unitsCheck = true := by
  simp only [unitRows, List.all_append, units_0_checked, units_1_checked, units_2_checked, units_3_checked, units_4_checked, units_5_checked, units_6_checked, units_7_checked, units_8_checked, units_9_checked, units_10_checked, units_11_checked, units_12_checked, units_13_checked, units_14_checked, units_15_checked, units_16_checked, units_17_checked, units_18_checked, units_19_checked, units_20_checked, units_21_checked, units_22_checked, units_23_checked, units_24_checked, units_25_checked, units_26_checked, units_27_checked, units_28_checked, units_29_checked, units_30_checked, units_31_checked, Bool.and_true]

def rowGM : List Int → Int
  | [_,g,_] => g
  | _ => 0
def rowIG : List Int → Int
  | [_,_,ig] => ig
  | _ => 0
def rowID : List Int → Int
  | [i,_,_] => i
  | _ => -1

theorem unit_bounds (r : List Int) (h : unitsCheck r = true) :
    FT1536NTT.Canon (rowGM r) ∧ FT1536NTT.Canon (rowIG r) := by
  cases r with
  | nil => simp [unitsCheck] at h
  | cons i tail =>
    cases tail with
    | nil => simp [unitsCheck] at h
    | cons g tail =>
      cases tail with
      | nil => simp [unitsCheck] at h
      | cons ig tail =>
        cases tail with
        | nil =>
          have hp : 0≤i ∧ i<1024 ∧ 0≤g ∧ g<18433 ∧ 0≤ig ∧ ig<18433 ∧
              (i=0 ∨ (g*ig)%18433=4564) := of_decide_eq_true h
          exact ⟨⟨hp.2.2.1,hp.2.2.2.1⟩,⟨hp.2.2.2.2.1,hp.2.2.2.2.2.1⟩⟩
        | cons x xs => simp [unitsCheck] at h

def unitRow (i : Fin 1024) : List Int := unitRows.get ⟨i.val, by simpa only [unitRows_length] using i.isLt⟩
def gm (i : Fin 1024) : Int := rowGM (unitRow i)
def igm (i : Fin 1024) : Int := rowIG (unitRow i)

theorem table_canonical (i : Fin 1024) : FT1536NTT.Canon (gm i) ∧ FT1536NTT.Canon (igm i) := by
  apply unit_bounds
  apply FT1536Tables.all_sound _ _ unitRows_checked
  exact List.get_mem _ _

def gmAt (i : Nat) : Int := if hi : i<1024 then gm ⟨i,hi⟩ else 0
def igmAt (i : Nat) : Int := if hi : i<1024 then igm ⟨i,hi⟩ else 0
theorem gmAt_canonical (i : Nat) : FT1536NTT.Canon (gmAt i) := by
  unfold gmAt
  split
  · exact (table_canonical _).1
  · simp [FT1536NTT.Canon]
theorem igmAt_canonical (i : Nat) : FT1536NTT.Canon (igmAt i) := by
  unfold igmAt
  split
  · exact (table_canonical _).2
  · simp [FT1536NTT.Canon]

#check @table_canonical
#print axioms unitRows_length
#print axioms unitRows_checked
#print axioms unit_bounds
#print axioms table_canonical
#print axioms gmAt_canonical
#print axioms igmAt_canonical
end FT1536Global
