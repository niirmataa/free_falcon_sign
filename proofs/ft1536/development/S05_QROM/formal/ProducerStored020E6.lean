import ProducerNumbers020E6
import ProducerPipeline020E6

namespace FT1536.S05.ProducerStored020E6
open WordRAM020 ArrayBank020E4 ProducerExpr020E6

/-- Stored code is an explicit input of the operational invocation.
    Neither expression compilation nor code-array construction is executed
    inside this function. -/
def invoke {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent)
    (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize) : ProducerFetch020E6.State regions codeSize :=
  ProducerFetch020E6.run sources code codeSize (ProducerFetch020E6.start (ProducerMachine020E6.initial codeSize))

theorem expression_output {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent)
    (f : ProducerMachine020E6.OutputCell → Expr regions) (hf : ∀ j,need (f j)≤64) :
    (invoke sources (ProducerProgram020E6.code f hf)).vm.output=load (fun j => eval sources (f j)) := by
  unfold invoke
  rw [ProducerFetch020E6.refines _ _ _ _ (by rfl)]
  exact ProducerProgram020E6.output sources f hf

/-- Both images are public, fixed preparation artifacts. Their full encoded
    lengths are counted in ProducerNumbers/ProducerMemory. -/
def windowCode := ProducerProgram020E6.code ProducerWindow020E6.cells ProducerWindow020E6.workspace
def slotCode := ProducerProgram020E6.code ProducerCoreSlots020E6.cells ProducerCoreSlots020E6.workspace

def pairRun {regions firstSize secondSize : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent)
    (firstCode : Bank (ProducerMachine020E6.Instruction regions firstSize) firstSize)
    (secondCode : Bank (ProducerMachine020E6.Instruction 1 secondSize) secondSize) : Bank Word 96 :=
  let first := invoke sources firstCode
  (invoke (ProducerComposition020E6.oneSource first.vm.output) secondCode).vm.output

theorem pair_output {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent)
    (f : ProducerMachine020E6.OutputCell → Expr regions) (hf : ∀ j,need (f j)≤64)
    (g : ProducerMachine020E6.OutputCell → Expr 1) (hg : ∀ j,need (g j)≤64) :
    pairRun sources (ProducerProgram020E6.code f hf) (ProducerProgram020E6.code g hg)=
      ProducerComposition020E6.value sources f g := by
  unfold pairRun
  dsimp only
  rw [expression_output,expression_output]
  rfl

def run (d : BoundaryPayload020E5.Data) (fresh : Bool) : Bank Word 96 :=
  pairRun (ProducerCoreView020E6.sources d fresh) windowCode slotCode

theorem run_words (d : BoundaryPayload020E5.Data) (fresh : Bool) : run d fresh=ProducerPipeline020E6.words d fresh :=
  pair_output (ProducerCoreView020E6.sources d fresh) ProducerWindow020E6.cells ProducerWindow020E6.workspace
    ProducerCoreSlots020E6.cells ProducerCoreSlots020E6.workspace

end FT1536.S05.ProducerStored020E6
