import Source3.ZintModSignedWord194
import Source3.StepCopyFixed190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One additional-prime march iteration of the make_fg_step walk
   (MakeFgAddPrimeShape194.walkBody) and the shared two-clause increment:
   one ZintModSignedWord194.ms_call instance at the pinned walk shape
   MakeFgAddPrimeShape194.modArgs with the executed word stored to t1[v]
   (the ReceiveC.store of the call statement), then the skip of the body
   scope. The callee keeps every caller cell and the whole heap; the only
   state change of one iteration is the t1[v] store. The increment
   (v += 1, x += slen) is the copy-loop clause verbatim
   (StepCopyBody190.inc_source at u0 = 0, slen = 1). Values stay executed
   words: no transform property, table law, root law or positivity claim
   is made here. -/
namespace FT1536.Source3.StepWalkBody195
open C99ArrayReference (State Pointer Name)
open C99MemoryReference (ArrayPointer Allocated Load32 Store32)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open KeygenMakeFgSource (Exec)
open ZintModSignedWord194 (modSignedWord)
open StepCopyBody190 (addr elem output next)

/- The marched cell of step i (stride slen = 1, start offset 0). -/
theorem march_capacity (src : ArrayPointer) (n i : Nat)
    (capacity : src.index+0+n*1≤src.count) (slot : i<n) : src.index+0+i*1≤src.count := by
  omega

theorem march_capacity_next (src : ArrayPointer) (n i : Nat)
    (capacity : src.index+0+n*1≤src.count) (slot : i<n) : src.index+0+i*1+1≤src.count := by
  omega

/- The slen cell of the walk is the u64 word 1, the dlen = 1 instance of
   the engine (ZintModSignedWord194.ms_call). -/
theorem slen_one (s : State) (slenCell : Cell s "slen".toList 1) :
    s.locals "slen".toList=some (.uint64,some (.uint64 1#64)) := by
  simpa [C99LoopScalar141.Cell,C99NatWord141.word] using slenCell

/- One march step: the body scope of the walk at the marched word. -/
theorem body_source (s : State) (src t1 : ArrayPointer) (i : Nat) (d0 pw p0w r2w rxw : BitVec 32)
    (bound : i<2^64) (srcCapacity : src.index+0+i*1≤src.count)
    (t1Capacity : t1.index+i<t1.count)
    (t1Binding : s.arrays "t1".toList=some t1)
    (xBinding : s.arrays "x".toList=some (addr src 0 i 1))
    (counter : Cell s "v".toList i) (slenCell : Cell s "slen".toList 1)
    (pSlot : Slot s "p" pw) (p0iSlot : Slot s "p0i" p0w)
    (r2Slot : Slot s "R2" r2w) (rxSlot : Slot s "Rx" rxw)
    (read : Load32 s.heap (addr src 0 i 1) d0)
    (t1Allocated : Allocated s.heap (elem t1 i)) (t1Width : t1.elementBytes=4)
    (t1Writable : s.heap.writable t1.block=true) :
    Exec MakeFgAddPrimeShape194.walkBody s
      ⟨output s t1 i (modSignedWord d0 pw p0w r2w rxw),.normal⟩ := by
  have cap : (addr src 0 i 1).index≤(addr src 0 i 1).count := by
    rw [StepCopyBody190.addr_index,StepCopyBody190.addr_count]
    exact srcCapacity
  have hslen : s.locals "slen".toList=some (.uint64,some (.uint64 1#64)) :=
    slen_one s slenCell
  obtain ⟨entry,out,binding,run,returned,stateEq⟩ :=
    ZintModSignedWord194.ms_call s (addr src 0 i 1) d0 pw p0w r2w rxw xBinding cap hslen
      pSlot p0iSlot r2Slot rxSlot read
  have address : Pointer s "t1".toList MakeFgAddPrimeShape194.varV (elem t1 i) :=
    StepCopyBody190.t1_address s t1 i bound (by omega) t1Binding counter
  have write : Store32 s.heap (elem t1 i)
      (BitVec.ofInt 32 (Value.integer (.uint32 (modSignedWord d0 pw p0w r2w rxw))))
      (Word32Memory176.write s.heap (elem t1 i) (modSignedWord d0 pw p0w r2w rxw)) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq]
      using Word32Memory176.source s.heap (elem t1 i) (modSignedWord d0 pw p0w r2w rxw)
        t1Allocated t1Width t1Writable
  have receive : KeygenZintCall.ReceiveC (.store "t1".toList MakeFgAddPrimeShape194.varV)
      {s with heap := out.state.heap} (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))
      (output s t1 i (modSignedWord d0 pw p0w r2w rxw)) := by
    rw [← stateEq]
    exact KeygenZintCall.ReceiveC.store "t1".toList MakeFgAddPrimeShape194.varV s
      (Word32Memory176.write s.heap (elem t1 i) (modSignedWord d0 pw p0w r2w rxw))
      (elem t1 i) (.uint32 (modSignedWord d0 pw p0w r2w rxw)) address write
  have callRun : KeygenZintCall.Exec MakeFgAddPrimeShape194.modCall s
      ⟨output s t1 i (modSignedWord d0 pw p0w r2w rxw),.normal⟩ :=
    KeygenZintCall.Exec.call s .modSigned MakeFgAddPrimeShape194.modArgs
      (.store "t1".toList MakeFgAddPrimeShape194.varV) entry out
      (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))
      (output s t1 i (modSignedWord d0 pw p0w r2w rxw)) binding run returned receive
  have zintRun : Exec (.zint MakeFgAddPrimeShape194.modCall) s
      ⟨output s t1 i (modSignedWord d0 pw p0w r2w rxw),.normal⟩ :=
    KeygenMakeFgSource.Exec.zint _ _ _ callRun
  have skipRun : Exec KeygenMakeFgSource.skip
      (output s t1 i (modSignedWord d0 pw p0w r2w rxw))
      ⟨output s t1 i (modSignedWord d0 pw p0w r2w rxw),.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _)))
  have inner : Exec (.seq (.zint MakeFgAddPrimeShape194.modCall) KeygenMakeFgSource.skip) s
      ⟨output s t1 i (modSignedWord d0 pw p0w r2w rxw),.normal⟩ :=
    .seqNormal _ _ s (output s t1 i (modSignedWord d0 pw p0w r2w rxw))
      ⟨output s t1 i (modSignedWord d0 pw p0w r2w rxw),.normal⟩ zintRun skipRun
  exact KeygenMakeFgSource.Exec.scope [] [] (.seq (.zint MakeFgAddPrimeShape194.modCall)
    KeygenMakeFgSource.skip) s ⟨output s t1 i (modSignedWord d0 pw p0w r2w rxw),.normal⟩ inner

/- The shared increment clause of the walk (walkInc is the copy loop
   increment verbatim), at the marched position. -/
theorem inc_source (s : State) (src t1 : ArrayPointer) (i : Nat) (w : BitVec 32)
    (bound : i<2^64) (srcCapacity : src.index+0+i*1+1≤src.count)
    (counter : Cell s "v".toList i) (slenCell : Cell s "slen".toList 1)
    (xBinding : s.arrays "x".toList=some (addr src 0 i 1)) :
    Exec MakeFgAddPrimeShape194.walkInc (output s t1 i w)
      ⟨next s src t1 0 1 i w,.normal⟩ :=
  StepCopyBody190.inc_source s src t1 0 1 i w bound (by decide) srcCapacity counter slenCell
    xBinding

end FT1536.Source3.StepWalkBody195
