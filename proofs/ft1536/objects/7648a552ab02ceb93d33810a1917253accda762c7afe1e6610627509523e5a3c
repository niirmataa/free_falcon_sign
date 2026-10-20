import Source3.C99HelperObjects
import Source3.C99PrimitiveExists

/- Source-fragment natural semantics. Indices are mathematical views of
   the actual size_t locals, not execution fuel. The selected domain uses
   representable, nonwrapping array sizes. Each iteration creates fresh
   by-value a,b,sum,product cells; witnesses below are their SSA values.
   They cease to exist at the iteration boundary and have no caller address.
   The source grammar checks these declarations and every use/definition.
   All caller reads/writes use explicit array descriptors and byte rules.
   No bounded evaluator, successful-run predicate or desired security
   conclusion occurs in these definitions. -/
namespace FT1536.Source3.C99HelperReference
open C99MemoryReference C99HelperObjects
abbrev Word := BitVec 64

structure State where
  heap : C99MemoryReference.Memory
  checks : List Word := []

def Positive (l : StableBinary.Layout) (s : State) (w z : Word) (out : State) : Prop :=
  C99CheckReference.Check s.heap (bad l) w z out.heap ∧ out.checks=w::s.checks
def Store (p : ArrayPointer) (s : State) (w : Word) (out : State) : Prop :=
  Store64 s.heap p w out.heap ∧ out.checks=s.checks
def Binary (name : B20.C.Name) (x y z : Word) : Prop :=
  C99Frontend.primitiveCall name [.uint64 x,.uint64 y] (.uint64 z)
def Unary (name : B20.C.Name) (x z : Word) : Prop :=
  (name="fpr_half".toList ∧ C99LeafCalls.Half x z) ∨
  (name="fpr_double".toList ∧ C99LeafCalls.Double x z)

inductive Pair (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (start u : Nat) :
    State → Word → Word → State → Prop where
  | step (s s1 out : State) (x a y b : Word)
      (readX : Load64 s.heap (values l (start+(u*2^code.first.shift+code.first.offset))) x)
      (checkX : Positive l s x a s1)
      (readY : Load64 s1.heap (values l (start+(u*2^code.second.shift+code.second.offset))) y)
      (checkY : Positive l s1 y b out) : Pair l code start u s a b out

inductive Gram (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (a b : Word) :
    State → Word → Word → State → Prop where
  | step (s s1 out : State) (rawSum sum rawProduct product : Word)
      (add : Binary code.sum.callee a b rawSum) (checkSum : Positive l s rawSum sum s1)
      (mul : Binary code.product.callee a b rawProduct) (checkProduct : Positive l s1 rawProduct product out) :
      Gram l code a b s sum product out

inductive HalfStore (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (u : Nat) (sum : Word) :
    State → State → Prop where
  | step (s mid out : State) (raw z : Word) (half : Unary code.firstStore.half sum raw)
      (check : Positive l s raw z mid) (write : Store (scratch l u) mid z out) : HalfStore l code u sum s out

inductive Suffix (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (u hn : Nat) (product sum : Word) :
    State → State → Prop where
  | step (s mid out : State) (twice raw z : Word) (double : Unary code.secondStore.double product twice)
      (divide : Binary code.secondStore.div twice sum raw)
      (check : Positive l s raw z mid) (write : Store (scratch l (u+hn)) mid z out) : Suffix l code u hn product sum s out

inductive Step (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (start u hn : Nat) :
    State → State → Prop where
  | step (s sp sg sh out : State) (a b sum product : Word)
      (pair : Pair l code start u s a b sp) (gram : Gram l code a b sp sum product sg)
      (halfStore : HalfStore l code u sum sg sh) (suffix : Suffix l code u hn product sum sh out) :
      Step l code start u hn s out

/- Finite natural derivation of the for-loop prefix. The index is u, which
   starts at zero and is incremented once after every completed body.
   The final false test is explicit in the function rule below. -/
inductive Loop (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (start hn : Nat) :
    Nat → State → State → Prop where
  | zero (s : State) : Loop l code start hn 0 s s
  | next (u : Nat) (s mid out : State) (guard : u<hn)
      (earlier : Loop l code start hn u s mid) (body : Step l code start u hn mid out) :
      Loop l code start hn (u+1) s out

def Copy (l : StableBinary.Layout) (start n : Nat) (s out : State) : Prop :=
  Memcpy s.heap (values l start) (scratch l 0) (8*n) out.heap ∧ out.checks=s.checks

inductive Exec (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) :
    Nat → Nat → State → State → Prop where
  | base (n start : Nat) (s mid out : State) (w z : Word) (guard : n=code.baseSize)
      (read : Load64 s.heap (values l start) w) (check : Positive l s w z mid)
      (write : Store (values l start) mid z out) : Exec l code n start s out
  | branch (n start : Nat) (s sl sc left out : State) (guard : n≠code.baseSize)
      (representable : n<2^64) (copySize : 8*n<2^64)
      (loop : Loop l code start (n/2) (n/2) s sl) (falseGuard : ¬n/2<n/2)
      (copy : Copy l start n sl sc)
      (leftCall : Exec l code (n/2) start sc left)
      (rightCall : Exec l code (n/2) (start+n/2) left out) : Exec l code n start s out

def PinnedExec (l : StableBinary.Layout) (n : Nat) (before after : C99MemoryReference.Memory)
    (checks : List Word) : Prop :=
  ∃ code, StableBinarySourceSyntax.source=some code ∧ Exec l code n 0 {heap := before} ⟨after,checks⟩

end FT1536.Source3.C99HelperReference
