import Source3.KeygenCodecStaticIteration

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticOuterControl
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticPending (normal_seq)

def Remaining (n : Nat) (l : Locals) : Prop :=
  l.scalars "n".toList=some (.uint64,some (.uint64 (BitVec.ofNat 64 n)))

theorem self_unsigned64 (a : BitVec 64) :
    C99IntegerReference.convert .uint64 (C99IntegerReference.Value.uint64 a).integer=.uint64 a := by
  simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,
    BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem decrement_value (n : Nat) (positive : 0<n) (upper : n≤1536) :
    C99IntegerReference.ArithmeticExec .plus (.uint64 (BitVec.ofNat 64 n)) (.int32 (-1))
      (.uint64 (BitVec.ofNat 64 (n-1))) := by
  have canonical := C99IntegerReference.ArithmeticExec.step .plus (.uint64 (BitVec.ofNat 64 n)) (.int32 (-1))
    .uint64 rfl (.uint64 (BitVec.ofNat 64 n)) (.uint64 (-1))
    (self_unsigned64 _).symm (by decide +kernel) (by intro h; cases h)
  have residue : BitVec.ofInt 64 ((n : Int)+18446744073709551615)=BitVec.ofNat 64 (n-1) := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_ofInt,BitVec.toNat_ofNat]
    omega
  simpa only [C99IntegerReference.exact,C99IntegerReference.Value.integer,
    BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show n<2^64 by omega),C99IntegerReference.convert,
    show ((-1 : BitVec 64).toNat : Int)=18446744073709551615 by decide +kernel,residue] using canonical

theorem decrement (args : Args) (s t : State) (n : Nat) (positive : 0<n) (upper : n≤1536)
    (cell : Remaining n s.locals)
    (source : Exec args KeygenCodecStaticBinding.node026 s t .normal) : Remaining (n-1) t.locals := by
  cases source with
  | evaluate args s e value locals evaluated =>
    cases evaluated with
    | postDec name before last old next updated =>
      cases updated with
      | scalar name delta before ty v z declared operation =>
        have equal : ty=.uint64 ∧ v=.uint64 (BitVec.ofNat 64 n) := by
          simpa only [Remaining,Option.some.injEq,Prod.mk.injEq,Option.some.injEq] using declared.symm.trans cell
        obtain ⟨rfl,rfl⟩ := equal
        have same := C99IntegerReference.arithmetic_deterministic _ _ _ _ _ operation (decrement_value n positive upper)
        simp only [Remaining,withLocals,localSet,C99ScalarReference.set,ite_true,same,self_unsigned64]

theorem test_eval (args : Args) (s : State) (l : Locals) (value : Value) (n : Nat)
    (upper : n≤1536) (cell : Remaining n s.locals)
    (source : Eval args s.heap s.buf KeygenCodecStaticBinding.guard102 s.locals value l) :
    truth value=decide (0<n) ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨same,last⟩ := KeygenCodecScalarCalculation.computes_eval args s.heap s.buf s.locals _ (.uint64 (BitVec.ofNat 64 n))
      (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) cell) middle x first
    subst x
    subst middle
    obtain ⟨same,last⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 0 (.int32 0) s.locals l y (by decide +kernel) second
    subst y
    cases operation with
    | gt x y z compared =>
      cases compared with
      | step ty ht a b ha hb =>
        subst ty
        subst a
        subst b
        constructor
        · simp only [C99IntegerReference.Value.type,C99IntegerReference.promote,C99IntegerReference.usual,
            C99IntegerReference.signed,C99IntegerReference.width,
            C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,
            BitVec.toNat_ofNat,
            Nat.mod_eq_of_lt (show n<2^64 by omega),C99IntegerReference.compare]
          by_cases positive : 0<n
          · simp [truth,positive,C99IntegerReference.Value.integer,Int.emod_eq_of_lt (show (0 : Int)≤n by omega) (show (n : Int)<18446744073709551616 by omega)]
          · simp [truth,positive,C99IntegerReference.Value.integer,Int.emod_eq_of_lt (show (0 : Int)≤n by omega) (show (n : Int)<18446744073709551616 by omega)]
        · exact last

/-- Every complete coefficient body decreases the actual remaining
    counter once, without uint64 wrap, from its reachable local range. -/
theorem body_remaining (args : Args) (s t : State) (n : Nat) (positive : 0<n) (upper : n≤1536)
    (cell : Remaining n s.locals)
    (source : Exec args KeygenCodecStaticBinding.node101 s t .normal) : Remaining (n-1) t.locals := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨s1,e0,rest⟩ := normal_seq args KeygenCodecStaticBinding.node022 KeygenCodecStaticBinding.node099 s t inside
    obtain ⟨s2,e1,rest⟩ := normal_seq args KeygenCodecStaticBinding.node023 KeygenCodecStaticBinding.node098 s1 t rest
    obtain ⟨s3,e2,rest⟩ := normal_seq args KeygenCodecStaticBinding.node024 KeygenCodecStaticBinding.node097 s2 t rest
    obtain ⟨s4,e3,rest⟩ := normal_seq args KeygenCodecStaticBinding.node025 KeygenCodecStaticBinding.node096 s3 t rest
    obtain ⟨s5,e4,rest⟩ := normal_seq args KeygenCodecStaticBinding.node026 KeygenCodecStaticBinding.node095 s4 t rest
    have kept := (KeygenCodecCellFrame.exec_frame "n".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "n".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "n".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "n".toList args _ s s1 .normal e0 (by decide +kernel)).trans cell)))
    have result := (KeygenCodecCellFrame.exec_frame "n".toList args _ s5 t .normal rest (by decide +kernel)).trans
      (decrement args s4 s5 n positive upper kept e4)
    simpa [Remaining,scopeExit,show scopeObjects KeygenCodecStaticBinding.node100=
      [⟨"w".toList,.i32,none⟩,⟨"lo".toList,.u32,none⟩,⟨"ne".toList,.i32,none⟩] from rfl] using result

end FT1536.Source3.KeygenCodecStaticOuterControl
