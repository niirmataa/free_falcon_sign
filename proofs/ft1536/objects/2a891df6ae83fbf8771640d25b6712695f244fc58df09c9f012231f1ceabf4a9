import Run2.AdversaryMachine

/- Project: Niirmata. The inherited Falcon Project / Thomas Pornin
attribution and licences remain in the pinned input closure.

Typed literal leaves are a semantic view of statically encoded output files.
There is no function-call instruction: the only instruction besides emitting
a literal is reading an addressed input bit. Erasure is the existing bit
interpreter, including its code scans and full literal copying charge. -/
namespace FT1536.Run2.LocalMachineCode
open Games FT1536.Relation PublicSimulation

inductive Code (α : Type) where
  | output : α → Code α
  | read : ℕ → Code α → Code α → Code α

def erase {α : Type} (encode : α → List Bool) : Code α → LocalBitCode.Code
  | .output a => .output (encode a)
  | .read n no yes => .read n (erase encode no) (erase encode yes)

def run {α : Type} (input : List Bool) : Code α → α
  | .output a => a
  | .read n no yes =>
      if (LocalBitCode.probe input n).1 then run input yes else run input no

theorem erasure {α : Type} (encode : α → List Bool) (input : List Bool) (code : Code α) :
    (LocalBitCode.run input (erase encode code)).bits = encode (run input code) := by
  induction code with
  | output a => rfl
  | read n no yes hn hy =>
    simp only [erase,LocalBitCode.run,run]
    split <;> assumption

inductive Command where
  | done : Forgery → Command
  | hash : Bytes → Command
  | sign : Bytes → Command

def commandBits : Command → List Bool
  | .done f => [true,true]++PublicEncoding.bytes f.message++PublicEncoding.bytes f.nonce++
      PublicEncoding.signature f.signature
  | .hash x => false::PublicEncoding.bytes x
  | .sign m => [true,false]++PublicEncoding.bytes m

def head : {s q : ℕ} → Program s q → Command
  | _,_,.done f => .done f
  | _,_,.hash x _ => .hash x
  | _,_,.sign m _ => .sign m

theorem head_encoding {s q : ℕ} (p : Program s q) :
    commandBits (head p)=AdversaryMachine.headBits p := by
  cases p <;> rfl

structure AdversaryCertificate (beta : Budget) (A : ClassicalAdversary beta) where
  code : Code Command
  fits : ∀ h coins,ProgramResources.Fits beta.bytes (A.code h coins)
  correct : ∀ (h : Rq) (coins : Fin beta.coinBits → Bool) {s q : ℕ}
    (hist : List Event) (p : Program s q), AdversaryMachine.At beta A h coins hist p →
      run (AdversaryMachine.input beta h coins hist) code=head p

def AdversaryCertificate.bitCertificate (beta : Budget) (A : ClassicalAdversary beta)
    (cert : AdversaryCertificate beta A) : AdversaryMachine.Certificate beta A where
  code := erase commandBits cert.code
  fits := cert.fits
  correct := by
    intro h coins s q hist p hat
    rw [erasure,cert.correct h coins hist p hat,head_encoding]

structure SamplerCertificate (beta : Budget) (S : Sampler) where
  code : Code (Rq × Option BoxVec)
  correct : ∀ (h : Rq) (st : State) (m : Bytes) (r : Nonce) (coins : Fin S.bits → Bool),
    StateResources.stateBits st≤SamplerMachine.stateCap beta → m.length≤beta.bytes →
      run (PublicEncoding.samplerInput S h st m r coins) code=S.code h st m r coins

def SamplerCertificate.bitCertificate (beta : Budget) (S : Sampler)
    (cert : SamplerCertificate beta S) : SamplerMachine.Certificate beta S where
  code := erase PublicEncoding.samplerOutput cert.code
  correct h st m r coins hs hm := by
    rw [erasure,cert.correct h st m r coins hs hm]

def resume (beta : Budget) (A : ClassicalAdversary beta)
    (cert : AdversaryCertificate beta A) (h : Rq) (coins : Fin beta.coinBits → Bool)
    (hist : List Event) : Command :=
  run (AdversaryMachine.input beta h coins hist) cert.code

def sample (beta : Budget) (S : Sampler) (cert : SamplerCertificate beta S)
    (h : Rq) (st : State) (m : Bytes) (r : Nonce) (coins : Fin S.bits → Bool) :
    Rq × Option BoxVec :=
  run (PublicEncoding.samplerInput S h st m r coins) cert.code

theorem resume_correct (beta : Budget) (A : ClassicalAdversary beta)
    (cert : AdversaryCertificate beta A) (h : Rq) (coins : Fin beta.coinBits → Bool)
    {s q : ℕ} (hist : List Event) (p : Program s q)
    (hat : AdversaryMachine.At beta A h coins hist p) :
    resume beta A cert h coins hist=head p := cert.correct h coins hist p hat

theorem sample_correct (beta : Budget) (S : Sampler) (cert : SamplerCertificate beta S)
    (h : Rq) (st : State) (m : Bytes) (r : Nonce) (coins : Fin S.bits → Bool)
    (hs : StateResources.stateBits st≤SamplerMachine.stateCap beta) (hm : m.length≤beta.bytes) :
    sample beta S cert h st m r coins=S.code h st m r coins :=
  cert.correct h st m r coins hs hm

theorem resume_resources (beta : Budget) (A : ClassicalAdversary beta)
    (cert : AdversaryCertificate beta A) (h : Rq) (coins : Fin beta.coinBits → Bool)
    {s q : ℕ} (hist : List Event) (p : Program s q)
    (hat : AdversaryMachine.At beta A h coins hist p) :
    SamplerMachine.actualCost (AdversaryMachine.input beta h coins hist)
      (erase commandBits cert.code)≤AdversaryMachine.cost beta (erase commandBits cert.code) :=
  AdversaryMachine.local_resource_bound beta A (cert.bitCertificate beta A) h coins hist p hat

theorem sample_resources (beta : Budget) (S : Sampler) (cert : SamplerCertificate beta S)
    (h : Rq) (st : State) (m : Bytes) (r : Nonce) (coins : Fin S.bits → Bool)
    (hs : StateResources.stateBits st≤SamplerMachine.stateCap beta) (hm : m.length≤beta.bytes) :
    SamplerMachine.actualCost (PublicEncoding.samplerInput S h st m r coins)
      (erase PublicEncoding.samplerOutput cert.code)≤SamplerMachine.cost beta S (cert.bitCertificate beta S) :=
  SamplerMachine.local_resource_bound beta S (cert.bitCertificate beta S) h st m r coins hs hm

end FT1536.Run2.LocalMachineCode

#print FT1536.Run2.LocalMachineCode.AdversaryCertificate
#print FT1536.Run2.LocalMachineCode.SamplerCertificate
#print FT1536.Run2.LocalMachineCode.erasure
#print axioms FT1536.Run2.LocalMachineCode.erasure
#print axioms FT1536.Run2.LocalMachineCode.resume_resources
#print axioms FT1536.Run2.LocalMachineCode.sample_resources
