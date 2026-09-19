import RawBridge
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge
abbrev Byte := Fin 256
abbrev Bytes := List Byte
structure Cursor where
  pos : Nat
  db : Nat
  bits : Nat
  deriving Repr,DecidableEq
def startCursor : Cursor := ⟨0,0,0⟩
def Valid (d : Bytes) (c : Cursor) : Prop := c.pos≤d.length ∧ c.db<4294967296
def Inv (d : Bytes) (c : Cursor) : Prop := Valid d c ∧ c.bits≤7
def remaining (d : Bytes) (c : Cursor) : Nat := 8*(d.length-c.pos)+c.bits

-- Exact unsigned32 shift/add on the retained db (including stale high bits).
def pull (d : Bytes) (c : Cursor) : Option Cursor :=
  if hp : c.pos<d.length then
    some ⟨c.pos+1,(c.db*256+(d[c.pos]'hp).val)%4294967296,c.bits+8⟩
  else none

theorem start_valid (d : Bytes) : Inv d startCursor := by simp [Inv,Valid,startCursor]
theorem pull_spec (d : Bytes) (c r : Cursor) (h : pull d c=some r) :
    Valid d r ∧ r.pos=c.pos+1 ∧ r.bits=c.bits+8 ∧ remaining d r=remaining d c := by
  unfold pull at h
  split at h
  · cases h
    dsimp [Valid,remaining] at *
    have hm:=Nat.mod_lt (c.db*256+(d[c.pos]'(by omega)).val) (show 0<4294967296 by decide)
    omega
  · cases h

def fill : Nat → Nat → Bytes → Cursor → Option Cursor
  | fuel,need,d,c =>
    if c.bits<need then
      match fuel with
      | 0 => none
      | f+1 => match pull d c with | none => none | some r => fill f need d r
    else some c

inductive FillRun (need : Nat) (d : Bytes) : Cursor → Option Cursor → Prop where
  | ready (c) (h : need≤c.bits) : FillRun need d c (some c)
  | eof (c) (h : c.bits<need) (hp : pull d c=none) : FillRun need d c none
  | more (c r result) (h : c.bits<need) (hp : pull d c=some r)
      (tail : FillRun need d r result) : FillRun need d c result

theorem fill_source (fuel need : Nat) (d : Bytes) (c : Cursor) (hc : Valid d c)
    (enough : need≤c.bits+8*fuel) : FillRun need d c (fill fuel need d c) := by
  induction fuel generalizing c with
  | zero =>
    have hn : ¬c.bits<need := by omega
    rw [fill,ite_eq_right hn]
    exact FillRun.ready c (by omega)
  | succ f ih =>
    rw [fill]
    split
    · rename_i hneed
      cases hp : pull d c with
      | none => exact FillRun.eof c hneed hp
      | some r =>
        have hs:=pull_spec d c r hp
        exact FillRun.more c r _ hneed hp (ih r hs.1 (by omega))
    · exact FillRun.ready c (by omega)

theorem fill_spec (fuel need : Nat) (d : Bytes) (c r : Cursor) (hc : Valid d c)
    (hb : c.bits<need+8) (h : fill fuel need d c=some r) :
    Valid d r ∧ need≤r.bits ∧ r.bits<need+8 ∧ c.pos≤r.pos ∧
    remaining d r=remaining d c := by
  induction fuel generalizing c with
  | zero =>
    rw [fill] at h
    split at h
    · cases h
    · cases h; exact ⟨hc,by omega,hb,by omega,rfl⟩
  | succ f ih =>
    rw [fill] at h
    split at h
    · rename_i hn
      cases hp : pull d c with
      | none => simp only [hp] at h; cases h
      | some c' =>
        simp only [hp] at h
        have hs:=pull_spec d c c' hp
        have hr:=ih c' hs.1 (by omega) h
        exact ⟨hr.1,hr.2.1,hr.2.2.1,by omega,hr.2.2.2.2.trans hs.2.2.2⟩
    · cases h; exact ⟨hc,by omega,hb,by omega,rfl⟩

-- Source unary read: refill db with one byte only at bits=0, then consume
-- one bit. No cap on the mathematical number of leading zero bits.
def nextBit (d : Bytes) (c : Cursor) : Option (Nat × Cursor) :=
  if c.bits=0 then
    if hp : c.pos<d.length then
      let v:=(d[c.pos]'hp).val
      some ((v/128)%2,⟨c.pos+1,v,7⟩)
    else none
  else
    let b:=c.bits-1
    some ((c.db/2^b)%2,{c with bits:=b})

theorem nextBit_spec (d : Bytes) (c r : Cursor) (bit : Nat) (hc : Inv d c)
    (h : nextBit d c=some (bit,r)) :
    Inv d r ∧ bit<2 ∧ c.pos≤r.pos ∧ remaining d c=remaining d r+1 := by
  unfold nextBit at h
  split at h
  · rename_i hb
    split at h
    · rename_i hp
      have hv:=(d[c.pos]'hp).isLt
      cases h
      dsimp [Inv,Valid,remaining] at *
      have hm:=Nat.mod_lt ((d[c.pos]'hp).val/128) (show 0<2 by decide)
      omega
    · cases h
  · rename_i hb
    cases h
    dsimp [Inv,Valid,remaining] at *
    have hm:=Nat.mod_lt (c.db/2^(c.bits-1)) (show 0<2 by decide)
    omega

theorem nextBit_empty (d : Bytes) (c : Cursor) (h : remaining d c=0) : nextBit d c=none := by
  have hb : c.bits=0 := by unfold remaining at h; omega
  have hp : ¬c.pos<d.length := by unfold remaining at h; omega
  simp only [nextBit,hb,↓reduceIte,dite_eq_right hp]

def unaryFuel : Nat → Bytes → Nat → Cursor → Option (Nat × Cursor)
  | 0,_,_,_ => none
  | f+1,d,ne,c =>
    match nextBit d c with
    | none => none
    | some (bit,r) => if bit=0 then unaryFuel f d ((ne+1)%4294967296) r else some (ne,r)
def unary (d : Bytes) (c : Cursor) : Option (Nat × Cursor) := unaryFuel (remaining d c) d 0 c

inductive UnaryRun (d : Bytes) : Nat → Cursor → Option (Nat × Cursor) → Prop where
  | eof (ne c) (h : nextBit d c=none) : UnaryRun d ne c none
  | stop (ne c bit r) (h : nextBit d c=some (bit,r)) (hb : bit≠0) : UnaryRun d ne c (some (ne,r))
  | more (ne c r result) (h : nextBit d c=some (0,r))
      (tail : UnaryRun d ((ne+1)%4294967296) r result) : UnaryRun d ne c result

theorem unary_source (fuel : Nat) (d : Bytes) (ne : Nat) (c : Cursor) (hc : Inv d c)
    (hf : remaining d c≤fuel) : UnaryRun d ne c (unaryFuel fuel d ne c) := by
  induction fuel generalizing ne c with
  | zero => exact UnaryRun.eof ne c (nextBit_empty d c (by omega))
  | succ f ih =>
    rw [unaryFuel]
    cases hp : nextBit d c with
    | none => exact UnaryRun.eof ne c hp
    | some pair =>
      rcases pair with ⟨bit,r⟩
      have hs:=nextBit_spec d c r bit hc hp
      simp only [hp]
      split
      · rename_i hz
        subst bit
        exact UnaryRun.more ne c r _ hp (ih _ r hs.1 (by omega))
      · rename_i hz
        exact UnaryRun.stop ne c bit r hp hz

theorem unary_spec (fuel : Nat) (d : Bytes) (ne : Nat) (c : Cursor) (hc : Inv d c) (hne : ne<4294967296)
    (out : Nat) (r : Cursor) (h : unaryFuel fuel d ne c=some (out,r)) :
    out<4294967296 ∧ Inv d r ∧ c.pos≤r.pos ∧ remaining d r<remaining d c := by
  induction fuel generalizing ne c with
  | zero => cases h
  | succ f ih =>
    rw [unaryFuel] at h
    cases hp : nextBit d c with
    | none => simp only [hp] at h; cases h
    | some pair =>
      rcases pair with ⟨bit,c'⟩
      simp only [hp] at h
      have hs:=nextBit_spec d c c' bit hc hp
      split at h
      · have hr:=ih _ c' hs.1 (Nat.mod_lt _ (by decide)) h
        exact ⟨hr.1,hr.2.1,by omega,by omega⟩
      · cases h
        exact ⟨hne,hs.1,hs.2.2.1,by omega⟩

def zeroCount : Nat → Nat → Nat
  | 0,ne => ne
  | k+1,ne => (zeroCount k ne+1)%4294967296
theorem unary_wrap (k ne : Nat) (hne : ne<4294967296) : zeroCount k ne=(ne+k)%4294967296 := by
  induction k with
  | zero => simp [zeroCount,Nat.mod_eq_of_lt hne]
  | succ k ih => simp only [zeroCount,ih]; omega

#check @fill_source
#check @nextBit_spec
#check @unary_source
#check @unary_spec
#check @unary_wrap
#print axioms start_valid
#print axioms pull_spec
#print axioms fill_source
#print axioms fill_spec
#print axioms nextBit_spec
#print axioms nextBit_empty
#print axioms unary_source
#print axioms unary_spec
#print axioms unary_wrap
end FT1536Bridge
