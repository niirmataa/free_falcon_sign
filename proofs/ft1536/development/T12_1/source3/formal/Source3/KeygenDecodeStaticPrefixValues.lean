import Source3.KeygenDecodeStaticPrefixLoop
import Source3.KeygenDecodeStaticBitSlice

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticPrefixValues
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeStaticReady KeygenDecodeWordOps

def signRhs : Expr := .binary .band
  (.binary .shr (.variable "db".toList) (.binary .sub (.variable "db_len".toList) (.number .i32 1))) (.number .i32 1)
def lowRhs : Expr := .binary .band (.binary .shr (.variable "db".toList) (.variable "db_len".toList)) (.variable "mask".toList)

theorem sign_calculation (args : Args) (s : State) (p : Nat) (db : BitVec 32)
    (lower : 1≤p) (upper : p≤16)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals)
    (acc : Cell "db" .uint32 (.uint32 db) s.locals) :
    Computes args s.heap s.buf s.locals signRhs (.uint32 ((db >>> (p-1)) &&& 1)) := by
  have decrement : Computes args s.heap s.buf s.locals
      (.binary .sub (.variable "db_len".toList) (.number .i32 1)) (.uint32 (BitVec.ofNat 32 (p-1))) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) pending)
      (.number _ _ _ (by decide +kernel))
      (.sub _ _ _ (KeygenDecodeStaticCounterOps.minus_nat32 p 1 (by decide +kernel) lower))
  have shifted : Computes args s.heap s.buf s.locals
      (.binary .shr (.variable "db".toList) (.binary .sub (.variable "db_len".toList) (.number .i32 1)))
      (.uint32 (db >>> (p-1))) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) acc) decrement
      (.shr _ _ _ (KeygenDecodeStaticWordOps.right_uint32 db (p-1) (by omega)))
  exact .binary _ _ _ _ _ _ shifted (.number _ _ _ (by decide +kernel))
    (.band _ _ _ (KeygenDecodeStaticWordOps.and_int32 _ 1 (by decide +kernel)))

theorem low_calculation (args : Args) (s : State) (p : Nat) (db : BitVec 32) (upper : p<8)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals)
    (acc : Cell "db" .uint32 (.uint32 db) s.locals)
    (mask : Cell "mask" .uint32 (.uint32 255) s.locals) :
    Computes args s.heap s.buf s.locals lowRhs (.uint32 ((db >>> p) &&& 255)) :=
  .binary _ _ _ _ _ _
    (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) acc)
      (.scalar _ _ _ (by unfold Ordinary; decide +kernel) pending)
      (.shr _ _ _ (KeygenDecodeStaticWordOps.right_uint32 db p (by omega))))
    (.scalar _ _ _ (by unfold Ordinary; decide +kernel) mask) (.band _ _ _ (and32 _ _))

theorem sign_bit (tail : List Bool) (bit : Bool) (db : BitVec 32)
    (held : KeygenCodecStaticBitBuffer.buffer (tail.length+1) db=bit::tail) :
    ((db >>> tail.length) &&& 1)=BitVec.ofNat 32 bit.toNat := by
  apply BitVec.eq_of_toNat_eq
  have masked := KeygenDecodeStaticBitSlice.mask (db >>> tail.length) 1 (by decide +kernel)
  change ((db >>> tail.length) &&& 1).toNat=(db >>> tail.length).toNat%2 at masked
  rw [masked,KeygenDecodeStaticBitRead.high_bit tail bit db held,BitVec.toNat_ofNat]
  exact (Nat.mod_eq_of_lt (by cases bit <;> decide +kernel)).symm

theorem low_bits (head tail : List Bool) (db : BitVec 32) (length : head.length=8)
    (held : KeygenCodecStaticBitBuffer.buffer (head.length+tail.length) db=head++tail) :
    ((db >>> tail.length) &&& 255)=BitVec.ofNat 32 (KeygenCodecStaticBits.value head) := by
  have heads := KeygenDecodeStaticBitSlice.head_bits head tail db held
  have values := congrArg KeygenCodecStaticBits.value heads
  rw [KeygenCodecStaticBitBuffer.buffer_value,length] at values
  apply BitVec.eq_of_toNat_eq
  have masked := KeygenDecodeStaticBitSlice.mask (db >>> tail.length) 8 (by decide +kernel)
  change ((db >>> tail.length) &&& 255).toNat=KeygenCodecStaticSuffix.low (db >>> tail.length) 8 at masked
  rw [masked,values,BitVec.toNat_ofNat]
  have less := KeygenCodecStaticBits.value_bound head
  rw [length] at less
  exact (Nat.mod_eq_of_lt (by omega)).symm

theorem source_sign : KeygenDecodeStaticBinding.node039=.write (.variable "sign".toList) .set signRhs := rfl
theorem source_low : KeygenDecodeStaticBinding.node041=.write (.variable "lo".toList) .set lowRhs := rfl

end FT1536.Source3.KeygenDecodeStaticPrefixValues
