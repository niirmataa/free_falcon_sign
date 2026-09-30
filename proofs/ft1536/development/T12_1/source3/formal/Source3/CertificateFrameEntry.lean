import Source3.C99Automatic32
import Source3.CertificateWorkspace

/- Memory entry for the actual local bad object. Legal caller memory does
   not supply an initialized bad cell or initialized certificate scratch.
   The source-level profile guard and parameter binding precede its zero
   assignment and must be composed by the complete function semantics. -/
namespace FT1536.Source3.CertificateFrameEntry
open C99MemoryReference C99InitializationTrace

structure Legal (base : Nat) (before : Memory) : Prop where
  aligned : base%8=0
  workspace : base+CertificateWorkspace.bytes≤before.size 0
  writable : before.writable 0=true
  localSpace : C99Automatic32.Space before

theorem allocated_workspace (base : Nat) (before : Memory) (legal : Legal base before) :
    CertificateWorkspace.Legal base (C99Automatic32.address before) (C99Automatic32.enter before) := by
  have ha := C99Automatic32.alignment (before.size 0)
  refine ⟨legal.aligned,ha.2.2,?_,?_,legal.localSpace,?_,?_⟩
  · dsimp [C99Automatic32.enter]
    simp only [ite_true]
    dsimp [C99Automatic32.address]
    have hw := legal.workspace
    omega
  · simp [C99Automatic32.enter]
  · simp [C99Automatic32.enter]
  · left
    dsimp [C99Automatic32.address]
    exact legal.workspace.trans ha.1

theorem initialized_entry (base : Nat) (before initialized : Memory)
    (legal : Legal base before)
    (zero : Store32 (C99Automatic32.enter before) (C99Automatic32.pointer before) 0 initialized) :
    CertificateWorkspace.Legal base (C99Automatic32.address before) initialized ∧
      Initialized initialized 0 (C99Automatic32.address before) 4 := by
  refine ⟨CertificateWorkspace.legal_preserved base (C99Automatic32.address before)
    (C99Automatic32.enter before) initialized (allocated_workspace base before legal)
      (store32_preserves _ _ _ _ zero),?_⟩
  intro i hi
  have hw := zero.2.2.2.2.2.1 ⟨i,hi⟩
  change initialized.bytes 0 (C99Automatic32.address before+i)=some (byte32 0 ⟨i,hi⟩) at hw
  rw [hw]
  rfl

theorem entry_exists (base : Nat) (before : Memory) (legal : Legal base before) :
    ∃ initialized, Store32 (C99Automatic32.enter before) (C99Automatic32.pointer before) 0 initialized ∧
      CertificateWorkspace.Legal base (C99Automatic32.address before) initialized ∧
      Initialized initialized 0 (C99Automatic32.address before) 4 := by
  obtain ⟨initialized,write,_⟩ := C99Automatic32.zero_initialization_exists before legal.localSpace
  exact ⟨initialized,write,initialized_entry base before initialized legal write⟩

theorem init_caller_frame (before initialized : Memory)
    (zero : Store32 (C99Automatic32.enter before) (C99Automatic32.pointer before) 0 initialized)
    (block offset : Nat) (live : offset<before.size block) :
    initialized.bytes block offset=before.bytes block offset := by
  have ha := (C99Automatic32.alignment (before.size 0)).1
  have hw := zero.2.2.2.2.2.2 block offset (by
    by_cases hb : block=0
    · right; left
      subst block
      dsimp [C99Automatic32.pointer,C99Automatic32.address,ArrayPointer.offset]
      omega
    · exact Or.inl hb)
  exact hw.trans (C99Automatic32.enter_preserves_caller before block offset live)

end FT1536.Source3.CertificateFrameEntry
