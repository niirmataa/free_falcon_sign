import CostValueCell020E4
import CostState020E4
import ArrayAtom020E4
import CostBounds020E4

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CostAtom020E4
open WordRAM020 SyntaxTape020E ArenaTypes020E1 CostRun020E4 CostFlow020E4

def withEval {cap : Nat} (f : Ptr cap → Run (Option Word)) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (n : Node cap) (t : Token) : Run (Option ArrayState020E4.State) := overhead 16 (match t with
  | .setter r => optBind (f n.first) (fun v => CostRun020E4.map some (CostState020E4.put s r v))
  | .rom r => optBind (f n.first) (fun v => CostRun020E4.bind (CostScalar020E4.address romSize v) (fun addr => match addr with
      | none => CostRun020E4.map some (CostState020E4.fail s)
      | some k => CostRun020E4.bind (CostBank020E4.read 1 i.rom k)
          (fun w => CostRun020E4.map some (CostState020E4.put s r w))))
  | .ram r => optBind (f n.first) (fun v => CostRun020E4.bind (CostScalar020E4.address ramSize v) (fun addr => match addr with
      | none => CostRun020E4.map some (CostState020E4.fail s)
      | some k => CostRun020E4.bind (CostBank020E4.read 1 s.ram k)
          (fun w => CostRun020E4.map some (CostState020E4.put s r w))))
  | .bit r => optBind (f n.first) (fun v => CostRun020E4.bind (CostScalar020E4.address tapeSize v) (fun addr => match addr with
      | none => CostRun020E4.map some (CostState020E4.fail s)
      | some k => CostRun020E4.bind (CostBank020E4.read 1 i.tape k)
          (fun b => overhead 2 (CostRun020E4.map some (CostState020E4.put s r (if b then 1 else 0))))))
  | .store => optBind (f n.second) (fun v => CostRun020E4.bind (CostScalar020E4.address ramSize v) (fun addr => match addr with
      | none => CostRun020E4.map some (CostState020E4.fail s)
      | some k => optBind (f n.first) (fun w => CostRun020E4.map some (CostState020E4.store s k w))))
  | .emit => optBind (f n.second) (fun v => CostRun020E4.bind (CostScalar020E4.address outputSize v) (fun addr => match addr with
      | none => CostRun020E4.map some (CostState020E4.fail s)
      | some k => optBind (f n.first) (fun w => overhead 2 (CostRun020E4.map some (CostState020E4.emit s k (w != 0))))))
  | _ => charge 1 1 none)

/-- Output is the largest mutable core bank. The polynomial remains explicit. -/
def writeBound : Nat := CostState020E4.writePrice outputSize

theorem core_prices : CostState020E4.writePrice 32≤writeBound ∧
    CostState020E4.writePrice ramSize≤writeBound ∧ 4≤writeBound := by
  norm_num [writeBound,CostState020E4.writePrice,CostBank020E4.writePrice,ramSize,outputSize]

theorem value {cap : Nat} (f : Ptr cap → Run (Option Word)) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (n : Node cap) (t : Token) :
    (withEval f i s n t).value=ArrayAtom020E4.withEval (fun p => (f p).value) i s n t := by
  cases t
  case literal w => rfl
  case register r => rfl
  case binary o => rfl
  case seq => rfl
  case branch => rfl
  case loop k => rfl
  case setter r =>
    simp only [withEval,overhead_value,ArrayAtom020E4.withEval,optBind_value]
    apply congrArg ((f n.first).value.bind)
    funext v
    exact congrArg some (CostState020E4.put_value s r v)
  case rom r =>
    simp only [withEval,overhead_value,ArrayAtom020E4.withEval,optBind_value]
    apply congrArg ((f n.first).value.bind)
    funext v
    simp only [CostRun020E4.bind_value,CostScalar020E4.address_value]
    cases ha : address romSize v <;>
      simp only [CostRun020E4.bind_value,CostBank020E4.read_value,CostRun020E4.map,
        CostState020E4.put_value,CostState020E4.fail,charge]
  case ram r =>
    simp only [withEval,overhead_value,ArrayAtom020E4.withEval,optBind_value]
    apply congrArg ((f n.first).value.bind)
    funext v
    simp only [CostRun020E4.bind_value,CostScalar020E4.address_value]
    cases ha : address ramSize v <;>
      simp only [CostRun020E4.bind_value,CostBank020E4.read_value,CostRun020E4.map,
        CostState020E4.put_value,CostState020E4.fail,charge]
  case bit r =>
    simp only [withEval,overhead_value,ArrayAtom020E4.withEval,optBind_value]
    apply congrArg ((f n.first).value.bind)
    funext v
    simp only [CostRun020E4.bind_value,CostScalar020E4.address_value]
    cases ha : address tapeSize v <;>
      simp only [CostRun020E4.bind_value,CostBank020E4.read_value,CostRun020E4.map,
        CostState020E4.put_value,CostState020E4.fail,charge,overhead_value]
    all_goals rfl
  case store =>
    simp only [withEval,overhead_value,ArrayAtom020E4.withEval,optBind_value]
    apply congrArg ((f n.second).value.bind)
    funext v
    simp only [CostRun020E4.bind_value,CostScalar020E4.address_value]
    cases ha : address ramSize v with
    | none => simp only [CostRun020E4.map,CostState020E4.fail,charge]
    | some k =>
      simp only [optBind_value]
      apply congrArg ((f n.first).value.bind)
      funext w
      exact congrArg some (CostState020E4.store_value s k w)
  case emit =>
    simp only [withEval,overhead_value,ArrayAtom020E4.withEval,optBind_value]
    apply congrArg ((f n.second).value.bind)
    funext v
    simp only [CostRun020E4.bind_value,CostScalar020E4.address_value]
    cases ha : address outputSize v with
    | none => simp only [CostRun020E4.map,CostState020E4.fail,charge]
    | some k =>
      simp only [optBind_value]
      apply congrArg ((f n.first).value.bind)
      funext w
      exact congrArg some (CostState020E4.emit_value s k (w != 0))

