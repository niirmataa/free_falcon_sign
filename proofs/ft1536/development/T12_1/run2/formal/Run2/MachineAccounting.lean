import Run2.MachineExecution

namespace FT1536.Run2.MachineAccounting
open Games FT1536.Relation FT1536.BitCost StateResources

/- Time and traffic add, memory takes the peak. An annotation is a ghost
counter; it is not an ever-growing runtime trace. -/
def seq (a b : Cost) : Cost := ⟨a.t+b.t,max a.w b.w,a.L+b.L⟩
def repeatBound (n : ℕ) (c : Cost) : Cost := ⟨n*c.t,c.w,n*c.L⟩

theorem cost_refl (c : Cost) : c≤c := ⟨le_rfl,le_rfl,le_rfl⟩
theorem cost_trans {a b c : Cost} (h : a≤b) (k : b≤c) : a≤c :=
  ⟨h.1.trans k.1,h.2.1.trans k.2.1,h.2.2.trans k.2.2⟩
theorem seq_mono {a b c d : Cost} (h : a≤c) (k : b≤d) : seq a b≤seq c d :=
  ⟨Nat.add_le_add h.1 k.1,max_le_max h.2.1 k.2.1,Nat.add_le_add h.2.2 k.2.2⟩
theorem seq_repeat {a b c : Cost} {n : ℕ} (ha : a≤c) (hb : b≤repeatBound n c) :
    seq a b≤repeatBound (n+1) c := by
  rcases ha with ⟨hat,haw,haL⟩
  rcases hb with ⟨hbt,hbw,hbL⟩
  change a.t+b.t≤(n+1)*c.t ∧ max a.w b.w≤c.w ∧ a.L+b.L≤(n+1)*c.L
  dsimp only [repeatBound] at *
  exact ⟨by nlinarith,max_le haw hbw,by nlinarith⟩
theorem repeat_mono (c : Cost) {n N : ℕ} (h : n≤N) : repeatBound n c≤repeatBound N c :=
  ⟨Nat.mul_le_mul_right c.t h,le_rfl,Nat.mul_le_mul_right c.L h⟩
theorem single_repeat (c : Cost) {n : ℕ} (h : 0<n) : c≤repeatBound n c := by
  change c.t≤n*c.t ∧ c.w≤c.w ∧ c.L≤n*c.L
  exact ⟨by nlinarith,le_rfl,by nlinarith⟩

/- A deliberately padded transport: a Boolean is sent in one byte, read
and written once. These sixteen operations per bit implement the existing
SamplerMachine port convention, rather than treating framing as free. -/
def copy : List Bool → BitArithmetic.Result
  | [] => ⟨[],1⟩
  | b::bs => let r:=copy bs; ⟨b::r.bits,16+r.steps⟩

theorem copy_correct (xs : List Bool) : (copy xs).bits=xs := by
  induction xs with
  | nil => rfl
  | cons b bs ih => simp only [copy,ih]

theorem copy_steps (xs : List Bool) : (copy xs).steps=16*xs.length+1 := by
  induction xs with
  | nil => rfl
  | cons b bs ih => simp only [copy,ih,List.length_cons]; omega

def transport (xs : List Bool) : Cost :=
  ⟨(copy xs).steps,8*(xs.length+(copy xs).bits.length),xs.length⟩

theorem transport_exact (xs : List Bool) :
    transport xs=⟨16*xs.length+1,16*xs.length,xs.length⟩ := by
  simp only [transport,copy_steps,copy_correct]
  congr 1
  omega

def lookupBound (L n : ℕ) : ℕ := n*(133*(41+L)+2)+1
def hashBound (L n T : ℕ) : ℕ :=
  lookupBound L n+24577*(T+1)+8*(41+L)+24576+T+8

theorem lookup_bound (L n : ℕ) (x : Name) (st : State)
    (hs : st.table.table.length≤n) (hx : x.2.length≤L) :
    (TableMachine.lookup x st.table.table).2≤lookupBound L n := by
  have hn:=(TableMachine.nameBytes_length x).trans (Nat.add_le_add_left hx 41)
  have ht:=TableMachine.lookup_steps x st.table.table
  have hm:=Nat.mul_le_mul hs (show 133*(TableMachine.nameBytes x).length+2≤133*(41+L)+2 by omega)
  unfold lookupBound
  omega

theorem hash_bound (L n T : ℕ) (cs : List Rq) (x : Bytes) (st : State)
    (hs : st.table.table.length≤n) (hu : st.table.used≤T) (hx : x.length≤L) :
    (TableMachine.hash cs x st).2≤hashBound L n T := by
  have hp:=(parse_message_length x).trans hx
  have hn:=(TableMachine.nameBytes_length (parse x)).trans (Nat.add_le_add_left hp 41)
  have ht:=TableMachine.hash_steps cs x st
  have hm:=Nat.mul_le_mul hs (show 133*(TableMachine.nameBytes (parse x)).length+2≤133*(41+L)+2 by omega)
  have hr:=Nat.mul_le_mul_left 24577 (Nat.add_le_add_right hu 1)
  have hw:=Nat.mul_le_mul_left 8 hn
  exact ht.trans (Nat.add_le_add_right
    (Nat.add_le_add (Nat.add_le_add_right
      (Nat.add_le_add (Nat.add_le_add (Nat.add_le_add_right hm 1) hr) hw) 24576) hu) 8)

theorem seen_bound (L n : ℕ) (m : Bytes) (st : State)
    (hs : st.table.seen.length≤n) (hm : m.length≤L) :
    (TableMachine.seen m st.table.seen).2≤lookupBound L n := by
  have ht:=TableMachine.seen_steps m st.table.seen
  have hh:=Nat.mul_le_mul hs (show 133*m.length+2≤133*(41+L)+2 by omega)
  unfold lookupBound
  omega

end FT1536.Run2.MachineAccounting

#print axioms FT1536.Run2.MachineAccounting.seq_repeat
#print axioms FT1536.Run2.MachineAccounting.transport_exact
#print axioms FT1536.Run2.MachineAccounting.hash_bound
