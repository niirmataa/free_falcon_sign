import CoreData020E5

namespace FT1536.S05.CoreControl020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5 CoreEncoding020E5

def faultAfter (old : Bool) : MemoryEdit020E5.Edit → Bool
  | .fault => true | _ => old

def pushMeta {cap capacity limit : Nat} (q : Core cap capacity limit) (p : Pending cap) : Meta cap capacity limit :=
  if h : q.frames.sp.val<capacity then (.push,(q.cursor,(q.left,(⟨q.frames.sp.val+1,by omega⟩,(p,q.state.fault)))))
  else (.bad,(q.cursor,(q.left,(q.frames.sp,(q.pending,q.state.fault)))))

/-- Executable control payload. It computes no new arrays: only scalar
    metadata and at most two fixed pending frames. -/
def next {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) : Meta cap capacity limit := match q.phase with
  | .check => if q.frames.sp.val=0 then (.done,(q.cursor,(q.left,(q.frames.sp,(q.pending,q.state.fault))))) else
      if q.left.val=0 then (.bad,(q.cursor,(q.left,(q.frames.sp,(q.pending,q.state.fault))))) else
        (.clear,(0,(q.left,(q.frames.sp,(q.pending,q.state.fault)))))
  | .clear => if h : q.cursor.val<cap then
      (.clear,(⟨q.cursor.val+1,by omega⟩,(q.left,(q.frames.sp,(q.pending,q.state.fault))))) else
      (.scan,(0,(q.left,(q.frames.sp,(q.pending,q.state.fault)))))
  | .scan => if h : q.cursor.val<cap then
      (.scan,(⟨q.cursor.val+1,by omega⟩,(q.left,(q.frames.sp,(q.pending,q.state.fault))))) else
      (.act,(q.cursor,(q.left,(q.frames.sp,(q.pending,q.state.fault)))))
  | .act => match ArrayFrames020E4.top q.frames with
      | none => (.bad,(q.cursor,(q.left,(q.frames.sp,(q.pending,q.state.fault)))))
      | some fr => match FixedAction020E5.action (ArrayValues020E4.lookup a q.values) a i q.state fr with
          | none => (.bad,(q.cursor,(q.left,(q.frames.sp,(q.pending,q.state.fault)))))
          | some r => (.push,(q.cursor,(⟨q.left.val-1,by have := q.left.isLt;omega⟩,
              (⟨q.frames.sp.val-1,by have := q.frames.sp.isLt;omega⟩,(r.1,faultAfter q.state.fault r.2)))))
  | .push => match q.pending with
      | .none => (.check,(q.cursor,(q.left,(q.frames.sp,(q.pending,q.state.fault)))))
      | .one _ => pushMeta q .none
      | .two f _ => pushMeta q (.one f)
  | .done | .bad => metadata q

theorem reconstruct {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) :
    CoreFieldPatch020E5.setMetadata (CoreData020E5.next a i q) (next a i q)=CoreStep020E5.step a i q := by
  cases hp : q.phase
  case check => simp only [CoreData020E5.next,next,CoreStep020E5.step,hp];split <;> first | rfl | (split <;> rfl)
  case clear =>
    simp only [CoreData020E5.next,next,CoreStep020E5.step,hp]
    split <;> rfl
  case scan =>
    simp only [CoreData020E5.next,next,CoreStep020E5.step,hp]
    split <;> rfl
  case act =>
    simp only [CoreData020E5.next,next,CoreStep020E5.step,hp]
    cases ht : ArrayFrames020E4.top q.frames with
    | none => rfl
    | some fr =>
      dsimp only
      cases ha : FixedAction020E5.action (ArrayValues020E4.lookup a q.values) a i q.state fr with
      | none => rfl
      | some r =>
        rcases r with ⟨p,e⟩
        cases e <;> rfl
  case push =>
    simp only [CoreData020E5.next,next,CoreStep020E5.step,hp]
    cases hq : q.pending with
    | none => rfl
    | one f =>
      simp only [CoreData020E5.pushData,pushMeta,ArrayFrames020E4.push,hq]
      split <;> rfl
    | two f g =>
      simp only [CoreData020E5.pushData,pushMeta,ArrayFrames020E4.push,hq]
      split <;> rfl
  case done => simp only [CoreData020E5.next,next,CoreStep020E5.step,hp];rfl
  case bad => simp only [CoreData020E5.next,next,CoreStep020E5.step,hp];rfl

end FT1536.S05.CoreControl020E5
