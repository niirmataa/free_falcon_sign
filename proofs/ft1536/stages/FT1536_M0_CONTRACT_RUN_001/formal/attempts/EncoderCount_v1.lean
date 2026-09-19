import CapacityMath
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536M0
open FT1536Global FT1536Forward FT1536Bridge

structure Count where
  used : Int
  bits : Int
  deriving Repr,DecidableEq
def weight (s : Count) : Int := 8*s.used+s.bits
def CountInv (s : Count) : Prop := 0≤s.used ∧ 0≤s.bits ∧ s.bits<8

-- C's two possible prefix drains, including the u>=capacity failure branch.
def drain (cap : Int) : Nat → Count → Option Count
  | 0,s => if s.bits<8 then some s else none
  | k+1,s => if 8≤s.bits then
      if s.used<cap then drain cap k ⟨s.used+1,s.bits-8⟩ else none
    else some s
def prefix9 (cap : Int) (s : Count) : Option Count := drain cap 2 ⟨s.used,s.bits+9⟩
def oneBit (cap : Int) (s : Count) : Option Count :=
  if s.bits+1=8 then if s.used<cap then some ⟨s.used+1,0⟩ else none
  else some ⟨s.used,s.bits+1⟩
def manyBits : Nat → Int → Count → Option Count
  | 0,_,s => some s
  | k+1,cap,s => match oneBit cap s with | none => none | some r => manyBits k cap r

theorem drain_ok (fuel : Nat) (cap : Int) (s : Count)
    (hs : 0≤s.used ∧ 0≤s.bits ∧ s.bits<8*((fuel:Int)+1)) (budget : weight s≤8*cap) :
    ∃ r, drain cap fuel s=some r ∧ CountInv r ∧ weight r=weight s := by
  induction fuel generalizing s with
  | zero =>
    have hb : s.bits<8 := by omega
    exact ⟨s,by simp [drain,hb],⟨hs.1,hs.2.1,hb⟩,rfl⟩
  | succ k ih =>
    by_cases hb : 8≤s.bits
    · have hc : s.used<cap := by unfold weight at budget;omega
      have he : weight ⟨s.used+1,s.bits-8⟩=weight s := by unfold weight;omega
      have hx : 0≤s.used+1 ∧ 0≤s.bits-8 ∧ s.bits-8<8*((k:Int)+1) := by omega
      obtain ⟨r,hr,hi,hw⟩:=ih ⟨s.used+1,s.bits-8⟩ hx (by rw [he];exact budget)
      exact ⟨r,by simp only [drain,ite_eq_left hb,ite_eq_left hc,hr],hi,hw.trans he⟩
    · exact ⟨s,by simp only [drain,ite_eq_right hb],⟨hs.1,hs.2.1,by omega⟩,rfl⟩

theorem prefix9_ok (cap : Int) (s : Count) (hs : CountInv s) (budget : weight s+9≤8*cap) :
    ∃ r, prefix9 cap s=some r ∧ CountInv r ∧ weight r=weight s+9 := by
  have he : weight ⟨s.used,s.bits+9⟩=weight s+9 := by unfold weight;omega
  obtain ⟨r,hr,hi,hw⟩:=drain_ok 2 cap ⟨s.used,s.bits+9⟩
    (by unfold CountInv at hs;dsimp;omega) (by rw [he];exact budget)
  exact ⟨r,hr,hi,hw.trans he⟩

theorem oneBit_ok (cap : Int) (s : Count) (hs : CountInv s) (budget : weight s+1≤8*cap) :
    ∃ r, oneBit cap s=some r ∧ CountInv r ∧ weight r=weight s+1 := by
  unfold CountInv weight at *
  by_cases hb : s.bits+1=8
  · have hc : s.used<cap := by omega
    refine ⟨⟨s.used+1,0⟩,?_,?_,?_⟩
    · simp only [oneBit,ite_eq_left hb,ite_eq_left hc]
    · dsimp;omega
    · dsimp;omega
  · refine ⟨⟨s.used,s.bits+1⟩,?_,?_,?_⟩
    · simp only [oneBit,ite_eq_right hb]
    · dsimp;omega
    · dsimp;omega

theorem manyBits_ok (k : Nat) (cap : Int) (s : Count) (hs : CountInv s) (budget : weight s+(k:Int)≤8*cap) :
    ∃ r, manyBits k cap s=some r ∧ CountInv r ∧ weight r=weight s+(k:Int) := by
  induction k generalizing s with
  | zero => exact ⟨s,rfl,hs,by simp⟩
  | succ k ih =>
    obtain ⟨t,ht,hit,hwt⟩:=oneBit_ok cap s hs (by omega)
    obtain ⟨r,hr,hir,hwr⟩:=ih t hit (by omega)
    exact ⟨r,by simp only [manyBits,ht,hr],hir,by omega⟩

def coeffBits (x : Int) : Int := 9+(x.natAbs/256+1 : Nat)
def listBits : List Int → Int
  | [] => 0
  | x::xs => coeffBits x+listBits xs
def encoderBody (cap : Int) : List Int → Count → Option Count
  | [],s => some s
  | x::xs,s => match prefix9 cap s with
    | none => none
    | some t => match manyBits (x.natAbs/256+1) cap t with
      | none => none
      | some r => encoderBody cap xs r
def finish (cap : Int) (s : Count) : Option Int :=
  if 0<s.bits then if s.used<cap then some (s.used+1) else none else some s.used
def encodeCount (cap : Int) (xs : List Int) : Option Int :=
  match encoderBody cap xs ⟨0,0⟩ with | none => none | some s => finish cap s

