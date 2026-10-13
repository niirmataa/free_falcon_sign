import ProducerWindow020E6
import ProducerProgram020E6
import Lean.Data.Json

namespace FT1536.S05.ProducerWindowExport020E6
open WordRAM020 ProducerMachine020E6

/-- Public diagnostic export, not a universal proof or a trusted compiler. -/
def serial {regions codeSize : Nat} : Instruction regions codeSize → List Nat
  | .literal d w => [0,d.val,w.toNat]
  | .copy d s => [1,d.val,s.val]
  | .binary d o a b => [2,d.val,SyntaxCells020E.opIndex o,a.val,b.val]
  | .load d r a => [3,d.val,r.val,a.val]
  | .output d s => [4,d.val,s.val]
  | .select d c z n => [5,d.val,c.val,z.val,n.val]

def instructions := (ProducerEmit020E6.batch (codeSize:=0) ProducerWindow020E6.cells
  ProducerWindow020E6.workspace (List.finRange 96)).map serial

#eval IO.println (Lean.Json.compress (Lean.toJson instructions))

end FT1536.S05.ProducerWindowExport020E6
