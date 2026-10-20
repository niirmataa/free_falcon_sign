import Source3.StableTopEffects

namespace FT1536.Source3.StableTopExec
open StableTopSyntax StableTopMemory
abbrev Word := BitVec 64
structure State where
  memory : StableBinaryCExec.State
  locals : StableTopExpr.Env

def initialLocals (three : Word) : StableTopExpr.Env := fun n => if n="three".toList then some three else none
def put (s : State) (n : B20.C.Name) (w : Word) : State := {s with locals := StableTopExpr.put s.locals n w}

def step (l : Layout) (u v : Nat) (s : State) : Stmt → Option State
  | .readCheck name delta => do
      let raw ← StableBinaryCExec.load s.memory (StableBinary.addr l.roots (u+delta))
      let (w,memory) ← StableBinaryCExec.positive (branch l 0) s.memory raw
      pure (put {s with memory} name w)
  | .letCheck name expr => do
      let raw ← StableTopExpr.eval s.locals expr
      let (w,memory) ← StableBinaryCExec.positive (branch l 0) s.memory raw
      pure (put {s with memory} name w)
  | .storeCheck offset expr => do
      let raw ← StableTopExpr.eval s.locals expr
      let (w,memory) ← StableBinaryCExec.positive (branch l 0) s.memory raw
      let memory ← StableBinaryCExec.store memory (StableBinary.addr l.leaves (offset+v)) w
      pure {s with memory}

def body (l : Layout) (u v : Nat) : List Stmt → State → Option State
  | [],s => some s
  | stmt::rest,s => do body l u v rest (← step l u v s stmt)

def loop (l : Layout) (code : Code) (three : Word) : Nat → StableBinaryCExec.State → Option StableBinaryCExec.State
  | 0,s => some s
  | i+1,s => do
      let mid ← loop l code three i s
      let u := code.loop.initialU+code.loop.stepU*i
      let v := code.loop.initialV+code.loop.stepV*i
      if ¬u<code.loop.bound then none else do
      let out ← body l u v code.body ⟨mid,initialLocals three⟩
      pure out.memory

def binaryLayout (l : Layout) (offset size : Nat) : StableBinary.Layout :=
  ⟨StableBinary.addr l.leaves offset,l.scratch,l.bad,size⟩
def binary (l : Layout) (b : Branch) (s : StableBinaryCExec.State) : Option StableBinaryCExec.State := do
  if b.size != 256 then none else do
  let out ← StableBinaryCExec.run (binaryLayout l b.offset b.size) 8 s.heap
  pure {out with checks := out.checks++s.checks}
def branches (l : Layout) : List Branch → StableBinaryCExec.State → Option StableBinaryCExec.State
  | [],s => some s
  | b::rest,s => do branches l rest (← binary l b s)

def run (l : Layout) (heap : B20.C.Byte.Memory) : Option StableBinaryCExec.State := do
  let code ← StableTopSyntax.source
  if code.initializer != .call1 "fpr_of".toList (.literal .i32 3) then none else do
  let value ← CLogic.execute FprOfThree.modelCalls FprScaledAST.ofCode [.i32 3]
  match value with
  | .u64 three => do
      let out ← loop l code three 256 ⟨heap,[]⟩
      if code.loop.initialU+code.loop.stepU*256<code.loop.bound then none
      else branches l code.branches out
  | _ => none

end FT1536.Source3.StableTopExec
