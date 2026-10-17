import Source3.PublicGenerateTable159
import Source3.C99NatWord141
import Source3.PublicGenerateHead159
import Source3.PublicRevSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Forward scalar evaluations and store addresses for the three mq_mkgm3
   suffix loops: the bit-reversed row indices, the doubled upper/square
   indices and the exact loop guards. Word expressions drive loop guards
   and scalar updates; CLogic expressions drive store/load addresses. All
   results are source operations on executed slots; no table value enters. -/
namespace FT1536.Source3.PublicGenerateIndex159
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value Ty)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval Address)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenMkgm3Indices (lastIndex reverse9)
open KeygenPublicLastProgram (shifted index nextU)

theorem u32_integer (r : Nat) (hr : r<2^32) :
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 r)).integer=(r:Int) :=
  congrArg (fun k : Nat => (k : Int)) (Nat.mod_eq_of_lt hr)

theorem convert_u32_u64 (r : Nat) (hr : r<2^32) :
    u64 r=C99IntegerReference.convert .uint64
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 r)).integer := by
  rw [u32_integer r hr,KeygenNttLoopSupport.convert_u64_nat]

/- Source operations on executed values. -/
theorem shl_one (i : Nat) (hi : i<2^64) (y : Value) (hy : y.integer=1) :
    C99IntegerReference.ShiftExec .left (u64 i) y (u64 (2*i)) := by
  have raw := C99IntegerReference.ShiftExec.unsignedLeft (u64 i) y 1
    rfl (hy.trans (rfl : (1:Int)=1)) (by decide : (1:Nat)<64)
  change C99IntegerReference.ShiftExec .left (u64 i) y
    (C99IntegerReference.convert .uint64 ((u64 i).integer*2^1)) at raw
  rw [pow_one,KeygenNttLoopSupport.convert_mul_two i hi] at raw
  have comm : i*2=2*i := Nat.mul_comm i 2
  rw [comm] at raw
  exact raw

theorem shl_pow (n : Nat) (y : Value) (hy : y.integer=(n:Int)) (bound : n<64) :
    C99IntegerReference.ShiftExec .left (u64 1) y (u64 (2^n)) := by
  have raw := C99IntegerReference.ShiftExec.unsignedLeft (u64 1) y n
    rfl hy bound
  change C99IntegerReference.ShiftExec .left (u64 1) y
    (C99IntegerReference.convert .uint64 ((u64 1).integer*2^n)) at raw
  have one : (u64 1).integer=(1:Int) := KeygenNttLoopSupport.u64_integer 1 (by decide)
  rw [one,one_mul] at raw
  have power : ((2:Int)^n)=((2^n : Nat):Int) := by norm_num
  rw [power,KeygenNttLoopSupport.convert_u64_nat] at raw
  exact raw

