import Source3.PublicInverseTripleDeclare172
import Source3.PublicTripleIndex165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicInverseTripleReads172
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenSmallOutput (element)
open PublicU32Locals165 (Env Ready)
open PublicGenerateTable159 (Written)
open PublicInverseTripleShape172 (names loaded reads)
open PublicTailShape159 (caddW cvar)

theorem source (s : State) (a gm : ArrayPointer) (u v : Nat)
    (env : Env s names) (ready : Ready s ["w"])
    (uBound : u+2 < 1536) (vBound : v < 1024)
    (capacity : a.index+1536 ≤ a.count) (tableCapacity : gm.index+1024 ≤ gm.count)
    (binding : s.arrays "a".toList=some a) (tableBinding : s.arrays "igm_cubic".toList=some gm)
    (uSlot : USlot s "u" u) (vSlot : USlot s "v" v)
    (data : ∀ j, j < 3 → Written s.heap (element a (u+j)))
    (table : Written s.heap (element gm v)) :
    ∃ after, Exec KeygenPublicSource.program [] reads s ⟨after,.normal⟩ ∧
      Env after names ∧ Ready after loaded ∧ after.heap=s.heap := by
  obtain ⟨s1,r1,e1,v1,h1⟩ := PublicU32Locals165.load s names ["w"] env ready "f0" "a"
    (caddW "u" 0) (element a (u+0)) (by decide)
    (PublicTripleIndex165.address s a u 0 (by omega) (by decide) binding uSlot (by omega))
    (data 0 (by decide))
  have f1 := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) r1
  have a1 : s1.arrays "a".toList=some a := by rw [f1.2.1]; exact binding
  have u1 : USlot s1 "u" u := (f1.2.2 _ (by decide)).trans uSlot
  obtain ⟨s2,r2,e2,v2,h2⟩ := PublicU32Locals165.load s1 names _ e1 v1 "f1" "a"
    (caddW "u" 1) (element a (u+1)) (by decide)
    (PublicTripleIndex165.address s1 a u 1 (by omega) (by decide) a1 u1 (by omega))
    (by rw [h1]; exact data 1 (by decide))
  have f2 := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) r2
  have a2 : s2.arrays "a".toList=some a := by rw [f2.2.1]; exact a1
  have u2 : USlot s2 "u" u := (f2.2.2 _ (by decide)).trans u1
  obtain ⟨s3,r3,e3,v3,h3⟩ := PublicU32Locals165.load s2 names _ e2 v2 "f2" "a"
    (caddW "u" 2) (element a (u+2)) (by decide)
    (PublicTripleIndex165.address s2 a u 2 (by omega) (by decide) a2 u2 (by omega))
    (by rw [h2,h1]; exact data 2 (by decide))
  have f3 := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) r3
  have gm3 : s3.arrays "igm_cubic".toList=some gm := by rw [f3.2.1,f2.2.1,f1.2.1]; exact tableBinding
  have v3Slot : USlot s3 "v" v :=
    (f3.2.2 _ (by decide)).trans ((f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans vSlot))
  obtain ⟨s4,r4,e4,v4,h4⟩ := PublicU32Locals165.load s3 names _ e3 v3 "x" "igm_cubic"
    (cvar "v") (element gm v) (by decide)
    (PublicWordSteps161.address_var s3 "igm_cubic" "v" gm v (by omega) gm3 v3Slot (by omega))
    (by rw [h3,h2,h1]; exact table)
  exact ⟨s4,PublicGenerateRow159.chain_step _ _ s s1 ⟨s4,.normal⟩ r1
    (PublicGenerateRow159.chain_step _ _ s1 s2 ⟨s4,.normal⟩ r2
      (PublicGenerateRow159.chain_step _ _ s2 s3 ⟨s4,.normal⟩ r3
        (PublicGenerateRow159.chain_step _ _ s3 s4 ⟨s4,.normal⟩ r4 (.skip s4)))),
    e4,v4,h4.trans (h3.trans (h2.trans h1))⟩

end FT1536.Source3.PublicInverseTripleReads172
