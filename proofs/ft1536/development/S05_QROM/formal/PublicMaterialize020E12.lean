import ProducerCoreExecution020E11
import ResidentCall020E5
import StartupImage020E5

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicMaterialize020E12
open WordRAM020 ArrayBank020E4 WordCodec020E5

/-- Concrete bounded fill of a finite encoding. The codecs used by the public
    pipeline below are the pinned finite projection codecs, not supplied oracles. -/
def materialize {A : Type} {n : Nat} (c : Codec A n) (a : A) : Bank Word n :=
  BoundaryFill020E5.fill (c.encode a) 0

theorem materialize_eq {A : Type} {n : Nat} (c : Codec A n) (a : A) :
    materialize c a=VerifiedPatch020E5.pack c a := BoundaryFill020E5.fill_eq _ _

def zeroed (n : Nat) : Bank Word n := BoundaryFill020E5.fill (fun _ => 0) 0

theorem zeroed_eq (n : Nat) : zeroed n=zero n 0 := BoundaryFill020E5.fill_eq _ _

/-- Full fill state, including its terminal cursor; consumed by the boundary
    encoder rather than being replaced by an assumed bank. -/
def filled {A : Type} {n : Nat} (f : Fin n → A) (z : A) : FillMachine020E5.State A n :=
  FillMachine020E5.run f n (FillMachine020E5.start (zero n z))

theorem filled_bank {A : Type} {n : Nat} (f : Fin n → A) (z : A) : (filled f z).bank=load f :=
  FillMachine020E5.fills f _

theorem filled_cursor {A : Type} {n : Nat} (f : Fin n → A) (z : A) : (filled f z).cursor.val=n :=
  FillMachine020E5.complete f n _ (by exact le_rfl)

end FT1536.S05.PublicMaterialize020E12
