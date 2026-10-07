import Source3.KeygenSmallStep
import Source3.KeygenMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenSmallBounds
open C99ArrayReference (State bindValue)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSmallSource

/- A derived trace of bounded writes. The source Exec rules contain neither
   this predicate nor the coefficient bounds. Failure remains observable. -/
inductive Writes (dst : ArrayPointer) : Nat → Memory → Memory → Prop where
  | done (i : Nat) (heap : Memory) (outside : ¬i<1536) : Writes dst i heap heap
  | next (i : Nat) (before middle after : Memory) (z : Int) (inside : i<1536)
      (bound : KeygenSmallOutput.accepted z)
      (store : KeygenSmallOutput.Store16 before (KeygenSmallOutput.element dst i) (BitVec.ofInt 16 z) middle)
      (rest : Writes dst (i+1) middle after) : Writes dst i before after

theorem earlier_bytes (dst : ArrayPointer) (i : Nat) (before after : Memory)
    (source : Writes dst i before after) (width : dst.elementBytes=2) (j : Nat) (hj : j < i) (b : Fin 2) :
    after.bytes dst.block ((KeygenSmallOutput.element dst j).offset+b.val)=
      before.bytes dst.block ((KeygenSmallOutput.element dst j).offset+b.val) := by
  induction source with
  | done => rfl
  | next i before middle after z inside bound store rest ih =>
    have hf := store.2.2.2.2.2.2 dst.block ((KeygenSmallOutput.element dst j).offset+b.val)
      (Or.inr (Or.inl (by
        have hb := b.isLt
        dsimp [KeygenSmallOutput.element,ArrayPointer.offset]
        rw [width]
        omega)))
    exact (ih (by omega)).trans hf

theorem write_values (dst : ArrayPointer) (i : Nat) (before after : Memory)
    (source : Writes dst i before after) (width : dst.elementBytes=2) :
    ∀ j, i≤j → j<1536 → ∃ z : Int, KeygenSmallOutput.accepted z ∧
      KeygenSmallOutput.Stored after (KeygenSmallOutput.element dst j) (BitVec.ofInt 16 z) := by
  induction source with
  | done i heap outside => intro j hij hj; omega
  | next i before middle after z inside bound store rest ih =>
    intro j hij hj
    by_cases he : j=i
    · subst j
      refine ⟨z,bound,?_⟩
      intro b
      exact (earlier_bytes dst (i+1) middle after rest width i (by omega) b).trans (store.2.2.2.2.2.1 b)
    · exact ih j (by omega) hj

theorem material (dst : ArrayPointer) (before after : Memory) (source : Writes dst 0 before after)
    (width : dst.elementBytes=2) : ∃ v : Geometry.Vec,
    KeygenMaterial.Represents after dst v ∧ KeygenIntegerLift.Bound v 2047 := by
  classical
  have hw : ∀ j : Fin 1536, ∃ z : Int, KeygenSmallOutput.accepted z ∧
      KeygenSmallOutput.Stored after (KeygenSmallOutput.element dst j.val) (BitVec.ofInt 16 z) :=
    fun j => write_values dst 0 before after source width j.val (Nat.zero_le _) j.isLt
  choose z hz using hw
  let v : Geometry.Vec := fun i => (z ⟨i.val,by have := i.isLt; omega⟩,
    z ⟨i.val+768,by have := i.isLt; omega⟩)
  refine ⟨v,?_,?_⟩
  · intro i
    exact ⟨(hz ⟨i.val,by have := i.isLt; omega⟩).2,(hz ⟨i.val+768,by have := i.isLt; omega⟩).2⟩
  · intro i
    exact ⟨abs_le.mpr (KeygenSmallOutput.accepted_bounds _ (hz ⟨i.val,by have := i.isLt; omega⟩).1),
      abs_le.mpr (KeygenSmallOutput.accepted_bounds _ (hz ⟨i.val+768,by have := i.isLt; omega⟩).1)⟩

