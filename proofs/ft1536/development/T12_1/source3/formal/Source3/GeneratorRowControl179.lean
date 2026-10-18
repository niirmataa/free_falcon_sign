import Source3.GeneratorRowFixed179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorRowControl179
open C99ArrayReference (State bindValue)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)

def put (s : State) (u : Nat) := bindValue s "u".toList .uint64 (u64 u)
def initial : C99ModularReference.Stmt := .assign "u".toList (.scalar (KeygenMkgm3Program.num 0))
def condition : CLogic.Expr := .cmp .lt (KeygenMkgm3Program.var "u") (KeygenMkgm3Program.var "b")
def increment : C99ModularReference.Stmt := .base (.scalar (.update "u".toList .add (KeygenMkgm3Program.num 2)))
def body : C99ModularReference.Stmt := .scope [] KeygenMkgm3Program.lastRowBody
def loop : C99ModularReference.Stmt := .loop condition body increment

theorem shape : KeygenMkgm3Program.lastRowLoop=.seq initial loop := rfl

theorem cell (s : State) (u : Nat) (bound : u<2^64) : USlot (put s u) "u" u :=
  KeygenMkgm3RowInit.set64_slot s "u" u bound

theorem start (s : State) (old : Option C99IntegerReference.Value)
    (declared : s.locals "u".toList=some (.uint64,old)) : Exec initial s ⟨put s 0,.normal⟩ :=
  .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))

theorem guard (s : State) (u : Nat) (bound : u<2^64) (counter : USlot s "u" u) (base : USlot s "b" 512) :
    C99ArrayReference.scalar s condition (C99ScalarReference.boolean (decide (u<512))) :=
  C99LoopScalar141.less s _ _ u 512 bound (by decide) (.variable _ _ _ counter) (.variable _ _ _ base)

theorem advance (s : State) (u : Nat) (bound : u<2^64) (counter : USlot s "u" u) :
    Exec increment s ⟨put s (u+2),.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 u)) (u64 (u+2)) counter
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 2)
      (PublicGenerateIndex159.add_two u bound))))

end FT1536.Source3.GeneratorRowControl179
