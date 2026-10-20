import Source3.KeygenPublicUpperBody

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Byte-level frames for the two upward bodies. Every executed write lands
   in one two-byte cell of the bound gm/igm tables, so allocation metadata
   and all bytes outside the full table ranges survive either body. These
   facts are derived from the actual store executions, not from a heap
   postulate. -/
namespace FT1536.Source3.KeygenPublicUpperFrames
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer Memory)
open KeygenPublicExec (Exec)
open KeygenPublicTableControl (seq_inv)
open KeygenPublicTableStore (Pointers)
open KeygenSmallOutput (element Store16)

def OutsideFull (gm igm : ArrayPointer) (block offset : Nat) : Prop :=
  ∀ p∈[gm,igm], block≠p.block ∨ offset<p.offset ∨ p.offset+2048≤offset
def UpperFrame (gm igm : ArrayPointer) (before after : Memory) : Prop :=
  after.size=before.size ∧ after.writable=before.writable ∧
    ∀ block offset, OutsideFull gm igm block offset → after.bytes block offset=before.bytes block offset
theorem frame_refl (gm igm : ArrayPointer) (heap : Memory) : UpperFrame gm igm heap heap :=
  ⟨rfl,rfl,fun _ _ _ => rfl⟩
theorem frame_trans (gm igm : ArrayPointer) (a b c : Memory)
    (first : UpperFrame gm igm a b) (second : UpperFrame gm igm b c) : UpperFrame gm igm a c :=
  ⟨second.1.trans first.1,second.2.1.trans first.2.1,
    fun block offset h => (second.2.2 block offset h).trans (first.2.2 block offset h)⟩
theorem from_last (gm igm : ArrayPointer) (before after : Memory)
    (source : KeygenPublicTableStore.LastFrame gm igm before after) : UpperFrame gm igm before after := by
  refine ⟨source.1,source.2.1,?_⟩
  intro block offset outside
  exact source.2.2 block offset (fun p member => by
    rcases outside p member with h | h | h
    · exact Or.inl h
    · exact Or.inr (Or.inl (by omega))
    · exact Or.inr (Or.inr h))
theorem full_write_frame (gm igm p : ArrayPointer) (member : p∈[gm,igm]) (width : p.elementBytes=2)
    (i : Nat) (hi : i<1024) (before after : Memory) (w : BitVec 16)
    (source : Store16 before (element p i) w after) : UpperFrame gm igm before after := by
  refine ⟨source.2.2.2.1,source.2.2.2.2.1,?_⟩
  intro block offset outside
  apply source.2.2.2.2.2.2
  have separate := outside p member
  simp only [element,ArrayPointer.offset,width] at *
  omega

theorem store_frame (s : State) (out : Result) (gm igm : ArrayPointer) (p : ArrayPointer)
    (member : p∈[gm,igm]) (width : p.elementBytes=2) (name : String) (index : CLogic.Expr)
    (e : KeygenWordExpr.Expr) (i : Nat) (hi : i<1024)
    (binding : s.arrays name.toList=some p)
    (value : ∀ v, KeygenPublicWord.scalar s index v → v.integer.toNat=i)
    (source : Exec KeygenPublicSource.program [] (.store name.toList index true e) s out) :
    UpperFrame gm igm s.heap out.state.heap := by
  cases source with
  | store _ _ _ _ before heap actual v address evaluated write =>
      rw [KeygenPublicTableIndex.address s name index p actual i binding value address] at write
      exact full_write_frame gm igm p member width i hi _ _ _ write

