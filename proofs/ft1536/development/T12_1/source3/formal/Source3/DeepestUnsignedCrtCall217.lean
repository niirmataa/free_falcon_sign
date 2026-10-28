import Source3.DeepestUnsignedCrtBody217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original deepest unsigned CRT call with explicit source-cell and memory domain. -/
namespace FT1536.Source3.DeepestUnsignedCrtCall217
open C99ArrayReference (State Name Bind Pointer bindPointer bindValue)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open C99NatWord141 (word)
open KeygenFullData127 (primes)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open ZintNormWalkFlat208 (Data)
open DeepestUnsignedCrtBody217 (words335)

def withTmp (s : State) (tmp : ArrayPointer) := bindPointer (CrtAddMulCall205.fresh s) "tmp".toList tmp
def withSign (s : State) (tmp : ArrayPointer) := bindValue (withTmp s tmp) "normalize_signed".toList .int32 (.int32 0)
def withPrimes (s : State) (tmp : ArrayPointer) := bindPointer (withSign s tmp) "primes".toList primes
def withNum (s : State) (tmp : ArrayPointer) := set64 (withPrimes s tmp) "num" (word 2)
def withStride (s : State) (tmp : ArrayPointer) := set64 (withNum s tmp) "xstride" (word 335)
def withLen (s : State) (tmp : ArrayPointer) := set64 (withStride s tmp) "xlen" (word 335)
def entry (s : State) (root tmp : ArrayPointer) := bindPointer (withLen s tmp) "xx".toList root

def args : List C99ArrayReference.Arg := [.pointer "fp".toList C99ProcedureParser.zero,
  .scalar (.var "len".toList),.scalar (.var "len".toList),.scalar (.literal .i32 2),
  .pointer "primes".toList C99ProcedureParser.zero,.scalar (.literal .i32 0),
  .pointer "t1".toList C99ProcedureParser.zero]

structure Domain (s : State) (root tmp : ArrayPointer) : Prop where
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  width : root.elementBytes=4
  capacity : root.index+670 ≤ root.count
  writable : s.heap.writable root.block=true
  tmpAllocated : Allocated s.heap tmp
  tmpWidth : tmp.elementBytes=4
  tmpCapacity : tmp.index+336 ≤ tmp.count
  tmpWritable : s.heap.writable tmp.block=true
  apart : ∀ i j, i < 670 → j ≤ 335 → Separate (elem root i) (elem tmp j)

theorem input (s : State) (root tmp : ArrayPointer) (domain : Domain s root tmp) :
    DeepestUnsignedCrtBody217.CrtInput (entry s root tmp) root tmp := by
  exact ⟨rfl,rfl,rfl,rfl,rfl,rfl,rfl,domain.object,domain.width,domain.capacity,domain.writable,
    domain.tmpAllocated,domain.tmpWidth,domain.tmpCapacity,domain.tmpWritable,domain.apart⟩

theorem binding (s : State) (root tmp : ArrayPointer)
    (sourceBinding : s.arrays "fp".toList=some root) (tmpBinding : s.arrays "t1".toList=some tmp)
    (primesBinding : s.arrays "primes".toList=some primes) (len : Cell s "len".toList 335)
    (rootCap : root.index+0 ≤ root.count) (tmpCap : tmp.index+0 ≤ tmp.count) :
    Bind s (KeygenZintCall.params .rebuildCrt) args (entry s root tmp) := by
  have source := RootBinding175.zero s "fp" root sourceBinding rootCap
  have table := RootBinding175.zero s "primes" primes primesBinding (by decide)
  have scratch := RootBinding175.zero s "t1" tmp tmpBinding tmpCap
  refine .pointer _ _ _ _ _ _ _ source ?_
  refine .scalar .uint64 "xlen".toList _ _ _ _ (.uint64 (word 335)) (.variable _ _ _ len) ?_
  refine .scalar .uint64 "xstride".toList _ _ _ _ (.uint64 (word 335)) (.variable _ _ _ len) ?_
  refine .scalar .uint64 "num".toList _ _ _ _ (.int32 2) (.literal .int32 2) ?_
  refine .pointer _ _ _ _ _ _ _ table ?_
  refine .scalar .int32 "normalize_signed".toList _ _ _ _ (.int32 0) (.literal .int32 0) ?_
  exact .pointer _ _ _ _ _ _ _ scratch .nil

theorem source (s : State) (root tmp : ArrayPointer) (W : Nat → BitVec 32)
    (sourceBinding : s.arrays "fp".toList=some root) (tmpBinding : s.arrays "t1".toList=some tmp)
    (primesBinding : s.arrays "primes".toList=some primes) (len : Cell s "len".toList 335)
    (domain : Domain s root tmp) (data : Data s root 670 W) :
    ∃ out, KeygenZintCall.Exec (.call .rebuildCrt args .discard) s ⟨out,.normal⟩ ∧
      Data out root 670 (words335 W) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧ out.tables=s.tables ∧
      (∀ q old, (∀ i, i < 670 → Separate (elem root i) q) → (∀ j, j < 335 → Separate (elem tmp j) q) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨out,run,image,keep⟩:=DeepestUnsignedCrtBody217.source (entry s root tmp) root tmp W (input s root tmp domain) data
  refine ⟨{s with heap:=out.heap},?_,image,rfl,rfl,rfl,keep⟩
  exact KeygenZintCall.Exec.call s .rebuildCrt args .discard (entry s root tmp) ⟨out,.normal⟩ none _
    (binding s root tmp sourceBinding tmpBinding primesBinding len
      (by have h:=domain.capacity; omega) (by have h:=domain.tmpCapacity; omega)) run .voidEnd (.discard _ _)

end FT1536.Source3.DeepestUnsignedCrtCall217
