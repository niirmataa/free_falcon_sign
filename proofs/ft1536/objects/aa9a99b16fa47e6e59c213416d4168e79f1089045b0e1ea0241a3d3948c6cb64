import Source3.KeygenPrimeTableBinding
import Source3.KeygenSearchContext

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Static records are consumed by the actual struct-member read. The index
   and field word come from that execution, not from an assumed prime value. -/
namespace FT1536.Source3.KeygenStaticReads
open KeygenStaticTables
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)

theorem mapM_at {α β : Type} (f : α → Option β) (xs : List α) (ys : List β)
    (source : xs.mapM f=some ys) (i : Nat) : (xs[i]?).bind f=ys[i]? := by
  induction xs generalizing ys i with
  | nil =>
    have he : ys=[] := (Option.some.inj source).symm
    subst ys
    simp
  | cons x xs ih =>
    rw [List.mapM_cons] at source
    obtain ⟨y,head,rest⟩ := Option.bind_eq_some_iff.mp source
    obtain ⟨tail,runTail,result⟩ := Option.bind_eq_some_iff.mp rest
    have he : y::tail=ys := Option.some.inj result
    subst ys
    cases i with
    | zero => simpa using head
    | succ i => simpa using ih tail runTail i
theorem indexed_source (table : PrimeTable) (i : Nat) :
    ((rows table)[i]?).bind row=(values table)[i]? :=
  mapM_at row (rows table) (values table) (KeygenPrimeTableBinding.source_values table) i
def first : PrimeTable → Nat×Nat×Nat
  | .binary => (2147473409,383167813,10239)
  | .ternary => (2147355649,1907584673,127999)
theorem first_source (table : PrimeTable) : ((rows table)[0]?).bind row=some (first table) := by
  cases table <;> decide +kernel
theorem first_value (table : PrimeTable) : (values table)[0]?=some (first table) :=
  (indexed_source table 0).symm.trans (first_source table)

theorem prime_read (s : State) (table : PrimeTable) (name : C99ArrayReference.Name)
    (root : ArrayPointer) (index : CLogic.Expr) (field : KeygenLevelCalls.Field) (v : Value)
    (binding : s.arrays name=some root) (object : PrimeObject s.heap root table)
    (source : KeygenLevelCalls.PrimeRead s name index field v) :
    ∃ iv i entry, C99ArrayReference.scalar s index iv ∧ i=iv.integer.toNat ∧
      i<rowCount table ∧ (values table)[i]?=some entry ∧
      v=.uint32 (BitVec.ofNat 32 (fieldValue entry field)) := by
  cases source with
  | read p w address width extent bytes =>
    cases address with
    | add base p iv pointer value nonnegative within =>
      have he : base=root := Option.some.inj (pointer.symm.trans binding)
      subst base
      cases within
      have hi : iv.integer.toNat<rowCount table := by
        simpa only [object.2.1,object.2.2.1,Nat.zero_add] using extent
      have hl : iv.integer.toNat<(values table).length := by
        rw [KeygenPrimeTableBinding.source_length]
        exact hi
      let entry := (values table)[iv.integer.toNat]
      have loaded : (values table)[iv.integer.toNat]?=some entry := by simp [entry,hl]
      have hp : KeygenLevelCalls.fieldPointer {root with index := root.index+iv.integer.toNat} field=
          primeField root iv.integer.toNat field := by
        simp only [KeygenLevelCalls.fieldPointer,primeField,ArrayPointer.offset,object.1,object.2.1,
          Nat.zero_add,Nat.mul_zero,Nat.add_zero]
      rw [hp] at bytes
      have hw := Gate00Memory.load32_deterministic s.heap _ w _ bytes (object.2.2.2.2.2.2 _ _ loaded field)
      exact ⟨iv,iv.integer.toNat,entry,value,rfl,hi,loaded,congrArg Value.uint32 hw⟩

end FT1536.Source3.KeygenStaticReads
