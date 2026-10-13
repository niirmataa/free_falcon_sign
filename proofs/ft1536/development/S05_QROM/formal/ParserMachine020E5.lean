import ParserDecision020E5

namespace FT1536.S05.ParserMachine020E5
open WordRAM020 ArrayArena020E4

structure State (cap n : Nat) where
  arena : Arena cap
  cursor : Fin (n+1)
  bad : Bool

def start (cap n : Nat) : State cap n := ⟨empty cap,0,false⟩

def decision {cap n : Nat} (c : SyntaxCells020E.Cell) (q : State cap n) :=
  if q.bad then none else ParserDecision020E5.cell q.arena c

def cursorNext {n : Nat} (j : Fin (n+1)) : Fin (n+1) := ⟨min n (j.val+1),by omega⟩

def step {cap n : Nat} (c : SyntaxCells020E.Cell) (q : State cap n) : State cap n :=
  match decision c q with
  | none => {q with cursor:=cursorNext q.cursor,bad:=true}
  | some d => ⟨ParserDecision020E5.apply q.arena d,cursorNext q.cursor,false⟩

def result {cap n : Nat} (q : State cap n) : Option (Arena cap) := if q.bad then none else some q.arena

/-- Semantic schedule of reads from immutable code. The driver uses cursor;
    the list of visited cells is proof data, not an allocated runtime log. -/
def run {cap n : Nat} : List SyntaxCells020E.Cell → State cap n → State cap n
  | [],q => q
  | c::cs,q => run cs (step c q)

theorem step_result {cap n : Nat} (c : SyntaxCells020E.Cell) (q : State cap n) :
    result (step c q)=(result q).bind (stepCell c) := by
  unfold step decision result
  cases hb : q.bad
  · simp only [Bool.false_eq_true,ite_false]
    have h := ParserDecision020E5.cell_refines q.arena c
    cases hd : ParserDecision020E5.cell q.arena c <;> simp_all
  · simp only [ite_true,Option.bind_none]

theorem run_result {cap n : Nat} (cs : List SyntaxCells020E.Cell) (q : State cap n) :
    result (run cs q)=(result q).bind (parse cs) := by
  induction cs generalizing q with
  | nil => cases hb : q.bad <;> simp [run,result,hb,parse]
  | cons c cs ih =>
    rw [run,ih,step_result,Option.bind_assoc]
    rfl

theorem start_result {cap n : Nat} (cs : List SyntaxCells020E.Cell) :
    result (run cs (start cap n))=parse cs (empty cap) := run_result cs (start cap n)

theorem step_cursor {cap n : Nat} (c : SyntaxCells020E.Cell) (q : State cap n) :
    (step c q).cursor=cursorNext q.cursor := by
  unfold step
  cases decision c q <;> rfl

theorem run_cursor {cap n : Nat} (cs : List SyntaxCells020E.Cell) (q : State cap n) :
    (run cs q).cursor.val=min n (q.cursor.val+cs.length) := by
  induction cs generalizing q with
  | nil => simp only [run,List.length_nil,Nat.add_zero];have := q.cursor.isLt;omega
  | cons c cs ih =>
    rw [run,ih,step_cursor]
    simp only [cursorNext,List.length_cons]
    omega

end FT1536.S05.ParserMachine020E5
