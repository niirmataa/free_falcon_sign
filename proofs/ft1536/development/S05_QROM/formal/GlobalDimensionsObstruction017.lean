import Source3.KeygenMakeSearchPrefix

/- Reuse only the pinned011 source3 model artifact; do not replay source3. -/
namespace FT1536.S05.GlobalDimensionsObstruction017
open FT1536.Source3

theorem empty_locals_not_dimensions (caller : C99ArrayReference.State) :
    ¬KeygenMakeSearchPrefix.Dimensions {caller with locals := fun _ => none} := by
  intro h
  have impossible := h.2.1
  cases impossible

theorem no_global_dimensions (caller : C99ArrayReference.State) :
    ¬((s : C99ArrayReference.State) → KeygenMakeSearchPrefix.Dimensions s) := by
  intro all
  exact empty_locals_not_dimensions caller (all {caller with locals := fun _ => none})

#print axioms empty_locals_not_dimensions
#print axioms no_global_dimensions
end FT1536.S05.GlobalDimensionsObstruction017
