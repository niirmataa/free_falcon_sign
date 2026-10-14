import Source3.KeygenPublicDomain095
import Source3.KeygenModpR2Exec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenModularLeaf096
open C99IntegerReference (Value)
open C99ArrayReference (State)
open C99ModularReference

theorem leaf_calls : C99ScalarDeterminism089.Deterministic LeafCall := by
  intro name args a b first second
  have unique := C99ScalarDeterminism089.function_unique C99Frontend.noCalls C99ScalarCallsDeterminism089.no_calls
  cases first <;> cases second
  all_goals exact unique _ _ _ _ (by assumption) (by assumption)

def word (v : Value) : BitVec 32 := BitVec.ofInt 32 v.integer

theorem convert_word (v : Value) : C99IntegerReference.convert .uint32 v.integer =
    C99IntegerReference.convert .uint32 (Value.uint32 (word v)).integer :=
  (C99CountedWords.convert_self (.uint32 (word v))).symm

theorem r2_parameters (base : State) (a b : Value) : bindParams base r2Params [a, b] =
    bindParams base r2Params [.uint32 (word a), .uint32 (word b)] := by
  apply KeygenPublicArguments.bind_equal
  exact .cons _ _ _ _ _ _ _ (convert_word a) (.cons _ _ _ _ _ _ _ (convert_word b) .nil)

/-- Proper two-argument calls depend only on source-converted parameters,
    even though the old body relation permits an arbitrary base state. -/
theorem r2_exact (a b out : Value) (source : r2Body [a, b] out) :
    out = .uint32 (KeygenModpR2Word.word (word a) (word b)) := by
  obtain ⟨base, after, body⟩ := source
  rw [r2_parameters] at body
  exact KeygenModpR2Exec.source_exact (word a) (word b) out ⟨base, after, body⟩

theorem r2_unique (a b x y : Value) (first : r2Body [a, b] x) (second : r2Body [a, b] y) : x = y :=
  (r2_exact a b x first).trans (r2_exact a b y second).symm

end FT1536.Source3.KeygenModularLeaf096