theorem loop_result (s : State) (out : Result) (dst : ArrayPointer) (source : Exec loop s out)
    (i : Nat) (hi : i≤1536) (counter : C99CountedWords.Counter s i)
    (size : C99CountedWords.Limit s) (binding : s.arrays "d".toList=some dst) :
    (out.flow=.normal ∧ Writes dst i s.heap out.state.heap) ∨ out.flow=KeygenSmallStep.abortFlow := by
  generalize shape : loop=statement at source
  induction source generalizing i with
  | modular | plain | store16 | seqNormal | seqExit | scope | branchTrue | branchFalse => cases shape
  | loopFalse condition body increment before v guard zero =>
    cases shape
    exact Or.inl ⟨rfl,.done i _ (C99CountedWords.guard_false before i v hi counter size guard zero)⟩
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    cases shape
    have inside := C99CountedWords.guard_true before i v hi counter size guard nonzero
    rcases KeygenSmallStep.iteration_cases before dst i ⟨middle,.normal⟩ hi counter binding iteration with
      ⟨normal,equal,z,bound,write⟩ | aborted
    · have hl : middle.locals=before.locals := by have h := congrArg State.locals equal; exact h
      have ha : middle.arrays=before.arrays := by have h := congrArg State.arrays equal; exact h
      have hc : C99CountedWords.Counter middle i := by simpa [C99CountedWords.Counter,hl] using counter
      have hs : C99CountedWords.Limit middle := by simpa [C99CountedWords.Limit,hl] using size
      cases update with
      | modular _ _ _ update =>
        have he := congrArg Result.state (KeygenCheckLoopBridge.increment_result middle i ⟨next,.normal⟩ hi hc update)
        change next=SmallintsCounter.advanced middle i at he
        subst next
        have tail := ih3 (i+1) (by omega) (SmallintsCounter.advanced_counter middle i)
          (SmallintsCounter.advanced_limit middle i hs) ((congrFun ha _).trans binding) rfl
        rcases tail with ⟨normal,trace⟩ | aborted
        · exact Or.inl ⟨normal,.next i _ _ _ z inside bound write trace⟩
        · exact Or.inr aborted
    · cases congrArg Result.flow aborted
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
    cases shape
    rcases KeygenSmallStep.iteration_cases before dst i ⟨after,.returned (some value)⟩ hi counter binding iteration with
      ⟨normal,_⟩ | aborted
    · cases normal
    · exact Or.inr (congrArg Result.flow aborted)

def Profile (s : State) : Prop := KeygenNttForwardExec.lognAt s ∧
  s.locals "ter".toList=some (.uint32,some (.uint32 1))
def declared (s : State) : State := C99DeclarationStatements.effect .u64 ["n".toList,"u".toList] s
def sized (s : State) : State := bindValue (declared s) "n".toList .uint64 (.uint64 1536)

theorem mkn_value (s : State) (v : Value) (profile : Profile s)
    (source : C99ArrayReference.scalar s (C99ArrayParser.mkn (var "logn") (var "ter")) v) : v.integer=1536 := by
  change C99ScalarReference.Eval _ _ (.shift .left
    (.cast .uint64 (.arithmetic .plus (.literal .int32 1)
      (.shift .left (.variable "ter".toList) (.literal .int32 1))))
    (.arithmetic .minus (.variable "logn".toList) (.variable "ter".toList))) v at source
  obtain ⟨a,b,ha,hb,hop⟩ := KeygenNttForwardExec.eval_shift s.locals .left _ _ v source
  obtain ⟨l,t,hl,ht,hsub⟩ := KeygenNttForwardExec.eval_arith s.locals .minus _ _ b hb
  have hl0 := C99CountedWords.variable_exact s "logn".toList .uint32 (.uint32 10) l profile.1 hl
  have ht0 := C99CountedWords.variable_exact s "ter".toList .uint32 (.uint32 1) t profile.2 ht
  subst l t
  have hb0 : b=.uint32 9 := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp hsub).2
  subst b
  obtain ⟨sum,hsum,hcast⟩ := KeygenNttForwardExec.eval_cast s.locals .uint64 _ a ha
  obtain ⟨one,two,h1,h2,hadd⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ sum hsum
  cases h1
  obtain ⟨t,k,ht,hk,hshift⟩ := KeygenNttForwardExec.eval_shift s.locals .left _ _ two h2
  have ht0 := C99CountedWords.variable_exact s "ter".toList .uint32 (.uint32 1) t profile.2 ht
  subst t
  cases hk
  obtain ⟨n,hn,hb,he⟩ := KeygenNttForwardExec.shift_left_value _ _ two hshift
  have hn0 : n=1 := by change (1:Int)=(n:Int) at hn; omega
  subst n
  have he0 : two=.uint32 2 := he
  subst two
  have hsum0 : sum=.uint32 3 := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp hadd).2
  subst sum
  have ha0 : a=.uint64 3 := hcast
  subst a
  obtain ⟨n,hn,hb,he⟩ := KeygenNttForwardExec.shift_left_value _ _ v hop
  have hn0 : n=9 := by change (9:Int)=(n:Int) at hn; omega
  subst n
  rw [he]
  decide

