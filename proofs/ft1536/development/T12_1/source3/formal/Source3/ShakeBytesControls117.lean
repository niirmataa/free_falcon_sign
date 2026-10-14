import Source3.ShakeXorCompute117

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeBytesControls117
open C99MemoryReference
open C99CompactState115 (State reference)
open C99FiniteMemory114 (putBlock)

def word : BitVec 64 := 0x0123456789abcdef
def dataWord : BitVec 64 := 0xfedcba9876543210
def wordPointer : ArrayPointer := ⟨3,0,2,8,0⟩
def bytePointer : ArrayPointer := ⟨3,0,16,1,0⟩
def dataPointer : ArrayPointer := ⟨4,0,16,1,0⟩
def blank : State := ⟨putBlock (putBlock ⟨.empty⟩ 3 ⟨16,true,some 0,.empty⟩)
  4 ⟨16,false,some 0,.empty⟩,[],[],[],[]⟩
def loaded : State := {blank with heap := C99FiniteWrite114.write64 blank.heap wordPointer word}
def both : State := {loaded with heap := C99FiniteWrite114.write64 loaded.heap ⟨4,0,2,8,0⟩ dataWord}
def xored : State := {both with heap := C99FiniteWrite114.write64 both.heap wordPointer (word ^^^ dataWord)}

theorem decoded_little_endian : ShakeDecodeCompute117.decode loaded bytePointer=some word := by decide +kernel

theorem decoded_source : ShakeSeedMemory.Decode (reference loaded) bytePointer word :=
  ShakeDecodeCompute117.decode_sound loaded bytePointer word decoded_little_endian

/-- dec64le performs byte loads, so an unaligned byte object is valid. -/
theorem unaligned_bytes_allowed :
    ShakeDecodeCompute117.decode loaded ⟨3,1,8,1,0⟩=some 0x000123456789abcd := by decide +kernel

theorem word_load_alignment_rejected : C99FiniteRead114.read64 loaded.heap ⟨3,1,1,8,0⟩=none := by decide +kernel

theorem byte_object_bound_enforced : ShakeDecodeCompute117.decode loaded ⟨3,0,7,1,0⟩=none := by decide +kernel

theorem encoded_little_endian : ShakeEncodeCompute117.invoke blank bytePointer (.u64 word)=some loaded := by decide +kernel

theorem encoded_source : ShakeEncode.Invoke (reference blank) bytePointer (.uint64 word) (reference loaded) :=
  ShakeEncodeCompute117.invoke_sound blank loaded bytePointer (.u64 word) encoded_little_endian

theorem readonly_destination_rejected : ShakeEncodeCompute117.invoke blank dataPointer (.u64 word)=none := by decide +kernel

theorem xor_computed : ShakeXorCompute117.invoke 4 both wordPointer dataPointer (.u64 8)=some xored := by decide +kernel

theorem xor_source : ShakeSeedMemory.XorCall (reference both) wordPointer dataPointer (.uint64 8) (reference xored) :=
  ShakeXorCompute117.invoke_sound 4 both xored wordPointer dataPointer (.u64 8) xor_computed

end FT1536.Source3.ShakeBytesControls117