theorem add_two (i : Nat) (hi : i<2^64) :
    C99IntegerReference.ArithmeticExec .plus (u64 i)
      (C99IntegerReference.convert .int32 2) (u64 (i+2)) := by
  have raw := C99IntegerReference.ArithmeticExec.step .plus (u64 i)
    (C99IntegerReference.convert .int32 2) .uint64 rfl
    (u64 i) (u64 2) (C99CountedWords.convert_self (u64 i)).symm rfl
    (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .plus (u64 i)
    (C99IntegerReference.convert .int32 2)
    (C99IntegerReference.convert .uint64 ((u64 i).integer+(u64 2).integer)) at raw
  rw [KeygenNttLoopSupport.u64_integer i hi,KeygenNttLoopSupport.u64_integer 2 (by decide)] at raw
  have sum : ((i:Nat):Int)+((2:Nat):Int)=(((i+2:Nat)):Int) := by omega
  rw [sum,KeygenNttLoopSupport.convert_u64_nat] at raw
  exact raw

theorem sub_one (i : Nat) (hi : 1 ≤ i) (bound : i<2^64) :
    C99IntegerReference.ArithmeticExec .minus (u64 i)
      (C99IntegerReference.convert .int32 1) (u64 (i-1)) := by
  have raw := C99IntegerReference.ArithmeticExec.step .minus (u64 i)
    (C99IntegerReference.convert .int32 1) .uint64 rfl
    (u64 i) (u64 1) (C99CountedWords.convert_self (u64 i)).symm rfl
    (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .minus (u64 i)
    (C99IntegerReference.convert .int32 1)
    (C99IntegerReference.convert .uint64 ((u64 i).integer-(u64 1).integer)) at raw
  rw [KeygenNttLoopSupport.u64_integer i bound,KeygenNttLoopSupport.u64_integer 1 (by decide)] at raw
  have diff : ((i:Nat):Int)-((1:Nat):Int)=(((i-1:Nat)):Int) := by omega
  rw [diff,KeygenNttLoopSupport.convert_u64_nat] at raw
  exact raw

theorem u32_add_one (k : Nat) (hk : k+1<2^32) :
    C99IntegerReference.ArithmeticExec .plus
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 k))
      (C99IntegerReference.convert .int32 1)
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 (k+1))) := by
  have raw := C99IntegerReference.ArithmeticExec.step .plus
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 k))
    (C99IntegerReference.convert .int32 1) .uint32 rfl
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 k))
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 1))
    (C99CountedWords.convert_self _).symm rfl (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .plus
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 k))
    (C99IntegerReference.convert .int32 1)
    (C99IntegerReference.convert .uint32
      ((C99IntegerReference.Value.uint32 (BitVec.ofNat 32 k)).integer+
        (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 1)).integer)) at raw
  rw [u32_integer k (Nat.lt_of_succ_lt hk),u32_integer 1 (by decide)] at raw
  have sum : ((k:Nat):Int)+((1:Nat):Int)=(((k+1:Nat)):Int) := by omega
  rw [sum] at raw
  exact raw

theorem plus_u64_u32 (x r : Nat) (hx : x<2^64) (hr : r<2^32) :
    C99IntegerReference.ArithmeticExec .plus (u64 x)
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 r)) (u64 (x+r)) := by
  have raw := C99IntegerReference.ArithmeticExec.step .plus (u64 x)
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 r)) .uint64 rfl
    (u64 x) (u64 r) (C99CountedWords.convert_self (u64 x)).symm (convert_u32_u64 r hr)
    (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .plus (u64 x)
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 r))
    (C99IntegerReference.convert .uint64 ((u64 x).integer+(u64 r).integer)) at raw
  rw [KeygenNttLoopSupport.u64_integer x hx,KeygenNttLoopSupport.u64_integer r (by omega)] at raw
  have sum : ((x:Nat):Int)+((r:Nat):Int)=(((x+r:Nat)):Int) := by omega
  rw [sum,KeygenNttLoopSupport.convert_u64_nat] at raw
  exact raw

theorem compare_gt_zero (i : Nat) (hi : i<2^64) :
    C99IntegerReference.CompareExec .gt (u64 i)
      (C99IntegerReference.convert .int32 0)
      (C99ScalarReference.boolean (decide (0 < i))) := by
  have raw := C99IntegerReference.CompareExec.step .gt (u64 i)
    (C99IntegerReference.convert .int32 0) .uint64 rfl
    (u64 i) (u64 0) (C99CountedWords.convert_self (u64 i)).symm rfl
  change C99IntegerReference.CompareExec .gt (u64 i)
    (C99IntegerReference.convert .int32 0)
    (C99ScalarReference.boolean
      (C99IntegerReference.compare .gt (u64 i).integer (u64 0).integer)) at raw
  rw [KeygenNttLoopSupport.u64_integer i hi,KeygenNttLoopSupport.u64_integer 0 (by decide)] at raw
  have same : C99IntegerReference.compare .gt ((i:Nat):Int) ((0:Nat):Int)=decide (0 < i) := by
    simp [C99IntegerReference.compare]
  rw [same] at raw
  exact raw

