import Source3.KeygenPublicSource
import Source3.KeygenPublicDivisionAlgebra

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-expression and scalar-statement inversions for the public table
   generator. These do not assume a generated table or transform result. -/
namespace FT1536.Source3.KeygenPublicTableAtoms
open C99ArrayReference (State Name bindValue)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenPublicExec (Stmt Exec)
open KeygenPublicWord (Eval)
open KeygenWordExpr (Expr)
open KeygenPublicDivisionAlgebra (multiply)

def var (n : String) : Expr := .scalar (.var n.toList)
def literal (n : Nat) : Expr := .scalar (.literal .i32 n)
def mont (a b : Expr) : Expr := .call4 (KeygenPublicScalar.name .mul) a b (literal 18433) (literal 18431)
def divide (a b : Expr) : Expr := .call2 (KeygenPublicScalar.name .divT) a b
def Slot (s : State) (n : String) (w : BitVec 32) : Prop := s.locals n.toList=some (.uint32,some (.uint32 w))
theorem literal_value (signed : List Name) (s : State) (n : Nat) (v : Value)
    (source : Eval signed s (literal n) v) : v=C99IntegerReference.convert .int32 n := by
  cases source
  cases ‹KeygenPublicWord.scalar _ _ _›
  rfl
theorem variable_value (signed : List Name) (s : State) (n : String) (w : BitVec 32) (v : Value)
    (slot : Slot s n w) (source : Eval signed s (var n) v) : v=.uint32 w := by
  cases source
  cases ‹KeygenPublicWord.scalar _ _ _› with
  | «variable» _ _ _ binding =>
      exact Option.some.inj (congrArg Prod.snd (Option.some.inj (binding.symm.trans slot)))
theorem mont_value (signed : List Name) (s : State) (a b : Expr) (x y : BitVec 32) (v : Value)
    (left : ∀ z, Eval signed s a z → KeygenPublicArguments.U32 z x)
    (right : ∀ z, Eval signed s b z → KeygenPublicArguments.U32 z y)
    (source : Eval signed s (mont a b) v) : v=.uint32 (multiply x y) := by
  cases source with
  | call4 _ _ _ _ _ av bv qv iv _ first second third fourth invoked =>
      have qEqual := literal_value signed s 18433 qv third
      have iEqual := literal_value signed s 18431 iv fourth
      subst qv; subst iv
      exact KeygenPublicArguments.source_mul_exact x y av bv _ _ v (left av first) (right bv second)
        (KeygenPublicArguments.u32_literal 18433) (KeygenPublicArguments.u32_literal 18431) invoked
theorem divide_value (signed : List Name) (s : State) (a b : Expr) (x y : BitVec 32) (v : Value)
    (left : ∀ z, Eval signed s a z → KeygenPublicArguments.U32 z x)
    (right : ∀ z, Eval signed s b z → KeygenPublicArguments.U32 z y)
    (source : Eval signed s (divide a b) v) : v=.uint32 (KeygenPublicDivisionWords.division x y) := by
  cases source with
  | call2 _ _ _ av bv _ first second invoked =>
      exact KeygenPublicDivisionWords.source_exact x y v
        (KeygenPublicDivisionAlgebra.normalize_call x y av bv v (left av first) (right bv second) invoked)
theorem literal_argument (signed : List Name) (s : State) (n : Nat) (v : Value)
    (source : Eval signed s (literal n) v) : KeygenPublicArguments.U32 v (BitVec.ofNat 32 n) := by
  rw [literal_value signed s n v source]
  exact KeygenPublicArguments.u32_literal n
theorem variable_argument (signed : List Name) (s : State) (n : String) (w : BitVec 32) (v : Value)
    (slot : Slot s n w) (source : Eval signed s (var n) v) : KeygenPublicArguments.U32 v w := by
  rw [variable_value signed s n w v slot source]
  exact KeygenPublicArguments.u32_self w

theorem assign_result (program : KeygenPublicExec.Program) (signed : List Name) (s : State)
    (n : String) (e : Expr) (w : BitVec 32) (out : Result)
    (declared : ∃ old, s.locals n.toList=some (.uint32,old))
    (value : ∀ v, Eval signed s e v → v=.uint32 w)
    (source : Exec program signed (.assign n.toList e) s out) :
    out=⟨bindValue s n.toList .uint32 (.uint32 w),.normal⟩ := by
  obtain ⟨old,bound⟩ := declared
  cases source with
  | assign _ _ _ ty previous v slot evaluated =>
      have typeEqual : ty=.uint32 := congrArg Prod.fst (Option.some.inj (slot.symm.trans bound))
      subst ty
      rw [value v evaluated]
