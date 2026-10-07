import Source3.KeygenSamplerBounds

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenSamplerFrame
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open ShakeExtractSource (Layout)
open KeygenSamplerSource
open ShakeExtractFrame (SameBlock same_trans)

theorem tail_frame (before : State) (out : Result) (dst : ArrayPointer) (block : Nat)
    (outside : dst.block≠block) (binding : before.arrays "v".toList=some dst)
    (source : KeygenTernaryStore.Exec before out) : SameBlock before.heap out.state.heap block := by
  cases source with
  | tail middle out prefixExecution branch =>
      have keep := C99ModularFrame.source_frame KeygenTernaryStore.draw before ⟨middle,.normal⟩ prefixExecution (by decide)
      have ptr : middle.arrays "v".toList=some dst := (congrFun keep.2 _).trans binding
      have heap : middle.heap=before.heap := keep.1
      cases branch with
      | rejected => rw [heap]; exact ⟨rfl,rfl,fun _ => rfl⟩
      | accepted after v guard nonzero write =>
        cases write with
        | store16 _ _ _ _ heapAfter p value address evaluated store =>
          cases address with
          | add root p i bound ev nonnegative within =>
            have he : root=dst := Option.some.inj (bound.symm.trans ptr)
            subst root
            cases within
            rw [heap] at store
            exact ⟨store.2.2.2.1,store.2.2.2.2.1,
              fun offset => store.2.2.2.2.2.2 block offset (Or.inl (Ne.symm outside))⟩

theorem inner_frame (ctx : Layout) (before after : State) (dst : ArrayPointer) (block : Nat)
    (contextOutside : ctx.block≠block) (destinationOutside : dst.block≠block)
    (source : Inner ctx before after) (live : 0<before.heap.size block)
    (binding : before.arrays "v".toList=some dst) : SameBlock before.heap after.heap block := by
  induction source with
  | accepted before refilled after refill tail =>
      have ref := KeygenSamplerInner.refill_heap ctx before refilled block contextOutside live refill
      have control := KeygenSamplerInner.refill_control ctx before refilled refill
      exact same_trans _ _ _ block ref
        (tail_frame refilled _ dst block destinationOutside ((congrFun control.2.2 _).trans binding) tail)
  | rejected before refilled next after refill tail rest ih =>
      have ref := KeygenSamplerInner.refill_heap ctx before refilled block contextOutside live refill
      have control := KeygenSamplerInner.control_trans before refilled next
        (KeygenSamplerInner.refill_control ctx before refilled refill) (KeygenSamplerInner.tail_control refilled _ tail)
      have ptr := (congrFun (KeygenSamplerInner.refill_control ctx before refilled refill).2.2 _).trans binding
      have one := same_trans _ _ _ block ref (tail_frame refilled _ dst block destinationOutside ptr tail)
      have alive : 0<next.heap.size block := by rw [one.1]; exact live
      exact same_trans _ _ _ block one (ih alive ((congrFun control.2.2 _).trans binding))

theorem outer_frame (ctx : Layout) (before after : State) (dst : ArrayPointer) (block : Nat)
    (contextOutside : ctx.block≠block) (destinationOutside : dst.block≠block)
    (source : Outer ctx before after) (live : 0<before.heap.size block)
    (binding : before.arrays "v".toList=some dst) : SameBlock before.heap after.heap block := by
  induction source with
  | done => exact ⟨rfl,rfl,fun _ => rfl⟩
  | next before declared inner updated after v guard nonzero declaration iteration update rest ih =>
      have hd := KeygenSamplerBounds.declaration_result before declared declaration
      subst declared
      have one := inner_frame ctx (KeygenSamplerBounds.declaredX before) inner dst block
        contextOutside destinationOutside iteration live binding
      have arrays := (KeygenSamplerInner.inner_control ctx _ inner iteration).2.2
      have inc := C99ModularFrame.source_frame increment (closedScope before inner) ⟨updated,.normal⟩ update (by decide)
      have heap : updated.heap=inner.heap := inc.1
      have current : SameBlock before.heap updated.heap block := by rw [heap]; exact one
      have alive : 0<updated.heap.size block := by rw [current.1]; exact live
      have ptr : updated.arrays "v".toList=some dst := (congrFun inc.2 _).trans ((congrFun arrays _).trans binding)
      exact same_trans _ _ _ block current (ih alive ptr)

theorem source_frame (ctx : Layout) (before after : State) (dst : ArrayPointer) (block : Nat)
    (contextOutside : ctx.block≠block) (destinationOutside : dst.block≠block)
    (live : 0<before.heap.size block) (binding : before.arrays "v".toList=some dst)
    (source : Exec ctx before after) : SameBlock before.heap after.heap block := by
  cases source with
  | run declared ready after setup initialization loop =>
      have pro := C99ModularFrame.source_frame prologue before ⟨declared,.normal⟩ setup (by decide)
      have init := C99ModularFrame.source_frame initial declared ⟨ready,.normal⟩ initialization (by decide)
      have heap : ready.heap=before.heap := init.1.trans pro.1
      have ptr : ready.arrays "v".toList=some dst := (congrFun init.2 _).trans ((congrFun pro.2 _).trans binding)
      have alive : 0<ready.heap.size block := by rw [heap]; exact live
      have keep := outer_frame ctx ready after dst block contextOutside destinationOutside loop alive ptr
      rw [heap] at keep
      exact keep

theorem represents (before after : Memory) (p : ArrayPointer) (v : Geometry.Vec)
    (same : SameBlock before after p.block) (material : KeygenMaterial.Represents before p v) :
    KeygenMaterial.Represents after p v := by
  intro i
  exact ⟨fun b => (same.2.2 _).trans ((material i).1 b),fun b => (same.2.2 _).trans ((material i).2 b)⟩

end FT1536.Source3.KeygenSamplerFrame
