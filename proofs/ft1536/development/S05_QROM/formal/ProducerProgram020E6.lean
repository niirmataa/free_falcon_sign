import ProducerExecution020E6

namespace FT1536.S05.ProducerProgram020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6 ProducerExpr020E6

def listCode {regions : Nat} (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) :
    List (Instruction regions (ProducerBatch020E6.size f)) := ProducerEmit020E6.batch f h (List.finRange 96)

def code {regions : Nat} (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) :
    Bank (Instruction regions (ProducerBatch020E6.size f)) (ProducerBatch020E6.size f) :=
  ⟨(listCode f h).toArray,by rw [List.size_toArray];exact ProducerBatch020E6.length f h⟩

theorem code_read {regions : Nat} (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) :
    List.ofFn (read (code f h))=listCode f h := by
  apply List.ext_getElem
  · rw [List.length_ofFn];exact (ProducerBatch020E6.length f h).symm
  · intro j hj hj'
    simp only [List.getElem_ofFn,ArrayBank020E4.read,code,List.getElem_toArray]

theorem initial_pc (codeSize : Nat) : (initial codeSize).pc.val=0 := rfl

def run {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) : State (ProducerBatch020E6.size f) :=
  ProducerMachine020E6.run sources (code f h) (ProducerBatch020E6.size f) (initial (ProducerBatch020E6.size f))

theorem output {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) :
    (run sources f h).output=load (fun j => eval sources (f j)) := by
  unfold run
  rw [ProducerExecution020E6.executes _ _ _ (initial_pc _),code_read]
  exact ProducerBatch020E6.full_output sources f h _

theorem done {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) :
    (run sources f h).pc.val=ProducerBatch020E6.size f := by
  unfold run
  exact ProducerExecution020E6.done sources (code f h) (ProducerBatch020E6.size f)
    (initial (ProducerBatch020E6.size f)) (by rw [initial_pc];omega)

end FT1536.S05.ProducerProgram020E6
