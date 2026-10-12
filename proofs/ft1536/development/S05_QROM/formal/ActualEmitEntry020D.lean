import EmitRead020D
import EmitEntry020D
import OutputLoop020D

namespace FT1536.S05.ActualEmitEntry020D
open WordRAM020 ReadSemantics020A Residue020D BufferField020D OutputValues020D
open EmitRead020D

def keyBody : Code := EmitEntry020D.code keyOps 16
def replyBody : Code := EmitEntry020D.code replyOps 17

theorem readVec_ram {s t : State} (h : s.ram=t.ram) : BoxImage020C.readVec s=BoxImage020C.readVec t := by
  funext p
  exact Prod.ext (congrFun h _) (congrFun h _)

theorem key_step (i : Input) (s0 : State) (z : StandaloneRuntime019.CachedBox) (v : Coeffs)
    (hz : BoxImage020C.readVec s0=BoxImage020C.image z) (hv : Holds s0 v) :
    OutputLoop020D.Step i keyBody (fun j => (keyValue z v j).val) 0 16 s0 := by
  intro p s h21 h28 hram
  have sz := (readVec_ram hram).trans hz
  have sv : Holds s v := by intro r;rw [hram];exact hv r
  let q := keyResult s z v p
  have fields := key_fields s z v p
  have ha : (keyValue z v p).val<2^16 := by have := ZMod.val_lt (keyValue z v p);omega
  exact EmitEntry020D.from_prefix i s q keyOps 16 p.val (0+16*p.val) (keyValue z v p).val
    (by decide) p.isLt (OutputChunks020D.end_bound 0 16 p (by decide)) ha
    (key_run i s z v p sz sv h21) (fields.2.1.trans h21) (fields.2.2.1.trans h28)
    fields.1 fields.2.2.2

theorem reply_step (i : Input) (s0 : State) (z : StandaloneRuntime019.CachedBox)
    (hz : BoxImage020C.readVec s0=BoxImage020C.image z) :
    OutputLoop020D.Step i replyBody (replyValue z) 24577 17 s0 := by
  intro p s h21 h28 hram
  have sz := (readVec_ram hram).trans hz
  let q := replyResult s z p
  have fields := reply_fields s z p
  have ha : replyValue z p<2^17 := by have := reply_bound z p;omega
  exact EmitEntry020D.from_prefix i s q replyOps 17 p.val (24577+17*p.val) (replyValue z p)
    (by decide) p.isLt (OutputChunks020D.end_bound 24577 17 p (by decide)) ha
    (reply_run i s z p sz h21) (fields.2.1.trans h21) (fields.2.2.1.trans h28)
    fields.1 fields.2.2.2

end FT1536.S05.ActualEmitEntry020D
