import CostProgram020E4
import CostBoundary020E4
import CostPipeline020E4

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CostDriver020E4
open WordRAM020 CostRun020E4 CostFlow020E4 JointInterface019

-- Keep closed interpreters opaque to elaboration; proofs use their checked
-- value/budget lemmas. This local setting adds no axiom or suppressed warning.
attribute [local irreducible] CostProgram020E4.actual ArrayProgram020E4.actual
  CostInput020E4.inputs CostBoundary020E4.initial ArrayState020E4.initial


def finish (q : Run (Option ArrayState020E4.State)) : Run (Option (ArrayBank020E4.Bank Bool outputSize)) :=
  optBind q (fun t => CostRun020E4.map some (CostBoundary020E4.copy t.out))

theorem finish_value (q : Run (Option ArrayState020E4.State)) :
    (finish q).value.map ArrayBank020E4.read=q.value.map (fun t => ArrayBank020E4.read t.out) := by
  simp only [finish,optBind_value,CostRun020E4.map,CostBoundary020E4.copy_value]
  cases q.value <;> rfl

def call (i : ArrayState020E4.Input) (s : ArrayState020E4.State) := finish (CostProgram020E4.actual i s)

theorem call_value (i : ArrayState020E4.Input) (s : ArrayState020E4.State) :
    (call i s).value.map ArrayBank020E4.read=(ArrayProgram020E4.actual i s).map (fun t => ArrayBank020E4.read t.out) := by
  unfold call
  rw [finish_value,CostProgram020E4.value]

abbrev assemble := CostPipeline020E4.run call

theorem assemble_value (ri : Run ArrayState020E4.Input) (rs : Run ArrayState020E4.State)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (hi : ri.value=i) (hs : rs.value=s) :
    (assemble ri rs).value.map ArrayBank020E4.read=(ArrayProgram020E4.actual i s).map (fun t => ArrayBank020E4.read t.out) :=
  CostPipeline020E4.value call (fun i s => (ArrayProgram020E4.actual i s).map (fun t => ArrayBank020E4.read t.out))
    (Option.map ArrayBank020E4.read) call_value ri rs i s hi hs

/-- Full public call in the declared copying-RAM/ideal-coins model. -/
def run (k : CostInput020E4.Key) (coins : Bits tapeSize) :=
  assemble (CostInput020E4.inputs k coins) CostBoundary020E4.initial

def price : Nat := CostInput020E4.price+(CostBoundary020E4.initialPrice+(CostProgram020E4.price+1+CostBoundary020E4.copyPrice))

theorem bound (k : CostInput020E4.Key) (coins : Bits tapeSize) : Bounded (run k coins) price price := by
  apply bind_bound _ _ CostInput020E4.price CostInput020E4.price _ _ (CostInput020E4.bound k coins)
  intro i
  apply bind_bound _ _ CostBoundary020E4.initialPrice CostBoundary020E4.initialPrice _ _ CostBoundary020E4.initial_bound
  intro s
  exact optBind_bound _ _ _ _ _ _ (CostProgram020E4.bound i s) (fun t => CostBoundary020E4.copy_bound t.out)

theorem value (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    (run k coins).value.map ArrayBank020E4.read=ArrayDriver020E4.run (CostInput020E4.key k) coins :=
  assemble_value (CostInput020E4.inputs k coins) CostBoundary020E4.initial
    (ArrayState020E4.loadInput (InputLayout020.encode (CostInput020E4.key k) coins)) ArrayState020E4.initial
    (CostInput020E4.value k coins) CostBoundary020E4.initial_value

theorem every_tape (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    (run k coins).value.map ArrayBank020E4.read=some (MachineLaw020D.code (CostInput020E4.key k) WordRAM020.initial coins) :=
  (value k coins).trans (ArrayDriver020E4.run_eq _ _)

def code (k : CostInput020E4.Key) (coins : Bits tapeSize) : Bits outputSize :=
  PublicDriver020E.totalize (fun _ => false) ((run k coins).value.map ArrayBank020E4.read)

theorem code_eq (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    code k coins=MachineLaw020D.code (CostInput020E4.key k) WordRAM020.initial coins :=
  PublicDriver020E.totalize_eq _ _ _ (every_tape k coins)

noncomputable def law (k : CostInput020E4.Key) : Law (Bits outputSize) :=
  (Law.uniform : Law (Bits tapeSize)).map (code k)

theorem law_eq (k : CostInput020E4.Key) : law k=MachineLaw020D.law (CostInput020E4.key k) WordRAM020.initial := by
  unfold law MachineLaw020D.law
  apply congrArg (fun f => (Law.uniform : Law (Bits tapeSize)).map f)
  exact funext (code_eq k)

end FT1536.S05.CostDriver020E4