/- CLogic scalar evaluations: store/load addresses and the row loop. -/
theorem var_u64 (s : State) (name : String) (n : Nat) (slot : USlot s name n) :
    KeygenPublicWord.scalar s (CLogic.Expr.var name.toList) (u64 n) :=
  C99ScalarReference.Eval.variable name.toList .uint64 (u64 n) slot

theorem var_u32 (s : State) (name : String) (w : BitVec 32) (slot : Slot s name w) :
    KeygenPublicWord.scalar s (CLogic.Expr.var name.toList) (.uint32 w) :=
  C99ScalarReference.Eval.variable name.toList .uint32 (.uint32 w) slot

theorem lit_i32 (s : State) (n : Nat) :
    KeygenPublicWord.scalar s (CLogic.Expr.literal .i32 n)
      (C99IntegerReference.convert .int32 n) :=
  C99ScalarReference.Eval.literal .int32 n

theorem shl_double (s : State) (i : Nat) (hi : i<2^64) (slot : USlot s "u" i) :
    KeygenPublicWord.scalar s
      (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))
      (u64 (2*i)) :=
  C99ScalarReference.Eval.shift .left _ _ _ _ _
    (var_u64 s "u" i slot) (lit_i32 s 1)
    (shl_one i hi _ (rfl : (C99IntegerReference.convert .int32 1).integer=1))

theorem next_eval (s : State) (i : Nat) (hi : i<512) (u : USlot s "u" i) :
    KeygenPublicWord.scalar s nextU (u64 (i+1)) :=
  C99ScalarReference.Eval.arithmetic .plus _ _ _ _ _
    (var_u64 s "u" i u) (lit_i32 s 1) (C99NatWord141.add_one i (by omega))

/- Word-expression evaluations: loop guards and scalar updates. -/
theorem word_cast_u64_one (s : State) :
    Eval [] s (.cast .uint64 (KeygenPublicTableAtoms.literal 1)) (u64 1) :=
  KeygenPublicWord.Eval.cast .uint64 _ _ (PublicGenerateHead159.eval_lit s 1)

theorem word_shl_count (s : State) (k : Nat) (hk : k+1<2^32)
    (slot : Slot s "k" (BitVec.ofNat 32 k)) :
    Eval [] s (.bin .add (KeygenPublicTableAtoms.var "k")
      (KeygenPublicTableAtoms.literal 1))
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 (k+1))) :=
  KeygenPublicWord.Eval.bin .add _ _ _ _ _
    (PublicGenerateHead159.eval_var s "k" _ slot) (PublicGenerateHead159.eval_lit s 1)
    (u32_add_one k hk)

theorem word_shl_upper (s : State) (k : Nat) (hk : k+1<64)
    (slot : Slot s "k" (BitVec.ofNat 32 k)) :
    Eval [] s (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
      (.bin .add (KeygenPublicTableAtoms.var "k") (KeygenPublicTableAtoms.literal 1)))
      (u64 (2^(k+1))) :=
  KeygenPublicWord.Eval.bin .shl _ _ _ _ _
    (word_cast_u64_one s) (word_shl_count s k (Nat.lt_of_lt_of_le hk (by norm_num)) slot)
    (shl_pow (k+1) _ (u32_integer (k+1) (Nat.lt_of_lt_of_le hk (by norm_num))) hk)

theorem word_shl_base (s : State) (k : Nat) (hk : k<64)
    (slot : Slot s "k" (BitVec.ofNat 32 k)) :
    Eval [] s (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
      (KeygenPublicTableAtoms.var "k")) (u64 (2^k)) :=
  KeygenPublicWord.Eval.bin .shl _ _ _ _ _
    (word_cast_u64_one s) (PublicGenerateHead159.eval_var s "k" _ slot)
    (shl_pow k _ (u32_integer k (Nat.lt_of_lt_of_le hk (by norm_num))) hk)

