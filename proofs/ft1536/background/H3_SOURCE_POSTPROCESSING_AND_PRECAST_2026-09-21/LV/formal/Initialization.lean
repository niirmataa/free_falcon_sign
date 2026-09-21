import VerifyBytes
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge
open FT1536Global

def writeDecoded (base : Nat) : List Int → Mem → Mem
  | [],m => m
  | x::xs,m => writeDecoded (base+1) xs (store m base x)
theorem write_below (xs : List Int) (base : Nat) (m : Mem) (i : Nat) (hi : i<base) :
    writeDecoded base xs m i=m i := by
  induction xs generalizing base m with
  | nil => rfl
  | cons x xs ih =>
    rw [writeDecoded,ih (base+1) (store m base x) (by omega),store_away _ base i x (by omega)]
theorem write_at (xs : List Int) (base : Nat) (m : Mem) (k : Nat) (hk : k<xs.length) :
    writeDecoded base xs m (base+k)=xs[k]'hk := by
  induction xs generalizing base m k with
  | nil => simp at hk
  | cons x xs ih =>
    cases k with
    | zero =>
      simp only [Nat.add_zero,List.getElem_cons_zero,writeDecoded]
      rw [write_below xs (base+1) _ base (by omega),store_at]
    | succ k =>
      have hk' : k<xs.length := by simpa using hk
      have he : base+(k+1)=(base+1)+k := by omega
      rw [writeDecoded,he,ih (base+1) (store m base x) k hk']
      rfl

theorem all_initialized (xs : List Int) (hlen : xs.length=1536) (initial : Mem) (i : Fin 1536) :
    writeDecoded 0 xs initial i.val=listVec xs i := by
  have hi : i.val<xs.length := by have h:=i.isLt;omega
  have h:=write_at xs 0 initial i.val hi
  simpa only [Nat.zero_add,listVec,List.getElem?_eq_getElem hi,Option.getD_some] using h

theorem signature_initializes (b : Bytes) (xs : List Int) (h : signature b=some xs) :
    ∀ initial : Mem, ∀ i : Fin 1536, writeDecoded 0 xs initial i.val=listVec xs i :=
  all_initialized xs (SIGNATURE_DECODE b xs h).2.1
theorem output_store_bounds (u : Nat) (hu : u<1536) :
    u<3072 ∧ u+1≤1536 ∧ u+1<18446744073709551616 ∧ 2*u+1<6144 := by omega
theorem cursor_counter_bounds (d : Bytes) (c : Cursor) (hlegal : LegalBytes d) (hc : Inv d c) :
    c.pos<18446744073709551616 ∧ c.db<4294967296 ∧ c.bits<32 := by
  unfold LegalBytes Inv Valid at *
  omega

theorem gcc_narrow16 (mag : Nat) (hm : mag<65536) :
    s16 (mag : Int)=if mag<32768 then (mag : Int) else (mag : Int)-65536 := by
  unfold s16
  split <;> omega
theorem static_negative_zero : staticValue 1 0=0 := by decide
theorem static_minimum_both_signs : staticValue 0 32768= -32768 ∧ staticValue 1 32768= -32768 := by decide
theorem static_maximum_magnitude : staticValue 0 65535= -1 ∧ staticValue 1 65535=1 := by decide
theorem public_failure_guard (d : Bytes) (hd : 0<d.length) :
    (match decodePK d with | none => 0 | some (_,ret) => ret)=d.length ↔ ∃ vs, decodePK d=some (vs,d.length) := by
  cases h : decodePK d with
  | none => simp;omega
  | some pair =>
    rcases pair with ⟨vs,ret⟩
    have hr:=(DECODE_PK d vs ret h).2.2.1
    simp only [hr,Option.some.injEq,Prod.mk.injEq,and_true]
    simp

-- All output cells are independent of the old/uninitialized buffer.
theorem L_V_SOURCE (h c : Vec) (hh : CanonVec h) (hc : CanonVec c) (b : Bytes) (legal : LegalBytes b)
    (accept : V_CAND h c b=1) :
    ∃ xs z, signature b=some xs ∧ xs.length=1536 ∧
      (∀ initial : Mem, ∀ i : Fin 1536, writeDecoded 0 xs initial i.val=listVec xs i) ∧
      Ext0 h c b=some z ∧ SignedVec (listVec xs) ∧ Congruent h c z ∧ Q z.1 z.2<2093922385 ∧ APIBounds b := by
  obtain ⟨xs,hdec,hraw⟩:=context_accept ⟨h,prepareKey h⟩ c b accept
  have hd:=SIGNATURE_DECODE b xs hdec
  have hs:=listVec_property FT1536.InInt16 xs hd.2.1 hd.2.2
  have hr:=RAW_VERIFIER_SOUND h c (listVec xs) hh hc hs hraw
  refine ⟨xs,Ext0Words h c (listVec xs),hdec,hd.2.1,signature_initializes b xs hdec,?_,hs,hr.2.1,hr.2.2,api_bounds b legal⟩
  simp only [Ext0,decodeS,hdec,Option.map_some]

#check @signature_initializes
#check @L_V_SOURCE
#print axioms write_below
#print axioms write_at
#print axioms all_initialized
#print axioms signature_initializes
#print axioms output_store_bounds
#print axioms cursor_counter_bounds
#print axioms gcc_narrow16
#print axioms static_negative_zero
#print axioms static_minimum_both_signs
#print axioms static_maximum_magnitude
#print axioms public_failure_guard
#print axioms L_V_SOURCE
end FT1536Bridge
