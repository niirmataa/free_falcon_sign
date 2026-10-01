import Source3.KeygenCheckProgram
import Source3.C99CountedWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCheckExpression
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ModularReference (Eval)
open KeygenFinalCheck (Arrays Step)

structure Inputs (arrays : Arrays) (p0i target : BitVec 32) (s : State) : Prop where
  f : s.arrays "ft".toList=some arrays.f
  g : s.arrays "gt".toList=some arrays.g
  bigF : s.arrays "Ft".toList=some arrays.bigF
  bigG : s.arrays "Gt".toList=some arrays.bigG
  prime : s.locals "p".toList=some (.uint32,some (.uint32 KeygenNinv31.prime))
  inverse : s.locals "p0i".toList=some (.uint32,some (.uint32 p0i))
  target : s.locals "r".toList=some (.uint32,some (.uint32 target))
  size : C99CountedWords.Limit s

theorem cell_value (s : State) (name : String) (expected : BitVec 32) (value : Value)
    (binding : s.locals name.toList=some (.uint32,some (.uint32 expected)))
    (source : Eval s (KeygenCheckProgram.cell name) value) : value=.uint32 expected := by
  cases source with
  | scalar _ _ source => exact C99CountedWords.variable_exact s name.toList .uint32 (.uint32 expected) value binding source

theorem load_value (s : State) (name : String) (ptr : ArrayPointer) (i : Nat) (value : Value)
    (hi : i≤1536) (counter : C99CountedWords.Counter s i) (binding : s.arrays name.toList=some ptr)
    (source : Eval s (KeygenCheckProgram.load name) value) :
    ∃ word : BitVec 32, value=.uint32 word ∧ Load32 s.heap (KeygenSmallOutput.element ptr i) word := by
  cases source with
  | load32 name index p word address read =>
      have he := C99CountedWords.pointer_exact s name.toList ptr p i hi counter binding address
      rw [he] at read
      exact ⟨word,rfl,read⟩

theorem product_value (s : State) (leftName rightName : String) (leftPtr rightPtr : ArrayPointer)
    (p0i : BitVec 32) (i : Nat) (value : Value) (hi : i≤1536)
    (counter : C99CountedWords.Counter s i)
    (leftBinding : s.arrays leftName.toList=some leftPtr) (rightBinding : s.arrays rightName.toList=some rightPtr)
    (prime : s.locals "p".toList=some (.uint32,some (.uint32 KeygenNinv31.prime)))
    (inverse : s.locals "p0i".toList=some (.uint32,some (.uint32 p0i)))
    (source : Eval s (KeygenCheckProgram.product leftName rightName) value) :
    ∃ a b out : BitVec 32, value=.uint32 out ∧
      Load32 s.heap (KeygenSmallOutput.element leftPtr i) a ∧
      Load32 s.heap (KeygenSmallOutput.element rightPtr i) b ∧
      KeygenModpWord.SourceExec a b KeygenNinv31.prime p0i (.uint32 out) := by
  cases source with
  | call4 name a b c d x y p pinv out first second third fourth call =>
      obtain ⟨a,ha,ra⟩ := load_value s leftName leftPtr i x hi counter leftBinding first
      obtain ⟨b,hb,rb⟩ := load_value s rightName rightPtr i y hi counter rightBinding second
      have hp := cell_value s "p" KeygenNinv31.prime p prime third
      have hi0 := cell_value s "p0i" p0i pinv inverse fourth
      subst x
      subst y
      subst p
      subst pinv
      cases call with
      | montgomery args value body =>
          have hv := KeygenModpWord.source_exact a b KeygenNinv31.prime p0i value body
          refine ⟨a,b,KeygenModpWord.montgomery a b KeygenNinv31.prime p0i,hv,ra,rb,?_⟩
          rw [hv] at body
          exact body

theorem source_step (arrays : Arrays) (s : State) (p0i target : BitVec 32) (i : Nat) (value : Value)
    (hi : i≤1536) (counter : C99CountedWords.Counter s i) (inputs : Inputs arrays p0i target s)
    (source : Eval s KeygenCheckProgram.expression value) :
    ∃ out : BitVec 32, value=.uint32 out ∧ Step arrays s.heap p0i i out := by
  cases source with
  | call3 name a b c x y p out first second third call =>
      obtain ⟨a,bigG,left,hl,ra,rG,cl⟩ := product_value s "ft" "Gt" arrays.f arrays.bigG p0i i x
        hi counter inputs.f inputs.bigG inputs.prime inputs.inverse first
      obtain ⟨b,bigF,right,hr,rb,rF,cr⟩ := product_value s "gt" "Ft" arrays.g arrays.bigF p0i i y
        hi counter inputs.g inputs.bigF inputs.prime inputs.inverse second
      have hp := cell_value s "p" KeygenNinv31.prime p inputs.prime third
      subst x
      subst y
      subst p
      cases call with
      | sub args value body =>
          have hv := KeygenModpAddSub.source_exact .sub left right KeygenNinv31.prime value body
          rw [hv] at body
          exact ⟨_,hv,.evaluated a b bigF bigG left right _ ra rb rF rG cl cr body⟩

end FT1536.Source3.KeygenCheckExpression
