import PairProgram020
import InputLayout020
import PairEncoding020

namespace FT1536.S05.RefinementTarget020
open WordRAM020 FT1536.Relation JointInterface019

/-- Exact target left OPEN at checkpoint020. No axiom, instance, certificate
    constructor or theorem here: only the missing proposition. A proof must
    handle every tape and actual tables; finite diagnostics do not fill it. -/
def EveryTape : Prop := ∀ (h : Rq) (t : Bits 24662538240),
  let s := (run (InputLayout020.encode h t) PairProgram020.program initial).1
  s.fault = false ∧
    List.ofFn s.out = PairEncoding020.encode ((StandaloneRuntime019.publicCode h).code t)

/-- Future resource driver: source of input bits, image loading, caller
    transfer and an implementation of code/control/expression storage.
    No predicate named CompleteResourceCertificate is instantiated in020. -/
def PublicInitial (h : Rq) (t : Bits 24662538240) : Input × State :=
  (InputLayout020.encode h t,initial)

theorem public_initial_no_fault (h : Rq) (t : Bits 24662538240) :
    (PublicInitial h t).2.fault = false := rfl

end FT1536.S05.RefinementTarget020