theorem word_shl_sub_one (s : State) (k : Nat) (hk : k<64)
    (one : 1 ≤ 2^k) (big : 2^k < 2^64) (slot : Slot s "k" (BitVec.ofNat 32 k)) :
    Eval [] s (.bin .sub (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
      (KeygenPublicTableAtoms.var "k")) (KeygenPublicTableAtoms.literal 1))
      (u64 (2^k-1)) :=
  KeygenPublicWord.Eval.bin .sub _ _ _ _ _
    (word_shl_base s k hk slot) (PublicGenerateHead159.eval_lit s 1)
    (sub_one (2^k) one big)

theorem word_shl_double (s : State) (i : Nat) (hi : i<2^64) (slot : USlot s "u" i) :
    Eval [] s (.bin .shl (KeygenPublicTableAtoms.var "u")
      (KeygenPublicTableAtoms.literal 1)) (u64 (2*i)) :=
  KeygenPublicWord.Eval.bin .shl _ _ _ _ _
    (KeygenPublicWord.Eval.scalar _ _ (var_u64 s "u" i slot))
    (PublicGenerateHead159.eval_lit s 1)
    (shl_one i hi _ (rfl : (C99IntegerReference.convert .int32 1).integer=1))

theorem word_guard_gt (s : State) (i : Nat) (hi : i<2^64) (slot : USlot s "u" i) :
    Eval [] s (.cmp .gt (KeygenPublicTableAtoms.var "u")
      (KeygenPublicTableAtoms.literal 0))
      (C99ScalarReference.boolean (decide (0 < i))) :=
  KeygenPublicWord.Eval.cmp .gt _ _ _ _ _
    (KeygenPublicWord.Eval.scalar _ _ (var_u64 s "u" i slot))
    (PublicGenerateHead159.eval_lit s 0)
    (compare_gt_zero i hi)

/- Bit-reversed row indices of the first suffix loop. -/
theorem shl_row (i : Nat) (hi : i<512) (y : Value) (hy : y.integer=1) :
    C99IntegerReference.ShiftExec .left (u64 i) y (u64 (2*i)) :=
  shl_one i (by omega) y hy

theorem shifted_u (s : State) (i : Nat) (hi : i<512) (k : Slot s "k" 1) (u : USlot s "u" i) :
    KeygenPublicWord.scalar s (shifted (CLogic.Expr.var "u".toList))
      (.uint32 (BitVec.ofNat 32 (2*i))) := by
  have shift : KeygenPublicWord.scalar s
      (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.var "k".toList))
      (u64 (2*i)) :=
    C99ScalarReference.Eval.shift .left _ _ _ _ _ (var_u64 s "u" i u) (var_u32 s "k" 1 k)
      (shl_row i hi _ (rfl : (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 1)).integer=1))
  have cast : KeygenPublicWord.scalar s (shifted (CLogic.Expr.var "u".toList))
      (C99IntegerReference.convert .uint32 (u64 (2*i)).integer) :=
    C99ScalarReference.Eval.cast .uint32 _ _ shift
  have same : (C99IntegerReference.convert .uint32 (u64 (2*i)).integer)=
      .uint32 (BitVec.ofNat 32 (2*i)) := by
    rw [KeygenNttLoopSupport.u64_integer (2*i) (by omega)]
    show C99IntegerReference.Value.uint32 (BitVec.ofInt 32 ((2*i:Nat):Int))=_
    rw [BitVec.ofInt_natCast]
  rw [same] at cast
  exact cast