theorem declaration_result (program : KeygenPublicExec.Program) (signed : List Name) (s : State)
    (ty : B20.C.Ty) (ns : List Name) (out : Result)
    (source : Exec program signed (.scalar (.declare ty ns)) s out) :
    out=⟨{s with locals := C99DeclarationCells.declareCells (C99ValueBridge.type ty) ns s.locals},.normal⟩ := by
  cases source with
  | scalar _ _ env executed =>
      have equal := C99ScalarReference.Result.normal.inj
        (C99DeclarationCells.complete KeygenPublicScalar.Call _ ns s.locals (.normal env) executed)
      rw [equal]
theorem slot_after (s : State) (n : String) (w : BitVec 32) : Slot (bindValue s n.toList .uint32 (.uint32 w)) n w := by
  have converted : C99IntegerReference.convert .uint32 (Value.uint32 w).integer=.uint32 w :=
    C99CountedWords.convert_self (.uint32 w)
  simp [Slot,bindValue,C99ScalarReference.set,converted]
theorem slot_preserved (s : State) (n other : String) (w : BitVec 32) (ty : Ty) (v : Value)
    (different : n≠other) (slot : Slot s n w) : Slot (bindValue s other.toList ty v) n w := by
  simpa only [Slot,bindValue,C99ScalarReference.set,
    show n.toList≠other.toList from fun equal => different (String.toList_injective equal),ite_false] using slot
theorem guard_value (signed : List Name) (s : State) (k : BitVec 32) (v : Value) (slot : Slot s "k" k)
    (source : Eval signed s (.cmp .lt (var "k") (literal 11)) v) :
    v=C99ScalarReference.boolean (decide (k.toNat<11)) := by
  cases source with
  | cmp _ _ _ a b _ first second comparison =>
      have aEqual := variable_value signed s "k" k a slot first
      have bEqual := literal_value signed s 11 b second
      subst a; subst b
      have equal := C99CountedWords.comparison_result _ _ _ v comparison
      have converted : C99IntegerReference.convert .uint32 (Value.uint32 k).integer=.uint32 k :=
        C99CountedWords.convert_self (.uint32 k)
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .lt
        (C99IntegerReference.convert .uint32 (Value.uint32 k).integer).integer 11) at equal
      rw [converted] at equal
      have lt : ((k.toNat : Int)<11) ↔ k.toNat<11 := by omega
      simpa only [C99IntegerReference.Value.integer,C99IntegerReference.compare,lt] using equal
theorem increment_result (program : KeygenPublicExec.Program) (signed : List Name)
    (s : State) (k : BitVec 32) (out : Result) (slot : Slot s "k" k)
    (source : Exec program signed (.scalar (.update "k".toList .add (.literal .i32 1))) s out) :
    out=⟨bindValue s "k".toList .uint32 (.uint32 (k+1)),.normal⟩ := by
  cases source with
  | scalar _ _ env executed =>
      cases executed with
      | assign _ _ _ ty old v declared evaluated =>
          have typeEqual : ty=.uint32 := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
          subst ty
          cases evaluated with
          | arithmetic _ _ _ a b _ first second operation =>
              have aEqual : a=.uint32 k := by
                cases first with
                | «variable» _ _ _ binding =>
                    exact Option.some.inj (congrArg Prod.snd (Option.some.inj (binding.symm.trans slot)))
              subst a
              cases second
              have vEqual := ((C99IntegerReference.arithmetic_iff _ _ _ _).mp operation).2
              have converted : C99IntegerReference.convert .uint32 (Value.uint32 k).integer=.uint32 k :=
                C99CountedWords.convert_self (.uint32 k)
              change v=C99IntegerReference.convert .uint32
                ((C99IntegerReference.convert .uint32 (Value.uint32 k).integer).integer+1) at vEqual
              rw [converted] at vEqual
              have exact : v=.uint32 (k+1) := by
                rw [vEqual]
                change Value.uint32 (BitVec.ofInt 32 (k.toNat+1))=Value.uint32 (k+1)
                rw [BitVec.ofInt_add,BitVec.ofInt_natCast]
                simp
              rw [exact]
              rfl

end FT1536.Source3.KeygenPublicTableAtoms
