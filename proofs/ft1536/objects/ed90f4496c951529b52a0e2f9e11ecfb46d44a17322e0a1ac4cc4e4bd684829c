import Run2.BitAllocation
import Run2.TableMachine

namespace FT1536.Run2.TableAllocation
open Games BitArithmetic TableMachine

def equal (a b : Byte) : ℕ := BitAllocation.scan (encodeNat a.val 8) (encodeNat b.val 8)+32

theorem equal_bound (a b : Byte) : equal a b≤32*(ByteMachine.equal a b).2 := by
  have hh:=BitAllocation.compare_bound (encodeNat a.val 8) (encodeNat b.val 8)
  simp only [equal,ByteMachine.equal]
  omega

def compare : Bytes → Bytes → ℕ
  | [],_ => 32
  | _::_,[] => 32
  | a::as,b::bs => if (ByteMachine.equal a b).1 then equal a b+compare as bs+32 else equal a b+32

theorem compare_bound (xs ys : Bytes) : compare xs ys≤32*(ByteMachine.compare xs ys).2 := by
  induction xs generalizing ys with
  | nil => cases ys <;> rfl
  | cons a as ih =>
    cases ys with
    | nil => rfl
    | cons b bs =>
      have he:=equal_bound a b
      have ht:=ih bs
      cases hc : (ByteMachine.equal a b).1 <;>
        simp only [compare,ByteMachine.compare,hc,Bool.false_eq_true,ite_false,ite_true] <;> omega

def lookup (x : Name) : List Entry → ℕ
  | [] => 32
  | e::es => if (ByteMachine.compare (nameBytes x) (nameBytes e.name)).1 then
      compare (nameBytes x) (nameBytes e.name)+32
    else compare (nameBytes x) (nameBytes e.name)+lookup x es+32

theorem lookup_bound (x : Name) (es : List Entry) : lookup x es≤32*(TableMachine.lookup x es).2 := by
  induction es with
  | nil => rfl
  | cons e es ih =>
    have hc:=compare_bound (nameBytes x) (nameBytes e.name)
    cases he : (ByteMachine.compare (nameBytes x) (nameBytes e.name)).1 <;>
      simp only [lookup,TableMachine.lookup,he,Bool.false_eq_true,ite_false,ite_true] <;> omega

def seen (m : Bytes) : List Bytes → ℕ
  | [] => 32
  | x::xs => if (ByteMachine.compare m x).1 then compare m x+32 else compare m x+seen m xs+32

theorem seen_bound (m : Bytes) (xs : List Bytes) : seen m xs≤32*(TableMachine.seen m xs).2 := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    have hc:=compare_bound m x
    cases he : (ByteMachine.compare m x).1 <;>
      simp only [seen,TableMachine.seen,he,Bool.false_eq_true,ite_false,ite_true] <;> omega

def target : List FT1536.Relation.Rq → ℕ → ℕ
  | [],_ => 32
  | _::_,0 => 24576+32
  | _::xs,n+1 => target xs n+32

theorem target_bound (cs : List FT1536.Relation.Rq) (n : ℕ) :
    target cs n≤32*(readTarget cs n).2 := by
  induction cs generalizing n with
  | nil => rfl
  | cons c cs ih =>
    cases n with
    | zero => change (24576+32 : ℕ)≤32*24577; decide
    | succ n => have hh:=ih n; simp only [target,readTarget]; omega

def hash (cs : List FT1536.Relation.Rq) (x : Bytes) (st : State) : ℕ :=
  match (TableMachine.lookup (parse x) st.table.table).1 with
  | some _ => lookup (parse x) st.table.table+32
  | none => match (readTarget cs st.table.used).1 with
    | none => lookup (parse x) st.table.table+target cs st.table.used+32
    | some _ => lookup (parse x) st.table.table+target cs st.table.used+
        8*(nameBytes (parse x)).length+24576+st.table.used+32

theorem hash_bound (cs : List FT1536.Relation.Rq) (x : Bytes) (st : State) :
    hash cs x st≤32*(TableMachine.hash cs x st).2 := by
  have hl:=lookup_bound (parse x) st.table.table
  have hr:=target_bound cs st.table.used
  cases he : (TableMachine.lookup (parse x) st.table.table).1 with
  | some e => simp only [hash,TableMachine.hash,he]; omega
  | none => cases hc : (readTarget cs st.table.used).1 <;>
      simp only [hash,TableMachine.hash,he,hc] <;> omega

end FT1536.Run2.TableAllocation

#print axioms FT1536.Run2.TableAllocation.hash_bound
#print axioms FT1536.Run2.TableAllocation.lookup_bound
