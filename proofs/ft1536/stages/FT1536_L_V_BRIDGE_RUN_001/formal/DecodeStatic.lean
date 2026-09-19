import ByteCursor
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge
open FT1536Global

def staticValue (sign mag : Nat) : Int :=
  if sign=0 then s16 (mag : Int) else s16 (-s16 (mag : Int))
theorem static_value_range (sign mag : Nat) : FT1536.InInt16 (staticValue sign mag) := by
  unfold staticValue; split <;> exact s16_range _
theorem static_promotions (lo ne : Nat) (hlo : lo<256) (hne : ne≤255) :
    lo+ne*256<65536 ∧ ne*256<4294967296 ∧
    -2147483648< -s16 (lo+ne*256 : Int) ∧ -s16 (lo+ne*256 : Int)<2147483647 := by
  have hs:=s16_range (lo+ne*256 : Int)
  unfold FT1536.InInt16 at hs
  omega

def readStatic (d : Bytes) (c : Cursor) : Option (Int × Cursor) :=
  match fill 2 9 d c with
  | none => none
  | some f =>
    let sign:=(f.db/2^(f.bits-1))%2
    let lo:=(f.db/2^(f.bits-9))%256
    let head:={f with bits:=f.bits-9}
    match unary d head with
    | none => none
    | some (ne,r) => if 255<ne then none else some (staticValue sign (lo+ne*256),r)

theorem readStatic_spec (d : Bytes) (c r : Cursor) (v : Int) (hc : Inv d c)
    (h : readStatic d c=some (v,r)) :
    FT1536.InInt16 v ∧ Inv d r ∧ c.pos≤r.pos ∧ remaining d r+10≤remaining d c := by
  unfold readStatic at h
  cases hf : fill 2 9 d c with
  | none => simp only [hf] at h; cases h
  | some f =>
    have fs:=fill_spec 2 9 d c f hc.1 (by have hb:=hc.2;omega) hf
    have ih : Inv d {f with bits:=f.bits-9} := ⟨fs.1,by change f.bits-9≤7;omega⟩
    have rem : remaining d {f with bits:=f.bits-9}+9=remaining d c := by
      dsimp [remaining] at *; omega
    simp only [hf] at h
    cases hu : unary d {f with bits:=f.bits-9} with
    | none => simp only [hu] at h; cases h
    | some pair =>
      rcases pair with ⟨ne,r'⟩
      have us:=unary_spec (remaining d {f with bits:=f.bits-9}) d 0 _ ih (by decide) ne r' hu
      simp only [hu] at h
      split at h
      · cases h
      · cases h
        have hpos : f.pos≤r.pos := us.2.2.1
        exact ⟨static_value_range _ _,us.2.1,by omega,by omega⟩

theorem static_head_source (d : Bytes) (c : Cursor) (hc : Inv d c) : FillRun 9 d c (fill 2 9 d c) :=
  fill_source 2 9 d c hc.1 (by omega)
theorem static_head_shifts (d : Bytes) (c f : Cursor) (hc : Inv d c) (h : fill 2 9 d c=some f) :
    9≤f.bits ∧ f.bits≤16 ∧ f.bits-1<32 ∧ f.bits-9≤7 := by
  have hs:=fill_spec 2 9 d c f hc.1 (by have hb:=hc.2;omega) h
  omega

def staticLoop : Nat → Bytes → Cursor → Option (List Int × Cursor)
  | 0,_,c => if c.db%2^c.bits=0 then some ([],c) else none
  | n+1,d,c =>
    match readStatic d c with
    | none => none
    | some (v,c') => match staticLoop n d c' with | none => none | some (vs,r) => some (v::vs,r)
def decodeStatic (d : Bytes) : Option (List Int × Nat) :=
  match staticLoop 1536 d startCursor with | none => none | some (vs,r) => some (vs,r.pos)

theorem static_loop_spec (n : Nat) (d : Bytes) (c r : Cursor) (vs : List Int) (hc : Inv d c)
    (h : staticLoop n d c=some (vs,r)) :
    vs.length=n ∧ (∀ x, x∈vs → FT1536.InInt16 x) ∧ Inv d r ∧ c.pos≤r.pos ∧
    remaining d r+10*n≤remaining d c ∧ r.db%2^r.bits=0 := by
  induction n generalizing c vs with
  | zero =>
    rw [staticLoop] at h
    split at h
    · rename_i pad
      cases h
      exact ⟨rfl,by simp,hc,by omega,by omega,pad⟩
    · cases h
  | succ n ih =>
    rw [staticLoop] at h
    cases hs : readStatic d c with
    | none => simp only [hs] at h; cases h
    | some pair =>
      rcases pair with ⟨v,c'⟩
      have hstep:=readStatic_spec d c c' v hc hs
      simp only [hs] at h
      cases ht : staticLoop n d c' with
      | none => simp only [ht] at h; cases h
      | some pair =>
        rcases pair with ⟨tail,last⟩
        simp only [ht] at h
        cases h
        have ihs:=ih c' tail hstep.2.1 ht
        refine ⟨by simp [ihs.1],?_,ihs.2.2.1,by omega,by omega,ihs.2.2.2.2.2⟩
        intro x hx
        rcases List.mem_cons.mp hx with rfl|hx
        · exact hstep.1
        · exact ihs.2.1 x hx

theorem DECODE_STATIC (d : Bytes) (vs : List Int) (used : Nat) (h : decodeStatic d=some (vs,used)) :
    vs.length=1536 ∧ (∀ x, x∈vs → FT1536.InInt16 x) ∧ 1920≤used ∧ used≤d.length := by
  unfold decodeStatic at h
  cases hs : staticLoop 1536 d startCursor with
  | none => simp only [hs] at h; cases h
  | some pair =>
    rcases pair with ⟨xs,r⟩
    simp only [hs] at h
    cases h
    have spec:=static_loop_spec 1536 d startCursor r vs (start_valid d) hs
    refine ⟨spec.1,spec.2.1,?_,spec.2.2.1.1.1⟩
    have hvalid:=spec.2.2.1.1.1
    have hrem:=spec.2.2.2.2.1
    dsimp [remaining,startCursor] at hrem
    omega

def listVec (xs : List Int) : Vec := fun i => xs[i.val]?.getD 0
theorem listVec_property (P : Int → Prop) (xs : List Int) (hlen : xs.length=1536)
    (hp : ∀ x, x∈xs → P x) : ∀ i, P (listVec xs i) := by
  intro i
  have hi : i.val<xs.length := by have h:=i.isLt;omega
  unfold listVec
  rw [List.getElem?_eq_getElem hi]
  exact hp _ (List.getElem_mem hi)
theorem static_vector_signed (d : Bytes) (vs : List Int) (used : Nat) (h : decodeStatic d=some (vs,used)) : SignedVec (listVec vs) :=
  listVec_property FT1536.InInt16 vs (DECODE_STATIC d vs used h).1 (DECODE_STATIC d vs used h).2.1

#check @DECODE_STATIC
#check @static_loop_spec
#print axioms static_value_range
#print axioms static_promotions
#print axioms readStatic_spec
#print axioms static_head_source
#print axioms static_head_shifts
#print axioms static_loop_spec
#print axioms DECODE_STATIC
#print axioms listVec_property
#print axioms static_vector_signed
end FT1536Bridge
