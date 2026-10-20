import Source3.C99ArrayReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99CountedWords
open C99IntegerReference
open C99ArrayReference (State)

theorem convert_self (v : Value) : convert v.type v.integer=v := by
  cases v <;> simp [convert,Value.type,Value.integer]

theorem comparison_result (op : Comparison) (x y z : Value) (h : CompareExec op x y z) :
    z=C99ScalarReference.boolean
      (compare op (convert (usual x.type y.type) x.integer).integer
        (convert (usual x.type y.type) y.integer).integer) := by
  cases h with
  | step t ht a b ha hb => subst t; subst a; subst b; rfl

theorem uint64_comparison (op : Comparison) (x y : BitVec 64) (z : Value)
    (h : CompareExec op (.uint64 x) (.uint64 y) z) :
    z=C99ScalarReference.boolean (compare op (x.toNat : Int) (y.toNat : Int)) := by
  have he := comparison_result op (.uint64 x) (.uint64 y) z h
  change z=C99ScalarReference.boolean
    (compare op (convert (Value.uint64 x).type (Value.uint64 x).integer).integer
      (convert (Value.uint64 y).type (Value.uint64 y).integer).integer) at he
  rw [convert_self,convert_self] at he
  exact he

theorem variable_exact (s : State) (name : C99ArrayReference.Name) (ty : Ty) (expected actual : Value)
    (binding : s.locals name=some (ty,some expected))
    (h : C99ArrayReference.scalar s (.var name) actual) : actual=expected := by
  cases h with
  | «variable» _ _ _ bound =>
      exact Option.some.inj (congrArg Prod.snd (Option.some.inj (bound.symm.trans binding)))

def Counter (s : State) (i : Nat) : Prop :=
  s.locals "u".toList=some (.uint64,some (.uint64 (BitVec.ofNat 64 i)))
def Limit (s : State) : Prop := s.locals "n".toList=some (.uint64,some (.uint64 1536))
def condition : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "n".toList)

theorem guard_exact (s : State) (i : Nat) (v : Value)
    (hi : i≤1536) (counter : Counter s i) (limit : Limit s)
    (source : C99ArrayReference.scalar s condition v) :
    v=C99ScalarReference.boolean (decide (i<1536)) := by
  change C99ScalarReference.Eval _ _ (.compare .lt (.variable "u".toList) (.variable "n".toList)) v at source
  cases source with
  | compare op a b x y z hx hy operation =>
      have hxu := variable_exact s "u".toList .uint64 (.uint64 (BitVec.ofNat 64 i)) x counter hx
      have hyn := variable_exact s "n".toList .uint64 (.uint64 1536) y limit hy
      subst x
      subst y
      have he := uint64_comparison .lt (BitVec.ofNat 64 i) 1536 v operation
      have hnat : (BitVec.ofNat 64 i).toNat=i := Nat.mod_eq_of_lt (by omega)
      rw [hnat] at he
      change v=C99ScalarReference.boolean (decide ((i : Int)<(1536 : Int))) at he
      have hlt : ((i : Int)<(1536 : Int))↔i<1536 := by omega
      simpa only [hlt] using he

theorem guard_true (s : State) (i : Nat) (v : Value)
    (hi : i≤1536) (counter : Counter s i) (limit : Limit s)
    (source : C99ArrayReference.scalar s condition v) (nonzero : v.integer≠0) : i<1536 := by
  rw [guard_exact s i v hi counter limit source] at nonzero
  by_contra h
  simp [h,C99ScalarReference.boolean,Value.integer] at nonzero

theorem guard_false (s : State) (i : Nat) (v : Value)
    (hi : i≤1536) (counter : Counter s i) (limit : Limit s)
    (source : C99ArrayReference.scalar s condition v) (zero : v.integer=0) : ¬i<1536 := by
  rw [guard_exact s i v hi counter limit source] at zero
  intro h
  simp [h,C99ScalarReference.boolean,Value.integer] at zero

theorem pointer_exact (s : State) (name : C99ArrayReference.Name) (root p : C99MemoryReference.ArrayPointer)
    (i : Nat) (hi : i≤1536) (counter : Counter s i) (binding : s.arrays name=some root)
    (source : C99ArrayReference.Pointer s name (.var "u".toList) p) :
    p={root with index := root.index+i} := by
  cases source with
  | add original _ value bound evaluated nonnegative within =>
      have he : original=root := Option.some.inj (bound.symm.trans binding)
      subst original
      have hv := variable_exact s "u".toList .uint64 (.uint64 (BitVec.ofNat 64 i)) value counter evaluated
      subst value
      cases within
      have hn : (Value.uint64 (BitVec.ofNat 64 i)).integer.toNat=i := by
        have hnat : (BitVec.ofNat 64 i).toNat=i := Nat.mod_eq_of_lt (by omega)
        change ((BitVec.ofNat 64 i).toNat : Int).toNat=i
        rw [hnat]
        rfl
      simp only [hn]

theorem add_one (i : Nat) (hi : i≤1536) (v : Value)
    (source : ArithmeticExec .plus (.uint64 (BitVec.ofNat 64 i)) (.int32 1) v) :
    v=.uint64 (BitVec.ofNat 64 (i+1)) := by
  have he := ((arithmetic_iff _ _ _ _).mp source).2
  change v=convert .uint64
    ((convert (Value.uint64 (BitVec.ofNat 64 i)).type (Value.uint64 (BitVec.ofNat 64 i)).integer).integer+1) at he
  rw [convert_self] at he
  have hnat : (BitVec.ofNat 64 i).toNat=i := Nat.mod_eq_of_lt (by omega)
  change v=Value.uint64 (BitVec.ofInt 64 ((BitVec.ofNat 64 i).toNat+1)) at he
  rw [hnat] at he
  have hc : (i : Int)+1=((i+1 : Nat) : Int) := by omega
  rw [hc,BitVec.ofInt_natCast] at he
  exact he

end FT1536.Source3.C99CountedWords
