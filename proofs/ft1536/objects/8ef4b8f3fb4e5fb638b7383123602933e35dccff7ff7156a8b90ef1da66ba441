import Source3.StableBinaryCExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryCExecAudit
open FT1536.Source3
open FT1536.Source3.StableBinaryByteView

/- Public 1.0, 2.0 and clear/nonzero flags. Scratch bytes are deliberately
   uninitialized; both arrays are allocated, writable and disjoint from bad. -/
def exampleHeap (initial : BitVec 32) : B20.C.Byte.Memory where
  length block := if block=0 then 128 else 0
  writable block := block==0
  contents p :=
    if p.block != 0 then none
    else if h : p.offset<8 then
      some (B20.Word.LE.byteOf 0x3ff0000000000000#64 ⟨p.offset,h⟩)
    else if h : 8≤p.offset ∧ p.offset<16 then
      some (B20.Word.LE.byteOf 0x4000000000000000#64 ⟨p.offset-8,by omega⟩)
    else if h : 64≤p.offset ∧ p.offset<68 then
      some (flagBytes initial ⟨p.offset-64,by omega⟩)
    else none

def layout (n : Nat) : StableBinary.Layout := ⟨0,32,64,n⟩

#eval (StableBinaryCExec.run (layout 1) 0 (exampleHeap 0#32)).map
  (fun s => (s.checks.length,flagRead s.heap 64,wordRead s.heap 0))
#eval (StableBinaryCExec.run (layout 2) 1 (exampleHeap 0#32)).map
  (fun s => (s.checks.length,flagRead s.heap 64,wordRead s.heap 0,wordRead s.heap 8))
#eval (StableBinaryCExec.run (layout 2) 1 (exampleHeap 7#32)).map
  (fun s => (s.checks.length,flagRead s.heap 64))

end FT1536.Source3.StableBinaryCExecAudit
