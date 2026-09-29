import B20.Word.LEExecution

namespace B20.Word
open B20.C.Byte

/-- The required LE64 instance: exact parsed source, legal byte access,
complete execution characterization, round-trip, and an arbitrary-address
frame. The C object/offset model and LP64 size bound are explicit. -/
theorem load_store_le_refines (m : Memory) (p : Pointer) (w : U64)
    (legal : WriteRegion m p) :
    parseFunction (LE.slice B20.Pinned.shakeLines 56 15) = some LE.decProgram ∧
    parseFunction (LE.slice B20.Pinned.shakeLines 75 15) = some LE.encProgram ∧
    (∀ result final, CExec LE.decProgram m [.pointer p] result final ↔
      result = some (LE.join (LE.bufferBytes m p)) ∧ final = m) ∧
    (∀ result final, CExec LE.encProgram m [.pointer p, .word w] result final ↔
      result = none ∧ final = LE.stored m p w) ∧
    RegionBytes (LE.stored m p w) p (LE.byteOf w) ∧
    CExec LE.decProgram (LE.stored m p w) [.pointer p] (some w) (LE.stored m p w) ∧
    (∀ q, q.block ≠ p.block ∨ q.offset < p.offset ∨ p.offset + 8 ≤ q.offset →
      (LE.stored m p w).contents q = m.contents q) ∧
    (LE.stored m p w).length = m.length ∧
    (LE.stored m p w).writable = m.writable := by
  refine ⟨LE.dec_parses, LE.enc_parses, ?_, ?_, LE.stored_bytes m p w, ?_, ?_, ?_, ?_⟩
  · intro result final
    unfold CExec
    rw [LE.dec_execution m p (LE.bufferBytes m p) legal.1 (LE.bufferBytes_spec m p legal.1)]
    simp only [Option.some.injEq, Prod.mk.injEq, eq_comm]
  · intro result final
    unfold CExec
    rw [LE.enc_execution m p w legal]
    simp only [Option.some.injEq, Prod.mk.injEq, eq_comm]
  · unfold CExec
    rw [LE.dec_execution (LE.stored m p w) p (LE.byteOf w)
      (LE.storeBytes_preserves_write p w LE.indices m legal).1 (LE.stored_bytes m p w),
      LE.join_byteOf]
  · intro q hq
    apply LE.storeBytes_frame
    intro i he
    have hb := congrArg Pointer.block he
    have ho := congrArg Pointer.offset he
    dsimp only [Pointer.add] at hb ho
    rcases hq with hq | hq | hq
    · exact hq hb
    · omega
    · have hi := i.isLt; omega
  · rfl
  · rfl

/-- Read-only callers need no write permission. -/
theorem load_le_refines (m : Memory) (p : Pointer) (legal : ReadRegion m p) :
    ∀ result final, CExec LE.decProgram m [.pointer p] result final ↔
      result = some (LE.join (LE.bufferBytes m p)) ∧ final = m := by
  intro result final
  unfold CExec
  rw [LE.dec_execution m p (LE.bufferBytes m p) legal (LE.bufferBytes_spec m p legal)]
  simp only [Option.some.injEq, Prod.mk.injEq, eq_comm]

#check @load_store_le_refines
#print axioms load_store_le_refines
#print axioms load_le_refines

end B20.Word
