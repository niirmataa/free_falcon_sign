import Source3.KeygenNormInduction151
import Source3.C99OuterScalar144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenNormBoundary151
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenNormInvariant151 (Norm)
open FftLocalCells140 (put)

theorem declared (s : State) (name : C99ArrayReference.Name)
    (type : (s.locals name).map Prod.fst=some .uint64) : ∃ old, s.locals name=some (.uint64,old) := by
  obtain ⟨⟨ty,old⟩,found,same⟩ := Option.map_eq_some_iff.mp type
  cases same
  exact ⟨old,found⟩

theorem zero (ctx : KeygenSearchContext.Context) (s : State) (old : Option Value)
    (cell : s.locals "norm".toList=some (.uint64,old)) :
    KeygenSearchExec.Exec ctx KeygenNormShape151.zero s ⟨put s "norm".toList 0,.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .assign _ _ s .uint64 old (.uint64 0) cell
    (.unary "fpr_of".toList _ (.int32 0) (.uint64 0) (.base _ _ (.scalar _ _ (.literal .int32 0))) FprOfZero151.source)

theorem double (ctx : KeygenSearchContext.Context) (s : State) (word : BitVec 64) (cell : Norm s word) :
    KeygenSearchExec.Exec ctx KeygenNormShape151.double s ⟨put s "norm".toList (FprHeadersFast137.double word),.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .assign _ _ s .uint64 (some (.uint64 word)) (.uint64 (FprHeadersFast137.double word)) cell
    (.unary "fpr_double".toList _ (.uint64 word) _
      (.base _ _ (FftLocalCells140.read_var s "norm".toList word cell)) (FprHeadersFast137.double_source word))

theorem compare (s : State) (word bound : BitVec 64) (normCell : Norm s word)
    (boundCell : s.locals "bound".toList=some (.uint64,some (.uint64 bound))) :
    KeygenNormFrame.Compare s (.int32 (FprCompare.spec word bound)) :=
  .run word bound _ (.variable "norm".toList .uint64 (.uint64 word) normCell)
    (.variable "bound".toList .uint64 (.uint64 bound) boundCell) (C99CompareObjects.exists_execution word bound)

end FT1536.Source3.KeygenNormBoundary151
