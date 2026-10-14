import Source3.KeygenTableObjects127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenGlobalCells127
open C99ArrayReference (Name)
open C99CompactCells115 (Cell Locals environment)

def cells (values : List (Name × BitVec 64)) : Locals := values.map (fun (name,value) => (name,Cell.u64 (some value)))

theorem lookup_source (values : List (Name × BitVec 64)) (name : Name) :
    environment (cells values) name=(values.find? (fun pair => pair.1==name)).map
      (fun pair => (C99IntegerReference.Ty.uint64,some (C99IntegerReference.Value.uint64 pair.2))) := by
  induction values with
  | nil => rfl
  | cons head tail ih =>
      rcases head with ⟨key,value⟩
      by_cases same : name=key
      · subst name
        simp [environment,cells,C99NameMap115.lookup,Cell.reference,Cell.ty,Cell.value]
        exact ⟨rfl,rfl⟩
      · simp [environment,cells,C99NameMap115.lookup,same,Ne.symm same] at ih ⊢
        exact ih

def globals : Locals := cells FftGlobalScalars.expected

theorem source : environment globals=FftGlobalScalars.environment := by
  funext name
  exact lookup_source FftGlobalScalars.expected name

end FT1536.Source3.KeygenGlobalCells127
