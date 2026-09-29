import Precast
import EncoderCount
import DecodeStatic
namespace Postprocess
def magnitude (w : Int) := if w<0 then -w else w
theorem source_magnitude (w : Int) (h : -32768≤w ∧ w≤32767) :
    0≤magnitude w ∧ magnitude w≤32768 ∧ magnitude w/256≤128 ∧
    magnitude w=256*(magnitude w/256)+magnitude w%256 := by
  unfold magnitude;split <;> omega
theorem coefficient_roundtrip (w : Int) (h : -32768≤w ∧ w≤32767) :
    (if w<0 then narrow16 (-narrow16 (magnitude w)) else narrow16 (magnitude w))=w := by
  unfold magnitude narrow16;split <;> omega
theorem no_negative_zero (w : Int) : w<0 → magnitude w≠0 := by
  intro h;unfold magnitude;split <;> omega
theorem byte_append (acc lo : Nat) (h : lo<512) :
    (acc*512+lo)%256=lo%256 ∧ (acc*512+lo)/512=acc := by omega
theorem unsigned_wrap_preserves_suffix (x k : Nat) (hk : k≤32) :
    (x%4294967296)%2^k=x%2^k := by
  have h : 2^k∣4294967296 := ⟨2^(32-k),by rw [←Nat.pow_add,show k+(32-k)=32 by omega]⟩
  exact Nat.mod_mod_of_dvd x h
theorem encoder_buffer_guard (u cap : Nat) : ¬u≥cap → u<cap := by omega
theorem encoder_header : (128+32+10:Nat)=170 := by decide
theorem narrowed_signed (a : Fin 1536→Int) : FT1536Bridge.SignedVec (fun i=>narrow16 (a i)) := by
  intro i;exact narrow_range (a i)
theorem stored_norm (a b : Fin 1536→Int) :
    (FT1536Bridge.isShort (fun i=>narrow16 (a i)) (fun i=>narrow16 (b i))=true ↔
      FT1536Bridge.Q (fun i=>narrow16 (a i)) (fun i=>narrow16 (b i))<2093922385) :=
  FT1536Bridge.STRICT_B _ _ (narrowed_signed a) (narrowed_signed b)
theorem stored_capacity (a b : Fin 1536→Int)
    (h : FT1536Bridge.isShort (fun i=>narrow16 (a i)) (fun i=>narrow16 (b i))=true) :
    FT1536M0.encodeCount 4095 (List.ofFn fun i=>narrow16 (b i))=
      some (FT1536M0.payloadLength (fun i=>narrow16 (b i))-1) ∧
    FT1536M0.payloadLength (fun i=>narrow16 (b i))≤3160 ∧
    FT1536M0.payloadLength (fun i=>narrow16 (b i))<4096 :=
  FT1536M0.STATIC_FITS_4096 _ _ (narrowed_signed a) (narrowed_signed b) h
end Postprocess
