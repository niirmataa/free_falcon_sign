import Source3.KeygenPublicRadixProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Bounded size_t operations used by the actual public outer loops. -/
namespace FT1536.Source3.KeygenPublicSizeOps
open C99ArrayReference (State bindValue)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval)
open KeygenPublicTableAtoms (var literal)
open KeygenNttLoopSupport (USlot u64)

def Declared (s : State) (name : String) : Prop := ∃ old, s.locals name.toList=some (.uint64,old)
def Has (s : State) (e : KeygenWordExpr.Expr) (n : Nat) : Prop := ∀ v, Eval [] s e v → v=u64 n

theorem variable_slot (s : State) (name : String) (n : Nat) (slot : USlot s name n) : Has s (var name) n :=
  fun v ev => KeygenPublicTableIndex.word64 s name n v slot ev

theorem sum (s : State) (a b : KeygenWordExpr.Expr) (x y : Nat)
    (hx : x<2^64) (hy : y<2^64) (left : Has s a x) (right : Has s b y) :
    Has s (.bin .add a b) (x+y) := by
  intro v ev
  cases ev with
  | bin _ _ _ av bv _ ae be op =>
      have he := left av ae
      have hf := right bv be
      subst av; subst bv
      exact KeygenNttLoopSupport.plus_u64 x y hx hy v op

theorem half (s : State) (name : String) (n : Nat) (hn : n<2^64) (slot : USlot s name n) :
    Has s (.bin .shr (var name) (literal 1)) (n/2) := by
  intro v ev
  cases ev with
  | bin _ _ _ av bv _ ae be op =>
      have he := variable_slot s name n slot av ae
      have hf := KeygenPublicTableAtoms.literal_value [] s 1 bv be
      subst av; subst bv
      exact KeygenNttLoopSupport.shr_one_u64 n hn v op

theorem double (s : State) (name : String) (n : Nat) (hn : n<2^64) (slot : USlot s name n) :
    Has s (.bin .shl (var name) (literal 1)) (n*2) := by
  intro v ev
  cases ev with
  | bin _ _ _ av bv _ ae be op =>
      have he := variable_slot s name n slot av ae
      have hf := KeygenPublicTableAtoms.literal_value [] s 1 bv be
      subst av; subst bv
      exact KeygenNttLoopSupport.shl_one_u64 n hn v op

theorem assign (s : State) (out : Result) (name : String) (e : KeygenWordExpr.Expr) (n : Nat)
    (hn : n<2^64) (declared : Declared s name) (value : Has s e n)
    (source : Exec KeygenPublicSource.program [] (.assign name.toList e) s out) :
    out=⟨bindValue s name.toList .uint64 (u64 n),.normal⟩ ∧ USlot out.state name n := by
  have eq := KeygenPublicLastEntry.assign64_result s out name e (u64 n) declared value source
  refine ⟨eq,?_⟩
  rw [eq]
  simp only [USlot,bindValue,C99ScalarReference.set,ite_true]
  rw [KeygenNttLoopSupport.convert_u64_self n hn]

theorem init (s : State) (out : Result) (name : String) (n : Nat) (hn : n≤2)
    (declared : Declared s name)
    (source : Exec KeygenPublicSource.program [] (.assign name.toList (literal n)) s out) :
    USlot out.state name n ∧ out.state.heap=s.heap := by
  have eq := KeygenPublicLastEntry.assign64_result s out name _ (C99IntegerReference.convert .int32 n)
    declared (fun v ev => KeygenPublicTableAtoms.literal_value [] s n v ev) source
  rw [eq]
  refine ⟨?_,rfl⟩
  simp only [USlot,bindValue,C99ScalarReference.set,ite_true]
  interval_cases n <;> rfl

theorem increment (s : State) (out : Result) (name : String) (n : Nat) (hn : n<1536)
    (slot : USlot s name n)
    (source : Exec KeygenPublicSource.program [] (.scalar (.update name.toList .add (.literal .i32 1))) s out) :
    USlot out.state name (n+1) ∧ out.state.heap=s.heap := by
  cases source with
  | scalar _ before env executed =>
      cases executed with
      | assign _ _ _ ty old v declared evaluated =>
          have te := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
          dsimp only at te
          subst ty
          cases evaluated with
          | arithmetic _ _ _ a b _ left right operation =>
              have ae := KeygenPublicTableIndex.variable64 s name n a slot left
              subst a
              cases right
              rw [KeygenNttLoopSupport.add_one_literal n (by omega) v operation]
              refine ⟨?_,rfl⟩
              simp only [USlot,C99ScalarReference.set,ite_true]
              rw [KeygenNttLoopSupport.convert_u64_self (n+1) (by omega)]

theorem lt (s : State) (a b : String) (x y : Nat) (hx : x≤1536) (hy : y≤1536) (v : Value)
    (left : USlot s a x) (right : USlot s b y) (source : Eval [] s (.cmp .lt (var a) (var b)) v) :
    v=C99ScalarReference.boolean (decide (x<y)) := by
  cases source with
  | cmp _ _ _ av bv _ ae be op =>
      have he := variable_slot s a x left av ae
      have hf := variable_slot s b y right bv be
      subst av; subst bv
      have eq := C99CountedWords.comparison_result _ _ _ v op
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .lt
        (C99IntegerReference.convert .uint64 (u64 x).integer).integer
        (C99IntegerReference.convert .uint64 (u64 y).integer).integer) at eq
      rw [KeygenNttLoopSupport.convert_u64_self x (by omega),KeygenNttLoopSupport.convert_u64_self y (by omega),
        KeygenNttLoopSupport.u64_integer x (by omega),KeygenNttLoopSupport.u64_integer y (by omega)] at eq
      have cmp : (x : Int)<(y : Int) ↔ x<y := by omega
      simpa only [C99IntegerReference.compare,cmp] using eq

theorem gt_three (s : State) (n : Nat) (hn : n≤768) (v : Value) (slot : USlot s "t" n)
    (source : Eval [] s KeygenPublicRadixProgram.stageGuard v) :
    v=C99ScalarReference.boolean (decide (3<n)) := by
  cases source with
  | cmp _ _ _ av bv _ ae be op =>
      have he := variable_slot s "t" n slot av ae
      have hf := KeygenPublicTableAtoms.literal_value [] s 3 bv be
      subst av; subst bv
      have eq := C99CountedWords.comparison_result _ _ _ v op
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .gt
        (C99IntegerReference.convert .uint64 (u64 n).integer).integer 3) at eq
      rw [KeygenNttLoopSupport.convert_u64_self n (by omega),KeygenNttLoopSupport.u64_integer n (by omega)] at eq
      have cmp : (3 : Int)<(n : Int) ↔ 3<n := by omega
      simpa only [C99IntegerReference.compare,cmp] using eq

theorem scalar_sum (s : State) (a b : String) (x y : Nat) (hx : x≤1536) (hy : y≤1536) (v : Value)
    (left : USlot s a x) (right : USlot s b y)
    (source : KeygenPublicWord.scalar s (.bin .add (.var a.toList) (.var b.toList)) v) :
    v.integer.toNat=x+y := by
  cases source with
  | arithmetic _ _ _ av bv _ ae be op =>
      have he := KeygenPublicTableIndex.variable64 s a x av left ae
      have hf := KeygenPublicTableIndex.variable64 s b y bv right be
      subst av; subst bv
      rw [KeygenNttLoopSupport.plus_u64 x y (by omega) (by omega) v op]
      exact KeygenNttLoopSupport.u64_toNat (x+y) (by omega)

end FT1536.Source3.KeygenPublicSizeOps
