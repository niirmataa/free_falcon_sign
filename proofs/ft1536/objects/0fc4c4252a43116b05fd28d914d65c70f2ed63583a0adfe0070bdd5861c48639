import Run2.MeteredExecution

namespace FT1536.Run2.PrefixResources
open Games FT1536.Relation PublicSimulation StateResources LocalMachineCode
open FT1536.BitCost MachineAccounting MeteredExecution

def ValidFinished (beta : Budget) (cs : List Rq) : Option Finished → Prop
  | none => True
  | some f => Shape beta.bytes (beta.qs+beta.qh) f.state ∧ Good cs f.state ∧
      f.forgery.message.length+f.forgery.nonce.length≤beta.bytes

theorem done_cost (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (coins : Fin beta.coinBits → Bool) (st : State) (f : Forgery)
    (ha : aCost beta A ac h coins st≤AdversaryMachine.cost beta (aCode beta A ac))
    (hs : stateBits st≤SamplerMachine.stateCap beta)
    (hf : (commandBits (.done f)).length≤AdversaryMachine.outputCap beta) :
    held (staticBits beta (aCode beta A ac) (sCode beta S sc)+stateBits st)
      (plus (aCost beta A ac h coins st) (frameCost st st (.done f)))≤turnBound beta A S ac sc := by
  rcases ha with ⟨hat,haw,haL⟩
  rcases frame_bound beta st st (.done f) hs hs hf with ⟨hft,hfw,hfL⟩
  change _≤_ ∧ _≤_ ∧ _≤_
  dsimp only [turnBound,held,plus]
  omega

theorem hash_cost (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (cs : List.Vector Rq (beta.qh+1)) (coins : Fin beta.coinBits → Bool)
    (st next : State) (x : Bytes)
    (ha : aCost beta A ac h coins st≤AdversaryMachine.cost beta (aCode beta A ac))
    (hs : stateBits st≤SamplerMachine.stateCap beta) (hn : stateBits next≤SamplerMachine.stateCap beta)
    (ht : st.table.table.length≤beta.qs+beta.qh+1) (hg : Good cs.val st) (hx : x.length≤beta.bytes)
    (hf : (commandBits (.hash x)).length≤AdversaryMachine.outputCap beta) :
    held (staticBits beta (aCode beta A ac) (sCode beta S sc)+stateBits st)
      (plus (aCost beta A ac h coins st) (hashCost cs.val st next x))≤turnBound beta A S ac sc := by
  rcases ha with ⟨hat,haw,haL⟩
  rcases frame_bound beta st next (.hash x) hs hn hf with ⟨hft,hfw,hfL⟩
  rcases hash_public_bound beta cs st x ht hg hx with ⟨hpt,hpw,hpL⟩
  change _≤_ ∧ _≤_ ∧ _≤_
  dsimp only [turnBound,held,plus,hashCost,primitive] at *
  omega

theorem sign_stop_cost (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (coins : Fin beta.coinBits → Bool) (st : State) (m : Bytes) (r : Nonce)
    (ha : aCost beta A ac h coins st≤AdversaryMachine.cost beta (aCode beta A ac))
    (hs : stateBits st≤SamplerMachine.stateCap beta)
    (hn : stateBits (submitted m st)≤SamplerMachine.stateCap beta)
    (ht : st.table.table.length≤beta.qs+beta.qh+1) (hm : m.length≤beta.bytes)
    (hf : (commandBits (.sign m)).length≤AdversaryMachine.outputCap beta) :
    held (staticBits beta (aCode beta A ac) (sCode beta S sc)+stateBits st)
      (plus (aCost beta A ac h coins st) (signBefore st m r))≤turnBound beta A S ac sc := by
  rcases ha with ⟨hat,haw,haL⟩
  rcases frame_bound beta st (submitted m st) (.sign m) hs hn hf with ⟨hft,hfw,hfL⟩
  rcases sign_public_bound beta st m r ht hm with ⟨hpt,hpw,hpL⟩
  change _≤_ ∧ _≤_ ∧ _≤_
  dsimp only [turnBound,held,plus,signBefore,primitive] at *
  omega

theorem sign_go_cost (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (coins : Fin beta.coinBits → Bool) (st : State) (m : Bytes) (r : Nonce)
    (bits : Fin S.bits → Bool) (co : Rq × Option BoxVec)
    (ha : aCost beta A ac h coins st≤AdversaryMachine.cost beta (aCode beta A ac))
    (hs : stateBits st≤SamplerMachine.stateCap beta)
    (hn : stateBits (submitted m st)≤SamplerMachine.stateCap beta)
    (hp : stateBits (MachineExecution.afterSign st m r co)≤SamplerMachine.stateCap beta)
    (ht : st.table.table.length≤beta.qs+beta.qh+1) (hm : m.length≤beta.bytes)
    (hf : (commandBits (.sign m)).length≤AdversaryMachine.outputCap beta) :
    held (staticBits beta (aCode beta A ac) (sCode beta S sc)+stateBits st)
      (plus (plus (aCost beta A ac h coins st) (signBefore st m r))
        (signAfter beta S sc h st m r bits co))≤turnBound beta A S ac sc := by
  rcases ha with ⟨hat,haw,haL⟩
  rcases frame_bound beta st (submitted m st) (.sign m) hs hn hf with ⟨hft,hfw,hfL⟩
  rcases frame_bound beta (submitted m st) (MachineExecution.afterSign st m r co) (.sign m) hn hp hf with
    ⟨hgt,hgw,hgL⟩
  rcases sign_public_bound beta st m r ht hm with ⟨hpt,hpw,hpL⟩
  have hsc : sCost beta S sc h (submitted m st) m r bits≤SamplerMachine.cost beta S (sc.bitCertificate beta S) :=
    sample_resources beta S sc h (submitted m st) m r bits hn hm
  rcases hsc with ⟨hst,hsw,hsL⟩
  change _≤_ ∧ _≤_ ∧ _≤_
  dsimp only [turnBound,held,plus,signBefore,signAfter,primitive] at *
  omega

theorem execution_bound (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (cs : List.Vector Rq (beta.qh+1)) (coins : Fin beta.coinBits → Bool)
    {s q : ℕ} (p : Program s q) : ∀ (st : State) (n fuel : ℕ),
    Shape beta.bytes n st → Good cs.val st → n+s+q≤beta.qs+beta.qh → s+q<fuel →
    AdversaryMachine.At beta A h coins st.events p →
    Dist.All (MeteredExecution.run beta A S ac sc h cs.val coins fuel st) (fun out =>
      out.2≤repeatBound (s+q+1) (turnBound beta A S ac sc) ∧ ValidFinished beta cs.val out.1) := by
  induction p with
  | @done s q f =>
    intro st n fuel hs hg hb hfu hat
    have hh:=AdversaryMachine.at_budget_and_fits beta A h coins (ac.fits h coins) hat
    have ha : aCost beta A ac h coins st≤AdversaryMachine.cost beta (aCode beta A ac) :=
      resume_resources beta A ac h coins st.events (.done f) hat
    have hst:=state_cap beta cs st n hs hg (by omega)
    have hcmd : (commandBits (.done f)).length≤AdversaryMachine.outputCap beta :=
      AdversaryMachine.headBits_length beta (.done f) hh.2.2
    cases fuel with
    | zero => omega
    | succ fuel =>
      rw [MeteredExecution.run,resume_correct beta A ac h coins st.events (.done f) hat]
      apply Dist.all_pure
      exact ⟨cost_trans (done_cost beta A S ac sc h coins st f ha hst hcmd)
        (single_repeat _ (by omega)),shape_mono beta.bytes (by omega) st hs,hg,hh.2.2⟩
  | @hash s q x k ih =>
    intro st n fuel hs hg hb hfu hat
    have hh:=AdversaryMachine.at_budget_and_fits beta A h coins (ac.fits h coins) hat
    have ha : aCost beta A ac h coins st≤AdversaryMachine.cost beta (aCode beta A ac) :=
      resume_resources beta A ac h coins st.events (.hash x k) hat
    have hst:=state_cap beta cs st n hs hg (by omega)
    have ht : st.table.table.length≤beta.qs+beta.qh+1 := hs.1.trans (by omega)
    have hcmd : (commandBits (.hash x)).length≤AdversaryMachine.outputCap beta :=
      AdversaryMachine.headBits_length beta (.hash x k) hh.2.2
    cases fuel with
    | zero => omega
    | succ fuel =>
      rw [MeteredExecution.run,resume_correct beta A ac h coins st.events (.hash x k) hat]
      simp only [head,TableMachine.hash_correct]
      cases hc : hashTargets cs.val x st with
      | none =>
        apply Dist.all_pure
        exact ⟨cost_trans (hash_cost beta A S ac sc h cs coins st st x ha hst hst ht hg hh.2.2.1 hcmd)
          (single_repeat _ (by omega)),trivial⟩
      | some co =>
        have hn:=hash_shape cs.val x st co beta.bytes n hs hh.2.2.1 hc
        have hgood:=(hashTargets_good cs.val x st co hg hc).1
        have hnext:=state_cap beta cs (recordedHash x co.1 co.2) (n+1) hn hgood (by omega)
        have hat' : AdversaryMachine.At beta A h coins (recordedHash x co.1 co.2).events (k co.1) := by
          simpa only [recordedHash,MachineExecution.hash_events cs.val x st co hc] using
            AdversaryMachine.At.hash_step hat co.1
        have hi:=ih co.1 (recordedHash x co.1 co.2) (n+1) fuel hn hgood (by omega) (by omega) hat'
        have hstep:=hash_cost beta A S ac sc h cs coins st (recordedHash x co.1 co.2) x
          ha hst hnext ht hg hh.2.2.1 hcmd
        intro u
        have hv:=hi u
        have he : s+(q+1)+1=(s+q+1)+1 := by omega
        rw [he]
        exact ⟨seq_repeat hstep hv.1,hv.2⟩
  | @sign s q m k ih =>
    intro st n fuel hs hg hb hfu hat
    have hh:=AdversaryMachine.at_budget_and_fits beta A h coins (ac.fits h coins) hat
    have ha : aCost beta A ac h coins st≤AdversaryMachine.cost beta (aCode beta A ac) :=
      resume_resources beta A ac h coins st.events (.sign m k) hat
    have hst:=state_cap beta cs st n hs hg (by omega)
    have hsub:=MachineExecution.submitted_cap beta cs st m n s q hb hs hg hh.2.2.1
    have ht : st.table.table.length≤beta.qs+beta.qh+1 := hs.1.trans (by omega)
    have hcmd : (commandBits (.sign m)).length≤AdversaryMachine.outputCap beta :=
      AdversaryMachine.headBits_length beta (.sign m k) hh.2.2
    cases fuel with
    | zero => omega
    | succ fuel =>
      rw [MeteredExecution.run,resume_correct beta A ac h coins st.events (.sign m k) hat]
      simp only [head,TableMachine.lookup_correct]
      apply Dist.all_bind _ _ (fun _ => True)
      · intro u; trivial
      · intro r _
        cases hm : ROM.lookup (some r,m) (submitted m st).table with
        | some e =>
          apply Dist.all_pure
          exact ⟨cost_trans (sign_stop_cost beta A S ac sc h coins st m r ha hst hsub ht hh.2.2.1 hcmd)
            (single_repeat _ (by omega)),trivial⟩
        | none =>
          apply Dist.all_bind _ _ (fun _ => True)
          · intro u; trivial
          · intro bits _
            rw [sample_correct beta S sc h (submitted m st) m r bits hsub hh.2.2.1]
            let co:=S.code h (submitted m st) m r bits
            have hn:=programmed_shape beta.bytes n st m r co hs hh.2.2.1
            have hgood:=programmed_good cs.val st m r co hg hm
            have hnext:=state_cap beta cs (MachineExecution.afterSign st m r co) (n+1) hn hgood (by omega)
            have hat' : AdversaryMachine.At beta A h coins (MachineExecution.afterSign st m r co).events
                (k (some (r,co.2))) := AdversaryMachine.At.sign_step hat (some (r,co.2))
            have hi:=ih (some (r,co.2)) (MachineExecution.afterSign st m r co) (n+1) fuel hn hgood
              (by omega) (by omega) hat'
            have hstep:=sign_go_cost beta A S ac sc h coins st m r bits co
              ha hst hsub hnext ht hh.2.2.1 hcmd
            intro u
            have hv:=hi u
            have he : (s+1)+q+1=(s+q+1)+1 := by omega
            rw [he]
            exact ⟨seq_repeat hstep hv.1,hv.2⟩

end FT1536.Run2.PrefixResources

#print FT1536.Run2.PrefixResources.execution_bound
#print axioms FT1536.Run2.PrefixResources.execution_bound
