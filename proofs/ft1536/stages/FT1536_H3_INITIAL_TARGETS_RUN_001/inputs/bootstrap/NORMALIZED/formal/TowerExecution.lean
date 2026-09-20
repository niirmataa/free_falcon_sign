import TowerMargin
namespace Tower
structure Ops (Entry Word : Type) where
  first : Entry → Option Entry
  ldl : Entry → Option (List Word × Entry)
  second : Entry → Option Entry
  leaf0 : Entry → Word
  leaf1 : Entry → Word
-- Immutable snapshots; the separate source frame proof justifies preservation
-- of the parent's snapshot while the first recursive child writes its buffers.
def execute {Entry Word : Type} (o : Ops Entry Word) : Nat → Entry → Option (List Word)
  | 0,e => do
    let z←o.ldl e
    pure (z.1++[o.leaf0 e,o.leaf1 z.2])
  | d+1,e => do
    let a←o.first e
    let left←execute o d a
    let z←o.ldl e
    let b←o.second z.2
    let right←execute o d b
    pure (z.1++left++right)
theorem successful_execution {Entry Word : Type} (o : Ops Entry Word) (Good : Nat → Entry → Prop)
    (base : ∀e,Good 0 e → ∃z,o.ldl e=some z)
    (step : ∀d e,Good (d+1) e → ∃a z b,
      o.first e=some a ∧ Good d a ∧ o.ldl e=some z ∧ o.second z.2=some b ∧ Good d b) :
    ∀d e,Good d e → ∃out,execute o d e=some out := by
  intro d
  induction d with
  | zero =>
    intro e he
    obtain ⟨z,hz⟩:=base e he
    exact ⟨z.1++[o.leaf0 e,o.leaf1 z.2],by simp [execute,hz]⟩
  | succ d ih =>
    intro e he
    obtain ⟨a,z,b,ha,hga,hz,hb,hgb⟩:=step d e he
    obtain ⟨left,hl⟩:=ih a hga
    obtain ⟨right,hr⟩:=ih b hgb
    exact ⟨z.1++left++right,by simp [execute,ha,hl,hz,hb,hr]⟩
end Tower