theorem bound {cap : Nat} (f : Ptr cap → Run (Option Word)) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (n : Node cap) (t : Token) (u v : Nat)
    (hf : ∀ p,Bounded (f p) u v) :
    Bounded (withEval f i s n t) (32+2*u+writeBound) (32+2*v+writeBound) := by
  have hp : ∀ r w,Bounded (CostRun020E4.map some (CostState020E4.put s r w)) writeBound writeBound := by
    intro r w
    exact ⟨(CostState020E4.put_budget s r w).1.le.trans core_prices.1,
      (CostState020E4.put_budget s r w).2.le.trans core_prices.1⟩
  have hs : ∀ k w,Bounded (CostRun020E4.map some (CostState020E4.store s k w)) writeBound writeBound := by
    intro k w
    exact ⟨(CostState020E4.store_budget s k w).1.le.trans core_prices.2.1,
      (CostState020E4.store_budget s k w).2.le.trans core_prices.2.1⟩
  have he : ∀ k b,Bounded (CostRun020E4.map some (CostState020E4.emit s k b)) writeBound writeBound := by
    intro k b
    exact ⟨(CostState020E4.emit_budget s k b).1.le,(CostState020E4.emit_budget s k b).2.le⟩
  have hfail : Bounded (CostRun020E4.map some (CostState020E4.fail s)) writeBound writeBound :=
    ⟨core_prices.2.2,core_prices.2.2⟩
  cases t
  case setter r =>
    have h := optBind_bound (f n.first) _ u v writeBound writeBound (hf _) (hp r)
    exact CostBounds020E4.weaken (overhead_bound 16 _ _ _ h) (by omega) (by omega)
  case rom r =>
    have h : Bounded (optBind (f n.first) (fun w => CostRun020E4.bind (CostScalar020E4.address romSize w) (fun addr => match addr with
        | none => CostRun020E4.map some (CostState020E4.fail s)
        | some k => CostRun020E4.bind (CostBank020E4.read 1 i.rom k)
            (fun b => CostRun020E4.map some (CostState020E4.put s r b)))))
        (u+1+(11+writeBound)) (v+1+(11+writeBound)) := by
      apply optBind_bound _ _ u v (11+writeBound) (11+writeBound) (hf _)
      intro w
      apply bind_bound _ _ 6 6 (5+writeBound) (5+writeBound)
      · exact ⟨(CostScalar020E4.address_budget _ _).1.le,(CostScalar020E4.address_budget _ _).2.le⟩
      · intro addr
        cases addr with
        | none => exact CostBounds020E4.weaken hfail (by omega) (by omega)
        | some k =>
          apply bind_bound _ _ 3 3 (2+writeBound) (2+writeBound) ⟨le_rfl,le_rfl⟩
          intro b
          exact CostBounds020E4.weaken (hp r b) (by omega) (by omega)
    exact CostBounds020E4.weaken (overhead_bound 16 _ _ _ h) (by omega) (by omega)
  case ram r =>
    have h : Bounded (optBind (f n.first) (fun w => CostRun020E4.bind (CostScalar020E4.address ramSize w) (fun addr => match addr with
        | none => CostRun020E4.map some (CostState020E4.fail s)
        | some k => CostRun020E4.bind (CostBank020E4.read 1 s.ram k)
            (fun b => CostRun020E4.map some (CostState020E4.put s r b)))))
        (u+1+(11+writeBound)) (v+1+(11+writeBound)) := by
      apply optBind_bound _ _ u v (11+writeBound) (11+writeBound) (hf _)
      intro w
      apply bind_bound _ _ 6 6 (5+writeBound) (5+writeBound)
      · exact ⟨(CostScalar020E4.address_budget _ _).1.le,(CostScalar020E4.address_budget _ _).2.le⟩
      · intro addr
        cases addr with
        | none => exact CostBounds020E4.weaken hfail (by omega) (by omega)
        | some k =>
          apply bind_bound _ _ 3 3 (2+writeBound) (2+writeBound) ⟨le_rfl,le_rfl⟩
          intro b
          exact CostBounds020E4.weaken (hp r b) (by omega) (by omega)
    exact CostBounds020E4.weaken (overhead_bound 16 _ _ _ h) (by omega) (by omega)
  case bit r =>
    have h : Bounded (optBind (f n.first) (fun w => CostRun020E4.bind (CostScalar020E4.address tapeSize w) (fun addr => match addr with
        | none => CostRun020E4.map some (CostState020E4.fail s)
        | some k => CostRun020E4.bind (CostBank020E4.read 1 i.tape k)
            (fun b => overhead 2 (CostRun020E4.map some (CostState020E4.put s r (if b then 1 else 0)))))))
        (u+1+(11+writeBound)) (v+1+(11+writeBound)) := by
      apply optBind_bound _ _ u v (11+writeBound) (11+writeBound) (hf _)
      intro w
      apply bind_bound _ _ 6 6 (5+writeBound) (5+writeBound)
      · exact ⟨(CostScalar020E4.address_budget _ _).1.le,(CostScalar020E4.address_budget _ _).2.le⟩
      · intro addr
        cases addr with
        | none => exact CostBounds020E4.weaken hfail (by omega) (by omega)
        | some k =>
          apply bind_bound _ _ 3 3 (2+writeBound) (2+writeBound) ⟨le_rfl,le_rfl⟩
          intro b
          exact overhead_bound 2 _ _ _ (hp r (if b then 1 else 0))
    exact CostBounds020E4.weaken (overhead_bound 16 _ _ _ h) (by omega) (by omega)
  case store =>
    have h : Bounded (optBind (f n.second) (fun w => CostRun020E4.bind (CostScalar020E4.address ramSize w) (fun addr => match addr with
        | none => CostRun020E4.map some (CostState020E4.fail s)
        | some k => optBind (f n.first) (fun w => CostRun020E4.map some (CostState020E4.store s k w)))))
        (u+1+(6+(u+1+(0+writeBound)))) (v+1+(6+(v+1+(0+writeBound)))) := by
      apply optBind_bound _ _ u v (6+(u+1+(0+writeBound))) (6+(v+1+(0+writeBound))) (hf _)
      intro w
      apply bind_bound _ _ 6 6 (u+1+(0+writeBound)) (v+1+(0+writeBound))
      · exact ⟨(CostScalar020E4.address_budget _ _).1.le,(CostScalar020E4.address_budget _ _).2.le⟩
      · intro addr
        cases addr with
        | none => exact CostBounds020E4.weaken hfail (by omega) (by omega)
        | some k =>
          apply optBind_bound _ _ u v (0+writeBound) (0+writeBound) (hf _)
          intro w
          simpa only [Nat.zero_add] using hs k w
    exact CostBounds020E4.weaken (overhead_bound 16 _ _ _ h) (by omega) (by omega)
  case emit =>
    have h : Bounded (optBind (f n.second) (fun w => CostRun020E4.bind (CostScalar020E4.address outputSize w) (fun addr => match addr with
        | none => CostRun020E4.map some (CostState020E4.fail s)
        | some k => optBind (f n.first) (fun w => overhead 2 (CostRun020E4.map some (CostState020E4.emit s k (w != 0)))))))
        (u+1+(6+(u+1+(2+writeBound)))) (v+1+(6+(v+1+(2+writeBound)))) := by
      apply optBind_bound _ _ u v (6+(u+1+(2+writeBound))) (6+(v+1+(2+writeBound))) (hf _)
      intro w
      apply bind_bound _ _ 6 6 (u+1+(2+writeBound)) (v+1+(2+writeBound))
      · exact ⟨(CostScalar020E4.address_budget _ _).1.le,(CostScalar020E4.address_budget _ _).2.le⟩
      · intro addr
        cases addr with
        | none => exact CostBounds020E4.weaken hfail (by omega) (by omega)
        | some k =>
          apply optBind_bound _ _ u v (2+writeBound) (2+writeBound) (hf _)
          intro w
          exact overhead_bound 2 _ _ _ (he k (w != 0))
    exact CostBounds020E4.weaken (overhead_bound 16 _ _ _ h) (by omega) (by omega)
  all_goals change 17≤32+2*u+writeBound ∧ 17≤32+2*v+writeBound
  all_goals constructor <;> omega

end FT1536.S05.CostAtom020E4
