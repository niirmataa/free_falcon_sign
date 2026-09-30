import Run2.LocalBitCode
import Run2.PublicEncoding
import FT1536.BitCost

namespace FT1536.Run2.SamplerMachine
open Games FT1536.Relation StateResources FT1536.BitCost

def stateCap (beta : Budget) : ℕ := stateBound beta.bytes (beta.qs+beta.qh+1) (beta.qh+1)
def inputCap (beta : Budget) (S : Sampler) : ℕ := 24900+stateCap beta+9*beta.bytes+S.bits

/- A certificate about the LOCAL supplied sampler only. Its program is a
finite binary decision program with a fixed evaluator and derived costs;
correctness is equality of the public binary interface, not a global game
bound or a whole-reducer cost assertion. Instantiation remains external. -/
structure Certificate (beta : Budget) (S : Sampler) where
  code : LocalBitCode.Code
  correct : ∀ (h : Rq) (st : State) (m : Bytes) (r : Nonce) (coins : Fin S.bits → Bool),
    stateBits st≤stateCap beta → m.length≤beta.bytes →
    (LocalBitCode.run (PublicEncoding.samplerInput S h st m r coins) code).bits=
      PublicEncoding.samplerOutput (S.code h st m r coins)

/- For a conservative port convention each data bit may occupy a whole
transport byte. Its write and read therefore pay sixteen bit operations.
This is an upper envelope for packed binary ports as well. -/
def actualCost (input : List Bool) (code : LocalBitCode.Code) : Cost :=
  let r:=LocalBitCode.run input code
  let traffic:=input.length+r.bits.length
  ⟨r.steps+16*traffic,LocalBitCode.workspace input code+8*traffic,traffic⟩

def cost (beta : Budget) (S : Sampler) (cert : Certificate beta S) : Cost :=
  ⟨LocalBitCode.timeBound (inputCap beta S) cert.code+16*(inputCap beta S+50689),
   LocalBitCode.spaceBound (inputCap beta S) cert.code+8*(inputCap beta S+50689),
   inputCap beta S+50689⟩

theorem input_length_bound (beta : Budget) (S : Sampler) (h : Rq) (st : State) (m : Bytes)
    (r : Nonce) (coins : Fin S.bits → Bool) (hs : stateBits st≤stateCap beta) (hm : m.length≤beta.bytes) :
    (PublicEncoding.samplerInput S h st m r coins).length ≤ inputCap beta S := by
  have hh:=PublicEncoding.samplerInput_length S h st m r coins
  unfold inputCap
  omega

theorem local_resource_bound (beta : Budget) (S : Sampler) (cert : Certificate beta S)
    (h : Rq) (st : State) (m : Bytes) (r : Nonce) (coins : Fin S.bits → Bool)
    (hs : stateBits st≤stateCap beta) (hm : m.length≤beta.bytes) :
    actualCost (PublicEncoding.samplerInput S h st m r coins) cert.code≤cost beta S cert := by
  let input:=PublicEncoding.samplerInput S h st m r coins
  have hi:=input_length_bound beta S h st m r coins hs hm
  have ho : (LocalBitCode.run input cert.code).bits.length≤50689 := by
    rw [cert.correct h st m r coins hs hm]
    exact PublicEncoding.samplerOutput_length _
  have ht:=(LocalBitCode.run_steps input cert.code).trans (LocalBitCode.timeBound_mono cert.code hi)
  have hw:=(LocalBitCode.workspace_bound input cert.code).trans (LocalBitCode.spaceBound_mono cert.code hi)
  change (LocalBitCode.run input cert.code).steps+16*(input.length+(LocalBitCode.run input cert.code).bits.length)≤
      (cost beta S cert).t ∧
    LocalBitCode.workspace input cert.code+8*(input.length+(LocalBitCode.run input cert.code).bits.length)≤
      (cost beta S cert).w ∧
    input.length+(LocalBitCode.run input cert.code).bits.length≤(cost beta S cert).L
  dsimp only [cost]
  dsimp only [input] at *
  omega

end FT1536.Run2.SamplerMachine
