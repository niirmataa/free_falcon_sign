import Source3.KeygenLexPrefix098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexCompose098
open B20.C (Token)
open KeygenZintCall (tokenize)

def Prefix (chars : List Char) (tokens : List Token) (steps : Nat) : Prop :=
  ∀ fuel tail, tokenize [] (fuel + steps) (chars ++ tail) =
    (tokenize [] fuel tail).map (fun rest => tokens ++ rest)

theorem prefix_append (a b : List Char) (u v : List Token) (ka kb : Nat)
    (first : Prefix a u ka) (second : Prefix b v kb) : Prefix (a ++ b) (u ++ v) (ka + kb) := by
  intro fuel tail
  have arithmetic : fuel + (ka + kb) = (fuel + kb) + ka := by omega
  rw [arithmetic, List.append_assoc, first, second]
  cases tokenize [] fuel tail with
  | none => rfl
  | some out => simp only [Option.map_some, List.append_assoc]

structure Chunk where
  lines : List String
  raw : List Token
  steps : Nat
  equation : Prefix (lines.flatMap String.toList) raw steps
  bound : steps ≤ (lines.flatMap String.toList).length

def empty : Chunk where
  lines := []
  raw := []
  steps := 0
  equation := by
    intro fuel tail
    simp only [List.flatMap_nil, Nat.add_zero, List.nil_append]
    cases tokenize [] fuel tail <;> rfl
  bound := Nat.le_refl 0

def append (a b : Chunk) : Chunk where
  lines := a.lines ++ b.lines
  raw := a.raw ++ b.raw
  steps := a.steps + b.steps
  equation := by
    simpa only [List.flatMap_append] using prefix_append _ _ _ _ _ _ a.equation b.equation
  bound := by
    simpa only [List.flatMap_append, List.length_append] using Nat.add_le_add a.bound b.bound

theorem terminal (fuel : Nat) : tokenize [] (fuel + 2) ['}'] = some [['}']] := by
  rw [KeygenTokenizerStep098.step]
  change (tokenize [] (fuel + 1) []).map (List.cons ['}']) = some [['}']]
  rw [KeygenTokenizerStep098.step]
  rfl

theorem finish (chars : List Char) (tokens : List Token) (steps : Nat)
    (equation : Prefix chars tokens steps) (bound : steps ≤ chars.length) :
    tokenize [] (chars.length + 2) (chars ++ ['}']) = some (tokens ++ [['}']]) := by
  let remaining := chars.length - steps + 2
  have arithmetic : chars.length + 2 = remaining + steps := by dsimp [remaining]; omega
  rw [arithmetic, equation]
  change (tokenize [] ((chars.length - steps) + 2) ['}']).map (fun rest => tokens ++ rest) = _
  rw [terminal]
  rfl

end FT1536.Source3.KeygenLexCompose098
