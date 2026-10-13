import Source3.KeygenDecodeNoneFor
import Source3.KeygenDecodeSequence

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete pinned uncompress_none body: prologue, for/while, physical
   stores, final source return and honest finite existence. Encoded-byte
   input images are joined to the actual encoder in the next interface. -/
namespace FT1536.Source3.KeygenDecodeNoneComplete
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeNoneScalar KeygenDecodeNoneReady KeygenDecodeNonePrologue
open KeygenDecodeNoneMemory KeygenDecodeNoneImages
open KeygenDecodeNonePairs (CarrierList)

def statements : List Stmt := [KeygenDecodeNoneBinding.node000,KeygenDecodeNoneBinding.node001,
  KeygenDecodeNoneBinding.node002,KeygenDecodeNoneBinding.node011,KeygenDecodeNoneBinding.node016,
  KeygenDecodeNoneBinding.node017,KeygenDecodeNoneBinding.node018,KeygenDecodeNoneBinding.node019]

theorem plug_chain (tail : Stmt) : plug tail=KeygenDecodeSequence.chain statements tail := rfl

theorem suffix_source (args : Args) (s t : State) (flow : Flow) (src dst : ArrayPointer)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (prepared : Prepared args src dst s) (images : ImagesAt s.heap src 0 inputs)
    (legal : WritableArray s.heap dst 1536) (separate : src.block≠dst.block)
    (source : Exec args KeygenDecodeNoneBinding.node046 s t flow) :
    flow=.returned 3072 ∧ Trace dst s.heap t.heap 0 inputs := by
  obtain ⟨loopEnd,forExec,returnExec⟩ := KeygenDecodeControl.seq_split_given args
    KeygenDecodeNoneBinding.node042 KeygenDecodeNoneBinding.node045 s t flow source
    (fun next result actual => (KeygenDecodeNoneFor.for_source args s next result src dst inputs count carrier
      prepared images legal separate actual).1)
  obtain ⟨_,trace,ready⟩ := KeygenDecodeNoneFor.for_source args s loopEnd .normal src dst inputs count carrier
    prepared images legal separate forExec
  obtain ⟨same,returned⟩ := KeygenDecodeNoneFor.return_tail_source args loopEnd t flow ready.count returnExec
  subst t
  exact ⟨returned,trace⟩

/-- Full source decoder outcome on honest centered input bytes and legal
    uninitialized output memory. Every output word and return3072 is derived. -/
theorem source_outcome (args : Args) (before : Memory) (after : State) (flow : Flow)
    (src dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst) (enough : 3072≤args.len.toNat)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (images : ImagesAt before src 0 inputs) (legal : WritableArray before dst 1536) (separate : src.block≠dst.block)
    (source : Exec args KeygenDecodeNoneBinding.code (initial args before) after flow) :
    flow=.returned 3072 ∧ Trace dst before after.heap 0 inputs ∧
      (∀ i : Fin inputs.length, Load16 after.heap (element dst i.val) inputs[i]) ∧
      KeygenDecodeMemory.Window dst before after.heap := by
  have frame := KeygenDecodeNoneFrame.source_frame args before after flow dst destination source
  cases source with
  | scope body s t flow noBufShadow inside =>
    obtain ⟨middle,prefixRun,prepared,heap,remaining⟩ := prefix_split args before t flow KeygenDecodeNoneBinding.node046
      src dst qM0 lognM0 data destination enough inside
    have midImages : ImagesAt middle.heap src 0 inputs := by rw [heap]; exact images
    have midLegal : WritableArray middle.heap dst 1536 := by rw [heap]; exact legal
    obtain ⟨returned,trace⟩ := suffix_source args middle t flow src dst inputs count carrier prepared midImages midLegal separate remaining
    have sourceTrace : Trace dst before t.heap 0 inputs := by rw [heap] at trace; exact trace
    have words := trace_readback dst before t.heap 0 inputs legal.1 sourceTrace
    exact ⟨returned,sourceTrace,by simpa only [Nat.zero_add,scopeExit] using words,frame⟩

/-- The full pinned decoder has a genuine finite honest execution. No
    successful return, decoded values, output frame or correctness flag
    is an input. The writable output array may have arbitrary old bytes. -/
theorem decoder_exists (args : Args) (before : Memory) (src dst : ArrayPointer)
    (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst) (enough : 3072≤args.len.toNat)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (images : ImagesAt before src 0 inputs) (legal : WritableArray before dst 1536) (separate : src.block≠dst.block) :
    ∃ after, Exec args KeygenDecodeNoneBinding.code (initial args before) after (.returned 3072) ∧
      Trace dst before after.heap 0 inputs ∧
      (∀ i : Fin inputs.length, Load16 after.heap (element dst i.val) inputs[i]) ∧
      KeygenDecodeMemory.Window dst before after.heap := by
  obtain ⟨middle,prefixRun,prepared,heap⟩ := KeygenDecodeNonePrologueExists.prefix_exists args before src dst
    qM0 lognM0 data destination enough
  have midImages : ImagesAt middle.heap src 0 inputs := by rw [heap]; exact images
  have midLegal : WritableArray middle.heap dst 1536 := by rw [heap]; exact legal
  obtain ⟨loopEnd,forExec⟩ := KeygenDecodeNoneFor.for_exists args middle src dst inputs count carrier prepared midImages midLegal separate
  have ready := (KeygenDecodeNoneFor.for_source args middle loopEnd .normal src dst inputs count carrier
    prepared midImages midLegal separate forExec).2.2
  have returnExec := KeygenDecodeNoneFor.return_tail_exists args loopEnd ready.count
  have suffixExec : Exec args KeygenDecodeNoneBinding.node046 middle loopEnd (.returned 3072) :=
    .seq args _ _ middle loopEnd loopEnd (.returned 3072) forExec returnExec
  have inside : Exec args KeygenDecodeNoneBinding.node054 (initial args before) loopEnd (.returned 3072) := by
    rw [source_partition,plug_chain]
    have runChain : Exec args (KeygenDecodeSequence.chain statements .skip) (initial args before) middle .normal := by
      simpa only [prefixCode,plug_chain] using prefixRun
    exact KeygenDecodeSequence.append_normal args statements (initial args before) middle loopEnd _ (.returned 3072) runChain suffixExec
  let after := scopeExit KeygenDecodeNoneBinding.node054 (initial args before) loopEnd
  have full : Exec args KeygenDecodeNoneBinding.code (initial args before) after (.returned 3072) :=
    .scope args _ _ loopEnd (.returned 3072) (by intro _; rfl) inside
  have actual := source_outcome args before after (.returned 3072) src dst qM0 lognM0 data destination enough
    inputs count carrier images legal separate full
  exact ⟨after,full,actual.2⟩

end FT1536.Source3.KeygenDecodeNoneComplete
