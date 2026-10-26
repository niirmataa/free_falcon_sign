import Source3.CrtCall208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepCrtDomain208
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated)
open SecondStepCopy203 (Side root)
open SecondStepLayout197 (fs gs gm)
open StepCopyBody190 (elem addr)
open Word32Memory176 (Separate)
open SecondStepGeometry203 (scratch ordered)
open SecondStepOuter204 (Outer)
open KeygenFullData127 (primes)

theorem data_shape (side : Side) (i : Nat) : elem (root side) i=scratch ((root side).index+i) := by cases side <;> rfl

theorem data_range (side : Side) : 1438 ≤ (root side).index ∧ (root side).index ≤ 1950 := by cases side <;> decide

theorem data_tmp (side : Side) (i k : Nat) (bound : i < 512) : Separate (elem gm k) (elem (root side) i) := by
  apply StepCopyFixed203.separate_symm
  rw [data_shape]
  change Separate (scratch ((root side).index+i)) (scratch (2462+k))
  exact ordered _ _ (by have range:=data_range side; omega)

theorem cross (i j : Nat) (ib : i < 512) : Separate (elem fs i) (elem gs j) := by
  change Separate (scratch (1438+i)) (scratch (1950+j))
  exact ordered _ _ (by omega)

theorem data_product (source product : Side) (i u j : Nat) (ub : u < 2) (jb : j < 128) :
    Separate (elem (root source) i) (addr (SecondStepProduct203.root product) u j 3) := by
  apply StepCopyFixed203.separate_symm
  rw [data_shape,SecondStepGeometry203.product_shape]
  have low:=SecondStepGeometry203.product_bound product u j ub jb
  have high:=(data_range source).1
  exact ordered _ _ (by omega)

theorem tmp_product (product : Side) (k u j : Nat) (ub : u < 2) (jb : j < 128) :
    Separate (elem gm k) (addr (SecondStepProduct203.root product) u j 3) := by
  apply StepCopyFixed203.separate_symm
  rw [SecondStepGeometry203.product_shape]
  change Separate (scratch ((SecondStepProduct203.root product).index+u+j*3)) (scratch (2462+k))
  exact ordered _ _ (by have low:=SecondStepGeometry203.product_bound product u j ub jb; omega)

theorem domain (side : Side) (s : State) (u : Nat) (h : Outer s u)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) : CrtCall208.Domain s (root side) gm := by
  refine ⟨object,?_,?_,?_,h.allocated 2462 (by decide),rfl,by decide,h.writable,?_⟩
  · cases side <;> rfl
  · cases side <;> decide
  · cases side <;> exact h.writable
  · intro i j ib _
    exact StepCopyFixed203.separate_symm (data_tmp side i j ib)

theorem outer (s out : State) (u : Nat) (h : Outer s u) (locals : out.locals=s.locals) (arrays : out.arrays=s.arrays)
    (stable : KeygenMemoryStability.Stable s.heap out.heap) : Outer out u := by
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact (congrFun locals "n".toList).trans h.nCell
  · exact (congrFun locals "hn".toList).trans h.hnCell
  · exact (congrFun locals "slen".toList).trans h.slenCell
  · exact (congrFun locals "tlen".toList).trans h.tlenCell
  · exact (congrFun locals "u".toList).trans h.uCell
  · exact (congrFun locals "logn".toList).trans h.lognCell
  · exact (congrFun locals "ter".toList).trans h.terCell
  · exact (congrFun locals "in_ntt".toList).trans h.inCell
  · exact (congrFun locals "out_ntt".toList).trans h.outCell
  · exact (congrFun arrays "fd".toList).trans h.fdBinding
  · exact (congrFun arrays "gd".toList).trans h.gdBinding
  · exact (congrFun arrays "fs".toList).trans h.fsBinding
  · exact (congrFun arrays "gs".toList).trans h.gsBinding
  · exact (congrFun arrays "gm".toList).trans h.gmBinding
  · exact (congrFun arrays "igm".toList).trans h.igmBinding
  · exact (congrFun arrays "t1".toList).trans h.t1Binding
  · exact (congrFun arrays "primes".toList).trans h.primesBinding
  · rw [stable.writable]
    exact h.writable
  · intro index bound
    simpa only [Allocated,stable.size] using h.allocated index bound

theorem prime_object (s out : State) (code : KeygenZintCall.Stmt)
    (run : KeygenZintCall.Exec code s ⟨out,.normal⟩) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) :
    KeygenStaticTables.PrimeObject out.heap primes .ternary := by
  have stable:=KeygenMemoryStability.zint _ _ _ run
  exact KeygenMakeEntry.prime_block s.heap out.heap primes
    ⟨congrFun stable.size primes.block,congrFun stable.writable primes.block,
      fun offset => stable.readonly primes.block offset object.2.2.2.1⟩ object

end FT1536.Source3.SecondStepCrtDomain208
