import Source3.DeepestUnsignedCrtCall217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Instantiate the deepest unsigned CRT domain at the selected fp/gp image. -/
namespace FT1536.Source3.DeepestSelectedCrt217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open KeygenSmallOutput (element)
open KeygenFullData127 (primes env)
open ZintNormWalkFlat208 (Data)
open NinthStepLayout217 (fd gd)
open DeepestUnsignedCrtCall217 (Domain)

def tmp := SelectedDeepestWorkspace175.pointer 4
noncomputable def pair (F G : Nat → BitVec 32) (i : Nat) := if i<335 then F i else G (i-335)

theorem pair_data (s : State) (F G : Nat → BitVec 32) (f : Data s fd 335 F) (g : Data s gd 335 G) :
    Data s fd 670 (pair F G) := by
  intro i bound
  by_cases low : i<335
  · simpa only [pair,low,ite_true] using f i low
  · have hi : i-335<335 := by omega
    have address : elem fd i=elem gd (i-335) := by
      change (⟨31,0,71680,4,670+i⟩ : ArrayPointer)=⟨31,0,71680,4,1005+(i-335)⟩
      apply congrArg (fun k : Nat => (⟨31,0,71680,4,k⟩ : ArrayPointer))
      omega
    rw [address]
    simpa only [pair,low,ite_false] using g (i-335) hi

theorem initial_object : KeygenStaticTables.PrimeObject SelectedMakeFgEntry175.entry.heap primes .ternary := by
  change KeygenStaticTables.PrimeObject SelectedPublicSuccess174.after.heap primes .ternary
  exact SelectedRootEntry175.source.primeObject

theorem selected_domain (s : State) (stable : KeygenMemoryStability.Stable SelectedMakeFgEntry175.entry.heap s.heap) :
    Domain s fd tmp := by
  have readonly := initial_object.2.2.2.1
  have object : KeygenStaticTables.PrimeObject s.heap primes .ternary :=
    KeygenMakeEntry.prime_block _ _ primes
      ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset readonly⟩ initial_object
  have extent : 4*71680≤s.heap.size 31 := by
    rw [stable.size,← SelectedMakeFgDomains176.heap]
    exact SelectedMakeFgDomains176.extent
  have size : s.heap.size 31<2^64 := by
    rw [stable.size,← SelectedMakeFgDomains176.heap]
    exact SelectedMakeFgDomains176.size_bound
  have writable : s.heap.writable 31=true := by
    rw [stable.writable,← SelectedMakeFgDomains176.heap]
    exact SelectedMakeFgDomains176.writable
  have alloc : Allocated s.heap tmp := by
    change 0<4 ∧ 0%4=0 ∧ 1340<71680 ∧ 0+4*71680≤s.heap.size 31 ∧ s.heap.size 31<2^64
    exact ⟨by decide,by decide,by decide,extent,size⟩
  refine ⟨object,rfl,by decide,writable,alloc,rfl,by decide,writable,?_⟩
  intro i j ib jb
  right; left
  change 0+4*(670+i)+4 ≤ 0+4*(1340+j)
  omega

end FT1536.Source3.DeepestSelectedCrt217
