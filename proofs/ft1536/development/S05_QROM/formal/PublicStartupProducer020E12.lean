import PublicStartupSpec020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicStartupProducer020E12
open WordRAM020 ArrayBank020E4 ProducerScalar020E6 ProducerExpr020E6 ProducerEval020E7
open ProducerReferenceSlots020E8 ProducerReferenceData020E8 PublicStartupSpec020E12

def dataValue (j : Nat) : Expr 1 := if j=1 then cell 0 0 else lit 0
def controlValue (j : Nat) : Expr 1 := lit (if j=2 then 1106642201817 else if j=3 then 1 else 0)
def cells (j : Fin 96) : Expr 1 :=
  let s := j.val/3
  let f := j.val%3
  if s<3 then match f with | 0 => lit 1 | 1 => lit (55329+s) | _ => dataValue s
  else if s<19 then match f with | 0 => lit 1 | 1 => lit (143906+(s-3)) | _ => controlValue (s-3)
  else lit 0

theorem workspace : ∀ j,need (cells j)≤64 := by decide +kernel


def code := ProducerProgram020E6.code cells workspace
/-- One public root word is the only varying input to this stored image. -/
def source (root : Root) : ProducerMachine020E6.Sources (fun _ : Fin 1 => 1) :=
  fun _ => PublicMaterialize020E12.materialize (WordCodec020E5.finCodec 878 (by norm_num)) root

def run (root : Root) : Bank Word 96 := (ProducerStored020E6.invoke (source root) code).vm.output


end FT1536.S05.PublicStartupProducer020E12
