import Run2.MachineAccounting
import Run2.TableAllocation
import Run2.VerifierAllocation

namespace FT1536.Run2.MeteredExecution
open Games FT1536.Relation PublicSimulation StateResources LocalMachineCode MachineAccounting
open FT1536.BitCost

/- Inside one turn the reference scheduler does not reclaim its scratch
arena: local calls, copies and public routines add their allocations. At a
tail transition it releases that arena; between turns seq takes the peak.
The complete target file, both literal programs and A's coins stay resident. -/
def plus (a b : Cost) : Cost := ⟨a.t+b.t,a.w+b.w,a.L+b.L⟩
def primitive (t w : ℕ) : Cost := ⟨t,w,0⟩
def drawCost (bits : ℕ) : Cost := ⟨5*bits,bits,bits⟩
def staticBits (beta : Budget) (acode scode : LocalBitCode.Code) : ℕ :=
  PeakExecution.publicInputBits (beta.qh+1)+beta.coinBits+
    LocalBitCode.codeBits acode+LocalBitCode.codeBits scode+
    VerifierAllocation.polynomialCode+beta.qs+beta.qh+1+2^20
def held (resident : ℕ) (c : Cost) : Cost := ⟨c.t,resident+c.w,c.L⟩
def frameCost (st next : State) (cmd : Command) : Cost :=
  transport (PublicEncoding.state st++commandBits cmd++PublicEncoding.state next)

def aCode (beta : Budget) (A : ClassicalAdversary beta) (ac : AdversaryCertificate beta A) : LocalBitCode.Code :=
  erase commandBits ac.code
def sCode (beta : Budget) (S : Sampler) (sc : SamplerCertificate beta S) : LocalBitCode.Code :=
  erase PublicEncoding.samplerOutput sc.code
def aCost (beta : Budget) (A : ClassicalAdversary beta) (ac : AdversaryCertificate beta A)
    (h : Rq) (coins : Fin beta.coinBits → Bool) (st : State) : Cost :=
  SamplerMachine.actualCost (AdversaryMachine.input beta h coins st.events) (aCode beta A ac)
def sCost (beta : Budget) (S : Sampler) (sc : SamplerCertificate beta S)
    (h : Rq) (st : State) (m : Bytes) (r : Nonce) (bits : Fin S.bits → Bool) : Cost :=
  SamplerMachine.actualCost (PublicEncoding.samplerInput S h st m r bits) (sCode beta S sc)

def hashCost (cs : List Rq) (st next : State) (x : Bytes) : Cost :=
  plus (frameCost st next (.hash x)) (primitive (TableMachine.hash cs x st).2 (TableAllocation.hash cs x st))
def signBefore (st : State) (m : Bytes) (r : Nonce) : Cost :=
  plus (frameCost st (submitted m st) (.sign m))
    (plus (drawCost 320) (primitive (TableMachine.lookup (some r,m) (submitted m st).table.table).2
      (TableAllocation.lookup (some r,m) (submitted m st).table.table)))
def signAfter (beta : Budget) (S : Sampler) (sc : SamplerCertificate beta S)
    (h : Rq) (st : State) (m : Bytes) (r : Nonce) (bits : Fin S.bits → Bool)
    (co : Rq × Option BoxVec) : Cost :=
  plus (drawCost S.bits) (plus (sCost beta S sc h (submitted m st) m r bits)
    (frameCost (submitted m st) (MachineExecution.afterSign st m r co) (.sign m)))

noncomputable def prepend (c : Cost) (p : Dist (Option Finished × Cost)) : Dist (Option Finished × Cost) :=
  p.map fun out => (out.1,seq c out.2)

