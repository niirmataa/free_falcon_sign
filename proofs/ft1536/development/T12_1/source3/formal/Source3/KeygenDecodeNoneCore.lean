import Source3.KeygenDecodeAssignments
import Source3.KeygenDecodeWordOps

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The exact sign extension, range guard, long subtraction and narrowing
   of a source NONE coefficient. Carrier restriction is explicit; actual
   byte-index and whole-loop composition are separate obligations. -/
namespace FT1536.Source3.KeygenDecodeNoneCore
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeWordOps KeygenDecodeNoneScalar

def Cell (name : String) (ty : C99IntegerReference.Ty) (value : IV) (l : Locals) : Prop :=
  l.scalars name.toList=some (ty,some value)

def signRhs : Expr := .unary .neg (.binary .band (.variable "w".toList) (.number .i32 32768))

theorem sign_calculation (args : Args) (s : State) (word : BitVec 32)
    (cell : Cell "w" .uint32 (.uint32 word) s.locals) :
    Computes args s.heap s.buf s.locals signRhs (.uint32 (-(word &&& 32768))) :=
  .unary _ _ _ _ (.binary _ _ _ _ _ _
    (.scalar _ _ _ (by unfold Ordinary; decide +kernel) cell)
    (.number _ _ _ (by decide +kernel)) (.band _ _ _ (mask32 word)))
    (.neg _ _ (neg32 _))

theorem sign_source (args : Args) (s t : State) (flow : Flow) (word : BitVec 32)
    (cell : Cell "w" .uint32 (.uint32 word) s.locals)
    (source : Exec args KeygenDecodeNoneBinding.node023 s t flow) :
    t=withLocals s (localSet s.locals "w".toList .uint32 (some (.uint32 (signedWord word)))) ∧ flow=.normal := by
  have result := KeygenDecodeAssignments.compound args s t flow "w".toList .uint32 (.uint32 word)
    .bor .bor signRhs (.uint32 (-(word &&& 32768))) (.uint32 (signedWord word)) cell rfl
    (sign_calculation args s word cell) (.bor _ _ _ (or32 _ _)) source
  simpa only [self32] using result

theorem add_q_source (args : Args) (s t : State) (flow : Flow) (word : BitVec 32)
    (cell : Cell "w" .uint32 (.uint32 word) s.locals)
    (q : Cell "q" .uint32 (.uint32 18433) s.locals)
    (source : Exec args KeygenDecodeNoneBinding.node024 s t flow) :
    t=withLocals s (localSet s.locals "w".toList .uint32 (some (.uint32 (word+18433)))) ∧ flow=.normal := by
  have result := KeygenDecodeAssignments.compound args s t flow "w".toList .uint32 (.uint32 word)
    .add .add (.variable "q".toList) (.uint32 18433) (.uint32 (word+18433)) cell rfl
    (.scalar _ _ _ (by unfold Ordinary; decide +kernel) q) (.add _ _ _ (add32 _ _)) source
  simpa only [self32] using result

def rangeBits : Expr := .binary .shr
  (.binary .band (.binary .sub (.variable "hq".toList) (.variable "w".toList))
    (.binary .sub (.variable "w".toList) (.variable "tq".toList))) (.number .i32 31)

theorem range_calculation (args : Args) (s : State) (word : BitVec 32)
    (w : Cell "w" .uint32 (.uint32 word) s.locals)
    (hq : Cell "hq" .uint32 (.uint32 9216) s.locals)
    (tq : Cell "tq" .uint32 (.uint32 27650) s.locals) :
    Computes args s.heap s.buf s.locals rangeBits (.uint32 (guardWord word)) := by
  exact .binary _ _ _ _ _ _
    (.binary _ _ _ _ _ _
      (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) hq)
        (.scalar _ _ _ (by unfold Ordinary; decide +kernel) w) (.sub _ _ _ (sub32 _ _)))
      (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) w)
        (.scalar _ _ _ (by unfold Ordinary; decide +kernel) tq) (.sub _ _ _ (sub32 _ _)))
      (.band _ _ _ (and32 _ _)))
    (.number _ _ _ (by decide +kernel)) (.shr _ _ _ (right32 _ 31 (by decide +kernel)))

theorem guard_calculation (args : Args) (s : State) (input : BitVec 16) (carrier : Carrier input)
    (w : Cell "w" .uint32 (.uint32 (adjusted (high input) (low input))) s.locals)
    (hq : Cell "hq" .uint32 (.uint32 9216) s.locals)
    (tq : Cell "tq" .uint32 (.uint32 27650) s.locals) :
    Computes args s.heap s.buf s.locals KeygenDecodeNoneBinding.guard029 (.int32 0) := by
  have bits := range_calculation args s _ w hq tq
  rw [carrier_guard input carrier] at bits
  exact .unary _ _ _ _ bits (.logicalNot (.integer (.uint32 1)))

/-- Honest source guard cannot return zero; its actual chosen branch is skip. -/
theorem guard_source (args : Args) (s t : State) (flow : Flow) (input : BitVec 16) (carrier : Carrier input)
    (w : Cell "w" .uint32 (.uint32 (adjusted (high input) (low input))) s.locals)
    (hq : Cell "hq" .uint32 (.uint32 9216) s.locals)
    (tq : Cell "tq" .uint32 (.uint32 27650) s.locals)
    (source : Exec args KeygenDecodeNoneBinding.node029 s t flow) : t=s ∧ flow=.normal := by
  have calculation := guard_calculation args s input carrier w hq tq
  cases source with
  | branchTrue test a b s t flow value locals evaluated yes selected =>
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ _ calculation locals value evaluated
    subst value
    cases yes
  | branchFalse test a b s t flow value locals evaluated no selected =>
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ _ calculation locals value evaluated
    subst locals
    cases selected
    exact ⟨rfl,rfl⟩

theorem guard_exists (args : Args) (s : State) (input : BitVec 16) (carrier : Carrier input)
    (w : Cell "w" .uint32 (.uint32 (adjusted (high input) (low input))) s.locals)
    (hq : Cell "hq" .uint32 (.uint32 9216) s.locals)
    (tq : Cell "tq" .uint32 (.uint32 27650) s.locals) :
    Exec args KeygenDecodeNoneBinding.node029 s s .normal :=
  .branchFalse args _ _ _ s s .normal (.integer (.int32 0)) s.locals
    (computes_exists args s.heap s.buf s.locals _ _ (guard_calculation args s input carrier w hq tq))
    rfl (.skip args s)

end FT1536.Source3.KeygenDecodeNoneCore
