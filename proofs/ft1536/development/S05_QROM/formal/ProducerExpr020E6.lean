import ProducerMachine020E6

namespace FT1536.S05.ProducerExpr020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6

/-- Closed scalar language: no arbitrary host function, callback, array
    constructor, recursive evaluator call, or hidden code-producing leaf. -/
inductive Expr (regions : Nat) where
  | literal (value : Word)
  | load (region : Fin regions) (address : Expr regions)
  | binary (op : Op) (lhs rhs : Expr regions)
  | select (condition zero nonzero : Expr regions)

def readWord {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent) (region : Fin regions) (w : Word) : Word :=
  match WordRAM020.address (extent region) w with | none => 0 | some j => read (sources region) j

def eval {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent) : Expr regions → Word
  | .literal w => w
  | .load r a => readWord sources r (eval sources a)
  | .binary o a b => WordRAM020.op o (eval sources a) (eval sources b)
  | .select c z n => if eval sources c=0 then eval sources z else eval sources n

/-- Scalar subexpressions are compiled offline. All three select operands
    can be evaluated: invalid speculative reads return zero and only set the
    producer's diagnostic flag; the selected value has the stated semantics. -/
def need {regions : Nat} : Expr regions → Nat
  | .literal _ => 1
  | .load _ a => need a
  | .binary _ a b => max (need a) (need b+1)
  | .select c z n => max (need c) (max (need z+1) (need n+2))

theorem positive {regions : Nat} (e : Expr regions) : 0<need e := by
  induction e with
  | literal w => exact Nat.zero_lt_succ _
  | load r a ih => exact ih
  | binary o a b ha hb => unfold need;omega
  | select c z n hc hz hn => unfold need;omega

def compile {regions codeSize : Nat} : (e : Expr regions) → (base : Nat) → base+need e≤64 → List (Instruction regions codeSize)
  | .literal w,base,h => [.literal ⟨base,by have := positive (.literal w : Expr regions);omega⟩ w]
  | .load r a,base,h => compile a base h ++ [.load ⟨base,by have := positive a;simp only [need] at h;omega⟩ r ⟨base,by have := positive a;simp only [need] at h;omega⟩]
  | .binary o a b,base,h => compile a base (by simp only [need] at h;omega) ++
      compile b (base+1) (by simp only [need] at h;omega) ++
      [.binary ⟨base,by have := positive a;simp only [need] at h;omega⟩ o
        ⟨base,by have := positive a;simp only [need] at h;omega⟩
        ⟨base+1,by have := positive b;simp only [need] at h;omega⟩]
  | .select c z n,base,h => compile c base (by simp only [need] at h;omega) ++
      compile z (base+1) (by simp only [need] at h;omega) ++
      compile n (base+2) (by simp only [need] at h;omega) ++
      [.select ⟨base,by have := positive c;simp only [need] at h;omega⟩
        ⟨base,by have := positive c;simp only [need] at h;omega⟩
        ⟨base+1,by have := positive z;simp only [need] at h;omega⟩
        ⟨base+2,by have := positive n;simp only [need] at h;omega⟩]

def executeList {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent) :
    List (Instruction regions codeSize) → State codeSize → State codeSize
  | [],q => q
  | i::is,q => executeList sources is (ProducerMachine020E6.execute sources i q)

theorem append {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (xs ys : List (Instruction regions codeSize)) (q : State codeSize) :
    executeList sources (xs++ys) q=executeList sources ys (executeList sources xs q) := by
  induction xs generalizing q with
  | nil => rfl
  | cons i is ih => exact ih _

end FT1536.S05.ProducerExpr020E6
