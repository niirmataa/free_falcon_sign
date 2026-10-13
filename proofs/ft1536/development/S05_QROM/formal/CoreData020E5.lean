import CoreFieldPatch020E5
import CoreStep020E5

namespace FT1536.S05.CoreData020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5 CoreFieldPatch020E5

/-- Metadata (including fault) is written separately; no bank changes for a
    keep/fault edit. All other edits change exactly one existing cell. -/
def edit {cap capacity limit : Nat} (q : Core cap capacity limit) : MemoryEdit020E5.Edit → Core cap capacity limit
  | .keep | .fault => q
  | .reg r w => setReg q r w
  | .ram r w => setRam q r w
  | .out r w => setOut q r w

def pushData {cap capacity limit : Nat} (q : Core cap capacity limit) (f : Frame cap) : Core cap capacity limit :=
  if h : q.frames.sp.val<capacity then setFrames q (ArrayBank020E4.write q.frames.bank ⟨q.frames.sp.val,h⟩ f) else q

def next {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) : Core cap capacity limit := match q.phase with
  | .clear => if h : q.cursor.val<cap then setValues q (ArrayBank020E4.write q.values ⟨q.cursor.val,h⟩ none) else q
  | .scan => if h : q.cursor.val<cap then
      setValues q (ArrayBank020E4.write q.values ⟨q.cursor.val,h⟩ (ArrayValues020E4.entry a q.state q.values ⟨q.cursor.val,h⟩)) else q
  | .act => match ArrayFrames020E4.top q.frames with
      | none => q
      | some fr => match FixedAction020E5.action (ArrayValues020E4.lookup a q.values) a i q.state fr with
          | none => q | some r => edit q r.2
  | .push => match q.pending with
      | .none => q | .one f => pushData q f | .two _ g => pushData q g
  | _ => q

end FT1536.S05.CoreData020E5
