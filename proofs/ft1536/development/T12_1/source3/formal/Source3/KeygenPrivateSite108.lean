import Source3.KeygenPlainHead108

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPrivateSite108
open C99MemoryReference
open C99ArrayReference (State)
open KeygenMakeInvocation (Env SmallSite)
open KeygenCanonicalAddresses108 (canonical)
open KeygenCodecTypedSegments (arguments)
open KeygenMakeSkeCells (SkeCellWord)

def Words (env : Env) (before : State) : Prop := ∀ i, SkeCellWord (canonical env) i before

theorem arguments_equal (env : Env) (before : State) (i : Fin 4) (a b : Memory) (x y : BitVec 64)
    (first : SmallSite (canonical env) before i a x) (second : SmallSite (canonical env) before i b y)
    (word : SkeCellWord (canonical env) i before) :
    arguments (canonical env) before i a x first = arguments (canonical env) before i b y second := by
  have sourceA := KeygenSkeBinding108.material env before i a x first word
  have sourceB := KeygenSkeBinding108.material env before i b y second word
  have capacities : first.klen = second.klen := by simpa using first.klenCell.symm.trans second.klenCell
  have offsets : first.skoff = second.skoff := by simpa using first.skoffCell.symm.trans second.skoffCell
  have rings : first.ter = second.ter := by simpa using first.terCell.symm.trans second.terCell
  have degrees : first.logn = second.logn := by simpa using first.lognCell.symm.trans second.lognCell
  simp only [arguments, sourceA, sourceB, capacities, offsets, rings, degrees]

theorem call_unique (env : Env) (before : State) (i : Fin 4) (a b : Memory) (x y : BitVec 64)
    (first : SmallSite (canonical env) before i a x) (second : SmallSite (canonical env) before i b y)
    (word : SkeCellWord (canonical env) i before)
    (runA : KeygenCodecExecution.Call (arguments (canonical env) before i a x first) before.heap a x)
    (runB : KeygenCodecExecution.Call (arguments (canonical env) before i b y second) before.heap b y) : a = b ∧ x = y := by
  have same := arguments_equal env before i a b x y first second word
  rw [same] at runA
  exact KeygenPrivateDispatcher107.call_unique _ before.heap a b x y runA runB

/-- All four pointer words survive any actual codec exit, including a
    capacity failure after a partial write. -/
theorem words_after (env : Env) (before : State) (i : Fin 4) (after : Memory) (ret : BitVec 64)
    (site : SmallSite (canonical env) before i after ret)
    (source : KeygenCodecExecution.Call (arguments (canonical env) before i after ret site) before.heap after ret)
    (separate : (canonical env).args.privkey.block ≠ (canonical env).blocks 5)
    (words : Words env before) : Words env {before with heap := after} := by
  let c : KeygenCodecTypedSegments.Site (canonical env) := ⟨i,before,after,ret,site,source⟩
  intro j
  exact KeygenCodecSkeSurvival.word_after_call (canonical env) before i j after ret site
    (KeygenCodecTypedSegments.projectedSite c).body separate (words j)

end FT1536.Source3.KeygenPrivateSite108
