import Source3.CertificateFunctionWitness

namespace FT1536.Source3.CertificateRegionFrame
open C99MemoryReference
open CertificateFunctionReference (Arguments)
open CertificateFunctionWitness (layout)

def Outside (base block offset : Nat) : Prop :=
  block≠0 ∨ offset<base ∨ base+CertificateWorkspace.bytes≤offset

theorem bad_outside (caller : Memory) (block offset : Nat) (live : offset<caller.size block) :
    block≠0 ∨ offset<C99Automatic32.address caller ∨ C99Automatic32.address caller+4≤offset := by
  have ha := (C99Automatic32.alignment (caller.size 0)).1
  by_cases hb : block=0
  · subst block
    dsimp [C99Automatic32.address]
    omega
  · exact Or.inl hb

theorem root_outside (args : Arguments) (caller : Memory) (i block offset : Nat) (hi : i<768)
    (outside : Outside args.base block offset) :
    block≠0 ∨ offset<(Gate00Memory.rootPtr (layout args caller) i).offset ∨
      (Gate00Memory.rootPtr (layout args caller) i).offset+8≤offset := by
  dsimp [Outside,CertificateWorkspace.bytes] at outside
  dsimp [Gate00Memory.rootPtr,layout,CertificateWorkspace.layout,CertificateWorkspace.slot,ArrayPointer.offset]
  omega

theorem gate_frame (args : Arguments) (caller before after : Memory) (i : Nat) (trace : List (BitVec 64))
    (source : Gate00Memory.Loop (layout args caller) i before after trace)
    (block offset : Nat) (live : offset<caller.size block) (outside : Outside args.base block offset) :
    after.bytes block offset=before.bytes block offset := by
  induction source with
  | done => rfl
  | next i before middle after word tail guard step rest ih =>
      have hf := Gate00Memory.step_frame (layout args caller) i before middle word step block offset
        (root_outside args caller i block offset guard outside) (bad_outside caller block offset live)
      exact ih.trans hf

theorem suffix_outside (args : Arguments) (caller : Memory) (block offset : Nat)
    (live : offset<caller.size block) (outside : Outside args.base block offset) :
    ¬CertificateMemory.Allowed (layout args caller) ⟨block,offset⟩ := by
  intro allowed
  obtain ⟨hb,ha⟩ := allowed
  change block=0 at hb
  subst block
  have hbad := bad_outside caller 0 offset live
  dsimp [Outside,CertificateWorkspace.bytes] at outside
  dsimp [layout,CertificateWorkspace.layout,CertificateWorkspace.slot] at ha
  omega

theorem suffix_frame (args : Arguments) (caller before after : Memory)
    (events : List CertificateEffects.Event) (ret : Bool)
    (formed : CertificateMemory.WellFormed (layout args caller))
    (legal : CertificateMemory.Legal (layout args caller) (C99MemoryBridge.encode before))
    (source : CertificateExec.PinnedExec (layout args caller) before after events ret)
    (block offset : Nat) (live : offset<caller.size block) (outside : Outside args.base block offset) :
    after.bytes block offset=before.bytes block offset :=
  (CertificateSuffix001Outcome.source_outcome (layout args caller) before after events ret formed legal source).2.2.2.1
    block offset (suffix_outside args caller block offset live outside)

end FT1536.Source3.CertificateRegionFrame
