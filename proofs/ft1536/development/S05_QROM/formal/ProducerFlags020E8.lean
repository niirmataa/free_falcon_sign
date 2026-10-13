import ProducerMetaWords020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerFlags020E8
open WordRAM020 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreCircuit020E6 ProducerReference020E7
open ProducerMetaWords020E8 ProducerEval020E7 ProducerWordLaws020E6 CoreEncoding020E5
attribute [local irreducible] ProducerCoreCircuit020E6.w

theorem phase (d : BoundaryPayload020E5.Data) (p : Fin 7) :
    eval (env d) (isPhase p.val)=if (phaseTag d.core.phase).val=p.val then (1 : Word) else 0 := by
  simp only [isPhase,eq_eval,literal,read_control d 0 (by decide),words,metadata]
  exact eq_nat (lt_trans (phaseTag d.core.phase).isLt (by norm_num)) (lt_trans p.isLt (by norm_num))

theorem cursor_test (d : BoundaryPayload020E5.Data) :
    eval (env d) (ProducerScalar020E6.lt (w 1) (lit 877))=if d.core.cursor.val<877 then (1 : Word) else 0 := by
  simp only [lt_eval,literal,read_control d 1 (by decide),words,metadata]
  exact lt_nat (lt_trans d.core.cursor.isLt (by norm_num)) (by norm_num)

theorem room (d : BoundaryPayload020E5.Data) :
    eval (env d) pushRoom=if d.core.frames.sp.val<28941 then (1 : Word) else 0 := by
  simp only [pushRoom,lt_eval,literal,read_control d 3 (by decide),words,metadata]
  exact lt_nat (lt_trans d.core.frames.sp.isLt (by norm_num)) (by norm_num)

theorem sp_zero (d : BoundaryPayload020E5.Data) :
    eval (env d) (ProducerScalar020E6.eq (w 3) (lit 0))=if d.core.frames.sp.val=0 then (1 : Word) else 0 := by
  simp only [eq_eval,literal,read_control d 3 (by decide),words,metadata]
  exact eq_nat (lt_trans d.core.frames.sp.isLt (by norm_num)) (by norm_num)

theorem left_zero (d : BoundaryPayload020E5.Data) :
    eval (env d) (ProducerScalar020E6.eq (w 2) (lit 0))=if d.core.left.val=0 then (1 : Word) else 0 := by
  simp only [eq_eval,literal,read_control d 2 (by decide),words,metadata]
  exact eq_nat (lt_trans d.core.left.isLt (by norm_num)) (by norm_num)

theorem cursor_add (d : BoundaryPayload020E5.Data) :
    eval (env d) (add (w 1) (lit 1))=word (d.core.cursor.val+1 : Nat) := by
  simp only [add_eval,literal,read_control d 1 (by decide),words,metadata]
  exact add_nat (lt_trans d.core.cursor.isLt (by norm_num)) (by norm_num)

theorem sp_add (d : BoundaryPayload020E5.Data) :
    eval (env d) (add (w 3) (lit 1))=word (d.core.frames.sp.val+1 : Nat) := by
  simp only [add_eval,literal,read_control d 3 (by decide),words,metadata]
  exact add_nat (lt_trans d.core.frames.sp.isLt (by norm_num)) (by norm_num)

def present {cap : Nat} : FixedAction020E5.Pending cap → Word | .none => 0 | _ => 1
def two {cap : Nat} : FixedAction020E5.Pending cap → Word | .two _ _ => 1 | _ => 0

theorem pending_present (d : BoundaryPayload020E5.Data) :
    eval (env d) pendingPresent=present d.core.pending := by
  simp only [pendingPresent,not_eval,eq_eval,literal,read_control d 4 (by decide),words,metadata]
  cases d.core.pending <;> rfl

theorem pending_two (d : BoundaryPayload020E5.Data) :
    eval (env d) pendingTwo=two d.core.pending := by
  simp only [pendingTwo,not_eval,eq_eval,literal,read_control d 5 (by decide),words,metadata]
  cases d.core.pending <;> rfl

def afterPush {cap : Nat} : FixedAction020E5.Pending cap → FixedAction020E5.Pending cap
  | .two f _ => .one f | _ => .none

theorem push_pending (d : BoundaryPayload020E5.Data) (j : Fin 11) :
    eval (env d) (pushPending j.val)=pending (afterPush d.core.pending) j.val := by
  have h9 := read_control d 9 (by decide)
  have h10 := read_control d 10 (by decide)
  have h11 := read_control d 11 (by decide)
  fin_cases j <;> simp only [pushPending,choose_eval,pending_two,h9,h10,h11,literal,words,metadata]
  all_goals cases d.core.pending <;> rfl

end FT1536.S05.ProducerFlags020E8
