import ProducerScalar020E6
import BoundaryPayload020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerCoreView020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5
abbrev Core := CoreState020E5.Core 877 28941 1106642201817
abbrev Parser := ParserMachine020E5.State 877 877

def extent : Fin 7 → Nat := Fin.cases 143922 (Fin.cases 5266 (Fin.cases (tapeSize+1)
  (Fin.cases (romSize+1) (Fin.cases 95452 (Fin.cases (outputSize+1) (Fin.cases 1 Fin.elim0))))))

/-- The finite reader interface is supplied by views of the resident banks.
    Encoding is a specification map; the producer code below only loads
    indexed words. The one-word last port is a freshly supplied ideal bit. -/
def sources (d : BoundaryPayload020E5.Data) (fresh : Bool) : ProducerMachine020E6.Sources extent :=
  Fin.cases (CoreEncoding020E5.encode (by norm_num) (by norm_num) (by norm_num) d.core)
    (Fin.cases (ParserStore020E5.image (by norm_num) (by norm_num) d.parser)
      (Fin.cases (FillStore020E5.image boolCodec (by norm_num [tapeSize]) d.tape)
        (Fin.cases (FillStore020E5.image wordCodec (by norm_num [romSize]) d.rom)
          (Fin.cases (PublicData020E5.image d.ro)
            (Fin.cases (FillStore020E5.image boolCodec (by norm_num [outputSize]) d.output)
              (Fin.cases (VerifiedPatch020E5.pack boolCodec fresh) (fun j => Fin.elim0 j)))))))

/-- All addresses here are public fixed layout constants. -/
def regBase : Nat := 0
def ramBase : Nat := 32
def outBase : Nat := 4640
def frameBase : Nat := 55329
def valueBase : Nat := 142152
def controlBase : Nat := 143906

def core (offset : Nat) : ProducerScalar020E6.E 7 := ProducerScalar020E6.cell 0 offset
def control (offset : Nat) : ProducerScalar020E6.E 7 := core (controlBase+offset)
def arena (offset : Nat) : ProducerScalar020E6.E 7 := ProducerScalar020E6.cell 1 offset

def phase := control 0
def cursor := control 1
def left := control 2
def sp := control 3
def fault := control 15
def used := arena 5262
def parserSP := arena 5263
def parserCursor := arena 5264
def parserBad := arena 5265

def valueAt (p : ProducerScalar020E6.E 7) : ProducerScalar020E6.Optional 7 :=
  let addr := ProducerScalar020E6.add (ProducerScalar020E6.lit valueBase) (ProducerScalar020E6.mul (ProducerScalar020E6.lit 2) p)
  let ok := ProducerScalar020E6.and (ProducerScalar020E6.lt p used)
    (.load 0 addr)
  ProducerScalar020E6.guarded ok (.load 0 (ProducerScalar020E6.add addr (ProducerScalar020E6.lit 1)))

def nodeAt (p : ProducerScalar020E6.E 7) (field : Nat) : ProducerScalar020E6.E 7 :=
  .load 1 (ProducerScalar020E6.add (ProducerScalar020E6.mul (ProducerScalar020E6.lit 5) p) (ProducerScalar020E6.lit field))

def frameAt (p : ProducerScalar020E6.E 7) (field : Nat) : ProducerScalar020E6.E 7 :=
  .load 0 (ProducerScalar020E6.add (ProducerScalar020E6.lit (frameBase+field)) (ProducerScalar020E6.mul (ProducerScalar020E6.lit 3) p))

end FT1536.S05.ProducerCoreView020E6
