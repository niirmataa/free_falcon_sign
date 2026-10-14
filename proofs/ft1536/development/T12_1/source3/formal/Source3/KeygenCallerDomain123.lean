import Source3.KeygenCallerShape123

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCallerDomain123
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99CompactState115 (reference)
open KeygenCallerData123
open KeygenCallerMemory123
open KeygenCallerShape123

theorem tables_separate (name : C99ArrayReference.Name) (p : ArrayPointer)
    (binding : (reference base).tables name=some p) : p.block≠1 ∧ p.block≠6 := by
  rcases tables_cases name p binding with same | same | same
  all_goals subst p; decide

theorem tables_live (name : C99ArrayReference.Name) (p : ArrayPointer)
    (binding : (reference base).tables name=some p) : 0<(reference base).heap.size p.block := by
  rcases tables_cases name p binding with same | same | same
  · subst p
    change 0<(memory heap).size 20
    rw [sizes]
    decide
  · subst p
    change 0<(memory heap).size 21
    rw [sizes]
    decide
  · subst p
    change 0<(memory heap).size 22
    rw [sizes]
    decide

theorem original : KeygenMakeEntry.Original env.ctx (KeygenMakeArguments.entry (reference base) env.args) primes rev := by
  refine ⟨rfl,object_legal,profile,rfl,primes_object,rfl,rev_object,scratch_legal,by decide,?_,?_⟩
  · intro name p binding
    exact (tables_separate name p binding).1
  · exact tables_live

theorem root_legal : KeygenMakeAssembly080.LegalEntry env (reference base) primes rev := by
  refine ⟨original,by decide,by decide,?_⟩
  change C99Automatic32.align4 ((memory heap).size 2)+4<2^64
  rw [sizes,external_sizes]
  decide

theorem buffers_legal : KeygenOutputMemory081.Legal env (reference base) := by
  refine ⟨?_,?_,?_,?_,by decide,by decide,by decide,by decide,by decide,by decide⟩
  · change 0<(memory heap).size 3
    rw [sizes,external_sizes]
    decide
  · change 0<(memory heap).size 4
    rw [sizes,external_sizes]
    decide
  · change 0<(memory heap).size 5
    rw [sizes,external_sizes]
    decide
  · change 0<(memory heap).size 6
    rw [sizes,external_sizes]
    decide

theorem public_legal : KeygenPublicEntry082.Legal env (reference base) 2881 := by
  refine ⟨public_capacity,by decide,public_writable,by decide,by decide,?_⟩
  intro name p binding
  exact (tables_separate name p binding).2

/-- A closed inhabited input to the actual whole-law domain. Neither a
    successful execution nor a candidate key is among its fields. -/
def domain : KeygenWholeBytes088.Domain env (reference base) :=
  ⟨primes,rev,root_legal,buffers_legal,rfl,2881,public_legal⟩

def input : KeygenWholeStages109.Input rawEnv := ⟨reference base,domain,0,seed_fresh⟩

theorem canonical_representation : KeygenMakeInvocation.VirtualLegal env.live env.vb :=
  KeygenCanonicalAddresses108.legal rawEnv

end FT1536.Source3.KeygenCallerDomain123
