import Source3.KeygenSamplerSource
import Source3.KeygenNttControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenSamplerInner
open C99ArrayReference (State bindValue)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open ShakeExtractSource (Layout)
open KeygenSamplerSource

def Control (before after : State) : Prop :=
  after.locals "u".toList=before.locals "u".toList ∧
  after.locals "n".toList=before.locals "n".toList ∧ after.arrays=before.arrays
theorem control_trans (a b c : State) (first : Control a b) (second : Control b c) : Control a c :=
  ⟨second.1.trans first.1,second.2.1.trans first.2.1,second.2.2.trans first.2.2⟩
def XDeclared (s : State) : Prop := ∃ old, s.locals "x".toList=some (.uint32,old)

theorem refill_slots (ctx : Layout) (before after : State) (source : Refill ctx before after) :
    (∀ name, name≠"rb".toList → name≠"rbits".toList → after.locals name=before.locals name) ∧
      after.arrays=before.arrays := by
  cases source with
  | skip => exact ⟨fun _ _ _ => rfl,rfl⟩
  | fill drawn after v w ty old guard nonzero declared draw bits =>
      obtain ⟨bty,previous,value,slot,ev,equal⟩ := KeygenNttForwardExec.assign_inv _ "rbits".toList _ ⟨after,.normal⟩ bits
      have he := congrArg Result.state equal
      change after=bindValue (bindValue drawn "rb".toList ty (.uint64 w)) "rbits".toList bty value at he
      subst after
      have keep := KeygenRngSource.slots ctx before drawn w draw
      refine ⟨?_,keep.2⟩
      intro name notRb notBits
      simpa only [bindValue,C99ScalarReference.set,notRb,notBits,ite_false] using congrFun keep.1 name

theorem refill_control (ctx : Layout) (before after : State) (source : Refill ctx before after) :
    Control before after := by
  have keep := refill_slots ctx before after source
  exact ⟨keep.1 _ (by decide) (by decide),keep.1 _ (by decide) (by decide),keep.2⟩

theorem refill_heap (ctx : Layout) (before after : State) (block : Nat)
    (outside : ctx.block≠block) (live : 0<before.heap.size block) (source : Refill ctx before after) :
    ShakeExtractFrame.SameBlock before.heap after.heap block := by
  cases source with
  | skip => exact ⟨rfl,rfl,fun _ => rfl⟩
  | fill drawn after v w ty old guard nonzero declared draw bits =>
      have keep := KeygenRngSource.source_frame ctx before drawn w block outside live draw
      have same := (C99ModularFrame.source_frame assignBits _ ⟨after,.normal⟩ bits (by decide)).1
      change after.heap=drawn.heap at same
      rw [same]
      exact keep

theorem tail_control (s : State) (out : Result) (source : KeygenTernaryStore.Exec s out) :
    Control s out.state := by
  cases source with
  | tail middle out prefixExecution branch =>
      have slots := KeygenNttControl.frame KeygenTernaryStore.draw s ⟨middle,.normal⟩ (by decide) prefixExecution
      have keep : Control s middle := ⟨slots.2.1 _ (by decide),slots.2.1 _ (by decide),
        funext (fun name => slots.2.2 name (by change name∉([] : List C99ArrayReference.Name); simp))⟩
      cases branch with
      | rejected => exact keep
      | accepted after v guard nonzero write => cases write; exact keep

theorem tail_x (s : State) (out : Result) (slot : XDeclared s) (source : KeygenTernaryStore.Exec s out) :
    XDeclared out.state := by
  obtain ⟨old,slot⟩ := slot
  cases source with
  | tail middle out prefixExecution branch =>
      obtain ⟨⟨x,hx⟩,_⟩ := KeygenTernaryStore.draw_slots s middle old slot prefixExecution
      cases branch with
      | rejected => exact ⟨some (.uint32 x),hx⟩
      | accepted after v guard nonzero write => cases write; exact ⟨some (.uint32 x),hx⟩

theorem inner_control (ctx : Layout) (before after : State) (source : Inner ctx before after) :
    Control before after := by
  induction source with
  | accepted before refilled after refill tail =>
      exact control_trans _ _ _ (refill_control ctx before refilled refill) (tail_control refilled _ tail)
  | rejected before refilled next after refill tail rest ih =>
      exact control_trans _ _ _
        (control_trans _ _ _ (refill_control ctx before refilled refill) (tail_control refilled _ tail)) ih

theorem inner_store (ctx : Layout) (before after : State) (dst : ArrayPointer) (i : Nat)
    (hi : i≤1536) (outside : ctx.block≠dst.block) (live : 0<before.heap.size dst.block)
    (counter : C99CountedWords.Counter before i) (binding : before.arrays "v".toList=some dst)
    (slot : XDeclared before) (source : Inner ctx before after) :
    ∃ middle : Memory, ShakeExtractFrame.SameBlock before.heap middle dst.block ∧
      ∃ z : Int, -1≤z ∧ z≤1 ∧
        KeygenSmallOutput.Store16 middle (KeygenSmallOutput.element dst i) (BitVec.ofInt 16 z) after.heap := by
  induction source with
  | accepted before refilled after refill tail =>
      have control := refill_control ctx before refilled refill
      obtain ⟨old,x⟩ := slot
      have hx := (refill_slots ctx before refilled refill).1 "x".toList (by decide) (by decide)
      obtain ⟨z,lower,upper,write⟩ := KeygenTernaryStore.accepted_store refilled ⟨after,.breakLoop⟩ dst i old hi
        (control.1.trans counter) ((congrFun control.2.2 _).trans binding) (hx.trans x) tail rfl
      exact ⟨refilled.heap,refill_heap ctx before refilled dst.block outside live refill,z,lower,upper,write⟩
  | rejected before refilled next after refill tail rest ih =>
      have control := control_trans before refilled next (refill_control ctx before refilled refill) (tail_control refilled _ tail)
      have heap := KeygenTernaryStore.rejected_heap refilled ⟨next,.normal⟩ tail rfl
      have keep := refill_heap ctx before refilled dst.block outside live refill
      have same : ShakeExtractFrame.SameBlock before.heap next.heap dst.block := by rw [heap]; exact keep
      have nextLive : 0<next.heap.size dst.block := by rw [same.1]; exact live
      obtain ⟨old,x⟩ := slot
      have hx := (refill_slots ctx before refilled refill).1 "x".toList (by decide) (by decide)
      have nextSlot := tail_x refilled ⟨next,.normal⟩ ⟨old,hx.trans x⟩ tail
      obtain ⟨middle,frame,z,lower,upper,write⟩ := ih nextLive (control.1.trans counter)
        ((congrFun control.2.2 _).trans binding) nextSlot
      exact ⟨middle,ShakeExtractFrame.same_trans _ _ _ dst.block same frame,z,lower,upper,write⟩

end FT1536.Source3.KeygenSamplerInner