theorem shifted_next (s : State) (i : Nat) (hi : i+1<512) (k : Slot s "k" 1) (u : USlot s "u" i) :
    KeygenPublicWord.scalar s (shifted nextU)
      (.uint32 (BitVec.ofNat 32 (2*(i+1)))) := by
  have shift : KeygenPublicWord.scalar s
      (CLogic.Expr.bin .shl nextU (CLogic.Expr.var "k".toList))
      (u64 (2*(i+1))) :=
    C99ScalarReference.Eval.shift .left _ _ _ _ _ (next_eval s i (by omega) u) (var_u32 s "k" 1 k)
      (shl_row (i+1) (by omega) _
        (rfl : (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 1)).integer=1))
  have cast : KeygenPublicWord.scalar s (shifted nextU)
      (C99IntegerReference.convert .uint32 (u64 (2*(i+1))).integer) :=
    C99ScalarReference.Eval.cast .uint32 _ _ shift
  have same : (C99IntegerReference.convert .uint32 (u64 (2*(i+1))).integer)=
      .uint32 (BitVec.ofNat 32 (2*(i+1))) := by
    rw [KeygenNttLoopSupport.u64_integer (2*(i+1)) (by omega)]
    show C99IntegerReference.Value.uint32 (BitVec.ofInt 32 (((2*(i+1)):Nat):Int))=_
    rw [BitVec.ofInt_natCast]
  rw [same] at cast
  exact cast

theorem rev_call_u (i : Nat) (hi : i<512) :
    KeygenPublicScalar.Call (KeygenPublicScalar.name .rev)
      [.uint32 (BitVec.ofNat 32 (2*i))] (.uint32 (BitVec.ofNat 32 (reverse9 i))) := by
  have base := PublicRevSource157.source (.u32 (BitVec.ofNat 32 (2*i)))
  have eq := (KeygenPublicRevCert.source_last_index i hi _ base).1
  rw [← eq]
  exact base

theorem rev_call_next (i : Nat) (hi : i+1<512) :
    KeygenPublicScalar.Call (KeygenPublicScalar.name .rev)
      [.uint32 (BitVec.ofNat 32 (2*(i+1)))] (.uint32 (BitVec.ofNat 32 (reverse9 (i+1)))) := by
  have base := PublicRevSource157.source (.u32 (BitVec.ofNat 32 (2*(i+1))))
  have eq := (KeygenPublicRevCert.source_last_index (i+1) (by omega) _ base).1
  rw [← eq]
  exact base

theorem rev_u (s : State) (i : Nat) (hi : i<512) (k : Slot s "k" 1) (u : USlot s "u" i) :
    KeygenPublicWord.scalar s
      (CLogic.Expr.call1 (KeygenPublicScalar.name .rev) (shifted (CLogic.Expr.var "u".toList)))
      (.uint32 (BitVec.ofNat 32 (reverse9 i))) :=
  C99ScalarReference.Eval.call1 _ _ _ _ (shifted_u s i hi k u) (rev_call_u i hi)

theorem rev_next (s : State) (i : Nat) (hi : i+1<512) (k : Slot s "k" 1) (u : USlot s "u" i) :
    KeygenPublicWord.scalar s
      (CLogic.Expr.call1 (KeygenPublicScalar.name .rev) (shifted nextU))
      (.uint32 (BitVec.ofNat 32 (reverse9 (i+1)))) :=
  C99ScalarReference.Eval.call1 _ _ _ _ (shifted_next s i hi k u) (rev_call_next i hi)

theorem index_u (s : State) (i : Nat) (hi : i<512) (k : Slot s "k" 1) (b : USlot s "b" 512)
    (u : USlot s "u" i) :
    KeygenPublicWord.scalar s (index (CLogic.Expr.var "u".toList)) (u64 (lastIndex i)) :=
  C99ScalarReference.Eval.arithmetic .plus _ _ _ _ _ (var_u64 s "b" 512 b) (rev_u s i hi k u)
    (plus_u64_u32 512 (reverse9 i) (by decide)
      (by have := (KeygenMkgm3IndexCert.all_indices i (by omega)).1 hi; omega))

theorem index_next (s : State) (i : Nat) (hi : i+1<512) (k : Slot s "k" 1) (b : USlot s "b" 512)
    (u : USlot s "u" i) :
    KeygenPublicWord.scalar s (index nextU) (u64 (lastIndex (i+1))) :=
  C99ScalarReference.Eval.arithmetic .plus _ _ _ _ _ (var_u64 s "b" 512 b) (rev_next s i hi k u)
    (plus_u64_u32 512 (reverse9 (i+1)) (by decide)
      (by have := (KeygenMkgm3IndexCert.all_indices (i+1) (by omega)).1 (by omega); omega))

