import Source3.CrtWordOps205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtState205
open C99ArrayReference (State)
open KeygenModpR2Exec (Slot)

def set32 (s : State) (name : String) (w : BitVec 32) := ModularAtoms178.set s name w
def set64 (s : State) (name : String) (w : BitVec 64) := C99ArrayReference.bindValue s name.toList .uint64 (.uint64 w)
def Slot64 (s : State) (name : String) (w : BitVec 64) := s.locals name.toList=some (.uint64,some (.uint64 w))

theorem cell32 (s : State) (name : String) (w : BitVec 32) : Slot (set32 s name w) name w := ModularAtoms178.slot s name w

theorem cell64 (s : State) (name : String) (w : BitVec 64) : Slot64 (set64 s name w) name w := by
  simp only [Slot64,set64,C99ArrayReference.bindValue,C99ScalarReference.set,ite_true,CrtWordOps205.self64]

theorem keep32 (s : State) (name other : String) (w : BitVec 32) (different : other.toList≠name.toList) :
    (set32 s name w).locals other.toList=s.locals other.toList := ModularAtoms178.outside s name other w different

theorem keep64 (s : State) (name other : String) (w : BitVec 64) (different : other.toList≠name.toList) :
    (set64 s name w).locals other.toList=s.locals other.toList := by
  simp only [set64,C99ArrayReference.bindValue,C99ScalarReference.set,different,ite_false]

theorem expr32 (s : State) (name : String) (w : BitVec 32) (h : Slot s name w) :
    KeygenWordExpr.Eval s (.scalar (.var name.toList)) (.uint32 w) := .scalar _ _ (.variable _ _ _ h)

theorem expr64 (s : State) (name : String) (w : BitVec 64) (h : Slot64 s name w) :
    KeygenWordExpr.Eval s (.scalar (.var name.toList)) (.uint64 w) := .scalar _ _ (.variable _ _ _ h)

end FT1536.Source3.CrtState205
