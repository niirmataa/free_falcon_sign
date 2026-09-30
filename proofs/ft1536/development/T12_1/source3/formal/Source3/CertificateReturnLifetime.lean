import Source3.CertificateSuffix001Outcome

/- Lifetime adapter for the previously proved statement suffix. An object
   handle resolves only while its frame is live. Return saves a value before
   removal of the handle; snapshots are mathematical witnesses, not reads of
   a dead C object. Binding allocation of this frame to the FULL certificate
   prefix is an independent obligation and is not asserted here. -/
namespace FT1536.Source3.CertificateReturnLifetime
open C99MemoryReference CertificateMemory

structure ObjectId where
  invocation : Nat
  slot : Nat
  deriving DecidableEq

structure Scoped where
  heap : Memory
  objects : ObjectId → Option ArrayPointer

def Read32 (s : Scoped) (id : ObjectId) (w : BitVec 32) : Prop :=
  ∃ p, s.objects id=some p ∧ Load32 s.heap p w

def leave (s : Scoped) (invocation : Nat) : Scoped :=
  ⟨s.heap,fun id => if id.invocation=invocation then none else s.objects id⟩

theorem dead_read_impossible (s : Scoped) (id : ObjectId) (w : BitVec 32) :
    ¬Read32 (leave s id.invocation) id w := by
  rintro ⟨p,h,_⟩
  simp [leave] at h

theorem caller_objects_preserved (s : Scoped) (frame : Nat) (id : ObjectId)
    (h : id.invocation≠frame) : (leave s frame).objects id=s.objects id := by
  simp [leave,h]

theorem caller_bytes_preserved (s : Scoped) (frame b i : Nat) :
    (leave s frame).heap.bytes b i=s.heap.bytes b i := rfl

inductive SuffixReturn (l : Layout) (id : ObjectId) (entry : Scoped) :
    Scoped → List CertificateEffects.Event → Bool → Prop where
  | returned (edge : Memory) (events : List CertificateEffects.Event) (ret : Bool)
      (localObject : entry.objects id=some (badPtr l))
      (source : CertificateExec.PinnedExec l entry.heap edge events ret) :
      SuffixReturn l id entry (leave ⟨edge,entry.objects⟩ id.invocation) events ret

theorem source_return_observation (l : Layout) (before edge : Memory)
    (events : List CertificateEffects.Event)
    (source : CertificateExec.PinnedExec l before edge events true) :
    StableBinaryByteView.flagRead (C99MemoryBridge.encode edge) l.bad=some 0 := by
  obtain ⟨code,_,h⟩ := source
  cases h with
  | sequence top reverse _ q _ form pointers ht hc hr hs hret =>
    exact (CertificateReturn.true_iff l (CertificateEffects.encode ⟨edge,events⟩)).mp
      (CertificateReturn.complete l ⟨edge,events⟩ true hret)

theorem accepted_snapshot (l : Layout) (id : ObjectId) (entry exit : Scoped)
    (events : List CertificateEffects.Event) (hl : WellFormed l)
    (legal : Legal l (C99MemoryBridge.encode entry.heap))
    (source : SuffixReturn l id entry exit events true) :
    (¬∃ w, Read32 exit id w) ∧
    ∃ edge : Memory,
      CertificateExec.PinnedExec l entry.heap edge events true ∧
      StableBinaryByteView.flagRead (C99MemoryBridge.encode edge) l.bad=some 0 ∧
      exit.heap=edge ∧
      (∀ i<1536, ∀ w,
        StableBinaryByteView.wordRead (C99MemoryBridge.encode edge)
          (StableBinary.addr (leaves l) i)=some w →
        Run2.KeygenLeafGate.positive w=true ∧
        Run2.KeygenLeafGate.lowerBits.toNat≤w.toNat ∧
        w.toNat≤Run2.KeygenLeafGate.upperBits.toNat ∧
        (1024 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue w ∧
        Run2.KeygenLeafGate.positiveNormalValue w<(332054 : ℝ)) ∧
      (∀ block offset, ¬Allowed l ⟨block,offset⟩ →
        exit.heap.bytes block offset=entry.heap.bytes block offset) := by
  cases source with
  | returned edge _ _ localObject hsource =>
    have outcome := CertificateSuffix001Outcome.source_outcome l entry.heap edge events true hl legal hsource
    refine ⟨?_,edge,hsource,source_return_observation l entry.heap edge events hsource,rfl,?_,?_⟩
    · rintro ⟨w,hw⟩
      exact dead_read_impossible ⟨edge,entry.objects⟩ id w hw
    · exact (outcome.2.2.2.2.2.2 rfl).2.2
    · exact outcome.2.2.2.1

end FT1536.Source3.CertificateReturnLifetime
