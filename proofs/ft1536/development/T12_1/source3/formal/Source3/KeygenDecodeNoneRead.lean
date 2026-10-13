import Source3.KeygenDecodeNoneCore

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual NONE byte indices and high/low reconstruction. Byte loads carry
   physical allocation and initialization, never an assumed parse result. -/
namespace FT1536.Source3.KeygenDecodeNoneRead
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeWordOps KeygenDecodeNoneCore

abbrev Cursor (n : Nat) (l : Locals) := Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 n)) l

def index (d : Nat) : Expr := .binary .add
  (.binary .shl (.variable "u".toList) (.number .i32 1)) (.number .i32 d)
def joinRhs : Expr := .binary .bor
  (.binary .shl (.cast .u32 (.index (.variable "buf".toList) (index 0))) (.number .i32 8))
  (.cast .u32 (.index (.variable "buf".toList) (index 1)))

theorem twice64 (n : Nat) (bound : n≤1536) :
    C99IntegerReference.ShiftExec .left (.uint64 (BitVec.ofNat 64 n)) (.int32 1)
      (.uint64 (BitVec.ofNat 64 (2*n))) := by
  have source := C99IntegerReference.ShiftExec.unsignedLeft (.uint64 (BitVec.ofNat 64 n)) (.int32 1) 1 rfl rfl (by change (1 : Nat)<64; decide +kernel)
  have same : C99IntegerReference.convert .uint64
      ((C99IntegerReference.Value.uint64 (BitVec.ofNat 64 n)).integer*2^1)=.uint64 (BitVec.ofNat 64 (2*n)) := by
    rw [KeygenCodecNoneCursor.unsigned_nat64 n (by omega)]
    change C99IntegerReference.Value.uint64 (BitVec.ofInt 64 ((n : Int)*2))=_
    rw [show (n : Int)*2=((2*n : Nat) : Int) by omega,BitVec.ofInt_natCast]
  exact same ▸ source

theorem plus64 (n d : Nat) (bound : n+d<2^64) (small : d<2^31) :
    C99IntegerReference.ArithmeticExec .plus (.uint64 (BitVec.ofNat 64 n))
      (.int32 (BitVec.ofNat 32 d)) (.uint64 (BitVec.ofNat 64 (n+d))) := by
  have left : C99IntegerReference.convert .uint64
      (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 n)).integer=.uint64 (BitVec.ofNat 64 n) := by
    simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,
      BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  have right : C99IntegerReference.convert .uint64
      (C99IntegerReference.Value.int32 (BitVec.ofNat 32 d)).integer=.uint64 (BitVec.ofNat 64 d) := by
    rw [C99IntegerReference.Value.integer,KeygenCodecNoneCursor.signed_nat32 d small]
    rfl
  have source := C99IntegerReference.ArithmeticExec.step .plus
    (.uint64 (BitVec.ofNat 64 n)) (.int32 (BitVec.ofNat 32 d)) .uint64 rfl
    (.uint64 (BitVec.ofNat 64 n)) (.uint64 (BitVec.ofNat 64 d)) left.symm right.symm (by intro h; cases h)
  have same : C99IntegerReference.convert .uint64
      ((C99IntegerReference.Value.uint64 (BitVec.ofNat 64 n)).integer+
       (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 d)).integer)=.uint64 (BitVec.ofNat 64 (n+d)) := by
    rw [KeygenCodecNoneCursor.unsigned_nat64 n (by omega),KeygenCodecNoneCursor.unsigned_nat64 d (by omega)]
    change C99IntegerReference.Value.uint64 (BitVec.ofInt 64 ((n : Int)+(d : Int)))=_
    rw [←Int.natCast_add,BitVec.ofInt_natCast]
  exact same ▸ source

theorem index_calculation (args : Args) (s : State) (n d : Nat) (bound : n≤1536) (small : d≤1)
    (cursor : Cursor n s.locals) :
    Computes args s.heap s.buf s.locals (index d) (.uint64 (BitVec.ofNat 64 (2*n+d))) := by
  exact .binary _ _ _ _ _ _
    (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) cursor)
      (.number _ _ _ (by decide +kernel)) (.shl _ _ _ (twice64 n bound)))
    (.number _ _ _ (by
      change some (C99IntegerReference.Value.int32 (BitVec.ofInt 32 (BitVec.ofNat 64 d).toInt))=some (C99IntegerReference.Value.int32 (BitVec.ofNat 32 d))
      rw [KeygenCodecNoneCursor.signed_nat64 d (by omega),BitVec.ofInt_natCast]))
    (.add _ _ _ (plus64 (2*n) d (by omega) (by omega)))

