import Source3.StableTopBranches

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableTopCore
open StableTopSyntax StableTopMemory StableTopEffects StableTopAtoms StableTopBranchLayout

theorem run_expansion (l : Layout) (heap : B20.C.Byte.Memory) : StableTopExec.run l heap=
    (StableTopExec.loop l expected FprOfThree.three 256 ⟨heap,[]⟩).bind (StableTopExec.branches l expected.branches) := by
  unfold StableTopExec.run
  rw [pinned_source]
  change (CLogic.execute FprOfThree.modelCalls FprScaledAST.ofCode [.i32 3]).bind
    (fun value => match value with
      | .u64 three => (StableTopExec.loop l expected three 256 ⟨heap,[]⟩).bind (StableTopExec.branches l expected.branches)
      | _ => none)=_
  rw [FprOfThree.of_three_model]
  rfl

theorem source_exists (l : Layout) (before : C99MemoryReference.Memory)
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before)) :
    ∃ after checks, StableTopReference.PinnedExec l before after checks := by
  let initial : StableBinaryCExec.State := ⟨C99MemoryBridge.encode before,[]⟩
  obtain ⟨sl,hloop,eloop,fill⟩ := StableTopLoop.loop_exists l hl FprOfThree.three initial legal 256 (by omega)
  obtain ⟨out,hbranches,_,_⟩ := StableTopBranches.exists_execution l hl expected.branches
    StableTopBranches.pinned_branches sl eloop.legal (StableTopLoop.filled_all l sl.heap fill)
  refine ⟨C99MemoryBridge.decode out.heap,out.checks,expected,pinned_source,?_⟩
  have h := StableTopReference.Exec.call (l:=l) (code:=expected) (before:=before) FprOfThree.three 256
    (C99HelperAtoms.decode sl) (C99HelperAtoms.decode out) FprOfThree.source_exists
    (by simpa only [initial,C99HelperAtoms.decode,C99MemoryBridge.decode_encode] using hloop)
    (by change ¬0+3*256<768; decide) hbranches
  exact h

theorem complete (l : Layout) (before after : C99MemoryReference.Memory) (checks : List (BitVec 64))
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before))
    (source : StableTopReference.PinnedExec l before after checks) :
    StableTopExec.run l (C99MemoryBridge.encode before)=some ⟨C99MemoryBridge.encode after,checks⟩ ∧
      Safe l (C99MemoryBridge.encode before) ⟨C99MemoryBridge.encode after,checks⟩ := by
  obtain ⟨code,hpin,hr⟩ := source
  have heq : code=expected := Option.some.inj (hpin.symm.trans pinned_source)
  subst code
  cases hr with
  | call three iterations sl out hinit hloop hfalse hbranches =>
      have hthree : three=FprOfThree.three := C99IntegerReference.Value.uint64.inj (FprOfThree.source_exact _ hinit)
      subst three
      have hn := StableTopBodyBridge.final_index l FprOfThree.three iterations ⟨before,[]⟩ sl hloop hfalse
      subst iterations
      let initial : StableBinaryCExec.State := ⟨C99MemoryBridge.encode before,[]⟩
      have hmloop := StableTopBodyBridge.loop_complete l expected FprOfThree.three 256 ⟨before,[]⟩ sl hloop
      obtain ⟨candidate,hcandidate,ecandidate,fill⟩ := StableTopLoop.loop_exists l hl FprOfThree.three initial legal 256 (by omega)
      have hmcan := StableTopBodyBridge.loop_complete l expected FprOfThree.three 256
        (C99HelperAtoms.decode initial) (C99HelperAtoms.decode candidate) hcandidate
      rw [C99HelperAtoms.encode_decode,C99HelperAtoms.encode_decode] at hmcan
      have hc : candidate=C99HelperAtoms.encode sl := Option.some.inj (hmcan.symm.trans hmloop)
      rw [hc] at ecandidate fill
      have hread := StableTopLoop.filled_all l (C99HelperAtoms.encode sl).heap fill
      obtain ⟨hmbranches,ebranches,_⟩ := StableTopBranches.complete l hl expected.branches
        StableTopBranches.pinned_branches (C99HelperAtoms.encode sl) out ecandidate.legal hread
        (by simpa only [C99HelperAtoms.decode_encode] using hbranches)
      refine ⟨?_,(effect_trans ecandidate ebranches).safe _ (safe_initial l _)⟩
      rw [run_expansion]
      change (StableTopExec.loop l expected FprOfThree.three 256 (C99HelperAtoms.encode ⟨before,[]⟩)).bind
        (StableTopExec.branches l expected.branches)=_
      rw [hmloop]
      exact hmbranches

end FT1536.Source3.StableTopCore

#check @FT1536.Source3.StableTopCore.source_exists
#check @FT1536.Source3.StableTopCore.complete
#print axioms FT1536.Source3.StableTopCore.source_exists
#print axioms FT1536.Source3.StableTopCore.complete
