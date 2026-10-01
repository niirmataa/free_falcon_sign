import Source3.C99CountedWords

namespace FT1536.Source3.C99VariablePointer
open C99MemoryReference
open C99ArrayReference (Name State)

theorem source_value (before : State) (array indexName : Name) (root result : ArrayPointer)
    (amount : Nat) (small : amount<2^64)
    (binding : before.arrays array=some root)
    (indexBinding : before.locals indexName=some (.uint64,some (.uint64 (BitVec.ofNat 64 amount))))
    (source : C99ArrayReference.Pointer before array (.var indexName) result) :
    result={root with index := root.index+amount} ∧ root.index+amount≤root.count := by
  cases source with
  | add original _ value bound evaluated nonnegative within =>
      have he : original=root := Option.some.inj (bound.symm.trans binding)
      subst original
      have hv := C99CountedWords.variable_exact before indexName .uint64
        (.uint64 (BitVec.ofNat 64 amount)) value indexBinding evaluated
      subst value
      have hn : (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 amount)).integer.toNat=amount := by
        have hword : (BitVec.ofNat 64 amount).toNat=amount := Nat.mod_eq_of_lt small
        change ((BitVec.ofNat 64 amount).toNat : Int).toNat=amount
        rw [hword]
        rfl
      rw [hn] at within
      cases within with
      | within hbound => exact ⟨rfl,hbound⟩

end FT1536.Source3.C99VariablePointer
