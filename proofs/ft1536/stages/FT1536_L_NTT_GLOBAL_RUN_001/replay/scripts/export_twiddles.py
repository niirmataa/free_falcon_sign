"""Reuse checked unit rows rather than regenerate numerical table claims."""
import hashlib,json
from pathlib import Path
W=Path.cwd()
src='''import Deps.Tables
import Deps.Words
set_option maxRecDepth 8192
set_option maxHeartbeats 20000000
namespace FT1536Global
open FT1536Tables
def unitRows : List (List Int) := '''+' ++ '.join('units_'+str(i) for i in range(32))+'''

theorem unitRows_length : unitRows.length=1024 := by decide
theorem unitRows_checked : unitRows.all unitsCheck = true := by
  simp only [unitRows, List.all_append, '''+', '.join('units_'+str(i)+'_checked' for i in range(32))+''', Bool.and_true]

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
'''
target=W/'formal/Twiddles.lean'
with target.open('x') as f:f.write(src)
table=json.loads((W/'inputs/certificates/tables_C.json').read_text())
literal=json.loads((W/'inputs/certificates/kernel_literals.json').read_text())
assert literal['families']['units']==[[i,table['gm'][i],table['igm'][i]] for i in range(1024)]
out=dict(input_tables_sha256=hashlib.sha256((W/'inputs/formal/Tables.lean').read_bytes()).hexdigest(),
         source_table_dump_sha256=hashlib.sha256((W/'inputs/certificates/tables_C.json').read_bytes()).hexdigest(),
         all_1024_row_indices_and_values_bound=True,
         formal_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),
         note='gmAt/igmAt are total models; source index lemmas must exclude fallback on every actual read')
(W/'artifacts/twiddle_binding.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
