import B20.C.Scalar
import B20.Word.SourceShift

namespace B20.C.Scalar

def shiftCalls (name : Name) (args : List Val) : Option Val :=
  if name = "fpr_ursh".toList then B20.C.execute B20.Word.urshFunction args
  else if name = "fpr_irsh".toList then B20.C.execute B20.Word.irshFunction args
  else if name = "fpr_ulsh".toList then B20.C.execute B20.Word.ulshFunction args
  else none

theorem ursh_call (x : BitVec 64) (n : Fin 64) :
    shiftCalls "fpr_ursh".toList [.u64 x, .i32 (BitVec.ofNat 32 n.val)] =
      some (.u64 (x >>> n.val)) := by
  change B20.C.execute B20.Word.urshFunction _ = _
  rw [B20.Word.ursh_execution, B20.Word.ursh_refines x n.val n.isLt]

theorem irsh_call (x : BitVec 64) (n : Fin 64) :
    shiftCalls "fpr_irsh".toList [.i64 x, .i32 (BitVec.ofNat 32 n.val)] =
      some (.i64 (x.sshiftRight n.val)) := by
  change B20.C.execute B20.Word.irshFunction _ = _
  rw [B20.Word.irsh_execution, B20.Word.irsh_refines x n.val n.isLt]

theorem ulsh_call (x : BitVec 64) (n : Fin 64) :
    shiftCalls "fpr_ulsh".toList [.u64 x, .i32 (BitVec.ofNat 32 n.val)] =
      some (.u64 (x <<< n.val)) := by
  change B20.C.execute B20.Word.ulshFunction _ = _
  rw [B20.Word.ulsh_execution, B20.Word.ulsh_refines x n.val n.isLt]

end B20.C.Scalar
