import Source3.PublicRootWrites174
import Source3.PublicMiddleBody161

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRootBody174
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenPublicExec (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableAtoms (Slot)
open PublicGenerateTable159 (Written)
open PublicRootReads174 (head names)
open PublicRootWrites174 (tail)
open PublicMiddleBody161 (Frame)
open KeygenPublicInputProgram (append)

structure Context (s : State) (a : ArrayPointer) (u : Nat) : Prop where
  bound : u+768<2^64
  capacity : a.index+(u+768)≤a.count
  binding : s.arrays "a".toList=some a
  counter : USlot s "u" u
  half : USlot s "hn" 768
  factor : ∃ w, Slot s "r" w
  low : Written s.heap (element a u)
  high : Written s.heap (element a (u+768))
  width : a.elementBytes=2
  writable : s.heap.writable a.block=true
  lowAllocated : Allocated s.heap (element a u)
  highAllocated : Allocated s.heap (element a (u+768))

theorem shape : KeygenPublicRootInverseProgram.body=.scope names [] (append head tail) := by decide
theorem visible_writes : PublicScopedFrame162.writes KeygenPublicRootInverseProgram.body=[] := by decide

theorem source (s : State) (a : ArrayPointer) (u : Nat) (ctx : Context s a u) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.body s ⟨after,.normal⟩ ∧ Frame s after a := by
  obtain ⟨w,factor⟩ := ctx.factor
  obtain ⟨middle,x,y,headRun,ready,heap⟩ := PublicRootReads174.source s a u w ctx.bound
    ctx.capacity ctx.binding ctx.counter ctx.half factor ctx.low ctx.high
  have writable : middle.heap.writable a.block=true := by rw [heap]; exact ctx.writable
  have low : Allocated middle.heap (element a u) := by rw [heap]; exact ctx.lowAllocated
  have high : Allocated middle.heap (element a (u+768)) := by rw [heap]; exact ctx.highAllocated
  obtain ⟨inner,tailRun,memory⟩ := PublicRootWrites174.source middle a u x y w ctx.bound
    ctx.capacity ready ctx.width writable low high
  have innerRun := PublicAppendSource157.source KeygenPublicSource.program [] head tail s middle ⟨inner,.normal⟩ headRun tailRun
  let after := C99ArrayReference.restoreScope s inner names []
  have run : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.body s ⟨after,.normal⟩ := by
    rw [shape]
    exact .scope names [] (append head tail) s ⟨inner,.normal⟩ innerRun
  have frame := PublicScopedFrame162.frame _ _ _ _ _ (by decide) run
  refine ⟨after,run,?_,frame.2.1,?_⟩
  · refine ⟨memory.size.trans (congrArg C99MemoryReference.Memory.size heap),
      memory.writable.trans (congrArg C99MemoryReference.Memory.writable heap),?_,?_⟩
    · intro block different offset
      exact (memory.outside block different offset).trans
        (congrArg (fun h : C99MemoryReference.Memory => h.bytes block offset) heap)
    · intro j written
      apply memory.written j
      rw [heap]
      exact written
  · funext name
    exact frame.2.2 name (by rw [visible_writes]; exact List.not_mem_nil)

end FT1536.Source3.PublicRootBody174
