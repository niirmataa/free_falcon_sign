import Source3.KeygenCodecStateFrame
import Source3.KeygenCodecNoneResult
import Source3.KeygenCodecStaticWindow

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNoneCursor
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
abbrev IV := C99IntegerReference.Value

def Cursor (n : Nat) (l : Locals) : Prop :=
  l.scalars "u".toList=some (.uint64,some (.uint64 (BitVec.ofNat 64 n)))
def Len (l : Locals) : Prop := l.scalars "len".toList=some (.uint64,some (.uint64 3072))
def test : Expr := .binary .lt (.variable "u".toList) (.variable "len".toList)
def index (d : Nat) : Expr := .binary .add (.variable "u".toList) (.number .i32 d)

theorem len_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l t : Locals) (v : Value) (cell : Len l)
    (source : Eval args heap buf (.variable "len".toList) l v t) :
    v=.integer (.uint64 3072) ∧ t=l := by
  cases source
  simp_all [Len]

theorem test_eval (args : Args) (s : State) (l : Locals) (value : Value) (n : Nat)
    (bound : n≤3072) (cursor : Cursor n s.locals) (length : Len s.locals)
    (source : Eval args s.heap s.buf test s.locals value l) :
    truth value=decide (n<3072) ∧ l=s.locals := by
  have nb : n<2^64 := by omega
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨hx,hm⟩ := KeygenCodecGuardedWrite.u_eval args s.heap s.buf s.locals middle x (BitVec.ofNat 64 n) cursor first
    subst x
    subst middle
    obtain ⟨hy,ht⟩ := len_eval args s.heap s.buf s.locals l y length second
    subst y
    cases operation with
    | lt x y z compared =>
      cases compared
      have ni : (n : Int)<18446744073709551616 := by omega
      simp_all [truth,C99IntegerReference.usual,C99IntegerReference.promote,
        C99IntegerReference.convert,C99IntegerReference.Value.type,C99IntegerReference.Value.integer,C99IntegerReference.compare,
        BitVec.toNat_ofNat,Nat.mod_eq_of_lt]
      by_cases h : n<3072
      · simp [h]
      · simp [h]

theorem signed_nat32 (d : Nat) (small : d<2^31) : (BitVec.ofNat 32 d).toInt=(d : Int) :=
  BitVec.toInt_ofInt_eq_self (w := 32) (n := (d : Int)) (by decide +kernel) (by omega) (by omega)

theorem signed_nat64 (d : Nat) (small : d<2^63) : (BitVec.ofNat 64 d).toInt=(d : Int) :=
  BitVec.toInt_ofInt_eq_self (w := 64) (n := (d : Int)) (by decide +kernel) (by omega) (by omega)

theorem unsigned_nat64 (n : Nat) (small : n<2^64) :
    (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 n)).integer=(n : Int) := by
  simp only [C99IntegerReference.Value.integer,BitVec.toNat_ofNat,Nat.mod_eq_of_lt small]

theorem plus_value (n d : Nat) (bound : n+d<2^64) (small : d<2^31)
    (z : IV) (source : BinaryOp .add (.integer (.uint64 (BitVec.ofNat 64 n)))
      (.integer (.int32 (BitVec.ofNat 32 d))) (.integer z)) :
    z=.uint64 (BitVec.ofNat 64 (n+d)) := by
  have nb : n<2^64 := by omega
  have db : d<2^64 := by omega
  cases source with
  | add x y z operation =>
    have same := (C99IntegerReference.arithmetic_iff .plus _ _ z).mp operation |>.2
    change z=.uint64 (BitVec.ofInt 64
      ((C99IntegerReference.convert .uint64 (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 n)).integer).integer+
       (C99IntegerReference.convert .uint64 (C99IntegerReference.Value.int32 (BitVec.ofNat 32 d)).integer).integer)) at same
    rw [unsigned_nat64 n nb] at same
    change z=.uint64 (BitVec.ofInt 64
      ((C99IntegerReference.Value.uint64 (BitVec.ofNat 64 n)).integer+
       (C99IntegerReference.convert .uint64 (BitVec.ofNat 32 d).toInt).integer)) at same
    rw [signed_nat32 d small] at same
    change z=.uint64 (BitVec.ofInt 64
      ((C99IntegerReference.Value.uint64 (BitVec.ofNat 64 n)).integer+(C99IntegerReference.Value.uint64 (BitVec.ofNat 64 d)).integer)) at same
    rw [unsigned_nat64 n nb,unsigned_nat64 d db] at same
    simpa only [←Int.natCast_add,BitVec.ofInt_natCast] using same

theorem index_eval (args : Args) (s : State) (l : Locals) (value : Value) (n d : Nat)
    (bound : n+d<2^64) (small : d<2^31) (cursor : Cursor n s.locals)
    (source : Eval args s.heap s.buf (index d) s.locals value l) :
    value=.integer (.uint64 (BitVec.ofNat 64 (n+d))) ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨hx,hm⟩ := KeygenCodecGuardedWrite.u_eval args s.heap s.buf s.locals middle x (BitVec.ofNat 64 n) cursor first
    subst x
    subst middle
    obtain ⟨hy,ht⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 d (.int32 (BitVec.ofNat 32 d)) s.locals l y (by
      have d64 : d<2^(64-1) := by omega
      simp only [castInteger,scalarTy,Option.map_some,C99IntegerReference.convert,C99IntegerReference.Value.integer,signed_nat64 d d64,BitVec.ofInt_natCast]) second
    subst y
    cases value with
    | pointer p => cases operation
    | integer z => exact ⟨congrArg Value.integer (plus_value n d bound small z operation),ht⟩

theorem update_cursor (args : Args) (s t : State) (flow : Flow) (n : Nat)
    (bound : n+2≤3072) (cursor : Cursor n s.locals)
    (source : Exec args KeygenCodecNoneBinding.loop032Update s t flow) : Cursor (n+2) t.locals := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.uint64 ∧ old=some (.uint64 (BitVec.ofNat 64 n)) := by
      simpa only [Option.some.injEq,Prod.mk.injEq] using declared.symm.trans cursor
    obtain ⟨rfl,rfl⟩ := equal
    obtain ⟨same,last⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 2 (.int32 2) s.locals locals (.integer value) (by decide +kernel) evaluated
    have integer : value=.int32 2 := Value.integer.inj same
    subst value
    cases assigned with
    | compound op binary old rhs z operator operation =>
      have binaryEq : binary=.add := Option.some.inj operator.symm
      subst binary
      have same := plus_value n 2 (by omega) (by decide +kernel) result operation
      subst result
      simp only [Cursor,withLocals,localSet,C99ScalarReference.set,ite_true,C99IntegerReference.convert,unsigned_nat64 (n+2) (by omega),BitVec.ofInt_natCast]

theorem initialize_cursor (args : Args) (s t : State) (flow : Flow)
    (declaredCursor : s.locals.scalars "u".toList=some (.uint64,none))
    (source : Exec args KeygenCodecNoneBinding.loop032Init s t flow) : Cursor 0 t.locals := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.uint64 ∧ old=none := by
      simpa only [Option.some.injEq,Prod.mk.injEq] using declared.symm.trans declaredCursor
    obtain ⟨rfl,rfl⟩ := equal
    obtain ⟨same,last⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 0 (.int32 0) s.locals locals (.integer value) (by decide +kernel) evaluated
    have integer : value=.int32 0 := Value.integer.inj same
    subst value
    cases assigned
    simp [Cursor,withLocals,localSet,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

end FT1536.Source3.KeygenCodecNoneCursor
