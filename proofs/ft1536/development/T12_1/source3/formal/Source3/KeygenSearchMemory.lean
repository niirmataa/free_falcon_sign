import Source3.KeygenSearchProbe
import Source3.C99PointerFootprint

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Byte-view casts and the complete align_fpr helper, for the search source.
   Pointer provenance and object extents survive casts. Alignment executes
   the actual k/km control, rather than choosing an arbitrary aligned output.
   The LP64 little-endian source profile remains explicit at the caller. -/
namespace FT1536.Source3.KeygenSearchMemory
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)

def view (p : ArrayPointer) (width : Nat) : ArrayPointer :=
  ⟨p.block,p.base,p.elementBytes*p.count/width,width,p.elementBytes*p.index/width⟩

def Cast (p : ArrayPointer) (width : Nat) (q : ArrayPointer) : Prop :=
  0<width ∧ p.base%width=0 ∧ (p.elementBytes*p.index)%width=0 ∧
  p.index≤p.count ∧ q=view p width

theorem cast_offset (p q : ArrayPointer) (width : Nat) (source : Cast p width q) :
    q.offset=p.offset := by
  obtain ⟨_,_,aligned,_,rfl⟩ := source
  dsimp [view,ArrayPointer.offset]
  rw [Nat.mul_div_cancel' (Nat.dvd_of_mod_eq_zero aligned)]

theorem cast_end (p q : ArrayPointer) (width : Nat) (source : Cast p width q) :
    q.base+q.elementBytes*q.count≤p.base+p.elementBytes*p.count := by
  obtain ⟨_,_,_,_,rfl⟩ := source
  dsimp [view]
  have h := Nat.div_mul_le_self (p.elementBytes*p.count) width
  rw [Nat.mul_comm (p.elementBytes*p.count/width) width] at h
  omega

theorem cast_outside (p q : ArrayPointer) (width block offset : Nat)
    (source : Cast p width q) (outside : C99PointerFootprint.PointOutside p block offset) :
    C99PointerFootprint.PointOutside q block offset := by
  have hp := cast_offset p q width source
  have he := cast_end p q width source
  have hb : q.block=p.block := by rw [source.2.2.2.2]; rfl
  dsimp [C99PointerFootprint.PointOutside] at *
  omega

def localNames : List B20.C.Name := ["k".toList,"km".toList]
def scalarEntry (before : State) (k km : BitVec 64) : State :=
  C99ArrayReference.bindValue (C99ArrayReference.bindValue
    {before with locals := fun _ => none} "k".toList .uint64 (.uint64 k))
    "km".toList .uint64 (.uint64 km)
def condition : CLogic.Expr := .var "km".toList
def update : C99ModularReference.Stmt := .base (.scalar (.update "k".toList .add
  (.bin .sub (.literal .u64 8) (.var "km".toList))))
def rounding : C99ModularReference.Stmt := .branch condition
  (.scope [] (C99ModularParser.chain [update])) (.base .skip)

theorem helper_source : KeygenSearchProbe.alignLines=KeygenSearchProbe.alignScaffold :=
  KeygenSearchProbe.alignment_source
theorem signature_source : (Pinned.keygenLines.drop 5315).take 3=
  ["static fpr *\n","align_fpr(void *base, void *data)\n","{\n"] := by decide

/- sizeof(fpr)=8 is the selected FPEMU ABI. The pointer-to-byte assignments
   preserve the source array, and subtraction is defined only in that array.
   Unsigned remainder is evaluated on the actual size_t word. -/
inductive Align (before : State) (base data : ArrayPointer) : ArrayPointer → Prop where
  | run (cb cd : ArrayPointer) (k km : BitVec 64) (rounded : C99ProcedureReference.Result)
      (offset : BitVec 64) (bytePointer result : ArrayPointer)
      (baseCast : Cast base 1 cb) (dataCast : Cast data 1 cd)
      (sameBlock : cd.block=cb.block) (sameBase : cd.base=cb.base)
      (sameCount : cd.count=cb.count) (ordered : cb.index≤cd.index)
      (difference : (k.toNat : Int)=(cd.index : Int)-(cb.index : Int))
      (ptrdiffRange : k.toNat<2^63)
      (remainder : km=BitVec.ofNat 64 (k.toNat%8))
      (control : C99ModularReference.Exec rounding (scalarEntry before k km) rounded)
      (normal : rounded.flow=.normal)
      (read : C99ArrayReference.scalar rounded.state (.var "k".toList) (.uint64 offset))
      (addition : PointerAdd cb offset.toNat bytePointer)
      (resultCast : Cast bytePointer 8 result) : Align before base data result

theorem align_outside (before : State) (base data result : ArrayPointer) (block offset : Nat)
    (source : Align before base data result)
    (outside : C99PointerFootprint.PointOutside base block offset) :
    C99PointerFootprint.PointOutside result block offset := by
  cases source with
  | run cb cd k km rounded word bytePointer result baseCast dataCast sameBlock sameBase sameCount
      ordered difference ptrdiffRange remainder control normal read addition resultCast =>
    have hb := cast_outside base cb 1 block offset baseCast outside
    have hp : C99PointerFootprint.PointOutside bytePointer block offset := by
      cases addition
      have monotone := Nat.mul_le_mul_left cb.elementBytes (Nat.le_add_right cb.index word.toNat)
      dsimp [C99PointerFootprint.PointOutside,ArrayPointer.offset] at hb ⊢
      omega
    exact cast_outside bytePointer result 8 block offset resultCast hp

/- memmove uses the complete pre-call snapshot even on overlapping ranges.
   This is the C library operation, not an arbitrary search call. -/
def Memmove (before : Memory) (dst src : ArrayPointer) (count : Nat) (after : Memory) : Prop :=
  dst.offset+count≤dst.base+dst.elementBytes*dst.count ∧
  src.offset+count≤src.base+src.elementBytes*src.count ∧
  dst.base+dst.elementBytes*dst.count≤before.size dst.block ∧
  src.base+src.elementBytes*src.count≤before.size src.block ∧
  before.size dst.block<2^64 ∧ before.size src.block<2^64 ∧ before.writable dst.block=true ∧
  (∀ i<count, (before.bytes src.block (src.offset+i)).isSome) ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  (∀ i<count, after.bytes dst.block (dst.offset+i)=before.bytes src.block (src.offset+i)) ∧
  (∀ block offset, block≠dst.block ∨ offset<dst.offset ∨ dst.offset+count≤offset →
    after.bytes block offset=before.bytes block offset)

theorem memmove_frame (before after : Memory) (dst src : ArrayPointer) (count block offset : Nat)
    (source : Memmove before dst src count after)
    (outside : C99PointerFootprint.PointOutside dst block offset) :
    after.bytes block offset=before.bytes block offset := by
  have extent := source.1
  apply source.2.2.2.2.2.2.2.2.2.2.2 block offset
  dsimp [C99PointerFootprint.PointOutside] at outside
  omega

end FT1536.Source3.KeygenSearchMemory
