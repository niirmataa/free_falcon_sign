import Source3.KeygenSamplerInner
import Source3.KeygenSmallBounds

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenSamplerBounds
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open ShakeExtractSource (Layout)
open KeygenSamplerSource
open KeygenSamplerInner (XDeclared)

/- The trace explicitly allows the RNG context to change between coefficient
   writes. Each such prefix preserves the complete destination object. -/
inductive Writes (dst : ArrayPointer) : Nat → Memory → Memory → Prop where
  | done (i : Nat) (heap : Memory) (outside : ¬i<1536) : Writes dst i heap heap
  | next (i : Nat) (before refilled middle after : Memory) (z : Int) (inside : i<1536)
      (refillFrame : ShakeExtractFrame.SameBlock before refilled dst.block)
      (lower : -1≤z) (upper : z≤1)
      (store : KeygenSmallOutput.Store16 refilled (KeygenSmallOutput.element dst i) (BitVec.ofInt 16 z) middle)
      (rest : Writes dst (i+1) middle after) : Writes dst i before after

theorem earlier_bytes (dst : ArrayPointer) (i : Nat) (before after : Memory)
    (source : Writes dst i before after) (width : dst.elementBytes=2) (j : Nat) (hj : j < i) (b : Fin 2) :
    after.bytes dst.block ((KeygenSmallOutput.element dst j).offset+b.val)=
      before.bytes dst.block ((KeygenSmallOutput.element dst j).offset+b.val) := by
  induction source with
  | done => rfl
  | next i before refilled middle after z inside refillFrame lower upper store rest ih =>
      have hf := store.2.2.2.2.2.2 dst.block ((KeygenSmallOutput.element dst j).offset+b.val)
        (Or.inr (Or.inl (by
          have hb := b.isLt
          dsimp [KeygenSmallOutput.element,ArrayPointer.offset]
          rw [width]
          omega)))
      exact (ih (by omega)).trans (hf.trans (refillFrame.2.2 _))

theorem write_values (dst : ArrayPointer) (i : Nat) (before after : Memory)
    (source : Writes dst i before after) (width : dst.elementBytes=2) :
    ∀ j, i≤j → j<1536 → ∃ z : Int, -1≤z ∧ z≤1 ∧
      KeygenSmallOutput.Stored after (KeygenSmallOutput.element dst j) (BitVec.ofInt 16 z) := by
  induction source with
  | done i heap outside => intro j hij hj; omega
  | next i before refilled middle after z inside refillFrame lower upper store rest ih =>
      intro j hij hj
      by_cases equal : j=i
      · subst j
        exact ⟨z,lower,upper,fun b =>
          (earlier_bytes dst (i+1) middle after rest width i (by omega) b).trans (store.2.2.2.2.2.1 b)⟩
      · exact ih j (by omega) hj

theorem material (dst : ArrayPointer) (before after : Memory) (source : Writes dst 0 before after)
    (width : dst.elementBytes=2) : ∃ v : Geometry.Vec,
    KeygenMaterial.Represents after dst v ∧ KeygenIntegerLift.Bound v 1 := by
  classical
  have hw : ∀ j : Fin 1536, ∃ z : Int, -1≤z ∧ z≤1 ∧
      KeygenSmallOutput.Stored after (KeygenSmallOutput.element dst j.val) (BitVec.ofInt 16 z) :=
    fun j => write_values dst 0 before after source width j.val (Nat.zero_le _) j.isLt
  choose z hz using hw
  let v : Geometry.Vec := fun i => (z ⟨i.val,by have := i.isLt; omega⟩,
    z ⟨i.val+768,by have := i.isLt; omega⟩)
  refine ⟨v,?_,?_⟩
  · intro i
    exact ⟨(hz ⟨i.val,by have := i.isLt; omega⟩).2.2,(hz ⟨i.val+768,by have := i.isLt; omega⟩).2.2⟩
  · intro i
    exact ⟨abs_le.mpr ⟨(hz ⟨i.val,by have := i.isLt; omega⟩).1,(hz ⟨i.val,by have := i.isLt; omega⟩).2.1⟩,
      abs_le.mpr ⟨(hz ⟨i.val+768,by have := i.isLt; omega⟩).1,(hz ⟨i.val+768,by have := i.isLt; omega⟩).2.1⟩⟩

def declaredX (s : State) : State := C99DeclarationStatements.effect .u32 ["x".toList] s
theorem declaration_result (before after : State)
    (source : C99ModularReference.Exec declareX before ⟨after,.normal⟩) : after=declaredX before := by
  cases source with
  | base _ _ _ source => exact C99DeclarationStatements.source_result .u32 ["x".toList] before after source

