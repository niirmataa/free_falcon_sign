import Source3.PublicNormalSource157
import Source3.PublicArgumentSource157
import Source3.KeygenPublicRev
import Source3.C99BodySound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRevSource157
open C99ArrayReference (State)
open C99ModularReference (Stmt GenExec)
open KeygenPublicRev (state initial prologue round condition reversed nextY noCalls types)

def reference (s : B20.C.Scalar.State) : State := {KeygenPublicScalar.empty with locals := C99Typing.environment s}
def roundBody : Stmt := .scope [] (KeygenPublicLinear.body round)
def increment : Stmt := .base (.scalar (.update "i".toList .add (.literal .i32 1)))
def loop : Stmt := .loop condition roundBody increment
def initialization : Stmt := .assign "i".toList (.scalar (.literal .i32 0))
def tail : Stmt := .seq (.ret (.scalar (.var "y".toList))) (.base .skip)

theorem shape : KeygenPublicScalar.code .rev=
    PublicNormalSource157.prepend (prologue.take 3) (.seq (.seq initialization loop) tail) := by decide +kernel

theorem calls_sound : C99ExpressionSound.CallsSound FprPrefixCalls.calls noCalls := by
  intro _ _ _ impossible
  cases impossible

theorem round_source (x y : BitVec 32) (i : Nat) :
    GenExec (fun _ _ _ => False) roundBody (reference (state x y i))
      ⟨reference (state (x >>> 1) (nextY x y) i),.normal⟩ := by
  have scalar := (C99BodySound.normal_sound C99HeaderProof.noSignature FprPrefixCalls.calls noCalls calls_sound round
    (state x y i) (state (x >>> 1) (nextY x y) i) types (KeygenPublicRev.state_good x y i)
    KeygenPublicRev.round_checked (KeygenPublicRev.round_model x y i)).1
  have source := PublicNormalSource157.body (fun _ _ _ => False) round (reference (state x y i))
    (C99Typing.environment (state (x >>> 1) (nextY x y) i)) scalar
  exact .scope _ _ _ _ source

theorem increment_source (x y : BitVec 32) (i : Nat) (range : i ≤ 10) :
    GenExec (fun _ _ _ => False) increment (reference (state x y i)) ⟨reference (state x y (i+1)),.normal⟩ := by
  have model : CLogic.step noCalls (state x y i) (.update "i".toList .add (.literal .i32 1))=some (state x y (i+1)) :=
    KeygenPublicRev.increment_model x y i range
  have source := (C99StateSound.step_sound C99HeaderProof.noSignature FprPrefixCalls.calls noCalls calls_sound
    (state x y i) (state x y (i+1)) (.update "i".toList .add (.literal .i32 1)) types
    (KeygenPublicRev.state_good x y i) (by rfl) model).1
  exact .base _ _ _ (.scalar _ _ _ source)

theorem guard (x y : BitVec 32) (i : Nat) (range : i ≤ 10) :
    C99ArrayReference.scalar (reference (state x y i)) condition (C99ScalarReference.boolean (decide (i<10))) := by
  have evaluated : ExpressionFuel.unbounded noCalls (state x y i).values condition=some (CLogic.boolean (decide (i<10))) := by
    rw [← ExpressionFuel.fuel_adequate _ _ _ _ (by decide : ExpressionFuel.depth condition ≤ 32)]
    exact KeygenPublicRev.condition_model x y i range
  exact C99ExpressionSound.expression_sound FprPrefixCalls.calls noCalls calls_sound (state x y i)
    (KeygenPublicRev.state_good x y i) condition _ evaluated

