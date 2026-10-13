import Source3.KeygenDecodeStaticCoefficient

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual ++u>=n outer termination test, deriving the next uint64 cursor
   and stopping at1536 without wrap. The final padding/return branch is next. -/
namespace FT1536.Source3.KeygenDecodeStaticOuterCounter
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified

def next (s : State) (u : Nat) : State :=
  withLocals s (localSet s.locals "u".toList .uint64 (some (.uint64 (BitVec.ofNat 64 (u+1)))))

theorem self64 (word : BitVec 64) : C99IntegerReference.convert .uint64
    (C99IntegerReference.Value.uint64 word).integer=.uint64 word := by
  simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,
    BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem comparison (u : Nat) (bound : u<1536) :
    C99IntegerReference.CompareExec .ge (.uint64 (BitVec.ofNat 64 (u+1))) (.uint64 1536)
      (.int32 (if u+1=1536 then 1 else 0)) := by
  have source := C99IntegerReference.CompareExec.step .ge (.uint64 (BitVec.ofNat 64 (u+1))) (.uint64 1536)
    .uint64 rfl (.uint64 (BitVec.ofNat 64 (u+1))) (.uint64 1536) (self64 _).symm rfl
  have value := KeygenCodecNoneCursor.unsigned_nat64 (u+1) (by omega)
  have limit : (C99IntegerReference.Value.uint64 1536).integer=(1536 : Int) := rfl
  rw [value,limit] at source
  by_cases last : u+1=1536
  · have concrete : u=1535 := by omega
    subst u
    convert source using 1; decide +kernel
  · have no : ¬(1536 : Int)≤((u+1 : Nat) : Int) := by omega
    simpa only [C99IntegerReference.compare,no,decide_false,Bool.false_eq_true,ite_false,last,
      show (0#32 : BitVec 32)=0 by decide +kernel] using source

theorem calculation (args : Args) (s : State) (u : Nat) (bound : u<1536)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (count : Cell "n" .uint64 (.uint64 1536) s.locals) :
    KeygenDecodeDynamicCalculation.Computes args s.heap s.buf KeygenDecodeStaticBinding.guard096 s.locals
      (.int32 (if u+1=1536 then 1 else 0)) (next s u).locals := by
  have update : KeygenDecodeDynamicCalculation.ScalarUpdate "u".toList 1 s.locals
      (.uint64 (BitVec.ofNat 64 u)) (.uint64 (BitVec.ofNat 64 (u+1))) (next s u).locals :=
    .scalar (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) .uint64 cursor _
      (KeygenDecodeNoneRead.plus64 u 1 (by omega) (by decide +kernel)) (self64 _).symm rfl
  have n : Cell "n" .uint64 (.uint64 1536) (next s u).locals := by
    simpa only [Cell,next,withLocals,localSet,C99ScalarReference.set,
      show "n".toList≠"u".toList by decide +kernel,ite_false] using count
  exact .binary _ _ _ _ _ _ _ _ _ (.preInc _ _ _ _ _ update)
    (.pure _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) n))
    (.ge _ _ _ (comparison u bound))

theorem source_nonfinal (args : Args) (s : State) (u : Nat) (bound : u+1<1536)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (count : Cell "n" .uint64 (.uint64 1536) s.locals) :
    Checked args KeygenDecodeStaticBinding.node096 s (next s u) .normal := by
  have source := branch_false args KeygenDecodeStaticBinding.guard096 KeygenDecodeStaticBinding.node095 .skip
    s (next s u) .normal _ (next s u).locals (calculation args s u (by omega) cursor count)
    (by simp only [show u+1≠1536 by omega,ite_false]; decide +kernel)
    (by exact skip args (next s u))
  exact source

end FT1536.Source3.KeygenDecodeStaticOuterCounter