/- Store/load addresses: the counter slot is always "u", the array any of gm/igm. -/
theorem pointer_within (p : ArrayPointer) (i : Nat) (capacity : p.index+i ≤ p.count) :
    C99MemoryReference.PointerAdd p i (KeygenSmallOutput.element p i) :=
  C99MemoryReference.PointerAdd.within p i capacity

theorem lastIndex_lt (i : Nat) (hi : i<512) : lastIndex i < 1024 :=
  (KeygenMkgm3Table.last_range i hi).2

theorem lastIndex_big (i : Nat) (hi : i<512) : lastIndex i < 2^64 := by
  have := lastIndex_lt i hi
  omega

theorem address_u64 (s : State) (name : String) (p : ArrayPointer) (i : Nat) (hi : i<2^64)
    (binding : s.arrays name.toList=some p) (slot : USlot s "u" i)
    (capacity : p.index+i ≤ p.count) :
    Address s name.toList (CLogic.Expr.var "u".toList) (KeygenSmallOutput.element p i) :=
  .add name.toList _ p _ (u64 i) binding (var_u64 s "u" i slot)
    (by rw [KeygenNttLoopSupport.u64_integer i hi]; omega)
    (by rw [KeygenNttLoopSupport.u64_toNat i hi]; exact pointer_within p i capacity)

theorem address_shifted (s : State) (name : String) (p : ArrayPointer) (i : Nat) (hi : i<2^63)
    (binding : s.arrays name.toList=some p) (slot : USlot s "u" i)
    (capacity : p.index+2*i ≤ p.count) :
    Address s name.toList
      (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))
      (KeygenSmallOutput.element p (2*i)) :=
  .add name.toList _ p _ (u64 (2*i)) binding (shl_double s i (by omega) slot)
    (by rw [KeygenNttLoopSupport.u64_integer (2*i) (by omega)]; omega)
    (by rw [KeygenNttLoopSupport.u64_toNat (2*i) (by omega)]; exact pointer_within p (2*i) capacity)

theorem address_index (s : State) (name : Name) (p : ArrayPointer) (i : Nat) (hi : i<512)
    (k : Slot s "k" 1) (b : USlot s "b" 512) (u : USlot s "u" i)
    (binding : s.arrays name=some p) (capacity : p.index+1024 ≤ p.count) :
    Address s name (index (CLogic.Expr.var "u".toList))
      (KeygenSmallOutput.element p (lastIndex i)) := by
  have big := lastIndex_big i hi
  have small := lastIndex_lt i hi
  refine .add name _ p _ (u64 (lastIndex i)) binding (index_u s i hi k b u) ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (lastIndex i) big]
    omega
  · rw [KeygenNttLoopSupport.u64_toNat (lastIndex i) big]
    exact pointer_within p (lastIndex i) (by omega)

theorem address_index_next (s : State) (name : Name) (p : ArrayPointer) (i : Nat) (hi : i+1<512)
    (k : Slot s "k" 1) (b : USlot s "b" 512) (u : USlot s "u" i)
    (binding : s.arrays name=some p) (capacity : p.index+1024 ≤ p.count) :
    Address s name (index nextU)
      (KeygenSmallOutput.element p (lastIndex (i+1))) := by
  have big := lastIndex_big (i+1) (by omega)
  have small := lastIndex_lt (i+1) (by omega)
  refine .add name _ p _ (u64 (lastIndex (i+1))) binding (index_next s i hi k b u) ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (lastIndex (i+1)) big]
    omega
  · rw [KeygenNttLoopSupport.u64_toNat (lastIndex (i+1)) big]
    exact pointer_within p (lastIndex (i+1)) (by omega)

end FT1536.Source3.PublicGenerateIndex159
