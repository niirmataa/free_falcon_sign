import Source3.PublicMiddleWrites161

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicMiddleBody161
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenPublicExec (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableAtoms (Slot)
open PublicGenerateTable159 (Written)
open PublicMiddleReads161 (head names)
open PublicMiddleWrites161 (tail MemoryFrame)
open KeygenPublicInputProgram (append)

structure Context (s : State) (a : ArrayPointer) (v ht : Nat) : Prop where
  bound : v+ht < 2^64
  capacity : a.index+(v+ht) ≤ a.count
  binding : s.arrays "a".toList=some a
  counter : USlot s "v" v
  half : USlot s "ht" ht
  factor : ∃ w, Slot s "s" w
  low : Written s.heap (element a v)
  high : Written s.heap (element a (v+ht))
  width : a.elementBytes=2
  writable : s.heap.writable a.block=true
  lowAllocated : Allocated s.heap (element a v)
  highAllocated : Allocated s.heap (element a (v+ht))

structure Frame (before after : State) (a : ArrayPointer) : Prop extends MemoryFrame before after a where
  arrays : after.arrays=before.arrays
  locals : after.locals=before.locals

theorem shape : PublicTailShape159.midInnerBody = .scope names [] (append head tail) := rfl

theorem restored_locals (before inner : State)
    (run : Exec KeygenPublicSource.program [] (append head tail) before ⟨inner,.normal⟩) :
    (C99ArrayReference.restoreScope before inner names []).locals=before.locals := by
  have fr := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) run
  funext n
  change (if names.contains n then before.locals n else inner.locals n)=before.locals n
  split
  · rfl
  · apply fr.2.2 n
    rename_i outside
    simp [names] at outside
    simp [names,head,tail,append,KeygenPublicExec.chain,
      KeygenPublicTableControl.writes,outside.1,outside.2]

theorem source (s : State) (a : ArrayPointer) (v ht : Nat) (ctx : Context s a v ht) :
    ∃ after, Exec KeygenPublicSource.program [] PublicTailShape159.midInnerBody s ⟨after,.normal⟩ ∧
      Frame s after a := by
  obtain ⟨w,factor⟩ := ctx.factor
  obtain ⟨middle,x,y,headRun,ready,heap⟩ := PublicMiddleReads161.source s a v ht w ctx.bound
    ctx.capacity ctx.binding ctx.counter ctx.half factor ctx.low ctx.high
  have writable : middle.heap.writable a.block=true := by rw [heap]; exact ctx.writable
  have low : Allocated middle.heap (element a v) := by rw [heap]; exact ctx.lowAllocated
  have high : Allocated middle.heap (element a (v+ht)) := by rw [heap]; exact ctx.highAllocated
  obtain ⟨inner,tailRun,memory⟩ := PublicMiddleWrites161.source middle a v ht x y ctx.bound
    ctx.capacity ready ctx.width writable low high
  have innerRun := PublicAppendSource157.source KeygenPublicSource.program [] head tail
    s middle ⟨inner,.normal⟩ headRun tailRun
  let after := C99ArrayReference.restoreScope s inner names []
  have run : Exec KeygenPublicSource.program [] PublicTailShape159.midInnerBody s ⟨after,.normal⟩ := by
    rw [shape]
    exact .scope names [] (append head tail) s ⟨inner,.normal⟩ innerRun
  have fr := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) innerRun
  refine ⟨after,run,?_,fr.2.1,restored_locals s inner innerRun⟩
  refine ⟨memory.size.trans (congrArg C99MemoryReference.Memory.size heap),
    memory.writable.trans (congrArg C99MemoryReference.Memory.writable heap),?_,?_⟩
  · intro block different offset
    exact (memory.outside block different offset).trans
      (congrArg (fun h : C99MemoryReference.Memory => h.bytes block offset) heap)
  · intro j written
    apply memory.written j
    rw [heap]
    exact written

end FT1536.Source3.PublicMiddleBody161
