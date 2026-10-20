import Source3.KeygenM0Preprocess

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMakePreprocess
open KeygenM0Preprocess

def regions : List (Nat×Nat) := [(7781,85),(7866,10),(7876,54),(7930,19),(7949,19),
  (7968,23),(7991,29),(8020,58),(8078,15),(8093,14),(8107,15),(8122,14),(8136,52)]
def piece (index : Nat) : List String :=
  let entry := regions[index]?.getD (0,0)
  (Pinned.keygenLines.drop (entry.1-1)).take entry.2
def visible (index : Nat) : List String := ((runControl (piece index) initial).map Prod.snd).getD []
def Checked (index : Nat) : Prop := (runControl (piece index) initial).map Prod.fst=some initial
instance (index : Nat) : Decidable (Checked index) :=
  inferInstanceAs (Decidable ((runControl (piece index) initial).map Prod.fst=some initial))

theorem part00 : Checked 0 := by decide
theorem part01 : Checked 1 := by decide
theorem part02 : Checked 2 := by decide
theorem part03 : Checked 3 := by decide
theorem part04 : Checked 4 := by decide
theorem part05 : Checked 5 := by decide
theorem part06 : Checked 6 := by decide
theorem part07 : Checked 7 := by decide
theorem part08 : Checked 8 := by decide
theorem part09 : Checked 9 := by decide
theorem part10 : Checked 10 := by decide
theorem part11 : Checked 11 := by decide
theorem part12 : Checked 12 := by decide

theorem all_parts (index : Fin 13) : Checked index.val := by
  fin_cases index
  · exact part00
  · exact part01
  · exact part02
  · exact part03
  · exact part04
  · exact part05
  · exact part06
  · exact part07
  · exact part08
  · exact part09
  · exact part10
  · exact part11
  · exact part12

theorem piece_bound (index : Nat) (checked : Checked index) :
    runControl (piece index) initial=some (initial,visible index) := by
  obtain ⟨result,run,control⟩ := Option.map_eq_some_iff.mp checked
  obtain ⟨last,lines⟩ := result
  change last=initial at control
  subst last
  simp only [visible,run,Option.map_some,Option.getD_some]

def indices : List Nat := List.range 13
def output : List String := indices.flatMap visible
theorem source_partition : (Pinned.keygenLines.drop 7780).take 407=indices.flatMap piece := by decide

theorem combine (parts : List Nat) (checked : ∀ index∈parts, Checked index) :
    runControl (parts.flatMap piece) initial=some (initial,parts.flatMap visible) := by
  induction parts with
  | nil => rfl
  | cons index rest ih =>
      rw [List.flatMap_cons,run_append,piece_bound index (checked index (by simp))]
      change (runControl (rest.flatMap piece) initial).map (fun right => (right.1,visible index++right.2))=_
      rw [ih (fun i hi => checked i (by simp [hi]))]
      rfl

theorem make_bound : KeygenM0Preprocess.makeSource=some output := by
  have h := combine indices (fun index member => all_parts ⟨index,List.mem_range.mp member⟩)
  unfold KeygenM0Preprocess.makeSource preprocess
  rw [source_partition,h]
  rfl
theorem make_defined : KeygenM0Preprocess.makeSource.isSome=true := by rw [make_bound]; rfl

end FT1536.Source3.KeygenMakePreprocess
