import Source3.CertificateEntryDeclarations
import Source3.CertificatePrefixFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateWorkspaceViews
open C99MemoryReference
open C99ArrayReference (State)
open CertificateAfterConversion (workspacePointer)

def Inside (base : Nat) (p : ArrayPointer) : Prop :=
  p.block=0 ∧ base≤p.offset ∧ p.base+p.elementBytes*p.count≤base+CertificateWorkspace.bytes

theorem pointer_inside (base slot : Nat) : Inside base (workspacePointer base slot) := by
  simp [Inside,workspacePointer,ArrayPointer.offset,CertificateWorkspace.bytes]

theorem aliases_inside (base : Nat) (before : State)
    (tmp : before.arrays "tmp".toList=some (workspacePointer base 0)) :
    CertificatePrefixFrame.Within base (CertificateAliases.installed base (CertificateEntryDeclarations.ready before)) := by
  intro name member p binding
  change name∈["tmp","tf","tg","tF","tG","g00","g10","g11","gxx","tree","t3","leaves","scratch"].map String.toList at member
  simp only [List.map_cons,List.map_nil,List.mem_cons,List.not_mem_nil,or_false] at member
  change before.arrays ['t','m','p']=some (workspacePointer base 0) at tmp
  rcases member with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  all_goals
    simp [CertificateAliases.installed,CertificateAliases.bindings,C99ArrayReference.bindPointer,
      CertificateEntryDeclarations.ready,C99DeclarationStatements.effect,CertificateDeclarations.clearAll,
      CertificateDeclarations.clear,CertificateDeclarations.firstNames,CertificateDeclarations.secondNames,
      CertificateDeclarations.thirdNames,tmp] at binding
  all_goals subst p; exact pointer_inside base _

theorem point_outside (base : Nat) (p : ArrayPointer) (inside : Inside base p) (block offset : Nat)
    (outside : block≠0 ∨ offset<base ∨ base+CertificateWorkspace.bytes≤offset) :
    C99PointerFootprint.PointOutside p block offset := by
  obtain ⟨hb,hl,hu⟩ := inside
  dsimp [C99PointerFootprint.PointOutside]
  rw [hb]
  omega

end FT1536.Source3.CertificateWorkspaceViews
