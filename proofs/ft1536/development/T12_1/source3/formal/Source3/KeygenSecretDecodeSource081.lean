import Source3.KeygenSecretComplete081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretDecodeSource081
open C99MemoryReference
open KeygenCodecExecution (byteOff)
open KeygenCodecStaticComplete (encoded)
open KeygenInt16Representation076 (wordList wordList_length)
open KeygenSecretObserved081 (ObservedSecret)

theorem observed_slice (key lengthCell : ArrayPointer) (heap : Memory)
    (left bytes right : List (BitVec 8)) (observed : ObservedSecret key lengthCell heap (left++(bytes++right))) :
    KeygenDecodeStaticWire.Reads heap (byteOff key left.length) 0 bytes := by
  intro i
  have bound : left.length+i.val<(left++(bytes++right)).length := by
    simp only [List.length_append]
    have index := i.isLt
    omega
  have read := observed.2.2 ⟨left.length+i.val,bound⟩
  change KeygenDecodeValues.LoadByte heap (byteOff key (left.length+i.val))
    ((left++(bytes++right))[left.length+i.val]'bound) at read
  simp only [List.getElem_append_right (by omega : left.length≤left.length+i.val),Nat.add_sub_cancel_left,
    List.getElem_append_left i.isLt] at read
  have shifted : KeygenDecodeValues.LoadByte heap (byteOff (byteOff key left.length) i.val) bytes[i] := by
    rw [KeygenPublicObserved077.byteOff_add]
    exact read
  have advance := KeygenDecodeNoneImages.byte_advance heap (byteOff key left.length) i.val
    (KeygenDecodeNoneImages.load_allocated _ _ _ shifted)
  refine ⟨byteOff (byteOff key left.length) i.val,?_,shifted⟩
  simpa only [KeygenPublicObserved077.byteOff_add,Nat.add_zero,Nat.zero_add] using advance

theorem packet_split (v : KeygenInt16FourMaterial076.Vectors) (slot : Fin 4) :
    ∃ left right, KeygenSecretLocal081.packet v=left++(encoded (wordList (v slot))++right) := by
  fin_cases slot
  · exact ⟨[170],encoded (wordList (v 1))++encoded (wordList (v 2))++encoded (wordList (v 3)),
      by simp only [KeygenSecretLocal081.packet,KeygenSecretPacket081.packet,KeygenSecretPacket081.payload,
        List.cons_append,List.nil_append,List.append_assoc]; rfl⟩
  · exact ⟨170::encoded (wordList (v 0)),encoded (wordList (v 2))++encoded (wordList (v 3)),
      by simp only [KeygenSecretLocal081.packet,KeygenSecretPacket081.packet,KeygenSecretPacket081.payload,
        List.cons_append,List.append_assoc]; rfl⟩
  · exact ⟨170::(encoded (wordList (v 0))++encoded (wordList (v 1))),encoded (wordList (v 3)),
      by simp only [KeygenSecretLocal081.packet,KeygenSecretPacket081.packet,KeygenSecretPacket081.payload,
        List.cons_append,List.append_assoc]; rfl⟩
  · exact ⟨170::(encoded (wordList (v 0))++encoded (wordList (v 1))++encoded (wordList (v 2))),[],
      by simp only [KeygenSecretLocal081.packet,KeygenSecretPacket081.packet,KeygenSecretPacket081.payload,
        List.cons_append,List.append_nil,List.append_assoc]; rfl⟩

def args (key dst : ArrayPointer) (left remaining : List (BitVec 8)) : KeygenDecodeValues.Args :=
  ⟨some (byteOff key left.length),BitVec.ofNat 64 remaining.length,1,18433,some dst,10⟩

/-- Every segment of the ACTUAL final observed blob admits its real full
    STATIC source dispatcher/body execution, consuming only that segment and
    recovering the same vector. The destination has ordinary decoder memory
    legality; no decoder result, length or frame is assumed. -/
theorem source_decoder_at_return (env : KeygenMakeInvocation.Env) (caller : C99ArrayReference.State)
    (out : C99ProcedureReference.Result) (result : KeygenSecretComplete081.Output env caller out)
    (slot : Fin 4) (dst : ArrayPointer)
    (legal : KeygenDecodeNoneMemory.WritableArray out.state.heap dst 1536)
    (separate : env.args.privkey.block≠dst.block) :
    ∃ (left right : List (BitVec 8)) (after : Memory),
      KeygenSecretLocal081.packet result.vectors=left++(encoded (wordList (result.vectors slot))++right) ∧
      KeygenDecodeStaticDispatchExecution.Call
        (args env.args.privkey dst left (encoded (wordList (result.vectors slot))++right)) out.state.heap after
        (BitVec.ofNat 64 (encoded (wordList (result.vectors slot))).length) ∧
      KeygenMaterial.Represents after dst (result.vectors slot) ∧
      KeygenInt16CodecMath076.IntegerReads after dst (result.vectors slot) := by
  obtain ⟨left,right,split⟩ := packet_split result.vectors slot
  have observed := result.observed
  rw [split] at observed
  have reads := observed_slice env.args.privkey env.args.privkeyLen out.state.heap left _ right observed
  have fits : (encoded (wordList (result.vectors slot))++right).length<2^64 := by
    have small := observed.1
    rw [List.length_append] at small
    omega
  let arguments := args env.args.privkey dst left (encoded (wordList (result.vectors slot))++right)
  have extent : (encoded (wordList (result.vectors slot))).length≤arguments.len.toNat := by
    change _≤(BitVec.ofNat 64 (encoded (wordList (result.vectors slot))++right).length).toNat
    rw [BitVec.toNat_ofNat,Nat.mod_eq_of_lt fits,List.length_append]
    omega
  obtain ⟨after,run,trace⟩ := KeygenDecodeStaticComplete.decoder_exists arguments out.state.heap
    (byteOff env.args.privkey left.length) dst rfl rfl rfl rfl (wordList (result.vectors slot))
    (wordList_length _) reads extent legal separate
  have outcome := KeygenDecodeStaticComplete.source_outcome arguments out.state.heap after _
    (byteOff env.args.privkey left.length) dst rfl rfl rfl rfl (wordList (result.vectors slot))
    (wordList_length _) reads extent legal separate run
  have signed := KeygenInt16FourMaterial076.bounds_signed result.vectors result.laws.2.1 slot
  have decoded := KeygenInt16CodecMath076.decoded_material after.heap dst (result.vectors slot) signed outcome.2.2.1
  exact ⟨left,right,after.heap,split,KeygenDecodeStaticDispatchFacts.call_exists arguments out.state.heap after _ rfl run,
    decoded.1,decoded.2⟩

end FT1536.Source3.KeygenSecretDecodeSource081