theorem loop_source (remaining i : Nat) (endIndex : i+remaining=10) (x y : BitVec 32) :
    ∃ lastX, GenExec (fun _ _ _ => False) loop (reference (state x y i))
      ⟨reference (state lastX (reversed remaining x y) 10),.normal⟩ := by
  induction remaining generalizing i x y with
  | zero =>
    have same : i=10 := by omega
    subst i
    have test : C99ArrayReference.scalar (reference (state x y 10)) condition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using guard x y 10 (by omega)
    exact ⟨x,.loopFalse _ _ _ _ (.int32 0) test (by decide)⟩
  | succ remaining ih =>
    have inside : i<10 := by omega
    obtain ⟨lastX,rest⟩ := ih (i+1) (by omega) (x >>> 1) (nextY x y)
    have test : C99ArrayReference.scalar (reference (state x y i)) condition (.int32 1) := by
      simpa [inside,C99ScalarReference.boolean] using guard x y i (by omega)
    exact ⟨lastX,.loopNormal _ _ _ _ _ _ _ (.int32 1) test (by decide) (round_source x y i)
      (increment_source (x >>> 1) (nextY x y) i (by omega)) rest⟩

theorem converted (x : BitVec 32) : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 x).integer=.uint32 x :=
  C99CountedWords.convert_self (.uint32 x)

theorem bound_entry (x : BitVec 32) : reference (initial x)=
    C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params .rev) [.uint32 x] := by
  unfold reference KeygenPublicScalar.params C99ModularReference.bindParams C99ArrayReference.bindValue
  simp only [C99ModularReference.bindParams,converted]
  congr 1
  funext n
  by_cases same : n=['x'] <;>
    simp [C99Typing.environment,KeygenPublicRev.initial,C99ScalarReference.set,KeygenPublicScalar.empty,
      C99ValueBridge.type,C99ValueBridge.value,same]

theorem body (x : BitVec 32) : KeygenPublicScalar.Body (fun _ _ _ => False) .rev [.uint32 x]
    (.uint32 (reversed 10 x 0)) := by
  obtain ⟨lastX,sourceLoop⟩ := loop_source 10 0 rfl x 0
  have returnSource : GenExec (fun _ _ _ => False) tail (reference (state lastX (reversed 10 x 0) 10))
      ⟨reference (state lastX (reversed 10 x 0) 10),.returned (some (.uint32 (reversed 10 x 0)))⟩ :=
    .seqExit _ _ _ _ (.ret _ _ _ (.scalar _ _ (.variable "y".toList .uint32 (.uint32 (reversed 10 x 0)) rfl)))
      (by intro impossible; cases impossible)
  have scalar := (C99BodySound.normal_sound C99HeaderProof.noSignature FprPrefixCalls.calls noCalls calls_sound prologue
    (initial x) (state x 0 0) types (KeygenPublicRev.initial_good x) (KeygenPublicRev.prologue_checked x)
    (KeygenPublicRev.prologue_model x)).1
  have all := PublicNormalSource157.source (fun _ _ _ => False) prologue (reference (initial x))
    (C99Typing.environment (state x 0 0)) scalar (.seq loop tail) _ (.seqNormal _ _ _ _ _ sourceLoop returnSource)
  change GenExec (fun _ _ _ => False)
    (PublicNormalSource157.prepend (prologue.take 3) (.seq initialization (.seq loop tail))) _ _ at all
  have grouped := PublicNormalSource157.regroup_after _ (prologue.take 3) initialization loop tail _ _ all
  rw [← shape,bound_entry] at grouped
  refine ⟨rfl,_,grouped,?_⟩
  simpa only [converted] using
    (C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (reversed 10 x 0)))

theorem source (x : B20.C.Val) : KeygenPublicScalar.Call "rev10".toList [C99ValueBridge.value x]
    (.uint32 (reversed 10 (PublicArgumentSource157.word x) 0)) :=
  .square _ _ _ (.leaf _ _ _ (.run .rev _ _ (by unfold KeygenPublicScalar.IsLeaf; decide)
    (KeygenPublicArguments.body_conversion _ .rev _ _ _ (PublicArgumentSource157.cons_unsigned _ x _ _ _ .nil)
      (body (PublicArgumentSource157.word x)))))

end FT1536.Source3.PublicRevSource157
