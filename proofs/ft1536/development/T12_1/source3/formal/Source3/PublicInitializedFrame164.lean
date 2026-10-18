import Source3.PublicScopedFrame162
import Source3.PublicGenerateTable159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A legal uint16 store may change a word, but cannot make an initialized
   word unreadable. This applies even to overlapping locations and lifts
   through the original supported statement semantics. It is not a claim
   that values outside the data buffer, or inside it, remain equal. -/
namespace FT1536.Source3.PublicInitializedFrame164
open C99ArrayReference (State)
open C99MemoryReference (Memory ArrayPointer Byte Allocated)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenSmallOutput (Store16 byte16)
open PublicGenerateTable159 (Written)
open KeygenPublicTableControl (supported)

theorem store_byte (before after : Memory) (p : ArrayPointer) (w : BitVec 16)
    (write : Store16 before p w after) (block offset : Nat) (old : Byte)
    (initialized : before.bytes block offset=some old) :
    ∃ value, after.bytes block offset=some value := by
  by_cases same : block=p.block
  · subst block
    by_cases first : offset=p.offset
    · rw [first]
      exact ⟨byte16 w 0,write.2.2.2.2.2.1 0⟩
    · by_cases second : offset=p.offset+1
      · rw [second]
        exact ⟨byte16 w 1,write.2.2.2.2.2.1 1⟩
      · exact ⟨old,(write.2.2.2.2.2.2 p.block offset (Or.inr (by omega))).trans initialized⟩
  · exact ⟨old,(write.2.2.2.2.2.2 block offset (Or.inl same)).trans initialized⟩

theorem store_written (before after : Memory) (p q : ArrayPointer) (w : BitVec 16)
    (write : Store16 before p w after) (written : Written before q) : Written after q := by
  classical
  obtain ⟨old,read⟩ := written
  cases read with
  | load bytes allocated width initialized =>
      have each : ∀ i : Fin 2, ∃ value, after.bytes q.block (q.offset+i.val)=some value :=
        fun i => store_byte before after p w write q.block (q.offset+i.val) (bytes i) (initialized i)
      let newBytes : Fin 2 → Byte := fun i => Classical.choose (each i)
      refine ⟨C99NarrowReads.le16 newBytes,.load after q newBytes ?_ width ?_⟩
      · simpa only [Allocated,write.2.2.2.1] using allocated
      · intro i
        exact Classical.choose_spec (each i)

structure Frame (before after : Memory) : Prop where
  size : after.size=before.size
  writable : after.writable=before.writable
  written : ∀ p, Written before p → Written after p

theorem refl (heap : Memory) : Frame heap heap := ⟨rfl,rfl,fun _ old => old⟩

theorem trans (a b c : Memory) (first : Frame a b) (second : Frame b c) : Frame a c :=
  ⟨second.size.trans first.size,second.writable.trans first.writable,
    fun p old => second.written p (first.written p old)⟩

theorem store_frame (before after : Memory) (p : ArrayPointer) (w : BitVec 16)
    (write : Store16 before p w after) : Frame before after :=
  ⟨write.2.2.2.1,write.2.2.2.2.1,fun q old => store_written before after p q w write old⟩

theorem source (program : KeygenPublicExec.Program) (signed : List C99ArrayReference.Name)
    (code : KeygenPublicExec.Stmt) (s : State) (out : Result) (checked : supported code=true)
    (run : Exec program signed code s out) : Frame s.heap out.state.heap := by
  induction run with
  | skip | scalar | assign | loopFalse => exact refl _
  | store _ _ _ _ _ _ _ _ _ _ write => exact store_frame _ _ _ _ write
  | seqNormal _ _ _ middle _ _ _ first second =>
      exact trans _ middle.heap _ (first (Bool.and_eq_true_iff.mp checked).1)
        (second (Bool.and_eq_true_iff.mp checked).2)
  | seqExit _ _ _ _ _ _ first => exact first (Bool.and_eq_true_iff.mp checked).1
  | scope _ pointers _ _ _ _ ih =>
      cases pointers with
      | nil => exact ih checked
      | cons => cases checked
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal _ _ _ _ middle next _ _ _ _ _ _ _ first second rest =>
      exact trans _ middle.heap _ (first (Bool.and_eq_true_iff.mp checked).1)
        (trans _ next.heap _ (second (Bool.and_eq_true_iff.mp checked).2) (rest checked))
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | declarePointer | pointer | call | arrayScope | ret | retVoid => cases checked

end FT1536.Source3.PublicInitializedFrame164
