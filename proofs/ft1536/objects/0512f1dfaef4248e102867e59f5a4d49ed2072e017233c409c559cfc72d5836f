import B20.Word.LEPrograms
import B20.Word.LESpec

set_option maxRecDepth 16384
set_option maxHeartbeats 8000000

namespace B20.Word.LE
open B20.C.Byte

def decState (m : Memory) (p : Pointer) : State :=
  updatePointer (updatePointer (updatePointer
    ⟨m, fun _ => none, fun _ => none⟩ "data".toList (true, some p))
    "buf".toList (true, none)) "buf".toList (true, some p)

theorem dec_prefix (m : Memory) (p : Pointer) :
    execute decProgram m [.pointer p] =
      evalBody true [.ret decodeExpr] (decState m p) := by rfl

theorem loadTerm_eval (m : Memory) (p : Pointer) (b : Fin 8 → U8)
    (hr : ReadRegion m p) (hb : RegionBytes m p b) (i : Fin 8) :
    evalExpr (decState m p) (loadTerm i.val) =
      some (.word ((b i).setWidth 64 <<< (8 * i.val))) := by
  have read := read_region_byte m p b hr hb i
  fin_cases i <;> simp [loadTerm, evalExpr, decState, updatePointer, read, Value.toWord]

theorem decodeExpr_eval (s : State) (b : Fin 8 → U8)
    (h : ∀ i : Fin 8, evalExpr s (loadTerm i.val) =
      some (.word ((b i).setWidth 64 <<< (8 * i.val)))) :
    evalExpr s decodeExpr = some (.word (orWord b)) := by
  simp only [decodeExpr, evalExpr]
  rw [h 0, h 1, h 2, h 3, h 4, h 5, h 6, h 7]
  change some (.word (((b 0).setWidth 64 <<< 0) ||| ((b 1).setWidth 64 <<< 8) |||
    ((b 2).setWidth 64 <<< 16) ||| ((b 3).setWidth 64 <<< 24) |||
    ((b 4).setWidth 64 <<< 32) ||| ((b 5).setWidth 64 <<< 40) |||
    ((b 6).setWidth 64 <<< 48) ||| ((b 7).setWidth 64 <<< 56))) = _
  simp only [orWord, BitVec.shiftLeft_zero]

theorem dec_execution (m : Memory) (p : Pointer) (b : Fin 8 → U8)
    (hr : ReadRegion m p) (hb : RegionBytes m p b) :
    execute decProgram m [.pointer p] = some (some (join b), m) := by
  rw [dec_prefix]
  change (evalExpr (decState m p) decodeExpr).bind _ = _
  rw [decodeExpr_eval (decState m p) b (loadTerm_eval m p b hr hb), orWord_eq_join]
  rfl

def encState (m : Memory) (p : Pointer) (w : U64) : State :=
  updatePointer (updatePointer (updatePointer
    ⟨m, fun _ => none, fun name => if name = ['x'] then some w else none⟩
    "out".toList (false, some p)) "buf".toList (false, none))
    "buf".toList (false, some p)

def storeStatement (i : Fin 8) := Statement.store "buf".toList i.val (storeTerm i.val)

theorem enc_prefix (m : Memory) (p : Pointer) (w : U64) :
    execute encProgram m [.pointer p, .word w] =
      evalBody false (indices.map storeStatement) (encState m p w) := by rfl

theorem storeTerm_eval (s : State) (w : U64) (hx : s.words ['x'] = some w) (i : Fin 8) :
    evalExpr s (storeTerm i.val) = some (.byte (byteOf w i)) := by
  fin_cases i <;> simp [storeTerm, evalExpr, hx, Value.toWord, byteOf]

theorem store_step (s : State) (p : Pointer) (w : U64)
    (hp : s.pointers "buf".toList = some (false, some p))
    (hx : s.words ['x'] = some w) (hr : WriteRegion s.memory p) (i : Fin 8) :
    step s (storeStatement i) =
      some { s with memory := putByte s.memory (p.add i.val) (byteOf w i) } := by
  unfold storeStatement step
  rw [hp]
  change (evalExpr s (storeTerm i.val)).bind _ = _
  rw [storeTerm_eval s w hx i]
  change (writeByte s.memory (p.add i.val) (((byteOf w i).setWidth 64).setWidth 8)).bind _ = _
  rw [show ((byteOf w i).setWidth 64).setWidth 8 = byteOf w i by simp,
    write_region_byte s.memory p (byteOf w i) hr i]
  rfl

theorem stores_execution (is : List (Fin 8)) (s : State) (p : Pointer) (w : U64)
    (hp : s.pointers "buf".toList = some (false, some p))
    (hx : s.words ['x'] = some w) (hr : WriteRegion s.memory p) :
    evalBody false (is.map storeStatement) s = some (none, storeBytes p w is s.memory) := by
  induction is generalizing s with
  | nil => rfl
  | cons i is ih =>
    change (step s (storeStatement i)).bind
      (fun t => evalBody false (is.map storeStatement) t) = _
    rw [store_step s p w hp hx hr i]
    apply ih _ hp hx (put_preserves_write s.memory p (p.add i.val) (byteOf w i) hr)

theorem enc_execution (m : Memory) (p : Pointer) (w : U64) (hr : WriteRegion m p) :
    execute encProgram m [.pointer p, .word w] = some (none, stored m p w) := by
  rw [enc_prefix]
  exact stores_execution indices (encState m p w) p w rfl rfl hr

#print axioms dec_execution
#print axioms enc_execution
#print axioms stored_bytes
#print axioms join_byteOf

end B20.Word.LE
