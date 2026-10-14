import Source3.KeygenPointerReadBoundary106

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecAgreement107
open C99MemoryReference
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenCodecAtoms106 (Clean)

/-- The synthetic comp activation slot is not a parameter of either
    private leaf. All real pointer/scalar cells remain compared. -/
def Agree (a b : Locals) : Prop := a.x = b.x ∧
  ∀ name, name ≠ "comp".toList → a.scalars name = b.scalars name

theorem cell (a b : Locals) (same : Agree a b) (name : Name) (different : name ≠ "comp".toList) :
    a.scalars name = b.scalars name := same.2 name different

theorem clean (a b : Locals) (same : Agree a b) (source : Clean a) : Clean b := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact (same.2 "out".toList (by decide)).symm.trans source.1
  · exact (same.2 "NULL".toList (by decide)).symm.trans source.2.1
  · exact (same.2 "x".toList (by decide)).symm.trans source.2.2.1
  · exact (same.2 "buf".toList (by decide)).symm.trans source.2.2.2

theorem set (a b : Locals) (name : Name) (ty : C99IntegerReference.Ty)
    (value : Option C99IntegerReference.Value) (same : Agree a b) :
    Agree (localSet a name ty value) (localSet b name ty value) := by
  refine ⟨same.1, ?_⟩
  intro key different
  simp only [localSet, C99ScalarReference.set]
  split
  · rfl
  · exact same.2 key different

theorem pointer (a b : Locals) (p : Option ArrayPointer) (same : Agree a b) :
    Agree {a with x := p} {b with x := p} := ⟨rfl, same.2⟩

theorem update (name : Name) (delta : Int) (a b c d : Locals) (x y u v : Value)
    (different : name ≠ "comp".toList) (start : Clean a) (same : Agree a b)
    (first : Update name delta a x y c) (second : Update name delta b u v d) : Agree c d ∧ x = u ∧ y = v := by
  have other := clean a b same start
  have cells := cell a b same name different
  have inputs := same.1
  cases first <;> cases second
  all_goals simp only [Clean] at start other
  all_goals grind only [C99IntegerReference.arithmetic_deterministic, C99HeapDeterminism089.pointer_add,
    KeygenCodecAgreement107.set, pointer]

def noComp : Expr → Bool
  | .variable name => decide (name ≠ "comp".toList)
  | .number _ _ | .argsNil => true
  | .preInc e | .postInc e | .preDec e | .postDec e | .unary _ e | .cast _ e | .member e _ | .call _ e => noComp e
  | .binary _ a b | .index a b | .argsCons a b => noComp a && noComp b
  | .conditional e a b => noComp e && noComp a && noComp b

end FT1536.Source3.KeygenCodecAgreement107
