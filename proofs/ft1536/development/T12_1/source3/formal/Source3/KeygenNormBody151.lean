import Source3.KeygenNormShape151
import Source3.FprOfZero151
import Source3.FftFirstInduction149

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenNormBody151
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load64)
open KeygenSearchExec (Exec Eval)
open KeygenSearchContext (Context)
open FftLocalCells140 (put)

def addSquare (acc x : BitVec 64) : BitVec 64 := FprAddFast137.word acc (FprHeadersFast137.sqr x)
def step (acc x y : BitVec 64) := addSquare (addSquare acc x) y

theorem update_word (ctx : Context) (s : State) (name : String) (p : ArrayPointer) (acc x out : BitVec 64)
    (cell : s.locals "norm".toList=some (.uint64,some (.uint64 acc)))
    (address : C99ArrayReference.Pointer s name.toList (.var "u".toList) p) (read : Load64 s.heap p x)
    (addition : FprPrefixCalls.calls "fpr_add".toList [.uint64 acc,.uint64 (FprHeadersFast137.sqr x)] (.uint64 out)) :
    Exec ctx (KeygenNormShape151.update name) s ⟨put s "norm".toList out,.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .assign _ _ s .uint64 (some (.uint64 acc)) (.uint64 out) cell
    (.binary "fpr_add".toList _ _ (.uint64 acc) (.uint64 (FprHeadersFast137.sqr x)) _
      (.base _ _ (FftLocalCells140.read_var s "norm".toList acc cell))
      (.unary "fpr_sqr".toList _ (.uint64 x) _ (.base _ _ (.load _ _ p x address read)) (FprHeadersFast137.sqr_source x))
      addition)

theorem pointer (s : State) (name : Name) (p : ArrayPointer) (word : BitVec 64)
    (address : C99ArrayReference.Pointer s name (.var "u".toList) p) :
    C99ArrayReference.Pointer (put s "norm".toList word) name (.var "u".toList) p := by
  apply FftPointerTransport140.source s (put s "norm".toList word) name (.var "u".toList) p address rfl
  intro key member
  have same : key="u".toList := List.mem_singleton.mp member
  subst key
  exact (FftLocalCells140.outside s "norm".toList "u".toList word (by decide)).symm

theorem source_words (ctx : Context) (s : State) (p q : ArrayPointer) (acc x y r z : BitVec 64)
    (cell : s.locals "norm".toList=some (.uint64,some (.uint64 acc)))
    (pAddress : C99ArrayReference.Pointer s "rt1".toList (.var "u".toList) p)
    (qAddress : C99ArrayReference.Pointer s "rt2".toList (.var "u".toList) q)
    (xRead : Load64 s.heap p x) (yRead : Load64 s.heap q y)
    (firstAdd : FprPrefixCalls.calls "fpr_add".toList [.uint64 acc,.uint64 (FprHeadersFast137.sqr x)] (.uint64 r))
    (secondAdd : FprPrefixCalls.calls "fpr_add".toList [.uint64 r,.uint64 (FprHeadersFast137.sqr y)] (.uint64 z)) :
    Exec ctx KeygenNormShape151.body s ⟨put (put s "norm".toList r) "norm".toList z,.normal⟩ := by
  let middle := put s "norm".toList r
  let after := put middle "norm".toList z
  have first := update_word ctx s "rt1" p acc x r cell pAddress xRead firstAdd
  have second := update_word ctx middle "rt2" q r y z
    (FftLocalCells140.cell_at s "norm".toList r) (pointer s _ q r qAddress) yRead secondAdd
  exact .scope [] [] _ s ⟨after,.normal⟩
    (.seqNormal _ _ s middle _ first (.seqNormal _ _ middle after _ second (.procedure _ _ _ (.base _ _ _ (.skip _)))))

theorem source (ctx : Context) (s : State) (p q : ArrayPointer) (acc x y : BitVec 64)
    (cell : s.locals "norm".toList=some (.uint64,some (.uint64 acc)))
    (pAddress : C99ArrayReference.Pointer s "rt1".toList (.var "u".toList) p)
    (qAddress : C99ArrayReference.Pointer s "rt2".toList (.var "u".toList) q)
    (xRead : Load64 s.heap p x) (yRead : Load64 s.heap q y) :
    Exec ctx KeygenNormShape151.body s ⟨put (put s "norm".toList (addSquare acc x)) "norm".toList (step acc x y),.normal⟩ :=
  source_words ctx s p q acc x y (addSquare acc x) (step acc x y) cell pAddress qAddress xRead yRead
    (FprAddFast137.source acc (FprHeadersFast137.sqr x)) (FprAddFast137.source (addSquare acc x) (FprHeadersFast137.sqr y))

end FT1536.Source3.KeygenNormBody151
