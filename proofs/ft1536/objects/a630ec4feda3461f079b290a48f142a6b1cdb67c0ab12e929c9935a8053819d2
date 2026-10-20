import Run2.ByteMachine
import Run2.GameInvariants

namespace FT1536.Run2.TableMachine
open Games FT1536.Relation

/- Internal keys have an explicit option tag. This makes the encoding
injective even for states outside the reachable well-framed invariant. -/
def nameBytes (x : Name) : Bytes := match x.1 with
  | none => 0::x.2
  | some r => 1::frame r x.2

theorem nameBytes_injective : Function.Injective nameBytes := by
  intro x y he
  obtain ⟨r,m⟩:=x
  obtain ⟨s,n⟩:=y
  cases r with
  | none =>
    cases s with
    | none => simpa [nameBytes] using he
    | some s => simp [nameBytes] at he
  | some r =>
    cases s with
    | none => simp [nameBytes] at he
    | some s =>
      have hh : frame r m=frame s n := by simpa only [nameBytes,List.cons.injEq,true_and] using he
      have hp:=congrArg parse hh
      simpa only [parse_frame,Prod.mk.injEq,Option.some.injEq] using hp

theorem nameBytes_length (x : Name) : (nameBytes x).length≤41+x.2.length := by
  obtain ⟨r,m⟩:=x
  cases r with
  | none => simp [nameBytes]
  | some r => simp [nameBytes,frame,List.length_append,r.property]

abbrev Entry := ROM.Entry (Option Nonce) Bytes Rq

def lookup (x : Name) : List Entry → Option Entry × ℕ
  | [] => (none,1)
  | e::es =>
      let c:=ByteMachine.compare (nameBytes x) (nameBytes e.name)
      if c.1 then (some e,c.2+1)
      else let r:=lookup x es; (r.1,c.2+1+r.2)

theorem lookup_correct (x : Name) (st : Table) :
    (lookup x st.table).1=ROM.lookup x st := by
  obtain ⟨es,seen,used⟩:=st
  induction es with
  | nil => rfl
  | cons e es ih =>
    simp only [lookup,ByteMachine.compare_correct,ROM.lookup]
    simp only [ROM.lookup] at ih
    have he : nameBytes x=nameBytes e.name ↔ x=e.name := nameBytes_injective.eq_iff
    simp only [he]
    by_cases hn : x=e.name
    · simp [hn]
    · simp [hn,Ne.symm hn,ih]

theorem lookup_steps (x : Name) (es : List Entry) :
    (lookup x es).2≤es.length*(133*(nameBytes x).length+2)+1 := by
  induction es with
  | nil => simp [lookup]
  | cons e es ih =>
    have hc:=ByteMachine.compare_cost (nameBytes x) (nameBytes e.name)
    have hm:=Nat.min_le_left (nameBytes x).length (nameBytes e.name).length
    simp only [lookup,List.length_cons,Nat.add_mul,Nat.one_mul]
    split <;> omega

def seen (m : Bytes) : List Bytes → Bool × ℕ
  | [] => (false,1)
  | x::xs =>
      let c:=ByteMachine.compare m x
      if c.1 then (true,c.2+1)
      else let r:=seen m xs; (r.1,c.2+1+r.2)

theorem seen_correct (m : Bytes) (xs : List Bytes) : (seen m xs).1=decide (m∈xs) := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    simp only [seen,ByteMachine.compare_correct]
    by_cases he:m=x <;> simp [he,ih]

theorem seen_steps (m : Bytes) (xs : List Bytes) :
    (seen m xs).2≤xs.length*(133*m.length+2)+1 := by
  induction xs with
  | nil => simp [seen]
  | cons x xs ih =>
    have hc:=ByteMachine.compare_cost m x
    have hm:=Nat.min_le_left m.length x.length
    simp only [seen,List.length_cons,Nat.add_mul,Nat.one_mul]
    split <;> omega

/- Target positions are walked in unary; each visited target costs its
entire 1536-coefficient, 16-bit file. This also covers a copying traversal. -/
def readTarget : List Rq → ℕ → Option Rq × ℕ
  | [],_ => (none,1)
  | x::_,0 => (some x,24577)
  | _::xs,n+1 => let r:=readTarget xs n; (r.1,24577+r.2)

theorem readTarget_correct (xs : List Rq) (n : ℕ) : (readTarget xs n).1=xs[n]? := by
  induction xs generalizing n with
  | nil => simp [readTarget]
  | cons x xs ih => cases n <;> simp [readTarget,ih]

theorem readTarget_steps (xs : List Rq) (n : ℕ) :
    (readTarget xs n).2≤24577*(n+1) := by
  induction xs generalizing n with
  | nil => simp [readTarget]; omega
  | cons x xs ih =>
    cases n with
    | zero => exact Nat.le_refl _
    | succ n => have hh:=ih n; simp only [readTarget]; omega

def hash (cs : List Rq) (x : Bytes) (st : State) : Option (Rq × State) × ℕ :=
  let e:=lookup (parse x) st.table.table
  match e.1 with
  | some row => (some (row.value,st),e.2+2)
  | none =>
      let c:=readTarget cs st.table.used
      match c.1 with
      | none => (none,e.2+c.2+2)
      | some target =>
          (some (target,⟨⟨⟨parse x,target,some st.table.used⟩::st.table.table,
              st.table.seen,st.table.used+1⟩,st.events⟩),
            e.2+c.2+8*(nameBytes (parse x)).length+24576+st.table.used+8)

theorem hash_correct (cs : List Rq) (x : Bytes) (st : State) :
    (hash cs x st).1=hashTargets cs x st := by
  simp only [hash,lookup_correct,readTarget_correct,hashTargets]
  cases he : ROM.lookup (parse x) st.table with
  | some e => rfl
  | none => cases hc : cs[st.table.used]? <;> rfl

theorem hash_steps (cs : List Rq) (x : Bytes) (st : State) :
    (hash cs x st).2≤st.table.table.length*(133*(nameBytes (parse x)).length+2)+1+
      24577*(st.table.used+1)+8*(nameBytes (parse x)).length+24576+st.table.used+8 := by
  have he:=lookup_steps (parse x) st.table.table
  have hc:=readTarget_steps cs st.table.used
  unfold hash
  dsimp only
  split
  · omega
  · split <;> omega

end FT1536.Run2.TableMachine
