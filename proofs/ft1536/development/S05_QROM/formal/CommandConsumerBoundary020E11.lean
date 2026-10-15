import CommandConsumerRefinement020E11

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CommandConsumerBoundary020E11
open WordRAM020 ArrayBank020E4 CommandConsumer020E11

theorem malformed_stops {n capacity : Nat} (fuel : Nat) (q : State n capacity)
    (hb : q.bad=false) (h : q.cursor.val<capacity)
    (he : CommandDecode020E11.decode n (slot q.encoded ⟨q.cursor.val,h⟩)=none) :
    CommandConsumer020E11.run (fuel+1) q={q with bad:=true} := by
  rw [CommandConsumer020E11.run,malformed q hb h he,bad_run _ _ (by rfl)]

theorem malformed_result {n capacity : Nat} (fuel : Nat) (q : State n capacity)
    (hb : q.bad=false) (h : q.cursor.val<capacity)
    (he : CommandDecode020E11.decode n (slot q.encoded ⟨q.cursor.val,h⟩)=none) :
    finish (CommandConsumer020E11.run (fuel+1) q)=none := by
  rw [malformed_stops fuel q hb h he]
  rfl

theorem empty_slot {n capacity : Nat} (q : State n capacity) (hb : q.bad=false) (h : q.cursor.val<capacity)
    (he : CommandDecode020E11.decode n (slot q.encoded ⟨q.cursor.val,h⟩)=some none) :
    step q={q with cursor:=⟨q.cursor.val+1,by omega⟩} := by
  simp only [step,hb,Bool.false_eq_true,ite_false,dite_eq_left h,he]
  rfl

theorem put_slot {n capacity : Nat} (q : State n capacity) (hb : q.bad=false) (h : q.cursor.val<capacity)
    (j : Fin n) (v : Word)
    (he : CommandDecode020E11.decode n (slot q.encoded ⟨q.cursor.val,h⟩)=some (some (j,v))) :
    step q={q with target:=write q.target j v,cursor:=⟨q.cursor.val+1,by omega⟩} := by
  simp only [step,hb,Bool.false_eq_true,ite_false,dite_eq_left h,he]
  rfl

theorem script_cursor {n capacity : Nat} (fuel : Nat) (q : ScriptMachine020E5.State n capacity) :
    (ScriptMachine020E5.run fuel q).cursor.val=min capacity (q.cursor.val+fuel) := by
  induction fuel generalizing q with
  | zero => change q.cursor.val=min capacity (q.cursor.val+0);have := q.cursor.isLt;omega
  | succ fuel ih =>
    rw [ScriptMachine020E5.run,ih,ScriptMachine020E5.step_cursor]
    omega

theorem encoded_incomplete {n capacity : Nat} (hn : n≤2^511) (fuel : Nat) (hf : fuel<capacity)
    (a : Bank Word n) (b : ScriptBuffer020E5.Buffer n capacity) :
    finish (CommandConsumer020E11.run fuel (start a (CommandConsumerRefinement020E11.encode hn b)))=none := by
  change finish (CommandConsumer020E11.run fuel (CommandConsumerRefinement020E11.model hn (ScriptMachine020E5.start a b)))=none
  rw [CommandConsumerRefinement020E11.run_model]
  simp only [finish,CommandConsumerRefinement020E11.model,Bool.false_eq_true,ite_false,script_cursor,ScriptMachine020E5.start]
  have hz : ((0 : Fin (capacity+1)).val : Nat)=0 := by simp
  simp only [hz,Nat.zero_add]
  rw [Nat.min_eq_right (Nat.le_of_lt hf),ite_eq_right (by omega)]

theorem zero_capacity {n : Nat} (a : Bank Word n) (b : Bank Word (0*3)) : consume a b=some a := rfl

end FT1536.S05.CommandConsumerBoundary020E11
