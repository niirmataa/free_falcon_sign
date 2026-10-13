import ProducerCoreRead020E6
import NodeRead020E2

namespace FT1536.S05.ProducerSnapshot020E6
open WordRAM020 ArrayBank020E4 ArenaTypes020E1 NodeFrames020E2 WordCodec020E5 ProducerCoreView020E6

/-- Reference-only snapshot. Runtime uses ProducerWindow's closed loads;
    this function is not an instruction or an uncharged supplied oracle. -/
def top (d : BoundaryPayload020E5.Data) := ArrayFrames020E4.top d.core.frames

def pc {cap : Nat} : Frame cap → Ptr cap | .run p | .again p _ => p

def actNode (d : BoundaryPayload020E5.Data) : Option (Node 877) :=
  (top d).bind (fun f => NodeRead020E2.read (ArrayArena020E4.model d.parser.arena) (pc f))

def scanNode (d : BoundaryPayload020E5.Data) : Option (Node 877) :=
  if h : d.core.cursor.val<877 then
    if d.core.cursor.val<d.parser.arena.used.val then some (read d.parser.arena.bank ⟨d.core.cursor.val,h⟩) else none
  else none

def child {cap : Nat} (n : Node cap) (j : Nat) : Ptr cap := if j=0 then n.first else if j=1 then n.second else n.third

def actValue (d : BoundaryPayload020E5.Data) (j : Nat) : Option Word :=
  (actNode d).bind (fun n => ArrayValues020E4.lookup d.parser.arena d.core.values (child n j))

def scanValue (d : BoundaryPayload020E5.Data) (j : Nat) : Option Word :=
  (scanNode d).bind (fun n => if (child n j).val<d.core.cursor.val then
    ArrayValues020E4.lookup d.parser.arena d.core.values (child n j) else none)

def field {cap : Nat} (n : Option (Node cap)) (j : Fin 5) : Word :=
  (n.map (fun n => ArenaWords020E1.nodeWords n j)).getD 0

def present {A : Type} (v : Option A) : Word := boolWord v.isSome

def value (v : Option Word) : Word := v.getD 0

def regValue (d : BoundaryPayload020E5.Data) : Word :=
  value ((scanNode d).bind (fun n => (SyntaxCells020E.decode n.cell).bind (fun t => match t with
    | .register r => some (read d.core.state.reg r) | _ => none)))

def memoryValue (d : BoundaryPayload020E5.Data) (kind : Fin 3) : Word :=
  value ((actValue d 0).bind (fun w => match kind.val with
    | 0 => (address ramSize w).map (read d.core.state.ram)
    | 1 => (address romSize w).map (read d.rom.bank)
    | _ => (address tapeSize w).map (fun j => boolWord (read d.tape.bank j))))

def fields (d : BoundaryPayload020E5.Data) (j : Fin 96) : Word :=
  if h : j.val<16 then
    (CoreEncoding020E5.metaCodec 877 28941 1106642201817 ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl).encode
      (CoreEncoding020E5.metadata d.core) ⟨j.val,h⟩
  else match j.val with
  | 16 => word d.parser.arena.used.val
  | 17 => present (top d)
  | 18 => ((top d).map (fun f => BankStorage020E3.frameWords f 0)).getD 0
  | 19 => ((top d).map (fun f => BankStorage020E3.frameWords f 1)).getD 0
  | 20 => ((top d).map (fun f => BankStorage020E3.frameWords f 2)).getD 0
  | 21 => field (scanNode d) 0
  | 22 => field (scanNode d) 1
  | 23 => field (scanNode d) 2
  | 24 => field (scanNode d) 3
  | 25 => field (scanNode d) 4
  | 26 => present (scanValue d 0)
  | 27 => value (scanValue d 0)
  | 28 => present (scanValue d 1)
  | 29 => value (scanValue d 1)
  | 30 => regValue d
  | 31 => present (actNode d)
  | 32 => field (actNode d) 0
  | 33 => field (actNode d) 1
  | 34 => field (actNode d) 2
  | 35 => field (actNode d) 3
  | 36 => field (actNode d) 4
  | 37 => present (actValue d 0)
  | 38 => value (actValue d 0)
  | 39 => present (actValue d 1)
  | 40 => value (actValue d 1)
  | 41 => present (actValue d 2)
  | 42 => value (actValue d 2)
  | 43 => memoryValue d 0
  | 44 => memoryValue d 1
  | 45 => memoryValue d 2
  | 46 => present (scanNode d)
  | _ => 0

end FT1536.S05.ProducerSnapshot020E6
