import CommandConsumer020E11

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CommandConsumerRefinement020E11
open WordRAM020 ArrayBank020E4 CommandConsumer020E11

def encode {n capacity : Nat} (hn : n≤2^511) (b : ScriptBuffer020E5.Buffer n capacity) : Bank Word (capacity*3) :=
  VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec n hn) capacity) b

theorem slot_decode {n capacity : Nat} (hn : n≤2^511) (b : ScriptBuffer020E5.Buffer n capacity) (j : Fin capacity) :
    CommandDecode020E11.decode n (slot (encode hn b) j)=some (read b j) := by
  have he : slot (encode hn b) j=(ScriptStore020E5.writeCodec n hn).encode (read b j) := by
    funext f
    exact ProducerWordLaws020E6.read_encoded_cell (ScriptStore020E5.writeCodec n hn) b j f
  rw [he]
  exact CommandDecode020E11.roundtrip hn _

/-- Proof comparison only. The operational consumer retains the encoded bank. -/
def model {n capacity : Nat} (hn : n≤2^511) (q : ScriptMachine020E5.State n capacity) : State n capacity :=
  ⟨q.target,encode hn q.script,q.cursor,false⟩

theorem step_model {n capacity : Nat} (hn : n≤2^511) (q : ScriptMachine020E5.State n capacity) :
    step (model hn q)=model hn (ScriptMachine020E5.step q) := by
  by_cases hc : q.cursor.val<capacity
  · simp only [step,model,Bool.false_eq_true,ite_false,dite_eq_left hc,slot_decode,ScriptMachine020E5.step]
  · have hd : q.cursor.val=capacity := by have := q.cursor.isLt;omega
    have hr := completed (model hn q) hd
    have hs : ScriptMachine020E5.step q=q := by rw [ScriptMachine020E5.step,dite_eq_right hc]
    exact hr.trans (congrArg (model hn) hs.symm)

theorem run_model {n capacity : Nat} (hn : n≤2^511) (fuel : Nat) (q : ScriptMachine020E5.State n capacity) :
    run fuel (model hn q)=model hn (ScriptMachine020E5.run fuel q) := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih =>
    rw [CommandConsumer020E11.run,step_model]
    exact ih (ScriptMachine020E5.step q)

theorem finish_model {n capacity : Nat} (hn : n≤2^511) (q : ScriptMachine020E5.State n capacity)
    (h : q.cursor.val=capacity) : finish (model hn q)=some q.target := by
  simp only [finish,model,Bool.false_eq_true,ite_false,h,ite_true]

theorem consumes {n capacity : Nat} (hn : n≤2^511) (a : Bank Word n) (b : ScriptBuffer020E5.Buffer n capacity) :
    consume a (encode hn b)=some (ScriptBuffer020E5.execute b a) := by
  change finish (run capacity (model hn (ScriptMachine020E5.start a b)))=_
  rw [run_model,finish_model hn _ (ScriptMachine020E5.done _ _ (by exact le_rfl)),ScriptMachine020E5.executes]

theorem no_bad_prefix {n capacity : Nat} (hn : n≤2^511) (fuel : Nat) (a : Bank Word n) (b : ScriptBuffer020E5.Buffer n capacity) :
    (run fuel (start a (encode hn b))).bad=false := by
  change (run fuel (model hn (ScriptMachine020E5.start a b))).bad=false
  rw [run_model]
  rfl

end FT1536.S05.CommandConsumerRefinement020E11
