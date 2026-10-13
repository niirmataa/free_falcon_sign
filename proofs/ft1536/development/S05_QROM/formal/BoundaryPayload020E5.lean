import ResidentCall020E5
import StartupImage020E5
import ScriptStore020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.BoundaryPayload020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5 RegionRam020E5

/-- All currently represented persistent boundary/core data. This is not a
    full execution-memory theorem: emitter locals and outer scheduling have
    to be realized and composed, not silently replaced by this sum. -/
structure Data where
  ro : PublicData020E5.Data
  tape : FillMachine020E5.State Bool tapeSize
  rom : FillMachine020E5.State Word romSize
  parser : ParserMachine020E5.State 877 877
  core : CoreState020E5.Core 877 28941 1106642201817
  output : FillMachine020E5.State Bool outputSize

def region {n : Nat} (a : Bank Word n) : Region := ⟨a.cells⟩

def heap (d : Data) : Heap := #[
  region (PublicData020E5.image d.ro),
  region (FillStore020E5.image boolCodec (by norm_num [tapeSize]) d.tape),
  region (FillStore020E5.image wordCodec (by norm_num [romSize]) d.rom),
  region (ParserStore020E5.image (by norm_num) (by norm_num) d.parser),
  region (CoreEncoding020E5.encode (by norm_num) (by norm_num) (by norm_num) d.core),
  region (FillStore020E5.image boolCodec (by norm_num [outputSize]) d.output)]

def payloadWords : Nat := 95452+(tapeSize+1)+(romSize+1)+5266+143922+(outputSize+1)

theorem heap_size (d : Data) : (heap d).size=6 := rfl

theorem payload (d : Data) : words (heap d)=payloadWords := by
  simp only [heap,words,region,List.map_cons,List.map_nil,List.sum_cons,List.sum_nil,ArrayBank020E4.fixed_size]
  rfl

theorem resident_live (d : Data) : live (heap d)=payloadWords+12 := by rw [live,payload,heap_size]

/-- A separate allocated script block, carrying every tag/address/value
    and its scan cursor; n is the target address-space size. -/
def scratch {n : Nat} (hn : n≤2^511) (b : ScriptBuffer020E5.Buffer n 32) (cursor : Fin 33) : Bank Word 97 :=
  VerifiedPatch020E5.pack (ScriptStore020E5.controls n 32 hn (by norm_num)) (b,cursor)

def withScratch {n : Nat} (d : Data) (hn : n≤2^511) (b : ScriptBuffer020E5.Buffer n 32) (cursor : Fin 33) : Heap :=
  (RegionRam020E5.allocate (heap d) (scratch hn b cursor).cells).1

theorem withScratch_live {n : Nat} (d : Data) (hn : n≤2^511) (b : ScriptBuffer020E5.Buffer n 32) (cursor : Fin 33) :
    live (withScratch d hn b cursor)=payloadWords+111 := by
  rw [withScratch,RegionRam020E5.allocate_live,resident_live,ArrayBank020E4.fixed_size]

end FT1536.S05.BoundaryPayload020E5
