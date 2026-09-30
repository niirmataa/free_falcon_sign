import Source3.StableBinarySourceSyntax
import Source3.StableBinaryByteView
import Source3.FprCErasure

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryCExec
open FT1536.Source3
open FT1536.Source3.StableBinarySourceSyntax
open FT1536.Source3.StableBinaryByteView
open B20.C

abbrev Heap := B20.C.Byte.Memory
abbrev Word := BitVec 64
abbrev Flag := BitVec 32

structure State where
  heap : Heap
  checks : List Word := []

def load (s : State) (a : Nat) : Option Word := wordRead s.heap a
def store (s : State) (a : Nat) (w : Word) : Option State := do
  let h ← wordWrite s.heap a w
  pure {s with heap := h}

/- This is the pinned *side-effecting* positive helper applied to the
   uint32_t bad object. Its typed RMW result is written back as four bytes. -/
def positive (l : StableBinary.Layout) (s : State) (w : Word) : Option (Word × State) := do
  let flag ← flagRead s.heap l.bad
  let flags : CRefWord.Heap := fun a => if a=l.bad then some flag else none
  let (result, flags') ← (CRefWord.parse (KeygenHelpers.slice 7477 12)).bind
    (fun f => CRefWord.execute StablePositive.pureCalls StablePositive.globals
      f flags [.word (.u64 w),.ref32 l.bad])
  let newFlag ← flags' l.bad
  let heap ← flagWrite s.heap l.bad newFlag
  match result with
  | .u64 z => pure (z,{heap,checks := w::s.checks})
  | _ => none

def binary (name : B20.C.Name) (s : State) (x y : Word) : Option (Word × State) := do
  let program ← if name="fpr_add".toList then some FprPrimitives.addProgram
    else if name="fpr_mul".toList then some FprPrimitives.mulProgram
    else if name="fpr_div".toList then some FprPrimitives.divProgram
    else none
  let (w,h) ← FprCFrame.sourceCall program x y s.heap
  pure (w,{s with heap := h})

def unary (name : B20.C.Name) (s : State) (x : Word) : Option (Word × State) := do
  let program ← if name="fpr_half".toList then
      CLogicParser.parseFunction
        (List.flatMap String.toList ((Pinned.fprLines.drop 164).take 10))
    else if name="fpr_double".toList then
      CLogicParser.parseFunction
        (List.flatMap String.toList ((Pinned.fprLines.drop 175).take 6))
    else none
  match ← CLogic.execute (fun _ _ => none) program [.u64 x] with
  | .u64 z => some (z,s)
  | _ => none

def sourcePair (l : StableBinary.Layout) (code : Code) (v u : Nat)
    (s : State) : Option ((Word × Word) × State) := do
  let x ← load s (StableBinary.addr v (u*2^code.first.shift+code.first.offset))
  let (a,s) ← positive l s x
  let y ← load s (StableBinary.addr v (u*2^code.second.shift+code.second.offset))
  let (b,s) ← positive l s y
  pure ((a,b),s)

def sourceGram (l : StableBinary.Layout) (code : Code) (a b : Word)
    (s : State) : Option ((Word × Word) × State) := do
  let (sum,s) ← (do
    let (r,s) ← binary code.sum.callee s a b
    positive l s r)
  let (product,s) ← (do
    let (r,s) ← binary code.product.callee s a b
    positive l s r)
  pure ((sum,product),s)

def sourceHalfStore (l : StableBinary.Layout) (code : Code) (u : Nat)
    (sum : Word) (s : State) : Option State := do
  let (r,s) ← unary code.firstStore.half s sum
  let (out,s) ← positive l s r
  store s (StableBinary.addr l.scratch u) out

def sourcePrefix (l : StableBinary.Layout) (code : Code) (v u : Nat)
    (s : State) : Option ((Word × Word) × State) := do
  let ((a,b),s) ← sourcePair l code v u s
  let ((sum,product),s) ← sourceGram l code a b s
  let s ← sourceHalfStore l code u sum s
  pure ((product,sum),s)

def sourceSuffix (l : StableBinary.Layout) (code : Code) (u hn : Nat)
    (product sum : Word) (s : State) : Option State := do
  let (r,s) ← unary code.secondStore.double s product
  let (r,s) ← binary code.secondStore.div s r sum
  let (out,s) ← positive l s r
  store s (StableBinary.addr l.scratch (u+hn)) out

def sourceStep (l : StableBinary.Layout) (code : Code) (v u hn : Nat)
    (s : State) : Option State := do
  let ((product,sum),s) ← sourcePrefix l code v u s
  sourceSuffix l code u hn product sum s

def sourceLoop (l : StableBinary.Layout) (code : Code) (v hn : Nat) :
    Nat → State → Option State
  | 0,s => some s
  | u+1,s => do
      let s ← sourceLoop l code v hn u s
      sourceStep l code v u hn s

def readCopy (scratch : Nat) : Nat → State → Option (List Word)
  | 0,_ => some []
  | i+1,s => do
      let xs ← readCopy scratch i s
      let w ← load s (StableBinary.addr scratch i)
      pure (xs++[w])

def writeCopy (base : Nat) : Nat → List Word → State → Option State
  | _,[],s => some s
  | i,w::rest,s => do
      let s ← store s (StableBinary.addr base i) w
      writeCopy base (i+1) rest s

def copy (s : State) (values scratch n : Nat) : Option State := do
  let words ← readCopy scratch n s
  writeCopy values 0 words s

def execute (l : StableBinary.Layout) (code : Code) :
    Nat → Nat → State → Option State
  | 0,v,s => do
      if code.baseSize != 1 then none else do
      let x ← load s v
      let (y,s) ← positive l s x
      store s v y
  | k+1,v,s => do
      let hn := 2^k
      let s ← sourceLoop l code v hn hn s
      let s ← copy s v l.scratch (2*hn)
      let s ← execute l code k v s
      execute l code k (v+8*hn) s

def run (l : StableBinary.Layout) (k : Nat) (heap : Heap) : Option State := do
  if ¬l.wellFormed k then none else do
    let code ← StableBinarySourceSyntax.source
    execute l code k l.values {heap}

end FT1536.Source3.StableBinaryCExec

#check @FT1536.Source3.StableBinaryCExec.run
