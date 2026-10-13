import ProducerProgram020E6

namespace FT1536.S05.ProducerComposition020E6
open WordRAM020 ArrayBank020E4 ProducerExpr020E6

def oneSource (w : Bank Word 96) : ProducerMachine020E6.Sources (fun _ : Fin 1 => 96) := fun _ => w

@[noinline] def run {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent)
    (f : ProducerMachine020E6.OutputCell → Expr regions) (hf : ∀ j,need (f j)≤64)
    (g : ProducerMachine020E6.OutputCell → Expr 1) (hg : ∀ j,need (g j)≤64) : Bank Word 96 :=
  let first := ProducerProgram020E6.run sources f hf
  (ProducerProgram020E6.run (oneSource first.output) g hg).output

def value {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent)
    (f : ProducerMachine020E6.OutputCell → Expr regions) (g : ProducerMachine020E6.OutputCell → Expr 1) : Bank Word 96 :=
  load (fun j => eval (oneSource (load (fun i => eval sources (f i)))) (g j))

theorem correct {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent)
    (f : ProducerMachine020E6.OutputCell → Expr regions) (hf : ∀ j,need (f j)≤64)
    (g : ProducerMachine020E6.OutputCell → Expr 1) (hg : ∀ j,need (g j)≤64) :
    run sources f hf g hg=value sources f g := by
  unfold run
  dsimp only
  rw [ProducerProgram020E6.output,ProducerProgram020E6.output]
  rfl

end FT1536.S05.ProducerComposition020E6
