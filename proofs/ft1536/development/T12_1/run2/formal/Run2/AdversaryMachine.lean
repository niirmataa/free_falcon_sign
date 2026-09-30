import Run2.SamplerMachine

namespace FT1536.Run2.AdversaryMachine
open Games FT1536.Relation StateResources ProgramResources FT1536.BitCost

/- A local resume is fed only the ordinary observable event history. It
does not see the reducer's table, target labels or an extra c with Sign. -/
inductive At (beta : Budget) (A : ClassicalAdversary beta) (h : Rq)
    (coins : Fin beta.coinBits → Bool) : {s q : ℕ} → List Event → Program s q → Prop
  | initial : At beta A h coins [] (A.code h coins)
  | hash_step {s q} {hist : List Event} {x : Bytes} {k : Rq → Program s q} :
      At beta A h coins hist (.hash x k) → (c : Rq) →
      At beta A h coins (Event.hash x c::hist) (k c)
  | sign_step {s q} {hist : List Event} {m : Bytes} {k : Reply → Program s q} :
      At beta A h coins hist (.sign m k) → (o : Reply) →
      At beta A h coins (Event.sign m o::hist) (k o)

def headBits : {s q : ℕ} → Program s q → List Bool
  | _,_,.done f => [true,true]++PublicEncoding.bytes f.message++PublicEncoding.bytes f.nonce++
      PublicEncoding.signature f.signature
  | _,_,.hash x _ => false::PublicEncoding.bytes x
  | _,_,.sign m _ => [true,false]++PublicEncoding.bytes m

def input (beta : Budget) (h : Rq) (coins : Fin beta.coinBits → Bool) (hist : List Event) : List Bool :=
  PublicEncoding.field h++List.ofFn coins++PublicEncoding.sequence PublicEncoding.event hist

def ViewFits (beta : Budget) (hist : List Event) : Prop :=
  hist.length≤beta.qs+beta.qh ∧ ∀ e∈hist,(eventMessage e).length≤beta.bytes

def inputCap (beta : Budget) : ℕ := 24577+beta.coinBits+(beta.qs+beta.qh)*(9*beta.bytes+26440)
def outputCap (beta : Budget) : ℕ := 9*beta.bytes+26120

theorem at_budget_and_fits (beta : Budget) (A : ClassicalAdversary beta) (h : Rq)
    (coins : Fin beta.coinBits → Bool) (ha : Fits beta.bytes (A.code h coins))
    {s q : ℕ} {hist : List Event} {p : Program s q} (hp : At beta A h coins hist p) :
    hist.length+s+q≤beta.qs+beta.qh ∧
      (∀ e∈hist,(eventMessage e).length≤beta.bytes) ∧ Fits beta.bytes p := by
  induction hp with
  | initial => exact ⟨by simp,by simp,ha⟩
  | hash_step hp c ih =>
    rcases ih with ⟨hc,hh,hfit⟩
    refine ⟨?_,?_,hfit.2 c⟩
    · simp only [List.length_cons]; omega
    · simpa only [List.forall_mem_cons,eventMessage] using And.intro hfit.1 hh
  | sign_step hp o ih =>
    rcases ih with ⟨hc,hh,hfit⟩
    refine ⟨?_,?_,hfit.2 o⟩
    · simp only [List.length_cons]; omega
    · simpa only [List.forall_mem_cons,eventMessage] using And.intro hfit.1 hh

theorem input_length_bound (beta : Budget) (h : Rq) (coins : Fin beta.coinBits → Bool)
    (hist : List Event) (hv : ViewFits beta hist) : (input beta h coins hist).length ≤ inputCap beta := by
  have he:=PublicEncoding.sequence_bound PublicEncoding.event hist eventBits
    (fun e _ => PublicEncoding.event_length e)
  have hs:=sum_map_bound hist eventBits (9*beta.bytes+26440) (by
    intro e hm
    have hh:=hv.2 e hm
    cases e <;> simp only [eventBits,eventMessage] at * <;> omega)
  have hc:=Nat.mul_le_mul_right (9*beta.bytes+26440) hv.1
  simp only [input,inputCap,List.length_append,PublicEncoding.field_length,List.length_ofFn]
  omega

theorem headBits_length (beta : Budget) {s q : ℕ} (p : Program s q) (hf : Fits beta.bytes p) :
    (headBits p).length≤outputCap beta := by
  cases p with
  | done f =>
    change f.message.length+f.nonce.length≤beta.bytes at hf
    simp only [headBits,List.length_append,List.length_cons,List.length_nil,
      PublicEncoding.bytes_length,PublicEncoding.signature_length,outputCap]
    omega
  | hash x k =>
    have hh:=hf.1
    simp only [headBits,List.length_cons,PublicEncoding.bytes_length,outputCap]
    omega
  | sign m k =>
    have hh:=hf.1
    simp only [headBits,List.length_append,List.length_cons,List.length_nil,PublicEncoding.bytes_length,outputCap]
    omega

def cost (beta : Budget) (code : LocalBitCode.Code) : Cost :=
  ⟨LocalBitCode.timeBound (inputCap beta) code+16*(inputCap beta+outputCap beta),
   LocalBitCode.spaceBound (inputCap beta) code+8*(inputCap beta+outputCap beta),
   inputCap beta+outputCap beta⟩

structure Certificate (beta : Budget) (A : ClassicalAdversary beta) where
  code : LocalBitCode.Code
  fits : ∀ h coins,Fits beta.bytes (A.code h coins)
  correct : ∀ (h : Rq) (coins : Fin beta.coinBits → Bool) {s q : ℕ}
    (hist : List Event) (p : Program s q), At beta A h coins hist p →
      (LocalBitCode.run (input beta h coins hist) code).bits=headBits p

theorem local_resource_bound (beta : Budget) (A : ClassicalAdversary beta) (cert : Certificate beta A)
    (h : Rq) (coins : Fin beta.coinBits → Bool) {s q : ℕ} (hist : List Event) (p : Program s q)
    (hat : At beta A h coins hist p) :
    SamplerMachine.actualCost (input beta h coins hist) cert.code≤cost beta cert.code := by
  have hh:=at_budget_and_fits beta A h coins (cert.fits h coins) hat
  have hv : ViewFits beta hist := ⟨by have hbudget:=hh.1; omega,hh.2.1⟩
  have hi:=input_length_bound beta h coins hist hv
  have ho : (LocalBitCode.run (input beta h coins hist) cert.code).bits.length≤outputCap beta := by
    rw [cert.correct h coins hist p hat]
    exact headBits_length beta p hh.2.2
  have ht:=(LocalBitCode.run_steps (input beta h coins hist) cert.code).trans
    (LocalBitCode.timeBound_mono cert.code hi)
  have hw:=(LocalBitCode.workspace_bound (input beta h coins hist) cert.code).trans
    (LocalBitCode.spaceBound_mono cert.code hi)
  change (LocalBitCode.run (input beta h coins hist) cert.code).steps+
      16*((input beta h coins hist).length+(LocalBitCode.run (input beta h coins hist) cert.code).bits.length)≤
      (cost beta cert.code).t ∧
    LocalBitCode.workspace (input beta h coins hist) cert.code+
      8*((input beta h coins hist).length+(LocalBitCode.run (input beta h coins hist) cert.code).bits.length)≤
      (cost beta cert.code).w ∧
    (input beta h coins hist).length+(LocalBitCode.run (input beta h coins hist) cert.code).bits.length≤
      (cost beta cert.code).L
  dsimp only [cost]
  omega

end FT1536.Run2.AdversaryMachine
