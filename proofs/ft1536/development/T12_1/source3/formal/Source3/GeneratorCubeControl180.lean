import Source3.GeneratorCubeFixed180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorCubeControl180
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenMkgm3Program
open GeneratorRowControl179 (put)

def initial : C99ModularReference.Stmt := .assign "u".toList (.scalar (.bin .shl (.cast .u64 (num 1)) (var "k")))
def upperExpr : CLogic.Expr := .bin .shl (.cast .u64 (num 1)) (.bin .add (var "k") (num 1))
def condition : CLogic.Expr := .cmp .lt (var "u") upperExpr
def loop : C99ModularReference.Stmt := .loop condition cubeBody (inc "u")

theorem shape : cubeLoop=.seq initial loop := rfl

theorem start (s : State) (old : Option C99IntegerReference.Value)
    (declared : s.locals "u".toList=some (.uint64,old)) (k : Slot s "k" 8) :
    Exec initial s ⟨put s 256,.normal⟩ :=
  .assign _ _ _ .uint64 old (.uint64 256) declared (.scalar _ _
    (.shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 1) (.literal .int32 1)) (.variable _ _ _ k)
      (.unsignedLeft (.uint64 1) (.uint32 8) 8 rfl rfl (by decide))))

theorem upper_value (s : State) (k : Slot s "k" 8) : C99ArrayReference.scalar s upperExpr (u64 512) :=
  .shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 1) (.literal .int32 1))
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ k) (.literal .int32 1)
      (.step .plus (.uint32 8) (.int32 1) .uint32 rfl (.uint32 8) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))
    (.unsignedLeft (.uint64 1) (.uint32 9) 9 rfl rfl (by decide))

theorem guard (s : State) (u : Nat) (bound : u<2^64) (counter : USlot s "u" u) (k : Slot s "k" 8) :
    C99ArrayReference.scalar s condition (C99ScalarReference.boolean (decide (u<512))) :=
  C99LoopScalar141.less s _ _ u 512 bound (by decide) (.variable _ _ _ counter) (upper_value s k)

theorem advance (s : State) (u : Nat) (bound : u<2^64) (counter : USlot s "u" u) :
    Exec (inc "u") s ⟨put s (u+1),.normal⟩ := by
  have run := C99LoopScalar141.increment (fun _ => none) s "u".toList u bound counter
  rw [FftLocalCells140.put_bind] at run
  cases run with
  | base _ _ _ inner => exact .base _ _ _ inner

end FT1536.Source3.GeneratorCubeControl180