theorem read_calculation (args : Args) (s : State) (n d : Nat) (bound : n≤1536) (small : d≤1)
    (cursor : Cursor n s.locals) (ptr atByte : ArrayPointer) (word : BitVec 8)
    (buffer : s.buf=some (some ptr)) (advance : PointerAdd ptr (2*n+d) atByte)
    (load : LoadByte s.heap atByte word) :
    Computes args s.heap s.buf s.locals (.index (.variable "buf".toList) (index d))
      (.int32 (BitVec.ofNat 32 word.toNat)) := by
  apply Computes.byteIndex _ ptr atByte (.uint64 (BitVec.ofNat 64 (2*n+d))) word buffer
    (index_calculation args s n d bound small cursor)
  · rw [KeygenCodecNoneCursor.unsigned_nat64 (2*n+d) (by omega)]; omega
  · rw [KeygenCodecNoneCursor.unsigned_nat64 (2*n+d) (by omega)]
    exact advance
  · exact load

theorem joined_calculation (args : Args) (s : State) (n : Nat) (bound : n≤1536)
    (cursor : Cursor n s.locals) (ptr hiPtr loPtr : ArrayPointer) (hi lo : BitVec 8)
    (buffer : s.buf=some (some ptr)) (hiStep : PointerAdd ptr (2*n) hiPtr)
    (loStep : PointerAdd ptr (2*n+1) loPtr) (high : LoadByte s.heap hiPtr hi) (low : LoadByte s.heap loPtr lo) :
    Computes args s.heap s.buf s.locals joinRhs (.uint32 (KeygenDecodeNoneScalar.joined hi lo)) := by
  have first := read_calculation args s n 0 bound (by decide +kernel) cursor ptr hiPtr hi buffer
    (by simpa only [Nat.add_zero] using hiStep) high
  have second := read_calculation args s n 1 bound (by decide +kernel) cursor ptr loPtr lo buffer loStep low
  have shifted : Computes args s.heap s.buf s.locals
      (.binary .shl (.cast .u32 (.index (.variable "buf".toList) (index 0))) (.number .i32 8))
      (.uint32 ((hi.setWidth 32) <<< 8)) :=
    .binary _ _ _ _ _ _ (.cast _ _ _ _ first (byte_cast32 hi))
      (.number _ _ _ (by decide +kernel)) (.shl _ _ _ (left32 _ 8 (by decide +kernel)))
  have joined : Computes args s.heap s.buf s.locals joinRhs
      (.uint32 (((hi.setWidth 32) <<< 8) ||| lo.setWidth 32)) :=
    .binary _ _ _ _ _ _ shifted (.cast _ _ _ _ second (byte_cast32 lo)) (.bor _ _ _ (or32 _ _))
  simpa only [joined_bytes] using joined

/-- The actual source assignment derives the reconstructed word from its
    two physical byte loads; no output word is supplied as a premise. -/
theorem joined_source (args : Args) (s t : State) (flow : Flow) (n : Nat) (bound : n≤1536)
    (cursor : Cursor n s.locals) (ptr hiPtr loPtr : ArrayPointer) (hi lo : BitVec 8)
    (buffer : s.buf=some (some ptr)) (hiStep : PointerAdd ptr (2*n) hiPtr)
    (loStep : PointerAdd ptr (2*n+1) loPtr) (high : LoadByte s.heap hiPtr hi) (low : LoadByte s.heap loPtr lo)
    (declaredW : s.locals.scalars "w".toList=some (.uint32,none))
    (source : Exec args KeygenDecodeNoneBinding.node022 s t flow) :
    t=withLocals s (localSet s.locals "w".toList .uint32
      (some (.uint32 (KeygenDecodeNoneScalar.joined hi lo)))) ∧ flow=.normal := by
  have result := assign_set args s t flow "w".toList .uint32 none joinRhs _ declaredW
    (joined_calculation args s n bound cursor ptr hiPtr loPtr hi lo buffer hiStep loStep high low) source
  simpa only [self32] using result

end FT1536.Source3.KeygenDecodeNoneRead
