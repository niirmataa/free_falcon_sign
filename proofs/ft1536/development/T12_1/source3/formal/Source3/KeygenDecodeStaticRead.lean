import Source3.KeygenDecodeStaticCertifiedStore
import Source3.KeygenDecodeStaticWordOps

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The two actual refill RHSs, with physical buf[v++] and its uint64
   activation update. The db word may retain arbitrary old high bits. -/
namespace FT1536.Source3.KeygenDecodeStaticRead
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenDecodeStaticCertified
open KeygenDecodeWordOps

def cursor (v : Nat) (l : Locals) : Prop :=
  l.scalars "v".toList=some (.uint64,some (.uint64 (BitVec.ofNat 64 v)))
def next (v : Nat) (l : Locals) : Locals :=
  localSet l "v".toList .uint64 (some (.uint64 (BitVec.ofNat 64 (v+1))))
def readRhs : Expr := .index (.variable "buf".toList) (.postInc (.variable "v".toList))
def appendRhs : Expr := .binary .add (.binary .shl (.variable "db".toList) (.number .i32 8)) readRhs

theorem increment (v : Nat) (l : Locals) (bound : v+1<2^64) (held : cursor v l) :
    ScalarUpdate "v".toList 1 l (.uint64 (BitVec.ofNat 64 v))
      (.uint64 (BitVec.ofNat 64 (v+1))) (next v l) :=
  .scalar (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) .uint64 held _
    (KeygenDecodeNoneRead.plus64 v 1 bound (by decide +kernel))
    (by simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]) rfl

theorem calculation (args : Args) (s : State) (v : Nat) (bound : v+1<2^64)
    (src atByte : ArrayPointer) (word : BitVec 8) (held : cursor v s.locals)
    (buf : s.buf=some (some src)) (advance : PointerAdd src v atByte) (load : LoadByte s.heap atByte word) :
    Computes args s.heap s.buf readRhs s.locals (.int32 (BitVec.ofNat 32 word.toNat)) (next v s.locals) := by
  apply Computes.byteIndex _ _ _ src atByte (.uint64 (BitVec.ofNat 64 v)) word buf
    (.postInc _ _ _ _ _ (increment v s.locals bound held))
  · rw [KeygenCodecNoneCursor.unsigned_nat64 v (by omega)]; omega
  · rw [KeygenCodecNoneCursor.unsigned_nat64 v (by omega)]
    exact advance
  · exact load

theorem append_calculation (args : Args) (s : State) (v : Nat) (bound : v+1<2^64)
    (src atByte : ArrayPointer) (word : BitVec 8) (db : BitVec 32) (held : cursor v s.locals)
    (dbCell : s.locals.scalars "db".toList=some (.uint32,some (.uint32 db)))
    (buf : s.buf=some (some src)) (advance : PointerAdd src v atByte) (load : LoadByte s.heap atByte word) :
    Computes args s.heap s.buf appendRhs s.locals
      (.uint32 ((db <<< 8)+word.setWidth 32)) (next v s.locals) := by
  have shifted : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals
      (.binary .shl (.variable "db".toList) (.number .i32 8)) (.uint32 (db <<< 8)) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) dbCell)
      (.number _ _ _ (by decide +kernel)) (.shl _ _ _ (left32 db 8 (by decide +kernel)))
  have add := KeygenDecodeStaticWordOps.plus_int32 (db <<< 8) word.toNat
    (by have bound:=word.isLt; omega)
  have equivalent : BitVec.ofNat 32 word.toNat=word.setWidth 32 := BitVec.ofNat_toNat 32 word
  exact .binary _ _ _ _ _ _ _ _ _ (.pure _ _ _ shifted)
    (calculation args s v bound src atByte word held buf advance load) (.add _ _ _ (by simpa only [←equivalent] using add))

theorem source_append (args : Args) (s : State) (v : Nat) (bound : v+1<2^64)
    (src atByte : ArrayPointer) (word : BitVec 8) (db : BitVec 32) (held : cursor v s.locals)
    (dbCell : s.locals.scalars "db".toList=some (.uint32,some (.uint32 db)))
    (buf : s.buf=some (some src)) (advance : PointerAdd src v atByte) (load : LoadByte s.heap atByte word) :
    Checked args KeygenDecodeStaticBinding.node031 s
      (withLocals s (localSet (next v s.locals) "db".toList .uint32 (some (.uint32 ((db <<< 8)+word.setWidth 32))))) .normal := by
  have source := assign args s "db".toList .uint32 (some (.uint32 db)) appendRhs _ (next v s.locals)
    (by decide +kernel) (by decide +kernel) dbCell
    (append_calculation args s v bound src atByte word db held dbCell buf advance load)
  simpa only [self32,KeygenDecodeStaticBinding.node031,appendRhs,readRhs] using source

theorem source_single (args : Args) (s : State) (v : Nat) (bound : v+1<2^64)
    (src atByte : ArrayPointer) (word : BitVec 8) (old : Option IV) (held : cursor v s.locals)
    (dbCell : s.locals.scalars "db".toList=some (.uint32,old))
    (buf : s.buf=some (some src)) (advance : PointerAdd src v atByte) (load : LoadByte s.heap atByte word) :
    Checked args KeygenDecodeStaticBinding.node048 s
      (withLocals s (localSet (next v s.locals) "db".toList .uint32 (some (.uint32 (word.setWidth 32))))) .normal := by
  have source := assign args s "db".toList .uint32 old readRhs _ (next v s.locals)
    (by decide +kernel) (by decide +kernel) dbCell
    (calculation args s v bound src atByte word held buf advance load)
  have cast : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.int32 (BitVec.ofNat 32 word.toNat)).integer=.uint32 (word.setWidth 32) :=
    Option.some.inj (byte_cast32 word)
  simpa only [cast,KeygenDecodeStaticBinding.node048,readRhs] using source

end FT1536.Source3.KeygenDecodeStaticRead
