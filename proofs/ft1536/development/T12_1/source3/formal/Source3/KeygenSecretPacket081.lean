import Source3.KeygenSecretSegment081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretPacket081
open KeygenSecretSegment081 (segment)
open KeygenCodecStaticComplete (encoded)
open KeygenInt16Representation076 (wordList wordList_length)
open KeygenInt16Vector076 (Signed16)

abbrev Material := Geometry.Vec × Geometry.Vec × Geometry.Vec × Geometry.Vec

def decodeVector (inputs : List (BitVec 16)) : Option Geometry.Vec :=
  if count : inputs.length=1536 then
    some (KeygenInt16Vector076.vector (fun i => inputs[i.val]'(by rw [count]; exact i.isLt)))
  else none

/-- The emitted M0/STATIC format: exact header0xaa, four independently
    padded segments in f,g,F,G order, and no leftover secret bytes. -/
def DecodeSecret : List (BitVec 8) → Option Material
  | [] => none
  | header::payload =>
    if header=170 then do
      let (fw,t0) ← segment payload
      let (gw,t1) ← segment t0
      let (bigFw,t2) ← segment t1
      let (bigGw,t3) ← segment t2
      if t3=[] then
        let f ← decodeVector fw
        let g ← decodeVector gw
        let bigF ← decodeVector bigFw
        let bigG ← decodeVector bigGw
        return (f,g,bigF,bigG)
      else none
    else none

def payload (f g bigF bigG : Geometry.Vec) : List (BitVec 8) :=
  encoded (wordList f)++encoded (wordList g)++encoded (wordList bigF)++encoded (wordList bigG)

def packet (f g bigF bigG : Geometry.Vec) : List (BitVec 8) := 170::payload f g bigF bigG

theorem decode_vector (v : Geometry.Vec) (signed : Signed16 v) : decodeVector (wordList v)=some v := by
  unfold decodeVector
  rw [dite_eq_left (wordList_length v)]
  simpa only [wordList,List.getElem_ofFn] using congrArg some (KeygenInt16Vector076.vector_words v signed)

theorem segment_wordlist (v : Geometry.Vec) (tail : List (BitVec 8)) :
    segment (encoded (wordList v)++tail)=some (wordList v,tail) :=
  KeygenSecretSegment081.segment_honest (wordList v) tail (wordList_length v)

theorem segment_last (v : Geometry.Vec) : segment (encoded (wordList v))=some (wordList v,[]) := by
  simpa only [List.append_nil] using segment_wordlist v []

theorem decode_honest (f g bigF bigG : Geometry.Vec)
    (sf : Signed16 f) (sg : Signed16 g) (sF : Signed16 bigF) (sG : Signed16 bigG) :
    DecodeSecret (packet f g bigF bigG)=some (f,g,bigF,bigG) := by
  simp only [DecodeSecret,packet,payload,List.append_assoc,ite_true,segment_wordlist]
  dsimp only [Bind.bind,Option.bind]
  rw [segment_wordlist]
  dsimp only [Bind.bind,Option.bind]
  rw [segment_wordlist]
  dsimp only [Bind.bind,Option.bind]
  rw [segment_last]
  dsimp only [Bind.bind,Option.bind]
  rw [ite_eq_left rfl,decode_vector f sf,decode_vector g sg,decode_vector bigF sF,decode_vector bigG sG]
  rfl

theorem packet_length (f g bigF bigG : Geometry.Vec) :
    (packet f g bigF bigG).length=1+KeygenCodecStaticLength.byteLength (wordList f)+
      KeygenCodecStaticLength.byteLength (wordList g)+KeygenCodecStaticLength.byteLength (wordList bigF)+
      KeygenCodecStaticLength.byteLength (wordList bigG) := by
  simp only [packet,payload,List.length_cons,List.length_append,KeygenCodecStaticLength.encoded_length]
  omega

end FT1536.Source3.KeygenSecretPacket081
