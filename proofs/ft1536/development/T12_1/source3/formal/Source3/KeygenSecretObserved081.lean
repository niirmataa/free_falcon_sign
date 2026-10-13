import Source3.KeygenSecretPacket081
import Source3.KeygenPublicObserved077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretObserved081
open C99MemoryReference
open KeygenCodecExecution (byteOff)
open KeygenDecodeValues (LoadByte)
open KeygenCodecByteHistory (Trace)
open KeygenCodecStaticHistory (positions)

/-- Observation reads only actual length and buffer bytes. It is independent
    of the mathematical material and of DecodeSecret. -/
abbrev ObservedSecret := KeygenPublicObserved077.ObservedPublic

theorem packet_observed (before encoded after : Memory) (key lengthCell : ArrayPointer)
    (bytes : List (BitVec 8)) (small : bytes.length+1<2^64) (separate : key.block≠lengthCell.block)
    (header : LoadByte before (byteOff key 0) 170)
    (payload : Trace before encoded (positions (some key) 1 bytes))
    (lengthStore : Store64 encoded lengthCell (BitVec.ofNat 64 (bytes.length+1)) after) :
    ObservedSecret key lengthCell after (170::bytes) := by
  have preserved := KeygenCodecByteHistory.outside _ _ _ payload key.block key.offset
    (by simpa only [Nat.add_zero] using KeygenCodecNoneWire.later_away key 0 bytes)
  have headerRead : LoadByte encoded (byteOff key 0) 170 :=
    KeygenPublicObserved077.byte_transport before encoded (byteOff key 0) 170
      (KeygenCodecStaticMaterial.trace_sizes _ _ _ payload)
      (by simpa only [KeygenCodecNoneWire.byte_offset,Nat.add_zero,
        show (byteOff key 0).block=key.block by rfl] using preserved) header
  refine ⟨small,KeygenMakeInvocation.load64_of_store encoded after lengthCell _ lengthStore,?_⟩
  intro i
  refine Fin.cases ?_ (fun j => ?_) i
  · exact KeygenPublicObserved077.byte_after_length encoded after (byteOff key 0) lengthCell _ 170 separate lengthStore headerRead
  · have read := KeygenCodecNoneWire.trace_readback key 1 bytes before encoded payload j
    have source := KeygenPublicObserved077.byte_after_length encoded after (byteOff key (1+j.val)) lengthCell _ bytes[j]
      separate lengthStore read
    change LoadByte after (byteOff key (j.val+1)) bytes[j]
    simpa only [Nat.add_comm 1 j.val] using source

theorem byte_block (before after : Memory) (p : ArrayPointer) (word : BitVec 8)
    (frame : KeygenMakeObjects.Block before after p.block) (read : LoadByte before p word) : LoadByte after p word := by
  cases read with
  | load allocated width initialized =>
    exact .load after p word (KeygenMakeEntry.allocated_block before after p frame allocated) width
      ((frame.2.2 _).trans initialized)

theorem length_block (before after : Memory) (p : ArrayPointer) (word : BitVec 64)
    (frame : KeygenMakeObjects.Block before after p.block) (read : Load64 before p word) : Load64 after p word := by
  cases read with
  | load bytes allocated width initialized =>
    exact .load after p bytes (KeygenMakeEntry.allocated_block before after p frame allocated) width
      (fun i => (frame.2.2 _).trans (initialized i))

/-- Buffer observations survive changes and teardown of OTHER blocks.
    Global equality of allocation sizes is not needed after scope close. -/
theorem preserved (key lengthCell : ArrayPointer) (before after : Memory) (packet : List (BitVec 8))
    (keyFrame : KeygenMakeObjects.Block before after key.block)
    (lengthFrame : KeygenMakeObjects.Block before after lengthCell.block)
    (observed : ObservedSecret key lengthCell before packet) : ObservedSecret key lengthCell after packet :=
  ⟨observed.1,length_block before after lengthCell _ lengthFrame observed.2.1,
    fun i => byte_block before after (byteOff key i.val) packet[i] keyFrame (observed.2.2 i)⟩

theorem unique (key lengthCell : ArrayPointer) (heap : Memory) (a b : List (BitVec 8))
    (first : ObservedSecret key lengthCell heap a) (second : ObservedSecret key lengthCell heap b) : a=b :=
  KeygenPublicObserved077.observed_unique key lengthCell heap a b first second

end FT1536.Source3.KeygenSecretObserved081
