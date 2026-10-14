import ProducerDataList020E8
import CoreData020E5

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerDataSpec020E9
open WordRAM020 ArrayBank020E4 CoreState020E5 CoreFieldPatch020E5 ProducerDataList020E8 NodeFrames020E2

def valueWrites {cap capacity : Nat} (j : Fin cap) (v : Option Word) : List (WordPatch020E5.Write (CoreEncoding020E5.payloadWords cap capacity)) :=
  List.ofFn (fun f : Fin 2 => (valuePointer j f,BankStorage020E3.valueWords v f))
def frameWrites {cap capacity : Nat} (j : Fin capacity) (v : Frame cap) : List (WordPatch020E5.Write (CoreEncoding020E5.payloadWords cap capacity)) :=
  List.ofFn (fun f : Fin 3 => (framePointer j f,BankStorage020E3.frameWords v f))
def pushWrites {cap capacity limit : Nat} (q : Core cap capacity limit) (f : Frame cap) :=
  if h : q.frames.sp.val<capacity then frameWrites (capacity:=capacity) ⟨q.frames.sp.val,h⟩ f else []

/-- Proof-only canonical data list. Act deliberately has no claimed refinement. -/
def writes {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (q : Core cap capacity limit) :=
  match q.phase with
  | .clear => if h : q.cursor.val<cap then valueWrites (capacity:=capacity) ⟨q.cursor.val,h⟩ none else []
  | .scan => if h : q.cursor.val<cap then valueWrites (capacity:=capacity) ⟨q.cursor.val,h⟩ (ArrayValues020E4.entry a q.state q.values ⟨q.cursor.val,h⟩) else []
  | .push => match q.pending with
    | .none => [] | .one f => pushWrites q f | .two _ g => pushWrites q g
  | _ => []

theorem values_effect {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (j : Fin cap) (v : Option Word) :
    WordPatch020E5.apply (valueWrites j v) (image hc hf hl q)=image hc hf hl (setValues q (write q.values j v)) := by
  rw [valueWrites,←values_code hc hf hl q j v]
  exact (CoreFieldPatch020E5.values hc hf hl q j v).correct

theorem frames_effect {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (j : Fin capacity) (v : Frame cap) :
    WordPatch020E5.apply (frameWrites j v) (image hc hf hl q)=image hc hf hl (setFrames q (write q.frames.bank j v)) := by
  rw [frameWrites,←frames_code hc hf hl q j v]
  exact (CoreFieldPatch020E5.frames hc hf hl q j v).correct

theorem push_effect {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (v : Frame cap) :
    WordPatch020E5.apply (pushWrites q v) (image hc hf hl q)=image hc hf hl (CoreData020E5.pushData q v) := by
  unfold pushWrites CoreData020E5.pushData
  split
  · exact frames_effect hc hf hl q _ v
  · rfl

theorem effect {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (q : Core cap capacity limit) (ha : q.phase≠.act) :
    WordPatch020E5.apply (writes a q) (image hc hf hl q)=image hc hf hl (CoreData020E5.next a i q) := by
  cases hp : q.phase <;> simp only [writes,CoreData020E5.next,hp]
  case check => rfl
  case clear => split; exact values_effect hc hf hl q _ none; rfl
  case scan => split; exact values_effect hc hf hl q _ _; rfl
  case act => exact (ha hp).elim
  case push => cases q.pending <;> first | rfl | exact push_effect hc hf hl q _
  case done => rfl
  case bad => rfl

theorem length_bound {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (q : Core cap capacity limit) : (writes a q).length≤3 := by
  cases hp : q.phase <;> simp only [writes,hp]
  case clear => split <;> simp [valueWrites]
  case scan => split <;> simp [valueWrites]
  case push => cases q.pending <;> simp only [pushWrites]; all_goals first | simp | split <;> simp [frameWrites]
  all_goals simp

end FT1536.S05.ProducerDataSpec020E9
