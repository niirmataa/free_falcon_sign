import Source3.GeneratorSquareDomains181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorSquareControl181
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenMkgm3Program
open GeneratorRowControl179 (put)

def initial : C99ModularReference.Stmt := .assign "u".toList (.scalar (.bin .sub
  (.bin .shl (.cast .u64 (num 1)) (var "k")) (num 1)))
def condition : CLogic.Expr := .cmp .gt (var "u") (num 0)
def loop : C99ModularReference.Stmt := .loop condition squareBody (dec "u")

theorem shape : squareLoop=.seq initial loop := rfl

theorem start (s : State) (old : Option C99IntegerReference.Value)
    (declared : s.locals "u".toList=some (.uint64,old)) (k : Slot s "k" 8) :
    Exec initial s ⟨put s 255,.normal⟩ :=
  .assign _ _ _ .uint64 old (.uint64 255) declared (.scalar _ _
    (.arithmetic .minus _ _ _ _ _
      (.shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 1) (.literal .int32 1)) (.variable _ _ _ k)
        (.unsignedLeft (.uint64 1) (.uint32 8) 8 rfl rfl (by decide)))
      (.literal .int32 1) (PublicGenerateIndex159.sub_one 256 (by decide) (by decide))))

theorem guard (s : State) (u : Nat) (bound : u < 256) (counter : USlot s "u" u) :
    C99ArrayReference.scalar s condition (C99ScalarReference.boolean (decide (0<u))) :=
  .compare .gt _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 0)
    (PublicGenerateIndex159.compare_gt_zero u (by omega))

theorem decrement (s : State) (u : Nat) (lo : 1 ≤ u) (hi : u < 256) (counter : USlot s "u" u) :
    Exec (dec "u") s ⟨put s (u-1),.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 u)) (u64 (u-1)) counter
    (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 1)
      (PublicGenerateIndex159.sub_one u lo (by omega)))))

end FT1536.Source3.GeneratorSquareControl181