noncomputable def run (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (cs : List Rq) (coins : Fin beta.coinBits → Bool) : ℕ → State → Dist (Option Finished × Cost)
  | 0,_ => Dist.pure (none,⟨0,0,0⟩)
  | fuel+1,st =>
      let a:=aCost beta A ac h coins st
      let resident:=staticBits beta (aCode beta A ac) (sCode beta S sc)+stateBits st
      match resume beta A ac h coins st.events with
      | .done f => Dist.pure (some ⟨f,st⟩,held resident (plus a (frameCost st st (.done f))))
      | .hash x =>
          match (TableMachine.hash cs x st).1 with
          | none => Dist.pure (none,held resident (plus a (hashCost cs st st x)))
          | some co =>
              let next:=recordedHash x co.1 co.2
              prepend (held resident (plus a (hashCost cs st next x)))
                (run beta A S ac sc h cs coins fuel next)
      | .sign m =>
          ((Dist.draw (Law.uniform : Law (Fin 320 → Bool))).map NonceBits.nonceEquiv).bind fun r =>
            let before:=plus a (signBefore st m r)
            match (TableMachine.lookup (some r,m) (submitted m st).table.table).1 with
            | some _ => Dist.pure (none,held resident before)
            | none => (Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun bits =>
                let co:=LocalMachineCode.sample beta S sc h (submitted m st) m r bits
                prepend (held resident (plus before (signAfter beta S sc h st m r bits co)))
                  (run beta A S ac sc h cs coins fuel (MachineExecution.afterSign st m r co))

theorem erasure (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (cs : List Rq) (coins : Fin beta.coinBits → Bool) (fuel : ℕ) : ∀ st,
    Dist.Same ((run beta A S ac sc h cs coins fuel st).map Prod.fst)
      (MachineExecution.run beta A S ac sc h cs coins fuel st) := by
  induction fuel with
  | zero => intro st F; simp only [run,MachineExecution.run,Dist.expect_map,Dist.expect_pure]
  | succ fuel ih =>
    intro st F
    simp only [run,MachineExecution.run]
    cases ha : resume beta A ac h coins st.events with
    | done f => simp only [Dist.expect_map,Dist.expect_pure]
    | hash x =>
      cases hc : (TableMachine.hash cs x st).1 with
      | none => simp only [hc,Dist.expect_map,Dist.expect_pure]
      | some co => simpa only [hc,prepend,Dist.expect_map] using ih (recordedHash x co.1 co.2) F
    | sign m =>
      simp only [Dist.expect_map,Dist.expect_bind]
      apply Dist.expect_congr
      intro bits320
      generalize NonceBits.nonceEquiv bits320 = r
      cases hc : (TableMachine.lookup (some r,m) (submitted m st).table.table).1 with
      | some e => simp only [Dist.expect_pure]
      | none =>
        simp only [Dist.expect_bind]
        apply Dist.expect_congr
        intro bits
        simpa only [prepend,Dist.expect_map] using
          ih (MachineExecution.afterSign st m r (LocalMachineCode.sample beta S sc h (submitted m st) m r bits)) F

def frameBound (beta : Budget) : Cost :=
  let bits:=2*SamplerMachine.stateCap beta+AdversaryMachine.outputCap beta
  ⟨16*bits+1,16*bits,bits⟩
def publicBound (beta : Budget) : Cost :=
  let t:=MachineAccounting.hashBound beta.bytes (beta.qs+beta.qh+1) (beta.qh+1)+
    MachineAccounting.lookupBound beta.bytes (beta.qs+beta.qh+1)
  ⟨t,32*t,0⟩
def turnBound (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S) : Cost :=
  held (staticBits beta (aCode beta A ac) (sCode beta S sc)+SamplerMachine.stateCap beta)
    (plus (AdversaryMachine.cost beta (aCode beta A ac))
      (plus (SamplerMachine.cost beta S (sc.bitCertificate beta S))
        (plus (frameBound beta) (plus (frameBound beta)
          (plus (publicBound beta) (plus (drawCost 320) (drawCost S.bits)))))))

theorem plus_mono {a b c d : Cost} (h : a≤c) (k : b≤d) : plus a b≤plus c d :=
  ⟨Nat.add_le_add h.1 k.1,Nat.add_le_add h.2.1 k.2.1,Nat.add_le_add h.2.2 k.2.2⟩
theorem held_mono {a b : Cost} {n N : ℕ} (h : a≤b) (hn : n≤N) : held n a≤held N b :=
  ⟨h.1,Nat.add_le_add hn h.2.1,h.2.2⟩

theorem frame_bound (beta : Budget) (st next : State) (cmd : Command)
    (hs : stateBits st≤SamplerMachine.stateCap beta)
    (hn : stateBits next≤SamplerMachine.stateCap beta)
    (hc : (commandBits cmd).length≤AdversaryMachine.outputCap beta) : frameCost st next cmd≤frameBound beta := by
  have hs':=PublicEncoding.state_length st
  have hn':=PublicEncoding.state_length next
  have hl : (PublicEncoding.state st++commandBits cmd++PublicEncoding.state next).length≤
      2*SamplerMachine.stateCap beta+AdversaryMachine.outputCap beta := by
    simp only [List.length_append]; omega
  rw [frameCost,transport_exact]
  change 16*_+1≤16*_+1 ∧ 16*_≤16*_ ∧ _≤_
  exact ⟨by omega,by omega,hl⟩

theorem state_cap (beta : Budget) (cs : List.Vector Rq (beta.qh+1)) (st : State) (n : ℕ)
    (hs : Shape beta.bytes n st) (hg : Good cs.val st) (hn : n≤beta.qs+beta.qh+1) :
    stateBits st≤SamplerMachine.stateCap beta := by
  have hh:=stateBits_bound beta.bytes n cs.val st hs hg
  rw [cs.property] at hh
  exact hh.trans (stateBound_mono beta.bytes (beta.qh+1) hn)

theorem hash_public_bound (beta : Budget) (cs : List.Vector Rq (beta.qh+1)) (st : State) (x : Bytes)
    (hs : st.table.table.length≤beta.qs+beta.qh+1) (hg : Good cs.val st) (hx : x.length≤beta.bytes) :
    primitive (TableMachine.hash cs.val x st).2 (TableAllocation.hash cs.val x st)≤publicBound beta := by
  have hu : st.table.used≤beta.qh+1 := by simpa only [cs.property] using hg.2.2
  have ht:=MachineAccounting.hash_bound beta.bytes (beta.qs+beta.qh+1) (beta.qh+1) cs.val x st hs hu hx
  have hw:=(TableAllocation.hash_bound cs.val x st).trans (Nat.mul_le_mul_left 32 ht)
  change _≤_+_ ∧ _≤32*(_+_) ∧ 0≤0
  dsimp only [primitive]
  exact ⟨by omega,by omega,le_rfl⟩

theorem sign_public_bound (beta : Budget) (st : State) (m : Bytes) (r : Nonce)
    (hs : st.table.table.length≤beta.qs+beta.qh+1) (hm : m.length≤beta.bytes) :
    primitive (TableMachine.lookup (some r,m) (submitted m st).table.table).2
      (TableAllocation.lookup (some r,m) (submitted m st).table.table)≤publicBound beta := by
  have ht:=MachineAccounting.lookup_bound beta.bytes (beta.qs+beta.qh+1) (some r,m) st hs hm
  have hw:=(TableAllocation.lookup_bound (some r,m) st.table.table).trans (Nat.mul_le_mul_left 32 ht)
  change _≤_+_ ∧ _≤32*(_+_) ∧ 0≤0
  dsimp only [primitive,submitted,ROM.submit]
  exact ⟨by omega,by omega,le_rfl⟩

end FT1536.Run2.MeteredExecution

#print FT1536.Run2.MeteredExecution.erasure
#print axioms FT1536.Run2.MeteredExecution.erasure
#print axioms FT1536.Run2.MeteredExecution.frame_bound
