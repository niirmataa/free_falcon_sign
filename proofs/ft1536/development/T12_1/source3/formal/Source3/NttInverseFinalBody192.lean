import Source3.NttInverseCorrectionSource192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- State skeleton of one original degree-1 butterfly iteration of the
   accepted modp_iNTT3_ext final pass: the exact modp_add/modp_sub/
   modp_montymul words of the a0/a1/b/c block (bb/subA/mid/low/high), the
   intermediate declared/assigned states, the two written positions and
   the scope restoration facts. Values are only the executed operations;
   no root or transform property is assumed. The iteration and increment
   executions follow in the next module. -/
namespace FT1536.Source3.NttInverseFinalBody192
open C99ArrayReference (State Name Pointer bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open StepCopyBody190 (addr)
open NttInverseCorrectionLoop192 (walk)

def bb (a0 a1 p : BitVec 32) : BitVec 32 := KeygenModpAddSub.result .add a0 a1 p
def subA (a0 a1 p : BitVec 32) : BitVec 32 := KeygenModpAddSub.result .sub a0 a1 p
def mid (a0 a1 w p p0i : BitVec 32) : BitVec 32 := KeygenModpWord.montgomery w (subA a0 a1 p) p p0i
def low (a0 a1 w p p0i : BitVec 32) : BitVec 32 :=
  KeygenModpAddSub.result .sub (bb a0 a1 p) (mid a0 a1 w p p0i) p
def high (a0 a1 w p p0i : BitVec 32) : BitVec 32 :=
  KeygenModpAddSub.result .add (mid a0 a1 w p p0i) (mid a0 a1 w p p0i) p

def names : List Name := ["a0".toList,"a1".toList,"b".toList,"c".toList]

def declared (s : State) : State := C99DeclarationStatements.effect .u32 names s
def withA0 (s : State) (a0 : BitVec 32) : State := ModularAtoms178.set (declared s) "a0" a0
def withA1 (s : State) (a0 a1 : BitVec 32) : State := ModularAtoms178.set (withA0 s a0) "a1" a1
def withB (s : State) (a0 a1 p : BitVec 32) : State :=
  ModularAtoms178.set (withA1 s a0 a1) "b" (bb a0 a1 p)
def withC (s : State) (a0 a1 w p p0i : BitVec 32) : State :=
  ModularAtoms178.set (withB s a0 a1 p) "c" (mid a0 a1 w p p0i)
def firstHeap (s : State) (a : ArrayPointer) (stride i : Nat) (a0 a1 w p p0i : BitVec 32) :
    C99MemoryReference.Memory :=
  Word32Memory176.write (withC s a0 a1 w p p0i).heap (walk a i stride) (low a0 a1 w p p0i)
def first (s : State) (a : ArrayPointer) (stride i : Nat) (a0 a1 w p p0i : BitVec 32) : State :=
  {withC s a0 a1 w p p0i with heap := firstHeap s a stride i a0 a1 w p p0i}
def secondHeap (s : State) (a : ArrayPointer) (stride hn i : Nat) (a0 a1 w p p0i : BitVec 32) :
    C99MemoryReference.Memory :=
  Word32Memory176.write (firstHeap s a stride i a0 a1 w p p0i) (walk a (i+hn) stride)
    (high a0 a1 w p p0i)
def second (s : State) (a : ArrayPointer) (stride hn i : Nat) (a0 a1 w p p0i : BitVec 32) : State :=
  {first s a stride i a0 a1 w p p0i with heap := secondHeap s a stride hn i a0 a1 w p p0i}
def output (s : State) (a : ArrayPointer) (stride hn i : Nat) (a0 a1 w p p0i : BitVec 32) : State :=
  restoreScope s (second s a stride hn i a0 a1 w p p0i) names []

theorem cells_outside (ty : C99IntegerReference.Ty) : ∀ (list : List Name)
    (env : C99ScalarReference.Env) (name : Name), name∉list →
    C99DeclarationCells.declareCells ty list env name=env name :=
  StepProductBody191.cells_outside ty

theorem declared_outside (s : State) (name : Name) (absent : name∉names) :
    (declared s).locals name=s.locals name :=
  cells_outside .uint32 names s.locals name absent

theorem set_outside (s : State) (target : String) (other : Name) (w : BitVec 32)
    (different : other≠target.toList) :
    (ModularAtoms178.set s target w).locals other=s.locals other :=
  StepProductBody191.put32_outside s target.toList w other different

theorem block_outside (name : Name) (first : name≠"a0".toList) (second : name≠"a1".toList)
    (third : name≠"b".toList) (fourth : name≠"c".toList) : name∉names := by
  intro hit
  simp only [names,List.mem_cons,List.not_mem_nil,or_false] at hit
  cases hit with
  | inl left => exact first left
  | inr rest =>
    cases rest with
    | inl left => exact second left
    | inr tail =>
      cases tail with
      | inl left => exact third left
      | inr last => exact fourth last

theorem block_absent (name : Name) (first : name≠"a0".toList) (second : name≠"a1".toList)
    (third : name≠"b".toList) (fourth : name≠"c".toList) : ¬ names.contains name=true :=
  fun hit => block_outside name first second third fourth (List.contains_iff_mem.mp hit)

theorem after_locals (s : State) (a : ArrayPointer) (stride hn i : Nat) (a0 a1 w p p0i : BitVec 32) :
    (output s a stride hn i a0 a1 w p p0i).locals=s.locals := by
  funext name
  by_cases h0 : name="a0".toList
  · subst h0
    rfl
  · by_cases h1 : name="a1".toList
    · subst h1
      rfl
    · by_cases h2 : name="b".toList
      · subst h2
        rfl
      · by_cases h3 : name="c".toList
        · subst h3
          rfl
        · show C99ScalarReference.restore s.locals (second s a stride hn i a0 a1 w p p0i).locals
            names name=s.locals name
          have kept : ¬ names.contains name=true := block_absent name h0 h1 h2 h3
          simp only [C99ScalarReference.restore,kept]
          exact ((set_outside _ "c" name (mid a0 a1 w p p0i) h3).trans
            ((set_outside _ "b" name (bb a0 a1 p) h2).trans
              ((set_outside _ "a1" name a1 h1).trans
                ((set_outside _ "a0" name a0 h0).trans
                  (declared_outside s name (block_outside name h0 h1 h2 h3))))))

theorem after_arrays (s : State) (a : ArrayPointer) (stride hn i : Nat) (a0 a1 w p p0i : BitVec 32) :
    (output s a stride hn i a0 a1 w p p0i).arrays=s.arrays := by
  funext name
  rfl

theorem body_state (s : State) (a : ArrayPointer) (stride hn i : Nat) (a0 a1 w p p0i : BitVec 32) :
    output s a stride hn i a0 a1 w p p0i=
      {second s a stride hn i a0 a1 w p p0i with locals := s.locals, arrays := s.arrays} :=
  StepProductBody191.state_ext rfl (after_locals s a stride hn i a0 a1 w p p0i)
    (after_arrays s a stride hn i a0 a1 w p p0i) rfl rfl

end FT1536.Source3.NttInverseFinalBody192
