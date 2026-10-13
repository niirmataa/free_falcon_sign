import ProducerEmit020E6
import WordPatch020E5

namespace FT1536.S05.ProducerBatch020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6 ProducerExpr020E6 ProducerEmit020E6

def cost {regions : Nat} : Expr regions → Nat
  | .literal _ => 1
  | .load _ a => cost a+1
  | .binary _ a b => cost a+cost b+1
  | .select c z n => cost c+cost z+cost n+1

theorem compile_length {regions codeSize : Nat} (e : Expr regions) (base : Nat) (h : base+need e≤64) :
    (compile (codeSize:=codeSize) e base h).length=cost e := by
  induction e generalizing base with
  | literal w => rfl
  | load r a ih =>
    change base+need a≤64 at h
    simp only [compile,List.length_append,List.length_cons,List.length_nil,ih,cost]
  | binary o a b ha hb => simp only [compile,List.length_append,List.length_cons,List.length_nil,ha,hb,cost]
  | select c z n hc hz hn => simp only [compile,List.length_append,List.length_cons,List.length_nil,hc,hz,hn,cost]

theorem one_length {regions codeSize : Nat} (dst : OutputCell) (e : Expr regions) (h : need e≤64) :
    (one (codeSize:=codeSize) dst e h).length=cost e+1 := by
  simp only [one,List.length_append,compile_length,List.length_cons,List.length_nil]

def size {regions : Nat} (f : OutputCell → Expr regions) : Nat := (List.ofFn (fun j => cost (f j)+1)).sum

theorem length {regions codeSize : Nat} (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) :
    (batch (codeSize:=codeSize) f h (List.finRange 96)).length=size f := by
  simp only [batch,List.length_flatMap,one_length,List.finRange,List.map_ofFn,Function.comp_def,size]

theorem fills_patch {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (f : OutputCell → Expr regions) (slots : List OutputCell) (b : Bank Word 96) :
    fills sources f slots b=WordPatch020E5.apply (slots.map (fun j => (j,eval sources (f j)))) b := by
  induction slots generalizing b with
  | nil => rfl
  | cons j js ih => exact ih _

theorem fills_all {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (f : OutputCell → Expr regions) (b : Bank Word 96) :
    fills sources f (List.finRange 96) b=load (fun j => eval sources (f j)) := by
  rw [fills_patch]
  apply WordPatch020E5.realizes
  · intro x hx
    obtain ⟨j,hj,rfl⟩ := List.mem_map.mp hx
    rw [read_load]
  · intro j hj
    exact False.elim (hj (j,eval sources (f j)) (List.mem_map.mpr ⟨j,by simp,rfl⟩) rfl)

theorem full_output {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (f : OutputCell → Expr regions) (h : ∀ j,need (f j)≤64) (q : State codeSize) :
    (executeList sources (batch f h (List.finRange 96)) q).output=load (fun j => eval sources (f j)) :=
  (batch_output sources f h _ q).trans (fills_all sources f q.output)

end FT1536.S05.ProducerBatch020E6