theorem coeff_bits_eq (x : Int) : coeffBits x=10+absI x/256 := by
  simp only [coeffBits,absI,Int.natCast_add,Int.natCast_ediv]
  omega
theorem list_bits_nonneg (xs : List Int) : 0≤listBits xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => unfold listBits coeffBits;omega

theorem encoder_body_ok (cap : Int) (xs : List Int) (s : Count) (hs : CountInv s)
    (budget : weight s+listBits xs≤8*cap) :
    ∃ r, encoderBody cap xs s=some r ∧ CountInv r ∧ weight r=weight s+listBits xs := by
  induction xs generalizing s with
  | nil => exact ⟨s,rfl,hs,by simp [listBits]⟩
  | cons x xs ih =>
    have htail:=list_bits_nonneg xs
    have hb : weight s+9+(x.natAbs/256+1 : Nat)+listBits xs≤8*cap := by
      simpa only [listBits,coeffBits,Int.add_assoc] using budget
    obtain ⟨t,ht,hit,hwt⟩:=prefix9_ok cap s hs (by omega)
    obtain ⟨u,hu,hiu,hwu⟩:=manyBits_ok (x.natAbs/256+1) cap t hit (by omega)
    obtain ⟨r,hr,hir,hwr⟩:=ih u hiu (by omega)
    refine ⟨r,by simp only [encoderBody,ht,hu,hr],hir,?_⟩
    simp only [listBits,coeffBits]
    omega

theorem finish_ok (cap : Int) (s : Count) (hs : CountInv s) (budget : weight s≤8*cap) :
    finish cap s=some ((weight s+7)/8) ∧ (weight s+7)/8≤cap := by
  unfold finish weight CountInv at *
  split
  · rename_i hb
    have hu : s.used<cap := by omega
    rw [ite_eq_left hu]
    constructor
    · congr 1;omega
    · omega
  · constructor
    · congr 1;omega
    · omega

theorem encoder_count_exact (cap : Int) (xs : List Int) (budget : listBits xs≤8*cap) :
    encodeCount cap xs=some ((listBits xs+7)/8) ∧ (listBits xs+7)/8≤cap := by
  obtain ⟨r,hr,hi,hw⟩:=encoder_body_ok cap xs ⟨0,0⟩ (by simp [CountInv]) (by simpa [weight] using budget)
  have he : weight r=listBits xs := by simpa [weight] using hw
  have hf:=finish_ok cap r hi (by rw [he];exact budget)
  rw [he] at hf
  exact ⟨by simp only [encodeCount,hr,hf.1],hf.2⟩

theorem list_bits_append (a b : List Int) : listBits (a++b)=listBits a+listBits b := by
  induction a <;> simp_all [listBits,Int.add_assoc]
theorem list_bits_ofFn (n : Nat) (f : Nat → Int) :
    listBits (List.ofFn (fun i : Fin n => f i.val))=sumN n (fun i => coeffBits (f i)) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [List.ofFn_succ_last,list_bits_append]
    change listBits (List.ofFn (fun i : Fin n => f i.val))+(coeffBits (f n)+0)=sumN n (fun i => coeffBits (f i))+coeffBits (f n)
    rw [ih,Int.add_zero]

attribute [local irreducible] FT1536Forward.sumN
theorem vector_bits (b : Vec) : listBits (List.ofFn b)=staticBits b := by
  have he : b=(fun i : Fin 1536 => fromVec b i.val) := by
    funext i;simp only [fromVec,i.isLt,↓reduceDIte]
  conv => lhs; rw [he]
  rw [list_bits_ofFn]
  have hf : (fun i => coeffBits (fromVec b i))=(fun i => 10+absI (fromVec b i)/256) := by
    funext i;exact coeff_bits_eq _
  rw [hf,sum_add,sum_const]
  rfl

theorem STATIC_FITS_4096 (a b : Vec) (ha : SignedVec a) (hb : SignedVec b) (accept : isShort a b=true) :
    encodeCount 4095 (List.ofFn b)=some (payloadLength b-1) ∧ payloadLength b≤3160 ∧ payloadLength b<4096 := by
  have hcap:=capacity_after_source_norm a b ha hb accept
  have hbits:=vector_bits b
  have he:=encoder_count_exact 4095 (List.ofFn b) (by rw [hbits];omega)
  rw [hbits] at he
  refine ⟨?_,hcap.2⟩
  simpa only [payloadLength,Int.add_sub_cancel_left] using he.1

theorem source_ne_bounds (x : Int) (hx : FT1536.InInt16 x) :
    x.natAbs≤32768 ∧ x.natAbs/256≤128 ∧ -2147483648≤ -x ∧ -x≤2147483647 := by
  unfold FT1536.InInt16 at hx;omega
theorem terminal_bit (ne : Int) (h : -1≤ne ∧ ne≤127) :
    (((ne%4294967296).toNat/32768)%2)=if ne<0 then 1 else 0 := by
  split <;> omega

#check @encoder_count_exact
#check @STATIC_FITS_4096
#print axioms drain_ok
#print axioms prefix9_ok
#print axioms oneBit_ok
#print axioms manyBits_ok
#print axioms coeff_bits_eq
#print axioms list_bits_nonneg
#print axioms encoder_body_ok
#print axioms finish_ok
#print axioms encoder_count_exact
#print axioms list_bits_append
#print axioms list_bits_ofFn
#print axioms vector_bits
#print axioms STATIC_FITS_4096
#print axioms source_ne_bounds
#print axioms terminal_bit
end FT1536M0
