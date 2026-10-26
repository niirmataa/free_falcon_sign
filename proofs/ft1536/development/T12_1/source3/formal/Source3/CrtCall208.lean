import Source3.CrtBody208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtCall208
open C99ArrayReference (State Name Bind Pointer bindPointer bindValue)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open C99NatWord141 (word)
open KeygenFullData127 (primes)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open ZintNormWalkFlat208 (Data)
open KeygenZintCall (Exec)

structure Domain (s : State) (root tmp : ArrayPointer) : Prop where
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  width : root.elementBytes=4
  capacity : root.index+512 ≤ root.count
  writable : s.heap.writable root.block=true
  tmpAllocated : Allocated s.heap tmp
  tmpWidth : tmp.elementBytes=4
  tmpCapacity : tmp.index+2 ≤ tmp.count
  tmpWritable : s.heap.writable tmp.block=true
  apart : ∀ i j, i < 512 → j < 2 → Separate (elem root i) (elem tmp j)

def withTmp (s : State) (tmp : ArrayPointer) := bindPointer (CrtAddMulCall205.fresh s) "tmp".toList tmp
 def withSign (s : State) (tmp : ArrayPointer) := bindValue (withTmp s tmp) "normalize_signed".toList .int32 (.int32 1)
 def withPrimes (s : State) (tmp : ArrayPointer) := bindPointer (withSign s tmp) "primes".toList primes
 def withNum (s : State) (tmp : ArrayPointer) := set64 (withPrimes s tmp) "num" (word 256)
 def withStride (s : State) (tmp : ArrayPointer) := set64 (withNum s tmp) "xstride" (word 2)
 def withLen (s : State) (tmp : ArrayPointer) := set64 (withStride s tmp) "xlen" (word 2)
 def entry (s : State) (root tmp : ArrayPointer) := bindPointer (withLen s tmp) "xx".toList root

theorem input (s : State) (root tmp : ArrayPointer) (domain : Domain s root tmp) : CrtEntry208.Input (entry s root tmp) root tmp := by
  refine ⟨rfl,rfl,rfl,rfl,rfl,rfl,rfl,domain.object,domain.width,domain.capacity,domain.writable,
    domain.tmpAllocated,domain.tmpWidth,domain.tmpCapacity,domain.tmpWritable,domain.apart⟩

theorem binding (src : String) (s : State) (root tmp : ArrayPointer)
    (sourceBinding : s.arrays src.toList=some root) (tmpBinding : s.arrays "gm".toList=some tmp)
    (primesBinding : s.arrays "primes".toList=some primes)
    (slen : Cell s "slen".toList 2) (num : Cell s "n".toList 256)
    (rootCap : root.index+0 ≤ root.count) (tmpCap : tmp.index+0 ≤ tmp.count) :
    Bind s (KeygenZintCall.params .rebuildCrt) (MakeFgCrtShape194.crtArgs src) (entry s root tmp) := by
  have zero:=C99ScalarReference.Eval.literal (calls:=FprPrefixCalls.calls) (env:=s.locals) .uint64 0
  have first : Pointer s src.toList C99ProcedureParser.zero root :=
    .add _ _ root root (.uint64 0) sourceBinding zero (by decide) (.within root 0 rootCap)
  have table : Pointer s "primes".toList C99ProcedureParser.zero primes :=
    .add _ _ primes primes (.uint64 0) primesBinding zero (by decide) (.within primes 0 (by decide))
  have scratch : Pointer s "gm".toList C99ProcedureParser.zero tmp :=
    .add _ _ tmp tmp (.uint64 0) tmpBinding zero (by decide) (.within tmp 0 tmpCap)
  refine .pointer _ _ _ _ _ _ _ first ?_
  refine .scalar .uint64 "xlen".toList (.var "slen".toList) _ _ _ (.uint64 (word 2)) (.variable _ _ _ slen) ?_
  refine .scalar .uint64 "xstride".toList (.var "slen".toList) _ _ _ (.uint64 (word 2)) (.variable _ _ _ slen) ?_
  refine .scalar .uint64 "num".toList (.var "n".toList) _ _ _ (.uint64 (word 256)) (.variable _ _ _ num) ?_
  refine .pointer _ _ _ _ _ _ _ table ?_
  refine .scalar .int32 "normalize_signed".toList (.literal .i32 1) _ _ _ (.int32 1) (.literal .int32 1) ?_
  exact .pointer _ _ _ _ _ _ _ scratch .nil

theorem source (src : String) (s : State) (root tmp : ArrayPointer) (W : Nat → BitVec 32)
    (sourceBinding : s.arrays src.toList=some root) (tmpBinding : s.arrays "gm".toList=some tmp)
    (primesBinding : s.arrays "primes".toList=some primes)
    (slen : Cell s "slen".toList 2) (num : Cell s "n".toList 256)
    (domain : Domain s root tmp) (data : Data s root 512 W) :
    ∃ out, Exec (.call .rebuildCrt (MakeFgCrtShape194.crtArgs src) .discard) s ⟨out,.normal⟩ ∧
      Data out root 512 (CrtBody208.words W) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, (∀ i, i < 512 → Separate (elem root i) q) → Separate tmp q →
        Separate (ZintAddMulWord205.next tmp) q → Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨out,run,image,_,_,_,_,_,_,keep⟩:=CrtBody208.source (entry s root tmp) root tmp W (input s root tmp domain) data
  refine ⟨{s with heap:=out.heap},?_,image,rfl,rfl,keep⟩
  exact .call s .rebuildCrt (MakeFgCrtShape194.crtArgs src) .discard (entry s root tmp) ⟨out,.normal⟩ none _
    (binding src s root tmp sourceBinding tmpBinding primesBinding slen num
      (by have h:=domain.capacity; omega) (by have h:=domain.tmpCapacity; omega)) run .voidEnd (.discard _ _)

end FT1536.Source3.CrtCall208
