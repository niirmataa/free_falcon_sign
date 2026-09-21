import DecodeNone
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge
open FT1536Global

-- uint32 (acc<<8)|byte equals the source-state pull's wrapped addition.
theorem byte_concat (acc byte : Nat) (hb : byte<256) :
    ((acc*256)%4294967296)|||byte=(acc*256+byte)%4294967296 := by
  have he : (acc*256)%4294967296=256*(acc%16777216) := by omega
  have ho : (256*(acc%16777216))|||byte=256*(acc%16777216)+byte :=
    (Nat.two_pow_add_eq_or_of_lt (i:=8) hb (acc%16777216)).symm
  rw [he,ho]
  omega

def readPK (d : Bytes) (c : Cursor) : Option (Int × Cursor) :=
  match fill 2 15 d c with
  | none => none
  | some f =>
    let bits:=f.bits-15
    let w:=f.db/2^bits
    if 18433≤w then none else some ((w : Int),⟨f.pos,f.db%2^bits,bits⟩)

theorem readPK_spec (d : Bytes) (c r : Cursor) (v : Int) (hc : Inv d c)
    (h : readPK d c=some (v,r)) :
    CanonVal v ∧ Inv d r ∧ c.pos≤r.pos ∧ remaining d r+15=remaining d c ∧ r.db<2^r.bits := by
  unfold readPK at h
  cases hf : fill 2 15 d c with
  | none => simp only [hf] at h;cases h
  | some f =>
    have fs:=fill_spec 2 15 d c f hc.1 (by have hb:=hc.2;omega) hf
    simp only [hf] at h
    split at h
    · cases h
    · rename_i hw
      cases h
      have hm:=Nat.mod_lt f.db (Nat.two_pow_pos (f.bits-15))
      have hle:=Nat.mod_le f.db (2^(f.bits-15))
      have cast_range (x : Nat) (hx : x<18433) : CanonVal (x : Int) := by unfold CanonVal;omega
      refine ⟨cast_range _ (by omega),?_,?_,?_,?_⟩
      all_goals dsimp [Inv,Valid,remaining] at *;omega

theorem pk_head_source (d : Bytes) (c : Cursor) (hc : Inv d c) : FillRun 15 d c (fill 2 15 d c) :=
  fill_source 2 15 d c hc.1 (by omega)
theorem pk_head_shifts (d : Bytes) (c f : Cursor) (hc : Inv d c) (h : fill 2 15 d c=some f) :
    15≤f.bits ∧ f.bits≤22 ∧ f.bits-15≤7 := by
  have hs:=fill_spec 2 15 d c f hc.1 (by have hb:=hc.2;omega) h
  omega

def pkLoop : Nat → Bytes → Cursor → Option (List Int × Cursor)
  | 0,_,c => if c.db=0 then some ([],c) else none
  | n+1,d,c =>
    match readPK d c with
    | none => none
    | some (v,c') => match pkLoop n d c' with | none => none | some (vs,r) => some (v::vs,r)
def decodePK (d : Bytes) : Option (List Int × Nat) :=
  match pkLoop 1536 d startCursor with | none => none | some (vs,_) => some (vs,d.length)

theorem pk_loop_spec (n : Nat) (d : Bytes) (c r : Cursor) (vs : List Int) (hc : Inv d c)
    (h : pkLoop n d c=some (vs,r)) :
    vs.length=n ∧ (∀ x, x∈vs → CanonVal x) ∧ Inv d r ∧ c.pos≤r.pos ∧
    remaining d r+15*n=remaining d c ∧ r.db=0 := by
  induction n generalizing c vs with
  | zero =>
    rw [pkLoop] at h
    split at h
    · rename_i pad
      cases h
      exact ⟨rfl,by simp,hc,by omega,by omega,pad⟩
    · cases h
  | succ n ih =>
    rw [pkLoop] at h
    cases hs : readPK d c with
    | none => simp only [hs] at h;cases h
    | some pair =>
      rcases pair with ⟨v,c'⟩
      have hstep:=readPK_spec d c c' v hc hs
      simp only [hs] at h
      cases ht : pkLoop n d c' with
      | none => simp only [ht] at h;cases h
      | some pair =>
        rcases pair with ⟨tail,last⟩
        simp only [ht] at h
        cases h
        have hi:=ih c' tail hstep.2.1 ht
        refine ⟨by simp [hi.1],?_,hi.2.2.1,by omega,by omega,hi.2.2.2.2.2⟩
        intro x hx
        rcases List.mem_cons.mp hx with rfl|hx
        · exact hstep.1
        · exact hi.2.1 x hx

theorem PK_CONSUMED (d : Bytes) (vs : List Int) (r : Cursor) (h : pkLoop 1536 d startCursor=some (vs,r)) :
    r.pos=2880 ∧ r.bits=0 ∧ r.db=0 := by
  have hs:=pk_loop_spec 1536 d startCursor r vs (start_valid d) h
  have hv:=hs.2.2.1
  have he:=hs.2.2.2.2.1
  dsimp [Inv,Valid,remaining,startCursor] at *
  omega
theorem DECODE_PK (d : Bytes) (vs : List Int) (ret : Nat) (h : decodePK d=some (vs,ret)) :
    vs.length=1536 ∧ (∀ x, x∈vs → CanonVal x) ∧ ret=d.length ∧ 2880≤ret := by
  unfold decodePK at h
  cases hs : pkLoop 1536 d startCursor with
  | none => simp only [hs] at h;cases h
  | some pair =>
    rcases pair with ⟨xs,r⟩
    simp only [hs] at h
    cases h
    have spec:=pk_loop_spec 1536 d startCursor r vs (start_valid d) hs
    have consumed:=PK_CONSUMED d vs r hs
    refine ⟨spec.1,spec.2.1,rfl,?_⟩
    have hv:=spec.2.2.1.1.1
    omega

structure FTContext where
  polynomial : Vec
  prepared : Vec

-- FT profile selection is explicit: other profiles are outside this lemma,
-- not reclassified as source loader failures. Empty context models logn=0.
def loadFT (pk : Bytes) : Option FTContext :=
  if pk.length≤1 then none else
    match pk with
    | [] => none
    | fb::d =>
      if (fb.val/16)%8≠0 then none else
      if fb.val%16≠10 ∨ fb.val/128≠1 then none else
      match decodePK d with
      | none => none
      | some (vs,ret) => if ret≠d.length then none else
          let h:=listVec vs
          some ⟨h,prepareKey h⟩

theorem PK_PREPARATION (pk : Bytes) (ctx : FTContext) (h : loadFT pk=some ctx) :
    CanonVec ctx.polynomial ∧ ctx.prepared=prepareKey ctx.polynomial := by
  unfold loadFT at h
  split at h
  · cases h
  · cases pk with
    | nil => cases h
    | cons fb d =>
      dsimp only at h
      split at h
      · cases h
      · split at h
        · cases h
        · cases hd : decodePK d with
          | none => simp only [hd] at h;cases h
          | some pair =>
            rcases pair with ⟨vs,ret⟩
            simp only [hd] at h
            split at h
            · cases h
            · cases h
              exact ⟨listVec_property CanonVal vs (DECODE_PK d vs ret hd).1 (DECODE_PK d vs ret hd).2.1,rfl⟩

#check @PK_CONSUMED
#check @DECODE_PK
#check @PK_PREPARATION
#print axioms byte_concat
#print axioms readPK_spec
#print axioms pk_head_source
#print axioms pk_head_shifts
#print axioms pk_loop_spec
#print axioms PK_CONSUMED
#print axioms DECODE_PK
#print axioms PK_PREPARATION
end FT1536Bridge