theorem cube_frame (s : State) (out : Result) (gm igm : ArrayPointer) (i : Nat) (hi : i<1024)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (pointers : Pointers s gm igm)
    (counter : KeygenNttLoopSupport.USlot s "u" i)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.cubeBody s out) :
    UpperFrame gm igm s.heap out.state.heap := by
  cases source with
  | scope _ _ _ _ inner executed =>
      obtain ⟨s1,d,tail1⟩ := seq_inv _ _ s inner rfl executed
      obtain ⟨s2,yload,tail2⟩ := seq_inv _ _ s1 inner rfl tail1
      obtain ⟨s3,zload,tail3⟩ := seq_inv _ _ s2 inner rfl tail2
      obtain ⟨s4,gst,tail4⟩ := seq_inv _ _ s3 inner rfl tail3
      obtain ⟨s5,ist,last⟩ := seq_inv _ _ s4 inner rfl tail4
      cases last
      have p1 := KeygenPublicTableStore.pointers_after _ s ⟨s1,.normal⟩ gm igm rfl pointers d
      have p2 := KeygenPublicTableStore.pointers_after _ s1 ⟨s2,.normal⟩ gm igm rfl p1 yload
      have p3 := KeygenPublicTableStore.pointers_after _ s2 ⟨s3,.normal⟩ gm igm rfl p2 zload
      have p4 := KeygenPublicTableStore.pointers_after _ s3 ⟨s4,.normal⟩ gm igm rfl p3 gst
      have u3 := KeygenPublicUpperBody.counter_after _ s2 ⟨s3,.normal⟩ i
        (KeygenPublicUpperBody.counter_after _ s1 ⟨s2,.normal⟩ i
          (KeygenPublicUpperBody.counter_after _ s ⟨s1,.normal⟩ i counter rfl (by decide) d)
          rfl (by decide) yload) rfl (by decide) zload
      have u4 := KeygenPublicUpperBody.counter_after _ s3 ⟨s4,.normal⟩ i u3 rfl (by decide) gst
      have h1 := KeygenPublicUpperAtoms.declaration_heap _ _ s ⟨s1,.normal⟩ d
      have h2 := KeygenPublicTableControl.assign_heap _ _ s1 ⟨s2,.normal⟩ yload
      have h3 := KeygenPublicTableControl.assign_heap _ _ s2 ⟨s3,.normal⟩ zload
      dsimp only at h1 h2 h3
      have f1 := store_frame s3 ⟨s4,.normal⟩ gm igm gm (by simp) gw "gm"
        KeygenPublicUpperProgram.u _ i hi p3.1
        (KeygenPublicUpperAtoms.index_value s3 "u" i (by omega) u3) gst
      have f2 := store_frame s4 ⟨s5,.normal⟩ gm igm igm (by simp) iw "igm"
        KeygenPublicUpperProgram.u _ i hi p4.2
        (KeygenPublicUpperAtoms.index_value s4 "u" i (by omega) u4) ist
      have f0 : UpperFrame gm igm s.heap s4.heap := by rw [← h1,← h2,← h3]; exact f1
      exact frame_trans gm igm s.heap s4.heap s5.heap f0 f2

theorem square_frame (s : State) (out : Result) (gm igm : ArrayPointer) (i : Nat) (hi : i<1024)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (pointers : Pointers s gm igm)
    (counter : KeygenNttLoopSupport.USlot s "u" i)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.squareBody s out) :
    UpperFrame gm igm s.heap out.state.heap := by
  cases source with
  | scope _ _ _ _ inner executed =>
      obtain ⟨s1,d,tail1⟩ := seq_inv _ _ s inner rfl executed
      obtain ⟨s2,vset,tail2⟩ := seq_inv _ _ s1 inner rfl tail1
      obtain ⟨s3,gst,tail3⟩ := seq_inv _ _ s2 inner rfl tail2
      obtain ⟨s4,ist,last⟩ := seq_inv _ _ s3 inner rfl tail3
      cases last
      have p1 := KeygenPublicTableStore.pointers_after _ s ⟨s1,.normal⟩ gm igm rfl pointers d
      have p2 := KeygenPublicTableStore.pointers_after _ s1 ⟨s2,.normal⟩ gm igm rfl p1 vset
      have p3 := KeygenPublicTableStore.pointers_after _ s2 ⟨s3,.normal⟩ gm igm rfl p2 gst
      have u2 := KeygenPublicUpperBody.counter_after _ s1 ⟨s2,.normal⟩ i
        (KeygenPublicUpperBody.counter_after _ s ⟨s1,.normal⟩ i counter rfl (by decide) d)
        rfl (by decide) vset
      have u3 := KeygenPublicUpperBody.counter_after _ s2 ⟨s3,.normal⟩ i u2 rfl (by decide) gst
      have h1 := KeygenPublicUpperAtoms.declaration_heap _ _ s ⟨s1,.normal⟩ d
      have h2 := KeygenPublicTableControl.assign_heap _ _ s1 ⟨s2,.normal⟩ vset
      dsimp only at h1 h2
      have f1 := store_frame s2 ⟨s3,.normal⟩ gm igm gm (by simp) gw "gm"
        KeygenPublicUpperProgram.u _ i hi p2.1
        (KeygenPublicUpperAtoms.index_value s2 "u" i (by omega) u2) gst
      have f2 := store_frame s3 ⟨s4,.normal⟩ gm igm igm (by simp) iw "igm"
        KeygenPublicUpperProgram.u _ i hi p3.2
        (KeygenPublicUpperAtoms.index_value s3 "u" i (by omega) u3) ist
      have f0 : UpperFrame gm igm s.heap s3.heap := by rw [← h1,← h2]; exact f1
      exact frame_trans gm igm s.heap s3.heap s4.heap f0 f2

end FT1536.Source3.KeygenPublicUpperFrames
