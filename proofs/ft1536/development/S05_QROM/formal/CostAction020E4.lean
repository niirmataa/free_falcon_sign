import CostControl020E4
import CostValues020E4
import ArrayPrefix020E4

namespace FT1536.S05.CostAction020E4
open WordRAM020 SyntaxTape020E ArenaTypes020E1 NodeFrames020E2 CostRun020E4 CostFlow020E4

def withEvaluator {cap : Nat} (f : Ptr cap → Run (Option Word)) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (fr : Frame cap) : Run (Option (ArrayAction020E4.Action cap)) := overhead 4 (match fr with
  | .run pc => optBind (CostControl020E4.inspect a pc) (fun nt => CostControl020E4.dispatch f i s pc nt.1 nt.2)
  | .again pc n => optBind (CostControl020E4.inspect a pc) (fun nt => overhead 20 (match nt.2 with
      | .loop limit => if n.val≤limit then CostControl020E4.loopAction f s pc nt.1.first nt.1.second n.val else CostRun020E4.pure none
      | _ => CostRun020E4.pure none)))

def action {cap : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (fr : Frame cap) : Run (Option (ArrayAction020E4.Action cap)) :=
  CostRun020E4.bind (CostValues020E4.build a s)
    (fun v => withEvaluator (CostValueCell020E4.lookup a v) a i s fr)

def price (cap : Nat) : Nat := CostValues020E4.buildPrice cap+140+CostAtom020E4.writeBound

theorem evaluator_value {cap : Nat} (f : Ptr cap → Run (Option Word)) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (fr : Frame cap) :
    (withEvaluator f a i s fr).value=ArrayAction020E4.withEvaluator (fun p => (f p).value) a i s fr := by
  cases fr with
  | run pc =>
    simp only [withEvaluator,overhead_value,optBind_value,CostControl020E4.inspect_value,
      CostControl020E4.dispatch_value,ArrayAction020E4.withEvaluator,ArrayAction020E4.start]
  | again pc n =>
    simp only [withEvaluator,overhead_value,optBind_value,CostControl020E4.inspect_value,
      ArrayAction020E4.withEvaluator,ArrayAction020E4.resume]
    apply congrArg ((NodeRead020E2.inspect (ArrayArena020E4.model a) pc).bind)
    funext nt
    rcases nt with ⟨node,t⟩
    cases t <;> try rfl
    dsimp only
    split
    · exact CostControl020E4.loop_value f s pc node.first node.second n.val
    · rfl

theorem evaluator_bound {cap : Nat} (f : Ptr cap → Run (Option Word)) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (fr : Frame cap)
    (u v : Nat) (hf : ∀ p,Bounded (f p) u v) :
    Bounded (withEvaluator f a i s fr) (128+2*u+CostAtom020E4.writeBound) (128+2*v+CostAtom020E4.writeBound) := by
  cases fr with
  | run pc =>
    have h := optBind_bound (CostControl020E4.inspect a pc) _ 43 43
      (50+2*u+CostAtom020E4.writeBound) (50+2*v+CostAtom020E4.writeBound)
      (CostControl020E4.inspect_bound a pc) (fun nt => CostControl020E4.dispatch_bound f i s pc nt.1 nt.2 u v hf)
    exact CostBounds020E4.weaken (overhead_bound 4 _ _ _ h) (by omega) (by omega)
  | again pc n =>
    apply CostBounds020E4.weaken (overhead_bound 4 (43+1+(20+(19+u))) (43+1+(20+(19+v))) _ ?_) (by omega) (by omega)
    apply optBind_bound _ _ 43 43 (20+(19+u)) (20+(19+v)) (CostControl020E4.inspect_bound a pc)
    rintro ⟨node,t⟩
    apply overhead_bound 20 (19+u) (19+v)
    cases t
    case loop limit =>
      dsimp only
      split
      · exact CostControl020E4.loop_bound f s pc node.first node.second n.val u v hf
      · exact ⟨Nat.zero_le _,Nat.zero_le _⟩
    all_goals exact ⟨Nat.zero_le _,Nat.zero_le _⟩

theorem value {cap : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (fr : Frame cap) : (action a i s fr).value=ArrayAction020E4.action a i s fr := by
  simp only [action,CostRun020E4.bind_value,CostValues020E4.build_value,evaluator_value,
    CostValueCell020E4.lookup_value,ArrayAction020E4.action]

theorem bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (fr : Frame cap) : Bounded (action a i s fr) (price cap) (price cap) := by
  have h := bind_bound (CostValues020E4.build a s) _ (CostValues020E4.buildPrice cap) (CostValues020E4.buildPrice cap)
    (128+2*6+CostAtom020E4.writeBound) (128+2*6+CostAtom020E4.writeBound)
    (CostValues020E4.build_bound a s) (fun vals => evaluator_bound (CostValueCell020E4.lookup a vals) a i s fr 6 6
      (CostValueCell020E4.lookup_bound a vals))
  exact CostBounds020E4.weaken h (by unfold price;omega) (by unfold price;omega)

theorem prefix_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (fr : Frame cap) (q : ArrayAction020E4.Action cap)
    (h : (action a i s fr).value=some q) : q.1.length≤2 :=
  ArrayPrefix020E4.action_prefix a i s fr q ((value a i s fr).symm.trans h)

end FT1536.S05.CostAction020E4
