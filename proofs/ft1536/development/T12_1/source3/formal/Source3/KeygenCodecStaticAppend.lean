import Source3.KeygenCodecStaticSuffix

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticAppend
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

def amount : Expr := .binary .add (.variable "j".toList) (.number .i32 1)
def shifted : Expr := .binary .shl (.variable "acc".toList) amount
def rhs : Expr := .binary .bor shifted (.variable "lo".toList)

theorem integer_cell (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (name : Name) (ty : C99IntegerReference.Ty) (v z : C99IntegerReference.Value) (l t : Locals)
    (cell : l.scalars name=some (ty,some v))
    (source : Eval args heap buf (.variable name) l (.integer z) t) : z=v ∧ t=l := by
  cases source
  simp_all

theorem amount_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l t : Locals) (z : C99IntegerReference.Value)
    (cell : l.scalars "j".toList=some (.int32,some (.int32 8)))
    (source : Eval args heap buf amount l (.integer z) t) : z=.int32 9 ∧ t=l := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    cases operation with
    | add x y z operation =>
      obtain ⟨hx,hm⟩ := integer_cell args heap buf "j".toList .int32 (.int32 8) x l middle cell first
      subst x
      subst middle
      obtain ⟨hy,ht⟩ := KeygenCodecNoneLength.number_eval args heap buf .i32 1 (.int32 1) l t (.integer y) (by decide +kernel) second
      have integer : y=.int32 1 := Value.integer.inj hy
      subst y
      have canonical : C99IntegerReference.ArithmeticExec .plus (.int32 8) (.int32 1) (.int32 9) :=
        (C99IntegerReference.arithmetic_iff _ _ _ _).mpr (by
          constructor
          · intro _
            change (-2147483648≤(9 : Int) ∧ (9 : Int)<2147483648)
            decide +kernel
          · rfl)
      exact ⟨C99IntegerReference.arithmetic_deterministic _ _ _ _ _ operation canonical,ht⟩

theorem shift_word (a : BitVec 32) :
    C99IntegerReference.convert .uint32 ((C99IntegerReference.Value.uint32 a).integer*2^9)=.uint32 (a <<< 9) := by
  change C99IntegerReference.Value.uint32 (BitVec.ofInt 32 ((a.toNat : Int)*512))=_
  rw [show (a.toNat : Int)*512=((a.toNat*512 : Nat) : Int) from (Int.natCast_mul _ _).symm,BitVec.ofInt_natCast]
  congr 1
  change BitVec.ofNat 32 (a.toNat*512)=BitVec.ofNat 32 (a.toNat <<< 9)
  rw [Nat.shiftLeft_eq]

theorem or_word (a b : BitVec 32) :
    C99IntegerReference.convert .uint32 ((a.toNat ||| b.toNat : Nat) : Int)=.uint32 (a ||| b) := by
  change C99IntegerReference.Value.uint32 (BitVec.ofNat 32 (a ||| b).toNat)=_
  rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem shifted_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l t : Locals) (z : C99IntegerReference.Value) (acc : BitVec 32)
    (cell : l.scalars "acc".toList=some (.uint32,some (.uint32 acc)))
    (j : l.scalars "j".toList=some (.int32,some (.int32 8)))
    (source : Eval args heap buf shifted l (.integer z) t) : z=.uint32 (acc <<< 9) ∧ t=l := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    cases operation with
    | shl x y z operation =>
      obtain ⟨hx,hm⟩ := integer_cell args heap buf "acc".toList .uint32 (.uint32 acc) x l middle cell first
      subst x
      subst middle
      obtain ⟨hy,ht⟩ := amount_eval args heap buf l t y j second
      subst y
      have canonical := C99IntegerReference.ShiftExec.unsignedLeft (.uint32 acc) (.int32 9) 9 rfl rfl (by change (9 : Nat)<32; decide +kernel)
      have same := C99IntegerReference.shift_deterministic _ _ _ _ _ operation canonical
      exact ⟨same.trans (shift_word acc),ht⟩

theorem rhs_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l t : Locals) (z : C99IntegerReference.Value) (acc lo : BitVec 32)
    (cell : l.scalars "acc".toList=some (.uint32,some (.uint32 acc)))
    (j : l.scalars "j".toList=some (.int32,some (.int32 8)))
    (bits : l.scalars "lo".toList=some (.uint32,some (.uint32 lo)))
    (source : Eval args heap buf rhs l (.integer z) t) : z=.uint32 ((acc <<< 9) ||| lo) ∧ t=l := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    cases operation with
    | bor x y z operation =>
      obtain ⟨hx,hm⟩ := shifted_eval args heap buf l middle x acc cell j first
      subst x
      subst middle
      obtain ⟨hy,ht⟩ := integer_cell args heap buf "lo".toList .uint32 (.uint32 lo) y l t bits second
      subst y
      have same := (C99IntegerReference.bitwise_iff .or _ _ z).mp operation
      change z=C99IntegerReference.convert .uint32
        (((C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 (acc <<< 9)).integer).bits |||
          (C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 lo).integer).bits : Nat) : Int) at same
      simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat] at same
      exact ⟨same.trans (or_word (acc <<< 9) lo),ht⟩

theorem convert_word (a : BitVec 32) :
    C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 a).integer=.uint32 a := by
  simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]

/-- Actual bound source assignment, universally over the old uint32 word.
    Only the low pending suffix is interpreted; old high bits are allowed. -/
theorem append_step (args : Args) (s t : State) (flow : Flow) (acc lo : BitVec 32)
    (cell : s.locals.scalars "acc".toList=some (.uint32,some (.uint32 acc)))
    (j : s.locals.scalars "j".toList=some (.int32,some (.int32 8)))
    (bits : s.locals.scalars "lo".toList=some (.uint32,some (.uint32 lo)))
    (source : Exec args KeygenCodecStaticBinding.node040 s t flow) :
    t.locals.scalars "acc".toList=some (.uint32,some (.uint32 ((acc <<< 9) ||| lo))) := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.uint32 ∧ old=some (.uint32 acc) := by
      simpa only [Option.some.injEq,Prod.mk.injEq] using declared.symm.trans cell
    obtain ⟨rfl,rfl⟩ := equal
    obtain ⟨same,last⟩ := rhs_eval args s.heap s.buf s.locals locals value acc lo cell j bits evaluated
    subst value
    cases assigned with
    | set => simp only [withLocals,localSet,C99ScalarReference.set,ite_true,convert_word]
    | compound op binary old rhs z operator operation => cases operator

theorem append_low (args : Args) (s t : State) (flow : Flow) (acc lo : BitVec 32) (pending : Nat)
    (width : pending+9≤32) (small : lo.toNat<512)
    (cell : s.locals.scalars "acc".toList=some (.uint32,some (.uint32 acc)))
    (j : s.locals.scalars "j".toList=some (.int32,some (.int32 8)))
    (bits : s.locals.scalars "lo".toList=some (.uint32,some (.uint32 lo)))
    (source : Exec args KeygenCodecStaticBinding.node040 s t flow) :
    ∃ word : BitVec 32, t.locals.scalars "acc".toList=some (.uint32,some (.uint32 word)) ∧
      KeygenCodecStaticSuffix.low word (pending+9)=KeygenCodecStaticSuffix.low acc pending*512+lo.toNat := by
  exact ⟨_,append_step args s t flow acc lo cell j bits source,
    KeygenCodecStaticSuffix.low_append acc lo pending 9 width small⟩

end FT1536.Source3.KeygenCodecStaticAppend
