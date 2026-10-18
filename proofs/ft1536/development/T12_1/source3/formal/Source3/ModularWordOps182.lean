import Source3.SelectedGeneratorFrame181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModularWordOps182
open C99ArrayReference (State)
open C99ModularReference (Expr Eval)
open KeygenModpR2Exec (Slot)

theorem add (s : State) (left right : Expr) (a b p : BitVec 32)
    (first : Eval s left (.uint32 a)) (second : Eval s right (.uint32 b)) (prime : Slot s "p" p) :
    Eval s (KeygenNttButterflyPrograms.add left right) (.uint32 (KeygenModpAddSub.result .add a b p)) :=
  .call3 _ _ _ _ _ _ _ _ first second (ModularAtoms178.cell s "p" p prime)
    (.add _ _ (KeygenModpAddSub.source_exists .add a b p))

theorem sub (s : State) (left right : Expr) (a b p : BitVec 32)
    (first : Eval s left (.uint32 a)) (second : Eval s right (.uint32 b)) (prime : Slot s "p" p) :
    Eval s (KeygenNttButterflyPrograms.sub left right) (.uint32 (KeygenModpAddSub.result .sub a b p)) :=
  .call3 _ _ _ _ _ _ _ _ first second (ModularAtoms178.cell s "p" p prime)
    (.sub _ _ (KeygenModpAddSub.source_exists .sub a b p))

end FT1536.Source3.ModularWordOps182
