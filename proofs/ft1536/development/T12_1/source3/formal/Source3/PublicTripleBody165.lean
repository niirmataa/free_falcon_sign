import Source3.PublicTripleWrites165
import Source3.PublicInitializedFrame164

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTripleBody165
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenPublicExec (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenSmallOutput (element)
open PublicGenerateTable159 (Written)
open PublicU32Locals165 (Has)
open PublicTripleShape165 (names declarations reads products writes)
open KeygenPublicInputProgram (append)

structure Context (s : State) (a gm : ArrayPointer) (u v : Nat) : Prop where
  uBound : u+2 < 1536
  vBound : v < 1024
  capacity : a.index+1536 ≤ a.count
  tableCapacity : gm.index+1024 ≤ gm.count
  binding : s.arrays "a".toList=some a
  tableBinding : s.arrays "gm_cubic".toList=some gm
  uSlot : USlot s "u" u
  vSlot : USlot s "v" v
  factor : Has s "w"
  data : ∀ j, j < 3 → Written s.heap (element a (u+j))
  table : Written s.heap (element gm v)
  width : a.elementBytes=2
  writable : s.heap.writable a.block=true
  allocated : ∀ j, j < 3 → Allocated s.heap (element a (u+j))

structure Frame (before after : State) : Prop where
  arrays : after.arrays=before.arrays
  locals : after.locals=before.locals
  memory : PublicInitializedFrame164.Frame before.heap after.heap

theorem visible_writes : PublicScopedFrame162.writes PublicTailShape159.tripleBody=[] := rfl

theorem source (s : State) (a gm : ArrayPointer) (u v : Nat) (ctx : Context s a gm u v) :
    ∃ after, Exec KeygenPublicSource.program [] PublicTailShape159.tripleBody s ⟨after,.normal⟩ ∧
      Frame s after := by
  let declared := PublicTripleDeclare165.after s
  have declareRun := PublicTripleDeclare165.source s
  obtain ⟨readState,readRun,env,ready,readHeap⟩ := PublicTripleReads165.source declared a gm u v
    (PublicTripleDeclare165.declared s) (PublicTripleDeclare165.ready_w s ctx.factor)
    ctx.uBound ctx.vBound ctx.capacity ctx.tableCapacity ctx.binding ctx.tableBinding
    ctx.uSlot ctx.vSlot ctx.data ctx.table
  obtain ⟨productState,productRun,_,complete,productHeap⟩ := PublicTripleProducts165.source readState env ready
  have readFrame := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) readRun
  have productFrame := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) productRun
  have binding : productState.arrays "a".toList=some a := by
    rw [productFrame.2.1,readFrame.2.1]; exact ctx.binding
  have counter : USlot productState "u" u :=
    (productFrame.2.2 _ (by decide)).trans ((readFrame.2.2 _ (by decide)).trans ctx.uSlot)
  have writable : productState.heap.writable a.block=true := by
    rw [productHeap,readHeap]; exact ctx.writable
  have allocated : ∀ j, j < 3 → Allocated productState.heap (element a (u+j)) := by
    intro j hj
    rw [productHeap,readHeap]; exact ctx.allocated j hj
  obtain ⟨raw,writeRun⟩ := PublicTripleWrites165.source productState a u complete ctx.uBound
    ctx.capacity binding counter ctx.width writable allocated
  have lastRun := PublicAppendSource157.source KeygenPublicSource.program [] products writes
    readState productState ⟨raw,.normal⟩ productRun writeRun
  have restRun := PublicAppendSource157.source KeygenPublicSource.program [] reads (append products writes)
    declared readState ⟨raw,.normal⟩ readRun lastRun
  have innerRun := PublicAppendSource157.source KeygenPublicSource.program [] declarations
    (append reads (append products writes)) s declared ⟨raw,.normal⟩ declareRun restRun
  let after := C99ArrayReference.restoreScope s raw (names.map String.toList) []
  have run : Exec KeygenPublicSource.program [] PublicTailShape159.tripleBody s ⟨after,.normal⟩ := by
    rw [PublicTripleShape165.source_shape]
    exact .scope _ [] _ s ⟨raw,.normal⟩ innerRun
  have frame := PublicScopedFrame162.frame _ _ _ _ _ (by decide) run
  refine ⟨after,run,frame.2.1,?_,PublicInitializedFrame164.source _ _ _ _ _ (by decide) run⟩
  funext name
  exact frame.2.2 name (by simp [visible_writes])

end FT1536.Source3.PublicTripleBody165
