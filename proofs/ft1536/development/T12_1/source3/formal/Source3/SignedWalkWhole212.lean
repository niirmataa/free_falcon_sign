import Source3.SignedWalkLoop212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SignedWalkWhole212
open C99ArrayReference (State Name bindPointer Pointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open StepCopyBody190 (elem addr)
open Word32Memory176 (Separate)
open SignedWalkFixed212 (Fixed Image)
open KeygenMakeFgSource (Exec)

def zero (s : State) := set64 s "v" 0
 def entry (s : State) (src : ArrayPointer) := bindPointer (zero s) "x".toList src

theorem locals (s : State) (src : ArrayPointer) (name : Name) (nv : name≠"v".toList) : (entry s src).locals name=s.locals name :=
  SelectedStepAddPrime195.locals_keep s "v".toList .uint64 (.uint64 0) name nv

theorem arrays (s : State) (src : ArrayPointer) (name : Name) (nx : name≠"x".toList) : (entry s src).arrays name=s.arrays name := by
  simp only [entry,bindPointer,nx,ite_false]; rfl

theorem fixed (s : State) (src t1 : ArrayPointer) (n len : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32)
    (h : Fixed s src t1 n len W p pi r2 rx) : Fixed (entry s src) src t1 n len W p pi r2 rx := by
  have hl:=locals s src
  exact ⟨h.nBound,h.lenBound,(hl "n".toList (by decide)).trans h.nCell,(hl "slen".toList (by decide)).trans h.lenCell,
    (hl "p".toList (by decide)).trans h.pCell,(hl "p0i".toList (by decide)).trans h.iCell,
    (hl "R2".toList (by decide)).trans h.r2Cell,(hl "Rx".toList (by decide)).trans h.rxCell,
    (arrays s src "t1".toList (by decide)).trans h.t1Binding,h.srcCapacity,h.dstCapacity,h.width,h.writable,h.allocated,h.data,h.apart⟩

theorem init_source (srcName : String) (s : State) (src : ArrayPointer) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) (binding : s.arrays srcName.toList=some src) (cap : src.index+0 ≤ src.count) :
    Exec (MakeFgAddPrimeShape194.walkInit srcName) s ⟨entry s src,.normal⟩ := by
  have first : C99ModularReference.Exec (.assign "v".toList (.scalar (.literal .i32 0))) s ⟨zero s,.normal⟩ :=
    .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have ptr : Pointer (zero s) srcName.toList MakeFgAddPrimeShape194.at0 src :=
    .add _ _ src src (.uint64 0) binding (.literal .uint64 0) (by decide) (.within src 0 cap)
  exact .level _ _ _ (.modular _ _ _ (.seqNormal _ _ _ _ _ first (.base _ _ _ (.bindPtr _ _ _ _ _ ptr))))

theorem source (srcName : String) (s : State) (src t1 : ArrayPointer) (n len : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32)
    (h : Fixed s src t1 n len W p pi r2 rx) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) (binding : s.arrays srcName.toList=some src) :
    ∃ out, Exec (MakeFgAddPrimeShape194.walkF srcName) s ⟨out,.normal⟩ ∧ Fixed out src t1 n len W p pi r2 rx ∧
      Cell out "v".toList n ∧ out.arrays "x".toList=some (addr src 0 n len) ∧ Image out t1 len W p pi r2 rx n ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < n → Separate (elem t1 i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have vc : Cell (entry s src) "v".toList 0 := by change Cell (zero s) "v".toList 0; exact CrtState205.cell64 _ _ _
  have xb : (entry s src).arrays "x".toList=some (addr src 0 0 len) := by
    change some src=some (addr src 0 0 len)
    simp only [addr,Nat.zero_mul,Nat.add_zero]
  obtain ⟨out,run,finalFixed,finalV,finalX,image,ls,ars,keep⟩:=SignedWalkLoop212.source (entry s src) src t1 n len W p pi r2 rx
    (fixed s src t1 n len W p pi r2 rx h) vc xb
  refine ⟨out,.seqNormal _ _ _ _ _ (init_source srcName s src old declared binding (by have cap:=h.srcCapacity; omega)) run,
    finalFixed,finalV,finalX,image,?_,?_,keep⟩
  · intro name different
    exact (ls name different).trans (locals s src name different)
  · intro name different
    exact (ars name different).trans (arrays s src name different)

end FT1536.Source3.SignedWalkWhole212