theorem prologue_result (s : State) (out : Result) (source : Exec prologue s out) :
    out=⟨declared s,.normal⟩ := by
  cases source with
  | modular _ _ _ source =>
    obtain ⟨mid,body,equal⟩ := KeygenNttForwardExec.base_inv _ s out source
    rw [equal,C99DeclarationStatements.source_result .u64 ["n".toList,"u".toList] s mid body]
    rfl

theorem size_result (s : State) (out : Result) (profile : Profile s)
    (source : Exec sizeAssign (declared s) out) : out=⟨sized s,.normal⟩ := by
  cases source with
  | modular _ _ _ source =>
    obtain ⟨ty,old,v,slot,ev,equal⟩ := KeygenNttForwardExec.assign_inv (declared s) "n".toList _ out source
    have hn : (declared s).locals "n".toList=some (.uint64,none) := rfl
    have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (slot.symm.trans hn))
    subst ty
    have hp : Profile (declared s) := by
      simpa [Profile,KeygenNttForwardExec.lognAt,declared,C99DeclarationStatements.effect,
        C99DeclarationCells.declareCells,C99ScalarReference.set] using profile
    have hv := mkn_value (declared s) v hp (KeygenNttForwardExec.eval_scalar _ _ _ ev)
    rw [equal]
    simp only [bindValue,hv,sized]
    rfl

theorem continuation (first second : Stmt) (before middle : State) (out : Result)
    (unique : ∀ r, Exec first before r → r=⟨middle,.normal⟩)
    (source : Exec (.seq first second) before out) : Exec second middle out := by
  cases source with
  | seqNormal _ _ _ actual _ head tail =>
    have he := congrArg Result.state (unique ⟨actual,.normal⟩ head)
    change actual=middle at he
    subst actual
    exact tail
  | seqExit _ _ _ _ head exit => exact (exit (congrArg Result.flow (unique out head))).elim

theorem initialized (s : State) (out : Result) (profile : Profile s) (source : Exec code s out) :
    Exec (.seq (.seq counter loop) (chain [ret 1])) (sized s) out := by
  have tail := continuation prologue _ s (declared s) out (prologue_result s) source
  exact continuation sizeAssign _ (declared s) (sized s) out (fun r h => size_result s r profile h) tail

theorem source_writes (s : State) (out : Result) (dst : ArrayPointer) (profile : Profile s)
    (binding : s.arrays "d".toList=some dst) (source : Exec code s out)
    (success : out.flow=.returned (some (.int32 1))) : Writes dst 0 s.heap out.state.heap := by
  have body := initialized s out profile source
  have unique : ∀ r, Exec counter (sized s) r → r=⟨KeygenCheckLoopBridge.ready (sized s),.normal⟩ := by
    intro r h
    cases h with
    | modular _ _ _ h => exact KeygenCheckLoopBridge.initial_result (sized s) none r rfl h
  have hs : C99CountedWords.Limit (KeygenCheckLoopBridge.ready (sized s)) := rfl
  have hd : (KeygenCheckLoopBridge.ready (sized s)).arrays "d".toList=some dst := binding
  cases body with
  | seqNormal _ _ _ middle _ head tail =>
    have loopExec := continuation counter loop (sized s) _ ⟨middle,.normal⟩ unique head
    rcases loop_result _ ⟨middle,.normal⟩ dst loopExec 0 (by decide)
      (KeygenCheckLoopBridge.ready_counter _) hs hd with ⟨_,writes⟩ | aborted
    · have hout : out=⟨middle,.returned (some (.int32 1))⟩ := by
        cases tail with
        | seqNormal _ _ _ last _ head _ => cases congrArg Result.flow (KeygenSmallStep.ret_result 1 middle ⟨last,.normal⟩ head)
        | seqExit _ _ _ _ head _ => exact KeygenSmallStep.ret_result 1 middle out head
      rw [hout]
      exact writes
    · cases aborted
  | seqExit _ _ _ _ head exit =>
    have loopExec := continuation counter loop (sized s) _ out unique head
    rcases loop_result _ out dst loopExec 0 (by decide) (KeygenCheckLoopBridge.ready_counter _) hs hd with
      ⟨normal,_⟩ | aborted
    · exact (exit normal).elim
    · rw [success] at aborted
      cases aborted

theorem source_material (s : State) (out : Result) (dst : ArrayPointer) (profile : Profile s)
    (binding : s.arrays "d".toList=some dst) (width : dst.elementBytes=2)
    (source : Exec code s out) (success : out.flow=.returned (some (.int32 1))) :
    ∃ v : Geometry.Vec, KeygenMaterial.Represents out.state.heap dst v ∧ KeygenIntegerLift.Bound v 2047 :=
  material dst s.heap out.state.heap (source_writes s out dst profile binding source success) width

end FT1536.Source3.KeygenSmallBounds