theorem outer_writes (ctx : Layout) (before after : State) (dst : ArrayPointer)
    (source : Outer ctx before after) (i : Nat) (hi : i≤1536)
    (outside : ctx.block≠dst.block) (live : 0<before.heap.size dst.block)
    (counter : C99CountedWords.Counter before i) (size : C99CountedWords.Limit before)
    (binding : before.arrays "v".toList=some dst) : Writes dst i before.heap after.heap := by
  induction source generalizing i with
  | done before v guard zero =>
      exact .done i _ (C99CountedWords.guard_false before i v hi counter size guard zero)
  | next before declared inner updated after v guard nonzero declaration iteration update rest ih =>
      have inside := C99CountedWords.guard_true before i v hi counter size guard nonzero
      have hd := declaration_result before declared declaration
      subst declared
      have dc : C99CountedWords.Counter (declaredX before) i := by
        simpa [declaredX,C99CountedWords.Counter,C99DeclarationStatements.effect,
          C99DeclarationCells.declareCells,C99ScalarReference.set] using counter
      obtain ⟨refilled,frame,z,lower,upper,store⟩ := KeygenSamplerInner.inner_store ctx (declaredX before) inner dst i hi
        outside live dc binding ⟨none,rfl⟩ iteration
      have control := KeygenSamplerInner.inner_control ctx (declaredX before) inner iteration
      have cu : C99CountedWords.Counter (closedScope before inner) i := by
        change (closedScope before inner).locals "u".toList=some _
        have hu : (closedScope before inner).locals "u".toList=inner.locals "u".toList := rfl
        exact hu.trans (control.1.trans dc)
      have sn : C99CountedWords.Limit (closedScope before inner) := by
        change (closedScope before inner).locals "n".toList=some _
        have hn : (closedScope before inner).locals "n".toList=inner.locals "n".toList := rfl
        exact hn.trans (control.2.1.trans size)
      have ptr : (closedScope before inner).arrays "v".toList=some dst :=
        (congrFun control.2.2 _).trans binding
      have he := congrArg Result.state (KeygenCheckLoopBridge.increment_result (closedScope before inner) i
        ⟨updated,.normal⟩ hi cu update)
      change updated=SmallintsCounter.advanced (closedScope before inner) i at he
      subst updated
      have afterLive : 0 < inner.heap.size dst.block := by
        rw [store.2.2.2.1,frame.1]
        exact live
      have tail := ih (i+1) (by omega) afterLive
        (SmallintsCounter.advanced_counter (closedScope before inner) i)
        (SmallintsCounter.advanced_limit (closedScope before inner) i sn) ptr
      exact .next i before.heap refilled inner.heap after.heap z inside frame lower upper store tail

theorem prologue_counter (before after : State)
    (source : C99ModularReference.Exec prologue before ⟨after,.normal⟩) :
    after.locals "u".toList=some (.uint64,none) := by
  obtain ⟨middle,first,tail⟩ := KeygenNttControl.seq_inv _ _ before ⟨after,.normal⟩ (by decide) source
  have hu : middle.locals "u".toList=some (.uint64,none) := by
    cases first with
    | base _ _ _ body =>
      rw [C99DeclarationStatements.source_result .u64 ["u".toList] before middle body]
      rfl
  have keep := KeygenNttControl.frame _ middle ⟨after,.normal⟩ (by decide) tail
  exact (keep.2.1 _ (by decide)).trans hu

theorem source_writes (ctx : Layout) (before after : State) (dst : ArrayPointer)
    (outside : ctx.block≠dst.block) (live : 0<before.heap.size dst.block)
    (size : C99CountedWords.Limit before) (binding : before.arrays "v".toList=some dst)
    (source : Exec ctx before after) : Writes dst 0 before.heap after.heap := by
  cases source with
  | run declared ready after setup initialization loop =>
      have control := KeygenNttControl.frame prologue before ⟨declared,.normal⟩ (by decide) setup
      have keep := C99ModularFrame.source_frame prologue before ⟨declared,.normal⟩ setup (by decide)
      have he := congrArg Result.state (KeygenCheckLoopBridge.initial_result declared none ⟨ready,.normal⟩
        (prologue_counter before declared setup) initialization)
      change ready=KeygenCheckLoopBridge.ready declared at he
      subst ready
      have sized : C99CountedWords.Limit (KeygenCheckLoopBridge.ready declared) :=
        (control.2.1 _ (by decide)).trans size
      have alive : 0<declared.heap.size dst.block := by rw [keep.1]; exact live
      have trace := outer_writes ctx _ after dst loop 0 (by decide) outside alive
        (KeygenCheckLoopBridge.ready_counter declared) sized ((congrFun keep.2 _).trans binding)
      have heap : declared.heap=before.heap := keep.1
      change Writes dst 0 declared.heap after.heap at trace
      rw [heap] at trace
      exact trace

theorem source_material (ctx : Layout) (before after : State) (dst : ArrayPointer)
    (outside : ctx.block≠dst.block) (live : 0<before.heap.size dst.block) (width : dst.elementBytes=2)
    (size : C99CountedWords.Limit before) (binding : before.arrays "v".toList=some dst)
    (source : Exec ctx before after) :
    ∃ v : Geometry.Vec, KeygenMaterial.Represents after.heap dst v ∧ KeygenIntegerLift.Bound v 1 :=
  material dst before.heap after.heap (source_writes ctx before after dst outside live size binding source) width

end FT1536.Source3.KeygenSamplerBounds
