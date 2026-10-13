import ProducerCompiler020E6

namespace FT1536.S05.ProducerEmit020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6 ProducerExpr020E6

def NoOutput {regions codeSize : Nat} (i : Instruction regions codeSize) : Prop :=
  match i with | .output _ _ => False | _ => True

theorem primitive_output {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (i : Instruction regions codeSize) (hi : NoOutput i) (q : State codeSize) : (execute sources i q).output=q.output := by
  cases i with
  | literal d w => rfl
  | copy d s => rfl
  | binary d o a b => rfl
  | load d r a => unfold execute;dsimp only;cases WordRAM020.address (extent r) (read q.regs a) <;> rfl
  | output d s => exact False.elim hi
  | select d c z n => rfl

theorem list_output {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : List (Instruction regions codeSize)) (h : ∀ i∈code,NoOutput i) (q : State codeSize) :
    (executeList sources code q).output=q.output := by
  induction code generalizing q with
  | nil => rfl
  | cons i is ih => exact (ih (by intro j hj;exact h j (List.mem_cons_of_mem _ hj)) _).trans (primitive_output sources i (h i List.mem_cons_self) q)

theorem compile_no_output {regions codeSize : Nat} (e : Expr regions) (base : Nat) (h : base+need e≤64) :
    ∀ i∈compile (codeSize:=codeSize) e base h,NoOutput i := by
  induction e generalizing base with
  | literal w => simp [compile,NoOutput]
  | load r a ih =>
    simp only [compile,List.mem_append,List.mem_cons,List.not_mem_nil,or_false]
    intro i hi
    rcases hi with hi|hi
    · exact ih base h i hi
    · subst i;exact True.intro
  | binary o a b ha hb =>
    simp only [compile,List.mem_append,List.mem_cons,List.not_mem_nil,or_false]
    intro i hi
    rcases hi with (hi|hi)|hi
    · exact ha base _ i hi
    · exact hb (base+1) _ i hi
    · subst i;exact True.intro
  | select c z n hc hz hn =>
    simp only [compile,List.mem_append,List.mem_cons,List.not_mem_nil,or_false]
    intro i hi
    rcases hi with ((hi|hi)|hi)|hi
    · exact hc base _ i hi
    · exact hz (base+1) _ i hi
    · exact hn (base+2) _ i hi
    · subst i;exact True.intro

def one {regions codeSize : Nat} (dst : OutputCell) (e : Expr regions) (h : need e≤64) : List (Instruction regions codeSize) :=
  compile e 0 (by omega) ++ [.output dst 0]

theorem one_output {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (dst : OutputCell) (e : Expr regions) (h : need e≤64) (q : State codeSize) :
    (executeList sources (one dst e h) q).output=write q.output dst (eval sources e) := by
  unfold one
  rw [append]
  change write (executeList sources (compile e 0 _) q).output dst
    (read (executeList sources (compile e 0 _) q).regs (0 : Register))=_
  rw [list_output sources _ (compile_no_output e 0 _)]
  exact congrArg (write q.output dst) (ProducerCompiler020E6.correct sources e 0 (by omega) q)

/-- Expression syntax and compilation are public preparation, not per-call
    allocations. The installed program overwrites one output slot at a time. -/
def batch {regions codeSize : Nat} (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64)
    (slots : List OutputCell) : List (Instruction regions codeSize) := slots.flatMap (fun j => one j (f j) (h j))

def fills {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent) (f : OutputCell → Expr regions) :
    List OutputCell → Bank Word 96 → Bank Word 96
  | [],b => b
  | j::js,b => fills sources f js (write b j (eval sources (f j)))

theorem batch_output {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) (slots : List OutputCell) (q : State codeSize) :
    (executeList sources (batch f h slots) q).output=fills sources f slots q.output := by
  induction slots generalizing q with
  | nil => rfl
  | cons j js ih =>
    change (executeList sources (one j (f j) (h j) ++ batch f h js) q).output=_
    rw [append,ih,one_output]
    rfl

end FT1536.S05.ProducerEmit020E6
