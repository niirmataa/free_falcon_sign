import Source3.KeygenCheckGate
import Source3.C99DeclarationStatements

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCheckIteration
open C99ArrayReference (State bindValue restoreScope)
open C99ModularReference (Exec)
open C99ProcedureReference (Result)
open KeygenFinalCheck (Arrays Step)
open KeygenCheckExpression (Inputs)

def declared (before : State) : State :=
  {before with locals := C99ScalarReference.set before.locals "z".toList (.uint32,none)}
def assigned (before : State) (word : BitVec 32) : State := bindValue (declared before) "z".toList .uint32 (.uint32 word)

theorem declared_inputs (arrays : Arrays) (p0i target : BitVec 32) (before : State)
    (h : Inputs arrays p0i target before) : Inputs arrays p0i target (declared before) := by
  refine ⟨h.f,h.g,h.bigF,h.bigG,?_,?_,?_,?_⟩
  · simpa [declared,C99ScalarReference.set] using h.prime
  · simpa [declared,C99ScalarReference.set] using h.inverse
  · simpa [declared,C99ScalarReference.set] using h.target
  · simpa [C99CountedWords.Limit,declared,C99ScalarReference.set] using h.size

theorem declared_counter (before : State) (i : Nat) (counter : C99CountedWords.Counter before i) :
    C99CountedWords.Counter (declared before) i := by
  simpa [C99CountedWords.Counter,declared,C99ScalarReference.set] using counter

theorem restored (before : State) (word : BitVec 32) : restoreScope before (assigned before word) ["z".toList] []=before := by
  have locals : C99ScalarReference.restore before.locals (assigned before word).locals ["z".toList]=before.locals := by
    funext name
    by_cases h : name=['z']
    all_goals simp [C99ScalarReference.restore,C99ScalarReference.set,assigned,declared,bindValue,h]
  change {before with locals := C99ScalarReference.restore before.locals (assigned before word).locals ["z".toList]}=before
  rw [locals]

theorem assignment_result (arrays : Arrays) (before : State) (p0i target : BitVec 32) (i : Nat) (result : Result)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays p0i target before)
    (source : Exec (.assign "z".toList KeygenCheckProgram.expression) (declared before) result) :
    ∃ out : BitVec 32, result=⟨assigned before out,.normal⟩ ∧ Step arrays before.heap p0i i out := by
  cases source with
  | assign _ _ _ ty old v binding value =>
      have z : (declared before).locals "z".toList=some (.uint32,none) := by simp [declared,C99ScalarReference.set]
      have ht : ty=.uint32 := congrArg Prod.fst (Option.some.inj (binding.symm.trans z))
      subst ty
      obtain ⟨out,hv,step⟩ := KeygenCheckExpression.source_step arrays (declared before) p0i target i v hi
        (declared_counter before i counter) (declared_inputs arrays p0i target before inputs) value
      subst v
      exact ⟨out,rfl,step⟩

theorem assigned_z (before : State) (word : BitVec 32) :
    (assigned before word).locals "z".toList=some (.uint32,some (.uint32 word)) := by
  change C99ScalarReference.set (declared before).locals "z".toList
    (.uint32,some (C99IntegerReference.convert (C99IntegerReference.Value.uint32 word).type
      (C99IntegerReference.Value.uint32 word).integer)) "z".toList=_
  rw [C99CountedWords.convert_self]
  simp [C99ScalarReference.set]

theorem assigned_target (before : State) (word target : BitVec 32)
    (r : before.locals "r".toList=some (.uint32,some (.uint32 target))) :
    (assigned before word).locals "r".toList=some (.uint32,some (.uint32 target)) := by
  simpa [assigned,declared,bindValue,C99ScalarReference.set] using r

theorem assigned_tail (arrays : Arrays) (before : State) (p0i target : BitVec 32) (i : Nat) (result : Result)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays p0i target before)
    (source : Exec (.seq (.assign "z".toList KeygenCheckProgram.expression)
      (.seq KeygenCheckProgram.gate KeygenCheckProgram.skip)) (declared before) result) :
    ∃ out : BitVec 32, result=⟨assigned before out,KeygenCheckGate.verdict out target⟩ ∧
      Step arrays before.heap p0i i out := by
  cases source with
  | seqNormal _ _ _ middle _ head tail =>
      obtain ⟨out,hm,step⟩ := assignment_result arrays before p0i target i ⟨middle,.normal⟩ hi counter inputs head
      have he := congrArg Result.state hm
      change middle=assigned before out at he
      subst middle
      exact ⟨out,KeygenCheckGate.gate_then_skip _ out target result (assigned_z before out)
        (assigned_target before out target inputs.target) tail,step⟩
  | seqExit _ _ _ _ head exit =>
      obtain ⟨out,hm,_⟩ := assignment_result arrays before p0i target i result hi counter inputs head
      exact False.elim (exit (congrArg Result.flow hm))

theorem source_result (arrays : Arrays) (before : State) (p0i target : BitVec 32) (i : Nat) (result : Result)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays p0i target before)
    (source : Exec KeygenCheckProgram.iteration before result) :
    ∃ out : BitVec 32, result=⟨before,KeygenCheckGate.verdict out target⟩ ∧ Step arrays before.heap p0i i out := by
  cases source with
  | scope _ _ _ inner body =>
      obtain ⟨entry,hd,tail⟩ := C99ModularReference.base_before_tail KeygenCheckProgram.declaration _ before inner body
      have he := C99DeclarationStatements.source_result .u32 ["z".toList] before entry hd
      change entry=declared before at he
      subst entry
      obtain ⟨out,hinner,step⟩ := assigned_tail arrays before p0i target i inner hi counter inputs tail
      refine ⟨out,?_,step⟩
      rw [hinner]
      change (⟨restoreScope before (assigned before out) ["z".toList] [],KeygenCheckGate.verdict out target⟩ : Result)=_
      rw [restored]

theorem accepted (arrays : Arrays) (before after : State) (p0i target : BitVec 32) (i : Nat)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays p0i target before)
    (source : Exec KeygenCheckProgram.iteration before ⟨after,.normal⟩) :
    after=before ∧ Step arrays before.heap p0i i target := by
  obtain ⟨out,he,step⟩ := source_result arrays before p0i target i ⟨after,.normal⟩ hi counter inputs source
  have equal : out=target := by
    by_contra different
    have hf := congrArg Result.flow he
    simp [KeygenCheckGate.verdict,different,KeygenCheckGate.abortFlow] at hf
  subst out
  exact ⟨congrArg Result.state he,step⟩

end FT1536.Source3.KeygenCheckIteration
