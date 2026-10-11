import PairProgram020
import Lean.Data.Json
namespace FT1536.S05.ExportProgram020
open WordRAM020 PairProgram020 Lean

def expr : WordRAM020.Expr → Json
  | .lit w => toJson (["lit",toString w.toInt] : List String)
  | .reg k => toJson (["reg",toString k.val] : List String)
  | .bin o a b => Json.arr #[toJson (match o with
    | .add => "add" | .sub => "sub" | .mul => "mul" | .div => "div"
    | .mod => "mod" | .lt => "lt" | .eq => "eq"),expr a,expr b]

def atom : Atom → Json
  | .set k e => Json.arr #[toJson "set",toJson k.val,expr e]
  | .loadROM k e => Json.arr #[toJson "rom",toJson k.val,expr e]
  | .loadRAM k e => Json.arr #[toJson "ram",toJson k.val,expr e]
  | .loadBit k e => Json.arr #[toJson "bit",toJson k.val,expr e]
  | .store a v => Json.arr #[toJson "store",expr a,expr v]
  | .emit a v => Json.arr #[toJson "emit",expr a,expr v]

def code : Code → Json
  | .atom a => atom a
  | .seq a b => Json.arr #[toJson "seq",code a,code b]
  | .branch e a b => Json.arr #[toJson "if",expr e,code a,code b]
  | .loop n g b => Json.arr #[toJson "loop",toJson n,expr g,code b]

def packet : Json := Json.mkObj [
  ("model",toJson "signed512-word-RAM020"),
  ("bound",toJson (bound program)),("nodes",toJson (nodes program)),
  ("depth",toJson (depth program)),("data_bits",toJson dataBits),
  ("program",code program),
  ("read384",code (readWord 7 (r 3) 384)),
  ("coordinate",code (coordinate 13 (r 3))),
  ("pair",code pair),("scatter",code scatterTerm),
  ("emit16",code (emitWord 16)),("emit17",code (emitWord 17))]
#eval IO.println packet.compress
end FT1536.S05.ExportProgram020
