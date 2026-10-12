import EmitStep020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.EmitTag020D
open WordRAM020 PairProgram020 ReadSemantics020A ScalarExpr020D
attribute [local irreducible] exec loopState

def ops : List Code := [.atom (.emit (r 28) (lit 1)),inc 28]
def code : Code := seqs ops
def position : Fin outputSize := ⟨24576,by decide⟩
def result (s : State) : State := put {s with out := Function.update s.out position true} 28 (word 24577)

theorem run_correct (i : Input) (s : State) (h28 : s.reg 28=word 24576) : exec i code s=result s := by
  let q : State := {s with out := Function.update s.out position true}
  have st : exec i (.atom (.emit (r 28) (lit 1))) s=q := by
    rw [EmitStep020D.exec_emit]
    change (match address outputSize (s.reg 28) with
      | none => fail s | some k => {s with out := Function.update s.out k (word 1 != 0)})=q
    have ha : address outputSize (word 24576)=some position :=
      address_exact outputSize 24576 (by decide) (by norm_num)
    rw [h28,ha]
    rfl
  have ei : eval q (add (r 28) (lit 1))=word 24577 :=
    inc_eval q 28 24576 (by decide) h28
  simp only [code,ops,exec_seqs_cons,exec_seqs_nil,st,inc,exec_set,ei]
  rfl

theorem tag_true (s : State) : (result s).out position=true := by
  change (Function.update s.out position true) position=true
  simp
theorem other (s : State) (j : Fin outputSize) (hj : j≠position) : (result s).out j=s.out j := by
  change (Function.update s.out position true) j=s.out j
  exact Function.update_of_ne hj _ _
theorem cursor (s : State) : (result s).reg 28=word 24577 := put_same _ _ _
theorem frame (s : State) : (result s).ram=s.ram ∧ (result s).fault=s.fault := ⟨rfl,rfl⟩

end FT1536.S05.EmitTag020D
